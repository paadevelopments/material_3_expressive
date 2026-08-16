import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return MaterialApp(
    home: M3ETheme(
      data: M3EThemeData.light(),
      child: Scaffold(body: Center(child: child)),
    ),
  );
}

void main() {
  test('every M3EShapeKind has a polygon', () {
    expect(M3EShapeKind.all, hasLength(35));
    for (final M3EShapeKind kind in M3EShapeKind.all) {
      expect(kind.polygon, isNotNull);
      expect(kind.polygon.toPath().getBounds().isEmpty, isFalse);
    }
  });

  test('M3EShapeClipper scales a non-empty path to 100x100', () {
    const clipper = M3EShapeClipper(M3EShapeKind.gem);
    final Path path = clipper.getClip(const Size(100, 100));
    expect(path.getBounds().isEmpty, isFalse);
    expect(path.getBounds().width, moreOrLessEquals(100, epsilon: 0.5));
    expect(path.getBounds().height, moreOrLessEquals(100, epsilon: 0.5));
  });

  testWidgets('M3EShapeContainer.heart pumps', (tester) async {
    await tester.pumpWidget(
      _host(
        const M3EShapeContainer.heart(
          width: 48,
          height: 48,
          color: Color(0xFF6750A4),
        ),
      ),
    );
    expect(find.byType(M3EShapeContainer), findsOneWidget);
    expect(find.byType(ClipPath), findsOneWidget);
  });
}
