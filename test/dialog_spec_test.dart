import 'dart:ui' show SemanticsRole;

import 'package:flutter/rendering.dart' show SemanticsNode;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

final M3EThemeData _theme = M3EThemeData.light(
  seedColor: const Color(0xFF6750A4),
);

void main() {
  testWidgets('theme defaults match the dialog spec', _themeDefaults);
  testWidgets('basic dialog spacing, color and role', _basicLayout);
  testWidgets('focus lands on first action, Escape closes', _focusEscape);
  testWidgets('long content scrolls with pinned headline', _scrollPinned);
  testWidgets('actions stack with confirm on top', _actionsStack);
  testWidgets('truncated headline expands on tap', _headlineExpand);
  testWidgets('custom position keeps a 56dp margin', _customMargin);
  testWidgets('full-screen header is 56 and tints on scroll', _fullScreen);
  testWidgets('unsaved changes confirm before discard', _discard);
  testWidgets('adaptive dialog swaps variant at 600dp', _adaptive);
  testWidgets('pointer open does not focus an action', _pointerOpen);
  testWidgets('disposing the controller on close is safe', _earlyDispose);
  testWidgets('full-screen dialog fills the view width', _fullWidth);
  testWidgets('positions respect system bars and keyboard', _positions);
  testWidgets('selection list uses arrows inside one Tab stop', _arrows);
  testWidgets('caller and built-in actions share one style', _sameActions);
  testWidgets('full-screen header extends under the status bar', _underBars);
}

Future<BuildContext> _pump(WidgetTester tester, Size size) async {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  late BuildContext captured;
  await tester.pumpWidget(
    M3ETheme(
      data: _theme,
      child: MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            captured = context;
            return const SizedBox.expand();
          },
        ),
      ),
    ),
  );
  return captured;
}

Widget _textButton(String label, VoidCallback? onPressed) {
  return M3EButton(
    style: M3EButtonStyle.text,
    onPressed: onPressed,
    child: Text(label),
  );
}

Future<void> _themeDefaults(WidgetTester tester) async {
  const M3EDialogTheme t = M3EDialogTheme.defaults;
  expect(t.minWidth, 280);
  expect(t.maxWidth, 560);
  expect(t.cornerRadius, 28);
  expect(t.padding, const EdgeInsets.all(24));
  expect(t.gapAfterIcon, 16);
  expect(t.gapAfterTitle, 16);
  expect(t.gapBeforeActions, 24);
  expect(t.actionGap, 8);
  expect(t.iconSize, 24);
  expect(t.dividerThickness, 1);
  expect(t.elevation, M3EElevation.level3);
  expect(t.fullScreenHeaderHeight, 56);
  expect(t.compactBreakpoint, 600);
  expect(t.customPositionMargin, 56);
  expect(t.scrimOpacity, 0.32);
  expect(t.appearance.actionHoverOpacity, 0.08);
  expect(t.fullScreen.maxWidth, double.infinity);
  expect(t.fullScreen.cornerRadius, 0);
  expect(t.fullScreen.actionBarHeight, 56);
  expect(t.fullScreen.contentPadding, const EdgeInsets.fromLTRB(24, 24, 24, 0));
  expect(t.fullScreen.elementGap, 8);
  expect(t.fullScreen.headerScrolledElevation, M3EElevation.level2);

  final M3EColorScheme s = _theme.colorScheme;
  expect(t.containerColor(s), s.surfaceContainerHigh);
  expect(t.appearance.resolveIcon(s), s.secondary);
  expect(t.appearance.resolveDivider(s), s.outline);
  expect(t.appearance.resolveAction(s), s.primary);
  expect(t.fullScreenBackground(s), s.surface);
  expect(t.fullScreen.resolveOnScroll(s), s.surfaceContainer);
  expect(t.fullScreen.resolveDivider(s), s.surfaceContainerHighest);
  expect(t.fullScreen.resolveIcon(s), s.onSurface);
}

Future<void> _basicLayout(WidgetTester tester) async {
  final SemanticsHandle handle = tester.ensureSemantics();
  final BuildContext context = await _pump(tester, const Size(800, 800));
  M3EDialog.show<void>(
    context,
    dialog: M3EDialog(
      title: 'Title',
      content: const Text('Body'),
      actions: <Widget>[_textButton('Cancel', () {})],
    ),
  );
  await tester.pumpAndSettle();

  final Rect title = tester.getRect(find.text('Title'));
  final Rect body = tester.getRect(find.text('Body'));
  expect(body.top - title.bottom, moreOrLessEquals(16));

  final Finder box = find.ancestor(
    of: find.text('Title'),
    matching: find.byWidgetPredicate(
      (Widget w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration! as BoxDecoration).color ==
              _theme.colorScheme.surfaceContainerHigh,
    ),
  );
  expect(box, findsOneWidget);
  expect(tester.getRect(box).left + 24, moreOrLessEquals(title.left));

  final SemanticsNode node = tester.getSemantics(
    find.bySemanticsLabel('Title').first,
  );
  expect(node.role, SemanticsRole.alertDialog);
  handle.dispose();
}

