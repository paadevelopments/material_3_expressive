import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  test('theme defaults match the snackbar spec', () {
    const theme = M3ESnackbarTheme.defaults;
    expect(theme.singleLineMinHeight, 48);
    expect(theme.twoLineMinHeight, 68);
    expect(theme.startPadding, 16);
    expect(theme.endPaddingWithTrailing, 8);
    expect(theme.closeIconSize, 24);
    expect(theme.closePadding, 12);
    expect(theme.elevation, M3EElevation.level3);
    expect(theme.defaultDuration, const Duration(seconds: 4));
    expect(theme.hoverStateOpacity, 0.08);
    expect(theme.focusStateOpacity, 0.1);
    expect(theme.pressedStateOpacity, 0.1);

    final scheme = M3EThemeData.light().colorScheme;
    final type = M3EThemeData.light().typeScale;
    expect(theme.containerColor(scheme), scheme.inverseSurface);
    expect(theme.messageStyle(type, scheme).color, scheme.onInverseSurface);
    expect(theme.actionStyle(type, scheme).color, scheme.inversePrimary);
    expect(theme.closeIconColor(scheme), scheme.onInverseSurface);
  });

  testWidgets('M3ESnackbar positions above system navigation inset', (
    WidgetTester tester,
  ) async {
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
                onPressed: () =>
                    M3ESnackbar.show(context, message: 'Draft saved'),
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

    final BuildContext hostContext = tester.element(
      find.byType(M3ESnackbarHost),
    );
    final MediaQueryData media = MediaQuery.of(hostContext);
    final M3ESnackbarTheme snackTheme = M3ETheme.of(hostContext).snackBarTheme;

    expect(
      positioned.bottom,
      snackTheme.overlayBottomInset +
          media.viewPadding.bottom +
          media.viewInsets.bottom,
    );
  });

  testWidgets('actionable snackbar does not auto-dismiss', (tester) async {
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () => M3ESnackbar.show(
                context,
                message: 'Photo deleted',
                actionLabel: 'Undo',
                onAction: () {},
              ),
              child: const Text('Show'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Photo deleted'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    expect(find.text('Photo deleted'), findsOneWidget);
  });

  testWidgets('close button dismisses snackbar', (tester) async {
    var closed = false;
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () => M3ESnackbar.show(
                context,
                message: 'Saved to drafts',
                showCloseButton: true,
                onClose: () => closed = true,
              ),
              child: const Text('Show'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Saved to drafts'), findsOneWidget);

    await tester.tap(find.byIcon(M3EIcons.close));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(closed, isTrue);
    expect(find.text('Saved to drafts'), findsNothing);
  });

  testWidgets('one snackbar at a time replaces the previous', (tester) async {
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (BuildContext context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                M3EButton(
                  onPressed: () =>
                      M3ESnackbar.show(context, message: 'First message'),
                  child: const Text('Show first'),
                ),
                M3EButton(
                  onPressed: () =>
                      M3ESnackbar.show(context, message: 'Second message'),
                  child: const Text('Show second'),
                ),
              ],
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show first'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('First message'), findsOneWidget);

    await tester.tap(find.text('Show second'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Second message'), findsOneWidget);
    expect(find.text('First message'), findsNothing);
    expect(find.byType(M3ESnackbarHost), findsOneWidget);
  });

  testWidgets('plain snackbar auto-dismisses after default duration', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        Builder(
          builder: (BuildContext context) {
            return M3EButton(
              onPressed: () =>
                  M3ESnackbar.show(context, message: 'Draft saved'),
              child: const Text('Show'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Draft saved'), findsOneWidget);

    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Draft saved'), findsNothing);
  });
}
