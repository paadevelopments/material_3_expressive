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
}
