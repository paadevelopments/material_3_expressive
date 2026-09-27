import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Center(child: SizedBox(width: 400, height: 200, child: child)),
    ),
  );
}

void _enableItem() {}

List<M3ECarouselItem> _items(int count) {
  return <M3ECarouselItem>[
    for (int i = 0; i < count; i++)
      M3ECarouselItem(
        onTap: _enableItem,
        image: ColoredBox(
          key: ValueKey<int>(i),
          color: const Color(0xFF112233),
          child: Center(child: Text('item$i')),
        ),
      ),
  ];
}

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
  testWidgets(
    'uncontained edge follows the shrink extent and does not jump on hover',
    _uncontainedInsets,
  );
  testWidgets('uncontained images fill their cards', _uncontainedImageFills);
  testWidgets('hero and contained insets match', _heroContainedInsets);
  testWidgets('full screen items fill the viewport', _fullScreenFills);
  testWidgets('vertical hero / contained / uncontained render', _vertical);
  testWidgets('tap reports the item index', _tap);
  testWidgets('free scroll snaps on drag', _freeScroll);
  testWidgets('tap pulse with neighbors completes', _tapPulseWithNeighbors);
  testWidgets('re-tap after scroll completes pulse', _retapAfterScroll);
  testWidgets('edge item tap pulse completes', _edgeItemTapPulse);
  testWidgets('hero tap pulse uses fixed per-edge pixels', _heroTapPulse);
  testWidgets(
    'hero tap pulse preserves per-edge pixel budget on mixed widths',
    _heroTapPulsePixelBudget,
  );
  testWidgets('onChange reports focal index after scroll', _onChangeFocal);
  testWidgets(
    'onChange setState during scroll does not throw',
    _onChangeSetState,
  );
  testWidgets(
    'onChange flips at midpoint for forward and reverse swipes',
    _onChangeMidpointSymmetric,
  );
  testWidgets('hero uses spec padding and radius', _paddingAndRadius);
  testWidgets('small slot stays within 40 to 56', _smallSlotClamp);
  testWidgets('swipe steps unless free scroll snaps', _snapDefaults);
  testWidgets('arrow key moves to the next item', _keyboardMove);
  testWidgets('show all opens the vertical list', _showAll);
  testWidgets('reduced motion keeps hero items one size', _reducedMotion);
  testWidgets('item transform opens after the tap pulse', _itemTransform);
  testWidgets('show all morphs the carousel into the list', _carouselTransform);
}

Future<void> _onChangeFocal(WidgetTester tester) async {
  M3ECarouselChangeDetails? latest;
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        onChange: (M3ECarouselChangeDetails details) {
          latest = details;
        },
        children: _items(6),
      ),
    ),
  );
  await tester.pump();
  expect(latest, isNull);

  await tester.fling(find.byType(M3ECarousel), const Offset(-300, 0), 800);
  await tester.pumpAndSettle();
  expect(latest, isNotNull);
  expect(latest!.itemCount, 6);
  expect(latest!.focalIndex, inInclusiveRange(0, 5));
  expect(latest!.leadingIndex, inInclusiveRange(0, 5));
}

