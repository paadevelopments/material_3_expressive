import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/navigation_rail/components/m3e_nav_selection_indicator.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets(
    'M3EIconButton renders its icon and fires onPressed',
    _m3eiconbuttonRendersItsIconAndFiresOnpressed,
  );
  testWidgets(
    'M3ENavigationBar renders destinations and reports selection',
    _m3enavigationbarRendersDestinationsAndReportsSelection,
  );
  testWidgets(
    'M3ENavigationBar liquid indicator appears without interaction',
    _m3enavigationbarLiquidIndicatorAppearsWithoutInteractio,
  );
  testWidgets(
    'M3ENavigationRail renders section destinations',
    _m3enavigationrailRendersSectionDestinations,
  );
  testWidgets(
    'M3ENavigationRail supports custom expand and collapse tooltips',
    _m3enavigationrailSupportsCustomExpandAndCollapseTooltips,
  );
  testWidgets(
    'M3ENavigationRail resting indicator tracks selection while scrolling',
    _m3enavigationrailRestingIndicatorTracksSelectionWhileS,
  );
  testWidgets(
    'M3ENavigationRail indicator stays on selection after MediaQuery churn',
    _m3enavigationrailIndicatorStaysOnSelectionAfterMediaqu,
  );
  testWidgets('M3ESlider reports value changes', _m3esliderReportsValueChanges);
  testWidgets(
    'M3ENavigationBar works under a WidgetsApp with the Material delegate',
    _m3enavigationbarWorksUnderAWidgetsappWithTheMaterial,
  );
  testWidgets(
    'M3ENavigationBar autoLayout uses wide at wide breakpoint',
    _m3enavigationbarAutolayoutUsesWideAtWideBreakpoint,
  );
  testWidgets(
    'M3ENavigationBar forced wide aligns destination group',
    _m3enavigationbarForcedWideAlignsDestinationGroup,
  );
  testWidgets(
    'M3ENavigationBar supports icon-only and label-only destinations',
    _m3enavigationbarSupportsIconOnlyAndLabelOnlyDestinations,
  );
  testWidgets(
    'M3ENavigationBar wide chips use fixed equal width',
    _m3enavigationbarWideChipsUseFixedEqualWidth,
  );
  testWidgets(
    'M3ENavigationBar respects custom wideBreakpoint and width',
    _m3enavigationbarRespectsCustomWidebreakpointAndWidth,
  );
  testWidgets(
    'M3ENavigationBar pill remeasures when alignment changes',
    _m3enavigationbarPillRemeasuresWhenAlignmentChanges,
  );
  testWidgets(
    'M3ESlider renders without a Scaffold/Material ancestor',
    _m3esliderRendersWithoutAScaffoldMaterialAncestor,
  );
}

Future<void> _m3eiconbuttonRendersItsIconAndFiresOnpressed(
  WidgetTester tester,
) async {
  var taps = 0;
  await tester.pumpWidget(
    _host(
      M3EIconButton(
        icon: const Icon(M3EIcons.favorite),
        onPressed: () => taps++,
      ),
    ),
  );

  expect(find.byIcon(M3EIcons.favorite), findsOneWidget);
  await tester.tap(find.byIcon(M3EIcons.favorite));
  expect(taps, 1);
}

Future<void> _m3enavigationbarRendersDestinationsAndReportsSelection(
  WidgetTester tester,
) async {
  var selected = -1;
  await tester.pumpWidget(
    _host(
      Align(
        alignment: Alignment.bottomCenter,
        child: M3ENavigationBar(
          onDestinationSelected: (i) => selected = i,
          destinations: const <M3ENavigationBarDestination>[
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.home),
              label: 'Home',
            ),
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    ),
  );

  expect(find.text('Home'), findsOneWidget);
  await tester.tap(find.text('Search'));
  expect(selected, 1);
}

Future<void> _m3enavigationbarLiquidIndicatorAppearsWithoutInteractio(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const Align(
        alignment: Alignment.bottomCenter,
        child: M3ENavigationBar(
          destinations: <M3ENavigationBarDestination>[
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.home),
              label: 'Home',
            ),
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    ),
  );
  // Resting pill is painted by the selected destination on first build.
  await tester.pump();

  expect(find.byType(M3ENavSelectionIndicator), findsOneWidget);
  expect(find.text('Home'), findsOneWidget);
  // Selected destination's resting DecoratedBox uses a non-transparent fill.
  final Iterable<DecoratedBox> boxes = tester.widgetList<DecoratedBox>(
    find.descendant(
      of: find.byType(M3ENavigationBar),
      matching: find.byType(DecoratedBox),
    ),
  );
  expect(
    boxes.any((DecoratedBox box) {
      final Decoration d = box.decoration;
      return d is BoxDecoration && d.color != null && d.color!.a > 0;
    }),
    isTrue,
  );
}

