import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const Key _contentKey = Key('badge-content');

Widget _host(Widget child, {TextDirection textDirection = TextDirection.ltr}) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Directionality(
      textDirection: textDirection,
      child: Scaffold(
        body: Align(alignment: Alignment.topLeft, child: child),
      ),
    ),
  );
}

void main() {
  _registerBadgeThemeTests();
  _registerBadgeLayoutTests();
  _registerBadgeLabelTests();
}

void _registerBadgeThemeTests() {
  test('theme defaults match the badge spec', _themeDefaultsMatchTheBadgeSpec);
}

void _registerBadgeLayoutTests() {
  testWidgets(
    'M3EBadge anchors the indicator to the requested edge',
    _m3ebadgeAnchorsTheIndicatorToTheRequestedEdge,
  );
  testWidgets(
    'M3EBadge does not expand or shift the child',
    _m3ebadgeDoesNotExpandOrShiftTheChild,
  );
  testWidgets('RTL mirrors trailing placement', _rtlMirrorsTrailingPlacement);
}

void _registerBadgeLabelTests() {
  testWidgets(
    'formats count above maxCount as max+',
    _formatsCountAboveMaxCount,
  );
  testWidgets('label is preferred over count', _labelIsPreferredOverCount);
  testWidgets(
    'dot a11y announces New notification',
    _dotA11yAnnouncesNewNotification,
  );
  testWidgets(
    'count a11y announces notification phrasing',
    _countA11yAnnouncesNotificationPhrasing,
  );
}

void _themeDefaultsMatchTheBadgeSpec() {
  const theme = M3EBadgeTheme.defaults;
  expect(theme.dotSize, 6);
  expect(theme.dotCornerRadius, 3);
  expect(theme.labelMinSize, 16);
  expect(theme.labelCornerRadius, 8);
  expect(theme.labelHorizontalPadding, 4);
  expect(theme.labelVerticalPadding, 0);
  expect(theme.labelFontSize, 11);
  expect(theme.labelFontWeight, FontWeight.w500);
  expect(theme.labelLineHeight, 16);
  expect(theme.labelLetterSpacing, 0.5);
  expect(theme.smallOffset, const Offset(6, 6));
  expect(theme.largeOffset, const Offset(12, 14));

  final scheme = M3EThemeData.light().colorScheme;
  expect(theme.containerColor(scheme), scheme.error);
  expect(theme.labelColor(scheme), scheme.onError);
}

Future<void> _m3ebadgeAnchorsTheIndicatorToTheRequestedEdge(
  WidgetTester tester,
) async {
  await _pumpBadge(tester, M3EBadgeAlignment.topRight);
  Rect content = tester.getRect(find.byKey(_contentKey));
  Rect indicator = tester.getRect(find.text('3'));
  expect(indicator.center.dx, greaterThan(content.center.dx));

  await _pumpBadge(tester, M3EBadgeAlignment.topCenter);
  content = tester.getRect(find.byKey(_contentKey));
  indicator = tester.getRect(find.text('3'));
  expect(indicator.center.dx, closeTo(content.center.dx, 0.5));

  await _pumpBadge(tester, M3EBadgeAlignment.topLeft);
  content = tester.getRect(find.byKey(_contentKey));
  indicator = tester.getRect(find.text('3'));
  expect(indicator.center.dx, lessThan(content.center.dx));
}

Future<void> _m3ebadgeDoesNotExpandOrShiftTheChild(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(const SizedBox(key: _contentKey, width: 40, height: 40)),
  );
  final Rect bare = tester.getRect(find.byKey(_contentKey));

  await _pumpBadge(tester, M3EBadgeAlignment.topRight);
  final Rect badge = tester.getRect(find.byType(M3EBadge));
  final Rect content = tester.getRect(find.byKey(_contentKey));

  expect(badge.size, content.size);
  expect(badge.size, bare.size);
  expect(content.topLeft, bare.topLeft);
}

Future<void> _formatsCountAboveMaxCount(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EBadge(
        count: 1200,
        child: SizedBox(key: _contentKey, width: 40, height: 40),
      ),
    ),
  );
  expect(find.text('999+'), findsOneWidget);
}

Future<void> _labelIsPreferredOverCount(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EBadge(
        count: 8,
        label: 'New',
        child: SizedBox(key: _contentKey, width: 40, height: 40),
      ),
    ),
  );
  expect(find.text('New'), findsOneWidget);
  expect(find.text('8'), findsNothing);
}

Future<void> _dotA11yAnnouncesNewNotification(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EBadge(
        showDot: true,
        child: SizedBox(key: _contentKey, width: 40, height: 40),
      ),
    ),
  );
  expect(find.bySemanticsLabel('New notification'), findsOneWidget);
}

Future<void> _countA11yAnnouncesNotificationPhrasing(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const M3EBadge(
        count: 1,
        child: SizedBox(key: _contentKey, width: 40, height: 40),
      ),
    ),
  );
  expect(find.bySemanticsLabel('One new notification'), findsOneWidget);

  await tester.pumpWidget(
    _host(
      const M3EBadge(
        count: 5,
        child: SizedBox(key: _contentKey, width: 40, height: 40),
      ),
    ),
  );
  expect(find.bySemanticsLabel('5 new notifications'), findsOneWidget);
}

Future<void> _rtlMirrorsTrailingPlacement(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EBadge(
        count: 3,
        child: SizedBox(key: _contentKey, width: 40, height: 40),
      ),
      textDirection: TextDirection.rtl,
    ),
  );
  final content = tester.getRect(find.byKey(_contentKey));
  final indicator = tester.getRect(find.text('3'));
  // topRight is trailing; in RTL trailing is visual left.
  expect(indicator.center.dx, lessThan(content.center.dx));
}

Future<void> _pumpBadge(
  WidgetTester tester,
  M3EBadgeAlignment alignment,
) async {
  await tester.pumpWidget(
    _host(
      M3EBadge(
        count: 3,
        alignment: alignment,
        child: const SizedBox(key: _contentKey, width: 40, height: 40),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
