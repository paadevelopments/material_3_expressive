import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

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
  test('baseline tokens match M3 spec for bodyLarge', _baselineTokensMatchSpec);
  test(
    'emphasized scale bumps labelLarge to w700',
    _emphasizedScaleBumpsLabelLargeToW700,
  );
  test(
    'M3ETypography.material3 exposes baseline and emphasized',
    _m3etypographyMaterial3ExposesBaselineAndEmphasized,
  );
  test(
    'typeScale getter on M3EThemeData returns baseline',
    _typescaleGetterOnM3ethemedataReturnsBaseline,
  );
  test(
    'copyWith typeScale preserves default emphasized scale',
    _copywithTypescalePreservesDefaultEmphasizedScale,
  );
  test(
    'applyVariableFont sets per-role opsz and split ROND',
    _applyvariablefontSetsPerRoleOpszAndSplitRond,
  );
  test(
    'applyVariableFont adds GRAD on emphasized scale only',
    _applyvariablefontAddsGradOnEmphasizedScaleOnly,
  );
  test('M3ETypeVariations.graded aliases emphasized preset', _gradedAlias);
  test(
    'M3EVariableFontAxes.toVariations omits null axes',
    _axesToVariationsOmitsNulls,
  );
  test(
    'global wght override beats auto sync',
    _globalWghtOverrideBeatsAutoSync,
  );
  test(
    'brand ROND beats global ROND for headline roles',
    _brandRondBeatsGlobalForHeadline,
  );
  test(
    'M3ETypeStyleTokens fromTextStyle round trip',
    _tokensFromTextStyleRoundTrip,
  );
  test(
    'toEmphasized bumps label weight to w700',
    _toemphasizedBumpsLabelWeight,
  );
  test(
    'nearestRole picks expected role by size',
    _nearestrolePicksExpectedRoleBySize,
  );
  test(
    'toVariant preserves color and applies emphasized tokens',
    _tovariantPreservesColorAndAppliesEmphasized,
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
    fontVariations: M3ETypeVariations.graded.variations,
  );

  for (final TextStyle style in _roles(applied)) {
    expect(style.fontVariations, M3ETypeVariations.graded.variations);
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

void _baselineTokensMatchSpec() {
  final scale = M3ETypeScale.baseline();
  expect(scale.bodyLarge.fontSize, 16);
  expect(scale.bodyLarge.height, closeTo(24 / 16, 0.001));
  expect(scale.bodyLarge.letterSpacing, 0.5);
  expect(scale.bodyLarge.fontWeight, FontWeight.w400);
}

void _emphasizedScaleBumpsLabelLargeToW700() {
  final scale = M3ETypeScale.emphasized();
  expect(scale.labelLarge.fontWeight, FontWeight.w700);
  expect(scale.headlineSmall.fontWeight, FontWeight.w500);
}

void _m3etypographyMaterial3ExposesBaselineAndEmphasized() {
  final typography = M3ETypography.material3();
  expect(typography.baseline.bodyLarge.fontWeight, FontWeight.w400);
  expect(typography.emphasized.bodyLarge.fontWeight, FontWeight.w500);
  expect(typography.emphasized.labelLarge.fontWeight, FontWeight.w700);
}

void _typescaleGetterOnM3ethemedataReturnsBaseline() {
  final data = M3EThemeData.light();
  expect(identical(data.typeScale, data.typography.baseline), isTrue);
}

void _copywithTypescalePreservesDefaultEmphasizedScale() {
  final custom = M3ETypeScale.baseline().apply(fontSizeFactor: 2);
  final data = M3EThemeData.light().copyWith(typeScale: custom);
  expect(data.typeScale.bodyMedium.fontSize, 28);
  expect(data.typography.emphasized.labelLarge.fontWeight, FontWeight.w700);
}

void _applyvariablefontSetsPerRoleOpszAndSplitRond() {
  const config = M3EVariableFontConfig(rond: 25, bodyRond: 75);
  final applied = M3ETypeScale.baseline().applyVariableFont(config);

  expect(
    applied.headlineSmall.fontVariations,
    contains(const FontVariation('opsz', 24)),
  );
  expect(
    applied.headlineSmall.fontVariations,
    contains(const FontVariation('ROND', 25)),
  );
  expect(
    applied.bodyLarge.fontVariations,
    contains(const FontVariation('opsz', 16)),
  );
  expect(
    applied.bodyLarge.fontVariations,
    contains(const FontVariation('ROND', 75)),
  );
}

void _applyvariablefontAddsGradOnEmphasizedScaleOnly() {
  const config = M3EVariableFontConfig();
  final typography = M3ETypography.material3().applyVariableFont(config);

  expect(
    typography.baseline.bodyLarge.fontVariations,
    isNot(contains(const FontVariation('GRAD', 50))),
  );
  expect(
    typography.emphasized.bodyLarge.fontVariations,
    contains(const FontVariation('GRAD', 50)),
  );
}

void _gradedAlias() {
  expect(M3ETypeVariations.graded, M3ETypeVariations.emphasized);
  expect(
    M3ETypeVariations.graded.variations,
    M3ETypeVariations.emphasized.variations,
  );
}

void _axesToVariationsOmitsNulls() {
  const axes = M3EVariableFontAxes(wght: 500, opsz: 16);
  expect(axes.toVariations(), hasLength(2));
  expect(axes.toVariations(), contains(const FontVariation('wght', 500)));
}

void _globalWghtOverrideBeatsAutoSync() {
  const config = M3EVariableFontConfig(
    global: M3EVariableFontAxes(wght: 600),
  );
  const style = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  final variations = config.resolveForRole(
    M3ETypeRole.bodyLarge,
    style,
    isEmphasizedScale: false,
  );
  expect(variations, contains(const FontVariation('wght', 600)));
  expect(variations, isNot(contains(const FontVariation('wght', 400))));
}

void _brandRondBeatsGlobalForHeadline() {
  const config = M3EVariableFontConfig(
    global: M3EVariableFontAxes(rond: 10),
    brand: M3EVariableFontAxes(rond: 40),
  );
  const style = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
  final headline = config.resolveForRole(
    M3ETypeRole.headlineSmall,
    style,
    isEmphasizedScale: false,
  );
  final body = config.resolveForRole(
    M3ETypeRole.bodyLarge,
    style,
    isEmphasizedScale: false,
  );
  expect(headline, contains(const FontVariation('ROND', 40)));
  expect(body, contains(const FontVariation('ROND', 10)));
}

void _tokensFromTextStyleRoundTrip() {
  const style = TextStyle(
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w400,
  );
  final tokens = M3ETypeStyleTokens.fromTextStyle(style);
  expect(tokens.fontSize, 16);
  expect(tokens.lineHeight, 24);
  expect(tokens.letterSpacing, 0.5);
  expect(tokens.fontWeight, FontWeight.w400);
}

void _toemphasizedBumpsLabelWeight() {
  const tokens = M3ETypeStyleTokens(
    fontSize: 14,
    lineHeight: 20,
    letterSpacing: 0.1,
    fontWeight: FontWeight.w500,
  );
  expect(tokens.toEmphasized().fontWeight, FontWeight.w700);
}

void _nearestrolePicksExpectedRoleBySize() {
  expect(
    M3ETypeStyleConversion.nearestRole(const TextStyle(fontSize: 24)),
    M3ETypeRole.headlineSmall,
  );
  expect(
    M3ETypeStyleConversion.nearestRole(const TextStyle(fontSize: 16)),
    M3ETypeRole.bodyLarge,
  );
}

void _tovariantPreservesColorAndAppliesEmphasized() {
  const source = TextStyle(
    fontFamily: 'Roboto Flex',
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: Color(0xFF112233),
  );
  final result = M3ETypeStyleConversion.toVariant(
    source,
    variant: M3ETypeScaleVariant.emphasized,
    role: M3ETypeRole.bodyLarge,
  );
  expect(result.fontFamily, 'Roboto Flex');
  expect(result.color, const Color(0xFF112233));
  expect(result.fontWeight, FontWeight.w500);
  expect(result.fontSize, 16);
}

List<TextStyle> _roles(M3ETypeScale scale) {
  return scale.roles.toList();
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
