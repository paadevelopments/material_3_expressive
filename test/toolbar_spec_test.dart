import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  setUp(M3EFocusInteraction.resetForTest);

  test(
    'toolbar color roles follow the scheme',
    _toolbarColorRolesFollowTheScheme,
  );
  testWidgets(
    'floating elevation is level 3 and docked stays flat',
    _floatingElevationIsLevel3AndDockedStaysFlat,
  );
  testWidgets('vertical floating margin is 24', _verticalFloatingMarginIs24);
  testWidgets(
    'horizontal floating margin stays 16',
    _horizontalFloatingMarginStays16,
  );
  testWidgets(
    'wide docked gap stays at 32 and a tight bar stops at 4',
    _wideDockedGapStaysAt32AndATightBarStopsAt4,
  );
  testWidgets(
    'centered and edge alignment apply from 600 wide',
    _centeredAndEdgeAlignmentApplyFrom600Wide,
  );
  testWidgets(
    'standard FAB is secondary container and morphs 80 to 56',
    _standardFabIsSecondaryContainerAndMorphs80To56,
  );
  testWidgets(
    'scroll exit keeps the toolbar from collapsing to the FAB',
    _scrollExitKeepsTheToolbarFromCollapsingToTheFab,
  );
  testWidgets(
    'arrows move focus and a pointer hides the ring',
    _arrowsMoveFocusAndAPointerHidesTheRing,
  );
  testWidgets(
    'horizontal order follows the reading direction',
    _horizontalOrderFollowsTheReadingDirection,
  );
  testWidgets(
    'selected actions are tonal and the emphasis action is filled',
    _selectedActionsAreTonalAndTheEmphasisActionIsFilled,
  );
}

void _toolbarColorRolesFollowTheScheme() {
  final M3EColorScheme scheme = M3EThemeData.light().colorScheme;
  final M3EToolbarTheme theme = M3EToolbarTheme.defaults;

  final M3EToolbarColors standard = theme.colors(
    scheme,
    M3EToolbarColorStyle.standard,
  );
  expect(standard.container, scheme.surfaceContainer);
  expect(standard.content, scheme.onSurfaceVariant);
  expect(standard.selectedContainer, scheme.secondaryContainer);
  expect(standard.selectedContent, scheme.onSecondaryContainer);
  expect(standard.fabContainer, scheme.secondaryContainer);
  expect(standard.fabContent, scheme.onSecondaryContainer);
  expect(standard.emphasisContainer, scheme.primary);
  expect(standard.emphasisContent, scheme.onPrimary);
  expect(
    standard.disabledContent,
    scheme.onSurface.withValues(alpha: M3EToolbarTokens.disabledContentAlpha),
  );

  final M3EToolbarColors vibrant = theme.colors(
    scheme,
    M3EToolbarColorStyle.vibrant,
  );
  expect(vibrant.container, scheme.primaryContainer);
  expect(vibrant.content, scheme.onPrimaryContainer);
  expect(vibrant.selectedContainer, scheme.surfaceContainer);
  expect(vibrant.selectedContent, scheme.onSurface);
  expect(vibrant.fabContainer, scheme.tertiaryContainer);
  expect(vibrant.fabContent, scheme.onTertiaryContainer);
}

Future<void> _floatingElevationIsLevel3AndDockedStaysFlat(
  WidgetTester tester,
) async {
  await tester.pumpWidget(_host(child: M3EToolbar(actions: _actions())));
  expect(_toolbarMaterial(tester).elevation, M3EElevation.level3);

  await tester.pumpWidget(
    _host(
      child: const M3EToolbar.docked(
        safeArea: false,
        actions: <M3EToolbarItem>[
          M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
        ],
      ),
    ),
  );
  expect(_toolbarMaterial(tester).elevation, 0);
}

Future<void> _verticalFloatingMarginIs24(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      child: M3EToolbar(axis: Axis.vertical, actions: _actions()),
    ),
  );
  final EdgeInsets insets = _outerPadding(tester);
  expect(insets.left, M3EToolbarTokens.verticalScreenOffset);
  expect(insets.right, M3EToolbarTokens.verticalScreenOffset);
  expect(insets.top, M3EToolbarTokens.verticalScreenOffset);
  expect(insets.bottom, M3EToolbarTokens.verticalScreenOffset);
}

Future<void> _horizontalFloatingMarginStays16(WidgetTester tester) async {
  await tester.pumpWidget(_host(child: M3EToolbar(actions: _actions())));
  expect(_outerPadding(tester).left, M3EToolbarTokens.screenOffset);
}

