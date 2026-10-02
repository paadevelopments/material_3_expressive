import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

final List<M3EExpandableData> _items = <M3EExpandableData>[
  const M3EExpandableData(
    title: 'Battery level low',
    subtitle: 'Plug in your device.',
    expanded: M3EExpandableExpanded.content(Text('Your battery is at 10%.')),
  ),
  const M3EExpandableData(
    title: 'System update available',
    subtitle: 'Version 2.4.0 is ready.',
    expanded: M3EExpandableExpanded.content(
      Text('This update includes security fixes.'),
    ),
  ),
];

M3EList _dataList({
  required List<M3EExpandableData> data,
  bool selection = false,
  M3EListSelectionState? selectionState,
  ValueChanged<Set<int>>? onSelectionChanged,
  bool? allowMultipleExpanded,
  Set<int> initiallyExpanded = const <int>{},
  void Function(int index, {required bool isExpanded})? onExpansionChanged,
}) {
  return M3EList(
    itemCount: data.length,
    selection: selection,
    selectionState: selectionState,
    onSelectionChanged: onSelectionChanged,
    allowMultipleExpanded: allowMultipleExpanded,
    initiallyExpanded: initiallyExpanded,
    onExpansionChanged: onExpansionChanged,
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

bool _focusInNestedList() {
  var found = false;
  primaryFocus?.context?.visitAncestorElements((Element element) {
    if (element.widget.key == const Key('nested-list')) {
      found = true;
    }
    return !found;
  });
  return found;
}

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(),
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Center(child: SizedBox(width: 400, child: child)),
      ),
    ),
  );
}

Widget _expandedSublistForTabTraversal(List<String> taps) {
  return _dataList(
    initiallyExpanded: const <int>{0},
    data: <M3EExpandableData>[
      M3EExpandableData(
        title: 'Parent',
        subtitle: 'Has nested rows',
        expanded: M3EExpandableExpanded.list(
          M3EList(
            key: const Key('nested-list'),
            embedded: true,
            itemCount: 2,
            onTap: (int index) => taps.add('nested-$index'),
            itemBuilder: (BuildContext context, int index) {
              return M3EListItem(headline: 'Nested $index');
            },
          ),
        ),
      ),
      const M3EExpandableData(
        title: 'Next parent',
        subtitle: 'After sublist',
        expanded: M3EExpandableExpanded.content(Text('Body')),
      ),
    ],
  );
}

Future<void> _pumpExpandedSublistForTabTraversal(
  WidgetTester tester,
  List<String> taps,
) async {
  await tester.pumpWidget(_host(_expandedSublistForTabTraversal(taps)));
  await tester.pumpAndSettle();
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
}

void main() {
  registerExpandableListRendersTitlesTests();
  registerExpandableListExpandsAndReportsTests();
  registerExpandableListSingleExpandTests();
  registerExpandableSublistTabTraversalTests();
  registerExpandableSublistSelectionPersistenceTests();
  registerExpandableSelectionTrailingExpandTests();
}

void registerExpandableListRendersTitlesTests() {
  testWidgets('M3EExpandableList renders item titles', (tester) async {
    await tester.pumpWidget(_host(_dataList(data: _items)));

    expect(find.text('Battery level low'), findsOneWidget);
    expect(find.text('System update available'), findsOneWidget);
  });
}

