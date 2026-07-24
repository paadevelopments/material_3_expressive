import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// X-axis scale from a [Transform.scale] matrix (Z is always 1.0).
double _xyScale(Transform transform) => transform.transform.storage[0];

double _fabXyScale(WidgetTester tester) {
  final transforms = tester.widgetList<Transform>(
    find.descendant(
      of: find.byType(M3EFab),
      matching: find.byType(Transform),
    ),
  );
  // Prefer a non-identity XY scale if the spring has moved; else first matrix.
  for (final transform in transforms) {
    final scale = _xyScale(transform);
    if ((scale - 1.0).abs() > 0.001) {
      return scale;
    }
  }
  return _xyScale(transforms.first);
}

void main() {
  testWidgets('M3EFab springs press scale while held', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(),
        home: Scaffold(
          body: Center(
            child: M3EFab(
              icon: const Icon(Icons.add),
              onPressed: () => taps++,
            ),
          ),
        ),
      ),
    );

    expect(_fabXyScale(tester), closeTo(1.0, 0.001));

    final Offset center = tester.getCenter(find.byType(M3EFab));
    final TestGesture gesture = await tester.startGesture(center);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 48));

    expect(_fabXyScale(tester), lessThan(0.995));

    await gesture.up();
    await tester.pump();
    expect(taps, 1);
  });

  testWidgets('M3EFab onPressed fires instantly on tap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(),
        home: Scaffold(
          body: Center(
            child: M3EFab(
              icon: const Icon(Icons.add),
              onPressed: () => taps++,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(M3EFab));
    expect(taps, 1);
  });
}
