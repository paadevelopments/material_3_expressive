import 'dart:ui' show SemanticsRole;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart' show SemanticsNode;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/text_fields/components/m3e_text_field_container_painter.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'focus_ring_test_support.dart';

final M3EThemeData _theme = M3EThemeData.light(
  seedColor: const Color(0xFF6750A4),
);

M3EColorScheme get _scheme => _theme.colorScheme;

Widget _app(Widget child) {
  return M3EMaterialApp(
    data: _theme,
    home: Scaffold(
      body: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: 320, child: child),
      ),
    ),
  );
}

M3ETextFieldContainerPainter _painter(WidgetTester tester) {
  return tester
      .widgetList<CustomPaint>(find.byType(CustomPaint))
      .map((CustomPaint p) => p.painter)
      .whereType<M3ETextFieldContainerPainter>()
      .first;
}

Rect _container(WidgetTester tester) => tester.getRect(
  find
      .byWidgetPredicate(
        (Widget w) =>
            w is CustomPaint && w.painter is M3ETextFieldContainerPainter,
      )
      .first,
);

void main() {
  setUp(setUpFocusRingTests);
  tearDown(tearDownFocusRingTests);
  testWidgets('filled measurements match the spec', _filledMeasurements);
  testWidgets('outlined notch and 3dp focus outline', _outlinedNotch);
  test('color roles resolve per state', _colorRoles);
  testWidgets('hover darkens the filled indicator', _hoverState);
  testWidgets('counter limits input and is labelled', _counter);
  testWidgets('error text is an alert with an error icon', _errorAlert);
  testWidgets('disabled fields are skipped by Tab', _disabledSkipped);
  testWidgets('focus ring is secondary 3dp and hides on tap', _focusRing);
  testWidgets('clear and password toggles', _clearAndPassword);
  testWidgets('density removes 4dp per step', _density);
  testWidgets('required label and affix labels', _requiredAndAffixes);
  testWidgets('null maxLines grows without a limit', _unlimitedLines);
  testWidgets('icons and affixes follow slot alignment', _slotAlignment);
}

