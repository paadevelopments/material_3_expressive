import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamic_color/samples.dart';
import 'package:dynamic_color/test_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('static M3ETheme defaults to light when adaptive fields are null',
      (WidgetTester tester) async {
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

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
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

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
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

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

  testWidgets('M3EThemeController toggles wrapped component brightness',
      (WidgetTester tester) async {
    final M3EThemeController controller = M3EThemeController();
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

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
    final M3EThemeController controller = M3EThemeController();
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

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
    DynamicColorTestingUtils.setMockDynamicColors(
      corePalette: SampleCorePalettes.green,
    );

    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

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
    expect(resolved.colorScheme.primary, const Color(0xFF286C2A));
  });

  testWidgets('dynamicColoring applies mocked dynamic schemes in dark mode',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(
      corePalette: SampleCorePalettes.green,
    );

    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

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
    expect(resolved.colorScheme.primary, const Color(0xFF90D889));
  });

  testWidgets('dynamicColoring harmonizes built-in and expressive semantic colors',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(
      corePalette: SampleCorePalettes.green,
    );

    final ColorScheme rawDynamic = SampleColorSchemes.green(Brightness.light);
    final M3EColorScheme expectedScheme = M3EColorScheme.fromColorScheme(
      rawDynamic.harmonized(),
    ).harmonized();
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

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

    final M3EColorScheme baseM3e =
        M3EColorScheme.fromColorScheme(rawDynamic.harmonized());
    expect(scheme.success, baseM3e.success.harmonizeWith(scheme.primary));
    expect(scheme.warning, baseM3e.warning.harmonizeWith(scheme.primary));
  });

  test('M3EColorScheme.harmonized shifts custom roles toward primary', () {
    const Color primary = Colors.blue;
    final M3EColorScheme scheme = M3EColorScheme.fromColorScheme(
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
    DynamicColorTestingUtils.setMockDynamicColors(
      corePalette: SampleCorePalettes.green,
    );

    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    const Color greenPrimary = Color(0xFF286C2A);
    final Color orangePrimary =
        SampleColorSchemes.orange(Brightness.light).primary;

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

    DynamicColorTestingUtils.setMockDynamicColors(
      corePalette: SampleCorePalettes.orange,
    );

    final TestWidgetsFlutterBinding binding =
        tester.binding as TestWidgetsFlutterBinding;
    binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).colorScheme.primary,
      orangePrimary,
    );
    expect(orangePrimary, isNot(greenPrimary));
  });
}
