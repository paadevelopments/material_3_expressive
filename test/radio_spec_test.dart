import 'dart:ui' show CheckedState, SemanticsRole;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  _registerRadioThemeTests();
  _registerRadioSelectionTests();
  _registerRadioFocusTests();
}

void _registerRadioThemeTests() {
  test('theme defaults match the radio spec', _themeDefaultsMatchTheRadioSpec);
  testWidgets(
    'control is a 48dp target around a 20dp ring',
    _controlIsA48dpTargetAroundA20dpRing,
  );
  testWidgets(
    'semantics expose a checked radio and the label',
    _semanticsExposeACheckedRadioAndTheLabel,
  );
}

void _registerRadioSelectionTests() {
  testWidgets(
    'arrows select and wrap; space does nothing when selected',
    _arrowsSelectAndWrapSpaceDoesNothingWhenSelected,
  );
  testWidgets(
    'shift tab enters on the last radio when none is selected',
    _shiftTabEntersOnTheLastRadioWhenNoneIsSelected,
  );
}

void _registerRadioFocusTests() {
  testWidgets('arrows move inside a scroll view', _arrowsMoveInsideAScrollView);
  testWidgets(
    'pointer tap clears the focus ring',
    _pointerTapClearsTheFocusRing,
  );
}

void _themeDefaultsMatchTheRadioSpec() {
  const theme = M3ERadioTheme.defaults;
  final scheme = M3EThemeData.light().colorScheme;
  _expectRadioThemeMetrics(theme);
  _expectRadioThemeColors(theme, scheme);
}

void _expectRadioThemeMetrics(M3ERadioTheme theme) {
  expect(theme.ringSize, 20);
  expect(theme.hitSize, 40);
  expect(theme.targetSize, 48);
  expect(theme.dotSize, 10);
  expect(theme.borderWidth, 2);
  expect(theme.disabledOpacity, 0.38);
  expect(theme.hoverStateLayerOpacity, 0.08);
  expect(theme.focusStateLayerOpacity, 0.1);
  expect(theme.pressedStateLayerOpacity, 0.1);
}

void _expectRadioThemeColors(M3ERadioTheme theme, M3EColorScheme scheme) {
  expect(
    theme.color(scheme, enabled: true, error: false, selected: true),
    scheme.primary,
  );
  expect(
    theme.color(scheme, enabled: true, error: false, selected: false),
    scheme.onSurfaceVariant,
  );
  expect(
    theme.color(
      scheme,
      enabled: true,
      error: false,
      selected: false,
      hovered: true,
    ),
    scheme.onSurface,
  );
  expect(
    theme.color(scheme, enabled: false, error: false, selected: true),
    M3EColorUtils.withOpacity(scheme.onSurface, 0.38),
  );
  expect(
    theme.stateLayerColor(scheme, selected: true, pressed: true),
    scheme.onSurface,
  );
  expect(
    theme.stateLayerColor(scheme, selected: false, pressed: true),
    scheme.primary,
  );
  expect(theme.stateLayerColor(scheme, selected: true), scheme.primary);
  expect(theme.stateLayerColor(scheme, selected: false), scheme.onSurface);
}

Future<void> _controlIsA48dpTargetAroundA20dpRing(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(M3ERadio<bool>(value: true, groupValue: true, onChanged: (_) {})),
  );

  expect(tester.getSize(find.byType(M3ERadio<bool>)), const Size(48, 48));

  final circles = tester
      .widgetList<Container>(find.byType(Container))
      .where(_isCircle)
      .toList();
  final sizes = circles
      .map((Container container) => tester.getSize(find.byWidget(container)))
      .toList();
  expect(sizes, contains(const Size(20, 20)));
  expect(sizes, contains(const Size(40, 40)));

  final ring = circles.firstWhere(
    (Container container) => _is20dpBorderedRing(tester, container),
  );
  final border = (ring.decoration! as BoxDecoration).border! as Border;
  expect(border.top.width, 2);
}

bool _isCircle(Container container) {
  final decoration = container.decoration;
  return decoration is BoxDecoration && decoration.shape == BoxShape.circle;
}

bool _is20dpBorderedRing(WidgetTester tester, Container container) {
  final decoration = container.decoration! as BoxDecoration;
  return decoration.border != null &&
      tester.getSize(find.byWidget(container)) == const Size(20, 20);
}

Future<void> _semanticsExposeACheckedRadioAndTheLabel(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      M3ERadioGroup<String>(
        groupValue: 'green',
        groupLabel: 'Color',
        onChanged: (_) {},
        child: M3ERadio<String>(
          value: 'green',
          groupValue: 'green',
          label: const Text('Green'),
          onChanged: (_) {},
        ),
      ),
    ),
  );

  final radio = tester.getSemantics(find.byType(M3ETappable));
  expect(radio.flagsCollection.isChecked, CheckedState.isTrue);
  expect(radio.flagsCollection.isInMutuallyExclusiveGroup, isTrue);
  expect(radio.flagsCollection.isButton, isFalse);
  expect(radio.label, contains('Green'));

  final group = tester.getSemantics(find.byType(M3ERadioGroup<String>));
  expect(group.role, SemanticsRole.radioGroup);
  expect(group.label, 'Color');
}

