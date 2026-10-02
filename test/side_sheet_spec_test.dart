import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/side_sheets/components/m3e_side_sheet_scrim.dart';
import 'package:material_3_expressive/components/side_sheets/components/m3e_side_sheet_surface.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

final M3EThemeData _theme = M3EThemeData.light(
  seedColor: const Color(0xFF6750A4),
);

final Finder _surface = find.byType(M3ESideSheetSurface);

void main() {
  setUp(M3EFocusInteraction.resetForTest);
  testWidgets('theme defaults match the spec', _themeDefaults);
  testWidgets('modal: 256 wide, start rounding, level 1', _modalAnatomy);
  testWidgets('header and actions measurements', _measurements);
  testWidgets('standard: surface, no rounding, level 0', _standard);
  testWidgets('width is capped at 400', _maxWidth);
  testWidgets('detached: 16 margins, every corner rounded', _detached);
  testWidgets('RTL anchors the sheet to the left', _rtl);
  testWidgets('close, scrim and Escape dismiss', _dismissPaths);
  testWidgets('onDismissRequest can keep the sheet open', _guard);
  testWidgets('controller closes with a result', _controllerClose);
  testWidgets('predictive back lifts, scales and commits', _predictiveBack);
  testWidgets('predictive back cancel springs back', _predictiveCancel);
  testWidgets('reads as a dialog: headline, then close', _semantics);
  testWidgets('keyboard lands on close; Enter closes', _keyboard);
  testWidgets('focus ring hides after a pointer tap', _pointerHidesRing);
  testWidgets('close icon: primary state layers', _stateLayers);
  testWidgets('layout: standard sheet shrinks the body', _layoutStandard);
  testWidgets('layout: compact windows use a modal sheet', _layoutCompact);
  testWidgets('layout morphs across the breakpoint', _layoutMorph);
  testWidgets('body scrolls independently and vertically', _scroll);
  testWidgets('header lines up with a 64dp app bar', _headerMatchesAppBar);
  testWidgets('actions stay above the bottom system bar', _bottomInset);
  testWidgets('light theme: dark bar icons over the sheet', _lightBars);
  testWidgets('dark theme: light bar icons', _darkBars);
  testWidgets('narrow standard layout does not overflow', _narrowStandard);
}

Future<BuildContext> _pump(
  WidgetTester tester, {
  Size size = const Size(400, 800),
  TextDirection direction = TextDirection.ltr,
  Widget? home,
  M3EThemeData? theme,
}) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  late BuildContext captured;
  await tester.pumpWidget(
    M3ETheme(
      data: theme ?? _theme,
      child: MaterialApp(
        // Edge-to-edge apps strip the bottom inset from MediaQuery.
        builder: (BuildContext context, Widget? child) =>
            MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: Directionality(textDirection: direction, child: child!),
            ),
        home: Builder(
          builder: (BuildContext context) {
            captured = context;
            return home ?? const SizedBox.expand();
          },
        ),
      ),
    ),
  );
  return captured;
}

Future<Future<Object?>> _show(
  WidgetTester tester,
  BuildContext context, {
  List<Widget> actions = const <Widget>[],
  bool detached = false,
  double? width,
  Future<bool> Function()? onDismissRequest,
  M3ESideSheetController? controller,
}) async {
  final Future<Object?> result = M3ESideSheet.show<Object?>(
    context,
    title: 'Filters',
    body: const Text('Body'),
    actions: actions,
    detached: detached,
    width: width,
    onDismissRequest: onDismissRequest,
    controller: controller,
  );
  await tester.pumpAndSettle();
  return result;
}

BoxDecoration _decoration(WidgetTester tester) {
  final DecoratedBox box = tester.widget<DecoratedBox>(
    find.descendant(of: _surface, matching: find.byType(DecoratedBox)).first,
  );
  return box.decoration as BoxDecoration;
}

