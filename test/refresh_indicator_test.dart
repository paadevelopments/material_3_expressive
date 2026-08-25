import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(
    home: Scaffold(body: SizedBox(width: 300, height: 400, child: child)),
  );
}

Widget _list() {
  return ListView.builder(
    itemCount: 20,
    itemBuilder: (BuildContext context, int index) =>
        SizedBox(height: 40, child: Text('row$index')),
  );
}

void main() {
  testWidgets('renders its child at rest', _rendersChild);
  testWidgets('overscroll past full reveal triggers refresh', _dragRefreshes);
  testWidgets('show() drives a refresh and reports status', _showRefreshes);
  testWidgets('contained variant drives a refresh', _containedRefreshes);
  testWidgets(
    'short pull cancels without calling onRefresh',
    _shortPullCancels,
  );
  testWidgets(
    'reveal stays 0 until pad passes 2× indicatorPadding',
    _revealDelayedByPadding,
  );
  testWidgets(
    'resting inset stays put while refresh runs',
    _restingInsetStableDuringRefresh,
  );
  testWidgets(
    'controller stays attached across keyed variant switch',
    _controllerSurvivesKeyedVariantSwitch,
  );
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

  // Need enough overscroll to fully reveal (height + 2*padding ≈ 64).
  await tester.fling(find.text('row0'), const Offset(0, 400), 2000);
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

  await tester.fling(find.text('row0'), const Offset(0, 400), 2000);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
  await tester.pumpAndSettle();

  expect(statuses, contains(M3ERefreshStatus.refresh));
}

Future<void> _shortPullCancels(WidgetTester tester) async {
  var refreshed = false;
  final statuses = <M3ERefreshStatus?>[];

  await tester.pumpWidget(
    _host(
      M3ERefreshIndicator(
        onStatusChange: statuses.add,
        onRefresh: () async {
          refreshed = true;
        },
        child: _list(),
      ),
    ),
  );

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('row0')),
  );
  // Pad grows but stays below full reveal (max ≈ 64 with defaults).
  await gesture.moveBy(const Offset(0, 24));
  await tester.pump();
  await gesture.up();
  await tester.pumpAndSettle();

  expect(refreshed, isFalse);
  expect(statuses, contains(M3ERefreshStatus.canceled));
  expect(statuses, isNot(contains(M3ERefreshStatus.refresh)));
}

Future<void> _revealDelayedByPadding(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(M3ERefreshIndicator(onRefresh: () async {}, child: _list())),
  );

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('row0')),
  );
  // Below 2× padding (16): reveal must stay at 0.
  await gesture.moveBy(const Offset(0, 10));
  await tester.pump();

  final Finder opacityFinder = find.descendant(
    of: find.byType(M3ERefreshIndicator),
    matching: find.byType(Opacity),
  );
  expect(opacityFinder, findsWidgets);
  expect(tester.widget<Opacity>(opacityFinder.first).opacity, 0);

  // Past the delay, reveal should begin.
  await gesture.moveBy(const Offset(0, 20));
  await tester.pump();
  expect(tester.widget<Opacity>(opacityFinder.first).opacity, greaterThan(0));
  expect(tester.widget<Opacity>(opacityFinder.first).opacity, lessThan(1));

  await gesture.up();
  await tester.pumpAndSettle();
}

Future<void> _restingInsetStableDuringRefresh(WidgetTester tester) async {
  final refreshHold = Completer<void>();
  final statuses = <M3ERefreshStatus?>[];

  await tester.pumpWidget(
    _host(
      M3ERefreshIndicator(
        onStatusChange: statuses.add,
        onRefresh: () => refreshHold.future,
        child: _list(),
      ),
    ),
  );

  await tester.fling(find.text('row0'), const Offset(0, 400), 2000);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
  expect(statuses, contains(M3ERefreshStatus.refresh));

  final Finder indicator = find.byType(M3ELoadingIndicator);
  expect(indicator, findsOneWidget);

  await tester.pump(const Duration(milliseconds: 600));
  final double yAfterBubble = tester.getTopLeft(indicator).dy;

  await tester.pump(const Duration(seconds: 1));
  final double yAfterOneSecond = tester.getTopLeft(indicator).dy;

  expect(
    yAfterOneSecond,
    closeTo(yAfterBubble, 0.5),
    reason: 'resting inset must not move after loading has started',
  );

  refreshHold.complete();
  await tester.pumpAndSettle();
}

Future<void> _controllerSurvivesKeyedVariantSwitch(WidgetTester tester) async {
  final controller = M3ERefreshIndicatorController();
  addTearDown(controller.dispose);
  var refreshCount = 0;
  var kind = 0;

  Widget buildIndicator() {
    Future<void> onRefresh() async {
      refreshCount++;
    }

    if (kind == 0) {
      return M3ERefreshIndicator(
        key: const ValueKey<int>(0),
        controller: controller,
        onRefresh: onRefresh,
        child: _list(),
      );
    }
    return M3ERefreshIndicator.contained(
      key: const ValueKey<int>(1),
      controller: controller,
      onRefresh: onRefresh,
      child: _list(),
    );
  }

  await tester.pumpWidget(
    _host(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: <Widget>[
              TextButton(
                onPressed: () => setState(() => kind = 1 - kind),
                child: const Text('switch'),
              ),
              TextButton(
                onPressed: () => controller.show(),
                child: const Text('trigger'),
              ),
              Expanded(child: buildIndicator()),
            ],
          );
        },
      ),
    ),
  );

  await tester.pumpAndSettle();
  expect(controller.isAttached, isTrue);

  await tester.tap(find.text('switch'));
  await tester.pumpAndSettle();
  expect(controller.isAttached, isTrue);

  unawaited(controller.show());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
  await tester.pumpAndSettle();

  expect(refreshCount, 1);
}