Future<void> _m3enavigationrailRendersSectionDestinations(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      M3ENavigationRail(
        type: M3ENavigationRailType.alwaysExpand,
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        sections: const <M3ENavigationRailSection>[
          M3ENavigationRailSection(
            destinations: <M3ENavigationRailDestination>[
              M3ENavigationRailDestination(
                icon: Icon(M3EIcons.inbox),
                label: 'Inbox',
              ),
              M3ENavigationRailDestination(
                icon: Icon(M3EIcons.send),
                label: 'Sent',
              ),
            ],
          ),
        ],
      ),
    ),
  );
  await tester.pump();

  expect(find.text('Inbox'), findsWidgets);
  expect(find.byIcon(M3EIcons.inbox), findsOneWidget);
}

Future<void> _m3enavigationrailSupportsCustomExpandAndCollapseTooltips(
  WidgetTester tester,
) async {
  Widget buildRail(M3ENavigationRailType type, Key key) => M3ENavigationRail(
    key: key,
    type: type,
    expandTooltip: '展开',
    collapseTooltip: '折叠',
    selectedIndex: 0,
    onDestinationSelected: (_) {},
    sections: const <M3ENavigationRailSection>[
      M3ENavigationRailSection(
        destinations: <M3ENavigationRailDestination>[
          M3ENavigationRailDestination(
            icon: Icon(M3EIcons.inbox),
            label: 'Inbox',
          ),
        ],
      ),
    ],
  );

  await tester.pumpWidget(
    _host(
      buildRail(M3ENavigationRailType.collapsed, const ValueKey('collapsed')),
    ),
  );
  expect(find.byTooltip('展开'), findsOneWidget);

  await tester.pumpWidget(
    _host(
      buildRail(M3ENavigationRailType.expanded, const ValueKey('expanded')),
    ),
  );
  await tester.pump();
  expect(find.byTooltip('折叠'), findsOneWidget);
}

