import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const List<M3EDropdownItem<String>> _items = <M3EDropdownItem<String>>[
  M3EDropdownItem(label: 'Flutter', value: 'flutter'),
  M3EDropdownItem(label: 'Dart', value: 'dart'),
  M3EDropdownItem(label: 'Material 3', value: 'm3'),
];

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(),
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Center(child: SizedBox(width: 320, child: child)),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'M3EDropdownMenu widget rebuild does not fire onSelectionChanged during build phase',
    _m3edropdownmenuRebuildDoesNotFireOnSelectionChangedDuringBuild,
  );

  testWidgets(
    'M3EDropdownMenu renders field with hint text',
    _m3edropdownmenuRendersFieldWithHintText,
  );
  testWidgets(
    'M3EDropdownMenu opens overlay and reports selection',
    _m3edropdownmenuOpensOverlayAndReportsSelection,
  );
  testWidgets(
    'M3EDropdownMenu single select replaces prior selection',
    _m3edropdownmenuSingleSelectReplacesPriorSelection,
  );
}

Future<void> _m3edropdownmenuRendersFieldWithHintText(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const M3EDropdownMenu<String>(
        items: _items,
        fieldStyle: M3EDropdownFieldStyle(hintText: 'Choose framework'),
      ),
    ),
  );

  expect(find.text('Choose framework'), findsOneWidget);
}

Future<void> _m3edropdownmenuOpensOverlayAndReportsSelection(
  WidgetTester tester,
) async {
  var selected = <M3EDropdownItem<String>>[];

  await tester.pumpWidget(
    _host(
      M3EDropdownMenu<String>(
        items: _items,
        fieldStyle: const M3EDropdownFieldStyle(hintText: 'Choose framework'),
        onSelectionChanged: (List<M3EDropdownItem<String>> value) {
          selected = value;
        },
      ),
    ),
  );

  await tester.tap(find.text('Choose framework'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  expect(find.text('Dart'), findsOneWidget);
  await tester.tap(find.text('Dart'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  expect(selected, hasLength(1));
  expect(selected.first.value, 'dart');
  expect(find.text('Dart'), findsWidgets);
}

Future<void> _m3edropdownmenuSingleSelectReplacesPriorSelection(
  WidgetTester tester,
) async {
  var selected = <M3EDropdownItem<String>>[];

  await tester.pumpWidget(
    _host(
      M3EDropdownMenu<String>(
        singleSelect: true,
        items: _items,
        fieldStyle: const M3EDropdownFieldStyle(hintText: 'Choose framework'),
        onSelectionChanged: (List<M3EDropdownItem<String>> value) {
          selected = value;
        },
      ),
    ),
  );

  await tester.tap(find.text('Choose framework'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  await tester.tap(find.text('Flutter'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  expect(selected, hasLength(1));
  expect(selected.first.value, 'flutter');

  await tester.tap(find.bySemanticsLabel('Choose framework'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  await tester.tap(find.text('Material 3').last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  expect(selected, hasLength(1));
  expect(selected.first.value, 'm3');
}

Future<void> _m3edropdownmenuRebuildDoesNotFireOnSelectionChangedDuringBuild(
  WidgetTester tester,
) async {
  var selectionCallCount = 0;
  List<M3EDropdownItem<String>> currentItems = _items;

  await tester.pumpWidget(
    StatefulBuilder(
      builder: (context, setState) {
        return _host(
          Column(
            children: [
              M3EDropdownMenu<String>(
                items: currentItems,
                onSelectionChanged: (_) {
                  selectionCallCount++;
                  setState(() {});
                },
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentItems = const [
                      M3EDropdownItem(label: 'Item A', value: 'a'),
                      M3EDropdownItem(label: 'Item B', value: 'b'),
                    ];
                  });
                },
                child: const Text('Update Items'),
              ),
            ],
          ),
        );
      },
    ),
  );

  expect(selectionCallCount, 0);

  // Trigger parent rebuild with updated items -> runs didUpdateWidget
  await tester.tap(find.text('Update Items'));
  await tester.pump();

  expect(tester.takeException(), isNull);
  expect(selectionCallCount, 0);
}
