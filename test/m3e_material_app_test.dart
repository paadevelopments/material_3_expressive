import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'deriveDarkTemplate preserves non-color tokens',
    _derivedarktemplatePreservesNonColorTokens,
  );
  testWidgets(
    'M3EThemeScope caches dark template across resolve calls',
    _m3ethemescopeCachesDarkTemplateAcrossResolveCalls,
  );
  testWidgets(
    'M3EMaterialApp aligns themeMode with autoTheming platform brightness',
    _m3ematerialappAlignsThememodeWithAutothemingPlatformBr,
  );
  testWidgets(
    'M3EMaterialApp toggle via controllerOf updates brightness',
    _m3ematerialappToggleViaControllerofUpdatesBrightness,
  );
  testWidgets(
    'M3ETheme.controllerOf returns controller from M3EMaterialApp',
    _m3ethemeControllerofReturnsControllerFromM3ematerialapp,
  );
  testWidgets(
    'M3EMaterialApp forwards MaterialApp constructor fields',
    _m3ematerialappForwardsMaterialappConstructorFields,
  );
  testWidgets(
    'M3EMaterialApp applies light overlay style for light brightness',
    _m3ematerialappAppliesLightOverlayStyleForLightBrightn,
  );
  testWidgets(
    'M3EMaterialApp updates overlay style after brightness toggle',
    _m3ematerialappUpdatesOverlayStyleAfterBrightnessToggle,
  );
  testWidgets(
    'M3EMaterialApp accepts drawUnderSystemBars without error',
    _m3ematerialappAcceptsDrawundersystembarsWithoutError,
  );
  test(
    'M3EMaterialApp defaults drawUnderSystemBars to false',
    _m3ematerialappDefaultsDrawundersystembarsToFalse,
  );
  testWidgets(
    'M3EMaterialApp clears bottom padding when drawUnderSystemBars is true',
    _m3ematerialappClearsBottomPaddingWhenDrawundersystembar,
  );
}

void _derivedarktemplatePreservesNonColorTokens() {
  final light = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
  final M3EThemeData dark = light.deriveDarkTemplate();

  expect(dark.brightness, Brightness.dark);
  expect(dark.typeScale, light.typeScale);
  expect(dark.spacing, light.spacing);
  expect(dark.buttonTheme, light.buttonTheme);
  expect(dark.cardTheme, light.cardTheme);
  expect(dark.colorScheme.primary, isNot(equals(light.colorScheme.primary)));
}

