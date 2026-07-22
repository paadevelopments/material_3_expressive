import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

const String _inbox = 'Inbox';
const String _custom = 'Custom';
const String _compact = 'Compact';
const String _large = 'Large';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('M3EAppBar.top does not imply a back button without leading',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              appBar: const M3EAppBar.top(titleText: _inbox),
              body: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return const Scaffold(
                            appBar: M3EAppBar.top(titleText: 'Details'),
                            body: SizedBox.shrink(),
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Details'), findsOneWidget);
    expect(find.byTooltip('Back'), findsNothing);
    expect(find.byType(BackButtonIcon), findsNothing);
  });

  testWidgets('M3EAppBar.top shows an explicit leading widget', (tester) async {
    await tester.pumpWidget(
      _host(
        const M3EAppBar.top(
          titleText: _inbox,
          leading: Icon(M3EIcons.menu),
        ),
      ),
    );

    expect(find.byIcon(M3EIcons.menu), findsOneWidget);
  });

  testWidgets('M3EAppBar.top honours a custom title widget and actions',
      (tester) async {
    await tester.pumpWidget(
      _host(
        const M3EAppBar.top(
          title: Text(_custom),
          actions: <Widget>[Icon(M3EIcons.search)],
        ),
      ),
    );

    expect(find.text(_custom), findsOneWidget);
    expect(find.byIcon(M3EIcons.search), findsOneWidget);
  });

  testWidgets('compact density reduces the bar height', (tester) async {
    await tester.pumpWidget(
      _host(
        const M3EAppBar.top(
          titleText: _compact,
          density: M3EAppBarDensity.compact,
        ),
      ),
    );

    final box = tester.getSize(
      find.descendant(
        of: find.byType(M3EAppBar),
        matching: find.byType(SizedBox),
      ).first,
    );
    expect(box.height, 56);
  });

  testWidgets('M3EAppBar.sliver renders an expanded large title',
      (tester) async {
    await tester.pumpWidget(
      _host(
        CustomScrollView(
          slivers: <Widget>[
            const M3EAppBar.sliver(
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
