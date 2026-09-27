import 'package:flutter/rendering.dart';
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
    'regular content band is 64 and sits below the status bar',
    _regularContentBandSitsBelowTheStatusBar,
  );
  testWidgets(
    'flexible and baseline slivers use spec content heights',
    _flexibleAndBaselineSliversUseSpecContentHeights,
  );
  testWidgets(
    'top bar switches color when content scrolls under it',
    _topBarSwitchesColorWhenContentScrollsUnderIt,
  );
  testWidgets(
    'every sliver variant switches color when scroll starts',
    _everySliverVariantSwitchesColorWhenScrollStarts,
  );
  testWidgets(
    'search bar switches color when scroll starts',
    _searchBarSwitchesColorWhenScrollStarts,
  );
  testWidgets(
    'controller collapses and hides the sliver',
    _controllerCollapsesAndHidesTheSliver,
  );
  testWidgets(
    'M3EAppBar.sliver renders an expanded large title',
    _m3eappbarSliverRendersAnExpandedLargeTitle,
  );
  testWidgets(
    'M3EAppBar.search fills title slot and opens the search view',
    _m3eappbarSearchFillsTitleSlotAndOpensTheSearchView,
  );
  testWidgets(
    'bottom bar raises elevation when content scrolls and restores it',
    _bottomBarRaisesElevationWhenContentScrollsAndRestoresIt,
  );
  testWidgets(
    'expanded title sits below the action row and returns when collapsed',
    _expandedTitleSitsBelowTheActionRowAndReturnsWhenCollapsed,
  );
  testWidgets(
    'entire hide slides the bar away and actions hide keeps the icons',
    _entireHideSlidesTheBarAwayAndActionsHideKeepsTheIcons,
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
  expect(box.height, 56);
}

Future<void> _regularContentBandSitsBelowTheStatusBar(
  WidgetTester tester,
) async {
  tester.view.devicePixelRatio = 1;
  tester.view.viewPadding = const FakeViewPadding(top: 24);
  tester.view.padding = const FakeViewPadding(top: 24);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: const Scaffold(
        appBar: M3EAppBar.top(titleText: _inbox),
        body: SizedBox.expand(),
      ),
    ),
  );

  final Size band = tester.getSize(
    find
        .descendant(of: find.byType(M3EAppBar), matching: find.byType(SizedBox))
        .first,
  );
  expect(band.height, 64);
  expect(tester.getSize(find.byType(M3EAppBar)).height, 88);
  expect(tester.getTopLeft(find.text(_inbox)).dy, greaterThanOrEqualTo(24));
}

Future<double> _sliverExtent(
  WidgetTester tester, {
  required M3EAppBarVariant variant,
  String? subtitleText,
}) async {
  await tester.pumpWidget(
    _host(
      CustomScrollView(
        slivers: <Widget>[
          M3EAppBar.sliver(
            titleText: _inbox,
            subtitleText: subtitleText,
            variant: variant,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 2400)),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
  final RenderSliver sliver = tester.renderObject<RenderSliver>(
    find.byType(M3EAppBar),
  );
  return sliver.geometry!.maxPaintExtent;
}

Future<void> _flexibleAndBaselineSliversUseSpecContentHeights(
  WidgetTester tester,
) async {
  expect(
    await _sliverExtent(tester, variant: M3EAppBarVariant.mediumFlexible),
    112,
  );
  expect(
    await _sliverExtent(
      tester,
      variant: M3EAppBarVariant.mediumFlexible,
      subtitleText: 'New messages',
    ),
    136,
  );
  expect(
    await _sliverExtent(tester, variant: M3EAppBarVariant.largeFlexible),
    120,
  );
  expect(
    await _sliverExtent(
      tester,
      variant: M3EAppBarVariant.largeFlexible,
      subtitleText: 'New messages',
    ),
    152,
  );
  expect(await _sliverExtent(tester, variant: M3EAppBarVariant.medium), 112);
  expect(
    await _sliverExtent(
      tester,
      variant: M3EAppBarVariant.medium,
      subtitleText: 'New messages',
    ),
    136,
  );
  expect(await _sliverExtent(tester, variant: M3EAppBarVariant.large), 152);
  expect(
    await _sliverExtent(
      tester,
      variant: M3EAppBarVariant.large,
      subtitleText: 'New messages',
    ),
    184,
  );
}

Future<void> _topBarSwitchesColorWhenContentScrollsUnderIt(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        appBar: const M3EAppBar.top(titleText: _inbox),
        body: ListView(children: const <Widget>[SizedBox(height: 2400)]),
      ),
    ),
  );

  final M3EColorScheme scheme = M3ETheme.of(
    tester.element(find.byType(M3EAppBar)),
  ).colorScheme;
  Material material() {
    return tester.widget<Material>(
      find
          .descendant(
            of: find.byType(M3EAppBar),
            matching: find.byType(Material),
          )
          .first,
    );
  }

  expect(material().color, scheme.surface);
  expect(material().elevation, 0);

  await tester.drag(find.byType(ListView), const Offset(0, -400));
  await tester.pump();

  expect(material().color, scheme.surfaceContainer);
  expect(material().elevation, M3EElevation.level2);

  tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(0);
  await tester.pump();

  expect(material().color, scheme.surface);
  expect(material().elevation, 0);
}

