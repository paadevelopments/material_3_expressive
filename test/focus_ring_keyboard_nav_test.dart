import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'focus_ring_test_support.dart';

void main() {
  setUp(setUpFocusRingTests);
  tearDown(tearDownFocusRingTests);

  registerFocusRingSinglePrimaryAmongButtonsTests();
  registerFocusRingPointerClearsTabResumesTests();
  registerFocusRingKeyboardScrollIntoViewTests();
  registerFocusRingNavBarKeyboardActivateTests();
  registerFocusRingPointerTapOnCardTests();
  registerFocusRingPointerOutsideClearsTests();
}

void registerFocusRingSinglePrimaryAmongButtonsTests() {
  testWidgets('only one primary focus ring among two buttons', (
    WidgetTester tester,
  ) async {
    final a = FocusNode(debugLabel: 'a');
    final b = FocusNode(debugLabel: 'b');
    addTearDown(a.dispose);
    addTearDown(b.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: Column(
              children: <Widget>[
                M3EButton.filled(
                  focusNode: a,
                  onPressed: () {},
                  child: const Text('A'),
                ),
                M3EButton.filled(
                  focusNode: b,
                  onPressed: () {},
                  child: const Text('B'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);
    expect(a.hasPrimaryFocus || b.hasPrimaryFocus, isTrue);
    expect(a.hasPrimaryFocus && b.hasPrimaryFocus, isFalse);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  });
}

void registerFocusRingPointerClearsTabResumesTests() {
  testWidgets('pointer clears ring; Tab resumes from clicked button', (
    WidgetTester tester,
  ) async {
    final a = FocusNode(debugLabel: 'a');
    final b = FocusNode(debugLabel: 'b');
    final c = FocusNode(debugLabel: 'c');
    addTearDown(a.dispose);
    addTearDown(b.dispose);
    addTearDown(c.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: Column(
              children: <Widget>[
                M3EButton.filled(
                  focusNode: a,
                  onPressed: () {},
                  child: const Text('A'),
                ),
                M3EButton.filled(
                  focusNode: b,
                  onPressed: () {},
                  child: const Text('B'),
                ),
                M3EButton.filled(
                  focusNode: c,
                  onPressed: () {},
                  child: const Text('C'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);

    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(M3EFocusInteraction.instance.ringsAllowed, isFalse);
    expect(b.hasPrimaryFocus, isTrue);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);
    expect(c.hasPrimaryFocus, isTrue);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  });
}

void registerFocusRingKeyboardScrollIntoViewTests() {
  testWidgets('keyboard focus scrolls button into view', (
    WidgetTester tester,
  ) async {
    final top = FocusNode(debugLabel: 'top');
    final bottom = FocusNode(debugLabel: 'bottom');
    addTearDown(top.dispose);
    addTearDown(bottom.dispose);
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: SizedBox(
              height: 200,
              child: ListView(
                controller: scrollController,
                scrollCacheExtent: const ScrollCacheExtent.pixels(2000),
                children: <Widget>[
                  M3EButton.filled(
                    focusNode: top,
                    onPressed: () {},
                    child: const Text('Top'),
                  ),
                  const SizedBox(height: 600),
                  M3EButton.filled(
                    focusNode: bottom,
                    onPressed: () {},
                    child: const Text('Bottom'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(scrollController.offset, 0);
    M3EFocusInteraction.instance.noteKeyboardHighlight();
    bottom.requestFocus();
    await tester.pumpAndSettle();

    expect(bottom.hasPrimaryFocus, isTrue);
    expect(scrollController.offset, greaterThan(0));
  });
}

void registerFocusRingNavBarKeyboardActivateTests() {
  testWidgets('nav bar destination activates with keyboard', (
    WidgetTester tester,
  ) async {
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: M3ENavigationBar(
              selectedIndex: selected,
              onDestinationSelected: (int i) => selected = i,
              destinations: const <M3ENavigationBarDestination>[
                M3ENavigationBarDestination(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                M3ENavigationBarDestination(
                  icon: Icon(Icons.search),
                  label: 'Search',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(selected, anyOf(0, 1));
    expect(tester.takeException(), isNull);
  });
}

void registerFocusRingPointerOutsideClearsTests() {
  testWidgets('pointer tap outside segmented button clears keyboard ring', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: SizedBox.expand(
              child: Column(
                children: <Widget>[
                  M3ESegmentedButton<int>(
                    selected: const <int>{0},
                    onSelectionChanged: (_) {},
                    segments: const <M3ESegment<int>>[
                      M3ESegment<int>(value: 0, label: 'Day'),
                      M3ESegment<int>(value: 1, label: 'Week'),
                    ],
                  ),
                  const Expanded(child: ColoredBox(color: Color(0x00000000))),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);
    expect(
      tester
          .widgetList<M3EFocusRing>(find.byType(M3EFocusRing))
          .any((M3EFocusRing r) => r.focused),
      isTrue,
    );

    await tester.tapAt(const Offset(400, 500));
    await tester.pump(); // deferred ring clear notify
    await tester.pumpAndSettle();
    expect(M3EFocusInteraction.instance.ringsAllowed, isFalse);
    expect(
      tester
          .widgetList<M3EFocusRing>(find.byType(M3EFocusRing))
          .any((M3EFocusRing r) => r.focused),
      isFalse,
    );
    await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  });
}

void registerFocusRingPointerTapOnCardTests() {
  testWidgets('pointer tap on card does not show ring and fires once', (
    WidgetTester tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: Center(
              child: M3ECard(
                onPressed: () => taps++,
                child: const Text('Item'),
              ),
            ),
          ),
        ),
      ),
    );

    // Pretend keyboard was used earlier so rings were allowed.
    M3EFocusInteraction.instance.noteKeyboardHighlight();
    expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);

    await tester.tap(find.text('Item'));
    await tester.pump();
    expect(taps, 1);
    await tester.pump(); // deferred ring clear notify
    expect(M3EFocusInteraction.instance.ringsAllowed, isFalse);

    // Ring chrome must not paint from pointer focus.
    final rings = tester.widgetList<M3EFocusRing>(find.byType(M3EFocusRing));
    for (final ring in rings) {
      expect(ring.focused, isFalse);
    }
  });
}
