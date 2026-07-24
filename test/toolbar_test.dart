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
      // padding zeroed (edge-to-edge); viewPadding still carries system insets.
      data: MediaQueryData(padding: EdgeInsets.zero, viewPadding: padding),
      child: M3ETheme(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        child: Center(child: child),
      ),
    ),
  );
}

List<M3EToolbarItem> _actions() => <M3EToolbarItem>[
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
            actions: <M3EToolbarItem>[
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
    final Size pillSize = tester.getSize(
      find
          .descendant(
            of: find.byType(M3EToolbar),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(pillSize.width, 64);
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

    final Size materialSize = tester.getSize(
      find
          .descendant(
            of: find.byType(M3EToolbar),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(materialSize.height, 64);

    final Padding safePadding = tester.widget(
      find.descendant(
        of: find.byType(M3EToolbar),
        matching: find.byWidgetPredicate((Widget w) {
          if (w is! Padding) {
            return false;
          }
          final EdgeInsets insets = w.padding.resolve(TextDirection.ltr);
          return insets.bottom == 40 &&
              insets.top == 0 &&
              insets.left == 0 &&
              insets.right == 0;
        }),
      ),
    );
    expect(safePadding.padding.resolve(TextDirection.ltr).bottom, 40);
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

    final Size materialSize = tester.getSize(
      find
          .descendant(
            of: find.byType(M3EToolbar),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(materialSize.height, 64);

    expect(
      find.descendant(
        of: find.byType(M3EToolbar),
        matching: find.byWidgetPredicate((Widget w) {
          if (w is! Padding) {
            return false;
          }
          final EdgeInsets insets = w.padding.resolve(TextDirection.ltr);
          return insets.top == 20 &&
              insets.bottom == 0 &&
              insets.left == 0 &&
              insets.right == 0;
        }),
      ),
      findsOneWidget,
    );
  });

  testWidgets('floating alignment positions pill in parent', (tester) async {
    await tester.pumpWidget(
      _host(
        child: SizedBox(
          width: 300,
          height: 200,
          child: M3EToolbar(
            alignment: Alignment.bottomCenter,
            actions: _actions(),
          ),
        ),
      ),
    );

    final Rect parent = tester.getRect(find.byType(SizedBox).first);
    final Rect pill = tester.getRect(
      find
          .descendant(
            of: find.byType(M3EToolbar),
            matching: find.byType(Material),
          )
          .first,
    );
    expect(pill.center.dx, closeTo(parent.center.dx, 0.5));
    expect(pill.bottom, closeTo(parent.bottom, 0.5));
  });

  testWidgets('docked icons-only pins first/last to padded edges',
      (tester) async {
    await tester.pumpWidget(
      _host(
        child: const SizedBox(
          width: 300,
          child: M3EToolbar.docked(
            safeArea: false,
            actions: <M3EToolbarItem>[
              M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
              M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
              M3EToolbarAction(icon: M3EIcons.favorite, onPressed: _noop),
            ],
          ),
        ),
      ),
    );

    final Finder buttons = find.descendant(
      of: find.byType(M3EToolbar),
      matching: find.byType(M3EIconButton),
    );
    final double toolbarLeft =
        tester.getTopLeft(find.byType(M3EToolbar)).dx;
    final double toolbarRight =
        tester.getTopRight(find.byType(M3EToolbar)).dx;
    final double firstLeft = tester.getTopLeft(buttons.at(0)).dx;
    final double lastRight = tester.getTopRight(buttons.at(2)).dx;

    // dockedHorizontalPadding = 16
    expect(firstLeft - toolbarLeft, closeTo(16, 0.5));
    expect(toolbarRight - lastRight, closeTo(16, 0.5));

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
            actions: <M3EToolbarItem>[
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
            actions: <M3EToolbarItem>[
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
            actions: <M3EToolbarItem>[
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
            actions: <M3EToolbarItem>[
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

  testWidgets('collapsed with FAB keeps FAB beside trigger pill', (tester) async {
    await tester.pumpWidget(
      _host(
        child: M3EToolbar(
          actions: <M3EToolbarItem>[
            M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            M3EToolbarAction(
              icon: M3EIcons.share,
              onPressed: _noop,
              isExpandTrigger: true,
            ),
            M3EToolbarAction(icon: M3EIcons.favorite, onPressed: _noop),
          ],
          fabIcon: const Icon(M3EIcons.add),
          onFabPressed: () {},
          expanded: false,
        ),
      ),
    );
    expect(find.byType(M3EFab), findsOneWidget);
    // Trigger stays in the collapsed pill; side actions are hidden.
    expect(find.byIcon(M3EIcons.share), findsOneWidget);
    expect(find.byIcon(M3EIcons.edit), findsNothing);
    expect(find.byIcon(M3EIcons.favorite), findsNothing);
  });

  testWidgets(
      'expand trigger tap does not throw on pointer up after rebuild',
      (tester) async {
    await tester.pumpWidget(
      _host(
        child: M3EToolbar(
          actions: <M3EToolbarItem>[
            M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            M3EToolbarAction(
              icon: M3EIcons.menu,
              onPressed: _noop,
              isExpandTrigger: true,
            ),
            M3EToolbarAction(icon: M3EIcons.favorite, onPressed: _noop),
          ],
          expanded: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(M3EIcons.menu));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byIcon(M3EIcons.edit), findsOneWidget);

    await tester.tap(find.byIcon(M3EIcons.menu));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byIcon(M3EIcons.edit), findsNothing);
  });

  testWidgets('toolbar widget items stay inline and height-capped',
      (tester) async {
    await tester.pumpWidget(
      _host(
        child: M3EToolbar(
          actions: <M3EToolbarItem>[
            M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            const M3EToolbarWidget(
              child: SizedBox(
                width: 72,
                height: 120,
                child: ColoredBox(color: Color(0xFF00FF00)),
              ),
            ),
            M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(ConstrainedBox), findsWidgets);
    expect(find.byType(ColoredBox), findsOneWidget);
    // Floating content padding is 8 on each side → 64 - 16 = 48.
    final Size size = tester.getSize(find.byType(ColoredBox));
    expect(size.height, lessThanOrEqualTo(48.01));
  });
}

void _noop() {}
