import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/sliders/enums/m3e_slider_enums.dart';
import 'package:material_3_expressive/components/sliders/utils/m3e_slider_dot_layout.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host(Widget child) {
  return Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(),
      child: M3ETheme(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('continuous drag updates value', (tester) async {
    double value = 0.25;
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 200,
          height: 48,
          child: M3ESlider(
            value: value,
            onChanged: (double v) => value = v,
          ),
        ),
      ),
    );

    await tester.tapAt(tester.getCenter(find.byType(M3ESlider)));
    await tester.pump();
    expect(value, closeTo(0.5, 0.05));
  });

  testWidgets('discrete divisions snap', (tester) async {
    double value = 0;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return _host(
            SizedBox(
              width: 200,
              height: 48,
              child: M3ESlider(
                value: value,
                max: 4,
                divisions: 4,
                onChanged: (double v) => setState(() => value = v),
              ),
            ),
          );
        },
      ),
    );

    final Offset topLeft = tester.getTopLeft(find.byType(M3ESlider));
    await tester.tapAt(topLeft + const Offset(150, 24));
    await tester.pump();
    expect(value, anyOf(3.0, 4.0));
  });

  testWidgets('centered constructor builds', (tester) async {
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 200,
          height: 48,
          child: M3ESlider.centered(
            value: 0,
            min: -100,
            max: 100,
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(M3ESlider), findsOneWidget);
  });

  testWidgets('wavy constructor builds and updates', (tester) async {
    double value = 0.3;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return _host(
            SizedBox(
              width: 200,
              height: 48,
              child: M3ESlider.wavy(
                value: value,
                onChanged: (double v) => setState(() => value = v),
              ),
            ),
          );
        },
      ),
    );

    expect(find.byType(M3ESlider), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tapAt(tester.getCenter(find.byType(M3ESlider)));
    await tester.pump();
    expect(value, closeTo(0.5, 0.05));
  });

  testWidgets('wavy range constructor builds', (tester) async {
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 200,
          height: 48,
          child: M3ERangeSlider.wavy(
            values: const M3ESliderRange(0.2, 0.8),
            onChanged: (_) {},
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(M3ERangeSlider), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('custom trackThickness thumbLength and dotBuilder', (tester) async {
    await tester.pumpWidget(
      _host(
        SizedBox(
          width: 200,
          height: 48,
          child: M3ESlider(
            value: 0.5,
            max: 4,
            divisions: 4,
            trackThickness: 20,
            thumbLength: 32,
            dotSize: 10,
            dotSpacing: 8,
            onChanged: (_) {},
            dotBuilder: ({
              required BuildContext context,
              required Color color,
              required double size,
              required bool active,
            }) {
              return CustomPaint(
                painter: _TestShapeDotPainter(
                  polygon: M3EMaterialNewShapes.cookie4Sided,
                  color: color,
                ),
              );
            },
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  test('dotSpacing pads outer edge of end stops from track ends', () {
    const Size size = Size(200, 48);
    const double trackHeight = 16;
    const double dotSize = 12;
    const double spacing = 8;
    final M3ESliderColors colors = M3ESliderTheme.defaults.colors(
      M3EThemeData.light(seedColor: const Color(0xFF6750A4)).colorScheme,
      enabled: true,
    );

    final List<M3ESliderDotPlacement> dots = M3ESliderDotLayout.resolve(
      size: size,
      mode: M3ESliderPaintMode.single,
      trackKind: M3ESliderTrackKind.standard,
      activeStartFraction: 0,
      activeEndFraction: 0.5,
      tickFractions: const <double>[],
      colors: colors,
      trackHeight: trackHeight,
      handleGap: 6,
      handleThickness: 4,
      stopIndicatorSize: dotSize,
      tickSize: dotSize,
      edgeInset: spacing,
      axis: Axis.horizontal,
      textDirection: TextDirection.ltr,
    );

    // Only the trailing stop is on the inactive track for value 0.5.
    expect(dots, isNotEmpty);
    final M3ESliderDotPlacement end = dots.last;
    final double outerEdge = end.primary + end.size / 2;
    expect(size.width - outerEdge, closeTo(spacing, 0.001));
  });

  testWidgets('range thumbs cannot cross', (tester) async {
    M3ESliderRange values = const M3ESliderRange(0.4, 0.6);
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return _host(
            SizedBox(
              width: 200,
              height: 48,
              child: M3ERangeSlider(
                values: values,
                onChanged: (M3ESliderRange v) => setState(() => values = v),
              ),
            ),
          );
        },
      ),
    );

    // Drag the start thumb far right; it must clamp at the end thumb.
    final Offset topLeft = tester.getTopLeft(find.byType(M3ERangeSlider));
    await tester.dragFrom(topLeft + const Offset(80, 24), const Offset(120, 0));
    await tester.pumpAndSettle();

    expect(values.start, lessThanOrEqualTo(values.end));
    expect(values.start, closeTo(0.6, 0.05));
  });

  testWidgets('vertical drag updates value', (tester) async {
    double value = 0.2;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return _host(
            SizedBox(
              width: 48,
              height: 200,
              child: M3ESlider.vertical(
                value: value,
                onChanged: (double v) => setState(() => value = v),
              ),
            ),
          );
        },
      ),
    );

    await tester.tapAt(tester.getCenter(find.byType(M3ESlider)));
    await tester.pump();
    expect(value, closeTo(0.5, 0.05));
  });

  testWidgets('vertical min is at bottom and max at top', (tester) async {
    double value = 0.5;
    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return _host(
            SizedBox(
              width: 48,
              height: 200,
              child: M3ESlider.vertical(
                value: value,
                onChanged: (double v) => setState(() => value = v),
              ),
            ),
          );
        },
      ),
    );

    final Offset topLeft = tester.getTopLeft(find.byType(M3ESlider));
    // Near the top → high value.
    await tester.tapAt(topLeft + const Offset(24, 20));
    await tester.pump();
    expect(value, greaterThan(0.75));

    // Near the bottom → low value.
    await tester.tapAt(topLeft + const Offset(24, 180));
    await tester.pump();
    expect(value, lessThan(0.25));
  });

  testWidgets('disabled when onChanged is null', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 200,
          height: 48,
          child: M3ESlider(value: 0.5, onChanged: null),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byType(M3ESlider));
    await tester.pump();
    expect(find.byType(M3ESlider), findsOneWidget);
  });
}

class _TestShapeDotPainter extends CustomPainter {
  const _TestShapeDotPainter({
    required this.polygon,
    required this.color,
  });

  final RoundedPolygon polygon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = polygon.toPath();
    final Matrix4 scale = Matrix4.diagonal3Values(size.width, size.height, 1);
    final Path scaled = path.transform(scale.storage);
    final Rect bounds = scaled.getBounds();
    final Path centered =
        scaled.shift(Offset(size.width / 2, size.height / 2) - bounds.center);
    canvas.drawPath(centered, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _TestShapeDotPainter oldDelegate) {
    return oldDelegate.polygon != polygon || oldDelegate.color != color;
  }
}