Future<void> _arrowsSelectAndWrapSpaceDoesNothingWhenSelected(
  WidgetTester tester,
) async {
  var plan = 'standard';
  var changes = 0;

  Future<void> pump() {
    return tester.pumpWidget(
      _planRadios(plan, (String value) {
        changes += 1;
        plan = value;
      }),
    );
  }

  await pump();
  await tester.pumpAndSettle();

  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.pump();

  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown);
  await pump();
  expect(plan, 'pro');

  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown);
  await pump();
  expect(plan, 'team');

  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown);
  await pump();
  expect(plan, 'standard');

  final before = changes;
  await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
  await tester.pump(const Duration(milliseconds: 150));
  expect(plan, 'standard');
  expect(changes, before);
}

Widget _planRadios(String plan, ValueChanged<String> onChanged) {
  return _host(
    M3ERadioGroup<String>(
      groupValue: plan,
      groupLabel: 'Plan',
      onChanged: onChanged,
      child: Column(
        children: <Widget>[
          for (final String value in <String>['standard', 'pro', 'team'])
            M3ERadio<String>(
              value: value,
              groupValue: plan,
              label: Text(value),
              onChanged: onChanged,
            ),
        ],
      ),
    ),
  );
}

Future<void> _shiftTabEntersOnTheLastRadioWhenNoneIsSelected(
  WidgetTester tester,
) async {
  final after = FocusNode();
  addTearDown(after.dispose);

  await tester.pumpWidget(_unselectedPlanRadios(after, (_) {}));
  await tester.pumpAndSettle();
  after.requestFocus();
  await tester.pump();

  await tester.sendKeyDownEvent(LogicalKeyboardKey.shift);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.shift);
  await tester.pump();

  expect(
    FocusManager.instance.primaryFocus?.context
        ?.findAncestorWidgetOfExactType<M3ERadio<String>>()
        ?.value,
    'last',
  );
}

Widget _unselectedPlanRadios(FocusNode after, ValueChanged<String> onChanged) {
  return _host(
    Column(
      children: <Widget>[
        M3ERadioGroup<String>(
          groupValue: null,
          groupLabel: 'Plan',
          onChanged: onChanged,
          child: Column(
            children: <Widget>[
              for (final String value in <String>['first', 'last'])
                M3ERadio<String>(
                  value: value,
                  groupValue: null,
                  label: Text(value),
                  onChanged: onChanged,
                ),
            ],
          ),
        ),
        Focus(focusNode: after, child: const SizedBox(width: 20, height: 20)),
      ],
    ),
  );
}

Future<void> _arrowsMoveInsideAScrollView(WidgetTester tester) async {
  var plan = 'standard';

  await tester.pumpWidget(
    _host(
      ListView(
        children: <Widget>[
          M3ERadioGroup<String>(
            groupValue: plan,
            groupLabel: 'Plan',
            onChanged: (String value) => plan = value,
            child: Column(
              children: <Widget>[
                for (final String value in <String>['standard', 'pro', 'team'])
                  M3ERadio<String>(
                    value: value,
                    groupValue: plan,
                    label: Text(value),
                    onChanged: (String next) => plan = next,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 1200),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();

  expect(plan, 'pro');
  expect(_focusedRadioValue<String>(), 'pro');
}

Future<void> _pointerTapClearsTheFocusRing(WidgetTester tester) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            M3ERadioGroup<String>(
              groupValue: 'standard',
              groupLabel: 'Plan',
              onChanged: (_) {},
              child: M3ERadio<String>(
                value: 'standard',
                groupValue: 'standard',
                label: const Text('standard'),
                onChanged: (_) {},
              ),
            ),
            const Expanded(child: SizedBox.expand()),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  M3EFocusInteraction.resetForTest();
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(_restoreAutomaticHighlight);

  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  expect(_ringVisible(tester), isTrue);

  await tester.tap(find.text('standard'));
  await tester.pump();
  await tester.pumpAndSettle();
  expect(_ringVisible(tester), isFalse);

  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  expect(_ringVisible(tester), isTrue);

  await tester.tapAt(const Offset(24, 520));
  await tester.pump();
  await tester.pumpAndSettle();
  expect(_ringVisible(tester), isFalse);
}

void _restoreAutomaticHighlight() {
  M3EFocusInteraction.resetForTest();
  FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic;
}

bool _ringVisible(WidgetTester tester) {
  return tester
      .widgetList<M3EFocusRing>(find.byType(M3EFocusRing))
      .any((M3EFocusRing ring) => ring.focused);
}

T? _focusedRadioValue<T>() {
  return FocusManager.instance.primaryFocus?.context
      ?.findAncestorWidgetOfExactType<M3ERadio<T>>()
      ?.value;
}
