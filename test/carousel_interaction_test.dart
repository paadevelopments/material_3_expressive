import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/carousel_test_helpers.dart';

void main() {
  testWidgets('controller steps and jumps', _controllerSteps);
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
  testWidgets('swipe steps unless free scroll snaps', _snapDefaults);
  testWidgets('arrow key moves to the next item', _keyboardMove);
  testWidgets('show all opens the vertical list', _showAll);
  testWidgets('item transform opens after the tap pulse', _itemTransform);
  testWidgets('show all morphs the carousel into the list', _carouselTransform);
}

Future<void> _controllerSteps(WidgetTester tester) async {
  final controller = M3ECarouselController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    CarouselSettleHost(
      width: 800,
      child: M3ECarousel(
        controller: controller,
        type: M3ECarouselType.uncontained,
        children: carouselItems(6),
      ),
    ),
  );
  await tester.pump();
  expect(controller.currentItem, 0);

  final double extent = M3ECarouselTheme.defaultUncontainedItemExtent;
  final Future<void> forward = controller.next();
  await tester.pumpAndSettle();
  await forward;
  double pixels() =>
      tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels;
  expect(pixels(), closeTo(extent, 1));
  expect(controller.currentItem, 1);

  controller.jumpToItem(3);
  await tester.pump();
  expect(pixels(), closeTo(extent * 3, 1));
  expect(controller.currentItem, 3);

  final Future<void> back = controller.previous();
  await tester.pumpAndSettle();
  await back;
  expect(controller.currentItem, 2);
  expect(pixels(), closeTo(extent * 2, 1));
}

Future<void> _tap(WidgetTester tester) async {
  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        onTap: (int index) {},
        children: carouselItems(6),
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
    hostCarousel(
      M3ECarousel(
        freeScroll: true,
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: carouselItems(8),
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
    hostCarousel(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: carouselItems(6),
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
    hostCarousel(
      M3ECarousel(
        freeScroll: true,
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: carouselItems(8),
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
    hostCarousel(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: carouselItems(6),
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
  await tester.pumpWidget(
    hostCarousel(M3ECarousel(children: carouselItems(6))),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('item1'), warnIfMissed: false);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 90));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
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
            child: M3ECarousel(children: carouselItems(6)),
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

Future<void> _onChangeFocal(WidgetTester tester) async {
  M3ECarouselChangeDetails? latest;
  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(
        onChange: (M3ECarouselChangeDetails details) {
          latest = details;
        },
        children: carouselItems(6),
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
    return hostCarousel(
      M3ECarousel(
        onChange: (M3ECarouselChangeDetails details) {
          if (_focalIndex == details.focalIndex) {
            return;
          }
          setState(() => _focalIndex = details.focalIndex);
        },
        children: carouselItems(6),
      ),
    );
  }
}

Future<void> _onChangeMidpointSymmetric(WidgetTester tester) async {
  M3ECarouselChangeDetails? latest;
  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(
        freeScroll: true,
        onChange: (M3ECarouselChangeDetails details) {
          latest = details;
        },
        children: carouselItems(6),
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

Future<void> _snapDefaults(WidgetTester tester) async {
  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(
        type: M3ECarouselType.uncontained,
        uncontainedItemExtent: 150,
        children: carouselItems(6),
      ),
    ),
  );
  await tester.pump();
  expect(
    tester.state<ScrollableState>(find.byType(Scrollable)).position.physics,
    isA<NeverScrollableScrollPhysics>(),
  );

  await tester.pumpWidget(
    hostCarousel(M3ECarousel(children: carouselItems(6))),
  );
  await tester.pump();
  expect(
    tester.state<ScrollableState>(find.byType(Scrollable)).position.physics,
    isA<NeverScrollableScrollPhysics>(),
  );

  await tester.pumpWidget(
    hostCarousel(M3ECarousel(freeScroll: true, children: carouselItems(6))),
  );
  await tester.pump();
  expect(
    tester.state<ScrollableState>(find.byType(Scrollable)).position.physics,
    isA<M3ECarouselScrollPhysics>(),
  );
}

Future<void> _keyboardMove(WidgetTester tester) async {
  await tester.pumpWidget(
    hostCarousel(M3ECarousel(children: carouselItems(6))),
  );
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
          child: M3ECarousel(showAll: true, children: carouselItems(4)),
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

Future<void> _itemTransform(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: 400,
          height: 200,
          child: M3ECarousel(
            type: M3ECarouselType.uncontained,
            uncontainedItemExtent: 160,
            children: <M3ECarouselItem>[
              M3ECarouselItem(
                onTap: enableCarouselItem,
                transform: Text('opened-item'),
                image: SizedBox.expand(child: Text('item0')),
              ),
              M3ECarouselItem(onTap: enableCarouselItem, image: Text('item1')),
              M3ECarouselItem(onTap: enableCarouselItem, image: Text('item2')),
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
  for (var i = 0; i < 40; i++) {
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
          child: M3ECarousel(
            header: const Text('Trips'),
            children: carouselItems(4),
          ),
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
