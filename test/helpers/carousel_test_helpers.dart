// Shared fixtures for the carousel test suite, split across
// `carousel_test.dart` (layout) and `carousel_interaction_test.dart`
// (tap/scroll/keyboard/onChange interaction).
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

/// Asserts [picture] fills [card] (within 1px) on both edges, for the given
/// fixture [width] and item [index] (used in the failure reason).
void expectImageWithinCard(Rect picture, Rect card, double width, int index) {
  expect(
    picture.left,
    lessThanOrEqualTo(card.left + 1),
    reason: 'w=$width item $index left image $picture card $card',
  );
  expect(
    picture.right,
    greaterThanOrEqualTo(card.right - 1),
    reason: 'w=$width item $index right image $picture card $card',
  );
}

/// Wraps [child] in a 400x200 host with a fixed `Directionality`/`MediaQuery`.
Widget hostCarousel(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Center(child: SizedBox(width: 400, height: 200, child: child)),
    ),
  );
}

/// No-op tap handler shared by fixture items.
void enableCarouselItem() {}

/// Builds [count] simple carousel items keyed by index.
List<M3ECarouselItem> carouselItems(int count) {
  return <M3ECarouselItem>[
    for (int i = 0; i < count; i++)
      M3ECarouselItem(
        onTap: enableCarouselItem,
        image: ColoredBox(
          key: ValueKey<int>(i),
          color: const Color(0xFF112233),
          child: Center(child: Text('item$i')),
        ),
      ),
  ];
}

/// Hosts [child] at a caller-chosen width inside a large viewport, so a
/// carousel can settle without being constrained by the outer test window.
class CarouselSettleHost extends StatelessWidget {
  const CarouselSettleHost({
    super.key,
    required this.width,
    required this.child,
  });

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(size: Size(1200, 800)),
        child: Center(
          child: SizedBox(width: width, height: 200, child: child),
        ),
      ),
    );
  }
}

