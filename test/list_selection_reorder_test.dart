import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

M3EList _dataList({
  required List<M3EExpandableData> data,
  bool selection = false,
  M3EListSelectionState? selectionState,
  ValueChanged<Set<int>>? onSelectionChanged,
  bool reorder = false,
  ReorderCallback? onReorder,
  Set<int> initiallyExpanded = const <int>{},
  M3EExpandableStyle? expandStyle,
}) {
  return M3EList(
    itemCount: data.length,
    selection: selection,
    selectionState: selectionState,
    onSelectionChanged: onSelectionChanged,
    reorder: reorder,
    onReorder: onReorder,
    initiallyExpanded: initiallyExpanded,
    expandStyle: expandStyle,
    itemBuilder: (BuildContext context, int index) {
      final M3EExpandableData item = data[index];
      return M3EListItem(
        headline: item.title,
        supportingText: item.subtitle,
        leading: item.leading,
        trailing: item.trailing,
        expanded: item.expanded,
      );
    },
  );
}

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
  testWidgets('expandable sublist appears when expanded', _expandableSublist);
  testWidgets(
    'expandable main selection fill and leading flip',
    _expandableMainSelection,
  );
  testWidgets(
    'expandable leading icon select does not expand',
    _expandableLeadingSelectDoesNotExpand,
  );
  testWidgets(
    'expandable nested last row closes bottom radii',
    _expandableNestedLastClosesBottom,
  );
  testWidgets(
    'expandable parent reorder ignores nested sublist long-press',
    _expandableParentReorderIgnoresNested,
  );
  testWidgets(
    'expandable reorder collapses then restores expansion',
    _expandableReorderRestores,
  );
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

Future<void> _pump(WidgetTester tester, Widget home) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(body: home),
    ),
  );
  await tester.pumpAndSettle();
}

Color? _rowColor(WidgetTester tester, String headline) {
  final Finder card = find.ancestor(
    of: find.text(headline),
    matching: find.byType(M3ECard),
  );
  return tester.widget<M3ECard>(card.first).color;
}