Future<void> _m3ethemescopeCachesDarkTemplateAcrossResolveCalls(
  WidgetTester tester,
) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(platformBrightness: Brightness.dark),
      child: M3ETheme(
        data: base,
        autoTheming: true,
        child: Builder(
          builder: (BuildContext context) {
            final M3EThemeScopeState? scope = M3EThemeScope.maybeOf(context);
            final M3EThemeData first = scope!.resolve(context);
            final M3EThemeData second = scope.resolve(context);
            expect(identical(first, second), isTrue);
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
}

Future<void> _m3ematerialappAlignsThememodeWithAutothemingPlatformBr(
  WidgetTester tester,
) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  Future<void> pumpWithBrightness(Brightness brightness) {
    return tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(platformBrightness: brightness),
        child: M3EMaterialApp(
          data: base,
          autoTheming: true,
          home: const M3EButton(onPressed: null, child: Text('Probe')),
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
}

Future<void> _m3ematerialappToggleViaControllerofUpdatesBrightness(
  WidgetTester tester,
) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    M3EMaterialApp(
      data: base,
      autoTheming: true,
      home: Builder(
        builder: (BuildContext context) {
          return M3EButton(
            onPressed: () {
              M3ETheme.controllerOf(
                context,
              )?.toggleBrightness(autoTheming: true);
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
  expect(
    tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
    ThemeMode.light,
  );

  await tester.tap(find.text('Toggle'));
  await tester.pumpAndSettle();

  expect(
    M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
    Brightness.dark,
  );
  expect(
    tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
    ThemeMode.dark,
  );
}

Future<void> _m3ethemeControllerofReturnsControllerFromM3ematerialapp(
  WidgetTester tester,
) async {
  final controller = M3EThemeController();
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    M3EMaterialApp(
      data: base,
      autoTheming: true,
      controller: controller,
      home: const M3EButton(onPressed: null, child: Text('Probe')),
    ),
  );
  await tester.pumpAndSettle();

  expect(
    M3ETheme.controllerOf(tester.element(find.byType(M3EButton))),
    controller,
  );
}

Future<void> _m3ematerialappForwardsMaterialappConstructorFields(
  WidgetTester tester,
) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
  const locale = Locale('en', 'US');
  const supportedLocales = <Locale>[Locale('en', 'US')];

  await tester.pumpWidget(
    M3EMaterialApp(
      data: base,
      locale: locale,
      showPerformanceOverlay: true,
      home: const M3EButton(onPressed: null, child: Text('Probe')),
    ),
  );
  await tester.pumpAndSettle();

  final MaterialApp app = tester.widget(find.byType(MaterialApp));
  expect(app.locale, locale);
  expect(app.supportedLocales, supportedLocales);
  expect(app.showPerformanceOverlay, isTrue);
}

Future<void> _m3ematerialappAppliesLightOverlayStyleForLightBrightn(
  WidgetTester tester,
) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    MediaQuery(
      data: const MediaQueryData(),
      child: M3EMaterialApp(
        data: base,
        autoTheming: true,
        home: const M3EButton(onPressed: null, child: Text('Probe')),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final AnnotatedRegion<SystemUiOverlayStyle> region = tester.widget(
    find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
  );
  final SystemUiOverlayStyle style = region.value;

  expect(style.statusBarColor, Colors.transparent);
  expect(style.systemNavigationBarColor, Colors.transparent);
  expect(style.statusBarIconBrightness, Brightness.dark);
  expect(style.systemNavigationBarIconBrightness, Brightness.dark);
  expect(style.statusBarBrightness, Brightness.dark);
  expect(style.systemStatusBarContrastEnforced, isFalse);
  expect(style.systemNavigationBarContrastEnforced, isFalse);
}

Future<void> _m3ematerialappUpdatesOverlayStyleAfterBrightnessToggle(
  WidgetTester tester,
) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    M3EMaterialApp(
      data: base,
      autoTheming: true,
      home: Builder(
        builder: (BuildContext context) {
          return M3EButton(
            onPressed: () {
              M3ETheme.controllerOf(
                context,
              )?.toggleBrightness(autoTheming: true);
            },
            child: const Text('Toggle'),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();

  SystemUiOverlayStyle overlayStyle() => tester
      .widget<AnnotatedRegion<SystemUiOverlayStyle>>(
        find.byType(AnnotatedRegion<SystemUiOverlayStyle>),
      )
      .value;

  expect(overlayStyle().statusBarIconBrightness, Brightness.dark);

  await tester.tap(find.text('Toggle'));
  await tester.pumpAndSettle();

  expect(overlayStyle().statusBarIconBrightness, Brightness.light);
  expect(overlayStyle().systemNavigationBarIconBrightness, Brightness.light);
  expect(overlayStyle().statusBarBrightness, Brightness.light);
}

Future<void> _m3ematerialappAcceptsDrawundersystembarsWithoutError(
  WidgetTester tester,
) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    M3EMaterialApp(
      data: base,
      drawUnderSystemBars: true,
      home: const M3EButton(onPressed: null, child: Text('Probe')),
    ),
  );
  await tester.pumpAndSettle();

  expect(find.byType(M3EMaterialApp), findsOneWidget);
  expect(find.byType(AnnotatedRegion<SystemUiOverlayStyle>), findsOneWidget);

  await tester.pumpWidget(
    M3EMaterialApp(
      data: base,
      home: const M3EButton(onPressed: null, child: Text('Probe')),
    ),
  );
  await tester.pumpAndSettle();

  expect(find.byType(M3EMaterialApp), findsOneWidget);
}

void _m3ematerialappDefaultsDrawundersystembarsToFalse() {
  final app = M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: const SizedBox.shrink(),
  );

  expect(app.drawUnderSystemBars, isFalse);
}

Future<void> _m3ematerialappClearsBottomPaddingWhenDrawundersystembar(
  WidgetTester tester,
) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
  const media = MediaQueryData(
    padding: EdgeInsets.only(bottom: 48),
    viewPadding: EdgeInsets.only(bottom: 48),
  );
  double capturedBottom = -1;

  Future<void> pump({required bool drawUnderSystemBars}) {
    return tester.pumpWidget(
      MediaQuery(
        data: media,
        child: M3EMaterialApp(
          data: base,
          drawUnderSystemBars: drawUnderSystemBars,
          home: Builder(
            builder: (BuildContext context) {
              capturedBottom = MediaQuery.paddingOf(context).bottom;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  await pump(drawUnderSystemBars: true);
  await tester.pumpAndSettle();
  expect(capturedBottom, 0);

  await pump(drawUnderSystemBars: false);
  await tester.pumpAndSettle();
  expect(capturedBottom, 48);
}
