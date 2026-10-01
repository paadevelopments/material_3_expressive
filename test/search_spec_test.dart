import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'focus_nav_repro_test_support.dart';

final M3EThemeData _theme = M3EThemeData.light(
  seedColor: const Color(0xFF6750A4),
);

Widget _app(Widget child) {
  return M3EMaterialApp(
    data: _theme,
    home: Scaffold(
      body: Align(alignment: Alignment.topCenter, child: child),
    ),
  );
}

Iterable<Widget> _results(BuildContext context, M3ESearchController c) {
  return <Widget>[
    for (final name in <String>['Alpha', 'Beta'])
      ListTile(title: Text(name), onTap: () {}),
  ];
}

Finder get _barMaterial => find
    .descendant(of: find.byType(M3ESearchBar), matching: find.byType(Material))
    .first;

Finder get _viewBar => find.byWidgetPredicate(
  (Widget widget) => widget is M3ESearchBar && !widget.readOnly,
);

Future<void> _openAnchor(
  WidgetTester tester, {
  required Size surface,
  bool? isFullScreen,
  M3ESearchViewStyle? style,
}) async {
  _setWindow(tester, surface);
  final controller = M3ESearchController();
  await tester.pumpWidget(
    _app(
      M3ESearchAnchor.bar(
        searchController: controller,
        isFullScreen: isFullScreen,
        viewStyle: style,
        barHintText: 'Search',
        suggestionsBuilder: _results,
      ),
    ),
  );
  controller.openView();
  await tester.pumpAndSettle();
}

void _setWindow(WidgetTester tester, Size size) {
  tester.view
    ..physicalSize = size
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  setUp(setUpFocusNavReproTests);
  tearDown(tearDownFocusNavReproTests);

  testWidgets(
    'bar paddings follow the 4 / 48 / 4 redlines',
    _barPaddingsFollowThe4484Redlines,
  );
  testWidgets(
    'bar caps at 720 and keeps the 56 height',
    _barCapsAt720AndKeepsThe56Height,
  );
  testWidgets('avatar is 30 inside a 48 target', _avatarIs30InsideA48Target);
  testWidgets(
    'clear button shows with text and clears it',
    _clearButtonShowsWithTextAndClearsIt,
  );
  testWidgets(
    'focus ring is secondary, 3 thick, 2 offset; tap hides it',
    _focusRingIsSecondary3Thick2OffsetTapHidesIt,
  );
  testWidgets(
    'contained full-screen view: surface container low, 56 bar',
    _containedFullScreenViewSurfaceContainerLow56Bar,
  );
  testWidgets(
    'docked at >= 600 with scrim, 2 gap, and r28 results',
    _dockedAt600WithScrim2GapAndR28Results,
  );
  testWidgets(
    'divided full-screen view: 72 header and divider',
    _dividedFullScreenView72HeaderAndDivider,
  );
  testWidgets(
    'ArrowDown moves from the field into the results',
    _arrowdownMovesFromTheFieldIntoTheResults,
  );
  testWidgets('result changes are announced', _resultChangesAreAnnounced);
  testWidgets(
    'predictive back scales the view down',
    _predictiveBackScalesTheViewDown,
  );
  testWidgets(
    'scroll-away sliver bar hides and reappears toward the top',
    _scrollAwaySliverBarHidesAndReappearsTowardTheTop,
  );
}