Future<void> _m3enavigationrailRestingIndicatorTracksSelectionWhileS(
  WidgetTester tester,
) async {
  final destinations = List<M3ENavigationRailDestination>.generate(
    20,
    (int i) => M3ENavigationRailDestination(
      icon: const Icon(M3EIcons.menu),
      label: 'Item $i',
    ),
  );

  await tester.pumpWidget(
    _host(
      SizedBox(
        height: 240,
        child: M3ENavigationRail(
          type: M3ENavigationRailType.alwaysExpand,
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          sections: <M3ENavigationRailSection>[
            M3ENavigationRailSection(destinations: destinations),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();

  final Finder selectedLabel = find.text('Item 0');
  final double before = tester.getTopLeft(selectedLabel).dy;

  await tester.drag(find.byType(Scrollable), const Offset(0, -40));
  await tester.pump();
  await tester.pump();

  // Resting fill is local on the destination, so it scrolls with the row.
  expect(tester.getTopLeft(selectedLabel).dy, lessThan(before));
  final Iterable<Material> materials = tester.widgetList<Material>(
    find.descendant(
      of: find.byType(M3ENavigationRail),
      matching: find.byType(Material),
    ),
  );
  expect(
    materials.any((Material m) => m.color != null && m.color!.a > 0),
    isTrue,
  );
}

Future<void> _m3enavigationrailIndicatorStaysOnSelectionAfterMediaqu(
  WidgetTester tester,
) async {
  Widget buildRail({required EdgeInsets viewInsets}) {
    return MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(viewInsets: viewInsets),
            child: Scaffold(
              body: M3ENavigationRail(
                type: M3ENavigationRailType.alwaysExpand,
                selectedIndex: 2,
                onDestinationSelected: (_) {},
                sections: const <M3ENavigationRailSection>[
                  M3ENavigationRailSection(
                    destinations: <M3ENavigationRailDestination>[
                      M3ENavigationRailDestination(
                        icon: Icon(M3EIcons.inbox),
                        label: 'Inbox',
                      ),
                      M3ENavigationRailDestination(
                        icon: Icon(M3EIcons.send),
                        label: 'Sent',
                      ),
                      M3ENavigationRailDestination(
                        icon: Icon(M3EIcons.favorite),
                        label: 'Starred',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  await tester.pumpWidget(buildRail(viewInsets: EdgeInsets.zero));
  await tester.pump();
  await tester.pump();

  final double starredY = tester.getTopLeft(find.text('Starred')).dy;

  // Simulate fullscreen search keyboard / route MediaQuery settle.
  await tester.pumpWidget(
    buildRail(viewInsets: const EdgeInsets.only(bottom: 300)),
  );
  await tester.pump();
  await tester.pump();
  await tester.pumpWidget(buildRail(viewInsets: EdgeInsets.zero));
  await tester.pump();
  await tester.pump();

  expect(tester.getTopLeft(find.text('Starred')).dy, closeTo(starredY, 1));
  final Iterable<Material> materials = tester.widgetList<Material>(
    find.descendant(
      of: find.byType(M3ENavigationRail),
      matching: find.byType(Material),
    ),
  );
  expect(
    materials.any((Material m) => m.color != null && m.color!.a > 0),
    isTrue,
  );
}

Future<void> _m3esliderReportsValueChanges(WidgetTester tester) async {
  var value = 0.5;
  await tester.pumpWidget(
    _host(
      StatefulBuilder(
        builder: (context, setState) {
          return M3ESlider(
            value: value,
            onChanged: (v) => setState(() => value = v),
          );
        },
      ),
    ),
  );

  expect(find.byType(M3ESlider), findsOneWidget);
  final Rect rect = tester.getRect(find.byType(M3ESlider));
  await tester.tapAt(Offset(rect.left + rect.width * 0.2, rect.center.dy));
  expect(value, isNot(0.5));
}

Future<void> _m3enavigationbarWorksUnderAWidgetsappWithTheMaterial(
  WidgetTester tester,
) async {
  // Mirrors the example app: no MaterialApp, just WidgetsApp + the Material
  // localizations delegate so the wrapped Material widgets can resolve.
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFF6750A4),
      pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
        return PageRouteBuilder<T>(
          settings: settings,
          pageBuilder: (context, _, _) => builder(context),
        );
      },
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      home: const Align(
        alignment: Alignment.bottomCenter,
        child: M3ENavigationBar(
          destinations: <M3ENavigationBarDestination>[
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.home),
              label: 'Home',
            ),
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(find.text('Home'), findsOneWidget);
}

Future<void> _m3enavigationbarAutolayoutUsesWideAtWideBreakpoint(
  WidgetTester tester,
) async {
  const destinations = <M3ENavigationBarDestination>[
    M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.search), label: 'Search'),
  ];
  final double breakpoint = M3ENavBarConstants.minWideBarWidth(
    destinations.length,
  );

  await tester.pumpWidget(
    _host(
      SizedBox(
        width: breakpoint,
        child: const M3ENavigationBar(
          safeArea: false,
          destinations: destinations,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(M3ENavBarConstants.layoutSettleDuration);

  expect(find.text('Home'), findsOneWidget);
  expect(find.text('Search'), findsOneWidget);
  expect(find.byType(M3ENavSelectionIndicator), findsOneWidget);

  // Below the computed breakpoint, autoLayout stays compact.
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: breakpoint - 1,
        child: const M3ENavigationBar(
          safeArea: false,
          destinations: destinations,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(M3ENavBarConstants.layoutSettleDuration);
  expect(find.text('Home'), findsOneWidget);
}

Future<void> _m3enavigationbarForcedWideAlignsDestinationGroup(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: 800,
        child: M3ENavigationBar(
          autoLayout: false,
          layout: M3ENavBarLayout.wide,
          alignment: M3ENavBarAlignment.end,
          safeArea: false,
          destinations: <M3ENavigationBarDestination>[
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.home),
              label: 'Home',
            ),
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();

  final Rect bar = tester.getRect(find.byType(M3ENavigationBar));
  final Rect search = tester.getRect(find.text('Search'));
  // Last fixed chip is flush to the trailing bar inset.
  expect(
    search.center.dx,
    closeTo(
      bar.right -
          M3ENavBarConstants.wideBarHorizontalPadding -
          M3ENavBarConstants.wideDestinationWidth / 2,
      24,
    ),
  );
  expect(search.left, greaterThan(bar.left + 100));
}

Future<void> _m3enavigationbarSupportsIconOnlyAndLabelOnlyDestinations(
  WidgetTester tester,
) async {
  var selected = -1;
  await tester.pumpWidget(
    _host(
      Align(
        alignment: Alignment.bottomCenter,
        child: M3ENavigationBar(
          autoLayout: false,
          layout: M3ENavBarLayout.wide,
          safeArea: false,
          onDestinationSelected: (int i) => selected = i,
          destinations: const <M3ENavigationBarDestination>[
            M3ENavigationBarDestination(icon: Icon(M3EIcons.home)),
            M3ENavigationBarDestination(label: 'Browse'),
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.radio),
              label: 'Radio',
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();

  expect(find.byIcon(M3EIcons.home), findsOneWidget);
  expect(find.text('Browse'), findsOneWidget);
  expect(find.text('Radio'), findsOneWidget);
  await tester.tap(find.text('Browse'));
  expect(selected, 1);
}

Future<void> _m3enavigationbarWideChipsUseFixedEqualWidth(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: 800,
        child: M3ENavigationBar(
          autoLayout: false,
          layout: M3ENavBarLayout.wide,
          safeArea: false,
          destinations: <M3ENavigationBarDestination>[
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.home),
              label: 'Home',
            ),
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.search),
              label: 'Browse',
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(M3ENavBarConstants.layoutSettleDuration);

  final Rect home = tester.getRect(find.text('Home'));
  final Rect browse = tester.getRect(find.text('Browse'));
  // Equal fixed chips: centers are one chip+gap apart regardless of icon.
  expect(
    browse.center.dx - home.center.dx,
    closeTo(
      M3ENavBarConstants.wideDestinationWidth +
          M3ENavBarConstants.wideDestinationGap,
      2,
    ),
  );
}

Future<void> _m3enavigationbarRespectsCustomWidebreakpointAndWidth(
  WidgetTester tester,
) async {
  const double customWidth = 96;
  const double customBreakpoint = 500;

  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: customBreakpoint,
        child: M3ENavigationBar(
          wideBreakpoint: customBreakpoint,
          wideDestinationWidth: customWidth,
          safeArea: false,
          destinations: <M3ENavigationBarDestination>[
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.home),
              label: 'Home',
            ),
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(M3ENavBarConstants.layoutSettleDuration);

  final Rect home = tester.getRect(find.text('Home'));
  final Rect search = tester.getRect(find.text('Search'));
  expect(
    search.center.dx - home.center.dx,
    closeTo(customWidth + M3ENavBarConstants.wideDestinationGap, 2),
  );

  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: customBreakpoint - 1,
        child: M3ENavigationBar(
          wideBreakpoint: customBreakpoint,
          wideDestinationWidth: customWidth,
          safeArea: false,
          destinations: <M3ENavigationBarDestination>[
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.home),
              label: 'Home',
            ),
            M3ENavigationBarDestination(
              icon: Icon(M3EIcons.search),
              label: 'Search',
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(M3ENavBarConstants.layoutSettleDuration);
  // Compact: equal Expanded cells across almost the full bar.
  final Rect homeCompact = tester.getRect(find.text('Home'));
  final Rect searchCompact = tester.getRect(find.text('Search'));
  expect(
    searchCompact.center.dx - homeCompact.center.dx,
    greaterThan(customWidth + M3ENavBarConstants.wideDestinationGap + 20),
  );
}

Future<void> _m3enavigationbarPillRemeasuresWhenAlignmentChanges(
  WidgetTester tester,
) async {
  const destinations = <M3ENavigationBarDestination>[
    M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.search), label: 'Search'),
  ];

  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: 800,
        child: M3ENavigationBar(
          autoLayout: false,
          layout: M3ENavBarLayout.wide,
          alignment: M3ENavBarAlignment.start,
          safeArea: false,
          destinations: destinations,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(M3ENavBarConstants.layoutSettleDuration);
  await tester.pump(const Duration(milliseconds: 50));

  final double homeLeftStart = tester.getTopLeft(find.text('Home')).dx;

  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: 800,
        child: M3ENavigationBar(
          autoLayout: false,
          layout: M3ENavBarLayout.wide,
          alignment: M3ENavBarAlignment.end,
          safeArea: false,
          destinations: destinations,
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(M3ENavBarConstants.layoutSettleDuration);
  await tester.pump(const Duration(milliseconds: 50));

  final double homeLeftEnd = tester.getTopLeft(find.text('Home')).dx;
  expect(homeLeftEnd, greaterThan(homeLeftStart + 50));

  // Resting pill should sit with the selected destination after alignment change.
  final Iterable<DecoratedBox> boxes = tester.widgetList<DecoratedBox>(
    find.descendant(
      of: find.byType(M3ENavigationBar),
      matching: find.byType(DecoratedBox),
    ),
  );
  final DecoratedBox pill = boxes.firstWhere((DecoratedBox box) {
    final Decoration d = box.decoration;
    return d is BoxDecoration && d.color != null && d.color!.a > 0;
  });
  final Rect pillRect = tester.getRect(find.byWidget(pill));
  final Rect homeRect = tester.getRect(find.text('Home'));
  expect(pillRect.left, lessThan(homeRect.left + 8));
  expect(pillRect.right, greaterThan(homeRect.right - 8));
}

Future<void> _m3esliderRendersWithoutAScaffoldMaterialAncestor(
  WidgetTester tester,
) async {
  // Components placed directly under a ListView with no Material ancestor
  // must not throw.
  await tester.pumpWidget(
    MaterialApp(
      home: ListView(
        children: <Widget>[M3ESlider(value: 0.5, onChanged: (_) {})],
      ),
    ),
  );

  expect(tester.takeException(), isNull);
  expect(find.byType(M3ESlider), findsOneWidget);
}
