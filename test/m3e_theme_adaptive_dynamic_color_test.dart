import 'dart:typed_data';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamic_color/test_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_color_utilities/material_color_utilities.dart';
import 'package:material_ui/material_ui.dart';

import 'm3e_theme_adaptive_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'dynamicColoring applies mocked dynamic schemes',
    _dynamiccoloringAppliesMockedDynamicSchemes,
  );
  testWidgets(
    'dynamicColoring applies mocked core palette via fromSeed',
    _dynamiccoloringAppliesMockedCorePaletteViaFromseed,
  );
  testWidgets(
    'dynamicColoring applies mocked dynamic schemes in dark mode',
    _dynamiccoloringAppliesMockedDynamicSchemesInDarkMode,
  );
  testWidgets(
    'dynamicColoring harmonizes built-in and expressive semantic colors',
    _dynamiccoloringHarmonizesBuiltInAndExpressiveSemantic,
  );
  test(
    'M3EColorScheme.harmonized shifts custom roles toward primary',
    _m3ecolorschemeHarmonizedShiftsCustomRolesTowardPrimary,
  );
  testWidgets(
    'dynamicColoring refreshes when app resumes after OS color change',
    _dynamiccoloringRefreshesWhenAppResumesAfterOsColorCh,
  );
  testWidgets(
    'dynamicColoring prefers core palette primary as seed over accent',
    _dynamiccoloringPrefersCorePalettePrimaryAsSeedOverAc,
  );
  testWidgets(
    'dynamicColoring refreshes from core palette primary on resume',
    _dynamiccoloringRefreshesFromCorePalettePrimaryOnResum,
  );
}

