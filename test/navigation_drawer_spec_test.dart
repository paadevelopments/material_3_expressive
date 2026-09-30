import 'dart:ui' show PointerDeviceKind, SemanticsRole;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/navigation_drawer/components/m3e_drawer_destination_button.dart';
import 'package:material_3_expressive/components/navigation_rail/components/m3e_nav_selection_indicator.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const List<M3ENavigationDestination> _destinations = <M3ENavigationDestination>[
  M3ENavigationDestination(icon: Icon(M3EIcons.home), label: 'Home'),
  M3ENavigationDestination(icon: Icon(M3EIcons.search), label: 'Search'),
  M3ENavigationDestination(
    icon: Icon(M3EIcons.mail),
    label: 'Inbox',
    badgeLabel: '24',
  ),
];

void main() {
  setUp(M3EFocusInteraction.resetForTest);

  testWidgets('width, pill, icon origin, and end radius', _geometry);
  testWidgets('rows sit flush and labels stay on one line', _rows);
  testWidgets('colors follow the drawer roles', _colors);
  testWidgets('hover and press use the state layers', _stateLayers);
  testWidgets(
    'pointer interaction dismisses the focus ring',
    _pointerDismissesRing,
  );
  testWidgets('arrows move focus and enter selects', _keyboard);
  testWidgets('section indent and divider', _section);
  testWidgets('drawer scrolls without moving the body', _scroll);
  testWidgets('modal dismisses from scrim, drag, selection, and back', _modal);
  testWidgets('dismissible standard stays open on selection', _dismissible);
  testWidgets('controller selects and closes', _controller);
  testWidgets('semantic label overrides the visible name', _semantics);
  testWidgets('destination ink uses InkSparkle', _ink);
}

Widget _app({
  M3ENavigationDrawerType type = M3ENavigationDrawerType.standard,
  bool dismissible = false,
  int selectedIndex = 0,
  ValueChanged<int>? onDestinationSelected,
  List<M3ENavigationDestination>? destinations,
  List<M3ENavigationDrawerSection> sections =
      const <M3ENavigationDrawerSection>[],
  String? headline = 'Mail',
  M3ENavigationDrawerController? controller,
  VoidCallback? onDismissed,
  Widget? beside,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          M3ENavigationDrawer(
            type: type,
            dismissible: dismissible,
            headline: headline,
            destinations: destinations ?? _destinations,
            sections: sections,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected ?? (_) {},
            controller: controller,
            onDismissed: onDismissed,
          ),
          if (beside != null) Expanded(child: beside),
        ],
      ),
    ),
  );
}

Future<void> _geometry(WidgetTester tester) async {
  await tester.pumpWidget(_app());
  await tester.pump();
  final drawer = tester.getRect(find.byType(M3ENavigationDrawer));
  expect(drawer.width, closeTo(360, 1));
  final indicator = tester.getRect(
    find.byWidgetPredicate(
      (Widget widget) => widget is M3ESelectionIndicator && widget.selected,
    ),
  );
  expect(indicator.width, closeTo(336, 1));
  expect(indicator.height, closeTo(56, 1));
  expect(indicator.left, closeTo(drawer.left + 12, 1));
  expect(
    tester.getTopLeft(find.byIcon(M3EIcons.home)).dx,
    closeTo(drawer.left + 28, 1),
  );
  expect(tester.getTopLeft(find.text('Mail')).dy, closeTo(drawer.top + 16, 1));
  final BoxDecoration decoration = tester
      .widgetList<DecoratedBox>(find.byType(DecoratedBox))
      .map((DecoratedBox box) => box.decoration)
      .whereType<BoxDecoration>()
      .firstWhere(
        (BoxDecoration decoration) => decoration.borderRadius != null,
      );
  final radius = decoration.borderRadius! as BorderRadius;
  expect(radius.topLeft, Radius.zero);
  expect(radius.topRight, const Radius.circular(16));
  expect(radius.bottomRight, const Radius.circular(16));
}

Future<void> _rows(WidgetTester tester) async {
  await tester.pumpWidget(_app());
  await tester.pump();
  final Finder buttons = find.byType(M3EDrawerDestinationButton);
  final first = tester.getRect(buttons.at(0));
  final second = tester.getRect(buttons.at(1));
  expect(first.height, closeTo(56, 0.5));
  expect(second.top - first.bottom, closeTo(0, 0.5));
  expect(tester.widget<Text>(find.text('Home')).maxLines, 1);
  expect(
    tester.widget<Text>(find.text('Home')).style?.fontWeight,
    FontWeight.w700,
  );
  expect(find.text('24'), findsOneWidget);
}

