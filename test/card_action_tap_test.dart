import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

double _shift(WidgetTester tester) {
  var shift = 0.0;
  for (final transform in tester.widgetList<Transform>(
    find.byType(Transform),
  )) {
    final double x = transform.transform.getTranslation().x;
    if (x.abs() > shift.abs()) {
      shift = x;
    }
  }
  return shift;
}

Future<void> _drag(WidgetTester tester, Offset delta) {
  return tester.timedDrag(
    find.text('Title'),
    delta,
    const Duration(milliseconds: 400),
  );
}

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  testWidgets(
    'action tap does not activate the card',
    _actionTapDoesNotActivateTheCard,
  );
  testWidgets(
    'partial swipe reveals and a full swipe dismisses',
    _partialSwipeRevealsAndFullSwipeDismisses,
  );
  testWidgets(
    'reveal mode stays open and does not dismiss',
    _revealModeStaysOpenAndDoesNotDismiss,
  );
  testWidgets(
    'dismiss mode does not stay revealed',
    _dismissModeDoesNotStayRevealed,
  );
  testWidgets(
    'vertical stacks a full-width media band above the title',
    _verticalStacksFullWidthMediaBandAboveTitle,
  );
  testWidgets(
    'content on media paints the band across the card',
    _contentOnMediaPaintsBandAcrossCard,
  );
  testWidgets(
    'media divider span follows the content padding',
    _mediaDividerSpanFollowsContentPadding,
  );
  testWidgets(
    'tab and enter reach the card, action, and overflow',
    _tabAndEnterReachCardActionAndOverflow,
  );
  testWidgets(
    'a non-actionable card is not a tab stop',
    _nonActionableCardIsNotATabStop,
  );
  testWidgets(
    'arrow keys show and hide the swipe action after the card',
    _arrowKeysShowAndHideSwipeActionAfterCard,
  );
  testWidgets(
    'a revealed swipe action is a tab stop',
    _revealedSwipeActionIsATabStop,
  );
}

