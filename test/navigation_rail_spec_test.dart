import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/navigation_rail/components/m3e_nav_selection_indicator.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const List<M3ENavigationRailDestination> _destinations =
    <M3ENavigationRailDestination>[
      M3ENavigationRailDestination(icon: Icon(M3EIcons.home), label: 'Home'),
      M3ENavigationRailDestination(
        icon: Icon(M3EIcons.search),
        label: 'Search',
      ),
      M3ENavigationRailDestination(
        icon: Icon(M3EIcons.mail),
        label: 'Inbox',
        badgeCount: 3,
      ),
    ];

void main() {
  setUp(M3EFocusInteraction.resetForTest);

  testWidgets('collapsed width is 96 and expanded width is 220', _widths);
  testWidgets('collapsed pill is 56 by 32', _collapsedPill);
  testWidgets('expanded pill hugs and can fill the rail', _hugAndFill);
  testWidgets('colors follow the later role pass', _colors);
  testWidgets('arrow moves focus and enter selects', _keyboard);
  testWidgets('pointer tap dismisses the focus ring', _pointerDismissesRing);
  testWidgets('text scale wraps through 2x and ellipsizes above', _textScale);
  testWidgets('scrim and escape dismiss a modal rail', _modalDismiss);
  testWidgets('hidden rail opens already expanded', _hiddenOpensExpanded);
  testWidgets(
    'destination list pads only under header controls',
    _destinationListPadding,
  );
  testWidgets('divider paints beside a square container', _divider);
  testWidgets('horizontal scroll raises the rail', _scrollUnder);
  testWidgets('controller selects and collapses', _controller);
  testWidgets('destination ink paints without a scaffold', _inkWithoutScaffold);
}

