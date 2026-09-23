import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('M3EExtendedFabTheme metrics', _extendedFabThemeMetrics);
  group('M3EExtendedFab colors', _extendedFabColors);
  group('M3EExtendedFabController', _extendedFabController);
  _registerExtendedFabWidgetTests();
}

void _extendedFabThemeMetrics() {
  test(
    'size tokens match M3E expressive tables',
    _sizeTokensMatchExpressiveTables,
  );
  test('min width and focus defaults', _minWidthAndFocusDefaults);
}

void _extendedFabColors() {
  test(
    'container vs filled resolve via M3EFabColor',
    _containerVsFilledResolveViaM3efabcolor,
  );
}

void _extendedFabController() {
  test('expand / collapse toggles extended', _expandCollapseTogglesExtended);
  testWidgets(
    'scroll notifications collapse and expand',
    _scrollNotificationsCollapseAndExpand,
  );
}

void _registerExtendedFabWidgetTests() {
  testWidgets(
    'M3EExtendedFab builds with optional icon and label-only',
    _extendedFabBuildsWithOptionalIconAndLabelOnly,
  );
  testWidgets(
    'M3EExtendedFab sizes use themed heights',
    _extendedFabSizesUseThemedHeights,
  );
  testWidgets(
    'M3EExtendedFab container transform opens and closes',
    _extendedFabContainerTransformOpensAndCloses,
  );
}

void _sizeTokensMatchExpressiveTables() {
  const theme = M3EExtendedFabTheme.defaults;
  final small = theme.resolve(M3EExtendedFabSize.small);
  expect(small.height, 56);
  expect(small.iconSize, 24);
  expect(small.cornerRadius, 16);
  expect(small.leadingSpace, 16);
  expect(small.trailingSpace, 16);
  expect(small.iconLabelGap, 8);
  expect(small.labelRole, M3ETypeRole.titleMedium);

  final medium = theme.resolve(M3EExtendedFabSize.medium);
  expect(medium.height, 80);
  expect(medium.iconSize, 28);
  expect(medium.cornerRadius, 20);
  expect(medium.leadingSpace, 26);
  expect(medium.trailingSpace, 26);
  expect(medium.iconLabelGap, 12);
  expect(medium.labelRole, M3ETypeRole.titleLarge);

  final large = theme.resolve(M3EExtendedFabSize.large);
  expect(large.height, 96);
  expect(large.iconSize, 36);
  expect(large.cornerRadius, 28);
  expect(large.leadingSpace, 28);
  expect(large.trailingSpace, 28);
  expect(large.iconLabelGap, 16);
  expect(large.labelRole, M3ETypeRole.headlineSmall);
}

void _minWidthAndFocusDefaults() {
  const theme = M3EExtendedFabTheme.defaults;
  expect(theme.minWidth, 80);
  expect(theme.focusRingWidth, 3);
  expect(theme.focusRingGap, 2);
}

void _containerVsFilledResolveViaM3efabcolor() {
  final scheme = M3EThemeData.light().colorScheme;
  const fabTheme = M3EFabTheme.defaults;

  final filled = fabTheme.resolve(
    size: M3EFabSize.regular,
    color: M3EFabColor.primaryFilled,
    scheme: scheme,
  );
  expect(filled.background, scheme.primary);
  expect(filled.foreground, scheme.onPrimary);

  final container = fabTheme.resolve(
    size: M3EFabSize.regular,
    color: M3EFabColor.primary,
    scheme: scheme,
  );
  expect(container.background, scheme.primaryContainer);
  expect(container.foreground, scheme.onPrimaryContainer);
}

void _expandCollapseTogglesExtended() {
  final controller = M3EExtendedFabController();
  expect(controller.isExtended, isTrue);
  controller.collapse();
  expect(controller.isExtended, isFalse);
  controller.expand();
  expect(controller.isExtended, isTrue);
  controller.dispose();
}

Future<void> _scrollNotificationsCollapseAndExpand(WidgetTester tester) async {
  final controller = M3EExtendedFabController(scrollThreshold: 4);
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        body: M3EExtendedFabScrollVisibility(
          controller: controller,
          child: ListView.builder(itemCount: 40, itemBuilder: _scrollItem),
        ),
      ),
    ),
  );

  await tester.drag(find.byType(ListView), const Offset(0, -80));
  await tester.pumpAndSettle();
  expect(controller.isExtended, isFalse);

  await tester.drag(find.byType(ListView), const Offset(0, 80));
  await tester.pumpAndSettle();
  expect(controller.isExtended, isTrue);
  controller.dispose();
}

Widget _scrollItem(BuildContext context, int i) {
  return SizedBox(height: 48, child: Text('$i'));
}

Future<void> _extendedFabBuildsWithOptionalIconAndLabelOnly(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: const Scaffold(
        body: Column(
          children: [
            M3EExtendedFab(
              label: 'Compose',
              icon: Icon(Icons.edit),
              onPressed: _noop,
            ),
            M3EExtendedFab(label: 'Label only', onPressed: _noop),
          ],
        ),
      ),
    ),
  );

  expect(find.text('Compose'), findsOneWidget);
  expect(find.text('Label only'), findsOneWidget);
  expect(find.byIcon(Icons.edit), findsOneWidget);
}

Future<void> _extendedFabSizesUseThemedHeights(WidgetTester tester) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: const Scaffold(
        body: Center(
          child: M3EExtendedFab(
            label: 'Compose',
            icon: Icon(Icons.edit),
            size: M3EExtendedFabSize.medium,
            onPressed: _noop,
          ),
        ),
      ),
    ),
  );

  final Size size = tester.getSize(find.byType(M3EExtendedFab));
  expect(size.height, 80);
  expect(size.width, greaterThanOrEqualTo(80));
}

Future<void> _extendedFabContainerTransformOpensAndCloses(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: const Scaffold(
        body: Center(
          child: M3EExtendedFab(
            label: 'Compose',
            icon: Icon(Icons.edit),
            openBuilder: _composeDestination,
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byType(M3EExtendedFab));
  await tester.pumpAndSettle();
  expect(find.text('Compose dest'), findsOneWidget);

  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
  expect(find.text('Compose dest'), findsNothing);
  expect(find.byType(M3EExtendedFab), findsOneWidget);
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
    body: const Center(child: Text('Compose dest')),
  );
}

void _noop() {}
