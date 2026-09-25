import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('segmented middle row rests at 4 and rounds to 16 on hover', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      M3ECardList(
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
  });

  testWidgets('baseline short rows stay centered and three-line rows start', (
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
  });

  testWidgets('arrow down reaches a trailing action before the next row', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      M3ECardList(
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
  });

  testWidgets('container transform opens from a tap and from the controller', (
    WidgetTester tester,
  ) async {
    final controller = M3EExpandableListController();
    await _pump(
      tester,
      M3EExpandableList(
        transformController: controller,
        data: const <M3EExpandableData>[
          M3EExpandableData(
            title: 'Open me',
            expanded: M3EExpandableExpanded.transform(Text('Destination')),
          ),
        ],
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
  });

  testWidgets('any list item can opt into a container transform', (
    WidgetTester tester,
  ) async {
    await _pump(
      tester,
      M3ECardList(
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

    M3ECardContainerTransformScope.closeOf(
      tester.element(find.text('From row')),
    );
    await tester.pumpAndSettle();
    expect(find.text('From row'), findsNothing);

    await _pump(
      tester,
      const M3EListItem(headline: 'Alone', transform: Text('From item')),
    );
    await tester.tap(find.text('Alone'));
    await tester.pumpAndSettle();
    expect(find.text('From item'), findsOneWidget);
  });
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
  final Finder card = find.ancestor(
    of: find.text(headline),
    matching: find.byType(M3ECard),
  );
  return tester.widget<M3ECard>(card.first).borderRadius!;
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