Future<void> _focusEscape(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(800, 800));
  final first = FocusNode();
  addTearDown(first.dispose);
  var closed = false;
  M3EFocusInteraction.instance.noteKeyboardHighlight();
  M3EDialog.show<void>(
    context,
    barrierDismissible: false,
    dialog: M3EDialog(
      title: 'Focus',
      actions: <Widget>[
        M3EButton(
          style: M3EButtonStyle.text,
          focusNode: first,
          onPressed: () {},
          child: const Text('A'),
        ),
        _textButton('B', () {}),
      ],
    ),
  ).then((_) => closed = true);
  await tester.pumpAndSettle();
  expect(first.hasPrimaryFocus, isTrue);

  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pumpAndSettle();
  expect(closed, isTrue);
  expect(find.text('Focus'), findsNothing);
}

Future<void> _scrollPinned(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(800, 600));
  M3EDialog.show<void>(
    context,
    dialog: M3EDialog(
      title: 'Pinned',
      content: Column(
        children: <Widget>[
          for (int i = 0; i < 40; i++) SizedBox(height: 48, child: Text('$i')),
        ],
      ),
      actions: <Widget>[_textButton('OK', () {})],
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  final Rect titleBefore = tester.getRect(find.text('Pinned'));
  final Rect ok = tester.getRect(find.text('OK'));
  expect(ok.bottom, lessThan(600));

  await tester.drag(find.text('3'), const Offset(0, -300));
  await tester.pumpAndSettle();
  expect(tester.getRect(find.text('Pinned')), titleBefore);
  expect(tester.getRect(find.text('OK')), ok);
}

Future<void> _actionsStack(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(360, 800));
  M3EDialog.show<void>(
    context,
    dialog: M3EDialog(
      title: 'Stack',
      actions: <Widget>[
        _textButton('A very long dismissive action', () {}),
        _textButton('A very long confirming action', () {}),
      ],
    ),
  );
  await tester.pumpAndSettle();
  final Rect dismiss = tester.getRect(
    find.text('A very long dismissive action'),
  );
  final Rect confirm = tester.getRect(
    find.text('A very long confirming action'),
  );
  expect(confirm.bottom, lessThan(dismiss.top));
}

Future<void> _headlineExpand(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(400, 800));
  const long = 'A long headline that cannot fit on a single line of the dialog';
  M3EDialog.show<void>(
    context,
    dialog: const M3EDialog(title: long, titleMaxLines: 1),
  );
  await tester.pumpAndSettle();
  Text text() => tester.widget<Text>(find.text(long));
  expect(text().maxLines, 1);
  await tester.tap(find.text(long));
  await tester.pumpAndSettle();
  expect(text().maxLines, isNull);
}

Future<void> _customMargin(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(1000, 800));
  M3EDialog.show<void>(
    context,
    position: M3EDialogPosition.right,
    dialog: const M3EDialog(title: 'Right', content: Text('Side')),
  );
  await tester.pumpAndSettle();
  final Finder surface = find.ancestor(
    of: find.text('Right'),
    matching: find.byType(M3EDialog),
  );
  expect(tester.getRect(surface).right, moreOrLessEquals(1000 - 56));
}

Future<void> _fullScreen(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(400, 800));
  M3EDialog.showFullScreen<void>(
    context,
    title: 'New event',
    confirmLabel: 'Save',
    onConfirm: () {},
    body: ListView(
      children: <Widget>[
        for (int i = 0; i < 40; i++) SizedBox(height: 48, child: Text('$i')),
      ],
    ),
  );
  await tester.pumpAndSettle();
  final Finder header = find.ancestor(
    of: find.text('New event'),
    matching: find.byType(DecoratedBox),
  );
  expect(tester.getSize(header.first).height, 56);
  Color headerColor() =>
      (tester.widget<DecoratedBox>(header.first).decoration as BoxDecoration)
          .color!;
  expect(headerColor(), _theme.colorScheme.surface);

  await tester.drag(find.text('3'), const Offset(0, -200));
  await tester.pumpAndSettle();
  expect(headerColor(), _theme.colorScheme.surfaceContainer);
  expect(find.bySemanticsLabel('Close'), findsWidgets);
}