Future<void> _everySliverVariantSwitchesColorWhenScrollStarts(
  WidgetTester tester,
) async {
  for (final M3EAppBarVariant variant in M3EAppBarVariant.values) {
    await tester.pumpWidget(
      _host(
        CustomScrollView(
          slivers: <Widget>[
            M3EAppBar.sliver(titleText: _inbox, variant: variant),
            const SliverToBoxAdapter(child: SizedBox(height: 2400)),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final M3EColorScheme scheme = M3ETheme.of(
      tester.element(find.byType(M3EAppBar)),
    ).colorScheme;
    Material material() {
      return tester.widget<Material>(
        find
            .descendant(
              of: find.byType(M3EAppBar),
              matching: find.byType(Material),
            )
            .first,
      );
    }

    expect(material().color, scheme.surface);
    expect(material().elevation, 0);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -20));
    await tester.pump();

    expect(material().color, scheme.surfaceContainer);
    expect(material().elevation, M3EElevation.level2);

    tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(0);
    await tester.pump();

    expect(material().color, scheme.surface);
    expect(material().elevation, 0);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  }
}

Future<void> _searchBarSwitchesColorWhenScrollStarts(
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
          suggestionsBuilder: (BuildContext context, M3ESearchController c) {
            return const <Widget>[];
          },
        ),
        body: ListView(children: const <Widget>[SizedBox(height: 2400)]),
      ),
    ),
  );

  final M3EColorScheme scheme = M3ETheme.of(
    tester.element(find.byType(M3EAppBar)),
  ).colorScheme;
  Material material() {
    return tester.widget<Material>(
      find
          .descendant(
            of: find.byType(M3EAppBar),
            matching: find.byType(Material),
          )
          .first,
    );
  }

  expect(material().color, scheme.surface);
  expect(material().elevation, 0);

  await tester.drag(find.byType(ListView), const Offset(0, -20));
  await tester.pump();

  expect(material().color, scheme.surfaceContainer);
  expect(material().elevation, M3EElevation.level2);

  tester
      .state<ScrollableState>(
        find.descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        ),
      )
      .position
      .jumpTo(0);
  await tester.pump();

  expect(material().color, scheme.surface);
  expect(material().elevation, 0);
}

