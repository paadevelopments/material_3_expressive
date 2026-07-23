import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/icon_buttons/m3e_icon_buttons.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host({
  required Widget child,
  EdgeInsets padding = EdgeInsets.zero,
}) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: MediaQueryData(padding: padding),
      child: M3ETheme(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        child: Center(child: child),
      ),
    ),
  );
}

List<M3EToolbarAction> _actions() => <M3EToolbarAction>[
      M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
      M3EToolbarAction(icon: M3EIcons.share, onPressed: () {}),
    ];

void main() {
  testWidgets('floating default builds pill wrap-content bar', (tester) async {
    await tester.pumpWidget(
      _host(child: M3EToolbar(actions: _actions())),
    );
    expect(find.byType(M3EToolbar), findsOneWidget);
    expect(find.byType(M3EIconButton), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('docked is full width', (tester) async {
    await tester.pumpWidget(
      _host(
        child: const SizedBox(
          width: 400,
          child: M3EToolbar.docked(
            safeArea: false,
            actions: <M3EToolbarAction>[
              M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            ],
          ),
        ),
      ),
    );
    final Size size = tester.getSize(find.byType(M3EToolbar));
    expect(size.width, 400);
    expect(size.height, greaterThanOrEqualTo(64));
  });

  testWidgets('vertical floating uses cross-axis width', (tester) async {
    await tester.pumpWidget(
      _host(
        child: SizedBox(
          height: 240,
          child: M3EToolbar(
            axis: Axis.vertical,
            actions: _actions(),
          ),
        ),
      ),
    );
    final Size size = tester.getSize(find.byType(M3EToolbar));
    expect(size.width, 64);
  });

  testWidgets('floating safeArea pads outside the pill on one edge',
      (tester) async {
    await tester.pumpWidget(
      _host(
        padding: const EdgeInsets.fromLTRB(10, 20, 30, 40),
        child: M3EToolbar(
          safeArea: true,
          dockEdge: M3EToolbarDockEdge.bottom,
          actions: _actions(),
        ),
      ),
    );

    final Size toolbarSize = tester.getSize(find.byType(M3EToolbar));
    final Size materialSize = tester.getSize(
      find
          .descendant(
            of: find.byType(M3EToolbar),
            matching: find.byType(Material),
          )
          .first,
    );

    // Pill stays token size; only bottom inset is added outside Material.
    expect(materialSize.height, 64);
    expect(toolbarSize.height, 64 + 40);
    expect(toolbarSize.width, materialSize.width);
  });

  testWidgets('floating safeArea top pads only top outside pill',
      (tester) async {
    await tester.pumpWidget(
      _host(
        padding: const EdgeInsets.fromLTRB(10, 20, 30, 40),
        child: M3EToolbar(
          safeArea: true,
          dockEdge: M3EToolbarDockEdge.top,
          actions: _actions(),
        ),
      ),
    );

    final Size toolbarSize = tester.getSize(find.byType(M3EToolbar));
    final Size materialSize = tester.getSize(
      find
          .descendant(
            of: find.byType(M3EToolbar),
            matching: find.byType(Material),
          )
          .first,
    );

    expect(materialSize.height, 64);
    expect(toolbarSize.height, 64 + 20);
    expect(toolbarSize.width, materialSize.width);
  });

  testWidgets('docked icons-only spaces actions evenly', (tester) async {
    await tester.pumpWidget(
      _host(
        child: const SizedBox(
          width: 300,
          child: M3EToolbar.docked(
            safeArea: false,
            actions: <M3EToolbarAction>[
              M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
              M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
              M3EToolbarAction(icon: M3EIcons.favorite, onPressed: _noop),
            ],
          ),
        ),
      ),
    );

    final double editX = tester.getCenter(find.byIcon(M3EIcons.edit)).dx;
    final double shareX = tester.getCenter(find.byIcon(M3EIcons.share)).dx;
    final double favoriteX =
        tester.getCenter(find.byIcon(M3EIcons.favorite)).dx;

    expect(shareX - editX, closeTo(favoriteX - shareX, 0.5));
  });

  testWidgets('floating title gets optical start inset', (tester) async {
    await tester.pumpWidget(
      _host(
        child: const SizedBox(
          width: 360,
          child: M3EToolbar(
            titleText: 'Inbox',
            actions: <M3EToolbarAction>[
              M3EToolbarAction(icon: M3EIcons.search, onPressed: _noop),
            ],
          ),
        ),
      ),
    );

    final double titleLeft = tester.getTopLeft(find.text('Inbox')).dx;
    final double toolbarLeft =
        tester.getTopLeft(find.byType(M3EToolbar)).dx;
    // contentPadding 8 + (48 target - 24 icon) / 2 = 20
    expect(titleLeft - toolbarLeft, closeTo(20, 0.5));
  });

  testWidgets('docked bottom safeArea pads only bottom', (tester) async {
    await tester.pumpWidget(
      _host(
        padding: const EdgeInsets.fromLTRB(10, 20, 30, 40),
        child: const SizedBox(
          width: 300,
          child: M3EToolbar.docked(
            safeArea: true,
            dockEdge: M3EToolbarDockEdge.bottom,
            actions: <M3EToolbarAction>[
              M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            ],
          ),
        ),
      ),
    );

    final Size size = tester.getSize(find.byType(M3EToolbar));
    // 64 content + 40 bottom inset
    expect(size.height, 104);
    expect(size.width, 300);
  });

  testWidgets('docked top safeArea pads only top', (tester) async {
    await tester.pumpWidget(
      _host(
        padding: const EdgeInsets.fromLTRB(10, 20, 30, 40),
        child: const SizedBox(
          width: 300,
          child: M3EToolbar.docked(
            safeArea: true,
            dockEdge: M3EToolbarDockEdge.top,
            actions: <M3EToolbarAction>[
              M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            ],
          ),
        ),
      ),
    );

    final Size size = tester.getSize(find.byType(M3EToolbar));
    // 64 content + 20 top inset
    expect(size.height, 84);
  });

  testWidgets('docked with title lays out without flex overflow', (tester) async {
    await tester.pumpWidget(
      _host(
        padding: const EdgeInsets.only(top: 44),
        child: const SizedBox(
          width: 280,
          child: M3EToolbar.docked(
            safeArea: true,
            dockEdge: M3EToolbarDockEdge.top,
            titleText: 'Docked top',
            actions: <M3EToolbarAction>[
              M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
              M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
              M3EToolbarAction(icon: M3EIcons.favorite, onPressed: _noop),
            ],
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Docked top'), findsOneWidget);
  });

  testWidgets('vibrant color style builds', (tester) async {
    await tester.pumpWidget(
      _host(
        child: M3EToolbar(
          colorStyle: M3EToolbarColorStyle.vibrant,
          actions: _actions(),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('FAB slot is present when fabIcon provided', (tester) async {
    await tester.pumpWidget(
      _host(
        child: M3EToolbar(
          actions: _actions(),
          fabIcon: const Icon(M3EIcons.add),
          onFabPressed: () {},
          expanded: true,
        ),
      ),
    );
    expect(find.byType(M3EFab), findsOneWidget);
  });

  testWidgets('collapsed with FAB shows FAB only', (tester) async {
    await tester.pumpWidget(
      _host(
        child: M3EToolbar(
          actions: _actions(),
          fabIcon: const Icon(M3EIcons.add),
          onFabPressed: () {},
          expanded: false,
        ),
      ),
    );
    expect(find.byType(M3EFab), findsOneWidget);
    // Actions are not in the collapsed FAB-only presentation.
    expect(find.byIcon(M3EIcons.edit), findsNothing);
  });
}

void _noop() {}
