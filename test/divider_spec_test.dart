import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(body: Center(child: child)),
  );
}

EdgeInsets _padding(WidgetTester tester) {
  final padding = tester.widget<Padding>(
    find.descendant(
      of: find.byType(M3EDivider),
      matching: find.byType(Padding),
    ),
  );
  return padding.padding.resolve(TextDirection.ltr);
}

void main() {
  test('theme defaults match the divider spec', () {
    const theme = M3EDividerTheme.defaults;
    final scheme = M3EThemeData.light(seedColor: const Color(0xFF6750A4))
        .colorScheme;

    expect(theme.thickness, 1);
    expect(theme.insetStart, 16);
    expect(theme.insetEnd, 0);
    expect(theme.middleInsetStart, 16);
    expect(theme.middleInsetEnd, 16);
    expect(theme.textGap, 4);
    expect(theme.endMargin, 8);
    expect(theme.bottomMargin, 8);
    expect(theme.color(scheme), scheme.outlineVariant);
    expect(theme.startFor(M3EDividerInset.full), 0);
    expect(theme.endFor(M3EDividerInset.inset), 0);
    expect(theme.startFor(M3EDividerInset.middle), 16);
  });

  testWidgets('default line is 1dp, full-bleed, and outline variant', (
    tester,
  ) async {
    final scheme = M3EThemeData.light(seedColor: const Color(0xFF6750A4))
        .colorScheme;
    await tester.pumpWidget(
      _host(const SizedBox(width: 200, child: M3EDivider())),
    );

    final line = tester.widget<SizedBox>(
      find.descendant(
        of: find.byType(M3EDivider),
        matching: find.byType(SizedBox),
      ),
    );
    expect(line.height, 1);
    expect(tester.getSize(find.byType(M3EDivider)), const Size(200, 1));
    expect(_padding(tester), EdgeInsets.zero);
    expect(
      tester
          .widget<ColoredBox>(
            find.descendant(
              of: find.byType(M3EDivider),
              matching: find.byType(ColoredBox),
            ),
          )
          .color,
      scheme.outlineVariant,
    );
    expect(
      find.descendant(
        of: find.byType(M3EDivider),
        matching: find.byType(ExcludeSemantics),
      ),
      findsOneWidget,
    );
  });

  testWidgets('inset is 16 leading and middle is 16 on both sides', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 200,
          child: M3EDivider(inset: M3EDividerInset.inset),
        ),
      ),
    );
    expect(_padding(tester), const EdgeInsets.only(left: 16));

    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 200,
          child: M3EDivider(inset: M3EDividerInset.middle),
        ),
      ),
    );
    expect(_padding(tester), const EdgeInsets.only(left: 16, right: 16));
  });

  testWidgets('outer margin is off until enabled', (tester) async {
    await tester.pumpWidget(
      _host(const SizedBox(width: 200, child: M3EDivider())),
    );
    expect(_padding(tester).bottom, 0);
    expect(_padding(tester).right, 0);

    await tester.pumpWidget(
      _host(const SizedBox(width: 200, child: M3EDivider(outerMargin: true))),
    );
    expect(_padding(tester), const EdgeInsets.only(right: 8, bottom: 8));
  });

  testWidgets('vertical line is 1dp wide and fills a bounded height', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          height: 48,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[M3EDivider(axis: M3EDividerAxis.vertical)],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(M3EDivider)), const Size(1, 48));
  });
}
