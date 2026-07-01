// This is a basic Flutter widget test for the example app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:material_3_expressive_example/main.dart';

void main() {
  testWidgets('Example app renders the gallery', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pump();

    expect(find.text('Material 3 Expressive'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Filled'), findsOneWidget);
  });

  testWidgets('Every gallery page renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pump();

    const Map<String, String> pages = <String, String>{
      'Selection': 'Checkbox',
      'Containment': 'Cards',
      'Navigation': 'App bars',
      'Feedback': 'Badges',
      'Actions': 'Buttons',
    };

    for (final MapEntry<String, String> page in pages.entries) {
      await tester.tap(find.text(page.key));
      // Avoid pumpAndSettle: indeterminate indicators animate indefinitely.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));

      expect(find.text(page.value), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('Overlays present over the app', (WidgetTester tester) async {
    await tester.pumpWidget(const ExampleApp());
    await tester.pump();

    // Containment page hosts the dialog trigger.
    await tester.tap(find.text('Containment'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    final Finder dialogTrigger = find.text('Dialog');
    await tester.scrollUntilVisible(
      dialogTrigger,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(dialogTrigger);
    await tester.pump();
    await tester.tap(dialogTrigger);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Reset settings?'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
