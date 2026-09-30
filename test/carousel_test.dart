import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/carousel_test_helpers.dart';

void main() {
  testWidgets('hero (default) lays out without error', _hero);
  testWidgets('hero left/right alignments render', _heroAlignments);
  testWidgets('contained layout renders', _contained);
  testWidgets('uncontained layout renders and swipes', _uncontained);
  testWidgets('uncontained settle keeps the leading item', _uncontainedSettle);
  testWidgets(
    'item text follows the live slot size',
    _textRestoresWhenScrollEnds,
  );
  testWidgets('multi-aspect items keep a gap', _multiAspectGap);
  testWidgets('multi-aspect shrinks like uncontained', _multiAspectShrinks);
  testWidgets(
    'uncontained edge follows the shrink extent and does not jump on hover',
    _uncontainedInsets,
  );
  testWidgets('uncontained images fill their cards', _uncontainedImageFills);
  testWidgets('hero and contained insets match', _heroContainedInsets);
  testWidgets('full screen items fill the viewport', _fullScreenFills);
  testWidgets('vertical hero / contained / uncontained render', _vertical);
  testWidgets('hero uses spec padding and radius', _paddingAndRadius);
  testWidgets('small slot stays within 40 to 56', _smallSlotClamp);
  testWidgets('reduced motion keeps hero items one size', _reducedMotion);
}

Future<void> _hero(WidgetTester tester) async {
  await tester.pumpWidget(
    hostCarousel(M3ECarousel(children: carouselItems(6))),
  );
  await tester.pump();

  expect(tester.takeException(), isNull);
  expect(find.text('item0'), findsOneWidget);
}

Future<void> _heroAlignments(WidgetTester tester) async {
  for (final M3ECarouselHeroAlignment alignment
      in M3ECarouselHeroAlignment.values) {
    await tester.pumpWidget(
      hostCarousel(
        M3ECarousel(heroAlignment: alignment, children: carouselItems(6)),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  }
}

Future<void> _contained(WidgetTester tester) async {
  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(type: M3ECarouselType.contained, children: carouselItems(6)),
    ),
  );
  await tester.pump();

  expect(tester.takeException(), isNull);
  expect(find.text('item0'), findsOneWidget);

  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(
        type: M3ECarouselType.contained,
        isExtended: true,
        children: carouselItems(6),
      ),
    ),
  );
  await tester.pump();
  expect(tester.takeException(), isNull);
}

Future<void> _uncontained(WidgetTester tester) async {
  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: carouselItems(8),
      ),
    ),
  );
  await tester.pump();
  expect(tester.takeException(), isNull);

  await tester.fling(find.byType(M3ECarousel), const Offset(-400, 0), 800);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _textRestoresWhenScrollEnds(WidgetTester tester) async {
  await tester.pumpWidget(
    CarouselSettleHost(
      width: 400,
      child: M3ECarousel(
        children: <M3ECarouselItem>[
          for (int i = 0; i < 6; i++)
            M3ECarouselItem(
              onTap: enableCarouselItem,
              image: ColoredBox(
                key: ValueKey<int>(i),
                color: const Color(0xFF112233),
              ),
              title: Text('Title $i'),
              subtitle: Text('Subtitle $i'),
              prefixText: Text('Prefix $i'),
            ),
        ],
      ),
    ),
  );
  await tester.pump();
  expect(find.text('Prefix 0'), findsOneWidget);
  expect(find.text('Title 0'), findsNothing);
  expect(find.text('Title 1'), findsOneWidget);
  expect(find.text('Subtitle 1'), findsOneWidget);

  await tester.fling(find.byType(M3ECarousel), const Offset(-500, 0), 1200);
  var sawTitleFollowSize = false;
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    final double pixels = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position
        .pixels;
    if (pixels <= 1) {
      continue;
    }
    if (find.text('Title 2').evaluate().isNotEmpty) {
      expect(find.text('Prefix 2'), findsNothing);
      sawTitleFollowSize = true;
      break;
    }
  }
  expect(sawTitleFollowSize, isTrue);

  await tester.pumpAndSettle();
  expect(find.text('Prefix 1'), findsOneWidget);
  expect(find.text('Title 1'), findsNothing);
  expect(find.text('Title 2'), findsOneWidget);
}

/// Returns the leading material's width when the current scroll position is
/// inside the settle-measurement window, or `null` otherwise.
double? _leadingWidthIfInWindow(WidgetTester tester) {
  final double pixels = tester
      .state<ScrollableState>(find.byType(Scrollable))
      .position
      .pixels;
  if (pixels <= 200 || pixels >= 270) {
    return null;
  }
  return leadingMaterialWidth(tester);
}

