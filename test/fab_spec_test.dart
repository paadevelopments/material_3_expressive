import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('M3EFabTheme metrics', () {
    const theme = M3EFabTheme.defaults;
    final scheme = M3EThemeData.light().colorScheme;

    test('size tokens match M3E expressive tables', () {
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
    });

    test('filled colors use primary roles', () {
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
    });

    test('disabled uses on-surface alphas', () {
      final disabled = theme.resolve(
        size: M3EFabSize.regular,
        color: M3EFabColor.primary,
        scheme: scheme,
        enabled: false,
      );
      expect(disabled.background.a, closeTo(0.1, 0.001));
      expect(disabled.foreground.a, closeTo(0.38, 0.001));
    });
  });

  group('M3EFabController', () {
    test('show / hide toggles visibility', () {
      final controller = M3EFabController();
      expect(controller.isVisible, isTrue);
      controller.hide();
      expect(controller.isVisible, isFalse);
      controller.show();
      expect(controller.isVisible, isTrue);
      controller.dispose();
    });

    testWidgets('scroll notifications hide and show', (tester) async {
      final controller = M3EFabController(scrollThreshold: 4);
      await tester.pumpWidget(
        M3EMaterialApp(
          data: M3EThemeData.light(),
          home: Scaffold(
            body: M3EFabScrollVisibility(
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
      expect(controller.isVisible, isFalse);

      await tester.drag(find.byType(ListView), const Offset(0, 80));
      await tester.pumpAndSettle();
      expect(controller.isVisible, isTrue);
      controller.dispose();
    });
  });

  testWidgets('M3EFab appear morph starts below resting scale', (tester) async {
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(),
        home: Scaffold(
          body: Center(
            child: M3EFab(
              appear: true,
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    final transforms = tester.widgetList<Transform>(
      find.descendant(
        of: find.byType(M3EFab),
        matching: find.byType(Transform),
      ),
    );
    final scales = transforms
        .map((Transform t) => t.transform.storage[0])
        .where((double s) => s < 0.999)
        .toList();
    expect(scales, isNotEmpty);

    await tester.pumpAndSettle();
  });

  testWidgets('M3EFab container transform opens and closes', (tester) async {
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(),
        home: Scaffold(
          body: Center(
            child: M3EFab(
              icon: const Icon(Icons.add),
              tooltip: 'Add',
              openBuilder: (BuildContext context) {
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
              },
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
  });
}