Future<void> _filledMeasurements(WidgetTester tester) async {
  final controller = TextEditingController(text: 'Input');
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    _app(
      M3ETextField(
        controller: controller,
        label: 'Label',
        leading: const Icon(M3EIcons.search),
        trailing: const Icon(M3EIcons.mic),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Rect box = _container(tester);
  expect(box.height, 56);
  final Rect leading = tester.getRect(find.byIcon(M3EIcons.search));
  expect(leading.left - box.left, 12);
  expect(leading.width, 24);
  final Rect trailing = tester.getRect(find.byIcon(M3EIcons.mic));
  expect(box.right - trailing.right, 12);
  final Rect input = tester.getRect(find.byType(EditableText));
  expect(input.left - leading.right, 16);
  expect(trailing.left - input.right, 16);
  expect(input.bottom, box.bottom - 8);
  expect(tester.getRect(find.text('Label')).top, box.top + 8);
  expect(tester.getRect(find.text('Label')).left, input.left);
  expect(_painter(tester).strokeWidth, 1);
  expect(_painter(tester).strokeColor, _scheme.onSurfaceVariant);
}

Future<void> _outlinedNotch(WidgetTester tester) async {
  await tester.pumpWidget(
    _app(
      const M3ETextField(label: 'Label', variant: M3ETextFieldVariant.outlined),
    ),
  );
  await tester.pumpAndSettle();
  expect(_container(tester).height, 56);
  expect(_painter(tester).notchWidth, 0);
  expect(_painter(tester).strokeColor, _scheme.outline);

  await tester.tap(find.byType(M3ETextField));
  await tester.pumpAndSettle();
  final M3ETextFieldContainerPainter painter = _painter(tester);
  expect(painter.strokeWidth, 3);
  expect(painter.strokeColor, _scheme.primary);
  // Notch starts 12dp in and pads the label by 4dp on each side.
  final Rect label = tester.getRect(find.text('Label'));
  expect(painter.notchStart, 12);
  expect(painter.notchWidth, closeTo(label.width + 8, 0.5));
  expect(label.center.dy, closeTo(_container(tester).top, 0.5));
}

void _colorRoles() {
  const theme = M3ETextFieldTheme.defaults;
  M3ETextFieldColors filled(M3ETextFieldStates s) => theme.resolveColors(
    _scheme,
    variant: M3ETextFieldVariant.filled,
    states: s,
  );
  M3ETextFieldColors outlined(M3ETextFieldStates s) => theme.resolveColors(
    _scheme,
    variant: M3ETextFieldVariant.outlined,
    states: s,
  );
  final M3ETextFieldColors enabled = filled(const M3ETextFieldStates());
  expect(enabled.container, _scheme.surfaceContainerHighest);
  expect(enabled.stroke, _scheme.onSurfaceVariant);
  expect(enabled.label, _scheme.onSurfaceVariant);
  expect(enabled.inputText, _scheme.onSurface);
  expect(enabled.caret, _scheme.primary);
  expect(enabled.focusRing, _scheme.secondary);
  final focus = filled(const M3ETextFieldStates(focused: true));
  expect(focus.label, _scheme.primary);
  expect(focus.strokeWidth, 2);
  final errorHover = filled(
    const M3ETextFieldStates(error: true, hovered: true),
  );
  expect(errorHover.stroke, _scheme.onErrorContainer);
  expect(errorHover.trailingIcon, _scheme.onErrorContainer);
  expect(errorHover.supportingText, _scheme.error);
  expect(errorHover.leadingIcon, _scheme.onSurfaceVariant);
  final errorFocus = filled(
    const M3ETextFieldStates(error: true, hovered: true, focused: true),
  );
  expect(errorFocus.label, _scheme.error);
  expect(errorFocus.caret, _scheme.error);
  expect(errorFocus.focusRing, _scheme.error);
  final disabled = filled(const M3ETextFieldStates(enabled: false));
  expect(disabled.container.a, closeTo(0.04, 0.01));
  expect(disabled.stroke.a, closeTo(0.38, 0.01));
  final outlinedHover = outlined(const M3ETextFieldStates(hovered: true));
  expect(outlinedHover.label, _scheme.onSurface);
  expect(outlinedHover.stroke, _scheme.onSurface);
  expect(outlinedHover.stateLayer.a, 0);
  final outlinedDisabled = outlined(const M3ETextFieldStates(enabled: false));
  expect(outlinedDisabled.stroke.a, closeTo(0.12, 0.01));
}

Future<void> _hoverState(WidgetTester tester) async {
  await tester.pumpWidget(_app(const M3ETextField(label: 'Label')));
  await tester.pumpAndSettle();
  final TestGesture mouse = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  addTearDown(mouse.removePointer);
  await mouse.addPointer(location: _container(tester).center);
  await tester.pumpAndSettle();
  final M3ETextFieldContainerPainter painter = _painter(tester);
  expect(painter.strokeColor, _scheme.onSurface);
  expect(painter.stateLayerColor.a, closeTo(0.08, 0.01));
}

Future<void> _counter(WidgetTester tester) async {
  final SemanticsHandle semantics = tester.ensureSemantics();
  await tester.pumpWidget(_app(const M3ETextField(label: 'Bio', maxLength: 5)));
  await tester.enterText(find.byType(EditableText), 'Hello world');
  await tester.pumpAndSettle();
  expect(find.text('5/5'), findsOneWidget);
  expect(
    find.bySemanticsLabel('Character count, 5 of 5 characters entered'),
    findsOneWidget,
  );
  semantics.dispose();
}

Future<void> _errorAlert(WidgetTester tester) async {
  final SemanticsHandle semantics = tester.ensureSemantics();
  await tester.pumpWidget(
    _app(
      const M3ETextField(
        label: 'ZIP code',
        supportingText: 'Five digits',
        errorText: 'Not a valid ZIP code',
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.text('Five digits'), findsNothing);
  final SemanticsNode alert = tester.getSemantics(
    find.bySemanticsLabel('Not a valid ZIP code').last,
  );
  expect(alert.getSemanticsData().role, SemanticsRole.alert);
  expect(find.byIcon(M3EIcons.error), findsOneWidget);
  expect(find.bySemanticsLabel('Error'), findsOneWidget);
  semantics.dispose();
}

Future<void> _disabledSkipped(WidgetTester tester) async {
  final first = FocusNode();
  final second = FocusNode();
  addTearDown(first.dispose);
  addTearDown(second.dispose);
  await tester.pumpWidget(
    _app(
      Column(
        children: <Widget>[
          M3ETextField(focusNode: first, label: 'Off', enabled: false),
          M3ETextField(focusNode: second, label: 'On'),
        ],
      ),
    ),
  );
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pumpAndSettle();
  expect(first.hasFocus, isFalse);
  expect(second.hasFocus, isTrue);
}

Future<void> _focusRing(WidgetTester tester) async {
  final node = FocusNode();
  addTearDown(node.dispose);
  await tester.pumpWidget(_app(M3ETextField(focusNode: node, label: 'Name')));
  M3EFocusInteraction.instance.noteKeyboardHighlight();
  node.requestFocus();
  await tester.pumpAndSettle();
  M3EFocusRing ring() => tester.widget<M3EFocusRing>(find.byType(M3EFocusRing));
  expect(ring().focused, isTrue);
  expect(ring().width, 3);
  expect(ring().gap, 2);
  expect(ring().color, _scheme.secondary);

  await tester.tap(find.byType(M3ETextField));
  await tester.pumpAndSettle();
  expect(node.hasFocus, isTrue);
  expect(ring().focused, isFalse);
}

Future<void> _clearAndPassword(WidgetTester tester) async {
  final controller = TextEditingController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    _app(
      Column(
        children: <Widget>[
          M3ETextField(controller: controller, showClearButton: true),
          const M3ETextField(obscureText: true, showPasswordToggle: true),
        ],
      ),
    ),
  );
  expect(find.byIcon(M3EIcons.cancel), findsNothing);
  await tester.enterText(find.byType(EditableText).first, 'abc');
  await tester.pumpAndSettle();
  await tester.tap(find.byIcon(M3EIcons.cancel));
  await tester.pumpAndSettle();
  expect(controller.text, isEmpty);
  expect(find.byIcon(M3EIcons.cancel), findsNothing);

  EditableText password() =>
      tester.widget<EditableText>(find.byType(EditableText).last);
  expect(password().obscureText, isTrue);
  await tester.tap(find.byIcon(M3EIcons.visibility));
  await tester.pumpAndSettle();
  expect(password().obscureText, isFalse);
  expect(find.byIcon(M3EIcons.visibility_off), findsOneWidget);
}

Future<void> _density(WidgetTester tester) async {
  await tester.pumpWidget(
    _app(const M3ETextField(label: 'Dense', density: -2)),
  );
  await tester.pumpAndSettle();
  expect(_container(tester).height, 48);
}

Future<void> _requiredAndAffixes(WidgetTester tester) async {
  final SemanticsHandle semantics = tester.ensureSemantics();
  final controller = TextEditingController(text: '20');
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    _app(
      M3ETextField(
        controller: controller,
        label: 'Price',
        isRequired: true,
        prefixText: '€',
        prefixSemanticsLabel: 'Euro',
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(find.text('Price*'), findsOneWidget);
  expect(find.bySemanticsLabel('Price*'), findsOneWidget);
  expect(find.bySemanticsLabel('Euro'), findsOneWidget);
  semantics.dispose();
}

Widget _multiLine(
  TextEditingController controller, {
  int? maxLines,
  M3ETextFieldSlotAlignment? icons,
  M3ETextFieldSlotAlignment? affixes,
}) {
  return _app(
    M3ETextField(
      controller: controller,
      label: 'Notes',
      leading: const Icon(M3EIcons.search),
      prefixText: '>',
      maxLines: maxLines,
      iconAlignment: icons,
      affixAlignment: affixes,
    ),
  );
}

TextEditingController _longText() {
  final controller = TextEditingController(
    text: List<String>.filled(12, 'wrapping words').join(' '),
  );
  addTearDown(controller.dispose);
  return controller;
}

Future<void> _unlimitedLines(WidgetTester tester) async {
  final TextEditingController controller = _longText();
  await tester.pumpWidget(_multiLine(controller));
  await tester.pumpAndSettle();
  expect(tester.widget<EditableText>(find.byType(EditableText)).maxLines, null);
  expect(_container(tester).height, greaterThan(56 + 24 * 3));
}

Future<void> _slotAlignment(WidgetTester tester) async {
  final TextEditingController controller = _longText();
  Future<(Rect, Rect, Rect, Rect)> layout(
    M3ETextFieldSlotAlignment alignment,
  ) async {
    await tester.pumpWidget(
      _multiLine(controller, icons: alignment, affixes: alignment),
    );
    await tester.pumpAndSettle();
    return (
      _container(tester),
      tester.getRect(find.byIcon(M3EIcons.search)),
      tester.getRect(find.text('>')),
      tester.getRect(find.byType(EditableText)),
    );
  }

  var (box, icon, prefix, input) = await layout(
    M3ETextFieldSlotAlignment.firstLine,
  );
  // Same spot as a single-line field: icon centered in the first 56dp.
  expect(icon.center.dy, closeTo(box.top + 28, 0.5));
  expect(prefix.top, closeTo(input.top, 0.5));

  (box, icon, prefix, input) = await layout(M3ETextFieldSlotAlignment.center);
  expect(icon.center.dy, closeTo(box.center.dy, 0.5));
  expect(prefix.center.dy, closeTo(input.center.dy, 0.5));

  (box, icon, prefix, input) = await layout(M3ETextFieldSlotAlignment.bottom);
  expect(icon.center.dy, closeTo(box.bottom - 28, 0.5));
  expect(prefix.bottom, closeTo(input.bottom, 0.5));
}