Future<void> _listOwnedSelection(WidgetTester tester) async {
  Set<int>? last;
  await _pump(
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
  expect(_rowColor(tester, 'Item 1'), scheme.secondaryContainer);

  await tester.tap(find.text('Item 0'));
  await tester.pumpAndSettle();
  expect(last, <int>{0});
  expect(_rowColor(tester, 'Item 0'), scheme.secondaryContainer);
  expect(_rowColor(tester, 'Item 1'), isNot(scheme.secondaryContainer));
}

Future<void> _listPrefersAncestorScope(WidgetTester tester) async {
  final controller = M3ESelectionController()..select(2);
  addTearDown(controller.dispose);

  await _pump(
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
  expect(_rowColor(tester, 'Row 2'), scheme.secondaryContainer);
  expect(controller.isSelected(2), isTrue);
  // No caller icon: multi-select still shows the built-in checkbox cue.
  expect(find.byType(M3ESelectionFlip), findsNWidgets(3));
}

Future<void> _cardListReorder(WidgetTester tester) async {
  final items = <String>['A', 'B', 'C'];
  await _pump(
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

Future<void> _expandableSublist(WidgetTester tester) async {
  await _pump(
    tester,
    _dataList(
      data: <M3EExpandableData>[
        M3EExpandableData(
          title: 'Parent',
          subtitle: 'Tap to expand',
          expanded: M3EExpandableExpanded.list(
            M3EList(
              embedded: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return M3EListItem(headline: 'Child ${index + 1}');
              },
            ),
          ),
        ),
      ],
    ),
  );

  // Nested list stays mounted while collapsed (selection/reorder persistence),
  // but must not be hit-testable until expanded.
  expect(find.text('Child 1').hitTestable(), findsNothing);
  await tester.tap(find.text('Parent'));
  await tester.pumpAndSettle();
  expect(find.text('Child 1').hitTestable(), findsOneWidget);
  expect(find.text('Child 2').hitTestable(), findsOneWidget);
}

Future<void> _expandableMainSelection(WidgetTester tester) async {
  Set<int>? last;
  await _pump(
    tester,
    _dataList(
      selection: true,
      selectionState: const M3EListSelectionState(
        mode: M3EListSelectionMode.single,
        selectedIcon: Icon(M3EIcons.check_circle),
      ),
      onSelectionChanged: (Set<int> s) => last = s,
      data: <M3EExpandableData>[
        M3EExpandableData(
          title: 'Section 0',
          leading: const Icon(M3EIcons.inbox),
          expanded: M3EExpandableExpanded.list(
            M3EList(
              embedded: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return const M3EListItem(
                  headline: 'Nested only',
                  leading: Icon(M3EIcons.folder),
                );
              },
            ),
          ),
        ),
        const M3EExpandableData(
          title: 'Section 1',
          leading: Icon(M3EIcons.inbox),
          expanded: M3EExpandableExpanded.content(Text('Body 1')),
        ),
      ],
    ),
  );

  expect(find.byType(M3ESelectionFlip), findsNWidgets(2));

  await tester.tap(find.text('Section 0'));
  await tester.pumpAndSettle();
  expect(find.text('Nested only'), findsOneWidget);
  // Nested leading must not pick up parent selection flips.
  expect(find.byType(M3ESelectionFlip), findsNWidgets(2));

  await tester.tap(find.byType(M3ESelectionFlip).at(1));
  await tester.pumpAndSettle();
  expect(last, <int>{1});

  final M3EColorScheme scheme = M3EThemeData.light(
    seedColor: const Color(0xFF6750A4),
  ).colorScheme;
  expect(_rowColor(tester, 'Section 1'), scheme.secondaryContainer);

  // Selection mode: header tap toggles selection (does not collapse).
  await tester.tap(find.text('Section 0'));
  await tester.pumpAndSettle();
  expect(last, <int>{0});
  expect(find.text('Nested only'), findsOneWidget);
}

Future<void> _expandableLeadingSelectDoesNotExpand(WidgetTester tester) async {
  Set<int>? last;
  await _pump(
    tester,
    _dataList(
      selection: true,
      onSelectionChanged: (Set<int> s) => last = s,
      selectionState: const M3EListSelectionState(
        selectedIcon: Icon(M3EIcons.check_circle),
      ),
      data: const <M3EExpandableData>[
        M3EExpandableData(
          title: 'Section',
          leading: Icon(M3EIcons.inbox),
          expanded: M3EExpandableExpanded.content(Text('BODY')),
        ),
      ],
    ),
  );

  expect(find.text('BODY'), findsNothing);
  await tester.tap(find.byType(M3ESelectionFlip));
  await tester.pumpAndSettle();
  expect(last, <int>{0});
  expect(find.text('BODY'), findsNothing);

  await tester.tap(find.text('Section'));
  await tester.pumpAndSettle();
  // In selection mode, title tap toggles selection (does not expand).
  expect(last, <int>{});
  expect(find.text('BODY'), findsNothing);
}

Future<void> _expandableNestedLastClosesBottom(WidgetTester tester) async {
  const double outer = 16;
  const double inner = 4;

  await _pump(
    tester,
    _dataList(
      expandStyle: const M3EExpandableStyle(),
      initiallyExpanded: const <int>{1},
      data: <M3EExpandableData>[
        const M3EExpandableData(
          title: 'First',
          expanded: M3EExpandableExpanded.content(Text('First body')),
        ),
        M3EExpandableData(
          title: 'Last parent',
          expanded: M3EExpandableExpanded.list(
            M3EList(
              embedded: true,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return M3EListItem(headline: 'Nest $index');
              },
            ),
          ),
        ),
      ],
    ),
  );

  final Finder nest0 = find.ancestor(
    of: find.text('Nest 0'),
    matching: find.byType(M3ECard),
  );
  final Finder nest1 = find.ancestor(
    of: find.text('Nest 1'),
    matching: find.byType(M3ECard),
  );

  expect(
    tester.widget<M3ECard>(nest0).borderRadius,
    BorderRadius.circular(inner),
  );
  expect(
    tester.widget<M3ECard>(nest1).borderRadius,
    const BorderRadius.vertical(
      top: Radius.circular(inner),
      bottom: Radius.circular(outer),
    ),
  );
}

Future<void> _expandableParentReorderIgnoresNested(WidgetTester tester) async {
  final parents = <String>['Parent A', 'Parent B'];
  final nested = <String>['Nest 0', 'Nest 1', 'Nest 2'];
  var parentReorderCount = 0;

  await _pump(
    tester,
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return _nestedExpandableReorderList(
          parents: parents,
          nested: nested,
          setState: setState,
          onParentReorder: () => parentReorderCount++,
        );
      },
    ),
  );

  expect(find.text('Nest 0'), findsOneWidget);

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('Nest 0').first),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
  await tester.pump();
  expect(find.text('Nest 1'), findsOneWidget);
  expect(find.text('Nest 2'), findsOneWidget);

  await gesture.moveBy(const Offset(0, 120));
  await tester.pump();
  await gesture.up();
  await tester.pumpAndSettle();

  expect(parentReorderCount, 0);
  expect(parents, <String>['Parent A', 'Parent B']);
  expect(nested.first, isNot('Nest 0'));
  expect(find.text('Nest 0'), findsOneWidget);
}

