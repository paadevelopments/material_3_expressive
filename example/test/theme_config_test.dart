// Widget tests for the theme config screen and its live theme updates.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_3_expressive_example/main.dart';
import 'package:material_3_expressive_example/theme/example_theme_settings.dart';

void main() {
  testWidgets('Palette action opens the theme config screen', (
    WidgetTester tester,
  ) async {
    await _openThemeConfig(tester);

    expect(find.text('Auto theming'), findsOneWidget);
    expect(find.text('Dynamic color'), findsOneWidget);
    expect(find.text('Seed color'), findsOneWidget);
    expect(find.text('Type'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Seed choices appear once dynamic color is off', (
    WidgetTester tester,
  ) async {
    await _openThemeConfig(tester);

    expect(find.text('Turn dynamic color off to pick a seed.'), findsOneWidget);

    await _toggle(tester, 'Dynamic color');

    expect(
      find.text('Generates the scheme for both brightnesses.'),
      findsOneWidget,
    );
    for (final String label in ExampleThemeSettings.seedLabels) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('Picking a seed recolors the app immediately', (
    WidgetTester tester,
  ) async {
    await _openThemeConfig(tester);
    await _toggle(tester, 'Dynamic color');

    final Color before = _scheme(tester).primary;

    await tester.tap(find.text(ExampleThemeSettings.seedLabels.last));
    await tester.pumpAndSettle();

    expect(_scheme(tester).primary, isNot(before));
    expect(tester.takeException(), isNull);
  });

  testWidgets('Picking Flex applies the family immediately', (
    WidgetTester tester,
  ) async {
    await _openThemeConfig(tester);

    await tester.ensureVisible(find.text('Flex'));
    await tester.tap(find.text('Flex'));
    await tester.pumpAndSettle();

    expect(_typeScale(tester).bodyMedium.fontFamily, 'Roboto Flex');
    expect(tester.takeException(), isNull);
  });

  testWidgets('Emphasized style applies Flex variations', (
    WidgetTester tester,
  ) async {
    await _openThemeConfig(tester);

    await tester.ensureVisible(find.text('Flex'));
    await tester.tap(find.text('Flex'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Emphasized'));
    await tester.tap(find.text('Emphasized'));
    await tester.pumpAndSettle();

    expect(
      _typeScale(tester).bodyMedium.fontVariations,
      M3ETypeVariations.emphasized.variations,
    );
    expect(tester.takeException(), isNull);
  });
}

Future<void> _openThemeConfig(WidgetTester tester) async {
  await tester.pumpWidget(const ExampleApp());
  await tester.pumpAndSettle();

  await tester.tap(find.byTooltip('Theme settings'));
  await tester.pumpAndSettle();
}

Future<void> _toggle(WidgetTester tester, String semanticLabel) async {
  await tester.tap(find.bySemanticsLabel(semanticLabel));
  await tester.pumpAndSettle();
}

M3EColorScheme _scheme(WidgetTester tester) {
  return M3ETheme.of(tester.element(find.text('Seed color'))).colorScheme;
}

M3ETypeScale _typeScale(WidgetTester tester) {
  return M3ETheme.of(tester.element(find.text('Type'))).typeScale;
}
