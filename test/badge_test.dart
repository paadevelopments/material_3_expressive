import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

const Key _contentKey = Key('badge-content');

void main() {
  testWidgets(
    'M3EBadge anchors the indicator to the requested edge',
    _m3ebadgeAnchorsTheIndicatorToTheRequestedEdge,
  );
  testWidgets(
    'M3EBadge reserves room for the indicator',
    _m3ebadgeReservesRoomForTheIndicator,
  );
}

Future<void> _pumpBadge(
  WidgetTester tester,
  M3EBadgeAlignment alignment,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: Align(
          alignment: Alignment.topLeft,
          child: M3EBadge(
            count: 3,
            alignment: alignment,
            child: const SizedBox(key: _contentKey, width: 40, height: 40),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
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

Future<void> _m3ebadgeReservesRoomForTheIndicator(WidgetTester tester) async {
  await _pumpBadge(tester, M3EBadgeAlignment.topRight);

  final Rect badge = tester.getRect(find.byType(M3EBadge));
  final Rect content = tester.getRect(find.byKey(_contentKey));
  final Rect indicator = tester.getRect(find.text('3'));

  expect(badge.width, greaterThan(content.width));
  expect(badge.height, greaterThan(content.height));
  expect(indicator.top, greaterThanOrEqualTo(badge.top));
  expect(indicator.right, lessThanOrEqualTo(badge.right));
}
