import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(padding: const EdgeInsets.all(24), child: child),
      ),
    ),
  );
}

void main() {
  testWidgets(
    'M3ESearchBar lays out at default height without overflow',
    _m3esearchbarLaysOutAtDefaultHeightWithoutOverflow,
  );
  testWidgets(
    'M3ESearchBar applies hint inset only without leading',
    _m3esearchbarAppliesHintInsetOnlyWithoutLeading,
  );
  testWidgets(
    'disabled M3ESearchBar applies reduced opacity',
    _disabledM3esearchbarAppliesReducedOpacity,
  );
  testWidgets(
    'M3ESearchAnchor.bar opens view on tap without typing',
    _m3esearchanchorBarOpensViewOnTapWithoutTyping,
  );
  testWidgets(
    'full-screen back closes view without reopening',
    _fullScreenBackClosesViewWithoutReopening,
  );
  testWidgets(
    'M3ESearchAnchor.bar opens and closes the search view',
    _m3esearchanchorBarOpensAndClosesTheSearchView,
  );
  testWidgets(
    'closeView populates the read-only anchor bar',
    _closeviewPopulatesTheReadOnlyAnchorBar,
  );
  testWidgets(
    'anchor bar stays at resting unexpanded inset',
    _anchorBarStaysAtRestingUnexpandedInset,
  );
  testWidgets(
    'full-screen search view header uses contained search bar styling',
    _fullScreenSearchViewHeaderUsesContainedSearchBarSty,
  );
  testWidgets(
    'M3ESearchBar expands horizontally on focus',
    _m3esearchbarExpandsHorizontallyOnFocus,
  );
  testWidgets(
    'M3ESearchBar expands on focus in narrow gallery layout',
    _m3esearchbarExpandsOnFocusInNarrowGalleryLayout,
  );
  testWidgets(
    'M3ESearchBarTheme overrides container color',
    _m3esearchbarthemeOverridesContainerColor,
  );
}

Future<void> _m3esearchbarLaysOutAtDefaultHeightWithoutOverflow(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(const SizedBox(width: 400, child: M3ESearchBar(hintText: 'Search'))),
  );

  expect(find.text('Search'), findsOneWidget);
  expect(tester.takeException(), isNull);
}

Future<void> _m3esearchbarAppliesHintInsetOnlyWithoutLeading(
  WidgetTester tester,
) async {
  const double extraInset = 12;

  await tester.pumpWidget(
    _host(const SizedBox(width: 400, child: M3ESearchBar(hintText: 'Search'))),
  );

  final M3ESearchBarInput withoutLeading = tester.widget<M3ESearchBarInput>(
    find.byType(M3ESearchBarInput),
  );
  expect(
    withoutLeading.contentPadding,
    const EdgeInsetsDirectional.only(start: extraInset),
  );

  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: 400,
        child: M3ESearchBar(hintText: 'Search', leading: Icon(M3EIcons.search)),
      ),
    ),
  );

  final M3ESearchBarInput withLeading = tester.widget<M3ESearchBarInput>(
    find.byType(M3ESearchBarInput),
  );
  expect(withLeading.contentPadding, EdgeInsetsDirectional.zero);
}

Future<void> _disabledM3esearchbarAppliesReducedOpacity(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: 400,
        child: M3ESearchBar(hintText: 'Search', enabled: false),
      ),
    ),
  );

  final Opacity opacity = tester.widget<Opacity>(
    find.descendant(
      of: find.byType(M3ESearchBar),
      matching: find.byType(Opacity),
    ),
  );
  expect(opacity.opacity, M3ESearchConstants.disabledOpacity);
}

