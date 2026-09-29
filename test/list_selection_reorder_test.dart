import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/list_test_helpers.dart';

void main() {
  testWidgets(
    'list-owned selection fills and supports single-select',
    _listOwnedSelection,
  );
  testWidgets(
    'list prefers ancestor M3ESelectionScope controller',
    _listPrefersAncestorScope,
  );
  testWidgets('card list onReorder fires after drop', _cardListReorder);
  testWidgets(
    'single tap is not delayed by double-tap trigger',
    _tapNotDelayed,
  );
  testWidgets(
    'dismissible list selection fill and double-tap',
    _dismissibleSelection,
  );
  testWidgets(
    'dismissible list onReorder fires after drop',
    _dismissibleReorder,
  );
  testWidgets(
    'dismissible reorder and dismiss are mutually exclusive',
    _dismissibleReorderDismissExclusion,
  );
}

Future<void> _listOwnedSelection(WidgetTester tester) async {
  Set<int>? last;
  await pumpList(
    tester,
    M3EList(
      selection: true,
      selectionState: const M3EListSelectionState(
        mode: M3EListSelectionMode.single,
        selectedIcon: Icon(M3EIcons.check_circle),
      ),
      onSelectionChanged: (Set<int> s) => last = s,
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Item $index',
        leading: const Icon(M3EIcons.inbox),
      ),
    ),
  );

  expect(find.byType(M3ESelectionFlip), findsNWidgets(3));
  await tester.tap(find.byType(M3ESelectionFlip).at(1));
  await tester.pumpAndSettle();
  expect(last, <int>{1});

  final M3EColorScheme scheme = M3EThemeData.light(
    seedColor: const Color(0xFF6750A4),
  ).colorScheme;
  expect(rowColor(tester, 'Item 1'), scheme.secondaryContainer);

  await tester.tap(find.text('Item 0'));
  await tester.pumpAndSettle();
  expect(last, <int>{0});
  expect(rowColor(tester, 'Item 0'), scheme.secondaryContainer);
  expect(rowColor(tester, 'Item 1'), isNot(scheme.secondaryContainer));
}

Future<void> _listPrefersAncestorScope(WidgetTester tester) async {
  final controller = M3ESelectionController()..select(2);
  addTearDown(controller.dispose);

  await pumpList(
    tester,
    M3ESelection(
      controller: controller,
      itemCount: 3,
      appBar: const M3ESelectionAppBar(idle: SizedBox(height: 32)),
      body: M3EList(
        selection: true,
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) =>
            M3EListItem(headline: 'Row $index'),
      ),
    ),
  );

  final M3EColorScheme scheme = M3EThemeData.light(
    seedColor: const Color(0xFF6750A4),
  ).colorScheme;
  expect(rowColor(tester, 'Row 2'), scheme.secondaryContainer);
  expect(controller.isSelected(2), isTrue);
  // No caller icon: multi-select still shows the built-in checkbox cue.
  expect(find.byType(M3ESelectionFlip), findsNWidgets(3));
}

Future<void> _cardListReorder(WidgetTester tester) async {
  final items = <String>['A', 'B', 'C'];
  await pumpList(
    tester,
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return M3EList(
          reorder: true,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              final String item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
            });
          },
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) => M3EListItem(
            headline: items[index],
            trailing: const Icon(M3EIcons.chevron_right),
          ),
        );
      },
    ),
  );

  expect(find.byIcon(M3EIcons.drag_handle), findsNWidgets(3));
  expect(find.byIcon(M3EIcons.chevron_right), findsNothing);

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('A')),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
  await gesture.moveBy(const Offset(0, 140));
  await tester.pump();

  final Rect listRect = tester.getRect(find.byType(M3EList).first);
  for (final Element element in find.byIcon(M3EIcons.drag_handle).evaluate()) {
    final box = element.renderObject! as RenderBox;
    expect(box.localToGlobal(Offset.zero).dx, greaterThan(listRect.center.dx));
  }

  await gesture.up();
  await tester.pumpAndSettle();

  expect(items.first, isNot('A'));
  expect(find.text('A'), findsOneWidget);
  expect(find.text('B'), findsOneWidget);
  expect(find.text('C'), findsOneWidget);
}

Future<void> _tapNotDelayed(WidgetTester tester) async {
  final taps = <int>[];
  await pumpList(
    tester,
    M3EList(
      selection: true,
      selectionState: const M3EListSelectionState(
        trigger: M3EListSelectionTrigger.doubleTap,
      ),
      onTap: taps.add,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) =>
          const M3EListItem(headline: 'Tap me'),
    ),
  );

  await tester.tap(find.text('Tap me'));
  await tester.pump();
  expect(taps, <int>[0]);
}

