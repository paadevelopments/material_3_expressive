import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'focus_nav_repro_test_support.dart';

void main() {
  setUp(setUpFocusNavReproTests);
  tearDown(tearDownFocusNavReproTests);

  registerWebStyleButtonActivateIntentTests();
  registerSelectionDialogEnterSelectsRowTests();
  registerSelectionDialogTabVisitsRowsTests();
  registerCheckboxFocusableFalseSkipsTabTests();
  registerFocusRingPaintsAboveOpaqueSiblingTests();
}

void registerWebStyleButtonActivateIntentTests() {
  testWidgets('Web-style ButtonActivateIntent activates focused button', (
    WidgetTester tester,
  ) async {
    var pressed = 0;
    final focusNode = FocusNode(debugLabel: 'btn');
    addTearDown(focusNode.dispose);

    // Mimic WidgetsApp web shortcuts: Enter → ButtonActivateIntent.
    await tester.pumpWidget(
      MaterialApp(
        shortcuts: <ShortcutActivator, Intent>{
          ...WidgetsApp.defaultShortcuts,
          const SingleActivator(LogicalKeyboardKey.enter):
              const ButtonActivateIntent(),
          const SingleActivator(LogicalKeyboardKey.numpadEnter):
              const ButtonActivateIntent(),
        },
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: M3EButton.filled(
              focusNode: focusNode,
              onPressed: () => pressed++,
              child: const Text('Go'),
            ),
          ),
        ),
      ),
    );

    M3EFocusInteraction.instance.noteKeyboardHighlight();
    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(focusNode.hasPrimaryFocus, isTrue);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);

    expect(pressed, 1);
  });
}

void registerSelectionDialogEnterSelectsRowTests() {
  testWidgets('selection dialog Enter selects focused row', (
    WidgetTester tester,
  ) async {
    List<String>? result;

    await pumpSelectionDialogEnterApp(
      tester,
      onResult: (List<String>? value) => result = value,
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Row is the Tab stop; embedded radio is not.
    final Finder optionFocus = find.descendant(
      of: find.bySemanticsLabel('B'),
      matching: find.byType(FocusableActionDetector),
    );
    final FocusableActionDetector detector = tester
        .widgetList<FocusableActionDetector>(optionFocus)
        .firstWhere((FocusableActionDetector d) => d.enabled);
    final FocusNode? node = detector.focusNode;
    expect(node, isNotNull);
    expect(node!.skipTraversal, isFalse);
    expect(node.canRequestFocus, isTrue);

    final Finder radioFocus = find.descendant(
      of: find.byType(M3ERadio<String>),
      matching: find.byType(FocusableActionDetector),
    );
    for (final FocusableActionDetector radioDetector
        in tester.widgetList<FocusableActionDetector>(radioFocus)) {
      expect(radioDetector.enabled, isFalse);
      expect(radioDetector.focusNode?.skipTraversal, isTrue);
    }

    M3EFocusInteraction.instance.noteKeyboardHighlight();
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(node.hasPrimaryFocus, isTrue);

    final M3EFocusRing rowRing = tester
        .widgetList<M3EFocusRing>(
          find.descendant(
            of: find.bySemanticsLabel('B'),
            matching: find.byType(M3EFocusRing),
          ),
        )
        .firstWhere((M3EFocusRing r) => r.focused);
    expect(rowRing.focused, isTrue);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(result, <String>['B']);
  });
}

void registerSelectionDialogTabVisitsRowsTests() {
  testWidgets('selection dialog Tab visits option rows under shell order', (
    WidgetTester tester,
  ) async {
    await pumpSelectionDialogShellOrderApp(tester);

    await tester.tap(find.text('Open selection'));
    await tester.pumpAndSettle();

    M3EFocusInteraction.instance.noteKeyboardHighlight();
    final hit = <String>{};
    for (var i = 0; i < 8; i++) {
      await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      final FocusNode? primary = FocusManager.instance.primaryFocus;
      primary?.context?.visitAncestorElements((Element element) {
        final Widget widget = element.widget;
        if (widget is Semantics && widget.properties.label != null) {
          hit.add(widget.properties.label!);
          return false;
        }
        return true;
      });
    }

    expect(
      hit.intersection(<String>{'Standard', 'Pro', 'Team'}),
      isNotEmpty,
      reason: 'Tab must reach selection rows (example-shell traversal)',
    );

    // Focused row must paint a keyboard focus ring (visible Tab feedback).
    expect(
      tester
          .widgetList<M3EFocusRing>(find.byType(M3EFocusRing))
          .any((M3EFocusRing r) => r.focused),
      isTrue,
    );
  });
}

void registerCheckboxFocusableFalseSkipsTabTests() {
  testWidgets('checkbox focusable false skips Tab traversal', (
    WidgetTester tester,
  ) async {
    final rowFocus = FocusNode(debugLabel: 'row');
    addTearDown(rowFocus.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: M3ETappable(
              focusNode: rowFocus,
              onTap: () {},
              builder: (BuildContext context, M3EInteractionState state) {
                return M3ECheckbox(
                  value: false,
                  onChanged: (_) {},
                  focusable: false,
                );
              },
            ),
          ),
        ),
      ),
    );

    final Finder checkboxDetector = find.descendant(
      of: find.byType(M3ECheckbox),
      matching: find.byType(FocusableActionDetector),
    );
    final FocusableActionDetector detector = tester.widget(checkboxDetector);
    expect(detector.enabled, isFalse);
    expect(detector.focusNode?.canRequestFocus, isFalse);
    expect(detector.focusNode?.skipTraversal, isTrue);
  });
}

void registerFocusRingPaintsAboveOpaqueSiblingTests() {
  testWidgets('focus ring paints above opaque sibling without extra gap', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: SizedBox(
                width: 120,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    M3EFocusRing(
                      focused: true,
                      radius: BorderRadius.all(Radius.circular(12)),
                      child: ColoredBox(
                        color: Color(0xFF2196F3),
                        child: SizedBox(width: 120, height: 40),
                      ),
                    ),
                    // 3dp gap — less than default ring outset (gap+width = 4).
                    SizedBox(height: 3),
                    ColoredBox(
                      color: Color(0xFFFF9800),
                      child: SizedBox(width: 120, height: 40),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // Rings only paint during keyboard navigation (setUp resets that).
    M3EFocusInteraction.instance.noteKeyboardHighlight();
    await tester.pumpAndSettle();

    final PhysicalModel model = tester.widget(
      find.descendant(
        of: find.byType(M3EFocusRing),
        matching: find.byType(PhysicalModel),
      ),
    );
    expect(model.elevation, greaterThan(0));
    expect(tester.takeException(), isNull);
  });
}