Future<void> _controllerCollapsesAndHidesTheSliver(WidgetTester tester) async {
  final controller = M3EAppBarController();
  addTearDown(controller.dispose);

  await tester.pumpWidget(
    _host(
      CustomScrollView(
        slivers: <Widget>[
          M3EAppBar.sliver(
            controller: controller,
            titleText: _inbox,
            variant: M3EAppBarVariant.mediumFlexible,
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 4000)),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(controller.isCollapsed, isFalse);
  expect(controller.isVisible, isTrue);

  final Future<void> collapsing = controller.collapse();
  await tester.pumpAndSettle();
  await collapsing;
  expect(controller.isCollapsed, isTrue);

  final Future<void> expanding = controller.expand();
  await tester.pumpAndSettle();
  await expanding;
  expect(controller.isCollapsed, isFalse);

  final Future<void> hiding = controller.hide();
  await tester.pumpAndSettle();
  await hiding;
  expect(controller.isVisible, isFalse);

  final Future<void> showing = controller.show();
  await tester.pumpAndSettle();
  await showing;
  expect(controller.isVisible, isTrue);
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

  expect(
    find.byWidgetPredicate(
      (Widget widget) =>
          widget is Text &&
          widget.data == 'Search' &&
          widget.overflow == TextOverflow.ellipsis,
    ),
    findsOneWidget,
  );
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

Future<void> _bottomBarRaisesElevationWhenContentScrollsAndRestoresIt(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        body: ListView(children: const <Widget>[SizedBox(height: 2400)]),
        bottomNavigationBar: const M3EAppBar.bottom(
          actions: <Widget>[Icon(M3EIcons.menu)],
        ),
      ),
    ),
  );

  final M3EColorScheme scheme = M3ETheme.of(
    tester.element(find.byType(M3EAppBar)),
  ).colorScheme;
  Material material() {
    return tester.widget<Material>(
      find
          .descendant(
            of: find.byType(M3EAppBar),
            matching: find.byType(Material),
          )
          .first,
    );
  }

  expect(material().color, scheme.surfaceContainer);
  expect(material().elevation, 0);

  await tester.drag(find.byType(ListView), const Offset(0, -400));
  await tester.pump();

  expect(material().color, scheme.surfaceContainer);
  expect(material().elevation, M3EElevation.level2);

  tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(0);
  await tester.pump();

  expect(material().color, scheme.surfaceContainer);
  expect(material().elevation, 0);
}

Future<void> _expandedTitleSitsBelowTheActionRowAndReturnsWhenCollapsed(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const CustomScrollView(
        slivers: <Widget>[
          M3EAppBar.sliver(
            titleText: _large,
            variant: M3EAppBarVariant.large,
            leading: Icon(M3EIcons.menu),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 2400)),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();

  final double iconTop = tester.getTopLeft(find.byIcon(M3EIcons.menu)).dy;
  final double expandedTop = tester.getTopLeft(find.text(_large)).dy;
  expect(expandedTop, greaterThan(iconTop + 24));

  tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(400);
  await tester.pump();

  final double collapsedTop = tester.getTopLeft(find.text(_large)).dy;
  expect(collapsedTop, lessThan(expandedTop - 24));
}

Future<void> _entireHideSlidesTheBarAwayAndActionsHideKeepsTheIcons(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const CustomScrollView(
        slivers: <Widget>[
          M3EAppBar.sliver(
            titleText: _inbox,
            variant: M3EAppBarVariant.mediumFlexible,
            hideMode: M3EAppBarHideMode.entire,
            leading: Icon(M3EIcons.menu),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 4000)),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();

  final double before = tester
      .renderObject<RenderSliver>(find.byType(M3EAppBar))
      .geometry!
      .paintExtent;
  expect(before, greaterThan(64));

  await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
  await tester.pumpAndSettle();

  final double after = tester
      .renderObject<RenderSliver>(find.byType(M3EAppBar, skipOffstage: false))
      .geometry!
      .paintExtent;
  expect(after, lessThan(1));

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpAndSettle();

  await tester.pumpWidget(
    _host(
      const CustomScrollView(
        slivers: <Widget>[
          M3EAppBar.sliver(
            titleText: _inbox,
            variant: M3EAppBarVariant.mediumFlexible,
            hideMode: M3EAppBarHideMode.actions,
            leading: Icon(M3EIcons.menu),
            actions: <Widget>[Icon(M3EIcons.search)],
          ),
          SliverToBoxAdapter(child: SizedBox(height: 4000)),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.drag(find.byType(CustomScrollView), const Offset(0, -800));
  await tester.pumpAndSettle();

  expect(find.byIcon(M3EIcons.menu), findsOneWidget);
  expect(find.byIcon(M3EIcons.search), findsOneWidget);
  expect(tester.getTopLeft(find.byIcon(M3EIcons.menu)).dy, lessThan(64));
  final double kept = tester
      .renderObject<RenderSliver>(find.byType(M3EAppBar))
      .geometry!
      .paintExtent;
  expect(kept, greaterThan(48));
  expect(kept, lessThan(80));

  final M3EColorScheme scheme = M3ETheme.of(
    tester.element(find.byType(M3EAppBar)),
  ).colorScheme;
  final Material material = tester.widget<Material>(
    find
        .descendant(of: find.byType(M3EAppBar), matching: find.byType(Material))
        .first,
  );
  expect(material.color, scheme.surfaceContainerHigh);
}
