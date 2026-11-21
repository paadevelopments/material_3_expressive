import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const List<M3EDropdownItem<String>> _items = <M3EDropdownItem<String>>[
  M3EDropdownItem(label: 'Flutter', value: 'flutter'),
  M3EDropdownItem(label: 'Dart', value: 'dart'),
  M3EDropdownItem(label: 'Material 3', value: 'm3'),
];

Widget _host(Widget child, {double width = 320}) {
  return M3EMaterialApp(
    data: M3EThemeData.light(),
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Center(
          child: SizedBox(width: width, child: child),
        ),
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

  testWidgets(
    'long selected labels fit in a narrow dropdown',
    _longSelectedLabelsFitInNarrowDropdown,
  );

  testWidgets(
    'M3EDropdownMenu limit blocks extra multi selections',
    _m3edropdownmenuLimitBlocksExtraMultiSelections,
  );
  testWidgets(
    'system back closes the dropdown before the route',
    _systemBackClosesDropdownBeforeRoute,
  );
  testWidgets(
    'outside tap closes the dropdown without activating the page',
    _outsideTapClosesDropdownWithoutActivatingPage,
  );
  testWidgets(
    'M3EDropdownMenu removes its global focus listeners on dispose',
    _m3edropdownmenuRemovesGlobalFocusListenersOnDispose,
  );
  testWidgets(
    'M3EDropdownMenu detaches from a caller-owned controller on dispose',
    _m3edropdownmenuDetachesFromCallerOwnedControllerOnDispose,
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

  await tester.tap(
    find.bySemanticsLabel('Choose framework'),
    warnIfMissed: false,
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  await tester.tap(find.text('Material 3').last);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  expect(selected, hasLength(1));
  expect(selected.first.value, 'm3');
}

Future<void> _longSelectedLabelsFitInNarrowDropdown(WidgetTester tester) async {
  const label = 'Turn off notifications for this conversation';
  List<M3EDropdownItem<String>>? selected;

  await tester.pumpWidget(
    _host(
      M3EDropdownMenu<String>(
        singleSelect: true,
        items: const <M3EDropdownItem<String>>[
          M3EDropdownItem(label: label, value: 'mute', selected: true),
        ],
        onSelectionChanged: (items) => selected = items,
      ),
      width: 220,
    ),
  );
  await tester.pumpAndSettle();

  expect(tester.takeException(), isNull);
  final removeIcon = find.byIcon(Icons.close);
  final dropdown = find.byType(M3EDropdownMenu<String>);
  expect(removeIcon, findsOneWidget);
  expect(
    tester.getRect(removeIcon).right,
    lessThanOrEqualTo(tester.getRect(dropdown).right),
  );

  await tester.tap(removeIcon);
  await tester.pumpAndSettle();

  expect(selected, isEmpty);
  expect(find.text(label), findsNothing);
}

Future<void> _m3edropdownmenuLimitBlocksExtraMultiSelections(
  WidgetTester tester,
) async {
  var selected = <M3EDropdownItem<String>>[];

  await tester.pumpWidget(
    _host(
      M3EDropdownMenu<String>(
        limit: 2,
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
  await tester.pump(const Duration(milliseconds: 200));
  expect(selected, hasLength(1));

  await tester.tap(find.text('Dart'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(selected, hasLength(2));

  await tester.tap(find.text('Material 3'));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(selected, hasLength(2));
  expect(
    selected.map((M3EDropdownItem<String> i) => i.value),
    containsAll(<String>['flutter', 'dart']),
  );
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

Future<void> _pumpDropdown(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _systemBackClosesDropdownBeforeRoute(WidgetTester tester) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) {
                      return const Scaffold(
                        body: M3EDropdownMenu<String>(
                          items: _items,
                          fieldStyle: M3EDropdownFieldStyle(
                            hintText: 'Choose framework',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              child: const Text('Root'),
            ),
          );
        },
      ),
    ),
  );
  await tester.tap(find.text('Root'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Choose framework'));
  await _pumpDropdown(tester);
  expect(find.text('Dart'), findsOneWidget);

  await tester.binding.handlePopRoute();
  await _pumpDropdown(tester);

  expect(find.text('Dart'), findsNothing);
  expect(find.text('Choose framework'), findsOneWidget);

  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();

  expect(find.text('Choose framework'), findsNothing);
  expect(find.text('Root'), findsOneWidget);
}

Future<void> _outsideTapClosesDropdownWithoutActivatingPage(
  WidgetTester tester,
) async {
  var behindTapped = false;

  await tester.pumpWidget(
    _host(
      Column(
        children: <Widget>[
          TextButton(
            onPressed: () => behindTapped = true,
            child: const Text('Behind'),
          ),
          const SizedBox(height: 240),
          const M3EDropdownMenu<String>(
            items: _items,
            fieldStyle: M3EDropdownFieldStyle(hintText: 'Choose framework'),
          ),
        ],
      ),
    ),
  );

  await tester.tap(find.text('Choose framework'));
  await _pumpDropdown(tester);
  expect(find.text('Dart'), findsOneWidget);

  await tester.tap(find.text('Behind'), warnIfMissed: false);
  await _pumpDropdown(tester);

  expect(behindTapped, isFalse);
  expect(find.text('Dart'), findsNothing);
  expect(find.text('Behind'), findsOneWidget);
}

Future<void> _m3edropdownmenuRemovesGlobalFocusListenersOnDispose(
  WidgetTester tester,
) async {
  // The menu registers on the `M3EFocusInteraction` singleton while mounted
  // and must detach on dispose; otherwise the singleton keeps the State ->
  // FocusNode -> popped route element tree alive for the process lifetime.
  expect(M3EFocusInteraction.instance.hasListeners, isFalse);

  await tester.pumpWidget(
    _host(
      const M3EDropdownMenu<String>(
        items: _items,
        fieldStyle: M3EDropdownFieldStyle(hintText: 'Choose framework'),
      ),
    ),
  );
  expect(M3EFocusInteraction.instance.hasListeners, isTrue);

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();

  expect(M3EFocusInteraction.instance.hasListeners, isFalse);
}

Future<void> _m3edropdownmenuDetachesFromCallerOwnedControllerOnDispose(
  WidgetTester tester,
) async {
  final controller = M3EDropdownController<String>();
  addTearDown(controller.dispose);

  await tester.pumpWidget(
    _host(
      M3EDropdownMenu<String>(
        items: _items,
        controller: controller,
        fieldStyle: const M3EDropdownFieldStyle(hintText: 'Choose framework'),
      ),
    ),
  );
  expect(controller.hasListeners, isTrue);

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump();

  expect(controller.hasListeners, isFalse);
}