Future<void> _themeDefaults(WidgetTester tester) async {
  const t = M3ESideSheetTheme.defaults;
  expect(t.width, 256);
  expect(t.maxWidth, 400);
  expect(t.detachedMargin, 16);
  expect(t.horizontalPadding, 24);
  expect(t.startPaddingWithIcon, 16);
  expect(t.topElementsGap, 12);
  expect(t.headerVerticalPadding, 8);
  expect(t.headlineMaxLines, 1);
  expect(t.actionsHeight, 72);
  expect(t.actionsTopPadding, 16);
  expect(t.actionsBottomPadding, 24);
  expect(t.actionsAlignment, MainAxisAlignment.start);
  expect(t.modalCornerRadius, 16);
  expect(t.standardCornerRadius, 0);
  expect(t.standardElevation, M3EElevation.level0);
  expect(t.modalElevation, M3EElevation.level1);
  expect(t.scrimOpacity, 0.32);
  expect(t.compactBreakpoint, 600);
  expect(t.action.hoverOpacity, 0.08);
  expect(t.action.focusOpacity, 0.1);
  expect(t.action.pressedOpacity, 0.1);
  expect(t.action.focusIndicatorThickness, 3);
  expect(t.action.focusIndicatorOffset, 2);
  final M3EColorScheme s = _theme.colorScheme;
  expect(t.dividerColor(s), s.outlineVariant);
  expect(t.iconColor(s), s.onSurfaceVariant);
  final TextStyle h = t.headlineStyle(_theme.typeScale, s);
  expect(h.fontSize, _theme.typeScale.titleLarge.fontSize);
  expect(h.color, s.onSurfaceVariant);
}

Future<void> _modalAnatomy(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  await _show(tester, context);
  final Rect rect = tester.getRect(_surface);
  expect(rect.width, 256);
  expect(rect.right, 400);
  expect(rect.height, 800);
  final BoxDecoration d = _decoration(tester);
  expect(d.color, _theme.colorScheme.surfaceContainerLow);
  expect(
    d.borderRadius,
    const BorderRadius.horizontal(left: Radius.circular(16)),
  );
  expect(d.boxShadow, isNotEmpty);
  expect(find.byIcon(M3EIcons.close), findsOneWidget);
  final Text title = tester.widget<Text>(find.text('Filters'));
  expect(title.style?.color, _theme.colorScheme.onSurfaceVariant);
}

Future<void> _measurements(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  M3ESideSheet.show<void>(
    context,
    title: 'Filters',
    onBack: () {},
    body: const Text('Body'),
    actions: <Widget>[
      M3EButton(onPressed: () {}, child: const Text('Save')),
      M3EButton(onPressed: () {}, child: const Text('Cancel')),
    ],
  );
  await tester.pumpAndSettle();
  final Rect sheet = tester.getRect(_surface);
  final Rect back = tester.getRect(find.byIcon(M3EIcons.arrow_back));
  final Rect close = tester.getRect(find.byIcon(M3EIcons.close));
  final Rect title = tester.getRect(find.text('Filters'));
  expect(back.center.dx - sheet.left, closeTo(16 + 24, 1));
  expect(sheet.right - close.center.dx, closeTo(24 + 24, 1));
  expect(title.left, greaterThan(back.right));
  expect(find.byType(M3EDivider), findsOneWidget);
  final Rect save = tester.getRect(find.text('Save'));
  final Rect cancel = tester.getRect(find.text('Cancel'));
  expect(save.left, lessThan(cancel.left), reason: 'start aligned');
  final Rect divider = tester.getRect(find.byType(M3EDivider));
  final Rect saveButton = tester.getRect(
    find.ancestor(of: find.text('Save'), matching: find.byType(M3EButton)),
  );
  expect(saveButton.left - sheet.left, closeTo(24, 0.5));
  expect(sheet.bottom - divider.bottom, greaterThanOrEqualTo(72));
}

Future<void> _standard(WidgetTester tester) async {
  await _pump(
    tester,
    home: const Align(
      alignment: Alignment.centerRight,
      child: M3ESideSheet.standard(
        title: 'Info',
        body: Text('Body'),
        showEdgeDivider: true,
      ),
    ),
  );
  final BoxDecoration d = _decoration(tester);
  expect(d.color, _theme.colorScheme.surface);
  expect(d.borderRadius, BorderRadius.zero);
  expect(d.boxShadow, isEmpty);
  expect(find.byIcon(M3EIcons.close), findsNothing, reason: 'no onClose');
  final M3EDivider divider = tester.widget(find.byType(M3EDivider));
  expect(divider.axis, M3EDividerAxis.vertical);
  expect(tester.getRect(find.byType(M3EDivider)).left, 400 - 256);
}

Future<void> _maxWidth(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, size: const Size(1000, 800));
  await _show(tester, context, width: 600);
  expect(tester.getRect(_surface).width, 400);
}

Future<void> _detached(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  await _show(tester, context, detached: true);
  final Rect rect = tester.getRect(_surface);
  expect(rect, const Rect.fromLTRB(400 - 16 - 256, 16, 400 - 16, 800 - 16));
  expect(_decoration(tester).borderRadius, BorderRadius.circular(16));
}

