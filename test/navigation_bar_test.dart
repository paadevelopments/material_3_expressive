import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/navigation_rail/components/m3e_nav_selection_indicator.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets(
    'M3ENavigationBar renders destinations and reports selection',
    _m3enavigationbarRendersDestinationsAndReportsSelection,
  );
  testWidgets(
    'M3ENavigationBar liquid indicator appears without interaction',
    _m3enavigationbarLiquidIndicatorAppearsWithoutInteractio,
  );
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