Future<void> _barPaddingsFollowThe4484Redlines(WidgetTester tester) async {
  await tester.pumpWidget(
    _app(
      const SizedBox(
        width: 500,
        child: M3ESearchBar(
          hintText: 'Search',
          leading: Icon(M3EIcons.menu),
          trailing: <Widget>[Icon(M3EIcons.mic)],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Rect bar = tester.getRect(_barMaterial);
  expect(bar.height, 56);
  // 24 unfocused margins on each side.
  expect(bar.width, 500 - 48);
  final Rect leading = tester.getRect(find.byIcon(M3EIcons.menu));
  final Rect trailing = tester.getRect(find.byIcon(M3EIcons.mic));
  expect(leading.size, const Size(24, 24));
  // Edge → 48 target is 4; icon is centered in the target.
  expect(leading.left - bar.left, 4 + 12);
  expect(bar.right - trailing.right, 4 + 12);
}

Future<void> _barCapsAt720AndKeepsThe56Height(WidgetTester tester) async {
  _setWindow(tester, const Size(1200, 800));
  await tester.pumpWidget(
    _app(const SizedBox(width: 1100, child: M3ESearchBar(hintText: 'S'))),
  );
  await tester.pumpAndSettle();
  expect(tester.getSize(_barMaterial), const Size(720, 56));
}

Future<void> _avatarIs30InsideA48Target(WidgetTester tester) async {
  await tester.pumpWidget(
    _app(
      const SizedBox(
        width: 500,
        child: M3ESearchBar(
          hintText: 'Search',
          avatar: ColoredBox(key: Key('avatar'), color: Color(0xFF00FF00)),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final Rect avatar = tester.getRect(find.byKey(const Key('avatar')));
  final Rect bar = tester.getRect(_barMaterial);
  expect(avatar.size, const Size(30, 30));
  // 4 trailing space + (48 - 30) / 2.
  expect(bar.right - avatar.right, 4 + 9);
}

Future<void> _clearButtonShowsWithTextAndClearsIt(WidgetTester tester) async {
  final controller = TextEditingController(text: 'abc');
  addTearDown(controller.dispose);
  await tester.pumpWidget(
    _app(
      SizedBox(
        width: 500,
        child: M3ESearchBar(
          controller: controller,
          hintText: 'Search',
          showClearButton: true,
        ),
      ),
    ),
  );
  expect(find.byIcon(M3EIcons.close), findsOneWidget);
  await tester.tap(find.byIcon(M3EIcons.close));
  await tester.pump();
  expect(controller.text, isEmpty);
  expect(find.byIcon(M3EIcons.close), findsNothing);
}

Future<void> _focusRingIsSecondary3Thick2OffsetTapHidesIt(
  WidgetTester tester,
) async {
  final before = FocusNode(debugLabel: 'before');
  final search = FocusNode(debugLabel: 'search');
  addTearDown(before.dispose);
  addTearDown(search.dispose);
  await tester.pumpWidget(
    _app(
      SizedBox(
        width: 500,
        child: Column(
          children: <Widget>[
            Focus(focusNode: before, child: const SizedBox(height: 10)),
            M3ESearchBar(focusNode: search, hintText: 'Search'),
          ],
        ),
      ),
    ),
  );
  M3EFocusInteraction.instance.noteKeyboardHighlight();
  before.requestFocus();
  await tester.pumpAndSettle();
  await pumpFocusNavTab(tester);

  final Finder ringFinder = find.descendant(
    of: find.byType(M3ESearchBar),
    matching: find.byType(M3EFocusRing),
  );
  M3EFocusRing ring = tester.widget<M3EFocusRing>(ringFinder.first);
  expect(search.hasPrimaryFocus, isTrue);
  expect(ring.focused, isTrue);
  expect(ring.color, _theme.colorScheme.secondary);
  expect(ring.width, 3);
  expect(ring.gap, 2);

  await tester.tap(find.byType(EditableText));
  await tester.pumpAndSettle();
  ring = tester.widget<M3EFocusRing>(ringFinder.first);
  expect(ring.focused, isFalse);
}

Future<void> _containedFullScreenViewSurfaceContainerLow56Bar(
  WidgetTester tester,
) async {
  await _openAnchor(tester, surface: const Size(400, 800));

  expect(
    tester
        .widgetList<Material>(find.byType(Material))
        .any((Material m) => m.color == _theme.colorScheme.surfaceContainerLow),
    isTrue,
  );
  final Rect bar = tester.getRect(
    find.descendant(of: _viewBar, matching: find.byType(Material)).first,
  );
  expect(bar.height, closeTo(56, 0.1));
  expect(bar.left, closeTo(12, 0.1));
  // 8 above the bar (72 header); results inset 12 like the bar.
  expect(bar.top, closeTo(8, 0.1));
  expect(tester.getRect(find.byType(ListTile).first).left, closeTo(12, 0.1));
  expect(bar.right, closeTo(400 - 12, 0.1));
  expect(find.byType(M3EDivider), findsNothing);
}

Future<void> _dockedAt600WithScrim2GapAndR28Results(WidgetTester tester) async {
  await _openAnchor(tester, surface: const Size(900, 800));

  final Color scrim = _theme.colorScheme.scrim.withValues(alpha: 0.32);
  expect(
    tester
        .widgetList<ColoredBox>(find.byType(ColoredBox))
        .any((ColoredBox box) => box.color == scrim),
    isTrue,
  );
  final Rect bar = tester.getRect(
    find.descendant(of: _viewBar, matching: find.byType(Material)).first,
  );
  final Material results = tester
      .widgetList<Material>(find.byType(Material))
      .firstWhere(
        (Material m) =>
            m.shape is RoundedRectangleBorder &&
            (m.shape! as RoundedRectangleBorder).borderRadius ==
                BorderRadius.circular(28),
      );
  final Rect resultsRect = tester.getRect(find.byWidget(results));
  expect(bar.height, closeTo(56, 0.1));
  expect(resultsRect.top - bar.bottom, closeTo(2, 0.1));
  expect(resultsRect.width, lessThanOrEqualTo(720));
}

Future<void> _dividedFullScreenView72HeaderAndDivider(
  WidgetTester tester,
) async {
  await _openAnchor(
    tester,
    surface: const Size(400, 800),
    style: M3ESearchViewStyle.divided,
  );
  final Rect bar = tester.getRect(
    find.descendant(of: _viewBar, matching: find.byType(Material)).first,
  );
  expect(bar.height, closeTo(72, 0.1));
  final M3EDivider divider = tester.widget<M3EDivider>(find.byType(M3EDivider));
  expect(divider.color, _theme.colorScheme.outline);
}

Future<void> _arrowdownMovesFromTheFieldIntoTheResults(
  WidgetTester tester,
) async {
  await _openAnchor(tester, surface: const Size(400, 800));
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pumpAndSettle();
  final FocusNode? focused = FocusManager.instance.primaryFocus;
  expect(focused?.context, isNotNull);
  expect(
    find.ancestor(
      of: find.byElementPredicate((Element e) => e == focused!.context),
      matching: find.widgetWithText(ListTile, 'Alpha'),
    ),
    findsOneWidget,
  );
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
  await tester.pumpAndSettle();
  expect(
    find
        .descendant(of: _viewBar, matching: find.byType(EditableText))
        .evaluate()
        .isNotEmpty,
    isTrue,
  );
  final EditableText field = tester.widget<EditableText>(
    find.descendant(of: _viewBar, matching: find.byType(EditableText)),
  );
  expect(field.focusNode.hasPrimaryFocus, isTrue);
}

Future<void> _resultChangesAreAnnounced(WidgetTester tester) async {
  final events = <Map<dynamic, dynamic>>[];
  tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<dynamic>(
    SystemChannels.accessibility,
    (dynamic message) async {
      events.add(message as Map<dynamic, dynamic>);
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger
        .setMockDecodedMessageHandler<dynamic>(
          SystemChannels.accessibility,
          null,
        ),
  );
  await _openAnchor(tester, surface: const Size(400, 800));
  expect(
    events.any(
      (Map<dynamic, dynamic> e) =>
          e['type'] == 'announce' &&
          (e['data'] as Map<dynamic, dynamic>)['message'] ==
              '2 results available',
    ),
    isTrue,
  );
}

Future<void> _predictiveBackScalesTheViewDown(WidgetTester tester) async {
  await _openAnchor(tester, surface: const Size(400, 800));

  Future<void> send(String method, [Map<String, dynamic>? args]) async {
    final ByteData data = const StandardMethodCodec().encodeMethodCall(
      MethodCall(method, args),
    );
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      SystemChannels.backGesture.name,
      data,
      (ByteData? _) {},
    );
  }

  await send('startBackGesture', <String, dynamic>{
    'touchOffset': <double>[5, 300],
    'progress': 0.0,
    'swipeEdge': 0,
  });
  await send('updateBackGestureProgress', <String, dynamic>{
    'touchOffset': <double>[100, 300],
    'progress': 1.0,
    'swipeEdge': 0,
  });
  await tester.pump();
  final Iterable<double> scales = tester
      .widgetList<Transform>(
        find.ancestor(of: _viewBar, matching: find.byType(Transform)),
      )
      .map((Transform t) => t.transform.storage[0]);
  expect(scales.any((double s) => (s - 0.9).abs() < 0.001), isTrue);

  await send('commitBackGesture');
  await tester.pumpAndSettle();
  expect(_viewBar, findsNothing);
}

Future<void> _scrollAwaySliverBarHidesAndReappearsTowardTheTop(
  WidgetTester tester,
) async {
  final scroll = ScrollController();
  addTearDown(scroll.dispose);
  await tester.pumpWidget(
    M3EMaterialApp(
      data: _theme,
      home: Scaffold(
        body: CustomScrollView(
          controller: scroll,
          slivers: <Widget>[
            const M3ESliverSearchBar(child: M3ESearchBar(hintText: 'Find')),
            SliverList.list(
              children: <Widget>[
                for (var i = 0; i < 60; i++)
                  SizedBox(height: 50, child: Text('row $i')),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  expect(tester.getRect(_barMaterial).top, greaterThanOrEqualTo(0));

  await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
  await tester.pumpAndSettle();
  final Finder visibleBar = find.descendant(
    of: find.byType(M3ESearchBar),
    matching: find.byType(Material),
  );
  expect(
    visibleBar.evaluate().isEmpty ||
        tester.getRect(visibleBar.first).bottom <= 0,
    isTrue,
  );

  await tester.drag(find.byType(CustomScrollView), const Offset(0, 120));
  await tester.pumpAndSettle();
  expect(tester.getRect(_barMaterial).top, greaterThanOrEqualTo(0));
}
