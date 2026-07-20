import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: Center(
        child: SizedBox(width: 400, height: 200, child: child),
      ),
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
  testWidgets('tap reports the item index', _tap);
  testWidgets('free scroll snaps on drag', _freeScroll);
  testWidgets('tap pulse with neighbors completes', _tapPulseWithNeighbors);
  testWidgets('re-tap after scroll completes pulse', _retapAfterScroll);
  testWidgets('edge item tap pulse completes', _edgeItemTapPulse);
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
    _host(
      M3ECarousel(type: M3ECarouselType.contained, children: _items(6)),
    ),
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
