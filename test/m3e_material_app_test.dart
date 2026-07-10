import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('deriveDarkTemplate preserves non-color tokens', () {
    final M3EThemeData light = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    final M3EThemeData dark = light.deriveDarkTemplate();

    expect(dark.brightness, Brightness.dark);
    expect(dark.typeScale, light.typeScale);
    expect(dark.spacing, light.spacing);
    expect(dark.buttonTheme, light.buttonTheme);
    expect(dark.cardTheme, light.cardTheme);
    expect(dark.colorScheme.primary, isNot(equals(light.colorScheme.primary)));
  });

  testWidgets('M3EMaterialApp aligns themeMode with autoTheming platform brightness',
      (WidgetTester tester) async {
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    Future<void> pumpWithBrightness(Brightness brightness) {
      return tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(platformBrightness: brightness),
          child: M3EMaterialApp(
            data: base,
            autoTheming: true,
            home: const M3EButton(
              onPressed: null,
              child: Text('Probe'),
            ),
          ),
        ),
      );
    }

    await pumpWithBrightness(Brightness.light);
    await tester.pumpAndSettle();

    final MaterialApp lightApp = tester.widget(find.byType(MaterialApp));
    expect(lightApp.themeMode, ThemeMode.light);
    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.light,
    );

    await pumpWithBrightness(Brightness.dark);
    await tester.pumpAndSettle();

    final MaterialApp darkApp = tester.widget(find.byType(MaterialApp));
    expect(darkApp.themeMode, ThemeMode.dark);
    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.dark,
    );
  });

  testWidgets('M3EMaterialApp toggle via controllerOf updates brightness',
      (WidgetTester tester) async {
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    await tester.pumpWidget(
      M3EMaterialApp(
        data: base,
        autoTheming: true,
        home: Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () {
                M3ETheme.controllerOf(context)?.toggleBrightness(
                  autoTheming: true,
                );
              },
              child: const Text('Toggle'),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.light,
    );
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.light);

    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();

    expect(
      M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
      Brightness.dark,
    );
    expect(tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
        ThemeMode.dark);
  });

  testWidgets('M3ETheme.controllerOf returns controller from M3EMaterialApp',
      (WidgetTester tester) async {
    final M3EThemeController controller = M3EThemeController();
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

    await tester.pumpWidget(
      M3EMaterialApp(
        data: base,
        autoTheming: true,
        controller: controller,
        home: const M3EButton(
          onPressed: null,
          child: Text('Probe'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      M3ETheme.controllerOf(tester.element(find.byType(M3EButton))),
      controller,
    );
  });

  testWidgets('M3EMaterialApp forwards MaterialApp constructor fields',
      (WidgetTester tester) async {
    final M3EThemeData base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
    const Locale locale = Locale('en', 'US');
    const List<Locale> supportedLocales = <Locale>[Locale('en', 'US')];

    await tester.pumpWidget(
      M3EMaterialApp(
        data: base,
        locale: locale,
        supportedLocales: supportedLocales,
        showPerformanceOverlay: true,
        home: const M3EButton(
          onPressed: null,
          child: Text('Probe'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final MaterialApp app = tester.widget(find.byType(MaterialApp));
    expect(app.locale, locale);
    expect(app.supportedLocales, supportedLocales);
    expect(app.showPerformanceOverlay, isTrue);
  });
}
