import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(),
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Center(child: child),
      ),
    ),
  );
}

Future<void> _settleSpring(WidgetTester tester) async {
  // Expressive spatial springs can overshoot; settle fully like dropdown tests.
  await tester.pump();
  await tester.pumpAndSettle(const Duration(milliseconds: 50));
}

void main() {
  testWidgets(
    'M3EMenu opens and dismisses on scrim tap',
    _m3emenuOpensAndDismissesOnScrimTap,
  );
  testWidgets(
    'M3EMenu entry onPressed fires and closes',
    _m3emenuEntryOnpressedFiresAndCloses,
  );
  testWidgets(
    'showM3EMenu returns selectable value',
    _showm3emenuReturnsSelectableValue,
  );
  testWidgets(
    'disabled menu entry is not tappable',
    _disabledMenuEntryIsNotTappable,
  );
  testWidgets(
    'system back closes the menu before the route',
    _systemBackClosesMenuBeforeRoute,
  );
  testWidgets(
    'system back closes a submenu before its parent menu',
    _systemBackClosesSubmenuBeforeParent,
  );
  test('menu theme defaults follow the spec presets', _menuThemeDefaults);
  testWidgets(
    'opening a menu focuses the first enabled item',
    _openingFocusesFirstItem,
  );
  testWidgets(
    'arrow keys move focus and skip disabled items',
    _arrowKeysSkipDisabledItems,
  );
  testWidgets('letter keys move focus by typeahead', _letterKeysTypeahead);
  testWidgets('multi-select keeps the menu open', _multiSelectKeepsMenuOpen);
  testWidgets(
    'multi-select can rebuild the anchor while the menu is open',
    _multiSelectRebuildsAnchor,
  );
  testWidgets(
    'a scrolling menu uses dividers instead of gaps',
    _scrollingMenuUsesDividers,
  );
  testWidgets(
    'grouped menus keep a gap when they do not scroll',
    _groupedMenusKeepGapWhenNotScrolling,
  );
}

Future<void> _m3emenuOpensAndDismissesOnScrimTap(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3EMenu(
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: const <M3EMenuNode>[
          M3EMenuEntry(label: 'One'),
          M3EMenuEntry(label: 'Two'),
        ],
      ),
    ),
  );

  expect(find.text('One'), findsNothing);

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);

  expect(find.text('One'), findsOneWidget);
  expect(find.text('Two'), findsOneWidget);

  await tester.tapAt(const Offset(10, 10));
  await _settleSpring(tester);

  expect(find.text('One'), findsNothing);
}

Future<void> _m3emenuEntryOnpressedFiresAndCloses(WidgetTester tester) async {
  var pressed = false;

  await tester.pumpWidget(
    _host(
      M3EMenu(
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: <M3EMenuNode>[
          M3EMenuEntry(label: 'Action', onPressed: () => pressed = true),
        ],
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);

  await tester.tap(find.text('Action'));
  await _settleSpring(tester);

  expect(pressed, isTrue);
  expect(find.text('Action'), findsNothing);
}

Future<void> _showm3emenuReturnsSelectableValue(WidgetTester tester) async {
  Object? selected;

  await tester.pumpWidget(
    _host(
      Builder(
        builder: (BuildContext context) {
          return TextButton(
            onPressed: () async {
              final buttonBox = context.findRenderObject()! as RenderBox;
              selected = await showM3EMenu<String>(
                context: context,
                anchor: buttonBox.localToGlobal(Offset.zero) & buttonBox.size,
                children: const <M3EMenuNode>[
                  M3EMenuSelectable(label: 'Alpha', value: 'a'),
                  M3EMenuSelectable(label: 'Beta', value: 'b'),
                ],
              );
            },
            child: const Text('Show'),
          );
        },
      ),
    ),
  );

  await tester.tap(find.text('Show'));
  await _settleSpring(tester);

  await tester.tap(find.text('Beta'));
  await _settleSpring(tester);

  expect(selected, 'b');
}

Future<void> _disabledMenuEntryIsNotTappable(WidgetTester tester) async {
  var pressed = false;

  await tester.pumpWidget(
    _host(
      M3EMenu(
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: <M3EMenuNode>[
          M3EMenuEntry(
            label: 'Nope',
            enabled: false,
            onPressed: () => pressed = true,
          ),
        ],
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);

  await tester.tap(find.text('Nope'));
  await tester.pump();

  expect(pressed, isFalse);
  expect(find.text('Nope'), findsOneWidget);
}

Future<void> _openPushedPage(WidgetTester tester, Widget page) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => page,
                  ),
                );
              },
              child: const Text('Root'),
            ),
          );
        },
      ),
    ),
  );
  await tester.tap(find.text('Root'));
  await tester.pumpAndSettle();
}

