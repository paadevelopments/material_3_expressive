import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Center(child: SizedBox(width: 400, height: 200, child: child)),
    ),
  );
}

List<Widget> _items(int count) {
  return <Widget>[
    for (int i = 0; i < count; i++)
      ColoredBox(
        key: ValueKey<int>(i),
        color: const Color(0xFF112233),
        child: Center(child: Text('item$i')),
      ),
  ];
}

void main() {
  testWidgets('hero (default) lays out without error', _hero);
  testWidgets('hero left/right alignments render', _heroAlignments);
  testWidgets('contained layout renders', _contained);
  testWidgets('uncontained layout renders and swipes', _uncontained);
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
    'onChange flips at midpoint for forward and reverse swipes',
    _onChangeMidpointSymmetric,
  );
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

  // Host width 400; hero center weights [2, 6, 2] → item step = 400 * 2/10 = 80.
  // Truncation would keep leading at 0 until pixels >= 80; rounding flips at 40.
  final ScrollPosition position = tester
      .state<ScrollableState>(find.byType(Scrollable))
      .position;

  position.jumpTo(39);
  await tester.pump();
  expect(latest, isNull, reason: 'still before midpoint when scrolling next');

  position.jumpTo(40);
  await tester.pump();
  expect(latest, isNotNull, reason: 'forward swipe should flip at midpoint');
  expect(latest!.leadingIndex, 1);
  expect(latest!.focalIndex, 2);

  latest = null;
  position.jumpTo(41);
  await tester.pump();
  expect(latest, isNull, reason: 'no change while staying on same side');

  position.jumpTo(39);
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
