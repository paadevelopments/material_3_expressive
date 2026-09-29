import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/app_bar_test_helpers.dart';

void main() {
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
    'bottom bar keeps flat elevation and color regardless of scroll',
    _bottomBarKeepsFlatElevationAndColorRegardlessOfScroll,
  );
  testWidgets(
    'auto hide slide does not twitch the bar or the body',
    _autoHideSlideDoesNotTwitchTheBarOrTheBody,
  );
  testWidgets('actions hide colors the overlay', _actionsHideColorsTheOverlay);
  testWidgets(
    'an overlay scrollable does not clear scroll-under',
    _overlayScrollableDoesNotClearScrollUnder,
  );
  testWidgets(
    'desktop scroll-under ignores an idle list',
    _desktopScrollUnderIgnoresAnIdleList,
  );
  testWidgets(
    'refresh cycle does not freeze scroll-under',
    _refreshCycleDoesNotFreezeScrollUnder,
  );
  testWidgets(
    'replacing the page scrollable does not throw',
    _replacingThePageScrollableDoesNotThrow,
  );
}

Future<void> _topBarSwitchesColorWhenContentScrollsUnderIt(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        appBar: const M3EAppBar.top(titleText: appBarInboxTitle),
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
  expect(material().elevation, 0);

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
      hostAppBar(
        CustomScrollView(
          slivers: <Widget>[
            M3EAppBar.sliver(titleText: appBarInboxTitle, variant: variant),
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
    expect(material().elevation, 0);

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
  expect(material().elevation, 0);

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

Future<void> _bottomBarKeepsFlatElevationAndColorRegardlessOfScroll(
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
  expect(material().elevation, 0);

  tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(0);
  await tester.pump();

  expect(material().color, scheme.surfaceContainer);
  expect(material().elevation, 0);
}

Future<void> _autoHideSlideDoesNotTwitchTheBarOrTheBody(
  WidgetTester tester,
) async {
  await _slideAppBarAndExpectNoTwitch(tester, M3EAppBarHideMode.entire);
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpAndSettle();
  await _slideAppBarAndExpectNoTwitch(tester, M3EAppBarHideMode.actions);
}

Future<void> _slideAppBarAndExpectNoTwitch(
  WidgetTester tester,
  M3EAppBarHideMode mode,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        appBar: M3EAppBar.top(
          titleText: appBarInboxTitle,
          variant: M3EAppBarVariant.mediumFlexible,
          hideMode: mode,
          leading: const Icon(M3EIcons.menu),
        ),
        body: ListView(children: const <Widget>[SizedBox(height: 4000)]),
      ),
    ),
  );
  await tester.pumpAndSettle();

  double barHeight() => tester.getSize(find.byType(M3EAppBar)).height;
  double bodyTop() => tester.getTopLeft(find.byType(ListView)).dy;

  final double startBar = barHeight();
  final double startBody = bodyTop();
  expect(startBar, greaterThan(64));

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.byType(ListView)),
  );
  await gesture.moveBy(const Offset(0, -320));
  await tester.pump();

  double previousBar = barHeight();
  double previousBody = bodyTop();
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 30));
    final bar = barHeight();
    final body = bodyTop();
    expect(bar, lessThanOrEqualTo(previousBar + 0.5));
    expect(body, lessThanOrEqualTo(previousBody + 0.5));
    previousBar = bar;
    previousBody = body;
  }
  await gesture.up();
  await tester.pumpAndSettle();

  expect(barHeight(), lessThan(startBar - 24));
  expect(bodyTop(), lessThan(startBody));
}

Future<void> _actionsHideColorsTheOverlay(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        appBar: const M3EAppBar.top(
          titleText: appBarInboxTitle,
          hideMode: M3EAppBarHideMode.actions,
          leading: Icon(M3EIcons.menu),
          actions: <Widget>[Icon(M3EIcons.search)],
        ),
        body: ListView(children: const <Widget>[SizedBox(height: 2400)]),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final M3EColorScheme scheme = M3ETheme.of(
    tester.element(find.byType(M3EAppBar)),
  ).colorScheme;
  Material barMaterial() {
    return tester.widget<Material>(
      find
          .descendant(
            of: find.byType(M3EAppBar),
            matching: find.byType(Material),
          )
          .first,
    );
  }

  ColoredBox overlay() {
    return tester.widget<ColoredBox>(
      find
          .descendant(
            of: find.byType(M3EAppBar),
            matching: find.byType(ColoredBox),
          )
          .first,
    );
  }

  expect(overlay().color, scheme.surface);
  expect(barMaterial().color, scheme.surface);
  expect(barMaterial().elevation, 0);

  await tester.drag(find.byType(ListView), const Offset(0, -400));
  await tester.pump();

  expect(overlay().color, scheme.surfaceContainer);
  expect(barMaterial().color, scheme.surfaceContainer);
  expect(barMaterial().elevation, 0);

  tester.state<ScrollableState>(find.byType(Scrollable)).position.jumpTo(0);
  await tester.pump();

  expect(overlay().color, scheme.surface);
  expect(barMaterial().elevation, 0);
}