Future<void> _systemBackClosesMenuBeforeRoute(WidgetTester tester) async {
  await _openPushedPage(
    tester,
    Scaffold(
      body: M3EMenu(
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: const <M3EMenuNode>[M3EMenuEntry(label: 'One')],
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);
  expect(find.text('One'), findsOneWidget);

  await tester.binding.handlePopRoute();
  await _settleSpring(tester);

  expect(find.text('One'), findsNothing);
  expect(find.text('Open'), findsOneWidget);

  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();

  expect(find.text('Open'), findsNothing);
  expect(find.text('Root'), findsOneWidget);
}

Future<void> _systemBackClosesSubmenuBeforeParent(WidgetTester tester) async {
  await _openPushedPage(
    tester,
    Scaffold(
      body: M3EMenu(
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: const <M3EMenuNode>[
          M3EMenuSubmenu(
            label: 'More',
            children: <M3EMenuNode>[M3EMenuEntry(label: 'Nested')],
          ),
        ],
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);
  await tester.tap(find.text('More'));
  await _settleSpring(tester);
  expect(find.text('Nested'), findsOneWidget);

  await tester.binding.handlePopRoute();
  await _settleSpring(tester);

  expect(find.text('Nested'), findsNothing);
  expect(find.text('More'), findsOneWidget);

  await tester.binding.handlePopRoute();
  await _settleSpring(tester);

  expect(find.text('More'), findsNothing);
  expect(find.text('Open'), findsOneWidget);

  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();
  expect(find.text('Root'), findsOneWidget);
}

void _menuThemeDefaults() {
  const vertical = M3EMenuTheme.defaults;
  expect(vertical.entryHeight, 48);
  expect(vertical.entryHorizontalPadding, 8);
  expect(vertical.entryVerticalPadding, 0);
  expect(vertical.iconSize, 20);
  expect(vertical.iconGap, 8);
  expect(vertical.verticalPadding, 4);
  expect(vertical.sectionGap, 2);
  expect(vertical.itemGap, 4);
  expect(vertical.containerRadius, 16);
  expect(vertical.containerBottomRadius, 12);
  expect(vertical.itemRadius, 12);
  expect(vertical.stateLayerInset, 4);
  expect(vertical.groupLabelHeight, 32);
  expect(vertical.focusIndicatorWidth, 3);
  expect(vertical.focusIndicatorOffset, -3);

  const M3EMenuTheme baseline = M3EMenuTheme.baselineMetrics;
  expect(baseline.entryHeight, 48);
  expect(baseline.entryHorizontalPadding, 12);
  expect(baseline.iconSize, 24);
  expect(baseline.itemRadius, 4);
  expect(baseline.containerRadius, 4);
  expect(baseline.containerBottomRadius, 4);
  expect(baseline.dividerVerticalPadding, 8);
  expect(baseline.verticalPadding, 8);
  expect(baseline.iconGap, 12);
  expect(baseline.itemGap, 0);
}

bool _focusShows(WidgetTester tester, String label) {
  final BuildContext? context =
      tester.binding.focusManager.primaryFocus?.context;
  if (context == null) {
    return false;
  }
  return find
      .descendant(of: find.byWidget(context.widget), matching: find.text(label))
      .evaluate()
      .isNotEmpty;
}

Future<void> _openingFocusesFirstItem(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3EMenu(
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: const <M3EMenuNode>[
          M3EMenuEntry(label: 'One'),
          M3EMenuEntry(label: 'Two'),
        ],
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);

  expect(_focusShows(tester, 'One'), isTrue);
}

Future<void> _arrowKeysSkipDisabledItems(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3EMenu(
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: const <M3EMenuNode>[
          M3EMenuEntry(label: 'One'),
          M3EMenuEntry(label: 'Skip', enabled: false),
          M3EMenuEntry(label: 'Three'),
        ],
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();

  expect(_focusShows(tester, 'Three'), isTrue);
}

Future<void> _letterKeysTypeahead(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3EMenu(
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: const <M3EMenuNode>[
          M3EMenuEntry(label: 'One'),
          M3EMenuEntry(label: 'Two'),
          M3EMenuEntry(label: 'Three'),
        ],
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);
  await tester.sendKeyEvent(LogicalKeyboardKey.keyT);
  await tester.pump();

  expect(_focusShows(tester, 'Two'), isTrue);
}

Future<void> _multiSelectKeepsMenuOpen(WidgetTester tester) async {
  final picked = <Object?>[];

  await tester.pumpWidget(
    _host(
      M3EMenu(
        selectionMode: M3EMenuSelectionMode.multi,
        onSelected: picked.add,
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: const <M3EMenuNode>[
          M3EMenuSelectable(label: 'Alpha', value: 'a'),
          M3EMenuSelectable(label: 'Beta', value: 'b'),
        ],
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);
  await tester.tap(find.text('Alpha'));
  await _settleSpring(tester);

  expect(picked, <Object?>['a']);
  expect(find.text('Beta'), findsOneWidget);
}

Future<void> _multiSelectRebuildsAnchor(WidgetTester tester) async {
  final selected = <String>{};

  await tester.pumpWidget(
    _host(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return M3EMenu(
            selectionMode: M3EMenuSelectionMode.multi,
            onSelected: (Object? value) {
              setState(() => selected.add(value! as String));
            },
            anchorBuilder: (BuildContext context, VoidCallback open) {
              return TextButton(onPressed: open, child: const Text('Open'));
            },
            children: <M3EMenuNode>[
              M3EMenuSelectable(
                label: 'Alpha',
                value: 'a',
                selected: selected.contains('a'),
              ),
              M3EMenuSelectable(
                label: 'Beta',
                value: 'b',
                selected: selected.contains('b'),
              ),
            ],
          );
        },
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);
  await tester.tap(find.text('Alpha'));
  await _settleSpring(tester);

  expect(tester.takeException(), isNull);
  expect(selected, <String>{'a'});
  expect(find.text('Beta'), findsOneWidget);
}

Future<void> _scrollingMenuUsesDividers(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      Builder(
        builder: (BuildContext context) {
          return TextButton(
            onPressed: () {
              final box = context.findRenderObject()! as RenderBox;
              showM3EMenu<void>(
                context: context,
                anchor: box.localToGlobal(Offset.zero) & box.size,
                themeOverride: const M3EMenuTheme(maxHeight: 80),
                children: const <M3EMenuNode>[
                  M3EMenuGroup(
                    children: <M3EMenuNode>[
                      M3EMenuEntry(label: 'One'),
                      M3EMenuEntry(label: 'Two'),
                      M3EMenuEntry(label: 'Three'),
                      M3EMenuEntry(label: 'Four'),
                    ],
                  ),
                  M3EMenuGroup(
                    children: <M3EMenuNode>[
                      M3EMenuEntry(label: 'Five'),
                      M3EMenuEntry(label: 'Six'),
                    ],
                  ),
                ],
              );
            },
            child: const Text('Show'),
          );
        },
      ),
    ),
  );

  await tester.tap(find.text('Show'));
  await _settleSpring(tester);

  expect(find.byType(M3EMenuDividerWidget), findsOneWidget);
  final RawScrollbar bar = tester.widget<RawScrollbar>(
    find.byType(RawScrollbar),
  );
  expect(bar.thumbVisibility, isTrue);
  expect(bar.controller!.position.maxScrollExtent, greaterThan(0));
}

Future<void> _groupedMenusKeepGapWhenNotScrolling(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3EMenu(
        anchorBuilder: (BuildContext context, VoidCallback open) {
          return TextButton(onPressed: open, child: const Text('Open'));
        },
        children: const <M3EMenuNode>[
          M3EMenuGroup(children: <M3EMenuNode>[M3EMenuEntry(label: 'One')]),
          M3EMenuGroup(children: <M3EMenuNode>[M3EMenuEntry(label: 'Two')]),
        ],
      ),
    ),
  );

  await tester.tap(find.text('Open'));
  await _settleSpring(tester);

  expect(find.text('One'), findsOneWidget);
  expect(find.byType(M3EMenuDividerWidget), findsNothing);
}