Future<void> _discard(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(400, 800));
  final controller = M3EDialogController(hasUnsavedChanges: true);
  addTearDown(controller.dispose);
  M3EDialog.showFullScreen<void>(
    context,
    title: 'Edit',
    controller: controller,
    body: const Text('Form'),
  );
  await tester.pumpAndSettle();
  expect(controller.isOpen, isTrue);
  expect(controller.variant, M3EDialogVariant.fullScreen);

  await tester.tap(find.byIcon(M3EIcons.close));
  await tester.pumpAndSettle();
  expect(find.text('Discard unsaved changes?'), findsOneWidget);
  await tester.tap(find.text('Keep editing'));
  await tester.pumpAndSettle();
  expect(find.text('Edit'), findsOneWidget);

  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pumpAndSettle();
  await tester.tap(find.text('Discard'));
  await tester.pumpAndSettle();
  expect(find.text('Edit'), findsNothing);
  expect(controller.isOpen, isFalse);
}

Future<void> _adaptive(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(400, 800));
  final controller = M3EDialogController();
  addTearDown(controller.dispose);
  M3EDialog.showAdaptive<void>(
    context,
    title: 'Album',
    content: const Text('Name'),
    confirmLabel: 'Save',
    onConfirm: () {},
    controller: controller,
  );
  await tester.pumpAndSettle();
  expect(find.byType(M3EFullScreenDialog), findsOneWidget);
  expect(controller.variant, M3EDialogVariant.fullScreen);

  tester.view.physicalSize = const Size(900, 800);
  await tester.pumpAndSettle();
  expect(find.byType(M3EFullScreenDialog), findsNothing);
  expect(find.text('Cancel'), findsOneWidget);
  expect(controller.variant, M3EDialogVariant.basic);
}

String? _focusLabel() => FocusManager.instance.primaryFocus?.debugLabel;

Future<void> _pointerOpen(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(800, 800));
  M3EFocusInteraction.instance.notePointerInteraction(immediate: true);
  M3EDialog.show<void>(
    context,
    dialog: M3EDialog(
      title: 'Pointer',
      actions: <Widget>[_textButton('A', () {}), _textButton('B', () {})],
    ),
  );
  await tester.pumpAndSettle();
  expect(_focusLabel(), 'M3EDialog');
  final M3EDialogAppearance appearance = M3EDialogTheme.defaults.appearance;
  const purple = Color(0xFF6750A4);
  // Buttons pass live states, so the dialog layer maps them directly:
  // pressed over focus over hover.
  Color? layer(Set<WidgetState> states) =>
      appearance.actionOverlay(purple, states);
  expect(
    layer(<WidgetState>{WidgetState.pressed, WidgetState.hovered}),
    purple.withValues(alpha: 0.1),
  );
  expect(
    layer(<WidgetState>{WidgetState.focused, WidgetState.hovered}),
    purple.withValues(alpha: 0.1),
  );
  expect(
    layer(<WidgetState>{WidgetState.hovered}),
    purple.withValues(alpha: 0.08),
  );
  expect(layer(<WidgetState>{})!.a, 0);
}

Future<void> _earlyDispose(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(400, 800));
  final controller = M3EDialogController();
  M3EDialog.showFullScreen<void>(
    context,
    title: 'Early',
    controller: controller,
    body: const Text('Body'),
  ).whenComplete(controller.dispose);
  await tester.pumpAndSettle();
  controller.close();
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
  expect(find.text('Early'), findsNothing);
}

Future<void> _fullWidth(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(590, 800));
  M3EDialog.showFullScreen<void>(
    context,
    title: 'Wide',
    body: const Text('Body'),
  );
  await tester.pumpAndSettle();
  final Finder header = find.ancestor(
    of: find.text('Wide'),
    matching: find.byType(DecoratedBox),
  );
  expect(tester.getSize(header.first).width, 590);
}

Rect _dialogRect(WidgetTester tester, String title) => tester.getRect(
  find.ancestor(of: find.text(title), matching: find.byType(M3EDialog)),
);

Future<void> _openAt(
  WidgetTester tester,
  BuildContext context,
  M3EDialogPosition position,
) async {
  M3EDialog.show<void>(
    context,
    position: position,
    dialog: M3EDialog(title: position.name, content: const Text('Body')),
  );
  await tester.pumpAndSettle();
}

