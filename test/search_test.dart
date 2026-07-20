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
