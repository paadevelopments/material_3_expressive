import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/time_pickers/models/m3e_time.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  testWidgets('M3ETimePicker scales down without overflow on narrow width',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: M3EThemeData.light(),
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(24),
              child: M3ETimePicker(
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
  });
}
