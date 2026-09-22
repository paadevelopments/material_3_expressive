import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child, {M3EThemeData? theme}) {
  return MaterialApp(
    home: M3ETheme(
      data: theme ?? M3EThemeData.light(),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  testWidgets('uses the default container and indicator sizes', (tester) async {
    await tester.pumpWidget(_host(const M3ELoadingIndicator()));

    expect(
      tester.getSize(find.byType(M3EExpressiveLoadingIndicator)),
      const Size(48, 48),
    );
    expect(
      tester
          .widget<M3EExpressiveLoadingIndicator>(
            find.byType(M3EExpressiveLoadingIndicator),
          )
          .indicatorSize,
      38,
    );
  });

  testWidgets('instance dimensions override theme dimensions', (tester) async {
    final theme = M3EThemeData.light().copyWith(
      loadingIndicatorTheme: const M3ELoadingIndicatorTheme(
        containerWidth: 64,
        containerHeight: 64,
        activeIndicatorSize: 52,
      ),
    );
    await tester.pumpWidget(
      _host(
        const M3ELoadingIndicator(
          indicatorSize: 24,
          containerWidth: 72,
          containerHeight: 56,
        ),
        theme: theme,
      ),
    );

    expect(
      tester.getSize(find.byType(M3EExpressiveLoadingIndicator)),
      const Size(72, 56),
    );
    expect(
      tester
          .widget<M3EExpressiveLoadingIndicator>(
            find.byType(M3EExpressiveLoadingIndicator),
          )
          .indicatorSize,
      24,
    );
  });

  testWidgets('uses theme dimensions', (tester) async {
    final theme = M3EThemeData.light().copyWith(
      loadingIndicatorTheme: const M3ELoadingIndicatorTheme(
        containerWidth: 60,
        containerHeight: 44,
        activeIndicatorSize: 30,
      ),
    );
    await tester.pumpWidget(_host(const M3ELoadingIndicator(), theme: theme));

    expect(
      tester.getSize(find.byType(M3EExpressiveLoadingIndicator)),
      const Size(60, 44),
    );
    expect(
      tester
          .widget<M3EExpressiveLoadingIndicator>(
            find.byType(M3EExpressiveLoadingIndicator),
          )
          .indicatorSize,
      30,
    );
  });

  testWidgets('uses the custom container shape', (tester) async {
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
    await tester.pumpWidget(
      _host(const M3ELoadingIndicator(containerShape: shape)),
    );

    final decoratedBox = tester.widget<DecoratedBox>(
      find.byType(DecoratedBox).first,
    );
    final decoration = decoratedBox.decoration as ShapeDecoration;
    expect(decoration.shape, shape);
  });

  testWidgets('exposes loading semantics', (tester) async {
    await tester.pumpWidget(
      _host(
        const M3ELoadingIndicator(
          semanticLabel: 'Loading',
          semanticValue: 'In progress',
        ),
      ),
    );

    final semantics = tester.getSemantics(
      find.byType(M3EExpressiveLoadingIndicator),
    );
    expect(semantics.label, 'Loading');
    expect(semantics.value, 'In progress');
  });

  testWidgets('resolves default and contained colors from theme', (
    tester,
  ) async {
    final theme = M3EThemeData.light();

    await tester.pumpWidget(_host(const M3ELoadingIndicator(), theme: theme));
    var indicator = tester.widget<M3EExpressiveLoadingIndicator>(
      find.byType(M3EExpressiveLoadingIndicator),
    );
    expect(
      indicator.color,
      theme.loadingIndicatorTheme.activeColor(theme.colorScheme),
    );

    await tester.pumpWidget(
      _host(
        const M3ELoadingIndicator(
          variant: M3ELoadingIndicatorVariant.contained,
        ),
        theme: theme,
      ),
    );
    indicator = tester.widget<M3EExpressiveLoadingIndicator>(
      find.byType(M3EExpressiveLoadingIndicator),
    );
    expect(
      indicator.color,
      theme.loadingIndicatorTheme.containedActiveColor(theme.colorScheme),
    );
  });

  testWidgets('supports single and multiple indicator colors', (tester) async {
    const singleColor = Color(0xff123456);
    const initialColors = <Color>[
      Color(0xffff0000),
      Color(0xff00ff00),
      Color(0xff0000ff),
    ];
    const updatedColors = <Color>[Color(0xffffff00), Color(0xffff00ff)];

    await tester.pumpWidget(
      _host(const M3ELoadingIndicator(color: singleColor)),
    );
    var indicator = tester.widget<M3EExpressiveLoadingIndicator>(
      find.byType(M3EExpressiveLoadingIndicator),
    );
    expect(indicator.color, singleColor);
    expect(indicator.indicatorColors, <Color>[singleColor]);

    await tester.pumpWidget(
      _host(
        const M3ELoadingIndicator(
          key: ValueKey('indicator'),
          indicatorColors: initialColors,
        ),
      ),
    );
    indicator = tester.widget<M3EExpressiveLoadingIndicator>(
      find.byType(M3EExpressiveLoadingIndicator),
    );
    expect(indicator.indicatorColors, initialColors);
    await tester.pump(const Duration(seconds: 2));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      _host(
        const M3ELoadingIndicator(
          key: ValueKey('indicator'),
          indicatorColors: updatedColors,
        ),
      ),
    );
    indicator = tester.widget<M3EExpressiveLoadingIndicator>(
      find.byType(M3EExpressiveLoadingIndicator),
    );
    expect(indicator.indicatorColors, updatedColors);
  });

  test('validates indicator color arguments', () {
    expect(
      () => M3ELoadingIndicator(
        color: const Color(0xff000000),
        indicatorColors: const <Color>[Color(0xffffffff)],
      ),
      throwsAssertionError,
    );
  });

  testWidgets('rejects an empty indicator color list', (tester) async {
    await tester.pumpWidget(
      _host(const M3ELoadingIndicator(indicatorColors: <Color>[])),
    );

    expect(tester.takeException(), isA<AssertionError>());
  });

  testWidgets('rejects an empty indicator color list in the base indicator', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(const M3EExpressiveLoadingIndicator(indicatorColors: <Color>[])),
    );

    expect(tester.takeException(), isA<AssertionError>());
  });

  test('validates instance dimensions', () {
    for (final indicatorSize in <double>[0, -1]) {
      expect(
        () => M3ELoadingIndicator(indicatorSize: indicatorSize),
        throwsAssertionError,
      );
    }
    for (final containerWidth in <double>[0, -1]) {
      expect(
        () => M3ELoadingIndicator(containerWidth: containerWidth),
        throwsAssertionError,
      );
    }
    for (final containerHeight in <double>[0, -1]) {
      expect(
        () => M3ELoadingIndicator(containerHeight: containerHeight),
        throwsAssertionError,
      );
    }
  });

  test('prevents mixing constraints with container dimensions', () {
    expect(
      () => M3ELoadingIndicator(
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        containerWidth: 48,
      ),
      throwsAssertionError,
    );
    expect(
      () => M3ELoadingIndicator(
        constraints: const BoxConstraints.tightFor(width: 48, height: 48),
        containerHeight: 48,
      ),
      throwsAssertionError,
    );
  });

  test('validates theme dimensions', () {
    expect(
      () => M3ELoadingIndicatorTheme(containerWidth: 0),
      throwsAssertionError,
    );
    expect(
      () => M3ELoadingIndicatorTheme(containerHeight: 0),
      throwsAssertionError,
    );
    expect(
      () => M3ELoadingIndicatorTheme(activeIndicatorSize: 0),
      throwsAssertionError,
    );
  });

  test('lerps and copies dimensions and container shape', () {
    const theme = M3ELoadingIndicatorTheme.defaults;
    const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );
    final copied = theme.copyWith(
      containerWidth: 64,
      containerHeight: 56,
      activeIndicatorSize: 40,
      containerShape: shape,
    );

    expect(copied.containerWidth, 64);
    expect(copied.containerHeight, 56);
    expect(copied.activeIndicatorSize, 40);
    expect(copied.containerShape, shape);

    final lerped = theme.lerp(copied, 1);
    expect(lerped.containerWidth, 64);
    expect(lerped.containerHeight, 56);
    expect(lerped.activeIndicatorSize, 40);
    expect(lerped.containerShape, isA<ShapeBorder>());
  });
}
