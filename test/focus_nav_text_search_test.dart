import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'focus_nav_repro_test_support.dart';

void main() {
  setUp(setUpFocusNavReproTests);
  tearDown(tearDownFocusNavReproTests);

  registerSearchBarStaysFocusedEditableTests();
  registerTextFieldKeepsTextInputClientTests();
  registerFocusRingFocusedToggleRemountTests();
  registerEscapeUnfocusesTextFieldTests();
  registerSearchAnchorBarTabStopTests();
}

void registerSearchBarStaysFocusedEditableTests() {
  testWidgets('Search bar stays focused and editable after Tab shows ring', (
    WidgetTester tester,
  ) async {
    final before = FocusNode(debugLabel: 'before');
    final search = FocusNode(debugLabel: 'search');
    final controller = TextEditingController();
    addTearDown(before.dispose);
    addTearDown(search.dispose);
    addTearDown(controller.dispose);

    await pumpSearchBarTabApp(
      tester,
      before: before,
      search: search,
      controller: controller,
    );

    before.requestFocus();
    await tester.pumpAndSettle();
    await pumpFocusNavTab(tester);

    expect(search.hasPrimaryFocus, isTrue);
    expect(M3EFocusRing.shouldShow(search), isTrue);
    expect(
      tester.testTextInput.hasAnyClients,
      isTrue,
      reason: 'Search EditableText must keep a text-input client with ring on',
    );

    tester.testTextInput.enterText('query');
    await tester.pump();
    expect(controller.text, 'query');
    expect(search.hasPrimaryFocus, isTrue);
  });
}

void registerTextFieldKeepsTextInputClientTests() {
  testWidgets('Text field keeps text-input client after Tab shows ring', (
    WidgetTester tester,
  ) async {
    final before = FocusNode(debugLabel: 'before');
    final field = FocusNode(debugLabel: 'field');
    final controller = TextEditingController();
    addTearDown(before.dispose);
    addTearDown(field.dispose);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: Column(
              children: <Widget>[
                M3EButton.filled(
                  focusNode: before,
                  onPressed: () {},
                  child: const Text('Before'),
                ),
                M3ETextField(
                  focusNode: field,
                  controller: controller,
                  label: 'Name',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    before.requestFocus();
    await tester.pumpAndSettle();
    await pumpFocusNavTab(tester);

    expect(field.hasPrimaryFocus, isTrue);
    expect(M3EFocusRing.shouldShow(field), isTrue);
    expect(
      tester.testTextInput.hasAnyClients,
      isTrue,
      reason: 'Focus ring must not remount EditableText (client was dropped before)',
    );

    tester.testTextInput.enterText('hi');
    await tester.pump();
    expect(controller.text, 'hi');
    expect(field.hasPrimaryFocus, isTrue);
  });
}

void registerFocusRingFocusedToggleRemountTests() {
  testWidgets('M3EFocusRing focused toggle does not remount child Element', (
    WidgetTester tester,
  ) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: M3EFocusRing(
              radius: BorderRadius.circular(8),
              child: SizedBox(key: key, width: 40, height: 40),
            ),
          ),
        ),
      ),
    );
    final before = key.currentContext! as Element;

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: M3EFocusRing(
              focused: true,
              radius: BorderRadius.circular(8),
              child: SizedBox(key: key, width: 40, height: 40),
            ),
          ),
        ),
      ),
    );
    final after = key.currentContext! as Element;
    expect(
      identical(before, after),
      isTrue,
      reason: 'Toggling focused must reuse the child Element',
    );
  });
}

void registerEscapeUnfocusesTextFieldTests() {
  testWidgets('Escape unfocuses text field during keyboard ring', (
    WidgetTester tester,
  ) async {
    final field = FocusNode(debugLabel: 'field');
    addTearDown(field.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: M3ETextField(focusNode: field, label: 'Name'),
          ),
        ),
      ),
    );

    M3EFocusInteraction.instance.noteKeyboardHighlight();
    field.requestFocus();
    await tester.pumpAndSettle();
    expect(field.hasPrimaryFocus, isTrue);
    expect(M3EFocusRing.shouldShow(field), isTrue);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);

    expect(field.hasPrimaryFocus, isFalse);
    expect(M3EFocusRing.shouldShow(field), isFalse);
  });
}

void registerSearchAnchorBarTabStopTests() {
  testWidgets('SearchAnchor.bar is a Tab stop with focus ring', (
    WidgetTester tester,
  ) async {
    final before = FocusNode(debugLabel: 'before');
    addTearDown(before.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: Column(
              children: <Widget>[
                M3EButton.filled(
                  focusNode: before,
                  onPressed: () {},
                  child: const Text('Before'),
                ),
                M3ESearchAnchor.bar(
                  searchController: M3ESearchController(),
                  suggestionsBuilder:
                      (
                        BuildContext context,
                        M3ESearchController controller,
                      ) async {
                        return const <Widget>[];
                      },
                  barHintText: 'Anchored search',
                ),
              ],
            ),
          ),
        ),
      ),
    );

    M3EFocusInteraction.instance.noteKeyboardHighlight();
    before.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    expect(before.hasPrimaryFocus, isFalse);
    expect(
      FocusManager.instance.primaryFocus?.debugLabel,
      'M3ESearchAnchorBar',
    );
    expect(
      M3EFocusRing.shouldShow(FocusManager.instance.primaryFocus!),
      isTrue,
    );
  });
}