Future<void> _rtl(WidgetTester tester) async {
  final BuildContext context = await _pump(
    tester,
    direction: TextDirection.rtl,
  );
  M3ESideSheet.show<void>(
    context,
    title: 'Filters',
    onBack: () {},
    body: const Text('Body'),
  );
  await tester.pumpAndSettle();
  final Rect rect = tester.getRect(_surface);
  expect(rect.left, 0);
  expect(
    _decoration(tester).borderRadius,
    const BorderRadius.horizontal(right: Radius.circular(16)),
  );
  final Rect back = tester.getRect(find.byIcon(M3EIcons.arrow_back));
  final Rect close = tester.getRect(find.byIcon(M3EIcons.close));
  expect(back.left, greaterThan(close.left), reason: 'mirrored');
}

Future<void> _dismissPaths(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  var closed = 0;
  (await _show(tester, context)).then((_) => closed++);
  await tester.tap(find.byIcon(M3EIcons.close));
  await tester.pumpAndSettle();
  expect(closed, 1);
  (await _show(tester, context)).then((_) => closed++);
  await tester.tapAt(const Offset(20, 400));
  await tester.pumpAndSettle();
  expect(closed, 2);
  (await _show(tester, context)).then((_) => closed++);
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pumpAndSettle();
  expect(closed, 3);
  expect(_surface, findsNothing);
}

Future<void> _guard(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  var allow = false;
  await _show(tester, context, onDismissRequest: () async => allow);
  await tester.tapAt(const Offset(20, 400));
  await tester.pumpAndSettle();
  expect(_surface, findsOneWidget);
  allow = true;
  await tester.tap(find.byIcon(M3EIcons.close));
  await tester.pumpAndSettle();
  expect(_surface, findsNothing);
}

Future<void> _controllerClose(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  final controller = M3ESideSheetController();
  addTearDown(controller.dispose);
  final Future<Object?> result = await _show(
    tester,
    context,
    controller: controller,
  );
  expect(controller.isOpen, isTrue);
  controller.close('done');
  await tester.pumpAndSettle();
  expect(await result, 'done');
  expect(controller.isAttached, isFalse);
}

Future<void> _sendBack(
  WidgetTester tester,
  String method, [
  Map<String, dynamic>? args,
]) async {
  final ByteData data = const StandardMethodCodec().encodeMethodCall(
    MethodCall(method, args),
  );
  await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    SystemChannels.backGesture.name,
    data,
    (ByteData? _) {},
  );
}

Map<String, dynamic> _backArgs(double progress, {int edge = 0}) =>
    <String, dynamic>{
      'touchOffset': <double>[5, 400],
      'progress': progress,
      'swipeEdge': edge,
    };

Future<void> _predictiveBack(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  var closed = false;
  (await _show(tester, context)).then((_) => closed = true);
  await _sendBack(tester, 'startBackGesture', _backArgs(0));
  await _sendBack(tester, 'updateBackGestureProgress', _backArgs(1));
  await tester.pump();
  final Transform transform = tester.widget<Transform>(
    find.ancestor(of: _surface, matching: find.byType(Transform)).first,
  );
  final m = transform.transform.storage;
  expect(m[0], closeTo(1 - 24 / 256, 0.001), reason: 'shrinks from left');
  expect(m[5], closeTo(1 - 48 / 800, 0.001), reason: 'lifts off edges');
  expect(_decoration(tester).borderRadius, BorderRadius.circular(16));
  await _sendBack(tester, 'commitBackGesture');
  await tester.pumpAndSettle();
  expect(closed, isTrue);
}

Future<void> _predictiveCancel(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  await _show(tester, context);
  await _sendBack(tester, 'startBackGesture', _backArgs(0, edge: 1));
  await _sendBack(tester, 'updateBackGestureProgress', _backArgs(1, edge: 1));
  await tester.pump();
  final Transform grow = tester.widget<Transform>(
    find.ancestor(of: _surface, matching: find.byType(Transform)).first,
  );
  expect(grow.transform.storage[0], closeTo(1 + 12 / 256, 0.001));
  await _sendBack(tester, 'cancelBackGesture');
  await tester.pumpAndSettle();
  expect(_surface, findsOneWidget);
  expect(tester.getRect(_surface).width, 256);
}