Future<void> _wideDockedGapStaysAt32AndATightBarStopsAt4(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      child: const SizedBox(
        width: 800,
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
  expect(_iconGap(tester, 0, 1), closeTo(32, 1));

  await tester.pumpWidget(
    _host(
      child: const SizedBox(
        width: 184,
        child: M3EToolbar.docked(
          safeArea: false,
          maxInlineActions: 8,
          actions: <M3EToolbarItem>[
            M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
            M3EToolbarAction(icon: M3EIcons.favorite, onPressed: _noop),
            M3EToolbarAction(icon: M3EIcons.home, onPressed: _noop),
          ],
        ),
      ),
    ),
  );
  expect(find.byType(M3EToolbarOverflowMenu), findsOneWidget);
  expect(_iconGap(tester, 0, 1), closeTo(4, 0.5));
}

Future<void> _centeredAndEdgeAlignmentApplyFrom600Wide(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      child: const SizedBox(
        width: 800,
        child: M3EToolbar.docked(
          safeArea: false,
          contentAlignment: M3EToolbarContentAlignment.centered,
          actions: <M3EToolbarItem>[
            M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
          ],
        ),
      ),
    ),
  );
  expect(_iconGap(tester, 0, 1), closeTo(8, 1));
  final double mid = tester.getCenter(find.byType(M3EToolbar)).dx;
  final double cluster =
      (tester.getCenter(find.byIcon(M3EIcons.edit)).dx +
          tester.getCenter(find.byIcon(M3EIcons.share)).dx) /
      2;
  expect(cluster, closeTo(mid, 1));

  await tester.pumpWidget(
    _host(
      child: const SizedBox(
        width: 800,
        child: M3EToolbar.docked(
          safeArea: false,
          contentAlignment: M3EToolbarContentAlignment.edges,
          actions: <M3EToolbarItem>[
            M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
            M3EToolbarAction(icon: M3EIcons.favorite, onPressed: _noop),
            M3EToolbarAction(icon: M3EIcons.home, onPressed: _noop),
          ],
        ),
      ),
    ),
  );
  final double toolbarLeft = tester.getTopLeft(find.byType(M3EToolbar)).dx;
  final double toolbarRight = tester.getTopRight(find.byType(M3EToolbar)).dx;
  final Finder buttons = find.byType(M3EIconButton);
  expect(tester.getTopLeft(buttons.at(0)).dx - toolbarLeft, closeTo(16, 1));
  expect(toolbarRight - tester.getTopRight(buttons.at(3)).dx, closeTo(16, 1));
}

Future<void> _standardFabIsSecondaryContainerAndMorphs80To56(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      child: const M3EToolbar(
        expanded: false,
        fabExpandIcon: Icon(M3EIcons.add),
        actions: <M3EToolbarItem>[
          M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
        ],
      ),
    ),
  );
  await tester.pump();
  final M3EFab fab = tester.widget<M3EFab>(find.byType(M3EFab));
  expect(fab.color, M3EFabColor.secondary);
  expect(tester.getSize(find.byType(M3EFab)).width, closeTo(80, 0.5));
  expect(
    IconTheme.of(tester.element(find.byIcon(M3EIcons.add))).size,
    M3EToolbarTokens.fabCollapsedIcon,
  );

  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(
    _host(
      child: const M3EToolbar(
        fabExpandIcon: Icon(M3EIcons.add),
        actions: <M3EToolbarItem>[
          M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
        ],
      ),
    ),
  );
  await tester.pump();
  expect(tester.getSize(find.byType(M3EFab)).width, closeTo(56, 0.5));
  expect(
    IconTheme.of(tester.element(find.byIcon(M3EIcons.close))).size,
    M3EToolbarTokens.fabExpandedIcon,
  );
}

Future<void> _scrollExitKeepsTheToolbarFromCollapsingToTheFab(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      child: M3EToolbar(
        expanded: false,
        scrollBehavior: M3EToolbarScrollBehavior.exitAlways(),
        fabExpandIcon: const Icon(M3EIcons.add),
        actions: const <M3EToolbarItem>[
          M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
        ],
      ),
    ),
  );
  await tester.pump();
  expect(tester.getSize(find.byType(M3EFab)).width, closeTo(56, 0.5));
  expect(find.byIcon(M3EIcons.edit), findsOneWidget);
}

