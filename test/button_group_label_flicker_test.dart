import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/components/toggle_button_group/models/m3e_button_group_action.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const String _everyDay = 'Every day';
const String _daysPerWeek = 'Days per week';
const String _selectedDays = 'Selected days';

Widget _themeHost(Widget child) => MaterialApp(
  home: M3ETheme(
    data: M3EThemeData.light(),
    child: Scaffold(body: Center(child: child)),
  ),
);

List<M3EButtonGroupAction> _actions({
  required int selectedIndex,
  required List<String> labels,
}) {
  return <M3EButtonGroupAction>[
    for (var i = 0; i < labels.length; i++)
      M3EButtonGroupAction(
        label: Text(
          labels[i],
          style: TextStyle(
            color: selectedIndex == i
                ? const Color(0xFF1D1B20)
                : const Color(0xFF49454F),
            fontSize: 12,
          ),
        ),
        checkedLabel: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(labels[i]),
            const Icon(Icons.check, size: 18),
          ],
        ),
        decoration: M3EToggleButtonDecoration(
          backgroundColor: WidgetStateProperty.all(
            selectedIndex == i
                ? const Color(0xFFE8DEF8)
                : const Color(0xFFECE6F0),
          ),
        ),
      ),
  ];
}

double _maxToggleWidth(WidgetTester tester) {
  var maxWidth = 0.0;
  for (final Element element in tester.elementList(
    find.byType(M3EToggleButton),
  )) {
    final Size size = element.size!;
    if (size.width > maxWidth) {
      maxWidth = size.width;
    }
  }
  return maxWidth;
}

void main() {
  testWidgets(
    'checkedLabel rebuild with new actions keeps label widths across selection',
    _checkedLabelRebuildKeepsWidths,
  );

  testWidgets(
    'real label content change keeps interim width above icon-only fallback',
    _contentChangeKeepsInterimWidth,
  );
}

Future<void> _checkedLabelRebuildKeepsWidths(WidgetTester tester) async {
  var selectedIndex = 0;
  const labels = <String>[_everyDay, _daysPerWeek, _selectedDays];

  Widget buildGroup() {
    return _themeHost(
      SizedBox(
        height: 32,
        width: 400,
        child: M3EButtonGroup(
          selectedIndex: selectedIndex,
          size: M3EButtonSize.xs,
          spacing: 8,
          density: M3EButtonGroupDensity.compact,
          decoration: const M3EToggleButtonDecoration(
            borderRadius: 8,
            uncheckedRadius: 8,
            pressedRadius: 4,
          ),
          actions: _actions(selectedIndex: selectedIndex, labels: labels),
          onSelectedIndexChanged: (int? index) {
            selectedIndex = index ?? selectedIndex;
          },
        ),
      ),
    );
  }

  await tester.pumpWidget(buildGroup());
  await tester.pumpAndSettle();

  final double settledWidth = _maxToggleWidth(tester);
  expect(settledWidth, greaterThan(40));
  expect(find.text(_everyDay), findsWidgets);

  selectedIndex = 1;
  await tester.pumpWidget(buildGroup());
  // One frame: remotion / rebuild must not collapse to icon-only height.
  await tester.pump();

  expect(find.text(_everyDay), findsWidgets);
  expect(find.text(_daysPerWeek), findsWidgets);
  expect(_maxToggleWidth(tester), greaterThan(40));
  expect(_maxToggleWidth(tester), closeTo(settledWidth, 24));

  await tester.pumpAndSettle();
  expect(find.text(_daysPerWeek), findsWidgets);
  expect(_maxToggleWidth(tester), greaterThan(40));
}

Future<void> _contentChangeKeepsInterimWidth(WidgetTester tester) async {
  var selectedIndex = 0;
  var labels = <String>[_everyDay, _daysPerWeek, _selectedDays];

  Widget buildGroup() {
    return _themeHost(
      SizedBox(
        height: 32,
        width: 480,
        child: M3EButtonGroup(
          selectedIndex: selectedIndex,
          size: M3EButtonSize.xs,
          spacing: 8,
          density: M3EButtonGroupDensity.compact,
          actions: _actions(selectedIndex: selectedIndex, labels: labels),
          onSelectedIndexChanged: (int? index) {
            selectedIndex = index ?? selectedIndex;
          },
        ),
      ),
    );
  }

  await tester.pumpWidget(buildGroup());
  await tester.pumpAndSettle();
  final double settledWidth = _maxToggleWidth(tester);
  expect(settledWidth, greaterThan(40));

  // Force a real layout-signature change while keeping action count.
  labels = <String>['Every single day', _daysPerWeek, _selectedDays];
  selectedIndex = 0;
  await tester.pumpWidget(buildGroup());
  await tester.pump();

  // Interim frame must keep last-known widths, not icon-only (~button height).
  expect(_maxToggleWidth(tester), greaterThan(40));
  expect(find.text('Every single day'), findsWidgets);

  await tester.pumpAndSettle();
  expect(_maxToggleWidth(tester), greaterThan(40));
}
