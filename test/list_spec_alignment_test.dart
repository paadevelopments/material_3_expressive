import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets(
    'segmented middle row rests at 4 and rounds to 16 on hover',
    _segmentedMiddleRowRestsAt4AndRoundsTo16OnHover,
  );
  testWidgets(
    'expandable header rounds on hover and keeps one trailing icon',
    _expandableHeaderRoundsOnHoverAndKeepsOneTrailingIcon,
  );
  testWidgets(
    'baseline short rows stay centered and three-line rows start',
    _baselineShortRowsStayCenteredAndThreeLineRowsStart,
  );
  testWidgets(
    'arrow down reaches a trailing action before the next row',
    _arrowDownReachesATrailingActionBeforeTheNextRow,
  );
  testWidgets(
    'container transform opens from a tap and from the controller',
    _containerTransformOpensFromATapAndFromTheController,
  );
  testWidgets(
    'any list item can opt into a container transform',
    _anyListItemCanOptIntoAContainerTransform,
  );
  testWidgets(
    'one row can swipe, expand in place, and open a transform',
    _oneRowCanSwipeExpandInPlaceAndOpenATransform,
  );
  testWidgets(
    'expanded sub-list joins the parent corners and fill',
    _expandedSubListJoinsTheParentCornersAndFill,
  );
}

Future<void> _segmentedMiddleRowRestsAt4AndRoundsTo16OnHover(
  WidgetTester tester,
) async {
  await _pump(
    tester,
    M3EList(
      itemCount: 3,
      onTap: (int index) {},
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(headline: 'Row $index');
      },
    ),
  );

  expect(_radius(tester, 'Row 1').topLeft.x, 4);

  final TestGesture hover = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await hover.addPointer(location: Offset.zero);
  addTearDown(hover.removePointer);
  await tester.pump();
  await hover.moveTo(tester.getCenter(find.text('Row 1')));
  await tester.pump();

  expect(_radius(tester, 'Row 1').topLeft.x, 16);
}

Future<void> _expandableHeaderRoundsOnHoverAndKeepsOneTrailingIcon(
  WidgetTester tester,
) async {
  await _pump(
    tester,
    M3EList(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Row $index',
          trailing: const Icon(M3EIcons.star),
          expanded: const M3EExpandableExpanded.content(Text('Body')),
        );
      },
    ),
  );

  expect(find.byIcon(M3EIcons.star), findsNothing);
  expect(find.byIcon(M3EIcons.expand_more_rounded), findsNWidgets(3));
  final RenderBox pill = tester.renderObject<RenderBox>(
    find
        .ancestor(
          of: find.byIcon(M3EIcons.expand_more_rounded).at(1),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  expect(pill.size, const Size(32, 40));
  expect(_radius(tester, 'Row 1').topLeft.x, 4);

  final TestGesture hover = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  await hover.addPointer(location: Offset.zero);
  addTearDown(hover.removePointer);
  await tester.pump();
  await hover.moveTo(tester.getCenter(find.text('Row 1')));
  await tester.pump();

  final BorderRadius hovered = _radius(tester, 'Row 1');
  expect(hovered.topLeft.x, 16);
  expect(hovered.bottomLeft.x, 16);
}

Future<void> _baselineShortRowsStayCenteredAndThreeLineRowsStart(
  WidgetTester tester,
) async {
  await _pump(
    tester,
    const Column(
      children: <Widget>[
        M3EListItem(
          appearance: M3EListAppearance.baseline,
          headline: 'Short',
          supportingText: 'Second line',
          leading: Icon(M3EIcons.inbox),
        ),
        M3EListItem(
          appearance: M3EListAppearance.baseline,
          overline: 'Over',
          headline: 'Tall',
          supportingText: 'Third line',
          leading: Icon(M3EIcons.inbox),
        ),
      ],
    ),
  );

  expect(_row(tester, 'Short').crossAxisAlignment, CrossAxisAlignment.center);
  expect(_row(tester, 'Tall').crossAxisAlignment, CrossAxisAlignment.start);
}

Future<void> _arrowDownReachesATrailingActionBeforeTheNextRow(
  WidgetTester tester,
) async {
  await _pump(
    tester,
    M3EList(
      itemCount: 2,
      onTap: (int index) {},
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Row $index',
          trailing: M3EListKeyTarget(
            index: index,
            child: Text('action-$index'),
          ),
        );
      },
    ),
  );

  await tester.tap(find.text('Row 0'));
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();

  expect(_focusContains('action-0'), isTrue);

  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();
  expect(_focusContains('Row 1'), isTrue);
}

