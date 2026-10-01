import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

class _Config {
  bool enabled = true;
  bool readOnly = false;
  bool obscure = false;
  bool toggle = false;
  bool leading = true;
  bool trailing = false;
  bool clear = false;
  bool error = false;
  bool counter = false;
  bool onFocusOnly = false;
  bool required = false;
  int maxLines = 1;
  int? minLines;
  int density = 0;
  String? prefix;
  String? suffix;
  String? placeholder;
  M3ETextFieldVariant variant = M3ETextFieldVariant.filled;
}

_Config _c = _Config();
late StateSetter _rebuild;
TextEditingController _controller = TextEditingController();

Widget _harness() {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          _rebuild = setState;
          final bool obscure = _c.obscure && _c.maxLines == 1;
          return SizedBox(
            width: 320,
            child: M3ETextField(
              controller: _controller,
              label: 'Label',
              supportingText: _c.error ? null : 'Supporting',
              errorText: _c.error ? 'Error' : null,
              variant: _c.variant,
              enabled: _c.enabled,
              readOnly: _c.readOnly,
              isRequired: _c.required,
              obscureText: obscure,
              showPasswordToggle: _c.toggle && _c.maxLines == 1,
              leading: _c.leading ? const Icon(M3EIcons.search) : null,
              trailing: _c.trailing ? const Icon(M3EIcons.mic) : null,
              showClearButton: _c.clear,
              supportingTextOnFocusOnly: _c.onFocusOnly,
              maxLength: _c.counter ? 20 : null,
              prefixText: _c.prefix,
              suffixText: _c.suffix,
              placeholder: _c.placeholder,
              maxLines: obscure ? 1 : _c.maxLines,
              minLines: obscure ? null : _c.minLines,
              density: _c.density,
            ),
          );
        },
      ),
    ),
  );
}

Future<void> _change(WidgetTester tester, void Function() edit) async {
  _rebuild(edit);
  await tester.pumpAndSettle();
}

/// Taps the field like a user and types one character through the IME.
Future<void> _typeWorks(WidgetTester tester, String step) async {
  await tester.tap(find.byType(EditableText));
  await tester.pumpAndSettle();
  final String before = _controller.text;
  expect(
    tester.testTextInput.hasAnyClients,
    isTrue,
    reason: 'no input connection after: $step',
  );
  tester.testTextInput.enterText('${before}x');
  await tester.pumpAndSettle();
  expect(_controller.text, '${before}x', reason: 'typing failed after: $step');
}

/// Playground-style control changes, applied in order.
final Map<String, void Function()> _steps = <String, void Function()>{
  'variant outlined': () => _c.variant = M3ETextFieldVariant.outlined,
  'leading off': () => _c.leading = false,
  'trailing on': () => _c.trailing = true,
  'clear on': () => _c.clear = true,
  'prefix': () => _c.prefix = r'$',
  'suffix': () => _c.suffix = 'lbs',
  'placeholder': () => _c.placeholder = 'Type',
  'counter on': () => _c.counter = true,
  'counter off': () => _c.counter = false,
  'error on': () => _c.error = true,
  'required on': () => _c.required = true,
  'focus-only support': () => _c.onFocusOnly = true,
  'density -3': () => _c.density = -3,
  'multi-line': () => _c.maxLines = 4,
  'text area': () => _c.minLines = 4,
  'single line': () {
    _c
      ..maxLines = 1
      ..minLines = null;
  },
  'obscure on': () => _c.obscure = true,
  'toggle on': () => _c.toggle = true,
  'obscure off': () => _c.obscure = false,
  'variant filled': () => _c.variant = M3ETextFieldVariant.filled,
  'leading on': () => _c.leading = true,
  'prefix off': () => _c.prefix = null,
  'error off': () => _c.error = false,
};

void main() {
  setUp(() {
    _c = _Config();
    _controller = TextEditingController();
  });
  tearDown(() => _controller.dispose());
  testWidgets(
    'field keeps accepting input across control changes',
    _controlChanges,
  );
  testWidgets(
    'field accepts input after disable/enable while focused',
    _disableEnable,
  );
  testWidgets(
    'field accepts input after password toggle then multi-line',
    _toggleThenMultiLine,
  );
  testWidgets('field accepts input after clear button', _afterClear);
}

Future<void> _controlChanges(WidgetTester tester) async {
  await tester.pumpWidget(_harness());
  await _typeWorks(tester, 'start');
  for (final MapEntry<String, void Function()> step in _steps.entries) {
    await _change(tester, step.value);
    await _typeWorks(tester, step.key);
  }
}

Future<void> _disableEnable(WidgetTester tester) async {
  await tester.pumpWidget(_harness());
  await _typeWorks(tester, 'start');
  await _change(tester, () => _c.enabled = false);
  await _change(tester, () => _c.enabled = true);
  await _typeWorks(tester, 're-enabled');
  await _change(tester, () => _c.readOnly = true);
  await _change(tester, () => _c.readOnly = false);
  await _typeWorks(tester, 'read-only off');
}

Future<void> _toggleThenMultiLine(WidgetTester tester) async {
  await tester.pumpWidget(_harness());
  await _change(tester, () => _c.toggle = true);
  await tester.tap(find.byIcon(M3EIcons.visibility_off));
  await tester.pumpAndSettle();
  await _change(tester, () => _c.maxLines = 4);
  await _typeWorks(tester, 'multi-line after toggle');
}

Future<void> _afterClear(WidgetTester tester) async {
  await tester.pumpWidget(_harness());
  await _change(tester, () => _c.clear = true);
  await _typeWorks(tester, 'start');
  await tester.tap(find.byIcon(M3EIcons.cancel));
  await tester.pumpAndSettle();
  tester.testTextInput.enterText('y');
  await tester.pumpAndSettle();
  expect(_controller.text, 'y', reason: 'typing failed right after clear');
}