Widget _rail({
  Key? key,
  M3ENavigationRailType type = M3ENavigationRailType.alwaysExpand,
  M3ENavigationRailModality modality = M3ENavigationRailModality.standard,
  int selectedIndex = 0,
  ValueChanged<int>? onDestinationSelected,
  VoidCallback? onDismissModal,
  bool fill = false,
  TextScaler textScaler = TextScaler.noScaling,
  List<M3ENavigationRailDestination>? destinations,
  Widget? beside,
  bool showDivider = false,
  bool hideWhenCollapsed = false,
}) {
  final Widget rail = M3ENavigationRail(
    key: key,
    type: type,
    modality: modality,
    selectedIndex: selectedIndex,
    onDestinationSelected: onDestinationSelected ?? (_) {},
    onDismissModal: onDismissModal,
    showDivider: showDivider,
    hideWhenCollapsed: hideWhenCollapsed,
    sections: <M3ENavigationRailSection>[
      M3ENavigationRailSection(destinations: destinations ?? _destinations),
    ],
  );
  return MaterialApp(
    builder: (BuildContext context, Widget? child) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: textScaler),
        child: child!,
      );
    },
    home: Builder(
      builder: (BuildContext context) {
        final M3EThemeData data = M3ETheme.of(context);
        return M3ETheme(
          data: data.copyWith(
            navigationRailTheme: data.navigationRailTheme.copyWith(
              indicatorFillsWidth: fill,
            ),
          ),
          child: Scaffold(
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                rail,
                if (beside != null) Expanded(child: beside),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Future<void> _widths(WidgetTester tester) async {
  await tester.pumpWidget(
    _rail(type: M3ENavigationRailType.alwaysCollapse, key: const Key('narrow')),
  );
  await tester.pump();
  expect(tester.getSize(find.byType(M3ENavigationRail)).width, 96);

  await tester.pumpWidget(_rail(key: const Key('wide')));
  await tester.pump();
  expect(tester.getSize(find.byType(M3ENavigationRail)).width, 220);
}

Future<void> _collapsedPill(WidgetTester tester) async {
  await tester.pumpWidget(_rail(type: M3ENavigationRailType.alwaysCollapse));
  await tester.pump();
  final Size pill = tester.getSize(
    find.descendant(
      of: find.byType(M3ESelectionIndicator).first,
      matching: find.byType(DecoratedBox),
    ),
  );
  expect(pill.width, 56);
  expect(pill.height, 32);
}

Future<void> _hugAndFill(WidgetTester tester) async {
  await tester.pumpWidget(_rail());
  await tester.pump();
  final Size hugged = tester.getSize(
    find.descendant(
      of: find.byType(M3ESelectionIndicator).first,
      matching: find.byType(DecoratedBox),
    ),
  );
  expect(hugged.height, greaterThanOrEqualTo(56));
  expect(hugged.width, lessThan(172));
  expect(hugged.width, greaterThan(56));
  final double railLeft = tester.getTopLeft(find.byType(M3ENavigationRail)).dx;
  final double home = tester.getTopLeft(find.byIcon(M3EIcons.home)).dx;
  final double search = tester.getTopLeft(find.byIcon(M3EIcons.search)).dx;
  expect(home, closeTo(railLeft + 40, 1));
  expect(search, closeTo(home, 1));
  expect(
    tester.getTopLeft(find.byType(M3ESelectionIndicator).first).dx,
    closeTo(railLeft + 24, 1),
  );

  await tester.pumpWidget(_rail(fill: true, key: const Key('fill')));
  await tester.pump();
  final Size filled = tester.getSize(
    find.descendant(
      of: find.byType(M3ESelectionIndicator).first,
      matching: find.byType(DecoratedBox),
    ),
  );
  expect(filled.width, closeTo(172, 1));
  expect(
    tester.getTopLeft(find.byIcon(M3EIcons.home)).dx,
    closeTo(tester.getTopLeft(find.byType(M3ENavigationRail)).dx + 40, 1),
  );
}

Future<void> _colors(WidgetTester tester) async {
  await tester.pumpWidget(_rail(type: M3ENavigationRailType.alwaysCollapse));
  await tester.pump();
  final BuildContext context = tester.element(find.byType(M3ENavigationRail));
  final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
  final decoration = _container(tester).decoration as BoxDecoration;
  expect(decoration.color, scheme.surface);
  expect(decoration.boxShadow, isEmpty);
  final Text active = tester.widget<Text>(find.text('Home'));
  expect(active.style?.color, scheme.onSurface);
  expect(active.style?.fontWeight, FontWeight.w700);
  expect(active.style?.fontSize, 12);
  final Text inactive = tester.widget<Text>(find.text('Search'));
  expect(inactive.style?.color, scheme.onSurfaceVariant);
  expect(inactive.style?.fontWeight, FontWeight.w500);
  expect(
    IconTheme.of(tester.element(find.byIcon(M3EIcons.home))).color,
    scheme.onSecondaryContainer,
  );
  final DecoratedBox pill = tester.widget<DecoratedBox>(
    find.descendant(
      of: find.byType(M3ESelectionIndicator).first,
      matching: find.byType(DecoratedBox),
    ),
  );
  expect((pill.decoration as BoxDecoration).color, scheme.secondaryContainer);
  expect(
    tester.widget<M3EBadge>(find.byType(M3EBadge)).backgroundColor,
    scheme.error,
  );
}

Future<void> _keyboard(WidgetTester tester) async {
  var selected = 0;
  var calls = 0;
  await tester.pumpWidget(
    _rail(
      type: M3ENavigationRailType.expanded,
      selectedIndex: selected,
      onDestinationSelected: (int index) {
        calls += 1;
        selected = index;
      },
    ),
  );
  await tester.pump();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowDown);
  expect(selected, 0);
  expect(calls, 0);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
  await tester.pump(const Duration(milliseconds: 150));
  expect(selected, 1);
  expect(calls, 1);
  expect(tester.takeException(), isNull);
}

Future<void> _pointerDismissesRing(WidgetTester tester) async {
  await tester.pumpWidget(_rail(type: M3ENavigationRailType.alwaysCollapse));
  await tester.pump();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);
  expect(_hasFocusRing(tester), isTrue);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.tap(find.text('Home'));
  await tester.pump();
  expect(M3EFocusInteraction.instance.ringsAllowed, isFalse);
  expect(_hasFocusRing(tester), isFalse);
}

Future<void> _textScale(WidgetTester tester) async {
  const destinations = <M3ENavigationRailDestination>[
    M3ENavigationRailDestination(
      icon: Icon(M3EIcons.home),
      label: 'Notifications and saved',
    ),
  ];
  await tester.pumpWidget(_rail(destinations: destinations));
  await tester.pump();
  expect(tester.widget<Text>(find.text('Notifications and saved')).maxLines, 1);

  await tester.pumpWidget(
    _rail(destinations: destinations, textScaler: const TextScaler.linear(1.5)),
  );
  await tester.pump();
  expect(tester.widget<Text>(find.text('Notifications and saved')).maxLines, 2);

  await tester.pumpWidget(
    _rail(destinations: destinations, textScaler: const TextScaler.linear(2.5)),
  );
  await tester.pump();
  final Text scaled = tester.widget<Text>(find.text('Notifications and saved'));
  expect(scaled.maxLines, 1);
  expect(scaled.overflow, TextOverflow.ellipsis);
}

Future<void> _modalDismiss(WidgetTester tester) async {
  var dismissed = 0;
  await tester.pumpWidget(
    _rail(
      key: const Key('scrim'),
      type: M3ENavigationRailType.expanded,
      modality: M3ENavigationRailModality.modal,
      onDismissModal: () => dismissed++,
    ),
  );
  await tester.pump();
  expect(
    tester
        .getSize(
          find.descendant(
            of: find.byType(M3ESelectionIndicator).first,
            matching: find.byType(DecoratedBox),
          ),
        )
        .height,
    greaterThanOrEqualTo(56),
  );
  await tester.pump(const Duration(milliseconds: 40));
  expect(
    tester
        .getSize(
          find.descendant(
            of: find.byType(M3ESelectionIndicator).first,
            matching: find.byType(DecoratedBox),
          ),
        )
        .height,
    greaterThanOrEqualTo(56),
  );
  await tester.pumpAndSettle();
  await tester.tapAt(const Offset(700, 300));
  await tester.pump();
  expect(dismissed, 1);
  await tester.pumpAndSettle();
  expect(tester.getSize(find.byType(M3ENavigationRail)).width, 0);

  dismissed = 0;
  await tester.pumpWidget(
    _rail(
      key: const Key('escape'),
      type: M3ENavigationRailType.expanded,
      modality: M3ENavigationRailModality.modal,
      onDismissModal: () => dismissed++,
    ),
  );
  await tester.pumpAndSettle();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
  expect(dismissed, 1);
  await tester.pump(M3ENavigationRailLayout.selectionDelay);
  expect(tester.takeException(), isNull);
  await tester.pumpAndSettle();
  expect(tester.getSize(find.byType(M3ENavigationRail)).width, 0);
}

Future<void> _hiddenOpensExpanded(WidgetTester tester) async {
  await tester.pumpWidget(
    _rail(type: M3ENavigationRailType.collapsed, hideWhenCollapsed: true),
  );
  await tester.pump();
  await tester.tap(
    find.descendant(
      of: find.byType(CompositedTransformFollower),
      matching: find.byIcon(M3EIcons.menu),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 40));
  expect(tester.takeException(), isNull);
  expect(
    tester
        .getSize(
          find.descendant(
            of: find.byType(M3ESelectionIndicator).first,
            matching: find.byType(DecoratedBox),
          ),
        )
        .height,
    greaterThanOrEqualTo(56),
  );
  await tester.pump(M3ENavigationRailLayout.selectionDelay);
}

double _listTop(WidgetTester tester) {
  final padding =
      tester.widget<ListView>(find.byType(ListView)).padding! as EdgeInsets;
  return padding.top;
}

Future<void> _destinationListPadding(WidgetTester tester) async {
  await tester.pumpWidget(_rail());
  await tester.pump();
  expect(_listTop(tester), 0);

  await tester.pumpWidget(
    _rail(key: const Key('menu'), type: M3ENavigationRailType.expanded),
  );
  await tester.pump();
  expect(_listTop(tester), 12);
}

Future<void> _divider(WidgetTester tester) async {
  await tester.pumpWidget(_rail(showDivider: true));
  await tester.pump();
  expect(tester.takeException(), isNull);
  expect(find.byType(M3ENavigationRail), findsOneWidget);
}

Future<void> _scrollUnder(WidgetTester tester) async {
  Future<void> pumpBeside(Axis axis, {Key? key}) {
    return tester.pumpWidget(
      _rail(
        key: key,
        beside: ListView(
          key: const Key('body-scroll'),
          scrollDirection: axis,
          children: const <Widget>[SizedBox(width: 1600, height: 1600)],
        ),
      ),
    );
  }

  await pumpBeside(Axis.horizontal);
  await tester.pump();
  final BuildContext context = tester.element(find.byType(M3ENavigationRail));
  final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
  BoxDecoration decoration() => _container(tester).decoration as BoxDecoration;
  expect(decoration().color, scheme.surface);
  expect(decoration().boxShadow, isEmpty);

  await tester.drag(
    find.byKey(const Key('body-scroll')),
    const Offset(-120, 0),
  );
  await tester.pump();
  expect(decoration().color, scheme.surfaceContainer);
  expect(decoration().boxShadow, isNotEmpty);

  await pumpBeside(Axis.vertical, key: const Key('vertical-body'));
  await tester.pump();
  expect(decoration().color, scheme.surface);
  await tester.drag(
    find.byKey(const Key('body-scroll')),
    const Offset(0, -120),
  );
  await tester.pump();
  expect(decoration().color, scheme.surface);
  expect(decoration().boxShadow, isEmpty);
}

Future<void> _controller(WidgetTester tester) async {
  final controller = M3ENavigationRailController();
  addTearDown(controller.dispose);
  var selected = 0;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return M3ENavigationRail(
              controller: controller,
              selectedIndex: selected,
              onDestinationSelected: (int index) {
                setState(() => selected = index);
              },
              sections: const <M3ENavigationRailSection>[
                M3ENavigationRailSection(destinations: _destinations),
              ],
            );
          },
        ),
      ),
    ),
  );
  await tester.pump();
  controller.select(2);
  await tester.pump();
  expect(selected, 2);
  expect(controller.index, 2);
  controller.collapse();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  expect(controller.expanded, isFalse);
  expect(tester.getSize(find.byType(M3ENavigationRail)).width, lessThan(220));
}

Future<void> _inkWithoutScaffold(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ColoredBox(
        color: const Color(0xFF141218),
        child: M3ENavigationRail(
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          sections: const <M3ENavigationRailSection>[
            M3ENavigationRailSection(destinations: _destinations),
          ],
        ),
      ),
    ),
  );
  await tester.pump();
  expect(tester.takeException(), isNull);
}

DecoratedBox _container(WidgetTester tester) {
  final Size rail = tester.getSize(find.byType(M3ENavigationRail));
  final List<DecoratedBox> matches = tester
      .widgetList<DecoratedBox>(find.byType(DecoratedBox))
      .where((DecoratedBox box) {
        final Decoration decoration = box.decoration;
        if (decoration is! BoxDecoration || decoration.boxShadow == null) {
          return false;
        }
        final Size size = tester.getSize(find.byWidget(box));
        return (size.width - rail.width).abs() < 1 &&
            (size.height - rail.height).abs() < 1;
      })
      .toList();
  return matches.single;
}

bool _hasFocusRing(WidgetTester tester) {
  return tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).any((
    DecoratedBox box,
  ) {
    final Decoration decoration = box.decoration;
    return decoration is BoxDecoration &&
        decoration.border != null &&
        decoration.border!.top.width >= 3;
  });
}
