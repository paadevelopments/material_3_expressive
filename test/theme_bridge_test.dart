import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Captures the resolved [M3EThemeData] beneath [app].
Future<M3EThemeData> _resolve(WidgetTester tester, Widget app) async {
  await tester.pumpWidget(app);
  return M3ETheme.of(tester.element(find.byType(SizedBox)));
}

Widget _capture(ThemeData theme, {M3EThemeData? tokens}) {
  const probe = SizedBox.shrink();
  return MaterialApp(
    theme: theme,
    home: tokens == null
        ? probe
        : M3ETheme(data: tokens, child: probe),
  );
}

void main() {
  testWidgets('M3ETheme.of derives from the ambient Material theme',
      (tester) async {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF00695C));
    final resolved = await _resolve(
      tester,
      _capture(ThemeData(colorScheme: scheme, useMaterial3: true)),
    );
    expect(resolved.colorScheme.primary, scheme.primary);
    expect(resolved.colorScheme.surface, scheme.surface);
  });

  testWidgets('an explicit M3ETheme overrides the ambient Material theme',
      (tester) async {
    final tokens = M3EThemeData.light(seedColor: const Color(0xFFB3261E));
    final resolved = await _resolve(
      tester,
      _capture(
        ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00695C)),
        ),
        tokens: tokens,
      ),
    );
    expect(resolved.colorScheme.primary, tokens.colorScheme.primary);
  });

  test('toThemeData projects the expressive tokens onto Material', () {
    final tokens = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    final material = tokens.toThemeData();
    expect(material.useMaterial3, isTrue);
    expect(material.colorScheme.primary, tokens.colorScheme.primary);
    expect(
      material.textTheme.labelLarge?.fontSize,
      tokens.typeScale.labelLarge.fontSize,
    );
  });

  testWidgets('M3ETheme.of is stable across rebuilds under a Material theme',
      (tester) async {
    final first = await _resolve(tester, _capture(ThemeData()));
    tester.element(find.byType(SizedBox)).markNeedsBuild();
    await tester.pump();
    final second = M3ETheme.of(tester.element(find.byType(SizedBox)));
    expect(identical(first, second), isTrue);
  });

  testWidgets('component theme override via copyWith', (tester) async {
    const customCheckbox = M3ECheckboxTheme(boxSize: 24);
    final tokens = M3EThemeData.light().copyWith(checkboxTheme: customCheckbox);
    final resolved = await _resolve(
      tester,
      _capture(ThemeData(), tokens: tokens),
    );
    expect(resolved.checkboxTheme.boxSize, 24);
  });
}