Widget _nestedExpandableReorderList({
  required List<String> parents,
  required List<String> nested,
  required StateSetter setState,
  required VoidCallback onParentReorder,
}) {
  return _dataList(
    reorder: true,
    initiallyExpanded: const <int>{0},
    onReorder: (int oldIndex, int newIndex) {
      onParentReorder();
      setState(() {
        final String item = parents.removeAt(oldIndex);
        parents.insert(newIndex, item);
      });
    },
    data: <M3EExpandableData>[
      for (int i = 0; i < parents.length; i++)
        M3EExpandableData(
          title: parents[i],
          expanded: i == 0
              ? M3EExpandableExpanded.list(
                  M3EList(
                    embedded: true,
                    reorder: true,
                    onReorder: (int oldIndex, int newIndex) {
                      setState(() {
                        final String item = nested.removeAt(oldIndex);
                        nested.insert(newIndex, item);
                      });
                    },
                    itemCount: nested.length,
                    itemBuilder: (BuildContext context, int index) {
                      return M3EListItem(headline: nested[index]);
                    },
                  ),
                )
              : const M3EExpandableExpanded.content(Text('Other body')),
        ),
    ],
  );
}

Future<void> _expandableReorderRestores(WidgetTester tester) async {
  final titles = <String>['Alpha', 'Beta', 'Gamma'];
  final bodies = <String>['Alpha body', 'Beta body', 'Gamma body'];

  await _pump(
    tester,
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return _dataList(
          reorder: true,
          initiallyExpanded: const <int>{0},
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              final String title = titles.removeAt(oldIndex);
              titles.insert(newIndex, title);
              final String body = bodies.removeAt(oldIndex);
              bodies.insert(newIndex, body);
            });
          },
          data: <M3EExpandableData>[
            for (int i = 0; i < titles.length; i++)
              M3EExpandableData(
                title: titles[i],
                subtitle: 'Section',
                expanded: M3EExpandableExpanded.content(Text(bodies[i])),
              ),
          ],
        );
      },
    ),
  );

  expect(find.text('Alpha body'), findsOneWidget);

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('Alpha')),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
  // Collapse for measure should hide body before/during drag.
  await tester.pump();
  expect(find.text('Alpha body'), findsNothing);

  await gesture.moveBy(const Offset(0, 160));
  await tester.pump();
  await gesture.up();
  await tester.pumpAndSettle();

  expect(titles.first, isNot('Alpha'));
  final int alphaAt = titles.indexOf('Alpha');
  expect(alphaAt, greaterThan(0));
  expect(find.text('Alpha body'), findsOneWidget);
  expect(bodies[alphaAt], 'Alpha body');
}

Future<void> _tapNotDelayed(WidgetTester tester) async {
  final taps = <int>[];
  await _pump(
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
  await _pump(
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
  expect(_rowColor(tester, 'Row 0'), scheme.secondaryContainer);

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
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: M3EList(
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
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _dismissibleReorder(WidgetTester tester) async {
  final items = <String>['A', 'B', 'C'];
  await _pump(
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
  await _pump(
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
