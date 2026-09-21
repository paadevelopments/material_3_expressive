import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) => MaterialApp(
  home: M3ETheme(
    data: M3EThemeData.light(),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  testWidgets('multiSelect toggles multiple actions independently', (
    WidgetTester tester,
  ) async {
    var selected = <int>{0};

    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) {
            return M3EButtonGroup(
              multiSelect: true,
              selectedIndices: selected,
              onSelectedIndicesChanged: (next) {
                setState(() => selected = next);
              },
              overflow: M3EButtonGroupOverflow.none,
              neighborSquish: false,
              actions: const <M3EButtonGroupAction>[
                M3EButtonGroupAction(label: Text('Mon')),
                M3EButtonGroupAction(label: Text('Tue')),
                M3EButtonGroupAction(label: Text('Wed')),
              ],
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(selected, <int>{0});

    await tester.tap(find.text('Tue').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, <int>{0, 1});

    await tester.tap(find.text('Wed').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, <int>{0, 1, 2});

    await tester.tap(find.text('Mon').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, <int>{1, 2});
  });

  testWidgets('multiSelect selectionRequired blocks clearing the last item', (
    WidgetTester tester,
  ) async {
    var selected = <int>{1};

    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) {
            return M3EButtonGroup(
              multiSelect: true,
              selectionRequired: true,
              selectedIndices: selected,
              onSelectedIndicesChanged: (next) {
                setState(() => selected = next);
              },
              overflow: M3EButtonGroupOverflow.none,
              neighborSquish: false,
              actions: const <M3EButtonGroupAction>[
                M3EButtonGroupAction(label: Text('A')),
                M3EButtonGroupAction(label: Text('B')),
              ],
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('B').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, <int>{1});
  });
}
