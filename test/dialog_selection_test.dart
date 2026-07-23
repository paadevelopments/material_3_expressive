import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host({required Widget child}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(800, 600)),
      child: M3ETheme(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        child: Navigator(
          onGenerateRoute: (RouteSettings settings) {
            return PageRouteBuilder<void>(
              pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return child;
              },
            );
          },
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('showSelectionScreen confirms single selection',
      (WidgetTester tester) async {
    List<String>? result;

    await tester.pumpWidget(
      _host(
        child: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () async {
                result = await M3EDialog.showSelectionScreen(
                  context,
                  title: 'Plan',
                  options: const <String>['A', 'B', 'C'],
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('OK'), findsOneWidget);
    // Confirm disabled until a selection exists.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Plan'), findsOneWidget);
    expect(result, isNull);

    await tester.tap(find.bySemanticsLabel('B'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(result, <String>['B']);
  });

  testWidgets('showSelectionScreen multiSelect returns several values',
      (WidgetTester tester) async {
    List<String>? result;

    await tester.pumpWidget(
      _host(
        child: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () async {
                result = await M3EDialog.showSelectionScreen(
                  context,
                  title: 'Topics',
                  multiSelect: true,
                  options: const <String>['Design', 'Eng'],
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Design'));
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('Eng'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(result, containsAll(<String>['Design', 'Eng']));
    expect(result, hasLength(2));
  });
}
