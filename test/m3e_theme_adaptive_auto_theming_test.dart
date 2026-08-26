import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'static M3ETheme defaults to light when adaptive fields are null',
    _staticM3ethemeDefaultsToLightWhenAdaptiveFieldsAreN,
  );
  testWidgets(
    'autoTheming resolves platform brightness without app setState',
    _autothemingResolvesPlatformBrightnessWithoutAppSetstat,
  );
  testWidgets(
    'autoTheming updates when platform brightness changes without setState',
    _autothemingUpdatesWhenPlatformBrightnessChangesWithout,
  );
  testWidgets(
    'autoTheming updates card painted color when platform brightness changes without setState',
    _autothemingUpdatesCardPaintedColorWhenPlatformBrightn,
  );
  testWidgets(
    'autoTheming updates icon button painted color when platform brightness changes without setState',
    _autothemingUpdatesIconButtonPaintedColorWhenPlatform,
  );
  testWidgets(
    'autoTheming updates navigation bar painted color when platform brightness changes without setState',
    _autothemingUpdatesNavigationBarPaintedColorWhenPlatfo,
  );
}

Future<void> _staticM3ethemeDefaultsToLightWhenAdaptiveFieldsAreN(
  WidgetTester tester,
) async {
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
}

Future<void> _autothemingResolvesPlatformBrightnessWithoutAppSetstat(
  WidgetTester tester,
) async {
  final base = M3EThemeData.light(seedColor: const Color(0xFF6750A4));

  await tester.pumpWidget(
    MaterialApp(
      theme: base.toThemeData(),
      home: MediaQuery(
        data: const MediaQueryData(platformBrightness: Brightness.dark),
        child: M3ETheme(
          data: base,
          autoTheming: true,
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
}

Future<void> _autothemingUpdatesWhenPlatformBrightnessChangesWithout(
  WidgetTester tester,
) async {
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
            child: const M3EButton(onPressed: null, child: Text('Probe')),
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
}

Future<void> _autothemingUpdatesCardPaintedColorWhenPlatformBrightn(
  WidgetTester tester,
) async {
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
  M3EThemeData lightTheme = M3ETheme.of(tester.element(find.byType(M3ECard)));
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

  final M3EThemeData darkTheme = M3ETheme.of(
    tester.element(find.byType(M3ECard)),
  );
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
}

Future<void> _autothemingUpdatesIconButtonPaintedColorWhenPlatform(
  WidgetTester tester,
) async {
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
  final Color lightPrimary = M3ETheme.of(
    tester.element(find.byType(M3EIconButton)),
  ).colorScheme.primary;
  final ButtonStyle lightStyle = tester
      .widget<IconButton>(iconButtonFinder)
      .style!;
  expect(lightStyle.backgroundColor!.resolve(<WidgetState>{}), lightPrimary);

  await pumpWithBrightness(Brightness.dark);
  await tester.pump();

  final Color darkPrimary = M3ETheme.of(
    tester.element(find.byType(M3EIconButton)),
  ).colorScheme.primary;
  final ButtonStyle darkStyle = tester
      .widget<IconButton>(iconButtonFinder)
      .style!;
  expect(darkStyle.backgroundColor!.resolve(<WidgetState>{}), darkPrimary);
  expect(darkPrimary, isNot(equals(lightPrimary)));
}

Future<void> _autothemingUpdatesNavigationBarPaintedColorWhenPlatfo(
  WidgetTester tester,
) async {
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
            child: const M3ENavigationBar(destinations: destinations),
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
  final M3EThemeData lightTheme = M3ETheme.of(
    tester.element(find.byType(M3ENavigationBar)),
  );
  final Color lightBg = lightTheme.navigationBarTheme.containerColor(
    lightTheme.colorScheme,
  );
  expect(tester.widget<Material>(materialFinder.first).color, lightBg);

  await pumpWithBrightness(Brightness.dark);
  await tester.pump();

  final M3EThemeData darkTheme = M3ETheme.of(
    tester.element(find.byType(M3ENavigationBar)),
  );
  final Color darkBg = darkTheme.navigationBarTheme.containerColor(
    darkTheme.colorScheme,
  );
  expect(tester.widget<Material>(materialFinder.first).color, darkBg);
  expect(darkBg, isNot(equals(lightBg)));
}
