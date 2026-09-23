import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('M3EFabTheme metrics', _fabThemeMetrics);
  group('M3EFabController', _fabController);
  _registerFabWidgetTests();
}

void _fabThemeMetrics() {
  test(
    'size tokens match M3E expressive tables',
    _sizeTokensMatchExpressiveTables,
  );
  test('filled colors use primary roles', _filledColorsUsePrimaryRoles);
  test('disabled uses on-surface alphas', _disabledUsesOnSurfaceAlphas);
}

void _fabController() {
  test('show / hide toggles visibility', _showHideTogglesVisibility);
  testWidgets(
    'scroll notifications hide and show',
    _scrollNotificationsHideAndShow,
  );
}

void _registerFabWidgetTests() {
  testWidgets(
    'M3EFab appear morph starts below resting scale',
    _appearMorphStartsBelowRestingScale,
  );
  testWidgets(
    'M3EFab container transform opens and closes',
    _containerTransformOpensAndCloses,
  );
}

void _sizeTokensMatchExpressiveTables() {
  const theme = M3EFabTheme.defaults;
  final scheme = M3EThemeData.light().colorScheme;

  expect(
    theme
        .resolve(
          size: M3EFabSize.small,
          color: M3EFabColor.primary,
          scheme: scheme,
        )
        .container,
    40,
  );
  expect(
    theme
        .resolve(
          size: M3EFabSize.regular,
          color: M3EFabColor.primary,
          scheme: scheme,
        )
        .container,
    56,
  );
  expect(
    theme
        .resolve(
          size: M3EFabSize.medium,
          color: M3EFabColor.primary,
          scheme: scheme,
        )
        .container,
    80,
  );
  expect(
    theme
        .resolve(
          size: M3EFabSize.medium,
          color: M3EFabColor.primary,
          scheme: scheme,
        )
        .iconSize,
    28,
  );
  expect(
    theme
        .resolve(
          size: M3EFabSize.medium,
          color: M3EFabColor.primary,
          scheme: scheme,
        )
        .radius,
    20,
  );
  expect(
    theme
        .resolve(
          size: M3EFabSize.large,
          color: M3EFabColor.primary,
          scheme: scheme,
        )
        .container,
    96,
  );
}

void _filledColorsUsePrimaryRoles() {
  const theme = M3EFabTheme.defaults;
  final scheme = M3EThemeData.light().colorScheme;

  final filled = theme.resolve(
    size: M3EFabSize.regular,
    color: M3EFabColor.primaryFilled,
    scheme: scheme,
  );
  expect(filled.background, scheme.primary);
  expect(filled.foreground, scheme.onPrimary);

  final container = theme.resolve(
    size: M3EFabSize.regular,
    color: M3EFabColor.primary,
    scheme: scheme,
  );
  expect(container.background, scheme.primaryContainer);
  expect(container.foreground, scheme.onPrimaryContainer);
}

void _disabledUsesOnSurfaceAlphas() {
  const theme = M3EFabTheme.defaults;
  final scheme = M3EThemeData.light().colorScheme;

  final disabled = theme.resolve(
    size: M3EFabSize.regular,
    color: M3EFabColor.primary,
    scheme: scheme,
    enabled: false,
  );
  expect(disabled.background.a, closeTo(0.1, 0.001));
  expect(disabled.foreground.a, closeTo(0.38, 0.001));
}

void _showHideTogglesVisibility() {
  final controller = M3EFabController();
  expect(controller.isVisible, isTrue);
  controller.hide();
  expect(controller.isVisible, isFalse);
  controller.show();
  expect(controller.isVisible, isTrue);
  controller.dispose();
}

Future<void> _scrollNotificationsHideAndShow(WidgetTester tester) async {
  final controller = M3EFabController(scrollThreshold: 4);
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        body: M3EFabScrollVisibility(
          controller: controller,
          child: ListView.builder(itemCount: 40, itemBuilder: _scrollItem),
        ),
      ),
    ),
  );

  await tester.drag(find.byType(ListView), const Offset(0, -80));
  await tester.pumpAndSettle();
  expect(controller.isVisible, isFalse);

  await tester.drag(find.byType(ListView), const Offset(0, 80));
  await tester.pumpAndSettle();
  expect(controller.isVisible, isTrue);
  controller.dispose();
}

Widget _scrollItem(BuildContext context, int i) {
  return SizedBox(height: 48, child: Text('$i'));
}

Future<void> _appearMorphStartsBelowRestingScale(WidgetTester tester) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: const Scaffold(
        body: Center(
          child: M3EFab(
            appear: true,
            icon: Icon(Icons.add),
            onPressed: _noop,
          ),
        ),
      ),
    ),
  );

  await tester.pump();
  final transforms = tester.widgetList<Transform>(
    find.descendant(of: find.byType(M3EFab), matching: find.byType(Transform)),
  );
  final scales = transforms
      .map((Transform t) => t.transform.storage[0])
      .where(_belowRestingScale)
      .toList();
  expect(scales, isNotEmpty);

  await tester.pumpAndSettle();
}

bool _belowRestingScale(double scale) => scale < 0.999;

Future<void> _containerTransformOpensAndCloses(WidgetTester tester) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: const Scaffold(
        body: Center(
          child: M3EFab(
            icon: Icon(Icons.add),
            tooltip: 'Add',
            openBuilder: _composeDestination,
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byType(M3EFab));
  await tester.pumpAndSettle();
  expect(find.text('Compose'), findsOneWidget);

  // Navigator back reverses the transform route (not just overlay).
  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
  expect(find.text('Compose'), findsNothing);
  expect(find.byType(M3EFab), findsOneWidget);
}

Widget _composeDestination(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Opened'),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
    ),
    body: const Center(child: Text('Compose')),
  );
}

void _noop() {}
