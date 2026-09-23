import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  tearDown(M3EFocusInteraction.resetForTest);
  group('M3EFabMenuTheme defaults', _fabMenuThemeDefaults);
  group('M3EFabMenuController', _fabMenuController);
  _registerFabMenuOpenTests();
  _registerFabMenuLayoutTests();
}

void _fabMenuThemeDefaults() {
  test('measurement tokens match spec', _measurementTokensMatchSpec);
  test(
    'closed size follows M3EFabSize when override is null',
    _closedSizeFollowsM3efabsizeWhenOverrideIsNull,
  );
  test(
    'color sets resolve filled close and container items',
    _colorSetsResolveFilledCloseAndContainerItems,
  );
}

void _fabMenuController() {
  test('updateOpen tracks isOpen', _updateOpenTracksIsOpen);
}

void _registerFabMenuOpenTests() {
  testWidgets('M3EFabMenu opens and shows items', _fabMenuOpensAndShowsItems);
  testWidgets(
    'M3EFabMenu controller open / close',
    _fabMenuControllerOpenClose,
  );
  testWidgets(
    'M3EFabMenu item container transform opens and closes',
    _fabMenuItemContainerTransformOpensAndCloses,
  );
}

void _registerFabMenuLayoutTests() {
  testWidgets(
    'focused item ring paints above neighboring pills',
    _focusedItemRingPaintsAboveNeighboringPills,
  );
  testWidgets(
    'large FAB keeps last item above close with menuOffset',
    _largeFabKeepsLastItemAboveCloseWithMenuOffset,
  );
  testWidgets(
    'short viewport keeps close hittable while items scroll',
    _shortViewportKeepsCloseHittableWhileItemsScroll,
  );
  testWidgets(
    'system back closes the menu before the route',
    _systemBackClosesTheMenuBeforeTheRoute,
  );
}

void _measurementTokensMatchSpec() {
  const theme = M3EFabMenuTheme.defaults;
  expect(theme.itemHeight, 56);
  expect(theme.itemLeading, 24);
  expect(theme.itemTrailing, 24);
  expect(theme.iconLabelGap, 8);
  expect(theme.itemGap, 4);
  expect(theme.menuOffset, 8);
  expect(theme.iconSize, 24);
  expect(theme.closeIconSize, 20);
  expect(theme.openFabContainer, 56);
  expect(theme.focusRingWidth, 3);
  expect(theme.focusRingGap, 2);
  expect(theme.itemElevation, 0);
  expect(theme.closeElevation, M3EElevation.level3);
  expect(theme.closeHoverElevation, M3EElevation.level4);
}

void _closedSizeFollowsM3efabsizeWhenOverrideIsNull() {
  const theme = M3EFabMenuTheme.defaults;
  const fabTheme = M3EFabTheme.defaults;
  expect(
    theme.resolveClosedContainer(size: M3EFabSize.regular, fabTheme: fabTheme),
    56,
  );
  expect(
    theme.resolveClosedContainer(size: M3EFabSize.medium, fabTheme: fabTheme),
    80,
  );
  expect(
    theme.resolveClosedContainer(size: M3EFabSize.large, fabTheme: fabTheme),
    96,
  );
}

void _colorSetsResolveFilledCloseAndContainerItems() {
  const theme = M3EFabMenuTheme.defaults;
  final scheme = M3EThemeData.light().colorScheme;

  expect(
    M3EFabMenuTheme.colorSetFor(M3EFabColor.primary),
    M3EFabMenuColorSet.primary,
  );
  expect(
    M3EFabMenuTheme.colorSetFor(M3EFabColor.surface),
    M3EFabMenuColorSet.primary,
  );
  expect(
    M3EFabMenuTheme.colorSetFor(M3EFabColor.secondaryFilled),
    M3EFabMenuColorSet.secondary,
  );

  expect(
    theme.itemContainerColor(scheme, M3EFabMenuColorSet.primary),
    scheme.primaryContainer,
  );
  expect(
    theme.itemForegroundColor(scheme, M3EFabMenuColorSet.primary),
    scheme.onPrimaryContainer,
  );
  expect(
    theme.closeContainerColor(scheme, M3EFabMenuColorSet.secondary),
    scheme.secondary,
  );
  expect(
    theme.closeForegroundColor(scheme, M3EFabMenuColorSet.tertiary),
    scheme.onTertiary,
  );
}

void _updateOpenTracksIsOpen() {
  final controller = M3EFabMenuController();
  expect(controller.isOpen, isFalse);
  controller.updateOpen(open: true);
  expect(controller.isOpen, isTrue);
  controller.updateOpen(open: false);
  expect(controller.isOpen, isFalse);
  controller.dispose();
}

Future<void> _fabMenuOpensAndShowsItems(WidgetTester tester) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: M3EFabMenu(
            items: const <M3EFabMenuItem>[
              M3EFabMenuItem(icon: Icon(Icons.image), label: 'Image'),
              M3EFabMenuItem(icon: Icon(Icons.mic), label: 'Audio'),
            ],
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byType(M3EFab));
  await tester.pumpAndSettle();
  expect(find.text('Image'), findsOneWidget);
  expect(find.text('Audio'), findsOneWidget);
}

Future<void> _fabMenuControllerOpenClose(WidgetTester tester) async {
  final controller = M3EFabMenuController();
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: M3EFabMenu(
            controller: controller,
            items: const <M3EFabMenuItem>[
              M3EFabMenuItem(icon: Icon(Icons.image), label: 'Image'),
              M3EFabMenuItem(icon: Icon(Icons.mic), label: 'Audio'),
            ],
          ),
        ),
      ),
    ),
  );

  controller.open();
  await tester.pumpAndSettle();
  expect(controller.isOpen, isTrue);
  expect(find.text('Image'), findsOneWidget);

  controller.close();
  await tester.pumpAndSettle();
  expect(controller.isOpen, isFalse);
  expect(find.text('Image'), findsNothing);
  controller.dispose();
}