Future<void> _colors(WidgetTester tester) async {
  await tester.pumpWidget(_app());
  await tester.pump();
  final M3EColorScheme scheme = M3ETheme.of(
    tester.element(find.byType(M3ENavigationDrawer)),
  ).colorScheme;
  expect(
    tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).any((
      DecoratedBox box,
    ) {
      final Decoration decoration = box.decoration;
      return decoration is BoxDecoration && decoration.color == scheme.surface;
    }),
    isTrue,
  );
  expect(
    tester.widget<Text>(find.text('Home')).style?.color,
    scheme.onSecondaryContainer,
  );
  expect(
    tester.widget<Text>(find.text('Search')).style?.color,
    scheme.onSurfaceVariant,
  );
  expect(
    tester.widget<Text>(find.text('24')).style?.color,
    scheme.onSurfaceVariant,
  );
}

Future<void> _stateLayers(WidgetTester tester) async {
  await tester.pumpWidget(_app());
  await tester.pump();
  final M3EColorScheme scheme = M3ETheme.of(
    tester.element(find.byType(M3ENavigationDrawer)),
  ).colorScheme;
  final TestGesture hover = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await hover.addPointer(location: Offset.zero);
  addTearDown(hover.removePointer);
  await tester.pump();
  await hover.moveTo(tester.getCenter(find.text('Search')));
  await tester.pump();
  expect(_hasLayer(tester, scheme.onSurface, 0.08), isTrue);

  final TestGesture press = await tester.startGesture(
    tester.getCenter(find.text('Search')),
  );
  await tester.pump();
  expect(_hasLayer(tester, scheme.onSecondaryContainer, 0.1), isTrue);
  await press.up();
  await tester.pumpAndSettle();
}

Future<void> _pointerDismissesRing(WidgetTester tester) async {
  final previous = FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() => FocusManager.instance.highlightStrategy = previous);
  await tester.pumpWidget(_app());
  await tester.pump();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);
  expect(_hasFocusRing(tester), isTrue);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);

  final TestGesture mouse = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await mouse.addPointer();
  await mouse.moveTo(const Offset(180, 520));
  await tester.pump();
  expect(M3EFocusInteraction.instance.ringsAllowed, isFalse);
  expect(_hasFocusRing(tester), isFalse);

  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  expect(_hasFocusRing(tester), isTrue);
  await mouse.down(tester.getCenter(find.text('Home')));
  await tester.pump();
  expect(_hasFocusRing(tester), isFalse);
  await mouse.up();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  expect(_hasFocusRing(tester), isFalse);
  await mouse.removePointer();
}

Future<void> _keyboard(WidgetTester tester) async {
  var index = 0;
  await tester.pumpWidget(
    _app(onDestinationSelected: (int value) => index = value),
  );
  await tester.pump();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  expect(_focused(tester, 'Home'), isTrue);
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();
  expect(_focused(tester, 'Search'), isTrue);
  expect(index, 0);
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();
  expect(_focused(tester, 'Inbox'), isTrue);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump();
  expect(index, 2);
  expect(_focused(tester, 'Inbox'), isTrue);
}

Future<void> _section(WidgetTester tester) async {
  await tester.pumpWidget(
    _app(
      sections: const <M3ENavigationDrawerSection>[
        M3ENavigationDrawerSection(
          header: 'Labels',
          destinations: <M3ENavigationDestination>[
            M3ENavigationDestination(
              icon: Icon(M3EIcons.folder),
              label: 'Personal',
            ),
          ],
        ),
      ],
    ),
  );
  await tester.pump();
  expect(find.text('Labels'), findsOneWidget);
  expect(
    tester
        .widgetList<SizedBox>(find.byType(SizedBox))
        .any((SizedBox box) => box.height == 1),
    isTrue,
  );
  final primary = tester.getTopLeft(find.byIcon(M3EIcons.home)).dx;
  final nested = tester.getTopLeft(find.byIcon(M3EIcons.folder)).dx;
  expect(nested, closeTo(primary + 12, 1));
}

Future<void> _scroll(WidgetTester tester) async {
  final many = <M3ENavigationDestination>[
    for (int i = 0; i < 20; i++)
      M3ENavigationDestination(
        icon: const Icon(M3EIcons.mail),
        label: 'Item $i',
      ),
  ];
  await tester.pumpWidget(
    _app(headline: null, destinations: many, beside: const Text('Body stays')),
  );
  await tester.pump();
  final body = tester.getTopLeft(find.text('Body stays'));
  await tester.drag(find.text('Item 0'), const Offset(0, -240));
  await tester.pump();
  expect(tester.getTopLeft(find.text('Body stays')), body);
  expect(find.text('Item 0'), findsNothing);
}

