import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) => MaterialApp(
  home: M3ETheme(
    data: M3EThemeData.light(),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  testWidgets('density shrinks visual height and keeps ≥48 layout', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        M3ESegmentedButton<int>(
          density: M3ESegmentedButtonDensity.dense,
          selected: const <int>{0},
          onSelectionChanged: (_) {},
          segments: const <M3ESegment<int>>[
            M3ESegment<int>(value: 0, label: 'A'),
            M3ESegment<int>(value: 1, label: 'B'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Size size = tester.getSize(find.byType(M3ESegmentedButton<int>));
    expect(size.height, 48);
  });

  testWidgets('single-select cannot clear the selected segment', (
    WidgetTester tester,
  ) async {
    var selected = <int>{0};

    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) {
            return M3ESegmentedButton<int>(
              selected: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              segments: const <M3ESegment<int>>[
                M3ESegment<int>(value: 0, label: 'Day'),
                M3ESegment<int>(value: 1, label: 'Week'),
                M3ESegment<int>(value: 2, label: 'Month'),
              ],
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Day').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, <int>{0});

    await tester.tap(find.text('Week').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, <int>{1});
  });

  testWidgets('multi-select toggles and allows empty', (
    WidgetTester tester,
  ) async {
    var selected = <int>{0};

    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) {
            return M3ESegmentedButton<int>(
              multiSelect: true,
              selected: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              segments: const <M3ESegment<int>>[
                M3ESegment<int>(value: 0, label: 'A'),
                M3ESegment<int>(value: 1, label: 'B'),
              ],
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('B').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, <int>{0, 1});

    await tester.tap(find.text('A').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, <int>{1});

    await tester.tap(find.text('B').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, isEmpty);
  });

  testWidgets('disabled segment does not change selection', (
    WidgetTester tester,
  ) async {
    var selected = <int>{0};

    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) {
            return M3ESegmentedButton<int>(
              selected: selected,
              onSelectionChanged: (next) => setState(() => selected = next),
              segments: const <M3ESegment<int>>[
                M3ESegment<int>(value: 0, label: 'On'),
                M3ESegment<int>(value: 1, label: 'Off', enabled: false),
              ],
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Off').hitTestable().first);
    await tester.pumpAndSettle();
    expect(selected, <int>{0});
  });

  testWidgets('icon-only selected shows check instead of category icon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        M3ESegmentedButton<int>(
          selected: const <int>{0},
          onSelectionChanged: (_) {},
          segments: const <M3ESegment<int>>[
            M3ESegment<int>(
              value: 0,
              icon: Icon(M3EIcons.home),
              semanticLabel: 'Home',
            ),
            M3ESegment<int>(
              value: 1,
              icon: Icon(M3EIcons.star),
              semanticLabel: 'Star',
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(M3EIcons.check), findsOneWidget);
    expect(find.byIcon(M3EIcons.home), findsNothing);
    expect(find.byIcon(M3EIcons.star), findsOneWidget);
  });

  test('theme density heights match spec', () {
    const theme = M3ESegmentedButtonTheme.defaults;
    expect(theme.heightFor(M3ESegmentedButtonDensity.regular), 40);
    expect(theme.heightFor(M3ESegmentedButtonDensity.comfortable), 36);
    expect(theme.heightFor(M3ESegmentedButtonDensity.compact), 32);
    expect(theme.heightFor(M3ESegmentedButtonDensity.dense), 28);
    expect(theme.focusIndicatorWidth, 3);
    expect(theme.focusIndicatorGap, 2);
    expect(theme.targetSize, 48);
  });

  test('segment count assert rejects fewer than 2', () {
    expect(
      () => M3ESegmentedButton<int>(
        selected: const <int>{},
        onSelectionChanged: (_) {},
        segments: const <M3ESegment<int>>[
          M3ESegment<int>(value: 0, label: 'A'),
        ],
      ),
      throwsAssertionError,
    );
  });
}