Future<void> _semantics(WidgetTester tester) async {
  final SemanticsHandle handle = tester.ensureSemantics();
  final BuildContext context = await _pump(tester);
  await _show(
    tester,
    context,
    actions: <Widget>[M3EButton(onPressed: () {}, child: const Text('Cancel'))],
  );
  final SemanticsNode dialog = tester.getSemantics(
    find.bySemanticsLabel('Filters').first,
  );
  expect(dialog.role, SemanticsRole.dialog);
  expect(dialog.flagsCollection.scopesRoute, isTrue);
  final order = <String>[];
  dialog.visitChildren((SemanticsNode node) {
    _labels(node, order);
    return true;
  });
  final int headline = order.indexOf('Filters');
  final int close = order.indexOf('Close');
  final int cancel = order.indexOf('Cancel');
  expect(headline, lessThan(close));
  expect(close, lessThan(cancel));
  handle.dispose();
}

void _labels(SemanticsNode node, List<String> out) {
  final String label = node.label;
  if (label.isNotEmpty) {
    out.add(label);
  }
  for (final SemanticsNode child in node.debugListChildrenInOrder(
    DebugSemanticsDumpOrder.traversalOrder,
  )) {
    _labels(child, out);
  }
}

Future<void> _keyboard(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);
  var closed = false;
  (await _show(tester, context)).then((_) => closed = true);
  final FocusNode? focus = FocusManager.instance.primaryFocus;
  expect(
    find.ancestor(
      of: find.byIcon(M3EIcons.close),
      matching: find.byWidgetPredicate(
        (Widget w) => w is Focus && w.focusNode == focus,
      ),
    ),
    findsOneWidget,
  );
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pumpAndSettle();
  expect(closed, isTrue);
}

Future<void> _pointerHidesRing(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await _show(tester, context);
  expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);
  await tester.tap(find.text('Body'));
  await tester.pump();
  expect(M3EFocusInteraction.instance.ringsAllowed, isFalse);
}

Future<void> _stateLayers(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  await _show(tester, context);
  final Finder button = find.byType(M3EIconButton);
  final M3EIconButtonDecoration? dec = tester
      .widget<M3EIconButton>(button)
      .decoration;
  final Color primary = _theme.colorScheme.primary;
  expect(
    dec?.overlayColor?.resolve(<WidgetState>{WidgetState.hovered}),
    primary.withValues(alpha: 0.08),
  );
  expect(
    dec?.overlayColor?.resolve(<WidgetState>{WidgetState.pressed}),
    primary.withValues(alpha: 0.1),
  );
  expect(
    dec?.foregroundColor?.resolve(<WidgetState>{}),
    _theme.colorScheme.onSurfaceVariant,
  );
}

Widget _layout(M3ESideSheetController controller) {
  return M3ESideSheetLayout(
    controller: controller,
    body: const SizedBox.expand(key: ValueKey<String>('main')),
    sheet: const M3ESideSheet.standard(title: 'Info', body: Text('Body')),
  );
}

Future<void> _layoutStandard(WidgetTester tester) async {
  final controller = M3ESideSheetController();
  addTearDown(controller.dispose);
  await _pump(tester, size: const Size(1000, 800), home: _layout(controller));
  final Finder main = find.byKey(const ValueKey<String>('main'));
  expect(tester.getRect(main).width, 1000);
  controller.open();
  await tester.pumpAndSettle();
  expect(controller.isOpen, isTrue);
  expect(tester.getRect(main).right, 1000 - 256 - 24);
  expect(_decoration(tester).color, _theme.colorScheme.surface);
  expect(find.byType(M3ESideSheetScrim), findsNothing);
  await tester.tap(find.byIcon(M3EIcons.close));
  await tester.pumpAndSettle();
  expect(controller.isOpen, isFalse);
  expect(tester.getRect(main).width, 1000);
}

Future<void> _layoutCompact(WidgetTester tester) async {
  final controller = M3ESideSheetController();
  addTearDown(controller.dispose);
  await _pump(tester, home: _layout(controller));
  controller.open();
  await tester.pumpAndSettle();
  final Finder main = find.byKey(const ValueKey<String>('main'));
  expect(tester.getRect(main).width, 400, reason: 'body keeps its size');
  expect(_decoration(tester).color, _theme.colorScheme.surfaceContainerLow);
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pumpAndSettle();
  expect(controller.isOpen, isFalse);
}

Future<void> _layoutMorph(WidgetTester tester) async {
  final controller = M3ESideSheetController();
  addTearDown(controller.dispose);
  await _pump(tester, size: const Size(1000, 800), home: _layout(controller));
  controller.open();
  await tester.pumpAndSettle();
  tester.view.physicalSize = const Size(500, 800);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  final double mid = tester
      .getRect(find.byKey(const ValueKey<String>('main')))
      .width;
  expect(mid, lessThan(500), reason: 'still springing');
  await tester.pumpAndSettle();
  expect(tester.getRect(find.byKey(const ValueKey<String>('main'))).width, 500);
  expect(
    _decoration(tester).borderRadius,
    const BorderRadius.horizontal(left: Radius.circular(16)),
  );
}

