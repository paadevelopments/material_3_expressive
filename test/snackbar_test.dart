import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  testWidgets('M3ESnackbar positions above system navigation inset',
      (WidgetTester tester) async {
    const double navigationInset = 34;
    tester.view.viewPadding = const FakeViewPadding(bottom: navigationInset);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        drawUnderSystemBars: true,
        home: Builder(
          builder: (BuildContext context) {
            return Center(
              child: M3EButton(
                onPressed: () => M3ESnackbar.show(
                  context,
                  message: 'Draft saved',
                ),
                child: const Text('Show snackbar'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show snackbar'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    final Positioned positioned = tester.widget<Positioned>(
      find.descendant(
        of: find.byType(M3ESnackbarHost),
        matching: find.byType(Positioned),
      ),
    );

    final BuildContext hostContext = tester.element(find.byType(M3ESnackbarHost));
    final MediaQueryData media = MediaQuery.of(hostContext);
    final M3ESnackbarTheme snackTheme = M3ETheme.of(hostContext).snackBarTheme;

    expect(
      positioned.bottom,
      snackTheme.overlayBottomInset +
          media.viewPadding.bottom +
          media.viewInsets.bottom,
    );
  });
}
