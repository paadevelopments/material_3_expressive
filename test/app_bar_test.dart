import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

const String _inbox = 'Inbox';
const String _custom = 'Custom';
const String _compact = 'Compact';
const String _large = 'Large';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('M3ETopAppBar renders its title text', (tester) async {
    await tester.pumpWidget(
      _host(const M3ETopAppBar(titleText: _inbox)),
    );

    expect(find.text(_inbox), findsOneWidget);
  });

  testWidgets('M3ETopAppBar honours a custom title widget and actions',
      (tester) async {
    await tester.pumpWidget(
      _host(
        const M3ETopAppBar(
          title: Text(_custom),
          actions: <Widget>[Icon(Icons.search)],
        ),
      ),
    );

    expect(find.text(_custom), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
  });

  testWidgets('compact density reduces the bar height', (tester) async {
    await tester.pumpWidget(
      _host(
        const M3ETopAppBar(
          titleText: _compact,
          density: M3EAppBarDensity.compact,
        ),
      ),
    );

    final box = tester.getSize(
      find.descendant(
        of: find.byType(M3ETopAppBar),
        matching: find.byType(SizedBox),
      ).first,
    );
    expect(box.height, 56);
  });

  testWidgets('M3ESliverAppBar renders an expanded large title',
      (tester) async {
    await tester.pumpWidget(
      _host(
        CustomScrollView(
          slivers: <Widget>[
            const M3ESliverAppBar(
              titleText: _large,
              variant: M3EAppBarVariant.large,
            ),
            SliverList.list(
              children: <Widget>[
                for (int i = 0; i < 20; i++)
                  SizedBox(height: 48, child: Text('row$i')),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(_large), findsWidgets);
  });
}
