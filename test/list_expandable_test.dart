import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/list_test_helpers.dart';

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
}

Future<void> _expandableSublist(WidgetTester tester) async {
  await pumpList(
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
  await pumpList(
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
  expect(rowColor(tester, 'Section 1'), scheme.secondaryContainer);

  // Selection mode: header tap toggles selection (does not collapse).
  await tester.tap(find.text('Section 0'));
  await tester.pumpAndSettle();
  expect(last, <int>{0});
  expect(find.text('Nested only'), findsOneWidget);
}

Future<void> _expandableLeadingSelectDoesNotExpand(WidgetTester tester) async {
  Set<int>? last;
  await pumpList(
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

  await pumpList(
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

Future<void> _expandableParentReorderIgnoresNested(WidgetTester tester) async {
  final parents = <String>['Parent A', 'Parent B'];
  final nested = <String>['Nest 0', 'Nest 1', 'Nest 2'];
  var parentReorderCount = 0;

  await pumpList(
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

Future<void> _expandableReorderRestores(WidgetTester tester) async {
  final titles = <String>['Alpha', 'Beta', 'Gamma'];
  final bodies = <String>['Alpha body', 'Beta body', 'Gamma body'];

  await pumpList(
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
