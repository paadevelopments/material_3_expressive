import 'dart:math' as math;

import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamic_color/test_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/icon_buttons/enums/m3e_icon_button_enums.dart';
import 'package:material_3_expressive/components/navigation_bar/models/m3e_navigation_bar_destination.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_color_utilities/hct/cam16.dart';
import 'package:material_color_utilities/palettes/tonal_palette.dart';

const Color _accentGreen = Color(0xFF286C2A);
const Color _accentOrange = Color(0xFFE65100);

M3EColorScheme resolvedM3eSchemeFromAccent(
  Color accent, {
  Brightness brightness = Brightness.light,
}) {
  final fromSeed = ColorScheme.fromSeed(
    seedColor: accent,
    brightness: brightness,
  );
  return M3EColorScheme.fromColorScheme(fromSeed.harmonized()).harmonized();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(M3EDynamicColorHost.clearCacheForTesting);

  testWidgets('static M3ETheme defaults to light when adaptive fields are null',
      (WidgetTester tester) async {
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    await tester.pumpWidget(
      MaterialApp(
        home: M3ETheme(
          data: base,
          child: Builder(
            builder: (BuildContext context) {
              final theme = M3ETheme.of(context);
              return Text(
                'brightness:${theme.brightness.name}',
                style: TextStyle(color: theme.colorScheme.primary),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('brightness:light'), findsOneWidget);
  });

  testWidgets('autoTheming resolves platform brightness without app setState',
      (WidgetTester tester) async {
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: M3ETheme(
            data: base,
            autoTheming: true,
            child: const M3EButton(
              onPressed: null,
              child: Text('Probe'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final M3EThemeData resolved =
        M3ETheme.of(tester.element(find.byType(M3EButton)));
    expect(resolved.brightness, Brightness.dark);
  });

  testWidgets(
      'autoTheming updates when platform brightness changes without setState',
      (WidgetTester tester) async {
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    Future<void> pumpWithBrightness(Brightness brightness) {
      return tester.pumpWidget(
        MaterialApp(
          theme: base.toThemeData(),
          home: MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: M3ETheme(
              data: base,
              autoTheming: true,
              child: const M3EButton(
                onPressed: null,
                child: Text('Probe'),
              ),
            ),
          ),
        ),
      );
    }

    await pumpWithBrightness(Brightness.light);
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.light,
    );

    await pumpWithBrightness(Brightness.dark);
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.dark,
    );
  });

  testWidgets(
      'autoTheming updates card painted color when platform brightness changes without setState',
      (WidgetTester tester) async {
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    Future<void> pumpWithBrightness(Brightness brightness) {
      return tester.pumpWidget(
        MaterialApp(
          theme: base.toThemeData(),
          home: MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: M3ETheme(
              data: base,
              autoTheming: true,
              child: const M3ECard(child: Text('Card')),
            ),
          ),
        ),
      );
    }

    await pumpWithBrightness(Brightness.light);
    await tester.pumpAndSettle();

    final Finder containerFinder = find.byType(AnimatedContainer);
    M3EThemeData lightTheme =
        M3ETheme.of(tester.element(find.byType(M3ECard)));
    final Color lightColor = lightTheme.cardTheme.backgroundColor(
      lightTheme.colorScheme,
      M3ECardVariant.elevated,
    );
    expect(
      (tester.widget<AnimatedContainer>(containerFinder).decoration!
              as BoxDecoration)
          .color,
      lightColor,
    );

    await pumpWithBrightness(Brightness.dark);
    await tester.pump();

    final M3EThemeData darkTheme =
        M3ETheme.of(tester.element(find.byType(M3ECard)));
    final Color darkColor = darkTheme.cardTheme.backgroundColor(
      darkTheme.colorScheme,
      M3ECardVariant.elevated,
    );
    expect(
      (tester.widget<AnimatedContainer>(containerFinder).decoration!
              as BoxDecoration)
          .color,
      darkColor,
    );
    expect(darkColor, isNot(equals(lightColor)));
  });

  testWidgets(
      'autoTheming updates icon button painted color when platform brightness changes without setState',
      (WidgetTester tester) async {
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    Future<void> pumpWithBrightness(Brightness brightness) {
      return tester.pumpWidget(
        MaterialApp(
          theme: base.toThemeData(),
          home: MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: M3ETheme(
              data: base,
              autoTheming: true,
              child: const M3EIconButton(
                icon: Icon(Icons.add),
                variant: M3EIconButtonVariant.filled,
              ),
            ),
          ),
        ),
      );
    }

    await pumpWithBrightness(Brightness.light);
    await tester.pumpAndSettle();

    final Finder iconButtonFinder = find.byType(IconButton);
    final Color lightPrimary =
        M3ETheme.of(tester.element(find.byType(M3EIconButton)))
            .colorScheme
            .primary;
    final ButtonStyle lightStyle = tester.widget<IconButton>(iconButtonFinder).style!;
    expect(lightStyle.backgroundColor!.resolve(<WidgetState>{}), lightPrimary);

    await pumpWithBrightness(Brightness.dark);
    await tester.pump();

    final Color darkPrimary =
        M3ETheme.of(tester.element(find.byType(M3EIconButton)))
            .colorScheme
            .primary;
    final ButtonStyle darkStyle = tester.widget<IconButton>(iconButtonFinder).style!;
    expect(darkStyle.backgroundColor!.resolve(<WidgetState>{}), darkPrimary);
    expect(darkPrimary, isNot(equals(lightPrimary)));
  });

  testWidgets(
      'autoTheming updates navigation bar painted color when platform brightness changes without setState',
      (WidgetTester tester) async {
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    const destinations = <M3ENavigationBarDestination>[
      M3ENavigationBarDestination(icon: Icon(Icons.home), label: 'Home'),
      M3ENavigationBarDestination(icon: Icon(Icons.search), label: 'Search'),
    ];

    Future<void> pumpWithBrightness(Brightness brightness) {
      return tester.pumpWidget(
        MaterialApp(
          theme: base.toThemeData(),
          home: MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: M3ETheme(
              data: base,
              autoTheming: true,
              child: const M3ENavigationBar(
                destinations: destinations,
              ),
            ),
          ),
        ),
      );
    }

    await pumpWithBrightness(Brightness.light);
    await tester.pumpAndSettle();

    final Finder materialFinder = find.descendant(
      of: find.byType(M3ENavigationBar),
      matching: find.byType(Material),
    );
    final M3EThemeData lightTheme =
        M3ETheme.of(tester.element(find.byType(M3ENavigationBar)));
    final Color lightBg = lightTheme.navigationBarTheme.containerColor(
      lightTheme.colorScheme,
    );
    expect(tester.widget<Material>(materialFinder.first).color, lightBg);

    await pumpWithBrightness(Brightness.dark);
    await tester.pump();

    final M3EThemeData darkTheme =
        M3ETheme.of(tester.element(find.byType(M3ENavigationBar)));
    final Color darkBg = darkTheme.navigationBarTheme.containerColor(
      darkTheme.colorScheme,
    );
    expect(tester.widget<Material>(materialFinder.first).color, darkBg);
    expect(darkBg, isNot(equals(lightBg)));
  });

  testWidgets('M3EThemeController toggles wrapped component brightness',
      (WidgetTester tester) async {
    final controller = M3EThemeController();
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: M3ETheme(
          data: base,
          controller: controller,
          child: const M3EButton(
            onPressed: null,
            child: Text('Probe'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.light,
    );

    controller.setBrightness(Brightness.dark);
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('M3EThemeController updates card background color after toggle',
      (WidgetTester tester) async {
    final controller = M3EThemeController();
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: M3ETheme(
          data: base,
          controller: controller,
          child: const M3ECard(child: Text('Card')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Finder containerFinder = find.byType(AnimatedContainer);
    expect(containerFinder, findsOneWidget);

    M3EThemeData theme =
        M3ETheme.of(tester.element(find.byType(M3ECard)));
    final Color lightColor = theme.cardTheme.backgroundColor(
      theme.colorScheme,
      M3ECardVariant.elevated,
    );

    AnimatedContainer container = tester.widget(containerFinder);
    expect((container.decoration! as BoxDecoration).color, lightColor);

    controller.setBrightness(Brightness.dark);
    await tester.pump();

    theme = M3ETheme.of(tester.element(find.byType(M3ECard)));
    final Color darkColor = theme.cardTheme.backgroundColor(
      theme.colorScheme,
      M3ECardVariant.elevated,
    );

    container = tester.widget(containerFinder);
    expect((container.decoration! as BoxDecoration).color, darkColor);
    expect(darkColor, isNot(equals(lightColor)));
  });

  testWidgets('dynamicColoring applies mocked dynamic schemes',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(accentColor: _accentGreen);

    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    final M3EColorScheme expected = resolvedM3eSchemeFromAccent(_accentGreen);

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: M3ETheme(
          data: base,
          dynamicColoring: true,
          child: const M3EButton(
            onPressed: null,
            child: Text('Probe'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final M3EThemeData resolved =
        M3ETheme.of(tester.element(find.byType(M3EButton)));
    expect(resolved.colorScheme.primary, expected.primary);
  });

  testWidgets('preload resolves dynamic colors before the first frame',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(accentColor: _accentGreen);

    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    final M3EColorScheme expected = resolvedM3eSchemeFromAccent(_accentGreen);

    await M3EDynamicColorHost.preload();

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: M3ETheme(
          data: base,
          dynamicColoring: true,
          child: const M3EButton(
            onPressed: null,
            child: Text('Probe'),
          ),
        ),
      ),
    );
    await tester.pump();

    final M3EThemeData resolved =
        M3ETheme.of(tester.element(find.byType(M3EButton)));
    expect(resolved.colorScheme.primary, expected.primary);
  });

  testWidgets('dynamicColoring applies mocked core palette via fromSeed',
      (WidgetTester tester) async {
    final Cam16 cam = Cam16.fromInt(_accentGreen.toARGB32());
    final TonalPalette primary =
        TonalPalette.of(cam.hue, math.max(48, cam.chroma));
    final seed = Color(primary.get(40));
    DynamicColorTestingUtils.setMockDynamicColors(
      corePalette: generateCorePalette(
        (int index) => index < TonalPalette.commonSize
            ? primary.asList[index]
            : 0,
      ),
    );

    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    final M3EColorScheme expected = resolvedM3eSchemeFromAccent(seed);

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: M3ETheme(
          data: base,
          dynamicColoring: true,
          child: const M3EButton(
            onPressed: null,
            child: Text('Probe'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final M3EThemeData resolved =
        M3ETheme.of(tester.element(find.byType(M3EButton)));
    expect(resolved.colorScheme.primary, expected.primary);
  });

  testWidgets('dynamicColoring applies mocked dynamic schemes in dark mode',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(accentColor: _accentGreen);

    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    final M3EColorScheme expected = resolvedM3eSchemeFromAccent(
      _accentGreen,
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
            child: const M3EButton(
              onPressed: null,
              child: Text('Probe'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final M3EThemeData resolved =
        M3ETheme.of(tester.element(find.byType(M3EButton)));
    expect(resolved.brightness, Brightness.dark);
    expect(resolved.colorScheme.primary, expected.primary);
  });

  testWidgets('dynamicColoring harmonizes built-in and expressive semantic colors',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(accentColor: _accentGreen);

    final rawDynamic = ColorScheme.fromSeed(seedColor: _accentGreen);
    final M3EColorScheme expectedScheme = resolvedM3eSchemeFromAccent(_accentGreen);
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: M3ETheme(
          data: base,
          dynamicColoring: true,
          child: const M3EButton(
            onPressed: null,
            child: Text('Probe'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final M3EColorScheme scheme =
        M3ETheme.of(tester.element(find.byType(M3EButton))).colorScheme;

    expect(scheme.primary, expectedScheme.primary);
    expect(scheme.error, expectedScheme.error);
    expect(scheme.success, expectedScheme.success);
    expect(scheme.warning, expectedScheme.warning);
    expect(scheme.danger, scheme.error);

    final baseM3e =
        M3EColorScheme.fromColorScheme(rawDynamic.harmonized());
    expect(scheme.success, baseM3e.success.harmonizeWith(scheme.primary));
    expect(scheme.warning, baseM3e.warning.harmonizeWith(scheme.primary));
  });

  test('M3EColorScheme.harmonized shifts custom roles toward primary', () {
    const Color primary = Colors.blue;
    final scheme = M3EColorScheme.fromColorScheme(
      const ColorScheme.light(primary: primary),
    );

    final M3EColorScheme harmonized = scheme.harmonized();

    expect(
      harmonized.success,
      const Color(0xFF2E7D32).harmonizeWith(primary),
    );
    expect(
      harmonized.warning,
      const Color(0xFFEF6C00).harmonizeWith(primary),
    );
    expect(harmonized.success, isNot(scheme.success));
  });

  testWidgets('dynamicColoring refreshes when app resumes after OS color change',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(accentColor: _accentGreen);

    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    final Color greenPrimary =
        resolvedM3eSchemeFromAccent(_accentGreen).primary;
    final Color orangePrimary =
        resolvedM3eSchemeFromAccent(_accentOrange).primary;

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: M3ETheme(
          data: base,
          dynamicColoring: true,
          child: const M3EButton(
            onPressed: null,
            child: Text('Probe'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).colorScheme.primary,
      greenPrimary,
    );

    DynamicColorTestingUtils.setMockDynamicColors(accentColor: _accentOrange);

    tester.binding
      ..handleAppLifecycleStateChanged(AppLifecycleState.paused)
      ..handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).colorScheme.primary,
      orangePrimary,
    );
    expect(orangePrimary, isNot(greenPrimary));
  });

  testWidgets('autoTheming toggle inverts platform brightness',
      (WidgetTester tester) async {
    final controller = M3EThemeController();
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    Future<void> pumpWithController() {
      return tester.pumpWidget(
        MaterialApp(
          theme: base.toThemeData(),
          home: MediaQuery(
            data: const MediaQueryData(),
            child: M3ETheme(
              data: base,
              autoTheming: true,
              controller: controller,
              child: const M3EButton(
                onPressed: null,
                child: Text('Probe'),
              ),
            ),
          ),
        ),
      );
    }

    await pumpWithController();
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.light,
    );

    controller.toggleBrightness(autoTheming: true);
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.dark,
    );
    expect(controller.invertPlatformBrightness, isTrue);
    expect(controller.brightnessOverride, isNull);

    controller.toggleBrightness(autoTheming: true);
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.light,
    );
    expect(controller.invertPlatformBrightness, isFalse);
  });

  testWidgets(
      'autoTheming toggle keeps tracking platform brightness when OS changes',
      (WidgetTester tester) async {
    final controller = M3EThemeController();
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    Future<void> pumpWithBrightness(Brightness brightness) {
      return tester.pumpWidget(
        MaterialApp(
          theme: base.toThemeData(),
          home: MediaQuery(
            data: MediaQueryData(platformBrightness: brightness),
            child: M3ETheme(
              data: base,
              autoTheming: true,
              controller: controller,
              child: const M3EButton(
                onPressed: null,
                child: Text('Probe'),
              ),
            ),
          ),
        ),
      );
    }

    await pumpWithBrightness(Brightness.light);
    await tester.pumpAndSettle();

    controller.toggleBrightness(autoTheming: true);
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.dark,
    );

    await pumpWithBrightness(Brightness.dark);
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.light,
    );
  });

  testWidgets('toggle without autoTheming locks absolute brightness',
      (WidgetTester tester) async {
    final controller = M3EThemeController();
    final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: MediaQuery(
          data: const MediaQueryData(platformBrightness: Brightness.dark),
          child: M3ETheme(
            data: base,
            controller: controller,
            child: const M3EButton(
              onPressed: null,
              child: Text('Probe'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    controller.toggleBrightness();
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.dark,
    );
    expect(controller.brightnessOverride, Brightness.dark);

    await tester.pumpWidget(
      MaterialApp(
        theme: base.toThemeData(),
        home: MediaQuery(
          data: const MediaQueryData(),
          child: M3ETheme(
            data: base,
            controller: controller,
            child: const M3EButton(
              onPressed: null,
              child: Text('Probe'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.dark,
    );
  });
}
