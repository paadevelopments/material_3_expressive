@TestOn('browser')
library;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

// Run with: flutter test --platform chrome test/text_field_web_autofill_test.dart

void main() {
  testWidgets(
    'web autofill id changes with the input configuration',
    _autofillIdFollowsConfig,
  );
}

String? _autofillId(MethodCall call) {
  final Object? args = call.arguments;
  final Object? config = args is List ? args[1] : args;
  final Object? autofill = (config! as Map<Object?, Object?>)['autofill'];
  return (autofill as Map<Object?, Object?>?)?['uniqueIdentifier'] as String?;
}

MethodCall _last(WidgetTester tester, String method) =>
    tester.testTextInput.log.lastWhere((MethodCall c) => c.method == method);

Future<void> _autofillIdFollowsConfig(WidgetTester tester) async {
  final node = FocusNode();
  addTearDown(node.dispose);
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: M3ETextField(
          focusNode: node,
          label: 'Password',
          obscureText: true,
          showPasswordToggle: true,
        ),
      ),
    ),
  );
  await tester.tap(find.byType(EditableText));
  await tester.pumpAndSettle();
  final String? first = _autofillId(_last(tester, 'TextInput.setClient'));
  expect(first, isNotNull);

  // Toggling visibility while focused updates the live configuration.
  await tester.tap(find.byIcon(M3EIcons.visibility));
  await tester.pumpAndSettle();
  final String? updated = _autofillId(_last(tester, 'TextInput.updateConfig'));
  expect(updated, isNot(first));

  // A reconnect must not reuse the id of the dormant engine form.
  node.unfocus();
  await tester.pumpAndSettle();
  await tester.tap(find.byType(EditableText));
  await tester.pumpAndSettle();
  final String? reconnect = _autofillId(_last(tester, 'TextInput.setClient'));
  expect(reconnect, updated);
  expect(reconnect, isNot(first));
}