Future<void> _modal(WidgetTester tester) async {
  final controller = M3ENavigationDrawerController();
  var index = 0;
  var dismissed = 0;
  try {
    await tester.pumpWidget(
      _app(
        type: M3ENavigationDrawerType.modal,
        controller: controller,
        onDismissed: () => dismissed++,
        onDestinationSelected: (int value) => index = value,
      ),
    );
    await tester.pump();
    expect(find.text('Home'), findsNothing);

    controller.open();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Home'), findsOneWidget);
    expect(tester.getSize(find.byType(M3ENavigationDrawer)).width, 0);
    final M3EColorScheme scheme = M3ETheme.of(
      tester.element(find.byType(M3ENavigationDrawer)),
    ).colorScheme;
    expect(
      tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).any((
        DecoratedBox box,
      ) {
        final Decoration decoration = box.decoration;
        return decoration is BoxDecoration &&
            decoration.color == scheme.surfaceContainer;
      }),
      isTrue,
    );

    await tester.tapAt(const Offset(520, 200));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Home'), findsNothing);
    expect(dismissed, 1);

    controller.open();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.drag(find.text('Home'), const Offset(-220, 0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Home'), findsNothing);

    controller.open();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('Search'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(index, 1);
    expect(find.text('Home'), findsNothing);

    controller.open();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    await navigator.maybePop();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Home'), findsNothing);
  } finally {
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  }
}

Future<void> _dismissible(WidgetTester tester) async {
  final controller = M3ENavigationDrawerController(isOpen: true);
  var index = 0;
  try {
    await tester.pumpWidget(
      _app(
        dismissible: true,
        controller: controller,
        onDestinationSelected: (int value) => index = value,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.text('Search'));
    await tester.pump();
    expect(index, 1);
    expect(find.text('Home'), findsOneWidget);
    expect(
      tester.getSize(find.byType(M3ENavigationDrawer)).width,
      greaterThan(300),
    );
  } finally {
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  }
}

Future<void> _controller(WidgetTester tester) async {
  final controller = M3ENavigationDrawerController(isOpen: true);
  var index = 0;
  try {
    await tester.pumpWidget(
      _app(
        dismissible: true,
        controller: controller,
        onDestinationSelected: (int value) => index = value,
      ),
    );
    await tester.pump();
    controller.select(2);
    await tester.pump();
    expect(index, 2);
    controller.close();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(tester.getSize(find.byType(M3ENavigationDrawer)).width, lessThan(1));
  } finally {
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  }
}

Future<void> _semantics(WidgetTester tester) async {
  await tester.pumpWidget(
    _app(
      destinations: const <M3ENavigationDestination>[
        M3ENavigationDestination(
          icon: Icon(M3EIcons.image),
          label: 'Recents',
          semanticLabel: 'Recent images',
        ),
        M3ENavigationDestination(icon: Icon(M3EIcons.mail), label: 'Inbox'),
      ],
    ),
  );
  await tester.pump();
  final semantics = tester.widget<Semantics>(
    find.byWidgetPredicate(
      (Widget widget) =>
          widget is Semantics && widget.properties.label == 'Recent images',
    ),
  );
  expect(semantics.properties.role, SemanticsRole.tab);
  expect(semantics.properties.selected, isTrue);
  expect(
    tester
        .widgetList<MouseRegion>(find.byType(MouseRegion))
        .any((MouseRegion region) => region.cursor == SystemMouseCursors.click),
    isTrue,
  );
}

Future<void> _ink(WidgetTester tester) async {
  await tester.pumpWidget(_app());
  await tester.pump();
  expect(
    tester.widget<InkWell>(find.byType(InkWell).first).splashFactory,
    InkSparkle.splashFactory,
  );
}

bool _focused(WidgetTester tester, String label) {
  var focused = false;
  tester.element(find.text(label)).visitAncestorElements((Element ancestor) {
    final focus = ancestor.widget;
    if (focus is Focus && (focus.focusNode?.hasFocus ?? false)) {
      focused = true;
      return false;
    }
    return true;
  });
  return focused;
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

bool _hasLayer(WidgetTester tester, Color color, double alpha) {
  return tester.widgetList<DecoratedBox>(find.byType(DecoratedBox)).any((
    DecoratedBox box,
  ) {
    final Decoration decoration = box.decoration;
    if (decoration is! BoxDecoration) {
      return false;
    }
    final Color? layer = decoration.color;
    if (layer == null) {
      return false;
    }
    return (layer.a - alpha).abs() < 0.02 &&
        layer.r == color.r &&
        layer.g == color.g &&
        layer.b == color.b;
  });
}
