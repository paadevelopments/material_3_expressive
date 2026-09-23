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
