import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets(
    'M3EIconButton renders its icon and fires onPressed',
    _m3eiconbuttonRendersItsIconAndFiresOnpressed,
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
    'M3ENavigationRail FAB slot supports custom elevation',
    _m3enavigationrailFabSlotSupportsCustomElevation,
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
      M3EIconButton(icon: const Icon(M3EIcons.menu), onPressed: () => taps++),
    ),
  );

  expect(find.byIcon(M3EIcons.menu), findsOneWidget);
  await tester.tap(find.byType(M3EIconButton));
  expect(taps, 1);
}

Future<void> _m3enavigationrailRendersSectionDestinations(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      M3ENavigationRail(
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
  expect(find.byTooltip('Expand'), findsOneWidget);

  await tester.pumpWidget(
    _host(
      buildRail(M3ENavigationRailType.expanded, const ValueKey('expanded')),
    ),
  );
  await tester.pump();
  expect(find.byTooltip('Collapse'), findsOneWidget);
}

Future<void> _m3enavigationrailFabSlotSupportsCustomElevation(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      M3ENavigationRail(
        type: M3ENavigationRailType.collapsed,
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        fab: const M3ENavigationRailFabSlot(
          icon: Icon(M3EIcons.add),
          label: 'Create',
          elevation: 0,
          hoverElevation: 0,
        ),
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
      ),
    ),
  );
  await tester.pump();

  final fabContainer = tester.widget<AnimatedContainer>(
    find.descendant(
      of: find.byType(M3EFab),
      matching: find.byType(AnimatedContainer),
    ),
  );
  final decoration = fabContainer.decoration;

  expect(decoration, isA<BoxDecoration>());
  expect((decoration! as BoxDecoration).boxShadow, isEmpty);
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
  await tester.pump(M3ENavigationRailLayout.expandDuration);

  final double starredY = tester.getTopLeft(find.text('Starred')).dy;

  // Simulate fullscreen search keyboard / route MediaQuery settle.
  await tester.pumpWidget(
    buildRail(viewInsets: const EdgeInsets.only(bottom: 300)),
  );
  await tester.pump();
  await tester.pump();
  await tester.pump(M3ENavigationRailLayout.expandDuration);
  await tester.pumpWidget(buildRail(viewInsets: EdgeInsets.zero));
  await tester.pump();
  await tester.pump();
  await tester.pump(M3ENavigationRailLayout.expandDuration);
  await tester.pump(const Duration(milliseconds: 16));

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

  final Rect rect = tester.getRect(find.byType(M3ESlider));
  await tester.tapAt(Offset(rect.left + rect.width * 0.2, rect.center.dy));
  expect(value, isNot(0.5));
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
