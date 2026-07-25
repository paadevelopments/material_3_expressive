import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'M3EThemeController toggles wrapped component brightness',
    _m3ethemecontrollerTogglesWrappedComponentBrightness,
  );
  testWidgets(
    'M3EThemeController updates card background color after toggle',
    _m3ethemecontrollerUpdatesCardBackgroundColorAfterToggl,
  );
  testWidgets(
    'autoTheming toggle inverts platform brightness',
    _autothemingToggleInvertsPlatformBrightness,
  );
  testWidgets(
    'autoTheming toggle keeps tracking platform brightness when OS changes',
    _autothemingToggleKeepsTrackingPlatformBrightnessWhenO,
  );
  testWidgets(
    'toggle without autoTheming locks absolute brightness',
    _toggleWithoutAutothemingLocksAbsoluteBrightness,
  );
}

Future<void> _m3ethemecontrollerTogglesWrappedComponentBrightness(
  WidgetTester tester,
) async {
  final controller = M3EThemeController();
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    MaterialApp(
      theme: base.toThemeData(),
      home: M3ETheme(
        data: base,
        controller: controller,
        child: const M3EButton(onPressed: null, child: Text('Probe')),
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
}

Future<void> _m3ethemecontrollerUpdatesCardBackgroundColorAfterToggl(
  WidgetTester tester,
) async {
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

  M3EThemeData theme = M3ETheme.of(tester.element(find.byType(M3ECard)));
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
}

Future<void> _autothemingToggleInvertsPlatformBrightness(
  WidgetTester tester,
) async {
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
            child: const M3EButton(onPressed: null, child: Text('Probe')),
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
}

Future<void> _autothemingToggleKeepsTrackingPlatformBrightnessWhenO(
  WidgetTester tester,
) async {
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
            child: const M3EButton(onPressed: null, child: Text('Probe')),
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
}

Future<void> _toggleWithoutAutothemingLocksAbsoluteBrightness(
  WidgetTester tester,
) async {
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
          child: const M3EButton(onPressed: null, child: Text('Probe')),
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
          child: const M3EButton(onPressed: null, child: Text('Probe')),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  expect(
    M3ETheme.of(tester.element(find.byType(M3EButton))).brightness,
    Brightness.dark,
  );
}