Future<void> _dismissibleSelection(WidgetTester tester) async {
  Set<int>? last;
  await pumpList(
    tester,
    _dismissibleSelectionColumn(onSelectionChanged: (Set<int> s) => last = s),
  );

  expect(find.byType(M3ESelectionFlip), findsNWidgets(2));
  await tester.tap(find.byType(M3ESelectionFlip).at(0));
  await tester.pumpAndSettle();
  expect(last, <int>{0});

  final M3EColorScheme scheme = M3EThemeData.light(
    seedColor: const Color(0xFF6750A4),
  ).colorScheme;
  expect(rowColor(tester, 'Row 0'), scheme.secondaryContainer);

  final Finder card = find.ancestor(
    of: find.text('Row 0'),
    matching: find.byType(M3ECard),
  );
  final BorderRadius? radius = tester.widget<M3ECard>(card.first).borderRadius;
  expect(radius?.topLeft, radius?.bottomLeft);
  expect(radius?.topLeft, radius?.topRight);

  await _pumpDoubleTapDismissible(
    tester,
    onSelectionChanged: (Set<int> s) => last = s,
  );
  last = null;
  await tester.tap(find.text('Double'));
  await tester.pump(const Duration(milliseconds: 40));
  await tester.tap(find.text('Double'));
  await tester.pumpAndSettle();
  expect(last, <int>{0});
}

Widget _dismissibleSelectionColumn({
  required ValueChanged<Set<int>> onSelectionChanged,
}) {
  return M3EList(
    selection: true,
    selectionState: const M3EListSelectionState(
      mode: M3EListSelectionMode.single,
      selectedIcon: Icon(M3EIcons.check_circle),
    ),
    onSelectionChanged: onSelectionChanged,
    itemCount: 2,
    itemBuilder: (BuildContext context, int index) {
      return M3EListItem(
        headline: 'Row $index',
        leading: const Icon(M3EIcons.schedule),
        swipe: M3EListItemSwipe(
          onDismiss: (DismissDirection direction) async => false,
        ),
      );
    },
  );
}

Future<void> _pumpDoubleTapDismissible(
  WidgetTester tester, {
  required ValueChanged<Set<int>> onSelectionChanged,
}) async {
  await pumpList(
    tester,
    M3EList(
      selection: true,
      selectionState: const M3EListSelectionState(
        trigger: M3EListSelectionTrigger.doubleTap,
      ),
      onSelectionChanged: onSelectionChanged,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Double',
          swipe: M3EListItemSwipe(
            onDismiss: (DismissDirection direction) async => false,
          ),
        );
      },
    ),
  );
}

Future<void> _dismissibleReorder(WidgetTester tester) async {
  final items = <String>['A', 'B', 'C'];
  await pumpList(
    tester,
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return M3EList(
          reorder: true,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              final String item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
            });
          },
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) => M3EListItem(
            headline: items[index],
            trailing: const Icon(M3EIcons.chevron_right),
            swipe: M3EListItemSwipe(
              onDismiss: (DismissDirection direction) async => false,
            ),
          ),
        );
      },
    ),
  );

  expect(find.byIcon(M3EIcons.drag_handle), findsNWidgets(3));
  expect(find.byIcon(M3EIcons.chevron_right), findsNothing);

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('A')),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
  await gesture.moveBy(const Offset(0, 140));
  await tester.pump();
  await gesture.up();
  await tester.pumpAndSettle();

  expect(items.first, isNot('A'));
  expect(find.text('A'), findsOneWidget);
  expect(find.text('B'), findsOneWidget);
  expect(find.text('C'), findsOneWidget);
}

Future<void> _dismissibleReorderDismissExclusion(WidgetTester tester) async {
  var dismissCalls = 0;
  final items = <String>['A', 'B', 'C'];
  await pumpList(
    tester,
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return M3EList(
          reorder: true,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              final String item = items.removeAt(oldIndex);
              items.insert(newIndex, item);
            });
          },
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) => M3EListItem(
            headline: items[index],
            trailing: const Icon(M3EIcons.chevron_right),
            swipe: M3EListItemSwipe(
              onDismiss: (DismissDirection direction) async {
                dismissCalls++;
                return false;
              },
            ),
          ),
        );
      },
    ),
  );

  // While reordering, horizontal swipe must not dismiss.
  final TestGesture reorder = await tester.startGesture(
    tester.getCenter(find.text('A')),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
  await reorder.moveBy(const Offset(120, 40));
  await tester.pump();
  await reorder.up();
  await tester.pumpAndSettle();
  expect(dismissCalls, 0);

  // While dismissing (including spring-back), long-press must not reorder.
  final before = List<String>.from(items);
  final TestGesture dismiss = await tester.startGesture(
    tester.getCenter(find.text(items.first)),
  );
  await dismiss.moveBy(const Offset(80, 0));
  await tester.pump();
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
  await dismiss.moveBy(const Offset(0, 120));
  await tester.pump();
  await dismiss.up();
  await tester.pumpAndSettle();
  expect(items, before);
}
