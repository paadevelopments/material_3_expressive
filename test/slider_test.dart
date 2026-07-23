import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