Future<void> _onChangeMidpointSymmetric(WidgetTester tester) async {
  M3ECarouselChangeDetails? latest;
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        freeScroll: true,
        onChange: (M3ECarouselChangeDetails details) {
          latest = details;
        },
        children: _items(6),
      ),
    ),
  );
  await tester.pump();
  expect(latest, isNull);

  // Host is 400 wide. Container padding and the 40–56 small-slot clamp
  // set the leading slot. Forward and reverse both flip at half that slot.
  final ScrollPosition position = tester
      .state<ScrollableState>(find.byType(Scrollable))
      .position;
  final double viewport = position.viewportDimension;
  final List<int> weights = M3ECarouselLayout.clampWeights(
    pattern: const <int>[2, 6, 2],
    viewport: viewport,
    smallMin: M3ECarouselTheme.defaultSmallMinWidth,
    smallMax: M3ECarouselTheme.defaultSmallMaxWidth,
    largeMax: M3ECarouselTheme.defaultLargeMaxWidth,
  );
  final int total = weights.fold<int>(0, (int a, int b) => a + b);
  final double mid = viewport * weights.first / total / 2;

  position.jumpTo(mid - 1);
  await tester.pump();
  expect(latest, isNull, reason: 'still before midpoint when scrolling next');

  position.jumpTo(mid);
  await tester.pump();
  expect(latest, isNotNull, reason: 'forward swipe should flip at midpoint');
  expect(latest!.leadingIndex, 1);
  expect(latest!.focalIndex, 2);

  latest = null;
  position.jumpTo(mid + 1);
  await tester.pump();
  expect(latest, isNull, reason: 'no change while staying on same side');

  position.jumpTo(mid - 1);
  await tester.pump();
  expect(latest, isNotNull, reason: 'reverse swipe should flip at midpoint');
  expect(latest!.leadingIndex, 0);
  expect(latest!.focalIndex, 1);
}

Future<void> _hero(WidgetTester tester) async {
  await tester.pumpWidget(_host(M3ECarousel(children: _items(6))));
  await tester.pump();

  expect(tester.takeException(), isNull);
  expect(find.text('item0'), findsOneWidget);
}

Future<void> _heroAlignments(WidgetTester tester) async {
  for (final M3ECarouselHeroAlignment alignment
      in M3ECarouselHeroAlignment.values) {
    await tester.pumpWidget(
      _host(M3ECarousel(heroAlignment: alignment, children: _items(6))),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  }
}

Future<void> _contained(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(M3ECarousel(type: M3ECarouselType.contained, children: _items(6))),
  );
  await tester.pump();

  expect(tester.takeException(), isNull);
  expect(find.text('item0'), findsOneWidget);

  await tester.pumpWidget(
    _host(
      M3ECarousel(
        type: M3ECarouselType.contained,
        isExtended: true,
        children: _items(6),
      ),
    ),
  );
  await tester.pump();
  expect(tester.takeException(), isNull);
}