Future<void> _m3esearchanchorBarOpensViewOnTapWithoutTyping(
  WidgetTester tester,
) async {
  final controller = M3ESearchController();

  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 420,
        child: M3ESearchAnchor.bar(
          searchController: controller,
          isFullScreen: true,
          barHintText: 'Find components',
          suggestionsBuilder: (BuildContext context, M3ESearchController c) {
            return <Widget>[
              ListTile(
                title: Text('Result for ${c.text}'),
                onTap: () => c.closeView('Buttons'),
              ),
            ];
          },
        ),
      ),
    ),
  );

  final M3ESearchBar anchorBar = tester.widget<M3ESearchBar>(
    find.byType(M3ESearchBar),
  );
  expect(anchorBar.readOnly, isTrue);

  await tester.tap(find.byType(M3ESearchBar));
  await tester.pumpAndSettle();
  await tester.pump();

  expect(controller.isOpen, isTrue);
  expect(controller.text, isEmpty);
  expect(find.text('Result for '), findsOneWidget);

  // View search bar is editable and focused; anchor bar stays unfocused.
  final Iterable<M3ESearchBar> bars = tester.widgetList<M3ESearchBar>(
    find.byType(M3ESearchBar),
  );
  final M3ESearchBar viewBar = bars.firstWhere(
    (M3ESearchBar bar) => !bar.readOnly,
  );
  expect(viewBar.autoFocus, isTrue);
}

Future<void> _fullScreenBackClosesViewWithoutReopening(
  WidgetTester tester,
) async {
  final controller = M3ESearchController();

  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 420,
        child: M3ESearchAnchor.bar(
          searchController: controller,
          isFullScreen: true,
          barHintText: 'Find components',
          suggestionsBuilder: (BuildContext context, M3ESearchController c) {
            return <Widget>[ListTile(title: Text('Result for ${c.text}'))];
          },
        ),
      ),
    ),
  );

  await tester.tap(find.byType(M3ESearchBar));
  await tester.pumpAndSettle();
  expect(controller.isOpen, isTrue);

  await tester.tap(find.byIcon(M3EIcons.arrow_back));
  await tester.pumpAndSettle();
  await tester.pump();

  expect(controller.isOpen, isFalse);
  expect(find.text('Result for '), findsNothing);
}

Future<void> _m3esearchanchorBarOpensAndClosesTheSearchView(
  WidgetTester tester,
) async {
  final controller = M3ESearchController();

  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 420,
        child: M3ESearchAnchor.bar(
          searchController: controller,
          isFullScreen: false,
          barHintText: 'Find components',
          suggestionsBuilder: (BuildContext context, M3ESearchController c) {
            return <Widget>[
              ListTile(
                title: Text('Result for ${c.text}'),
                onTap: () => c.closeView('Buttons'),
              ),
            ];
          },
        ),
      ),
    ),
  );

  expect(controller.isAttached, isTrue);
  expect(controller.isOpen, isFalse);

  controller.openView();
  await tester.pumpAndSettle();
  await tester.pump();

  expect(controller.isOpen, isTrue);
  expect(find.text('Result for '), findsOneWidget);

  await tester.tap(find.byIcon(M3EIcons.arrow_back));
  await tester.pumpAndSettle();

  expect(controller.isOpen, isFalse);
}

Future<void> _closeviewPopulatesTheReadOnlyAnchorBar(
  WidgetTester tester,
) async {
  final controller = M3ESearchController();

  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 420,
        child: M3ESearchAnchor.bar(
          searchController: controller,
          isFullScreen: false,
          barHintText: 'Find',
          suggestionsBuilder: (BuildContext context, M3ESearchController c) {
            return <Widget>[
              ListTile(
                title: const Text('Buttons'),
                onTap: () => c.closeView('Buttons'),
              ),
            ];
          },
        ),
      ),
    ),
  );

  expect(
    tester.widget<M3ESearchBar>(find.byType(M3ESearchBar)).readOnly,
    isTrue,
  );
  expect(find.byIcon(M3EIcons.close), findsNothing);

  await tester.tap(find.byType(M3ESearchBar));
  await tester.pumpAndSettle();
  await tester.pump();
  await tester.tap(find.text('Buttons'));
  await tester.pumpAndSettle();

  expect(controller.isOpen, isFalse);
  expect(controller.text, 'Buttons');
  expect(find.text('Buttons'), findsOneWidget);
  expect(find.byIcon(M3EIcons.close), findsOneWidget);

  await tester.tap(find.byIcon(M3EIcons.close));
  await tester.pumpAndSettle();
  expect(controller.text, isEmpty);
  expect(find.byIcon(M3EIcons.close), findsNothing);
}

