import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(
      body: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('M3ESearchBar lays out at default height without overflow',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 400,
          child: M3ESearchBar(hintText: 'Search'),
        ),
      ),
    );

    expect(find.text('Search'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('M3ESearchBar applies hint inset only without leading',
      (WidgetTester tester) async {
    const double extraInset = 12;

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 400,
          child: M3ESearchBar(hintText: 'Search'),
        ),
      ),
    );

    final M3ESearchBarInput withoutLeading = tester.widget<M3ESearchBarInput>(
      find.byType(M3ESearchBarInput),
    );
    expect(
      withoutLeading.contentPadding,
      EdgeInsetsDirectional.only(start: extraInset),
    );

    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 400,
          child: M3ESearchBar(
            hintText: 'Search',
            leading: const Icon(M3EIcons.search),
          ),
        ),
      ),
    );

    final M3ESearchBarInput withLeading = tester.widget<M3ESearchBarInput>(
      find.byType(M3ESearchBarInput),
    );
    expect(withLeading.contentPadding, EdgeInsetsDirectional.zero);
  });

  testWidgets('disabled M3ESearchBar applies reduced opacity',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 400,
          child: M3ESearchBar(
            hintText: 'Search',
            enabled: false,
          ),
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
  });

  testWidgets('M3ESearchAnchor.bar opens view on tap without typing',
      (WidgetTester tester) async {
    final M3ESearchController controller = M3ESearchController();

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

    await tester.tap(find.byType(M3ESearchBar));
    await tester.pumpAndSettle();
    await tester.pump();

    expect(controller.isOpen, isTrue);
    expect(controller.text, isEmpty);
    expect(find.text('Result for '), findsOneWidget);
  });

  testWidgets('full-screen back closes view without reopening',
      (WidgetTester tester) async {
    final M3ESearchController controller = M3ESearchController();

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
                ListTile(title: Text('Result for ${c.text}')),
              ];
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
  });

  testWidgets('M3ESearchAnchor.bar opens and closes the search view',
      (WidgetTester tester) async {
    final M3ESearchController controller = M3ESearchController();

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
  });

  testWidgets('closeView sets controller text', (WidgetTester tester) async {
    final M3ESearchController controller = M3ESearchController();

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

    controller.openView();
    await tester.pumpAndSettle();
    await tester.pump();
    await tester.tap(find.text('Buttons'));
    await tester.pumpAndSettle();

    expect(controller.text, 'Buttons');
    expect(controller.isOpen, isFalse);
  });

  testWidgets('full-screen search view header uses contained search bar styling',
      (WidgetTester tester) async {
    final M3ESearchController controller = M3ESearchController();
    final M3EThemeData theme =
        M3EThemeData.light(seedColor: const Color(0xFF6750A4));

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
                    return <Widget>[
                      ListTile(title: Text('Item ${c.text}')),
                    ];
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

    final Iterable<Material> materials =
        tester.widgetList<Material>(find.byType(Material));
    expect(
      materials.any(
        (Material material) =>
            material.elevation == 0 &&
            material.color == theme.colorScheme.surfaceContainerHigh,
      ),
      isTrue,
    );
  });

  testWidgets('M3ESearchBar expands horizontally on focus',
      (WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();

    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 420,
          child: M3ESearchBar(
            focusNode: focusNode,
            hintText: 'Search',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Finder barMaterial = find.descendant(
      of: find.byType(M3ESearchBar),
      matching: find.byType(Material),
    ).first;
    final double widthBefore = tester.getSize(barMaterial).width;
    focusNode.requestFocus();
    await tester.pumpAndSettle();

    final double widthFocused = tester.getSize(barMaterial).width;
    expect(widthFocused, greaterThan(widthBefore));

    focusNode.unfocus();
    await tester.pumpAndSettle();

    final double widthAfter = tester.getSize(barMaterial).width;
    expect(widthAfter, lessThan(widthFocused));
  });

  testWidgets('M3ESearchBarTheme overrides container color',
      (WidgetTester tester) async {
    const Color custom = Color(0xFFFF00FF);
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)).copyWith(
          searchBarTheme: const M3ESearchBarTheme(),
        ),
        home: Scaffold(
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
      find.descendant(
        of: find.byType(M3ESearchBar),
        matching: find.byType(Material),
      ).first,
    );
    expect(material.color, custom);
  });
}