Future<void> _scroll(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  M3ESideSheet.show<void>(
    context,
    title: 'Filters',
    scrollable: true,
    body: Column(
      children: <Widget>[
        for (var i = 0; i < 40; i++) SizedBox(height: 48, child: Text('R$i')),
      ],
    ),
  );
  await tester.pumpAndSettle();
  final ScrollableState state = tester.state<ScrollableState>(
    find.byType(Scrollable),
  );
  expect(state.position.axis, Axis.vertical);
  await tester.drag(find.text('R3'), const Offset(-100, -300));
  await tester.pumpAndSettle();
  expect(state.position.pixels, greaterThan(0));
  expect(
    PrimaryScrollController.maybeOf(context),
    isNot(state.widget.controller),
  );
}

void _systemBars(WidgetTester tester) {
  tester.view
    ..padding = const FakeViewPadding(top: 24, bottom: 48)
    ..viewPadding = const FakeViewPadding(top: 24, bottom: 48);
  addTearDown(tester.view.resetPadding);
  addTearDown(tester.view.resetViewPadding);
}

Future<void> _headerMatchesAppBar(WidgetTester tester) async {
  _systemBars(tester);
  final BuildContext context = await _pump(tester);
  await _show(tester, context);
  final double barCenter = 24 + 64 / 2;
  expect(tester.getCenter(find.byIcon(M3EIcons.close)).dy, barCenter);
  expect(tester.getCenter(find.text('Filters')).dy, closeTo(barCenter, 0.5));
  expect(tester.getRect(_surface).top, 0, reason: 'paints under the bar');
}

Future<void> _bottomInset(WidgetTester tester) async {
  _systemBars(tester);
  final BuildContext context = await _pump(tester);
  await _show(
    tester,
    context,
    actions: <Widget>[M3EButton(onPressed: () {}, child: const Text('Save'))],
  );
  expect(tester.getRect(_surface).bottom, 800);
  final Rect save = tester.getRect(
    find.ancestor(of: find.text('Save'), matching: find.byType(M3EButton)),
  );
  expect(save.bottom, lessThanOrEqualTo(800 - 48 - 24));
}

SystemUiOverlayStyle? _styleAt(WidgetTester tester, Offset offset) {
  return tester.binding.renderViews.first.debugLayer!
      .find<SystemUiOverlayStyle>(offset);
}

Future<void> _lightBars(WidgetTester tester) async {
  final BuildContext context = await _pump(tester);
  await _show(tester, context);
  expect(
    _styleAt(tester, const Offset(350, 10))?.statusBarIconBrightness,
    Brightness.dark,
    reason: 'light sheet under the status bar',
  );
  expect(
    _styleAt(tester, const Offset(350, 799))?.systemNavigationBarIconBrightness,
    Brightness.dark,
  );
  expect(
    _styleAt(tester, const Offset(20, 10))?.statusBarIconBrightness,
    Brightness.light,
    reason: 'scrim',
  );
}

Future<void> _darkBars(WidgetTester tester) async {
  final BuildContext context = await _pump(
    tester,
    theme: M3EThemeData.dark(seedColor: const Color(0xFF6750A4)),
  );
  await _show(tester, context);
  expect(
    _styleAt(tester, const Offset(350, 10))?.statusBarIconBrightness,
    Brightness.light,
  );
}

Future<void> _narrowStandard(WidgetTester tester) async {
  final controller = M3ESideSheetController();
  addTearDown(controller.dispose);
  await _pump(
    tester,
    size: const Size(300, 800),
    home: M3ESideSheetLayout(
      controller: controller,
      mode: M3ESideSheetLayoutMode.standard,
      body: const SizedBox.expand(key: ValueKey<String>('main')),
      sheet: const M3ESideSheet.standard(title: 'Info', body: Text('Body')),
    ),
  );
  controller.open();
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(
    tester.getRect(find.byKey(const ValueKey<String>('main'))).width,
    300 - 256 - 24,
  );
  expect(tester.getRect(_surface).width, 256);
  expect(
    _styleAt(tester, const Offset(250, 10))?.statusBarIconBrightness,
    isNot(Brightness.dark),
    reason: 'standard sheets leave the bars alone',
  );
}
