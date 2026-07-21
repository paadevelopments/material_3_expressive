import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host(Widget child) {
  return MaterialApp(
    home: M3ETheme(
      data: M3EThemeData.light(),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('M3EDialTimePicker scales down without overflow on narrow width',
      _dialLayout);
  testWidgets('M3EDialTimePicker toggles AM and PM', _periodToggle);
  testWidgets('M3ETimePicker.show returns null on cancel', _dialogCancel);
  testWidgets('M3ETimePicker.show returns time on confirm', _dialogConfirm);
  testWidgets('M3ETimePickerTheme overrides layout without ThemeData', _themeOverride);
  testWidgets('M3ETimePickerDialog portrait layout has no overflow', _dialogLayout);
  testWidgets('M3ETimePicker toggles to input mode without error', _inputModeToggle);
  test('M3ETimePickerUtils clamps and parses input time', _utils);
}

Future<void> _dialLayout(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(320, 640));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: M3EDialTimePicker(
              value: const M3ETime(hour: 9, minute: 30),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
}

Future<void> _periodToggle(WidgetTester tester) async {
  M3ETime? selected;
  await tester.pumpWidget(
    _host(
      M3EDialTimePicker(
        value: const M3ETime(hour: 9, minute: 30),
        onChanged: (M3ETime value) => selected = value,
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('PM').first);
  await tester.pumpAndSettle();

  expect(selected?.hour, 21);
}

Future<void> _dialogCancel(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  M3ETime? result;
  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light(),
        child: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () async {
                result = await M3ETimePicker.show(
                  context,
                  initialTime: const M3ETime(hour: 9, minute: 30),
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Cancel'));
  await tester.pumpAndSettle();

  expect(result, isNull);
}

Future<void> _dialogConfirm(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  M3ETime? result;
  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light(),
        child: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () async {
                result = await M3ETimePicker.show(
                  context,
                  initialTime: const M3ETime(hour: 9, minute: 30),
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();

  expect(result, const M3ETime(hour: 9, minute: 30));
}

Future<void> _themeOverride(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light().copyWith(
          timePickerTheme: const M3ETimePickerTheme(dialSize: 200),
        ),
        child: M3EDialTimePicker(
          value: const M3ETime(hour: 9, minute: 30),
          onChanged: (_) {},
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _dialogLayout(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light(),
        child: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () {
                M3ETimePicker.show(
                  context,
                  initialTime: const M3ETime(hour: 9, minute: 30),
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _inputModeToggle(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light(),
        child: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () {
                M3ETimePicker.show(
                  context,
                  initialTime: const M3ETime(hour: 9, minute: 30),
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    ),
  );

  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  await tester.tap(find.byTooltip('Switch to text input mode'));
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
  expect(find.text('Hour'), findsOneWidget);
  expect(find.text('Minute'), findsOneWidget);
}

void _utils() {
  expect(
    M3ETimePickerUtils.clampRaw(hour: 25, minute: 70),
    const M3ETime(hour: 23, minute: 59),
  );
  expect(
    M3ETimePickerUtils.parseInputTime(
      hourText: '09',
      minuteText: '30',
      use24HourFormat: false,
      isPm: false,
    ),
    const M3ETime(hour: 9, minute: 30),
  );
  expect(
    M3ETimePickerUtils.to24Hour(12, true),
    12,
  );
}
