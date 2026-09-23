import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const Key _anchorKey = Key('tooltip-anchor');

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(body: Center(child: child)),
  );
}

Widget _anchor() {
  return const SizedBox(
    key: _anchorKey,
    width: 48,
    height: 48,
    child: ColoredBox(color: Color(0xFF000000)),
  );
}

void main() {
  _registerTooltipThemeTests();
  _registerTooltipShowTests();
  _registerTooltipDismissTests();
}

void _registerTooltipThemeTests() {
  test(
    'theme defaults match the tooltip spec',
    _themeDefaultsMatchTheTooltipSpec,
  );
}

void _registerTooltipShowTests() {
  testWidgets(
    'plain tooltip shows on long-press and exposes tooltip semantics',
    _plainTooltipShowsOnLongPressAndExposesTooltipSemantics,
  );
  testWidgets(
    'persistent rich ignores hover and shows on tap',
    _persistentRichIgnoresHoverAndShowsOnTap,
  );
  testWidgets('controller show and hide', _controllerShowAndHide);
  testWidgets(
    'opening one tooltip closes another',
    _openingOneTooltipClosesAnother,
  );
}

void _registerTooltipDismissTests() {
  testWidgets(
    'plain dismisses immediately after leave',
    _plainDismissesImmediatelyAfterLeave,
  );
  testWidgets(
    'tooltip does not add an extra tab stop around icon buttons',
    _tooltipDoesNotAddAnExtraTabStopAroundIconButtons,
  );
  testWidgets(
    'transient rich dismisses after richDismissDelay',
    _transientRichDismissesAfterRichDismissDelay,
  );
}

void _themeDefaultsMatchTheTooltipSpec() {
  const theme = M3ETooltipTheme.defaults;
  expect(theme.plainMinHeight, 24);
  expect(
    theme.plainPadding,
    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  );
  expect(theme.richPadding, const EdgeInsets.fromLTRB(16, 12, 16, 8));
  expect(theme.richTitleGap, 4);
  expect(theme.richActionsGap, 12);
  expect(theme.plainDismissDelay, Duration.zero);
  expect(theme.richDismissDelay, const Duration(milliseconds: 1500));
  expect(theme.placementStep, 8);
  expect(theme.anchorOffset, 4);

  final scheme = M3EThemeData.light().colorScheme;
  final type = M3EThemeData.light().typeScale;
  expect(theme.plainContainerColor(scheme), scheme.inverseSurface);
  expect(theme.plainMessageStyle(type, scheme).color, scheme.onInverseSurface);
  expect(theme.richContainerColor(scheme), scheme.surfaceContainer);
  expect(theme.richTitleStyle(type, scheme).color, scheme.onSurfaceVariant);
}

Future<void> _plainTooltipShowsOnLongPressAndExposesTooltipSemantics(
  WidgetTester tester,
) async {
  await tester.pumpWidget(_host(M3ETooltip(message: 'Edit', child: _anchor())));

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.byKey(_anchorKey)),
  );
  addTearDown(() async {
    await gesture.up();
  });
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
  expect(find.text('Edit'), findsOneWidget);
  expect(find.byWidgetPredicate(_editTooltipSemantics), findsOneWidget);
}

bool _editTooltipSemantics(Widget widget) {
  return widget is Semantics && widget.properties.tooltip == 'Edit';
}

Future<void> _plainDismissesImmediatelyAfterLeave(WidgetTester tester) async {
  await tester.pumpWidget(_host(M3ETooltip(message: 'Edit', child: _anchor())));

  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(find.byKey(_anchorKey)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(find.text('Edit'), findsOneWidget);

  await gesture.moveTo(const Offset(5, 5));
  await tester.pump();
  expect(find.text('Edit'), findsNothing);
}

Future<void> _persistentRichIgnoresHoverAndShowsOnTap(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      M3ETooltip(
        persistent: true,
        richTitle: 'Title',
        richMessage: 'Body',
        child: _anchor(),
      ),
    ),
  );

  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(find.byKey(_anchorKey)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(find.text('Body'), findsNothing);

  await tester.tap(find.byKey(_anchorKey));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(find.text('Body'), findsOneWidget);
  expect(find.text('Title'), findsOneWidget);
}

