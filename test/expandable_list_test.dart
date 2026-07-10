import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

const List<M3EExpandableData> _items = <M3EExpandableData>[
  M3EExpandableData(
    title: 'Battery level low',
    subtitle: 'Plug in your device.',
    body: Text('Your battery is at 10%.'),
  ),
  M3EExpandableData(
    title: 'System update available',
    subtitle: 'Version 2.4.0 is ready.',
    body: Text('This update includes security fixes.'),
  ),
];

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(),
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Center(child: SizedBox(width: 400, child: child)),
      ),
    ),
  );
}

void main() {
  testWidgets('M3EExpandableList renders item titles', (tester) async {
    await tester.pumpWidget(
      _host(
        M3EExpandableList(data: _items),
      ),
    );

    expect(find.text('Battery level low'), findsOneWidget);
    expect(find.text('System update available'), findsOneWidget);
  });

  testWidgets('M3EExpandableList expands item and reports change',
      (tester) async {
    int? changedIndex;
    bool? changedExpanded;

    await tester.pumpWidget(
      _host(
        M3EExpandableList(
          data: _items,
          onExpansionChanged: (int index, {required bool isExpanded}) {
            changedIndex = index;
            changedExpanded = isExpanded;
          },
        ),
      ),
    );

    await tester.tap(find.text('Battery level low'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(changedIndex, 0);
    expect(changedExpanded, isTrue);
    expect(find.text('Your battery is at 10%.'), findsOneWidget);
  });

  testWidgets('M3EExpandableList single-expand collapses prior item',
      (tester) async {
    final expandedEvents = <int>[];

    await tester.pumpWidget(
      _host(
        M3EExpandableList(
          data: _items,
          allowMultipleExpanded: false,
          onExpansionChanged: (int index, {required bool isExpanded}) {
            if (isExpanded) {
              expandedEvents.add(index);
            }
          },
        ),
      ),
    );

    await tester.tap(find.text('Battery level low'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(expandedEvents, <int>[0]);

    await tester.tap(find.text('System update available'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(expandedEvents, <int>[0, 1]);
    expect(find.text('This update includes security fixes.'), findsOneWidget);
  });
}
