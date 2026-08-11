// Basic Flutter widget tests for the catalog-driven example app.

import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive_example/main.dart';

void main() {
  testWidgets('Example app renders the gallery shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pump();

    expect(find.text('Material 3 Expressive'), findsOneWidget);
    expect(find.text('Do'), findsWidgets);
    expect(find.text('Buttons'), findsOneWidget);
  });

  testWidgets('Every section list renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pump();

    const Map<String, String> pages = <String, String>{
      'Pick': 'Checkbox',
      'View': 'Cards',
      'Nav': 'App bars',
      'Find': 'Badges',
      'Do': 'Buttons',
    };

    for (final MapEntry<String, String> page in pages.entries) {
      await tester.tap(find.text(page.key).last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text(page.value), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Do opens Buttons playground', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pump();

    await tester.tap(find.text('Buttons'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('Controls'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
