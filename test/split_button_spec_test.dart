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
  test('pressed inner radii match hovered', () {
    const theme = M3ESplitButtonTheme.defaults;
    const sizes = <M3EButtonSize>[
      M3EButtonSize.xs,
      M3EButtonSize.sm,
      M3EButtonSize.md,
      M3EButtonSize.lg,
      M3EButtonSize.xl,
    ];
    for (final size in sizes) {
      expect(
        theme.splitPressedRadius(size),
        theme.splitHoveredInnerCornerRadius(size),
        reason: size.name,
      );
    }
  });

  test('gap is always 2dp including elevated', () {
    const theme = M3ESplitButtonTheme.defaults;
    expect(theme.innerGap, 2);
    expect(theme.elevatedInnerGap, 2);
  });

  test('small leading icon is 20dp', () {
    const theme = M3ESplitButtonTheme.defaults;
    expect(theme.splitIcon(M3EButtonSize.sm), 20);
    expect(theme.splitLeadingIconBlockWidth(M3EButtonSize.sm), 20);
  });

  test('optical vs centered trailing pads', () {
    const theme = M3ESplitButtonTheme.defaults;
    expect(theme.splitTrailingOpticalLeading(M3EButtonSize.xs), 12);
    expect(theme.splitTrailingOpticalTrailing(M3EButtonSize.xs), 14);
    expect(theme.splitTrailingOpticalLeading(M3EButtonSize.md), 13);
    expect(theme.splitTrailingOpticalTrailing(M3EButtonSize.md), 17);
    expect(theme.splitTrailingButtonLeadingSpace(M3EButtonSize.md), 15);
    expect(theme.splitTrailingButtonTrailingSpace(M3EButtonSize.md), 15);
    expect(theme.splitSidePaddingSelected(M3EButtonSize.xl), 43);
    expect(theme.splitMenuIconOffset(M3EButtonSize.xl), -6);
  });

  test('chevron open turns is 180 degrees', () {
    expect(M3ESplitButtonTheme.defaults.chevronOpenTurns, 0.5);
  });

  testWidgets('xs layout height meets 48dp tap target', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        M3ESplitButton<String>(
          size: M3EButtonSize.xs,
          label: 'Edit',
          onPressed: () {},
          onSelected: (_) {},
          items: const <M3ESplitButtonItem<String>>[
            M3ESplitButtonItem(value: 'a', child: Text('A')),
            M3ESplitButtonItem(value: 'b', child: Text('B')),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final Size size = tester.getSize(find.byType(M3ESplitButton<String>));
    expect(size.height, greaterThanOrEqualTo(48));
  });

  testWidgets('trailing semantics expose More options', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _host(
        M3ESplitButton<String>(
          label: 'Save',
          onPressed: () {},
          onSelected: (_) {},
          items: const <M3ESplitButtonItem<String>>[
            M3ESplitButtonItem(value: 'a', child: Text('A')),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('More options'), findsOneWidget);
  });

  testWidgets('system back closes the popup menu before the route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return M3ETheme(
              data: M3EThemeData.light(),
              child: Scaffold(
                body: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return M3ETheme(
                            data: M3EThemeData.light(),
                            child: Scaffold(
                              body: Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  height: 48,
                                  child: M3ESplitButton<String>(
                                    label: 'Save',
                                    onPressed: () {},
                                    onSelected: (_) {},
                                    items: const <M3ESplitButtonItem<String>>[
                                      M3ESplitButtonItem(
                                        value: 'a',
                                        child: Text('Archive'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: const Text('Root'),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('Root'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(M3EIcons.keyboard_arrow_down));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(find.byType(M3EMenuPopup<String>), findsOneWidget);
    expect(find.text('Archive'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 50));

    expect(find.byType(M3EMenuPopup<String>), findsNothing);
    expect(find.text('Save'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Save'), findsNothing);
    expect(find.text('Root'), findsOneWidget);
  });
}