/// Hosts a 3-item full-screen carousel in an 800x800 viewport, keyed 0-2.
Widget fullScreenCarouselHost() {
  return const Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: MediaQueryData(size: Size(800, 800)),
      child: Center(
        child: SizedBox(
          width: 220,
          height: 360,
          child: M3ECarousel(
            type: M3ECarouselType.fullScreen,
            children: <M3ECarouselItem>[
              M3ECarouselItem(
                onTap: enableCarouselItem,
                image: ColoredBox(
                  key: ValueKey<int>(0),
                  color: Color(0xFF112233),
                ),
              ),
              M3ECarouselItem(
                onTap: enableCarouselItem,
                image: ColoredBox(
                  key: ValueKey<int>(1),
                  color: Color(0xFF223344),
                ),
              ),
              M3ECarouselItem(
                onTap: enableCarouselItem,
                image: ColoredBox(
                  key: ValueKey<int>(2),
                  color: Color(0xFF334455),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// A material's horizontal span, used to score candidate leading/trailing
/// items without re-deriving the same geometry checks inline.
class MaterialSpan {
  const MaterialSpan(this.left, this.width);
  final double left;
  final double width;
}

MaterialSpan? _leadingMaterialSpan(Element element, Rect carousel) {
  final box = element.renderObject! as RenderBox;
  if (!box.hasSize || box.size.width < 1 || box.size.height < 20) {
    return null;
  }
  final Offset origin = box.localToGlobal(Offset.zero);
  final double right = origin.dx + box.size.width;
  if (right < carousel.left + 4 || origin.dx > carousel.right - 4) {
    return null;
  }
  return MaterialSpan(origin.dx, box.size.width);
}

/// Width of the left-most `Material` fully within the carousel's bounds, or
/// `null` when none qualifies.
double? leadingMaterialWidth(WidgetTester tester) {
  final Rect carousel = tester.getRect(find.byType(M3ECarousel));
  double? leadingWidth;
  double leadingLeft = double.infinity;
  for (final Element element in find.byType(Material).evaluate()) {
    final MaterialSpan? span = _leadingMaterialSpan(element, carousel);
    if (span == null) {
      continue;
    }
    if (span.left < leadingLeft) {
      leadingLeft = span.left;
      leadingWidth = span.width;
    }
  }
  return leadingWidth;
}

MaterialSpan? _trailingMaterialSpan(Element element, Rect carousel) {
  final box = element.renderObject! as RenderBox;
  if (!box.hasSize || box.size.height < 20 || box.size.width < 20) {
    return null;
  }
  final Offset origin = box.localToGlobal(Offset.zero);
  final double right = origin.dx + box.size.width;
  if (right <= carousel.left + 4 || origin.dx >= carousel.right + 4) {
    return null;
  }
  return MaterialSpan(origin.dx, box.size.width);
}

/// Right edge of the right-most `Material` within the carousel's bounds.
double trailingMaterialEdge(WidgetTester tester) {
  final Rect carousel = tester.getRect(find.byType(M3ECarousel));
  double rightEdge = carousel.left;
  for (final Element element in find.byType(Material).evaluate()) {
    final MaterialSpan? span = _trailingMaterialSpan(element, carousel);
    if (span == null) {
      continue;
    }
    final double right = span.left + span.width;
    if (right > rightEdge) {
      rightEdge = right;
    }
  }
  return rightEdge;
}

/// This element's horizontal span when it's a sized `Material` overlapping
/// [carousel]'s bounds with no tolerance, or `null` when it's disqualified.
MaterialSpan? _exactOverlapSpan(Element element, Rect carousel) {
  final box = element.renderObject! as RenderBox;
  if (!box.hasSize || box.size.height < 20 || box.size.width < 20) {
    return null;
  }
  final Offset origin = box.localToGlobal(Offset.zero);
  final double right = origin.dx + box.size.width;
  if (right <= carousel.left || origin.dx >= carousel.right) {
    return null;
  }
  return MaterialSpan(origin.dx, box.size.width);
}

/// Right edge of the right-most sized `Material` whose span overlaps
/// [carousel]'s bounds, starting from `carousel.left` when none qualify.
///
/// Unlike [trailingMaterialEdge], this uses no edge tolerance — callers that
/// need the exact overlap boundary (rather than a few px of slack) use this.
double rightmostMaterialEdgeWithin(Rect carousel) {
  double rightEdge = carousel.left;
  for (final Element element in find.byType(Material).evaluate()) {
    final MaterialSpan? span = _exactOverlapSpan(element, carousel);
    if (span == null) {
      continue;
    }
    final double right = span.left + span.width;
    if (right > rightEdge) {
      rightEdge = right;
    }
  }
  return rightEdge;
}

/// This element's horizontal span when it's a sized `Material` overlapping
/// [carousel]'s bounds with 1-2px slack, or `null` when it's disqualified.
MaterialSpan? _slackOverlapSpan(Element element, Rect carousel) {
  final box = element.renderObject! as RenderBox;
  if (!box.hasSize || box.size.height < 20 || box.size.width < 20) {
    return null;
  }
  final Offset origin = box.localToGlobal(Offset.zero);
  final double edge = origin.dx + box.size.width;
  if (edge <= carousel.left + 1 || origin.dx >= carousel.right - 1) {
    return null;
  }
  return MaterialSpan(origin.dx, edge - origin.dx);
}

/// Left edge of the left-most, and right edge of the right-most, sized
/// `Material` whose span overlaps [carousel]'s bounds (with 1-2px slack).
({double left, double right}) heroCardEdges(Rect carousel) {
  double left = double.infinity;
  double right = carousel.left;
  for (final Element element in find.byType(Material).evaluate()) {
    final MaterialSpan? span = _slackOverlapSpan(element, carousel);
    if (span == null) {
      continue;
    }
    final double edge = span.left + span.width;
    if (span.left < left) {
      left = span.left;
    }
    if (edge > right && edge <= carousel.right + 2) {
      right = edge;
    }
  }
  return (left: left, right: right);
}