Future<void> _uncontained(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: _items(8),
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
    _SettleHost(
      width: 400,
      child: M3ECarousel(
        type: M3ECarouselType.hero,
        children: <M3ECarouselItem>[
          for (int i = 0; i < 6; i++)
            M3ECarouselItem(
              onTap: _enableItem,
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

Future<void> _uncontainedSettle(WidgetTester tester) async {
  const double width = 282;
  await tester.pumpWidget(
    _SettleHost(
      width: width,
      child: M3ECarousel(
        key: const ValueKey<String>('settle'),
        type: M3ECarouselType.uncontained,
        children: _items(8),
      ),
    ),
  );
  await tester.pump();
  await tester.fling(find.byType(M3ECarousel), const Offset(-400, 0), 1200);
  double? narrowest;
  for (var i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    final double pixels = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position
        .pixels;
    if (pixels <= 200 || pixels >= 270) {
      continue;
    }
    final double? leading = _leadingMaterialWidth(tester);
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
  final double? leading = _leadingMaterialWidth(tester);
  expect(narrowest, greaterThan(100), reason: 'settled pixels $pixels');
  expect(pixels, closeTo(M3ECarouselTheme.defaultUncontainedItemExtent, 1));
  expect(leading, greaterThan(200));
}

double? _leadingMaterialWidth(WidgetTester tester) {
  final Rect carousel = tester.getRect(find.byType(M3ECarousel));
  double? leadingWidth;
  double leadingLeft = double.infinity;
  for (final Element element in find.byType(Material).evaluate()) {
    final RenderBox box = element.renderObject! as RenderBox;
    if (!box.hasSize || box.size.width < 1 || box.size.height < 20) {
      continue;
    }
    final Offset origin = box.localToGlobal(Offset.zero);
    final double right = origin.dx + box.size.width;
    if (right < carousel.left + 4 || origin.dx > carousel.right - 4) {
      continue;
    }
    if (origin.dx < leadingLeft) {
      leadingLeft = origin.dx;
      leadingWidth = box.size.width;
    }
  }
  return leadingWidth;
}

class _SettleHost extends StatelessWidget {
  const _SettleHost({required this.width, required this.child});

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

Future<void> _multiAspectGap(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        type: M3ECarouselType.uncontainedMultiAspect,
        children: const <M3ECarouselItem>[
          M3ECarouselItem(
            aspectRatio: 1,
            onTap: _enableItem,
            image: ColoredBox(
              key: ValueKey<String>('a'),
              color: Color(0xFF112233),
            ),
          ),
          M3ECarouselItem(
            aspectRatio: 1,
            onTap: _enableItem,
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

Future<void> _uncontainedImageFills(WidgetTester tester) async {
  for (final double width in <double>[282, 360, 400, 480, 540, 640, 800]) {
    await tester.pumpWidget(
      _SettleHost(
        width: width,
        child: M3ECarousel(
          key: ValueKey<double>(width),
          type: M3ECarouselType.uncontained,
          children: _items(4),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final Rect carousel = tester.getRect(find.byType(M3ECarousel));
    for (final int index in <int>[0, 1]) {
      final Finder image = find.byKey(ValueKey<int>(index));
      if (image.evaluate().isEmpty) {
        continue;
      }
      final Rect picture = tester.getRect(image).intersect(carousel);
      if (picture.width <= 0) {
        continue;
      }
      final List<Element> materials = find
          .ancestor(of: image, matching: find.byType(Material))
          .evaluate()
          .toList();
      expect(materials, isNotEmpty);
      for (final Element material in materials) {
        final RenderBox box = material.renderObject! as RenderBox;
        final Rect card = (box.localToGlobal(Offset.zero) & box.size).intersect(
          carousel,
        );
        if (card.width <= 0 || card.height < 20) {
          continue;
        }
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
    }
  }
}

Future<void> _uncontainedInsets(WidgetTester tester) async {
  for (final M3ECarouselType type in <M3ECarouselType>[
    M3ECarouselType.uncontained,
    M3ECarouselType.uncontainedMultiAspect,
  ]) {
    await tester.pumpWidget(
      _host(
        M3ECarousel(
          key: ValueKey<M3ECarouselType>(type),
          type: type,
          uncontainedItemExtent: 150,
          children: _items(6),
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
    double rightEdge = carousel.left;
    for (final Element element in find.byType(Material).evaluate()) {
      final RenderBox box = element.renderObject! as RenderBox;
      if (!box.hasSize || box.size.height < 20 || box.size.width < 20) {
        continue;
      }
      final Offset origin = box.localToGlobal(Offset.zero);
      final double right = origin.dx + box.size.width;
      if (right <= carousel.left || origin.dx >= carousel.right) {
        continue;
      }
      if (right > rightEdge) {
        rightEdge = right;
      }
    }
    final double rightInset =
        carousel.right - rightEdge.clamp(carousel.left, carousel.right);
    expect(
      leftInset,
      closeTo(M3ECarouselTheme.defaultItemGap, 1),
      reason: '$type left',
    );
    // Extent 150 in a 400-wide host leaves a peek below the shrink extent,
    // so the trailing item stays at that extent and meets the edge.
    final double expectedRight = 0;
    expect(rightInset, closeTo(expectedRight, 1), reason: '$type right');
  }

  for (double width = 320; width <= 1040; width += 37) {
    await tester.pumpWidget(
      _SettleHost(
        width: width,
        child: M3ECarousel(
          key: ValueKey<double>(width),
          type: M3ECarouselType.uncontained,
          children: _items(8),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await _expectStableEdge(tester, 'rest $width');
    await tester.fling(find.byType(M3ECarousel), const Offset(-500, 0), 1200);
    await tester.pumpAndSettle();
    await _expectStableEdge(tester, 'scrolled $width');
  }
}

Future<void> _expectStableEdge(WidgetTester tester, String reason) async {
  final double beforePixels = tester
      .state<ScrollableState>(find.byType(Scrollable))
      .position
      .pixels;
  final double beforeEdge = _trailingMaterialEdge(tester);
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
    _trailingMaterialEdge(tester),
    closeTo(beforeEdge, 0.5),
    reason: '$reason edge',
  );
}

double _trailingMaterialEdge(WidgetTester tester) {
  final Rect carousel = tester.getRect(find.byType(M3ECarousel));
  double rightEdge = carousel.left;
  for (final Element element in find.byType(Material).evaluate()) {
    final RenderBox box = element.renderObject! as RenderBox;
    if (!box.hasSize || box.size.height < 20 || box.size.width < 20) {
      continue;
    }
    final Offset origin = box.localToGlobal(Offset.zero);
    final double right = origin.dx + box.size.width;
    if (right <= carousel.left + 4 || origin.dx >= carousel.right + 4) {
      continue;
    }
    if (right > rightEdge) {
      rightEdge = right;
    }
  }
  return rightEdge;
}

Future<void> _heroContainedInsets(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  for (final M3ECarouselType type in <M3ECarouselType>[
    M3ECarouselType.hero,
    M3ECarouselType.contained,
  ]) {
    for (final double width in <double>[360, 743, 1107]) {
      await tester.pumpWidget(
        _SettleHost(
          width: width,
          child: M3ECarousel(
            key: ValueKey<String>('$type-$width'),
            type: type,
            children: _items(6),
          ),
        ),
      );
      await tester.pump();
      final Rect carousel = tester.getRect(find.byType(M3ECarousel));
      double left = double.infinity;
      double right = carousel.left;
      for (final Element element in find.byType(Material).evaluate()) {
        final RenderBox box = element.renderObject! as RenderBox;
        if (!box.hasSize || box.size.height < 20 || box.size.width < 20) {
          continue;
        }
        final Offset origin = box.localToGlobal(Offset.zero);
        final double edge = origin.dx + box.size.width;
        if (edge <= carousel.left + 1 || origin.dx >= carousel.right - 1) {
          continue;
        }
        if (origin.dx < left) {
          left = origin.dx;
        }
        if (edge > right && edge <= carousel.right + 2) {
          right = edge;
        }
      }
      final double leftInset = left - carousel.left;
      final double rightInset = carousel.right - right;
      expect(leftInset, closeTo(16, 1), reason: '$type $width left');
      expect(rightInset, closeTo(leftInset, 1), reason: '$type $width right');
    }
  }
}

Future<void> _fullScreenFills(WidgetTester tester) async {
  await tester.pumpWidget(
    const Directionality(
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
                  onTap: _enableItem,
                  image: ColoredBox(
                    key: ValueKey<int>(0),
                    color: Color(0xFF112233),
                  ),
                ),
                M3ECarouselItem(
                  onTap: _enableItem,
                  image: ColoredBox(
                    key: ValueKey<int>(1),
                    color: Color(0xFF223344),
                  ),
                ),
                M3ECarouselItem(
                  onTap: _enableItem,
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
    ),
  );
  await tester.pump();

  final Rect carousel = tester.getRect(find.byType(M3ECarousel));
  Rect card(int index) {
    return tester.getRect(
      find.ancestor(
        of: find.byKey(ValueKey<int>(index)),
        matching: find.byType(CompositedTransformTarget),
      ),
    );
  }

  final Rect first = card(0);
  final Rect picture = tester.getRect(find.byKey(const ValueKey<int>(0)));
  expect(first.height, closeTo(carousel.height, 1));
  expect(first.top, closeTo(carousel.top, 1));
  final double restGap = first.top - picture.top;
  expect(picture.height, greaterThan(first.height + 20));
  expect(restGap, greaterThan(8));

  await tester.fling(find.byType(M3ECarousel), const Offset(0, -500), 2000);
  var sawShift = false;
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
    final Rect moving = card(0);
    final Rect movingPicture = tester.getRect(
      find.byKey(const ValueKey<int>(0)),
    );
    expect(moving.height, closeTo(carousel.height, 1));
    if ((moving.top - movingPicture.top - restGap).abs() > 4) {
      sawShift = true;
      break;
    }
  }
  expect(sawShift, isTrue);
  await tester.pumpAndSettle();

  final Rect second = card(1);
  expect(second.height, closeTo(carousel.height, 1));
  expect(second.top, closeTo(carousel.top, 1));
  expect(second.bottom, closeTo(carousel.bottom, 1));
}

Future<void> _vertical(WidgetTester tester) async {
  for (final M3ECarouselType type in M3ECarouselType.values) {
    await tester.pumpWidget(
      _host(
        M3ECarousel(
          key: ValueKey<M3ECarouselType>(type),
          axis: Axis.vertical,
          type: type,
          uncontainedItemExtent: 80,
          children: _items(6),
        ),
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull, reason: '$type');
    expect(find.text('item0'), findsOneWidget);
  }

  await tester.pumpWidget(
    _host(
      M3ECarousel(
        axis: Axis.vertical,
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 80,
        children: _items(6),
      ),
    ),
  );
  await tester.pump();
  await tester.fling(find.byType(M3ECarousel), const Offset(0, -300), 800);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _tap(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        onTap: (int index) {},
        children: _items(6),
      ),
    ),
  );
  await tester.pump();

  // With onTap set, each item is covered by a tappable splash layer; tapping
  // must not throw.
  await tester.tap(find.text('item0'), warnIfMissed: false);
  await tester.pump();

  expect(tester.takeException(), isNull);
}

Future<void> _freeScroll(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        freeScroll: true,
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: _items(8),
      ),
    ),
  );
  await tester.pump();

  await tester.fling(find.byType(M3ECarousel), const Offset(-400, 0), 800);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _tapPulseWithNeighbors(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: _items(6),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('item2'), warnIfMissed: false);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 90));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
}

Future<void> _retapAfterScroll(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        freeScroll: true,
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: _items(8),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.fling(find.byType(M3ECarousel), const Offset(-300, 0), 600);
  await tester.pumpAndSettle();

  await tester.tap(find.byType(InkWell).first, warnIfMissed: false);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 90));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
}

Future<void> _edgeItemTapPulse(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: _items(6),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('item0'), warnIfMissed: false);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 90));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
}

Future<void> _heroTapPulse(WidgetTester tester) async {
  await tester.pumpWidget(_host(M3ECarousel(children: _items(6))));
  await tester.pumpAndSettle();

  await tester.tap(find.text('item1'), warnIfMissed: false);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 90));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
}

Future<void> _paddingAndRadius(WidgetTester tester) async {
  await tester.pumpWidget(_host(M3ECarousel(children: _items(6))));
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
  final RoundedRectangleBorder shape =
      material.shape! as RoundedRectangleBorder;
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
              children: _items(6),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  final List<double> widths = <double>[
    for (final Element element in find.byType(Material).evaluate())
      if (element.size != null) element.size!.width,
  ];
  final double smallest = widths.reduce((double a, double b) => a < b ? a : b);
  expect(smallest, inInclusiveRange(40, 56));
}

Future<void> _snapDefaults(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: _items(6),
      ),
    ),
  );
  await tester.pump();
  expect(
    tester.state<ScrollableState>(find.byType(Scrollable)).position.physics,
    isA<NeverScrollableScrollPhysics>(),
  );

  await tester.pumpWidget(_host(M3ECarousel(children: _items(6))));
  await tester.pump();
  expect(
    tester.state<ScrollableState>(find.byType(Scrollable)).position.physics,
    isA<NeverScrollableScrollPhysics>(),
  );

  await tester.pumpWidget(
    _host(M3ECarousel(freeScroll: true, children: _items(6))),
  );
  await tester.pump();
  expect(
    tester.state<ScrollableState>(find.byType(Scrollable)).position.physics,
    isA<M3ECarouselScrollPhysics>(),
  );
}

Future<void> _keyboardMove(WidgetTester tester) async {
  await tester.pumpWidget(_host(M3ECarousel(children: _items(6))));
  await tester.pump();

  await tester.tap(find.text('item0'), warnIfMissed: false);
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
  await tester.pumpAndSettle();

  expect(
    tester.binding.focusManager.primaryFocus?.debugLabel,
    contains('carousel item 1'),
  );
}

Future<void> _showAll(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 200,
          child: M3ECarousel(showAll: true, children: _items(4)),
        ),
      ),
    ),
  );
  await tester.pump();

  await tester.tap(find.text('Show all'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));

  expect(find.byType(M3ECarouselShowAll), findsOneWidget);
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
            child: M3ECarousel(children: _items(6)),
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  final List<double> widths = <double>[
    for (final Element element in find.byType(Material).evaluate())
      if (element.size != null &&
          element.size!.width > 80 &&
          element.size!.width < 390)
        element.size!.width,
  ];
  expect(widths.length, greaterThan(1));
  expect(widths.first, closeTo(widths[1], 1));
}

