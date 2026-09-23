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
  _registerSnackbarLayoutTests();
  _registerSnackbarBehaviorTests();
}

void _registerSnackbarLayoutTests() {
  testWidgets(
    'single-line snackbar with action stays at min height',
    _singleLineSnackbarWithActionStaysAtMinHeight,
  );
  testWidgets(
    'close icon is 12dp from the action and the trailing edge',
    _closeIconIs12dpFromTheActionAndTheTrailingEdge,
  );
  test(
    'theme defaults match the snackbar spec',
    _themeDefaultsMatchTheSnackbarSpec,
  );
  testWidgets(
    'M3ESnackbar positions above system navigation inset',
    _m3esnackbarPositionsAboveSystemNavigationInset,
  );
}

void _registerSnackbarBehaviorTests() {
  testWidgets(
    'actionable snackbar does not auto-dismiss',
    _actionableSnackbarDoesNotAutoDismiss,
  );
  testWidgets('close button dismisses snackbar', _closeButtonDismissesSnackbar);
  testWidgets(
    'one snackbar at a time replaces the previous',
    _oneSnackbarAtATimeReplacesThePrevious,
  );
  testWidgets(
    'plain snackbar auto-dismisses after default duration',
    _plainSnackbarAutoDismissesAfterDefaultDuration,
  );
}

Future<void> _singleLineSnackbarWithActionStaysAtMinHeight(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      M3ESnackbar(message: 'Draft saved', actionLabel: 'Undo', onAction: () {}),
    ),
  );

  expect(tester.getSize(find.byType(M3ESnackbar)).height, 48);
}

Future<void> _closeIconIs12dpFromTheActionAndTheTrailingEdge(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      M3ESnackbar(
        message: 'Draft saved',
        actionLabel: 'Undo',
        onAction: () {},
        showCloseButton: true,
      ),
    ),
  );

  final Rect action = tester.getRect(find.byType(M3EButton));
  final Rect icon = tester.getRect(find.byIcon(M3EIcons.close));
  final Rect bar = tester.getRect(find.byType(M3ESnackbar));

  expect(icon.left - action.right, 12);
  expect(bar.right - icon.right, 12);
  expect(bar.height, 48);
}

void _themeDefaultsMatchTheSnackbarSpec() {
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
}

Future<void> _m3esnackbarPositionsAboveSystemNavigationInset(
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

  final BuildContext hostContext = tester.element(find.byType(M3ESnackbarHost));
  final MediaQueryData media = MediaQuery.of(hostContext);
  final M3ESnackbarTheme snackTheme = M3ETheme.of(hostContext).snackBarTheme;

  expect(
    positioned.bottom,
    snackTheme.overlayBottomInset +
        media.viewPadding.bottom +
        media.viewInsets.bottom,
  );
}

Future<void> _actionableSnackbarDoesNotAutoDismiss(WidgetTester tester) async {
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
}

Future<void> _closeButtonDismissesSnackbar(WidgetTester tester) async {
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
}

Future<void> _oneSnackbarAtATimeReplacesThePrevious(WidgetTester tester) async {
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
}

Future<void> _plainSnackbarAutoDismissesAfterDefaultDuration(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      Builder(
        builder: (BuildContext context) {
          return M3EButton(
            onPressed: () => M3ESnackbar.show(context, message: 'Draft saved'),
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
}
