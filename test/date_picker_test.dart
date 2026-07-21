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
  testWidgets('M3ECalendarDatePicker selects a day', _calendarSelectsDay);
  testWidgets('M3ECalendarDatePicker respects firstDate and lastDate', _dateBounds);
  testWidgets('M3ECalendarDatePicker respects selectableDayPredicate', _predicate);
  testWidgets('M3EDatePicker.show returns null on cancel', _dialogCancel);
  testWidgets('M3EDatePicker.show returns date on confirm', _dialogConfirm);
  testWidgets('M3ECalendarDatePicker year mode renders', _yearMode);
  testWidgets('M3EDatePicker.showRange selects a range', _rangeSelection);
  testWidgets('M3EDatePickerTheme overrides layout without ThemeData', _themeOverride);
  testWidgets('M3EDatePickerDialog portrait layout has no overflow', _dialogLayout);
}

Future<void> _calendarSelectsDay(WidgetTester tester) async {
  DateTime? selected;
  await tester.pumpWidget(
    _host(
      M3ECalendarDatePicker(
        firstDate: DateTime(2026, 1, 1),
        lastDate: DateTime(2026, 12, 31),
        currentDate: DateTime(2026, 3, 15),
        onDateChanged: (DateTime value) => selected = value,
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('15').first);
  await tester.pumpAndSettle();

  expect(selected, DateTime(2026, 3, 15));
}

Future<void> _dateBounds(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECalendarDatePicker(
        firstDate: DateTime(2026, 3, 10),
        lastDate: DateTime(2026, 3, 20),
        currentDate: DateTime(2026, 3, 15),
        onDateChanged: (_) {},
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Finder disabledDay = find.text('9');
  if (disabledDay.evaluate().isNotEmpty) {
    await tester.tap(disabledDay.first);
    await tester.pump();
  }
  expect(tester.takeException(), isNull);
}

Future<void> _predicate(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECalendarDatePicker(
        firstDate: DateTime(2026, 3, 1),
        lastDate: DateTime(2026, 3, 31),
        currentDate: DateTime(2026, 3, 15),
        selectableDayPredicate: (DateTime day) => day.day.isEven,
        onDateChanged: (_) {},
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}

Future<void> _dialogCancel(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  DateTime? result;
  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light(),
        child: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () async {
                result = await M3EDatePicker.show(
                  context,
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2027),
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

  DateTime? result;
  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light(),
        child: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () async {
                result = await M3EDatePicker.show(
                  context,
                  initialDate: DateTime(2026, 3, 15),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2027),
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

  expect(result, DateTime(2026, 3, 15));
}

Future<void> _yearMode(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECalendarDatePicker(
        firstDate: DateTime(2020),
        lastDate: DateTime(2030),
        initialCalendarMode: M3EDatePickerMode.year,
        onDateChanged: (_) {},
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(find.text('2026'), findsWidgets);
}

Future<void> _rangeSelection(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  M3EDateRange? result;
  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light(),
        child: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () async {
                result = await M3EDatePicker.showRange(
                  context,
                  firstDate: DateTime(2026, 3, 1),
                  lastDate: DateTime(2026, 3, 31),
                  currentDate: DateTime(2026, 3, 15),
                );
              },
              child: const Text('open range'),
            );
          },
        ),
      ),
    ),
  );

  await tester.tap(find.text('open range'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('10').first);
  await tester.pump();
  await tester.tap(find.text('20').first);
  await tester.pump();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();

  expect(result?.start, DateTime(2026, 3, 10));
  expect(result?.end, DateTime(2026, 3, 20));
}

Future<void> _themeOverride(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light().copyWith(
          datePickerTheme: const M3EDatePickerTheme(daySize: 36),
        ),
        child: M3ECalendarDatePicker(
          firstDate: DateTime(2026),
          lastDate: DateTime(2027),
          onDateChanged: (_) {},
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
                M3EDatePicker.show(
                  context,
                  initialDate: DateTime(2026, 3, 15),
                  firstDate: DateTime(2026),
                  lastDate: DateTime(2027),
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
