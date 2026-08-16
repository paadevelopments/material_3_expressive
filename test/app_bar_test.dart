import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const String _inbox = 'Inbox';
const String _custom = 'Custom';
const String _compact = 'Compact';
const String _large = 'Large';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets(
    'M3EAppBar.top does not imply a back button without leading',
    _m3eappbarTopDoesNotImplyABackButtonWithoutLeading,
  );
  testWidgets(
    'M3EAppBar.top shows an explicit leading widget',
    _m3eappbarTopShowsAnExplicitLeadingWidget,
  );
  testWidgets(
    'M3EAppBar.top honours a custom title widget and actions',
    _m3eappbarTopHonoursACustomTitleWidgetAndActions,
  );
  testWidgets(
    'compact density reduces the bar height',
    _compactDensityReducesTheBarHeight,
  );
  testWidgets(
    'M3EAppBar.sliver renders an expanded large title',
    _m3eappbarSliverRendersAnExpandedLargeTitle,
  );
  testWidgets(
    'M3EAppBar.search fills title slot and opens the search view',
    _m3eappbarSearchFillsTitleSlotAndOpensTheSearchView,
  );
}

Future<void> _m3eappbarTopDoesNotImplyABackButtonWithoutLeading(
  WidgetTester tester,
) async {
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
}

Future<void> _m3eappbarTopShowsAnExplicitLeadingWidget(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(const M3EAppBar.top(titleText: _inbox, leading: Icon(M3EIcons.menu))),
  );

  expect(find.byIcon(M3EIcons.menu), findsOneWidget);
}

Future<void> _m3eappbarTopHonoursACustomTitleWidgetAndActions(
  WidgetTester tester,
) async {
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
}

Future<void> _compactDensityReducesTheBarHeight(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EAppBar.top(
        titleText: _compact,
        density: M3EAppBarDensity.compact,
      ),
    ),
  );

  final box = tester.getSize(
    find
        .descendant(of: find.byType(M3EAppBar), matching: find.byType(SizedBox))
        .first,
  );
  expect(box.height, 64);
}

Future<void> _m3eappbarSliverRendersAnExpandedLargeTitle(
  WidgetTester tester,
) async {
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
}

Future<void> _m3eappbarSearchFillsTitleSlotAndOpensTheSearchView(
  WidgetTester tester,
) async {
  final controller = M3ESearchController();
  addTearDown(controller.dispose);

  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        appBar: M3EAppBar.search(
          searchController: controller,
          barHintText: 'Search',
          leading: const Icon(M3EIcons.menu),
          actions: const <Widget>[
            Icon(M3EIcons.tune),
            Icon(M3EIcons.account_circle),
          ],
          suggestionsBuilder: (BuildContext context, M3ESearchController c) {
            return const <Widget>[];
          },
        ),
        body: const SizedBox.shrink(),
      ),
    ),
  );

  expect(find.text('Search'), findsOneWidget);
  expect(find.byIcon(M3EIcons.menu), findsOneWidget);
  expect(find.byIcon(M3EIcons.tune), findsOneWidget);

  final barBox = tester.getSize(find.byType(M3ESearchBar));
  final appBarBox = tester.getSize(find.byType(M3EAppBar));
  // Below max width the bar should occupy most of the toolbar (not min 360).
  expect(barBox.width, greaterThan(200));
  expect(barBox.width, lessThan(appBarBox.width));

  await tester.tap(find.byType(M3ESearchBar));
  await tester.pumpAndSettle();
  expect(controller.isOpen, isTrue);
}