Future<void> _arrowsMoveFocusAndAPointerHidesTheRing(
  WidgetTester tester,
) async {
  final FocusHighlightStrategy previous =
      FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() => FocusManager.instance.highlightStrategy = previous);

  await tester.pumpWidget(
    _host(
      child: const M3EToolbar(
        actions: <M3EToolbarItem>[
          M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
          M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
        ],
      ),
    ),
  );
  await tester.pump();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  expect(_iconFocused(tester, M3EIcons.edit), isTrue);
  expect(_ringVisible(tester), isTrue);

  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowRight);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowRight);
  await tester.pump();
  expect(_iconFocused(tester, M3EIcons.share), isTrue);
  expect(_ringVisible(tester), isTrue);

  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer();
  await gesture.moveTo(tester.getCenter(find.byIcon(M3EIcons.share)));
  await tester.pump();
  expect(M3EFocusInteraction.instance.ringsAllowed, isFalse);
  expect(_ringVisible(tester), isFalse);
  await gesture.removePointer();
}

Future<void> _horizontalOrderFollowsTheReadingDirection(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.rtl,
      child: M3ETheme(
        data: M3EThemeData.light(),
        child: const M3EToolbar(
          actions: <M3EToolbarItem>[
            M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
            M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
          ],
        ),
      ),
    ),
  );
  expect(
    tester.getCenter(find.byIcon(M3EIcons.edit)).dx,
    greaterThan(tester.getCenter(find.byIcon(M3EIcons.share)).dx),
  );
}

Future<void> _selectedActionsAreTonalAndTheEmphasisActionIsFilled(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      child: const M3EToolbar.docked(
        safeArea: false,
        actions: <M3EToolbarItem>[
          M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop, active: true),
        ],
      ),
    ),
  );
  expect(
    tester.widget<M3EIconButton>(find.byType(M3EIconButton)).variant,
    M3EIconButtonVariant.tonal,
  );
  expect(
    tester.widget<M3EIconButton>(find.byType(M3EIconButton)).shape,
    M3EIconButtonShapeVariant.square,
  );

  await tester.pumpWidget(
    _host(
      child: const M3EToolbar(
        actions: <M3EToolbarItem>[
          M3EToolbarAction(
            icon: M3EIcons.share,
            onPressed: _noop,
            isExpandTrigger: true,
          ),
        ],
      ),
    ),
  );
  expect(
    tester.widget<M3EIconButton>(find.byType(M3EIconButton)).variant,
    M3EIconButtonVariant.filled,
  );
  expect(
    tester.widget<M3EIconButton>(find.byType(M3EIconButton)).shape,
    M3EIconButtonShapeVariant.round,
  );
}

void _noop() {}

List<M3EToolbarItem> _actions() => const <M3EToolbarItem>[
  M3EToolbarAction(icon: M3EIcons.edit, onPressed: _noop),
  M3EToolbarAction(icon: M3EIcons.share, onPressed: _noop),
];

Widget _host({required Widget child}) {
  return MaterialApp(
    home: M3ETheme(
      data: M3EThemeData.light(),
      child: Scaffold(body: child),
    ),
  );
}

Material _toolbarMaterial(WidgetTester tester) {
  return tester.widget<Material>(
    find.byWidgetPredicate((Widget widget) {
      return widget is Material &&
          (widget.shape is StadiumBorder ||
              widget.shape is RoundedRectangleBorder);
    }).first,
  );
}

EdgeInsets _outerPadding(WidgetTester tester) {
  final Padding padding = tester.widget<Padding>(
    find.descendant(
      of: find.byType(M3EToolbar),
      matching: find.byWidgetPredicate((Widget widget) {
        if (widget is! Padding) {
          return false;
        }
        final EdgeInsets insets = widget.padding.resolve(TextDirection.ltr);
        return insets.left == insets.right && insets.left >= 16;
      }),
    ),
  );
  return padding.padding.resolve(TextDirection.ltr);
}

double _iconGap(WidgetTester tester, int a, int b) {
  final Finder buttons = find.byType(M3EIconButton);
  return tester.getTopLeft(buttons.at(b)).dx -
      tester.getTopRight(buttons.at(a)).dx;
}

bool _ringVisible(WidgetTester tester) {
  return tester
      .widgetList<M3EFocusRing>(find.byType(M3EFocusRing))
      .any((M3EFocusRing ring) => ring.focused);
}

bool _iconFocused(WidgetTester tester, IconData icon) {
  final FocusNode? node = Focus.maybeOf(tester.element(find.byIcon(icon)));
  return node?.hasPrimaryFocus ?? false;
}