Future<void> _actionTapDoesNotActivateTheCard(WidgetTester tester) async {
  final taps = <String>[];
  await tester.pumpWidget(
    _host(
      M3ECard(
        onPressed: () => taps.add('card'),
        headline: 'Title',
        actions: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: M3EButton.filled(
            onPressed: () => taps.add('action'),
            child: const Text('Action'),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('Action'));
  await tester.pump();
  expect(taps, <String>['action']);

  await tester.tap(find.text('Title'));
  await tester.pump();
  expect(taps, <String>['action', 'card']);
}

Future<void> _partialSwipeRevealsAndFullSwipeDismisses(
  WidgetTester tester,
) async {
  final taps = <String>[];
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 300,
        child: M3ECard(
          onSwipe: () => taps.add('dismiss'),
          headline: 'Title',
          swipeAction: const Icon(M3EIcons.favorite_border),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await _drag(tester, const Offset(90, 0));
  await tester.pump(const Duration(milliseconds: 800));
  expect(taps, isEmpty);
  expect(_shift(tester), greaterThan(40));

  await _drag(tester, const Offset(220, 0));
  await tester.pump(const Duration(milliseconds: 800));
  expect(taps, <String>['dismiss']);
}

Future<void> _revealModeStaysOpenAndDoesNotDismiss(WidgetTester tester) async {
  final taps = <String>[];
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 300,
        child: M3ECard(
          swipeMode: M3ECardSwipeMode.reveal,
          onSwipe: () => taps.add('dismiss'),
          leadingSwipeAction: const Icon(M3EIcons.favorite_border),
          headline: 'Title',
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await _drag(tester, const Offset(220, 0));
  await tester.pump(const Duration(milliseconds: 400));
  expect(taps, isEmpty);
  expect(_shift(tester), lessThan(100));
  expect(_shift(tester), greaterThan(40));
}

Future<void> _dismissModeDoesNotStayRevealed(WidgetTester tester) async {
  final taps = <String>[];
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 300,
        child: M3ECard(
          swipeMode: M3ECardSwipeMode.dismiss,
          onSwipe: () => taps.add('dismiss'),
          headline: 'Title',
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await _drag(tester, const Offset(90, 0));
  await tester.pump(const Duration(seconds: 2));
  expect(taps, isEmpty);
  expect(_shift(tester).abs(), lessThan(24));
}

Future<void> _verticalStacksFullWidthMediaBandAboveTitle(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: 320,
        child: M3ECard(
          vertical: true,
          media: SizedBox(key: Key('media'), height: 40),
          headline: 'Title',
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Rect media = tester.getRect(find.byKey(const Key('media')));
  final Rect title = tester.getRect(find.text('Title'));
  expect(media.bottom, lessThanOrEqualTo(title.top));
  expect(media.width, greaterThan(280));
}

Future<void> _contentOnMediaPaintsBandAcrossCard(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const SizedBox(
        width: 320,
        child: M3ECard(
          contentOnMedia: true,
          media: SizedBox(key: Key('media'), height: 96),
          headline: 'Title',
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Rect media = tester.getRect(find.byKey(const Key('media')));
  final Rect title = tester.getRect(find.text('Title'));
  expect(media.width, greaterThan(280));
  expect(title.center.dy, inInclusiveRange(media.top, media.bottom));
}

Future<double> _mediaDividerInset(
  WidgetTester tester,
  M3ECardDividerSpan span,
) async {
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 320,
        child: M3ECard(
          vertical: true,
          dividerAfterMedia: true,
          mediaDividerSpan: span,
          media: const SizedBox(height: 40),
          headline: 'Title',
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final Rect card = tester.getRect(find.byType(M3ECard));
  final Rect line = tester.getRect(find.byType(M3EDivider));
  return line.left - card.left;
}

Future<void> _mediaDividerSpanFollowsContentPadding(WidgetTester tester) async {
  expect(await _mediaDividerInset(tester, M3ECardDividerSpan.edge), 0);
  expect(await _mediaDividerInset(tester, M3ECardDividerSpan.padding), 16);
}

Future<void> _tabAndEnterReachCardActionAndOverflow(WidgetTester tester) async {
  final taps = <String>[];
  await tester.pumpWidget(
    _host(
      M3ECard(
        onPressed: () => taps.add('card'),
        headline: 'Title',
        actions: M3EButton.filled(
          onPressed: () => taps.add('action'),
          child: const Text('Action'),
        ),
        overflow: M3EMenu.entries(
          anchorBuilder: (BuildContext context, VoidCallback open) {
            return M3EIconButton(
              icon: const Icon(M3EIcons.more_vert),
              tooltip: 'More',
              inflateHitTarget: false,
              onPressed: () {
                taps.add('overflow');
                open();
              },
            );
          },
          entries: const <M3EMenuEntry>[
            M3EMenuEntry(label: 'Move'),
            M3EMenuEntry(label: 'Delete'),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await _tabUntil(tester, M3ECard);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump();
  expect(taps, <String>['card']);

  await _tabUntil(tester, M3EButton);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump();
  expect(taps, <String>['card', 'action']);

  await _tabUntil(tester, M3EIconButton);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pumpAndSettle();
  expect(taps, <String>['card', 'action']);
  expect(find.text('Move'), findsOneWidget);

  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pumpAndSettle();
  expect(find.text('Move'), findsNothing);

  await tester.sendKeyEvent(LogicalKeyboardKey.space);
  await tester.pumpAndSettle();
  expect(find.text('Move'), findsOneWidget);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pumpAndSettle();
  expect(find.text('Move'), findsNothing);
}

Future<void> _nonActionableCardIsNotATabStop(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ECard(
        headline: 'Title',
        actions: M3EButton.filled(
          onPressed: () {},
          child: const Text('Action'),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  expect(_nearestFocus(<Type>[M3EButton, M3ECard]), M3EButton);
}

Future<void> _arrowKeysShowAndHideSwipeActionAfterCard(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 320,
        child: M3ECard(
          onPressed: () {},
          swipeMode: M3ECardSwipeMode.reveal,
          headline: 'Title',
          actions: M3EButton.filled(
            onPressed: () {},
            child: const Text('Action'),
          ),
          leadingSwipeAction: const M3EIconButton(
            icon: Icon(M3EIcons.favorite_border),
            tooltip: 'Favorite',
            inflateHitTarget: false,
            onPressed: _noop,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await _tabUntil(tester, M3ECard);
  expect(_ringClipped(tester), isFalse);

  await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  expect(_shift(tester), greaterThan(40));
  expect(_nearestFocus(<Type>[M3ECard, M3EButton, M3EIconButton]), M3ECard);

  await _tabUntil(tester, M3EButton);
  await _tabUntil(tester, M3EIconButton);

  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  expect(_shift(tester).abs(), lessThan(24));
  expect(_nearestFocus(<Type>[M3ECard, M3EButton, M3EIconButton]), M3ECard);
}

Future<void> _revealedSwipeActionIsATabStop(WidgetTester tester) async {
  final taps = <String>[];
  await tester.pumpWidget(
    _host(
      SizedBox(
        width: 300,
        child: M3ECard(
          swipeMode: M3ECardSwipeMode.reveal,
          headline: 'Title',
          leadingSwipeAction: M3EIconButton(
            key: const Key('fav'),
            icon: const Icon(M3EIcons.favorite_border),
            tooltip: 'Favorite',
            inflateHitTarget: false,
            onPressed: () => taps.add('fav'),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await _drag(tester, const Offset(90, 0));
  await tester.pump(const Duration(milliseconds: 500));
  expect(_shift(tester), greaterThan(40));

  await _tabUntil(tester, M3EIconButton);
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump();
  expect(taps, <String>['fav']);
}

Type? _nearestFocus(List<Type> types) {
  final BuildContext? context = FocusManager.instance.primaryFocus?.context;
  if (context == null) {
    return null;
  }
  if (types.contains(context.widget.runtimeType)) {
    return context.widget.runtimeType;
  }
  Type? hit;
  context.visitAncestorElements((Element element) {
    if (types.contains(element.widget.runtimeType)) {
      hit = element.widget.runtimeType;
      return false;
    }
    return true;
  });
  return hit;
}

void _noop() {}

bool _ringClipped(WidgetTester tester) {
  final Element ring = find.byType(M3EFocusRing).evaluate().firstWhere((
    Element element,
  ) {
    var insideButton = false;
    element.visitAncestorElements((Element ancestor) {
      if (ancestor.widget is M3EIconButton || ancestor.widget is M3EButton) {
        insideButton = true;
        return false;
      }
      return true;
    });
    return !insideButton;
  });
  var clipped = false;
  ring.visitAncestorElements((Element element) {
    if (element.widget is ClipRRect) {
      clipped = true;
      return false;
    }
    return true;
  });
  return clipped;
}

Future<void> _tabUntil(WidgetTester tester, Type type) async {
  const types = <Type>[M3ECard, M3EButton, M3EIconButton];
  for (var i = 0; i < 6; i++) {
    if (_nearestFocus(types) == type) {
      return;
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
  }
  expect(_nearestFocus(types), type);
}
