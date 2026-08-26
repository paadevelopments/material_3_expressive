import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const String _one = 'One';
const String _two = 'Two';

Widget _themeHost(Widget child) => MaterialApp(
  home: M3ETheme(
    data: M3EThemeData.light(),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  testWidgets(
    'fitting scroll overflow keeps offset at 0 when selectedIndex changes',
    _fittingScrollKeepsOffset,
  );

  testWidgets(
    'overflowing scroll overflow keeps offset when selectedIndex changes',
    _overflowingScrollKeepsOffset,
  );
}

Future<void> _fittingScrollKeepsOffset(WidgetTester tester) async {
  var selectedIndex = 0;

  Widget buildGroup() {
    return _themeHost(
      SizedBox(
        width: 400,
        child: M3EButtonGroup(
          selectedIndex: selectedIndex,
          onSelectedIndexChanged: (int? index) {
            selectedIndex = index ?? selectedIndex;
          },
          actions: const <M3EButtonGroupAction>[
            M3EButtonGroupAction(label: Text(_one)),
            M3EButtonGroupAction(label: Text(_two)),
          ],
        ),
      ),
    );
  }

  await tester.pumpWidget(buildGroup());
  await tester.pumpAndSettle();

  expect(find.byType(SingleChildScrollView), findsOneWidget);
  final fittedView = tester.widget<SingleChildScrollView>(
    find.byType(SingleChildScrollView),
  );
  expect(fittedView.physics, isA<NeverScrollableScrollPhysics>());
  expect(fittedView.clipBehavior, Clip.none);

  final ScrollableState scrollable = tester.state<ScrollableState>(
    find.byType(Scrollable),
  );
  expect(scrollable.position.pixels, 0);
  expect(scrollable.position.maxScrollExtent, 0);

  selectedIndex = 1;
  await tester.pumpWidget(buildGroup());
  await tester.pumpAndSettle();

  expect(find.text(_one), findsWidgets);
  expect(find.text(_two), findsWidgets);
  expect(
    tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels,
    0,
  );
  expect(
    tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
        .physics,
    isA<NeverScrollableScrollPhysics>(),
  );
}

Future<void> _overflowingScrollKeepsOffset(WidgetTester tester) async {
  const longA = 'AAAAAAAAAAAAAAAA';
  const longB = 'BBBBBBBBBBBBBBBB';
  var selectedIndex = 0;

  Widget buildGroup() {
    return _themeHost(
      SizedBox(
        width: 120,
        child: M3EButtonGroup(
          selectedIndex: selectedIndex,
          onSelectedIndexChanged: (int? index) {
            selectedIndex = index ?? selectedIndex;
          },
          actions: const <M3EButtonGroupAction>[
            M3EButtonGroupAction(label: Text(longA)),
            M3EButtonGroupAction(label: Text(longB)),
          ],
        ),
      ),
    );
  }

  await tester.pumpWidget(buildGroup());
  await tester.pumpAndSettle();

  final ScrollableState scrollable = tester.state<ScrollableState>(
    find.byType(Scrollable),
  );
  expect(scrollable.position.maxScrollExtent, greaterThan(0));
  expect(
    tester
        .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
        .physics,
    isNot(isA<NeverScrollableScrollPhysics>()),
  );

  await tester.drag(find.byType(SingleChildScrollView), const Offset(-48, 0));
  await tester.pumpAndSettle();
  final offset = scrollable.position.pixels;
  expect(offset, greaterThan(0));

  selectedIndex = 1;
  await tester.pumpWidget(buildGroup());
  await tester.pumpAndSettle();

  expect(
    tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels,
    offset,
  );
}
