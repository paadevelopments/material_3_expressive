import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  testWidgets('list is a single Tab stop', _singleTabStop);
  testWidgets('Tab re-enters on the last-focused row', _reentersLastFocused);
  testWidgets(
    'arrows walk sublist rows; Tab leaves from a sublist row',
    _sublist,
  );
  testWidgets(
    'expandable content headers share one Tab stop and arrows stay inside',
    _expandableContentHeaders,
  );
  testWidgets(
    'selection icon is an arrow-reachable action, not a Tab stop',
    _selectionIconAction,
  );
  testWidgets(
    'arrows enter a sublist while it is still expanding',
    _sublistWhileExpanding,
  );
  testWidgets(
    'dismissible rows without a tap are focusable and reveal on Enter',
    _dismissibleDefaultTap,
  );
}

Future<void> _sublistWhileExpanding(WidgetTester tester) async {
  await _pump(
    tester,
    M3EList(
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Row $index',
        expanded: M3EExpandableExpanded.list(
          M3EList(
            embedded: true,
            onTap: (_) {},
            itemCount: 2,
            itemBuilder: (BuildContext context, int child) =>
                M3EListItem(headline: 'Nest $index.$child'),
          ),
        ),
      ),
    ),
  );

  await _press(tester, LogicalKeyboardKey.tab);
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'Row 0');

  // Expand from the keyboard, then arrow before the spring settles.
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump(const Duration(milliseconds: 48));
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();
  expect(_focused(), 'Nest 0.0');
  await tester.pumpAndSettle();

  // Collapsing takes the sublist out of the arrow order right away.
  await _press(tester, LogicalKeyboardKey.arrowUp);
  expect(_focused(), 'Row 0');
  await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  await tester.pump(const Duration(milliseconds: 48));
  await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
  await tester.pump();
  expect(_focused(), 'Row 1');
  await tester.pumpAndSettle();
}

Future<void> _dismissibleDefaultTap(WidgetTester tester) async {
  await _pump(
    tester,
    M3EList(
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Row $index',
        trailing: index == 0 ? const Icon(M3EIcons.star) : null,
        swipe: M3EListItemSwipe(
          onDismiss: (DismissDirection direction) async => false,
          trailing: index == 0
              ? const <M3EListSwipeAction>[
                  M3EListSwipeAction(icon: Icon(M3EIcons.archive), width: 56),
                ]
              : const <M3EListSwipeAction>[],
        ),
      ),
    ),
  );

  await _press(tester, LogicalKeyboardKey.tab);
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'Row 0', reason: 'row is focusable without onTap');

  await _press(tester, LogicalKeyboardKey.enter);
  expect(find.byIcon(M3EIcons.archive), findsOneWidget);
  await _press(tester, LogicalKeyboardKey.enter);
  expect(find.byIcon(M3EIcons.archive), findsNothing);

  await _press(tester, LogicalKeyboardKey.arrowDown);
  expect(_focused(), 'Row 1', reason: 'a row without actions is focusable');
  await _press(tester, LogicalKeyboardKey.enter);
  expect(_focused(), 'Row 1');
}

Future<void> _pump(WidgetTester tester, Widget list) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              M3EButton(onPressed: () {}, child: const Text('Before')),
              list,
              M3EButton(onPressed: () {}, child: const Text('After')),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _press(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pumpAndSettle();
}

Future<void> _shiftTab(WidgetTester tester) async {
  await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
  await tester.pumpAndSettle();
}

/// Texts painted inside the primary focus node's own `Focus` widget.
List<String> _focusedTexts() {
  final FocusNode? node = FocusManager.instance.primaryFocus;
  final texts = <String>[];
  for (final Element element in find.byType(Text).evaluate()) {
    var inside = false;
    element.visitAncestorElements((Element ancestor) {
      final Widget widget = ancestor.widget;
      if (widget is Focus && widget.focusNode == node) {
        inside = true;
        return false;
      }
      return true;
    });
    if (inside) {
      texts.add((element.widget as Text).data ?? '');
    }
  }
  return texts;
}

String _focused() {
  final List<String> texts = _focusedTexts();
  return texts.isEmpty ? '' : texts.first;
}