Future<void> _anchorBarStaysAtRestingUnexpandedInset(
  WidgetTester tester,
) async {
  final controller = M3ESearchController();
  const double hostWidth = 420;

  await tester.pumpWidget(
    _host(
      SizedBox(
        width: hostWidth,
        child: M3ESearchAnchor.bar(
          searchController: controller,
          isFullScreen: false,
          barHintText: 'Find',
          suggestionsBuilder: (BuildContext context, M3ESearchController c) {
            return const <Widget>[];
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Finder barMaterial = find
      .descendant(
        of: find.byType(M3ESearchBar),
        matching: find.byType(Material),
      )
      .first;
  final double barWidth = tester.getSize(barMaterial).width;
  final double restingInset =
      M3ESearchBarTheme.defaults.restingExpandPadding * 2;
  expect(barWidth, closeTo(hostWidth - restingInset, 0.1));
}

Future<void> _fullScreenSearchViewHeaderUsesContainedSearchBarSty(
  WidgetTester tester,
) async {
  final controller = M3ESearchController();
  final theme = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    M3EMaterialApp(
      data: theme,
      home: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 420,
              child: M3ESearchAnchor.bar(
                searchController: controller,
                isFullScreen: true,
                barHintText: 'Find',
                suggestionsBuilder:
                    (BuildContext context, M3ESearchController c) {
                      return <Widget>[ListTile(title: Text('Item ${c.text}'))];
                    },
              ),
            ),
          ),
        ),
      ),
    ),
  );

  controller.openView();
  await tester.pumpAndSettle();
  await tester.pump();

  final Iterable<Material> materials = tester.widgetList<Material>(
    find.byType(Material),
  );
  expect(
    materials.any(
      (Material material) =>
          material.elevation == 0 &&
          material.color == theme.colorScheme.surfaceContainerHigh,
    ),
    isTrue,
  );
}

Future<void> _m3esearchbarExpandsHorizontallyOnFocus(
  WidgetTester tester,
) async {
  final focusNode = FocusNode();

  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 420,
        child: M3ESearchBar(focusNode: focusNode, hintText: 'Search'),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Finder barMaterial = find
      .descendant(
        of: find.byType(M3ESearchBar),
        matching: find.byType(Material),
      )
      .first;
  final double widthBefore = tester.getSize(barMaterial).width;
  focusNode.requestFocus();
  await tester.pumpAndSettle();

  final double widthFocused = tester.getSize(barMaterial).width;
  expect(widthFocused, greaterThan(widthBefore));
  expect(widthFocused - widthBefore, closeTo(8, 0.1));

  focusNode.unfocus();
  await tester.pumpAndSettle();

  final double widthAfter = tester.getSize(barMaterial).width;
  expect(widthAfter, lessThan(widthFocused));
  expect(widthAfter, closeTo(widthBefore, 0.1));
}

Future<void> _m3esearchbarExpandsOnFocusInNarrowGalleryLayout(
  WidgetTester tester,
) async {
  await tester.binding.setSurfaceSize(const Size(390, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: const <Widget>[M3ESearchBar(hintText: 'Search components')],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Finder barMaterial = find
      .descendant(
        of: find.byType(M3ESearchBar),
        matching: find.byType(Material),
      )
      .first;
  final double widthBefore = tester.getSize(barMaterial).width;

  await tester.tap(find.byType(EditableText));
  await tester.pumpAndSettle();

  final double widthFocused = tester.getSize(barMaterial).width;
  expect(widthFocused, greaterThan(widthBefore));
}

Future<void> _m3esearchbarthemeOverridesContainerColor(
  WidgetTester tester,
) async {
  const custom = Color(0xFFFF00FF);
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(
        seedColor: const Color(0xFF6750A4),
      ).copyWith(searchBarTheme: M3ESearchBarTheme.defaults),
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 400,
            child: M3ESearchBar(
              hintText: 'Search',
              backgroundColor: WidgetStatePropertyAll<Color>(custom),
            ),
          ),
        ),
      ),
    ),
  );

  final Material material = tester.widget<Material>(
    find
        .descendant(
          of: find.byType(M3ESearchBar),
          matching: find.byType(Material),
        )
        .first,
  );
  expect(material.color, custom);
}
