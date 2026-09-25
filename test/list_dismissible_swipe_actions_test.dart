import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  registerDismissiblePreviewSnapTests();
  registerDismissibleReorderBlockedTests();
  registerDismissibleFullDismissTests();
}

void registerDismissiblePreviewSnapTests() {
  testWidgets('dismissible action preview snaps open and closes on card tap', (
    WidgetTester tester,
  ) async {
    var archiveTaps = 0;
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        home: Scaffold(
          body: M3EList(
            itemCount: 2,
            itemBuilder: (BuildContext context, int index) {
              return M3EListItem(
                headline: 'Item $index',
                swipe: M3EListItemSwipe(
                  onDismiss: (DismissDirection direction) async => false,
                  trailing: <M3EListSwipeAction>[
                    M3EListSwipeAction(
                      icon: const Icon(M3EIcons.archive),
                      width: 56,
                      onPressed: () => archiveTaps++,
                    ),
                    const M3EListSwipeAction(
                      icon: Icon(M3EIcons.delete),
                      width: 56,
                      isPrimary: true,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Offset start = tester.getCenter(find.text('Item 0'));
    final TestGesture gesture = await tester.startGesture(start);
    // Drag left past 35% of actions width (~(56+56+8*3)=184 → 0.35≈64).
    await gesture.moveBy(const Offset(-100, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    expect(find.byIcon(M3EIcons.archive), findsOneWidget);
    expect(find.byIcon(M3EIcons.delete), findsOneWidget);

    // Card is translated left while open — tap its on-screen body.
    final Finder card = find.ancestor(
      of: find.text('Item 0'),
      matching: find.byType(M3ECard),
    );
    final Rect cardRect = tester.getRect(card.first);
    await tester.tapAt(Offset(cardRect.right - 24, cardRect.center.dy));
    await tester.pumpAndSettle();
    expect(find.byIcon(M3EIcons.archive), findsNothing);

    // Re-open and tap action.
    final TestGesture open = await tester.startGesture(
      tester.getCenter(find.text('Item 0')),
    );
    await open.moveBy(const Offset(-100, 0));
    await tester.pump();
    await open.up();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(M3EIcons.archive));
    await tester.pumpAndSettle();
    expect(archiveTaps, 1);
    expect(find.byIcon(M3EIcons.archive), findsNothing);
  });
}

List<M3EListSwipeAction> _previewSwipeActions(int index) {
  return const <M3EListSwipeAction>[
    M3EListSwipeAction(icon: Icon(M3EIcons.archive), width: 56),
    M3EListSwipeAction(icon: Icon(M3EIcons.delete), width: 56, isPrimary: true),
  ];
}

void _applyListReorder(
  List<String> items,
  StateSetter setState,
  int oldIndex,
  int newIndex,
) {
  setState(() {
    final String item = items.removeAt(oldIndex);
    items.insert(newIndex, item);
  });
}

Widget _reorderBlockedColumn(List<String> items, StateSetter setState) {
  return M3EList(
    reorder: true,
    onReorder: (int oldIndex, int newIndex) {
      _applyListReorder(items, setState, oldIndex, newIndex);
    },
    itemCount: items.length,
    itemBuilder: (BuildContext context, int index) {
      return M3EListItem(
        headline: items[index],
        swipe: M3EListItemSwipe(
          onDismiss: (DismissDirection direction) async => false,
          trailing: _previewSwipeActions(index),
        ),
      );
    },
  );
}

Widget _reorderBlockedDismissibleHost(List<String> items) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return _reorderBlockedColumn(items, setState);
        },
      ),
    ),
  );
}

Future<void> _openActionPreviewThenAttemptReorder(WidgetTester tester) async {
  final TestGesture open = await tester.startGesture(
    tester.getCenter(find.text('A')),
  );
  await open.moveBy(const Offset(-100, 0));
  await tester.pump();
  await open.up();
  await tester.pumpAndSettle();

  final TestGesture reorder = await tester.startGesture(
    tester.getCenter(find.text('A')),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
  await reorder.moveBy(const Offset(0, 120));
  await tester.pump();
  await reorder.up();
  await tester.pumpAndSettle();
}

void registerDismissibleReorderBlockedTests() {
  testWidgets('dismissible action preview blocks reorder long-press', (
    WidgetTester tester,
  ) async {
    final items = <String>['A', 'B', 'C'];
    await tester.pumpWidget(_reorderBlockedDismissibleHost(items));
    await tester.pumpAndSettle();

    final before = List<String>.from(items);
    await _openActionPreviewThenAttemptReorder(tester);
    expect(items, before);
  });
}

void registerDismissibleFullDismissTests() {
  testWidgets('dismissible without actions still full-dismisses', (
    WidgetTester tester,
  ) async {
    var dismissed = false;
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        home: Scaffold(
          body: SizedBox(
            width: 400,
            child: M3EList(
              itemCount: 1,
              dismissStyle: const M3EDismissibleListStyle(
                background: ColoredBox(color: Color(0xFF00FF00)),
              ),
              itemBuilder: (BuildContext context, int index) {
                return M3EListItem(
                  headline: 'Only',
                  swipe: M3EListItemSwipe(
                    onDismiss: (DismissDirection direction) async {
                      dismissed = true;
                      return true;
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final TestGesture gesture = await tester.startGesture(
      tester.getCenter(find.text('Only')),
    );
    await gesture.moveBy(const Offset(120, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(dismissed, isTrue);
  });
}
