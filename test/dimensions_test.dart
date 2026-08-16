import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  test('M3ESpacing.regular aliases M3EDimensions space steps', () {
    const spacing = M3ESpacing.regular();
    expect(spacing.xs, M3EDimensions.spaceXs);
    expect(spacing.sm, M3EDimensions.spaceSm);
    expect(spacing.md, M3EDimensions.spaceMd);
    expect(spacing.lg, M3EDimensions.spaceLg);
    expect(spacing.xl, M3EDimensions.spaceXl);
    expect(spacing.xxl, M3EDimensions.spaceXxl);
  });

  test('M3EShapes radius aliases M3EDimensions', () {
    expect(M3EShapes.none, M3EDimensions.radiusNone);
    expect(M3EShapes.small, M3EDimensions.radiusSmall);
    expect(M3EShapes.largeIncreased, M3EDimensions.radiusLargeIncreased);
    expect(M3EShapes.full, M3EDimensions.radiusFull);
    expect(M3EShapes.radiusMedium, M3EDimensions.borderRadiusMedium);
    expect(M3EShapes.resolve(12), M3EDimensions.resolveRadius(12));
  });
}
