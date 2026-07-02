import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/refresh_indicator/enums/m3e_refresh_status.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: SizedBox(width: 300, height: 400, child: child),
    ),
  );
}

Widget _list() {
  return ListView.builder(
    itemCount: 20,
    itemBuilder: (BuildContext context, int index) => SizedBox(
      height: 40,
      child: Text('row$index'),
    ),
  );
}

void main() {
  testWidgets('renders its child at rest', _rendersChild);
  testWidgets('overscroll drag triggers the refresh callback', _dragRefreshes);
  testWidgets('show() drives a refresh and reports status', _showRefreshes);
  testWidgets('contained variant drives a refresh', _containedRefreshes);
}

Future<void> _rendersChild(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(M3ERefreshIndicator(onRefresh: () async {}, child: _list())),
  );

  expect(find.text('row0'), findsOneWidget);
}

Future<void> _dragRefreshes(WidgetTester tester) async {
  var refreshed = false;

  await tester.pumpWidget(
    _host(
      M3ERefreshIndicator(
        onRefresh: () async {
          refreshed = true;
        },
        child: _list(),
      ),
    ),
  );

  await tester.fling(find.text('row0'), const Offset(0, 300), 1000);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();

  expect(refreshed, isTrue);
}

Future<void> _showRefreshes(WidgetTester tester) async {
  var refreshed = false;
  final statuses = <M3ERefreshStatus?>[];
  final key = GlobalKey<M3ERefreshIndicatorState>();

  await tester.pumpWidget(
    _host(
      M3ERefreshIndicator(
        key: key,
        onStatusChange: statuses.add,
        onRefresh: () async {
          refreshed = true;
        },
        child: _list(),
      ),
    ),
  );

  unawaited(key.currentState!.show());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
  expect(statuses, contains(M3ERefreshStatus.refresh));

  await tester.pumpAndSettle();
  expect(refreshed, isTrue);
}

Future<void> _containedRefreshes(WidgetTester tester) async {
  final statuses = <M3ERefreshStatus?>[];

  await tester.pumpWidget(
    _host(
      M3ERefreshIndicator.contained(
        onRefresh: () async {},
        onStatusChange: statuses.add,
        child: _list(),
      ),
    ),
  );

  await tester.fling(find.text('row0'), const Offset(0, 300), 1000);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();

  expect(statuses, contains(M3ERefreshStatus.refresh));
}