Future<void> _positions(WidgetTester tester) async {
  const bars = FakeViewPadding(top: 40, bottom: 30);
  tester.view
    ..padding = bars
    ..viewPadding = bars;
  BuildContext context = await _pump(tester, const Size(400, 800));
  await _openAt(tester, context, M3EDialogPosition.top);
  expect(_dialogRect(tester, 'top').top, moreOrLessEquals(40 + 24));
  Navigator.of(context).pop();
  await tester.pumpAndSettle();

  await _openAt(tester, context, M3EDialogPosition.bottom);
  expect(_dialogRect(tester, 'bottom').bottom, moreOrLessEquals(800 - 30 - 24));
  tester.view.viewInsets = const FakeViewPadding(bottom: 300);
  await tester.pumpAndSettle();
  expect(
    _dialogRect(tester, 'bottom').bottom,
    moreOrLessEquals(800 - 300 - 24),
  );
  Navigator.of(context).pop();
  await tester.pumpAndSettle();

  tester.view.viewInsets = FakeViewPadding.zero;
  context = await _pump(tester, const Size(1000, 800));
  await _openAt(tester, context, M3EDialogPosition.left);
  expect(_dialogRect(tester, 'left').left, moreOrLessEquals(56));
}

Future<void> _key(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pumpAndSettle();
}

Future<void> _arrows(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(800, 800));
  List<String>? result;
  M3EFocusInteraction.instance.noteKeyboardHighlight();
  M3EDialog.showSelectionScreen(
    context,
    title: 'Ringtone',
    options: const <String>['None', 'Callisto', 'Ganymede'],
  ).then((List<String>? v) => result = v);
  await tester.pumpAndSettle();
  expect(_focusLabel(), 'M3EDialog option None');

  await _key(tester, LogicalKeyboardKey.arrowDown);
  expect(_focusLabel(), 'M3EDialog option Callisto');
  await _key(tester, LogicalKeyboardKey.space);
  await _key(tester, LogicalKeyboardKey.arrowUp);
  expect(_focusLabel(), 'M3EDialog option None');
  await _key(tester, LogicalKeyboardKey.arrowDown);

  // Tab leaves the list for the actions instead of visiting each row.
  await _key(tester, LogicalKeyboardKey.tab);
  expect(_focusLabel(), isNot(startsWith('M3EDialog option')));
  await _key(tester, LogicalKeyboardKey.tab);
  await _key(tester, LogicalKeyboardKey.enter);
  expect(result, <String>['Callisto']);
}

TextStyle _labelStyle(WidgetTester tester, String label) {
  final Finder text = find.descendant(
    of: find.widgetWithText(M3EButton, label),
    matching: find.byType(RichText),
  );
  return tester.widget<RichText>(text.first).text.style!;
}

Future<void> _sameActions(WidgetTester tester) async {
  final BuildContext context = await _pump(tester, const Size(400, 800));
  M3EDialog.show<void>(
    context,
    dialog: M3EDialog(
      title: 'Mine',
      actions: <Widget>[
        _textButton('Caller', () {}),
        M3EButton(onPressed: () {}, child: const Text('Filled')),
      ],
    ),
  );
  await tester.pumpAndSettle();
  final TextStyle caller = _labelStyle(tester, 'Caller');
  final TextStyle filled = _labelStyle(tester, 'Filled');
  Navigator.of(context).pop();
  await tester.pumpAndSettle();

  M3EDialog.showDiscardConfirmation(context);
  await tester.pumpAndSettle();
  final TextStyle builtIn = _labelStyle(tester, 'Discard');
  expect(caller.fontSize, builtIn.fontSize);
  expect(caller.fontSize, _theme.typeScale.labelLarge.fontSize);
  expect(caller.fontWeight, builtIn.fontWeight);
  expect(caller.color, builtIn.color);
  expect(caller.color, _theme.colorScheme.primary);
  // Only text buttons take the dialog tokens.
  expect(filled.color, _theme.colorScheme.onPrimary);
}

Future<void> _underBars(WidgetTester tester) async {
  const bars = FakeViewPadding(top: 40, bottom: 30);
  tester.view
    ..padding = bars
    ..viewPadding = bars;
  final BuildContext context = await _pump(tester, const Size(400, 800));
  M3EDialog.showFullScreen<void>(
    context,
    title: 'Bars',
    bottomActions: <Widget>[_textButton('Create', () {})],
    body: const Text('Body'),
  );
  await tester.pumpAndSettle();
  final Finder header = find.ancestor(
    of: find.text('Bars'),
    matching: find.byType(DecoratedBox),
  );
  final Rect rect = tester.getRect(header.first);
  expect(rect.top, 0);
  expect(rect.height, 56 + 40);
  expect(
    tester.getRect(find.text('Bars')).center.dy,
    moreOrLessEquals(40 + 28),
  );

  final Finder bar = find.ancestor(
    of: find.text('Create'),
    matching: find.byType(DecoratedBox),
  );
  final Rect barRect = tester.getRect(bar.first);
  expect(barRect.bottom, 800);
  expect(barRect.height, 56 + 30);
}