Future<void> _dynamiccoloringAppliesMockedDynamicSchemes(
  WidgetTester tester,
) async {
  DynamicColorTestingUtils.setMockDynamicColors(accentColor: accentGreen);

  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
  final M3EColorScheme expected = resolvedM3eSchemeFromAccent(accentGreen);

  await tester.pumpWidget(
    MaterialApp(
      theme: base.toThemeData(),
      home: M3ETheme(
        data: base,
        dynamicColoring: true,
        child: const M3EButton(onPressed: null, child: Text('Probe')),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final M3EThemeData resolved = M3ETheme.of(
    tester.element(find.byType(M3EButton)),
  );
  expect(resolved.colorScheme.primary, expected.primary);
}

Future<void> _dynamiccoloringAppliesMockedCorePaletteViaFromseed(
  WidgetTester tester,
) async {
  // Reconstruct CorePalette.of tones without calling the deprecated API:
  // primary chroma floor 48, seed = primary tone 40 (same as toColorScheme).
  final cam = Cam16.fromInt(accentGreen.toARGB32());
  final primary = TonalPalette.of(cam.hue, cam.chroma < 48 ? 48 : cam.chroma);
  final secondary = TonalPalette.of(cam.hue, 16);
  final tertiary = TonalPalette.of(cam.hue + 60, 24);
  final neutral = TonalPalette.of(cam.hue, 4);
  final neutralVariant = TonalPalette.of(cam.hue, 8);
  final paletteList = <int>[
    ...primary.asList,
    ...secondary.asList,
    ...tertiary.asList,
    ...neutral.asList,
    ...neutralVariant.asList,
  ];

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(DynamicColorPlugin.channel, (
        MethodCall methodCall,
      ) async {
        if (methodCall.method == DynamicColorPlugin.methodName) {
          return Int64List.fromList(paletteList);
        }
        if (methodCall.method == DynamicColorPlugin.accentColorMethodName) {
          return null;
        }
        return null;
      });
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          DynamicColorPlugin.channel,
          (MethodCall methodCall) => null,
        );
  });

  final seed = Color(primary.get(40));
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
  final M3EColorScheme expected = resolvedM3eSchemeFromAccent(seed);

  await tester.pumpWidget(
    MaterialApp(
      theme: base.toThemeData(),
      home: M3ETheme(
        data: base,
        dynamicColoring: true,
        child: const M3EButton(onPressed: null, child: Text('Probe')),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final M3EThemeData resolved = M3ETheme.of(
    tester.element(find.byType(M3EButton)),
  );
  expect(resolved.colorScheme.primary, expected.primary);
}

Future<void> _dynamiccoloringAppliesMockedDynamicSchemesInDarkMode(
  WidgetTester tester,
) async {
  DynamicColorTestingUtils.setMockDynamicColors(accentColor: accentGreen);

  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
  final M3EColorScheme expected = resolvedM3eSchemeFromAccent(
    accentGreen,
    brightness: Brightness.dark,
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: base.toThemeData(),
      home: MediaQuery(
        data: const MediaQueryData(platformBrightness: Brightness.dark),
        child: M3ETheme(
          data: base,
          autoTheming: true,
          dynamicColoring: true,
          child: const M3EButton(onPressed: null, child: Text('Probe')),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final M3EThemeData resolved = M3ETheme.of(
    tester.element(find.byType(M3EButton)),
  );
  expect(resolved.brightness, Brightness.dark);
  expect(resolved.colorScheme.primary, expected.primary);
}

Future<void> _dynamiccoloringHarmonizesBuiltInAndExpressiveSemantic(
  WidgetTester tester,
) async {
  DynamicColorTestingUtils.setMockDynamicColors(accentColor: accentGreen);

  final rawDynamic = ColorScheme.fromSeed(seedColor: accentGreen);
  final M3EColorScheme expectedScheme = resolvedM3eSchemeFromAccent(
    accentGreen,
  );
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    MaterialApp(
      theme: base.toThemeData(),
      home: M3ETheme(
        data: base,
        dynamicColoring: true,
        child: const M3EButton(onPressed: null, child: Text('Probe')),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final M3EColorScheme scheme = M3ETheme.of(
    tester.element(find.byType(M3EButton)),
  ).colorScheme;

  expect(scheme.primary, expectedScheme.primary);
  expect(scheme.error, expectedScheme.error);
  expect(scheme.success, expectedScheme.success);
  expect(scheme.warning, expectedScheme.warning);
  expect(scheme.danger, scheme.error);

  final baseM3e = M3EColorScheme.fromColorScheme(rawDynamic.harmonized());
  expect(scheme.success, baseM3e.success.harmonizeWith(scheme.primary));
  expect(scheme.warning, baseM3e.warning.harmonizeWith(scheme.primary));
}

void _m3ecolorschemeHarmonizedShiftsCustomRolesTowardPrimary() {
  const Color primary = Colors.blue;
  final scheme = M3EColorScheme.fromColorScheme(
    const ColorScheme.light(primary: primary),
  );

  final M3EColorScheme harmonized = scheme.harmonized();

  expect(harmonized.success, const Color(0xFF2E7D32).harmonizeWith(primary));
  expect(harmonized.warning, const Color(0xFFEF6C00).harmonizeWith(primary));
  expect(harmonized.success, isNot(scheme.success));
}

Future<void> _dynamiccoloringRefreshesWhenAppResumesAfterOsColorCh(
  WidgetTester tester,
) async {
  DynamicColorTestingUtils.setMockDynamicColors(accentColor: accentGreen);

  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
  final Color greenPrimary = resolvedM3eSchemeFromAccent(accentGreen).primary;
  final Color orangePrimary = resolvedM3eSchemeFromAccent(accentOrange).primary;

  await tester.pumpWidget(
    MaterialApp(
      theme: base.toThemeData(),
      home: M3ETheme(
        data: base,
        dynamicColoring: true,
        child: const M3EButton(onPressed: null, child: Text('Probe')),
      ),
    ),
  );
  await tester.pumpAndSettle();

  expect(
    M3ETheme.of(tester.element(find.byType(M3EButton))).colorScheme.primary,
    greenPrimary,
  );

  DynamicColorTestingUtils.setMockDynamicColors(accentColor: accentOrange);

  tester.binding
    ..handleAppLifecycleStateChanged(AppLifecycleState.paused)
    ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  await tester.pumpAndSettle();

  expect(
    M3ETheme.of(tester.element(find.byType(M3EButton))).colorScheme.primary,
    orangePrimary,
  );
  expect(orangePrimary, isNot(greenPrimary));
}

Future<void> _dynamiccoloringPrefersCorePalettePrimaryAsSeedOverAc(
  WidgetTester tester,
) async {
  final mock = corePaletteMockFromSeed(accentGreen);
  mockDynamicColorChannel(
    corePaletteList: mock.list,
    accentColor: accentOrange,
  );

  final Color expectedPrimary = resolvedM3eSchemeFromAccent(
    mock.primarySeed,
  ).primary;
  final Color accentPrimary = resolvedM3eSchemeFromAccent(accentOrange).primary;

  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    MaterialApp(
      theme: base.toThemeData(),
      home: M3ETheme(
        data: base,
        dynamicColoring: true,
        child: const M3EButton(onPressed: null, child: Text('Probe')),
      ),
    ),
  );
  await tester.pumpAndSettle();

  expect(
    M3ETheme.of(tester.element(find.byType(M3EButton))).colorScheme.primary,
    expectedPrimary,
  );
  expect(expectedPrimary, isNot(accentPrimary));
}

Future<void> _dynamiccoloringRefreshesFromCorePalettePrimaryOnResum(
  WidgetTester tester,
) async {
  final greenMock = corePaletteMockFromSeed(accentGreen);
  final orangeMock = corePaletteMockFromSeed(accentOrange);

  mockDynamicColorChannel(corePaletteList: greenMock.list);

  final Color greenPrimary = resolvedM3eSchemeFromAccent(
    greenMock.primarySeed,
  ).primary;
  final Color orangePrimary = resolvedM3eSchemeFromAccent(
    orangeMock.primarySeed,
  ).primary;

  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    MaterialApp(
      theme: base.toThemeData(),
      home: M3ETheme(
        data: base,
        dynamicColoring: true,
        child: const M3EButton(onPressed: null, child: Text('Probe')),
      ),
    ),
  );
  await tester.pumpAndSettle();

  expect(
    M3ETheme.of(tester.element(find.byType(M3EButton))).colorScheme.primary,
    greenPrimary,
  );

  mockDynamicColorChannel(corePaletteList: orangeMock.list);

  tester.binding
    ..handleAppLifecycleStateChanged(AppLifecycleState.paused)
    ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
  await tester.pumpAndSettle();

  expect(
    M3ETheme.of(tester.element(find.byType(M3EButton))).colorScheme.primary,
    orangePrimary,
  );
  expect(orangePrimary, isNot(greenPrimary));
}