Future<void> _containerTransformOpensFromATapAndFromTheController(
  WidgetTester tester,
) async {
  final controller = M3EExpandableListController();
  await _pump(
    tester,
    M3EList(
      expandController: controller,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return const M3EListItem(
          headline: 'Open me',
          expanded: M3EExpandableExpanded.transform(Text('Destination')),
        );
      },
    ),
  );

  await tester.tap(find.text('Open me'));
  await tester.pumpAndSettle();
  expect(find.text('Destination'), findsOneWidget);

  M3ECardContainerTransformScope.closeOf(
    tester.element(find.text('Destination')),
  );
  await tester.pumpAndSettle();
  expect(find.text('Destination'), findsNothing);

  controller.open(0);
  await tester.pump();
  await tester.pumpAndSettle();
  expect(find.text('Destination'), findsOneWidget);
}

Future<void> _anyListItemCanOptIntoAContainerTransform(
  WidgetTester tester,
) async {
  await _pump(
    tester,
    M3EList(
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Row $index',
          transform: index == 0 ? const Text('From row') : null,
        );
      },
    ),
  );

  await tester.tap(find.text('Row 1'));
  await tester.pumpAndSettle();
  expect(find.text('From row'), findsNothing);

  await tester.tap(find.text('Row 0'));
  await tester.pumpAndSettle();
  expect(find.text('From row'), findsOneWidget);

  M3ECardContainerTransformScope.closeOf(tester.element(find.text('From row')));
  await tester.pumpAndSettle();
  expect(find.text('From row'), findsNothing);

  await _pump(
    tester,
    const M3EListItem(headline: 'Alone', transform: Text('From item')),
  );
  await tester.tap(find.text('Alone'));
  await tester.pumpAndSettle();
  expect(find.text('From item'), findsOneWidget);
}

Future<void> _oneRowCanSwipeExpandInPlaceAndOpenATransform(
  WidgetTester tester,
) async {
  final dismiss = M3EDismissibleListController();
  final expand = M3EExpandableListController();
  await _pump(
    tester,
    M3EList(
      dismissController: dismiss,
      expandController: expand,
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Mix',
          swipe: M3EListItemSwipe(
            trailing: <M3EListSwipeAction>[
              M3EListSwipeAction(
                icon: const Icon(M3EIcons.archive),
                width: 56,
                onPressed: () {},
              ),
            ],
          ),
          expanded: const M3EExpandableExpanded.content(Text('In place')),
          transform: const Text('Morphed'),
        );
      },
    ),
  );

  final TestGesture gesture = await tester.startGesture(
    tester.getCenter(find.text('Mix')),
  );
  await gesture.moveBy(const Offset(-120, 0));
  await tester.pump();
  await gesture.up();
  await tester.pumpAndSettle();
  expect(find.byIcon(M3EIcons.archive), findsOneWidget);

  dismiss.close();
  await tester.pumpAndSettle();
  await tester.tap(find.text('Mix'));
  await tester.pumpAndSettle();
  expect(find.text('In place'), findsOneWidget);

  expand.open(0);
  await tester.pumpAndSettle();
  expect(find.text('Morphed'), findsOneWidget);
  M3ECardContainerTransformScope.closeOf(tester.element(find.text('Morphed')));
  await tester.pumpAndSettle();
}

Future<void> _expandedSubListJoinsTheParentCornersAndFill(
  WidgetTester tester,
) async {
  const fill = Color(0xFF112233);
  await _pump(
    tester,
    M3EList(
      color: fill,
      // Keep the rest fill when expanded so the sublist inherits [fill].
      expandStyle: const M3EExpandableStyle(expandedStateFill: false),
      initiallyExpanded: const <int>{0},
      itemCount: 1,
      itemBuilder: (BuildContext context, int index) {
        return const M3EListItem(
          headline: 'Parent',
          expanded: M3EExpandableExpanded.list(
            M3EList(itemCount: 2, itemBuilder: _nestItem),
          ),
        );
      },
    ),
  );

  final M3ECard first = _card(tester, 'Nest 0');
  final M3ECard last = _card(tester, 'Nest 1');
  expect(first.borderRadius, BorderRadius.circular(4));
  expect(
    last.borderRadius,
    const BorderRadius.vertical(
      top: Radius.circular(4),
      bottom: Radius.circular(16),
    ),
  );
  expect(first.color, fill);
  expect(last.color, fill);
}

Widget _nestItem(BuildContext context, int index) {
  return M3EListItem(headline: 'Nest $index');
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

BorderRadius _radius(WidgetTester tester, String headline) {
  return _card(tester, headline).borderRadius!;
}

M3ECard _card(WidgetTester tester, String headline) {
  final Finder card = find.ancestor(
    of: find.text(headline),
    matching: find.byType(M3ECard),
  );
  return tester.widget<M3ECard>(card.first);
}

Row _row(WidgetTester tester, String headline) {
  final Finder row = find.ancestor(
    of: find.text(headline),
    matching: find.byType(Row),
  );
  return tester.widget<Row>(row.first);
}

bool _focusContains(String label) {
  final start = FocusManager.instance.primaryFocus?.context as Element?;
  if (start == null) {
    return false;
  }
  var found = false;
  void visit(Element element) {
    final Widget widget = element.widget;
    if (widget is Text && widget.data == label) {
      found = true;
    }
    element.visitChildren(visit);
  }

  visit(start);
  return found;
}
