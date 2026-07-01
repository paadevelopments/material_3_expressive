// This is a basic Flutter integration test for the Material 3 Expressive
// component library.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders a component', (WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: M3EActions.button(label: 'Tap me', onPressed: () {}),
      ),
    );

    expect(find.text('Tap me'), findsOneWidget);
  });
}
