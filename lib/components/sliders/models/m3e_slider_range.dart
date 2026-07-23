import 'package:flutter/foundation.dart';

/// A continuous range with [start] ≤ [end], used by [M3ERangeSlider].
@immutable
class M3ESliderRange {
  const M3ESliderRange(this.start, this.end)
      : assert(start <= end, 'start must be ≤ end');

  final double start;
  final double end;

  M3ESliderRange copyWith({double? start, double? end}) {
    return M3ESliderRange(start ?? this.start, end ?? this.end);
  }

  @override
  bool operator ==(Object other) {
    return other is M3ESliderRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'M3ESliderRange($start, $end)';
}