Future<void> _overlayScrollableDoesNotClearScrollUnder(
  WidgetTester tester,
) async {
  final overlay = ScrollController();
  addTearDown(overlay.dispose);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        appBar: const M3EAppBar.top(titleText: appBarInboxTitle),
        body: Stack(
          children: <Widget>[
            ListView(children: const <Widget>[SizedBox(height: 2400)]),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 120,
                child: ListView(
                  controller: overlay,
                  children: const <Widget>[SizedBox(height: 400)],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.drag(find.byType(ListView).first, const Offset(0, -400));
  await tester.pump();

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

  await tester.drag(find.byType(ListView).last, const Offset(0, 40));
  await tester.pump();

  expect(material().color, scheme.surfaceContainer);
  expect(material().elevation, 0);
}

Future<void> _desktopScrollUnderIgnoresAnIdleList(WidgetTester tester) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  final idle = ScrollController();
  addTearDown(idle.dispose);
  try {
    await _desktopScrollUnderBody(tester, idle);
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

Future<void> _desktopScrollUnderBody(
  WidgetTester tester,
  ScrollController idle,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        appBar: const M3EAppBar.top(titleText: appBarInboxTitle),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(children: const <Widget>[SizedBox(height: 2400)]),
            ),
            SizedBox(
              height: 80,
              child: ListView(
                controller: idle,
                children: const <Widget>[SizedBox(height: 400)],
              ),
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.drag(find.byType(ListView).first, const Offset(0, -400));
  await tester.pump();

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

  await tester.drag(find.byType(ListView).last, const Offset(0, 40));
  await tester.pump();

  expect(material().color, scheme.surfaceContainer);
  expect(material().elevation, 0);

  await tester.drag(find.byType(ListView).first, const Offset(0, 800));
  await tester.pump();

  expect(material().color, scheme.surface);
  expect(material().elevation, 0);
}

Future<void> _refreshCycleDoesNotFreezeScrollUnder(WidgetTester tester) async {
  debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
  try {
    await tester.pumpWidget(const MaterialApp(home: _RefreshScrollHost()));
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

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pump();
    expect(material().color, scheme.surfaceContainer);
    expect(material().elevation, 0);

    await tester.drag(find.byType(ListView), const Offset(0, 800));
    await tester.pumpAndSettle();
    final double pixels = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position
        .pixels;
    expect(pixels, 0, reason: 'list should be back at the top');
    expect(material().color, scheme.surface);

    final Future<void> refresh = tester
        .state<_RefreshScrollHostState>(find.byType(_RefreshScrollHost))
        .controller
        .show();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await refresh;
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pump();
    expect(material().color, scheme.surfaceContainer);
    expect(material().elevation, 0);

    await tester.drag(find.byType(ListView), const Offset(0, 800));
    await tester.pumpAndSettle();
    expect(material().color, scheme.surface);
    expect(material().elevation, 0);
  } finally {
    debugDefaultTargetPlatformOverride = null;
  }
}

Future<void> _replacingThePageScrollableDoesNotThrow(
  WidgetTester tester,
) async {
  final first = ScrollController();
  final second = ScrollController();
  addTearDown(first.dispose);
  addTearDown(second.dispose);

  Widget page(ScrollController controller) {
    return MaterialApp(
      home: Scaffold(
        appBar: const M3EAppBar.top(titleText: appBarInboxTitle),
        body: ListView(
          controller: controller,
          children: const <Widget>[SizedBox(height: 2400)],
        ),
      ),
    );
  }

  await tester.pumpWidget(page(first));
  await tester.pumpAndSettle();
  await tester.drag(find.byType(ListView), const Offset(0, -400));
  await tester.pump();

  await tester.pumpWidget(page(second));
  await tester.pump();
  await tester.drag(find.byType(ListView), const Offset(0, -200));
  await tester.pump();

  expect(tester.takeException(), isNull);
}

class _RefreshScrollHost extends StatefulWidget {
  const _RefreshScrollHost();

  @override
  State<_RefreshScrollHost> createState() => _RefreshScrollHostState();
}

class _RefreshScrollHostState extends State<_RefreshScrollHost> {
  final M3ERefreshIndicatorController controller =
      M3ERefreshIndicatorController();
  int _count = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: M3EAppBar.top(titleText: 'Refresh ($_count)'),
      body: M3ERefreshIndicator.contained(
        controller: controller,
        onRefresh: () async {
          await Future<void>.delayed(const Duration(milliseconds: 300));
          if (mounted) {
            setState(() => _count++);
          }
        },
        child: M3EList.scrollable(
          itemCount: 16,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(height: 72, child: Text('Item $index'));
          },
        ),
      ),
    );
  }
}
