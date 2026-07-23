import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host({required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: M3ETheme(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('M3ERadio label tap selects value', (WidgetTester tester) async {
    String? plan = 'standard';

    await tester.pumpWidget(
      _host(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                M3ERadio<String>(
                  value: 'standard',
                  groupValue: plan,
                  label: const Text('standard'),
                  onChanged: (String value) => setState(() => plan = value),
                ),
                M3ERadio<String>(
                  value: 'pro',
                  groupValue: plan,
                  label: const Text('pro'),
                  onChanged: (String value) => setState(() => plan = value),
                ),
              ],
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('pro'));
    await tester.pumpAndSettle();
    expect(plan, 'pro');

    await tester.tap(find.text('standard'));
    await tester.pumpAndSettle();
    expect(plan, 'standard');
  });
}
