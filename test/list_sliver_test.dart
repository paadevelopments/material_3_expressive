import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget sliver) {
  return M3EMaterialApp(
    data: M3EThemeData.light(),
    home: Scaffold(body: CustomScrollView(slivers: <Widget>[sliver])),
  );
}

M3EListItem _item(BuildContext context, int index) {
  return M3EListItem(headline: 'Row $index', onTap: () {});
}

void main() {
  testWidgets('M3EList.sliver lays out in a CustomScrollView', _plain);
  testWidgets('M3EList.sliver applies margin as sliver padding', _margin);
  testWidgets('M3EList.sliver works with selection', _selection);
  testWidgets('M3EList.sliver shows emptyBuilder', _empty);
}

Future<void> _plain(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const SliverPadding(
        padding: EdgeInsets.all(16),
        sliver: M3EList.sliver(
          variant: M3ECardVariant.filled,
          itemCount: 30,
          itemBuilder: _item,
        ),
      ),
    ),
  );
  expect(tester.takeException(), isNull);
  expect(find.text('Row 0'), findsOneWidget);
}

Future<void> _margin(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EList.sliver(
        margin: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: _item,
      ),
    ),
  );
  expect(tester.takeException(), isNull);
  expect(find.byType(SliverPadding), findsOneWidget);
}

Future<void> _selection(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EList.sliver(selection: true, itemCount: 3, itemBuilder: _item),
    ),
  );
  expect(tester.takeException(), isNull);
  expect(find.text('Row 2'), findsOneWidget);
}

Future<void> _empty(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EList.sliver(
        itemCount: 0,
        itemBuilder: _item,
        emptyBuilder: Text('Nothing here'),
      ),
    ),
  );
  expect(tester.takeException(), isNull);
  expect(find.text('Nothing here'), findsOneWidget);
}
