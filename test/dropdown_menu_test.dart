import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

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
  testWidgets('M3EDropdownMenu renders field with hint text', (tester) async {
    await tester.pumpWidget(
      _host(
        M3EDropdownMenu<String>(
          items: _items,
          fieldStyle: const M3EDropdownFieldStyle(hintText: 'Choose framework'),
        ),
      ),
    );

    expect(find.text('Choose framework'), findsOneWidget);
  });

  testWidgets('M3EDropdownMenu opens overlay and reports selection',
      (tester) async {
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
  });

  testWidgets('M3EDropdownMenu single select replaces prior selection',
      (tester) async {
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
  });
}