Future<void> _fabMenuItemContainerTransformOpensAndCloses(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: M3EFabMenu(
            items: const <M3EFabMenuItem>[
              M3EFabMenuItem(
                icon: Icon(Icons.image),
                label: 'Image',
                openBuilder: _composeDestination,
              ),
              M3EFabMenuItem(icon: Icon(Icons.mic), label: 'Audio'),
            ],
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byType(M3EFab));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Image'));
  await tester.pumpAndSettle();
  expect(find.text('Compose dest'), findsOneWidget);

  await tester.tap(find.byIcon(Icons.arrow_back));
  await tester.pumpAndSettle();
  expect(find.text('Compose dest'), findsNothing);
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

Future<void> _focusedItemRingPaintsAboveNeighboringPills(
  WidgetTester tester,
) async {
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(_restoreAutomaticHighlight);

  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: M3EFabMenu(
            size: M3EFabSize.regular,
            items: const <M3EFabMenuItem>[
              M3EFabMenuItem(icon: Icon(Icons.image), label: 'Image'),
              M3EFabMenuItem(icon: Icon(Icons.videocam), label: 'Video'),
              M3EFabMenuItem(icon: Icon(Icons.mic), label: 'Audio'),
            ],
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byType(M3EFab));
  await tester.pumpAndSettle();

  M3EFocusInteraction.instance.noteKeyboardHighlight();
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pumpAndSettle();

  expect(find.byType(M3EFocusRing), findsWidgets);
  // Ring is layered in the items Stack after the pills column (paint-on-top).
  final Finder itemsStackFinder = find
      .descendant(
        of: find.byType(SingleChildScrollView),
        matching: find.byType(Stack),
      )
      .first;
  final Stack itemsStack = tester.widget(itemsStackFinder);
  expect(itemsStack.clipBehavior, Clip.none);
  expect(itemsStack.children.length, 2);
}

void _restoreAutomaticHighlight() {
  FocusManager.instance.highlightStrategy = FocusHighlightStrategy.automatic;
}

Future<void> _largeFabKeepsLastItemAboveCloseWithMenuOffset(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        body: Align(
          alignment: Alignment.bottomCenter,
          child: M3EFabMenu(
            size: M3EFabSize.large,
            items: const <M3EFabMenuItem>[
              M3EFabMenuItem(icon: Icon(Icons.image), label: 'Image'),
              M3EFabMenuItem(icon: Icon(Icons.videocam), label: 'Video'),
              M3EFabMenuItem(icon: Icon(Icons.mic), label: 'Audio'),
            ],
          ),
        ),
      ),
    ),
  );

  await tester.tap(find.byType(M3EFab));
  await tester.pumpAndSettle();

  final lastItem = tester.getBottomRight(find.text('Audio'));
  // Overlay close is the last M3EFab; its top must sit below the item + gap.
  final closeTop = tester.getTopRight(find.byType(M3EFab).last).dy;
  expect(lastItem.dy, lessThanOrEqualTo(closeTop - 8));
}

Future<void> _shortViewportKeepsCloseHittableWhileItemsScroll(
  WidgetTester tester,
) async {
  await tester.binding.setSurfaceSize(const Size(400, 320));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Scaffold(
        body: const SizedBox.shrink(),
        floatingActionButton: M3EFabMenu(
          items: const <M3EFabMenuItem>[
            M3EFabMenuItem(icon: Icon(Icons.one_k), label: 'One'),
            M3EFabMenuItem(icon: Icon(Icons.two_k), label: 'Two'),
            M3EFabMenuItem(icon: Icon(Icons.three_k), label: 'Three'),
            M3EFabMenuItem(icon: Icon(Icons.four_k), label: 'Four'),
            M3EFabMenuItem(icon: Icon(Icons.five_k), label: 'Five'),
            M3EFabMenuItem(icon: Icon(Icons.six_k), label: 'Six'),
          ],
        ),
      ),
    ),
  );

  await tester.tap(find.byType(M3EFab).first);
  await tester.pumpAndSettle();
  expect(find.byType(SingleChildScrollView), findsWidgets);

  // Close remains tappable (overlay close FAB).
  await tester.tap(find.byType(M3EFab).last);
  await tester.pumpAndSettle();
  expect(find.text('One'), findsNothing);
}

Future<void> _systemBackClosesTheMenuBeforeTheRoute(WidgetTester tester) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: TextButton(
              onPressed: () => _pushFabMenuRoute(context),
              child: const Text('Root'),
            ),
          );
        },
      ),
    ),
  );
  await tester.tap(find.text('Root'));
  await tester.pumpAndSettle();

  await tester.tap(find.byType(M3EFab));
  await tester.pumpAndSettle();
  expect(find.text('Image'), findsOneWidget);

  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();

  expect(find.text('Image'), findsNothing);
  expect(find.byType(M3EFabMenu), findsOneWidget);

  await tester.binding.handlePopRoute();
  await tester.pumpAndSettle();

  expect(find.byType(M3EFabMenu), findsNothing);
  expect(find.text('Root'), findsOneWidget);
}

void _pushFabMenuRoute(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: _fabMenuRoute));
}

Widget _fabMenuRoute(BuildContext context) {
  return Scaffold(
    body: Align(
      alignment: Alignment.bottomCenter,
      child: M3EFabMenu(
        items: const <M3EFabMenuItem>[
          M3EFabMenuItem(icon: Icon(Icons.image), label: 'Image'),
          M3EFabMenuItem(icon: Icon(Icons.mic), label: 'Audio'),
        ],
      ),
    ),
  );
}
