import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M3EExtendedFabTheme metrics', () {
    const theme = M3EExtendedFabTheme.defaults;

    test('size tokens match M3E expressive tables', () {
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
    });

    test('min width and focus defaults', () {
      expect(theme.minWidth, 80);
      expect(theme.focusRingWidth, 3);
      expect(theme.focusRingGap, 2);
    });
  });

  group('M3EExtendedFab colors', () {
    final scheme = M3EThemeData.light().colorScheme;
    const fabTheme = M3EFabTheme.defaults;

    test('container vs filled resolve via M3EFabColor', () {
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
    });
  });

  group('M3EExtendedFabController', () {
    test('expand / collapse toggles extended', () {
      final controller = M3EExtendedFabController();
      expect(controller.isExtended, isTrue);
      controller.collapse();
      expect(controller.isExtended, isFalse);
      controller.expand();
      expect(controller.isExtended, isTrue);
      controller.dispose();
    });

    testWidgets('scroll notifications collapse and expand', (tester) async {
      final controller = M3EExtendedFabController(scrollThreshold: 4);
      await tester.pumpWidget(
        M3EMaterialApp(
          data: M3EThemeData.light(),
          home: Scaffold(
            body: M3EExtendedFabScrollVisibility(
              controller: controller,
              child: ListView.builder(
                itemCount: 40,
                itemBuilder: (_, int i) =>
                    SizedBox(height: 48, child: Text('$i')),
              ),
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
    });
  });

  testWidgets('M3EExtendedFab builds with optional icon and label-only', (
    tester,
  ) async {
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              M3EExtendedFab(
                label: 'Compose',
                icon: const Icon(Icons.edit),
                onPressed: () {},
              ),
              M3EExtendedFab(label: 'Label only', onPressed: () {}),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Compose'), findsOneWidget);
    expect(find.text('Label only'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });

  testWidgets('M3EExtendedFab sizes use themed heights', (tester) async {
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(),
        home: Scaffold(
          body: Center(
            child: M3EExtendedFab(
              label: 'Compose',
              icon: const Icon(Icons.edit),
              size: M3EExtendedFabSize.medium,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    final Size size = tester.getSize(find.byType(M3EExtendedFab));
    expect(size.height, 80);
    expect(size.width, greaterThanOrEqualTo(80));
  });

  testWidgets('M3EExtendedFab container transform opens and closes', (
    tester,
  ) async {
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(),
        home: Scaffold(
          body: Center(
            child: M3EExtendedFab(
              label: 'Compose',
              icon: const Icon(Icons.edit),
              openBuilder: (BuildContext context) {
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
              },
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
  });
}