void registerExpandableListExpandsAndReportsTests() {
  testWidgets('M3EExpandableList expands item and reports change', (
    tester,
  ) async {
    int? changedIndex;
    bool? changedExpanded;

    await tester.pumpWidget(
      _host(
        _dataList(
          data: _items,
          onExpansionChanged: (int index, {required bool isExpanded}) {
            changedIndex = index;
            changedExpanded = isExpanded;
          },
        ),
      ),
    );

    await tester.tap(find.text('Battery level low'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(changedIndex, 0);
    expect(changedExpanded, isTrue);
    expect(find.text('Your battery is at 10%.'), findsOneWidget);
  });
}

void registerExpandableListSingleExpandTests() {
  testWidgets('M3EExpandableList single-expand collapses prior item', (
    tester,
  ) async {
    final expandedEvents = <int>[];

    await tester.pumpWidget(
      _host(
        _dataList(
          data: _items,
          allowMultipleExpanded: false,
          onExpansionChanged: (int index, {required bool isExpanded}) {
            if (isExpanded) {
              expandedEvents.add(index);
            }
          },
        ),
      ),
    );

    await tester.tap(find.text('Battery level low'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(expandedEvents, <int>[0]);

    await tester.tap(find.text('System update available'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(expandedEvents, <int>[0, 1]);
    expect(find.text('This update includes security fixes.'), findsOneWidget);
  });
}

void registerExpandableSublistTabTraversalTests() {
  testWidgets('expanded sublist rows are reached by arrows, not Tab', (
    WidgetTester tester,
  ) async {
    final taps = <String>[];
    await _pumpExpandedSublistForTabTraversal(tester, taps);

    expect(find.text('Nested 0'), findsOneWidget);
    expect(find.text('Nested 1'), findsOneWidget);

    // The list is one Tab stop: Tab lands on the header and never on a
    // nested row.
    expect(primaryFocus?.nextFocus(), isTrue);
    await tester.pumpAndSettle();
    expect(_focusInNestedList(), isFalse);
    final FocusNode? header = primaryFocus;

    // Nothing else on screen takes focus, so Tab has nowhere to go.
    primaryFocus?.nextFocus();
    await tester.pumpAndSettle();
    expect(_focusInNestedList(), isFalse);

    // Back on the header, arrows step into the sublist.
    header!.requestFocus();
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(_focusInNestedList(), isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, <String>['nested-0']);
  });

  testWidgets('arrow keys walk an expanded sublist between headers', (
    WidgetTester tester,
  ) async {
    final taps = <String>[];
    await _pumpExpandedSublistForTabTraversal(tester, taps);

    expect(primaryFocus?.nextFocus(), isTrue);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, <String>['nested-0']);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, <String>['nested-0', 'nested-1']);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(_focusInNestedList(), isFalse);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, <String>['nested-0', 'nested-1', 'nested-1']);
  });
}

void registerExpandableSublistSelectionPersistenceTests() {
  testWidgets('nested selection survives collapse and re-expand', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        _dataList(
          initiallyExpanded: const <int>{0},
          data: <M3EExpandableData>[
            M3EExpandableData(
              title: 'Parent',
              expanded: M3EExpandableExpanded.list(
                M3EList(
                  embedded: true,
                  selection: true,
                  selectionState: const M3EListSelectionState(
                    selectedIcon: Icon(M3EIcons.check_circle),
                  ),
                  itemCount: 2,
                  itemBuilder: (BuildContext context, int index) {
                    return M3EListItem(
                      headline: 'Child $index',
                      leading: const Icon(M3EIcons.star_outline),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(M3ESelectionFlip).first);
    await tester.pumpAndSettle();
    expect(
      tester
          .widgetList<M3ESelectionFlip>(find.byType(M3ESelectionFlip))
          .first
          .selected,
      isTrue,
    );

    // Collapse then re-expand — owned FeatureHost must stay mounted.
    await tester.tap(find.text('Parent'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Parent'));
    await tester.pumpAndSettle();

    expect(find.text('Child 0'), findsOneWidget);
    expect(
      tester
          .widgetList<M3ESelectionFlip>(find.byType(M3ESelectionFlip))
          .first
          .selected,
      isTrue,
    );
  });
}

void registerExpandableSelectionTrailingExpandTests() {
  testWidgets('selection on: trailing icon expands when not selecting', (
    WidgetTester tester,
  ) async {
    Set<int>? last;
    await tester.pumpWidget(
      _host(
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
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(M3EIcons.expand_more_rounded));
    await tester.pumpAndSettle();
    expect(find.text('BODY'), findsOneWidget);
    expect(last, isNull);
  });
}
