import 'dart:math' as math;

/// Turns a weight pattern into slot sizes that follow the carousel spec.
abstract final class M3ECarouselLayout {
  const M3ECarouselLayout._();

  /// Clamps small slots to [smallMin]–[smallMax] and large slots to [largeMax].
  ///
  /// The leftover width is shared by the other slots so the row still fills
  /// [viewport].
  static List<int> clampWeights({
    required List<int> pattern,
    required double viewport,
    required double smallMin,
    required double smallMax,
    required double largeMax,
  }) {
    if (pattern.isEmpty || viewport <= 0) {
      return pattern;
    }
    final int sum = pattern.fold<int>(0, (int a, int b) => a + b);
    if (sum <= 0) {
      return pattern;
    }
    final int minWeight = pattern.reduce(math.min);
    final int maxWeight = pattern.reduce(math.max);
    final double unit = viewport / sum;
    final List<double> slots = <double>[
      for (final int weight in pattern) weight * unit,
    ];
    final List<bool> small = <bool>[
      for (final int weight in pattern) weight == minWeight,
    ];
    final List<bool> large = <bool>[
      for (final int weight in pattern)
        weight == maxWeight && weight != minWeight,
    ];
    for (int i = 0; i < slots.length; i++) {
      if (small[i]) {
        slots[i] = slots[i].clamp(smallMin, smallMax);
      } else if (large[i]) {
        slots[i] = math.min(slots[i], largeMax);
      }
    }
    final List<int> receivers = <int>[
      for (int i = 0; i < slots.length; i++)
        if (!small[i] && !large[i]) i,
    ];
    final List<int> targets = receivers.isNotEmpty
        ? receivers
        : <int>[
            for (int i = 0; i < slots.length; i++)
              if (!small[i]) i,
          ];
    final double used = slots.fold<double>(0, (double a, double b) => a + b);
    if (targets.isNotEmpty) {
      final double share = (viewport - used) / targets.length;
      for (final int index in targets) {
        slots[index] += share;
        if (large[index]) {
          slots[index] = math.min(slots[index], largeMax);
        }
      }
    }
    final List<int> rounded = <int>[
      for (final double slot in slots) math.max(1, slot.round()),
    ];
    if (targets.isEmpty) {
      return rounded;
    }
    final int drift =
        viewport.round() - rounded.fold<int>(0, (int a, int b) => a + b);
    final int last = targets.last;
    rounded[last] = math.max(1, rounded[last] + drift);
    return rounded;
  }
}