M3EList _rows({int count = 3}) => M3EList(
  itemCount: count,
  onTap: (_) {},
  itemBuilder: (BuildContext context, int index) =>
      M3EListItem(headline: 'Row $index'),
);

Future<void> _singleTabStop(WidgetTester tester) async {
  await _pump(tester, _rows());

  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'Before');
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'Row 0');
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'After', reason: 'Tab leaves the list from any row');

  await _shiftTab(tester);
  expect(_focused(), 'Row 0');
  await _shiftTab(tester);
  expect(_focused(), 'Before', reason: 'Shift+Tab leaves the list');
}

Future<void> _reentersLastFocused(WidgetTester tester) async {
  await _pump(tester, _rows());

  await _press(tester, LogicalKeyboardKey.tab);
  await _press(tester, LogicalKeyboardKey.tab);
  await _press(tester, LogicalKeyboardKey.arrowDown);
  expect(_focused(), 'Row 1');
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'After');

  await _shiftTab(tester);
  expect(_focused(), 'Row 1');
}

Future<void> _sublist(WidgetTester tester) async {
  await _pump(
    tester,
    M3EList(
      itemCount: 2,
      onTap: (_) {},
      initiallyExpanded: const <int>{0},
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Row $index',
        expanded: M3EExpandableExpanded.list(
          M3EList(
            embedded: true,
            onTap: (_) {},
            itemCount: 2,
            itemBuilder: (BuildContext context, int child) =>
                M3EListItem(headline: 'Nest $index.$child'),
          ),
        ),
      ),
    ),
  );

  await _press(tester, LogicalKeyboardKey.tab);
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'Row 0');
  await _press(tester, LogicalKeyboardKey.arrowDown);
  expect(_focused(), 'Nest 0.0');
  await _press(tester, LogicalKeyboardKey.arrowDown);
  expect(_focused(), 'Nest 0.1');
  await _press(tester, LogicalKeyboardKey.arrowDown);
  expect(_focused(), 'Row 1');
  await _press(tester, LogicalKeyboardKey.arrowUp);
  expect(_focused(), 'Nest 0.1');

  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'After', reason: 'Tab leaves from a sublist row');
  await _shiftTab(tester);
  expect(_focused(), 'Nest 0.1');
}

Future<void> _expandableContentHeaders(WidgetTester tester) async {
  await _pump(
    tester,
    M3EList(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Row $index',
        expanded: M3EExpandableExpanded.content(Text('Body $index')),
      ),
    ),
  );

  await _press(tester, LogicalKeyboardKey.tab);
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'Row 0');
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'After', reason: 'headers are not separate Tab stops');

  await _shiftTab(tester);
  expect(_focused(), 'Row 0');
  await _press(tester, LogicalKeyboardKey.arrowUp);
  expect(_focused(), 'Row 2', reason: 'arrows wrap inside the list');
  await _press(tester, LogicalKeyboardKey.arrowDown);
  expect(_focused(), 'Row 0');

  await _press(tester, LogicalKeyboardKey.enter);
  expect(find.text('Body 0').hitTestable(), findsOneWidget);
}

Future<void> _selectionIconAction(WidgetTester tester) async {
  Set<int>? selected;
  await _pump(
    tester,
    M3EList(
      itemCount: 2,
      selection: true,
      onTap: (_) {},
      // Default trigger is the leading icon.
      onSelectionChanged: (Set<int> value) => selected = value,
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Row $index',
        leading: const Icon(M3EIcons.folder),
      ),
    ),
  );

  await _press(tester, LogicalKeyboardKey.tab);
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'Row 0');
  await _press(tester, LogicalKeyboardKey.tab);
  expect(_focused(), 'After', reason: 'the icon is not a Tab stop');

  await _shiftTab(tester);
  await _press(tester, LogicalKeyboardKey.arrowDown);
  expect(
    FocusManager.instance.primaryFocus?.debugLabel,
    'list 0.1',
    reason: 'arrow reaches the leading selection action',
  );
  await _press(tester, LogicalKeyboardKey.space);
  expect(selected, <int>{0});
  await _press(tester, LogicalKeyboardKey.arrowDown);
  expect(_focused(), 'Row 1');
}