Future<void> _itemTransform(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 200,
          child: M3ECarousel(
            type: M3ECarouselType.uncontained,
            uncontainedItemExtent: 160,
            children: const <M3ECarouselItem>[
              M3ECarouselItem(
                onTap: _enableItem,
                transform: Text('opened-item'),
                image: SizedBox.expand(child: Text('item0')),
              ),
              M3ECarouselItem(onTap: _enableItem, image: Text('item1')),
              M3ECarouselItem(onTap: _enableItem, image: Text('item2')),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  await tester.tap(find.byType(InkWell).first);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump(const Duration(milliseconds: 50));
  for (int i = 0; i < 40; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (find.text('opened-item').evaluate().isNotEmpty) {
      break;
    }
  }

  expect(find.text('opened-item'), findsOneWidget);
}

Future<void> _carouselTransform(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 320,
          child: M3ECarousel(header: const Text('Trips'), children: _items(4)),
        ),
      ),
    ),
  );
  await tester.pump();

  await tester.tap(find.byType(M3EIconButton));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));

  expect(find.byType(M3ECarouselShowAll), findsOneWidget);
  expect(find.text('Trips'), findsWidgets);
}

Future<void> _heroTapPulsePixelBudget(WidgetTester tester) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
  await tester.pumpWidget(
    M3EMaterialApp(
      data: base.copyWith(
        carouselTheme: const M3ECarouselTheme(itemPadding: EdgeInsets.all(8)),
      ),
      home: Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            height: 200,
            child: M3ECarousel(children: _items(6)),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('item1'), warnIfMissed: false);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 90));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
}

Future<void> _onChangeSetState(WidgetTester tester) async {
  await tester.pumpWidget(const _OnChangeHost());
  await tester.pump();
  await tester.fling(find.byType(M3ECarousel), const Offset(-300, 0), 800);
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

class _OnChangeHost extends StatefulWidget {
  const _OnChangeHost();

  @override
  State<_OnChangeHost> createState() => _OnChangeHostState();
}

class _OnChangeHostState extends State<_OnChangeHost> {
  int _focalIndex = 1;

  @override
  Widget build(BuildContext context) {
    return _host(
      M3ECarousel(
        onChange: (M3ECarouselChangeDetails details) {
          if (_focalIndex == details.focalIndex) {
            return;
          }
          setState(() => _focalIndex = details.focalIndex);
        },
        children: _items(6),
      ),
    );
  }
}
