import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'focus_ring_test_support.dart';

void main() {
  setUp(setUpFocusRingTests);
  tearDown(tearDownFocusRingTests);

  registerFocusRingPaintsWhenFocusedTests();
  registerFocusRingThemeColorOverrideTests();
  registerFocusRingButtonTraditionalHighlightTests();
  registerFocusRingCheckboxSharedThemeTests();
  registerFocusRingIndicatorsDisabledTests();
}

void registerFocusRingPaintsWhenFocusedTests() {
  testWidgets('M3EFocusRing paints when focused', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: M3EFocusRing(
                focused: true,
                radius: BorderRadius.all(Radius.circular(12)),
                child: SizedBox(width: 80, height: 40),
              ),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(M3EFocusRing), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

void registerFocusRingThemeColorOverrideTests() {
  testWidgets('focusRingTheme color override applies', (
    WidgetTester tester,
  ) async {
    const override = Color(0xFFAA00FF);
    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light().copyWith(
            focusRingTheme: const M3EFocusRingTheme(color: override),
          ),
          child: Builder(
            builder: (BuildContext context) {
              final Color resolved = M3ETheme.of(context).focusRingTheme
                  .resolveColor(M3ETheme.of(context).colorScheme);
              expect(resolved, override);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  });
}

void registerFocusRingButtonTraditionalHighlightTests() {
  testWidgets('M3EButton shows focus ring under traditional highlight', (
    WidgetTester tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: Center(
              child: M3EButton.filled(
                focusNode: focusNode,
                onPressed: () {},
                child: const Text('Go'),
              ),
            ),
          ),
        ),
      ),
    );

    M3EFocusInteraction.instance.noteKeyboardHighlight();
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);
    expect(find.byType(M3EFocusRing), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

void registerFocusRingCheckboxSharedThemeTests() {
  testWidgets('checkbox focus ring uses shared theme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(body: M3ECheckbox(value: false, onChanged: (_) {})),
        ),
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(find.byType(M3EFocusRing), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

void registerFocusRingIndicatorsDisabledTests() {
  testWidgets('keyboardFocusIndicators false hides focus rings', (
    WidgetTester tester,
  ) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light().copyWith(keyboardFocusIndicators: false),
          child: Scaffold(
            body: Column(
              children: <Widget>[
                const M3EFocusRing(
                  focused: true,
                  radius: BorderRadius.all(Radius.circular(8)),
                  child: SizedBox(width: 40, height: 40),
                ),
                M3EButton.filled(
                  focusNode: focusNode,
                  onPressed: () {},
                  child: const Text('Go'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    M3EFocusInteraction.instance.noteKeyboardHighlight();
    focusNode.requestFocus();
    await tester.pumpAndSettle();

    expect(focusNode.hasPrimaryFocus, isTrue);
    expect(
      M3EFocusRing.shouldShow(
        focusNode,
        tester.element(find.byType(M3EButton)),
      ),
      isFalse,
    );

    final PhysicalModel forcedRing = tester.widget(
      find.descendant(
        of: find.byType(M3EFocusRing).first,
        matching: find.byType(PhysicalModel),
      ),
    );
    expect(forcedRing.elevation, 0);

    // Button shouldShow respects the theme flag (no painted ring chrome).
    expect(
      tester
          .widgetList<PhysicalModel>(
            find.descendant(
              of: find.byType(M3EButton),
              matching: find.byType(PhysicalModel),
            ),
          )
          .every((PhysicalModel m) => m.elevation == 0),
      isTrue,
    );
  });
}