Future<void> _uncontainedSettle(WidgetTester tester) async {
  const double width = 282;
  await tester.pumpWidget(
    CarouselSettleHost(
      width: width,
      child: M3ECarousel(
        key: const ValueKey<String>('settle'),
        type: M3ECarouselType.uncontained,
        children: carouselItems(8),
      ),
    ),
  );
  await tester.pump();
  await tester.fling(find.byType(M3ECarousel), const Offset(-400, 0), 1200);
  double? narrowest;
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    final double? leading = _leadingWidthIfInWindow(tester);
    if (leading == null) {
      continue;
    }
    if (narrowest == null || leading < narrowest) {
      narrowest = leading;
    }
  }
  await tester.pumpAndSettle();
  final double pixels = tester
      .state<ScrollableState>(find.byType(Scrollable))
      .position
      .pixels;
  final double? leading = leadingMaterialWidth(tester);
  expect(narrowest, greaterThan(100), reason: 'settled pixels $pixels');
  expect(pixels, closeTo(M3ECarouselTheme.defaultUncontainedItemExtent, 1));
  expect(leading, greaterThan(200));
}

Future<void> _multiAspectGap(WidgetTester tester) async {
  await tester.pumpWidget(
    hostCarousel(
      const M3ECarousel(
        type: M3ECarouselType.uncontainedMultiAspect,
        children: <M3ECarouselItem>[
          M3ECarouselItem(
            onTap: enableCarouselItem,
            image: ColoredBox(
              key: ValueKey<String>('a'),
              color: Color(0xFF112233),
            ),
          ),
          M3ECarouselItem(
            onTap: enableCarouselItem,
            image: ColoredBox(
              key: ValueKey<String>('b'),
              color: Color(0xFF112233),
            ),
          ),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Finder firstFrame = find
      .ancestor(
        of: find.byKey(const ValueKey<String>('a')),
        matching: find.byType(Material),
      )
      .first;
  final Finder secondFrame = find
      .ancestor(
        of: find.byKey(const ValueKey<String>('b')),
        matching: find.byType(Material),
      )
      .first;
  final Rect first = tester.getRect(firstFrame);
  final Rect second = tester.getRect(secondFrame);
  expect(second.left - first.right, greaterThan(4));
}

Future<void> _multiAspectShrinks(WidgetTester tester) async {
  await tester.pumpWidget(
    CarouselSettleHost(
      width: 800,
      child: M3ECarousel(
        type: M3ECarouselType.uncontainedMultiAspect,
        children: <M3ECarouselItem>[
          for (int i = 0; i < 4; i++)
            M3ECarouselItem(
              onTap: enableCarouselItem,
              aspectRatio: i.isEven ? 16 / 9 : 9 / 16,
              image: ColoredBox(
                key: ValueKey<int>(i),
                color: const Color(0xFF112233),
              ),
            ),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();

  double widthOf(int index) {
    return tester
        .getSize(
          find
              .ancestor(
                of: find.byKey(ValueKey<int>(index)),
                matching: find.byType(Material),
              )
              .first,
        )
        .width;
  }

  final double restWide = widthOf(0);
  final double restNarrow = widthOf(1);
  expect(restWide, greaterThan(restNarrow + 20));

  await tester.fling(find.byType(M3ECarousel), const Offset(-500, 0), 1200);
  var shrank = false;
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    if (find.byKey(const ValueKey<int>(0)).evaluate().isEmpty) {
      continue;
    }
    if (widthOf(0) < restWide - 8) {
      shrank = true;
      break;
    }
  }
  expect(shrank, isTrue);
}

Future<void> _expectUncontainedImageFillsAtWidth(
  WidgetTester tester,
  double width,
) async {
  await tester.pumpWidget(
    CarouselSettleHost(
      width: width,
      child: M3ECarousel(
        key: ValueKey<double>(width),
        type: M3ECarouselType.uncontained,
        children: carouselItems(4),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final Rect carousel = tester.getRect(find.byType(M3ECarousel));
  for (final index in <int>[0, 1]) {
    _expectImageFillsAtIndex(tester, carousel, width, index);
  }
}

void _expectImageFillsAtIndex(
  WidgetTester tester,
  Rect carousel,
  double width,
  int index,
) {
  final Finder image = find.byKey(ValueKey<int>(index));
  if (image.evaluate().isEmpty) {
    return;
  }
  final Rect picture = tester.getRect(image).intersect(carousel);
  if (picture.width <= 0) {
    return;
  }
  final List<Element> materials = find
      .ancestor(of: image, matching: find.byType(Material))
      .evaluate()
      .toList();
  expect(materials, isNotEmpty);
  for (final material in materials) {
    final box = material.renderObject! as RenderBox;
    final Rect card = (box.localToGlobal(Offset.zero) & box.size).intersect(
      carousel,
    );
    if (card.width <= 0 || card.height < 20) {
      continue;
    }
    expectImageWithinCard(picture, card, width, index);
  }
}

Future<void> _uncontainedImageFills(WidgetTester tester) async {
  for (final width in <double>[282, 360, 400, 480, 540, 640, 800]) {
    await _expectUncontainedImageFillsAtWidth(tester, width);
  }
}

Future<void> _expectUncontainedTypeInset(
  WidgetTester tester,
  M3ECarouselType type,
) async {
  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(
        key: ValueKey<M3ECarouselType>(type),
        type: type,
        uncontainedItemExtent: 150,
        children: carouselItems(6),
      ),
    ),
  );
  await tester.pump();

  final Rect carousel = tester.getRect(find.byType(M3ECarousel));
  final Rect leading = tester.getRect(
    find
        .ancestor(of: find.text('item0'), matching: find.byType(Material))
        .first,
  );
  final double leftInset = leading.left - carousel.left;
  final double rightEdge = rightmostMaterialEdgeWithin(carousel);
  final double rightInset =
      carousel.right - rightEdge.clamp(carousel.left, carousel.right);
  expect(
    leftInset,
    closeTo(M3ECarouselTheme.defaultItemGap, 1),
    reason: '$type left',
  );
  // Extent 150 in a 400-wide host leaves a peek below the shrink extent,
  // so the trailing item stays at that extent and meets the edge.
  const double expectedRight = 0;
  expect(rightInset, closeTo(expectedRight, 1), reason: '$type right');
}

Future<void> _expectUncontainedWidthStable(
  WidgetTester tester,
  double width,
) async {
  await tester.pumpWidget(
    CarouselSettleHost(
      width: width,
      child: M3ECarousel(
        key: ValueKey<double>(width),
        type: M3ECarouselType.uncontained,
        children: carouselItems(8),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await _expectStableEdge(tester, 'rest $width');
  await tester.fling(find.byType(M3ECarousel), const Offset(-500, 0), 1200);
  await tester.pumpAndSettle();
  await _expectStableEdge(tester, 'scrolled $width');
}

Future<void> _uncontainedInsets(WidgetTester tester) async {
  for (final type in <M3ECarouselType>[
    M3ECarouselType.uncontained,
    M3ECarouselType.uncontainedMultiAspect,
  ]) {
    await _expectUncontainedTypeInset(tester, type);
  }

  for (double width = 320; width <= 1040; width += 37) {
    await _expectUncontainedWidthStable(tester, width);
  }
}

Future<void> _expectStableEdge(WidgetTester tester, String reason) async {
  final double beforePixels = tester
      .state<ScrollableState>(find.byType(Scrollable))
      .position
      .pixels;
  final double beforeEdge = trailingMaterialEdge(tester);
  final TestGesture hover = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await hover.addPointer();
  await hover.moveTo(tester.getCenter(find.byType(M3ECarousel)));
  await tester.pump();
  await hover.removePointer();
  expect(
    tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels,
    closeTo(beforePixels, 0.5),
    reason: '$reason pixels',
  );
  expect(
    trailingMaterialEdge(tester),
    closeTo(beforeEdge, 0.5),
    reason: '$reason edge',
  );
}

Future<void> _expectHeroContainedInset(
  WidgetTester tester,
  M3ECarouselType type,
  double width,
) async {
  await tester.pumpWidget(
    CarouselSettleHost(
      width: width,
      child: M3ECarousel(
        key: ValueKey<String>('$type-$width'),
        type: type,
        children: carouselItems(6),
      ),
    ),
  );
  await tester.pump();
  final Rect carousel = tester.getRect(find.byType(M3ECarousel));
  final (:double left, :double right) = heroCardEdges(carousel);
  final double leftInset = left - carousel.left;
  final double rightInset = carousel.right - right;
  expect(leftInset, closeTo(16, 1), reason: '$type $width left');
  expect(rightInset, closeTo(leftInset, 1), reason: '$type $width right');
}

Future<void> _heroContainedInsets(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  for (final type in <M3ECarouselType>[
    M3ECarouselType.hero,
    M3ECarouselType.contained,
  ]) {
    for (final width in <double>[360, 743, 1107]) {
      await _expectHeroContainedInset(tester, type, width);
    }
  }
}

Rect _fullScreenCard(WidgetTester tester, int index) {
  return tester.getRect(
    find.ancestor(
      of: find.byKey(ValueKey<int>(index)),
      matching: find.byType(CompositedTransformTarget),
    ),
  );
}

Future<bool> _fullScreenCardShifts(
  WidgetTester tester,
  Rect carousel,
  double restGap,
) async {
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    final double pixels = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position
        .pixels;
    if (pixels < 24 || pixels > carousel.height - 24) {
      continue;
    }
    if (!find.byKey(const ValueKey<int>(0)).evaluate().isNotEmpty) {
      continue;
    }
    final Rect moving = _fullScreenCard(tester, 0);
    final Rect movingPicture = tester.getRect(
      find.byKey(const ValueKey<int>(0)),
    );
    expect(moving.height, closeTo(carousel.height, 1));
    if ((moving.top - movingPicture.top - restGap).abs() > 4) {
      return true;
    }
  }
  return false;
}

Future<void> _fullScreenFills(WidgetTester tester) async {
  await tester.pumpWidget(fullScreenCarouselHost());
  await tester.pump();

  final Rect carousel = tester.getRect(find.byType(M3ECarousel));
  final Rect first = _fullScreenCard(tester, 0);
  final Rect picture = tester.getRect(find.byKey(const ValueKey<int>(0)));
  expect(first.height, closeTo(carousel.height, 1));
  expect(first.top, closeTo(carousel.top, 1));
  final double restGap = first.top - picture.top;
  expect(picture.height, greaterThan(first.height + 20));
  expect(restGap, greaterThan(8));

  await tester.fling(find.byType(M3ECarousel), const Offset(0, -500), 2000);
  final bool sawShift = await _fullScreenCardShifts(tester, carousel, restGap);
  expect(sawShift, isTrue);
  await tester.pumpAndSettle();

  final Rect second = _fullScreenCard(tester, 1);
  expect(second.height, closeTo(carousel.height, 1));
  expect(second.top, closeTo(carousel.top, 1));
  expect(second.bottom, closeTo(carousel.bottom, 1));
}

Future<void> _vertical(WidgetTester tester) async {
  for (final M3ECarouselType type in M3ECarouselType.values) {
    await tester.pumpWidget(
      hostCarousel(
        M3ECarousel(
          key: ValueKey<M3ECarouselType>(type),
          axis: Axis.vertical,
          type: type,
          uncontainedItemExtent: 80,
          children: carouselItems(6),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull, reason: '$type');
    expect(find.text('item0'), findsOneWidget);
  }

  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(
        axis: Axis.vertical,
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 80,
        children: carouselItems(6),
      ),
    ),
  );
  await tester.pump();
  await tester.fling(find.byType(M3ECarousel), const Offset(0, -300), 800);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _paddingAndRadius(WidgetTester tester) async {
  await tester.pumpWidget(
    hostCarousel(M3ECarousel(children: carouselItems(6))),
  );
  await tester.pump();

  final Padding padding = tester.widget<Padding>(
    find
        .descendant(
          of: find.byType(M3ECarousel),
          matching: find.byType(Padding),
        )
        .first,
  );
  expect(padding.padding, const EdgeInsets.fromLTRB(12, 8, 12, 8));

  final Material material = tester.widget<Material>(
    find
        .descendant(
          of: find.byType(M3ECarousel),
          matching: find.byType(Material),
        )
        .at(1),
  );
  final shape = material.shape! as RoundedRectangleBorder;
  expect(shape.borderRadius, BorderRadius.circular(28));
}

Future<void> _smallSlotClamp(WidgetTester tester) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Center(
          child: SizedBox(
            width: 800,
            height: 200,
            child: M3ECarousel(
              type: M3ECarouselType.contained,
              children: carouselItems(6),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  final widths = <double>[
    for (final Element element in find.byType(Material).evaluate())
      if (element.size != null) element.size!.width,
  ];
  final double smallest = widths.reduce((double a, double b) => a < b ? a : b);
  expect(smallest, inInclusiveRange(40, 56));
}

Future<void> _reducedMotion(WidgetTester tester) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Center(
          child: SizedBox(
            width: 400,
            height: 200,
            child: M3ECarousel(children: carouselItems(6)),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  final widths = <double>[
    for (final Element element in find.byType(Material).evaluate())
      if (element.size != null &&
          element.size!.width > 80 &&
          element.size!.width < 390)
        element.size!.width,
  ];
  expect(widths.length, greaterThan(1));
  expect(widths.first, closeTo(widths[1], 1));
}
