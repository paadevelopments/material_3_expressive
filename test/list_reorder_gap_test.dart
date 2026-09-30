import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/lists/components/m3e_card_list_item.dart';
import 'package:material_3_expressive/components/lists/components/m3e_expandable_sublist.dart';
import 'package:material_3_expressive/components/lists/components/m3e_list_drag_proxy_scope.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/list_test_helpers.dart';

void main() {
  testWidgets(
    'dragged card proxy is the card height, not card + gap',
    _draggedProxyExcludesGap,
  );
  testWidgets(
    'dragged dismissible-item proxy is the card height, not card + gap',
    _draggedDismissibleProxyExcludesGap,
  );
  testWidgets(
    'dragged expandable-item proxy is the card height, not card + gap',
    _draggedExpandableProxyExcludesGap,
  );
  testWidgets(
    'header-to-sublist gap survives reorder support',
    _expandableSublistGapSurvivesReorder,
  );
}

Future<void> _draggedProxyExcludesGap(WidgetTester tester) async {
  final items = <String>['A', 'B'];
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
          itemBuilder: (BuildContext context, int index) =>
              M3EListItem(headline: items[index]),
        );
      },
    ),
  );

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('A')),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));

  // The floating proxy's card, identified by `M3EListDragProxyScope`.
  final Size proxySize = tester.getSize(
    find
        .ancestor(
          of: find.byType(M3EListDragProxyScope),
          matching: find.byType(PhysicalModel),
        )
        .first,
  );

  // The still-resting sibling's own card, for the same content shape.
  final Size restingSize = tester.getSize(
    find
        .ancestor(of: find.text('B'), matching: find.byType(M3ECardListItem))
        .first,
  );

  expect(
    proxySize.height,
    restingSize.height,
    reason: 'the dragged card must not carry the trailing gap as extra height',
  );

  await gesture.up();
  await tester.pumpAndSettle();
}

Future<void> _draggedDismissibleProxyExcludesGap(WidgetTester tester) async {
  final items = <String>['A', 'B'];
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
            swipe: M3EListItemSwipe(
              onDismiss: (DismissDirection direction) async => false,
            ),
          ),
        );
      },
    ),
  );

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('A')),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));

  // The floating proxy's card, identified by `M3EListDragProxyScope`.
  final Size proxySize = tester.getSize(
    find
        .ancestor(
          of: find.byType(M3EListDragProxyScope),
          matching: find.byType(PhysicalModel),
        )
        .first,
  );

  // The still-resting sibling's own card surface, for the same content shape.
  final Size restingSize = tester.getSize(
    find
        .ancestor(of: find.text('B'), matching: find.byType(M3EListRowSurface))
        .first,
  );

  expect(
    proxySize.height,
    restingSize.height,
    reason:
        'the dragged dismissible card must not carry the trailing gap as '
        'extra height',
  );

  await gesture.up();
  await tester.pumpAndSettle();
}

Future<void> _draggedExpandableProxyExcludesGap(WidgetTester tester) async {
  final titles = <String>['Alpha', 'Beta'];
  await pumpList(
    tester,
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return M3EList(
          reorder: true,
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              final String title = titles.removeAt(oldIndex);
              titles.insert(newIndex, title);
            });
          },
          itemCount: titles.length,
          itemBuilder: (BuildContext context, int index) => M3EListItem(
            headline: titles[index],
            expanded: M3EExpandableExpanded.content(
              Text('${titles[index]} body'),
            ),
          ),
        );
      },
    ),
  );

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('Alpha')),
  );
  await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));

  // The floating proxy's card, identified by `M3EListDragProxyScope`.
  final Size proxySize = tester.getSize(
    find
        .ancestor(
          of: find.byType(M3EListDragProxyScope),
          matching: find.byType(PhysicalModel),
        )
        .first,
  );

  // The still-resting sibling's own header card surface.
  final Size restingSize = tester.getSize(
    find
        .ancestor(
          of: find.text('Beta'),
          matching: find.byType(M3EListRowSurface),
        )
        .first,
  );

  expect(
    proxySize.height,
    restingSize.height,
    reason:
        'the dragged expandable header must not carry the trailing gap as '
        'extra height',
  );

  await gesture.up();
  await tester.pumpAndSettle();
}

Future<void> _expandableSublistGapSurvivesReorder(WidgetTester tester) async {
  await pumpList(
    tester,
    M3EList(
      reorder: true,
      onReorder: (int oldIndex, int newIndex) {},
      initiallyExpanded: const <int>{0},
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Parent',
          expanded: M3EExpandableExpanded.list(
            M3EList(
              embedded: true,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return const M3EListItem(headline: 'Child');
              },
            ),
          ),
        );
      },
    ),
  );

  final SizedBox gapBox = tester.widget<SizedBox>(
    find
        .descendant(
          of: find.byType(M3EExpandableSublist),
          matching: find.byType(SizedBox),
        )
        .first,
  );

  final M3EThemeData theme = M3ETheme.of(tester.element(find.text('Parent')));
  expect(gapBox.height, theme.listTheme.expandable.gap);
  expect(gapBox.height, greaterThan(0));
}
