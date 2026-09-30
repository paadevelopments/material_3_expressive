// Shared fixtures for the list test suite, split across
// `list_selection_reorder_test.dart` (selection/reorder/dismiss) and
// `list_expandable_test.dart` (expandable rows and sublists).
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

/// Pumps [home] inside a themed `M3EMaterialApp`/`Scaffold` and settles.
Future<void> pumpList(WidgetTester tester, Widget home) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(body: home),
    ),
  );
  await tester.pumpAndSettle();
}

/// The fill color of the `M3ECard` row containing [headline].
Color? rowColor(WidgetTester tester, String headline) {
  final Finder card = find.ancestor(
    of: find.text(headline),
    matching: find.byType(M3ECard),
  );
  return tester.widget<M3ECard>(card.first).color;
}
