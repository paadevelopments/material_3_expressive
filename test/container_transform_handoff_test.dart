import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/carousel_test_helpers.dart';

void main() {
  testWidgets(
    'FAB content cross-fades in and out of the transform',
    _fabContentCrossFades,
  );
  testWidgets(
    'card is hidden while open and its content cross-fades',
    _cardContentCrossFades,
  );
  testWidgets(
    'list row is hidden while open and its content cross-fades',
    _listRowContentCrossFades,
  );
  testWidgets(
    'carousel track is hidden while show all is open',
    _carouselTrackHiddenWhileShowAllOpen,
  );
  testWidgets(
    'carousel item is hidden while open and its content cross-fades',
    _carouselItemContentCrossFades,
  );
}

Future<void> _pump(WidgetTester tester, Widget body) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(body: body),
    ),
  );
  await tester.pumpAndSettle();
}

/// Whether an [Opacity] of 0 sits above [finder] (origin hidden).
bool _hidden(Finder finder) => find
    .ancestor(
      of: finder,
      matching: find.byWidgetPredicate((w) => w is Opacity && w.opacity == 0),
    )
    .evaluate()
    .isNotEmpty;

/// Opens with [open], checks the origin snapshot paints at the start, then
/// closes with [close] and checks it paints again before the route pops.
Future<void> _expectCrossFade(
  WidgetTester tester, {
  required Future<void> Function() open,
  required String destination,
  required void Function() close,
}) async {
  await open();
  await tester.pump();
  expect(find.byType(RawImage), findsOneWidget);

  await tester.pumpAndSettle();
  expect(find.text(destination), findsOneWidget);
  expect(find.byType(RawImage), findsNothing);

  close();
  var sawSnapshot = false;
  // The destination unmounts on the first closing frame; step the reverse
  // morph frame by frame until the snapshot fades back in.
  for (var i = 0; i < 300 && !sawSnapshot; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    sawSnapshot |= find.byType(RawImage).evaluate().isNotEmpty;
  }
  await tester.pumpAndSettle();
  expect(sawSnapshot, isTrue);
  expect(find.text(destination), findsNothing);
}

Future<void> _fabContentCrossFades(WidgetTester tester) async {
  await _pump(
    tester,
    Center(
      child: M3EFab(
        icon: const Icon(Icons.add),
        openBuilder: (BuildContext context) => const Text('FAB dest'),
      ),
    ),
  );

  await _expectCrossFade(
    tester,
    open: () => tester.tap(find.byType(M3EFab)),
    destination: 'FAB dest',
    close: () => M3EFabContainerTransformScope.closeOf(
      tester.element(find.text('FAB dest')),
    ),
  );
  expect(_hidden(find.byIcon(Icons.add)), isFalse);
}

Future<void> _cardContentCrossFades(WidgetTester tester) async {
  await _pump(
    tester,
    Center(
      child: M3ECard(
        openBuilder: (BuildContext context) => const Text('Card dest'),
        child: const Text('Card body'),
      ),
    ),
  );

  await _expectCrossFade(
    tester,
    open: () async {
      await tester.tap(find.text('Card body'));
      await tester.pump();
      expect(_hidden(find.text('Card body')), isTrue);
    },
    destination: 'Card dest',
    close: () => M3ECardContainerTransformScope.closeOf(
      tester.element(find.text('Card dest')),
    ),
  );
  expect(_hidden(find.text('Card body')), isFalse);
}

Future<void> _listRowContentCrossFades(WidgetTester tester) async {
  await _pump(
    tester,
    M3EList(
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return const M3EListItem(headline: 'Row', transform: Text('Row dest'));
      },
    ),
  );

  await _expectCrossFade(
    tester,
    open: () async {
      await tester.tap(find.text('Row'));
      await tester.pump();
      expect(_hidden(find.text('Row')), isTrue);
    },
    destination: 'Row dest',
    close: () => M3ECardContainerTransformScope.closeOf(
      tester.element(find.text('Row dest')),
    ),
  );
  expect(_hidden(find.text('Row')), isFalse);
}

Future<void> _carouselTrackHiddenWhileShowAllOpen(WidgetTester tester) async {
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
  expect(find.byType(RawImage), findsOneWidget);
  await tester.pumpAndSettle();
  expect(find.byType(M3ECarouselShowAll), findsOneWidget);
  expect(_hidden(find.byType(M3ECarouselWrapper)), isTrue);

  M3ECardContainerTransformScope.closeOf(
    tester.element(find.byType(M3ECarouselShowAll)),
  );
  await tester.pumpAndSettle();
  expect(find.byType(M3ECarouselShowAll), findsNothing);
  expect(_hidden(find.byType(M3ECarouselWrapper)), isFalse);
}

Future<void> _carouselItemContentCrossFades(WidgetTester tester) async {
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
                transform: Text('Item dest'),
                image: SizedBox.expand(child: Text('item0')),
              ),
              M3ECarouselItem(onTap: enableCarouselItem, image: Text('item1')),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();

  // The transform opens after the tap pulse; catch its first frame.
  await tester.tap(find.byType(InkWell).first);
  var sawSnapshot = false;
  for (var i = 0; i < 100 && !sawSnapshot; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    sawSnapshot = find.byType(RawImage).evaluate().isNotEmpty;
  }
  expect(sawSnapshot, isTrue);
  expect(_hidden(find.text('item0')), isTrue);

  await tester.pumpAndSettle();
  expect(find.text('Item dest'), findsOneWidget);
  M3ECardContainerTransformScope.closeOf(
    tester.element(find.text('Item dest')),
  );
  await tester.pumpAndSettle();
  expect(find.text('Item dest'), findsNothing);
  expect(_hidden(find.text('item0')), isFalse);
}