Future<void> _controllerShowAndHide(WidgetTester tester) async {
  final controller = M3ETooltipController();
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    _host(
      M3ETooltip(
        persistent: true,
        richMessage: 'Feature',
        controller: controller,
        child: _anchor(),
      ),
    ),
  );

  controller.show();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(controller.isShowing, isTrue);
  expect(find.text('Feature'), findsOneWidget);

  controller.hide();
  await tester.pump();
  expect(controller.isShowing, isFalse);
  expect(find.text('Feature'), findsNothing);
}

Future<void> _openingOneTooltipClosesAnother(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          M3ETooltip(
            message: 'One',
            child: SizedBox(
              key: Key('a'),
              width: 40,
              height: 40,
              child: ColoredBox(color: Color(0xFF000000)),
            ),
          ),
          SizedBox(width: 80),
          M3ETooltip(
            message: 'Two',
            child: SizedBox(
              key: Key('b'),
              width: 40,
              height: 40,
              child: ColoredBox(color: Color(0xFF000000)),
            ),
          ),
        ],
      ),
    ),
  );

  final TestGesture first = await tester.startGesture(
    tester.getCenter(find.byKey(const Key('a'))),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
  expect(find.text('One'), findsOneWidget);
  await first.up();
  await tester.pump();

  final TestGesture second = await tester.startGesture(
    tester.getCenter(find.byKey(const Key('b'))),
  );
  addTearDown(() async {
    await second.up();
  });
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
  expect(find.text('Two'), findsOneWidget);
  expect(find.text('One'), findsNothing);
}

Future<void> _tooltipDoesNotAddAnExtraTabStopAroundIconButtons(
  WidgetTester tester,
) async {
  await tester.pumpWidget(_host(_iconButtonRow(withTooltip: false)));
  final int without = _countTraversableIn(tester, find.byType(Row));

  await tester.pumpWidget(_host(_iconButtonRow(withTooltip: true)));
  final int withTips = _countTraversableIn(tester, find.byType(Row));

  expect(withTips, without);
  expect(withTips, greaterThanOrEqualTo(2));
}

Widget _iconButtonRow({required bool withTooltip}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      M3EIconButton(
        tooltip: withTooltip ? 'First' : null,
        icon: const Icon(Icons.edit),
        onPressed: _noop,
      ),
      M3EIconButton(
        tooltip: withTooltip ? 'Second' : null,
        icon: const Icon(Icons.delete),
        onPressed: _noop,
      ),
    ],
  );
}

int _countTraversableIn(WidgetTester tester, Finder host) {
  final traversable = <FocusNode>{};
  final Rect hostRect = tester.getRect(host);
  _collectTraversable(
    FocusScope.of(tester.element(host)),
    hostRect,
    traversable,
  );
  return traversable.length;
}

void _collectTraversable(
  FocusNode node,
  Rect hostRect,
  Set<FocusNode> traversable,
) {
  final BuildContext? ctx = node.context;
  if (ctx != null && node.canRequestFocus && !node.skipTraversal) {
    _addIfInsideHost(ctx, hostRect, node, traversable);
  }
  for (final FocusNode child in node.children) {
    _collectTraversable(child, hostRect, traversable);
  }
}

void _addIfInsideHost(
  BuildContext ctx,
  Rect hostRect,
  FocusNode node,
  Set<FocusNode> traversable,
) {
  final RenderObject? ro = ctx.findRenderObject();
  if (ro is! RenderBox || !ro.hasSize) {
    return;
  }
  final Offset center = ro.localToGlobal(ro.size.center(Offset.zero));
  if (hostRect.contains(center)) {
    traversable.add(node);
  }
}

Future<void> _transientRichDismissesAfterRichDismissDelay(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const M3ETooltip(
        richMessage: 'Body with actions',
        child: SizedBox(
          key: _anchorKey,
          width: 48,
          height: 48,
          child: ColoredBox(color: Color(0xFF000000)),
        ),
      ),
    ),
  );

  final TestGesture gesture = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(find.byKey(_anchorKey)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(find.text('Body with actions'), findsOneWidget);

  await gesture.moveTo(const Offset(5, 5));
  await tester.pump();
  expect(find.text('Body with actions'), findsOneWidget);
  await tester.pump(const Duration(milliseconds: 1500));
  await tester.pump();
  expect(find.text('Body with actions'), findsNothing);
}

void _noop() {}
