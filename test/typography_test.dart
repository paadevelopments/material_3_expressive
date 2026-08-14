import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  test(
    'apply sets fontFamily on every role without changing size or weight',
    _applySetsFontFamilyOnEveryRole,
  );
  test(
    'apply scales font sizes with factor and delta',
    _applyScalesFontSizesWithFactorAndDelta,
  );
  test(
    'apply copies fontVariations onto every role',
    _applyCopiesFontVariationsOntoEveryRole,
  );
  test('withColor still colors every role', _withColorStillColorsEveryRole);
  test(
    'copyWith fontFamily applies onto an explicit typeScale',
    _copyWithFontFamilyAppliesOntoAnExplicitTypescale,
  );
  testWidgets(
    'copyWith fontFamily projects to DefaultTextStyle and textTheme',
    _copyWithFontFamilyProjectsToDefaulttextstyleAndTexttheme,
  );
  testWidgets(
    'M3EMaterialApp.fontFamily projects to the shell and Material theme',
    _m3ematerialappFontfamilyProjectsToTheShellAndMaterialT,
  );
}

void _applySetsFontFamilyOnEveryRole() {
  final base = M3ETypeScale.baseline();
  final applied = base.apply(fontFamily: 'Courier');

  for (final (TextStyle next, TextStyle original) in _pairs(applied, base)) {
    expect(next.fontFamily, 'Courier');
    expect(next.fontSize, original.fontSize);
    expect(next.fontWeight, original.fontWeight);
    expect(next.letterSpacing, original.letterSpacing);
  }
}

void _applyScalesFontSizesWithFactorAndDelta() {
  final base = M3ETypeScale.baseline();
  final applied = base.apply(fontSizeFactor: 2, fontSizeDelta: 1);

  expect(applied.bodyMedium.fontSize, base.bodyMedium.fontSize! * 2 + 1);
  expect(applied.displayLarge.fontSize, base.displayLarge.fontSize! * 2 + 1);
}

void _applyCopiesFontVariationsOntoEveryRole() {
  final applied = M3ETypeScale.baseline().apply(
    fontVariations: M3ETypeVariations.emphasized.variations,
  );

  for (final TextStyle style in _roles(applied)) {
    expect(style.fontVariations, M3ETypeVariations.emphasized.variations);
  }
}

void _withColorStillColorsEveryRole() {
  const color = Color(0xFF123456);
  final applied = M3ETypeScale.baseline().withColor(color);

  for (final TextStyle style in _roles(applied)) {
    expect(style.color, color);
  }
}

void _copyWithFontFamilyAppliesOntoAnExplicitTypescale() {
  final sized = M3ETypeScale.baseline().apply(fontSizeFactor: 1.5);
  final data = M3EThemeData.light().copyWith(
    typeScale: sized,
    fontFamily: 'Courier',
  );

  expect(data.typeScale.bodyMedium.fontFamily, 'Courier');
  expect(data.typeScale.bodyMedium.fontSize, sized.bodyMedium.fontSize);
}

Future<void> _copyWithFontFamilyProjectsToDefaulttextstyleAndTexttheme(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    MaterialApp(
      home: M3ETheme(
        data: M3EThemeData.light().copyWith(fontFamily: 'Courier'),
        child: const Text('probe'),
      ),
    ),
  );

  final BuildContext context = tester.element(find.text('probe'));
  expect(DefaultTextStyle.of(context).style.fontFamily, 'Courier');
  expect(Theme.of(context).textTheme.bodyMedium?.fontFamily, 'Courier');
}

Future<void> _m3ematerialappFontfamilyProjectsToTheShellAndMaterialT(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      fontFamily: 'Courier',
      fontVariations: M3ETypeVariations.wide.variations,
      home: const Text('probe'),
    ),
  );

  final BuildContext context = tester.element(find.text('probe'));
  final scale = M3ETheme.of(context).typeScale;
  expect(scale.bodyMedium.fontFamily, 'Courier');
  expect(scale.bodyMedium.fontVariations, M3ETypeVariations.wide.variations);
  expect(DefaultTextStyle.of(context).style.fontFamily, 'Courier');
  expect(Theme.of(context).textTheme.bodyMedium?.fontFamily, 'Courier');
}

List<TextStyle> _roles(M3ETypeScale scale) {
  return <TextStyle>[
    scale.displayLarge,
    scale.displayMedium,
    scale.displaySmall,
    scale.headlineLarge,
    scale.headlineMedium,
    scale.headlineSmall,
    scale.titleLarge,
    scale.titleMedium,
    scale.titleSmall,
    scale.bodyLarge,
    scale.bodyMedium,
    scale.bodySmall,
    scale.labelLarge,
    scale.labelMedium,
    scale.labelSmall,
  ];
}

Iterable<(TextStyle, TextStyle)> _pairs(
  M3ETypeScale next,
  M3ETypeScale original,
) {
  final List<TextStyle> a = _roles(next);
  final List<TextStyle> b = _roles(original);
  return <(TextStyle, TextStyle)>[
    for (int i = 0; i < a.length; i++) (a[i], b[i]),
  ];
}
