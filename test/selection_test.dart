import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets(
    'M3ESelection fills selected rows with the highlight color',
    _m3eselectionFillsSelectedRowsWithTheHighlightColor,
  );
  testWidgets(
    'M3ESelection selectedColor overrides the theme highlight',
    _m3eselectionSelectedColorOverridesTheThemeHighlight,
  );
}

Future<void> _pumpSelection(
  WidgetTester tester,
  M3ESelectionController controller, {
  Color? selectedColor,
}) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: M3ESelection(
        controller: controller,
        itemCount: 3,
        selectedColor: selectedColor,
        appBar: const M3ESelectionAppBar(idle: SizedBox(height: 32)),
        body: M3ECardList.builder(
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) =>
              M3EListItem(headline: 'Item $index'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Color? _rowColor(WidgetTester tester, String headline) {
  final Finder card = find.ancestor(
    of: find.text(headline),
    matching: find.byType(M3ECard),
  );
  return tester.widget<M3ECard>(card.first).color;
}

Future<void> _m3eselectionFillsSelectedRowsWithTheHighlightColor(
  WidgetTester tester,
) async {
  final controller = M3ESelectionController()..select(1);
  addTearDown(controller.dispose);

  await _pumpSelection(tester, controller);

  final M3EColorScheme scheme = M3EThemeData.light(
    seedColor: const Color(0xFF6750A4),
  ).colorScheme;
  expect(_rowColor(tester, 'Item 1'), scheme.secondaryContainer);
  expect(_rowColor(tester, 'Item 0'), isNot(scheme.secondaryContainer));
}

Future<void> _m3eselectionSelectedColorOverridesTheThemeHighlight(
  WidgetTester tester,
) async {
  final controller = M3ESelectionController()..select(2);
  addTearDown(controller.dispose);

  await _pumpSelection(
    tester,
    controller,
    selectedColor: const Color(0xFF00FF00),
  );

  expect(_rowColor(tester, 'Item 2'), const Color(0xFF00FF00));
  expect(_rowColor(tester, 'Item 1'), isNot(const Color(0xFF00FF00)));
}
