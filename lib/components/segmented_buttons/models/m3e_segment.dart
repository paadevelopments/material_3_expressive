import 'package:flutter/widgets.dart';

/// A single option within an `M3ESegmentedButton`.
@immutable
class M3ESegment<T> {
  const M3ESegment({
    required this.value,
    this.label,
    this.icon,
  }) : assert(
          label != null || icon != null,
          'A segment needs at least a label or an icon.',
        );

  /// The value reported when this segment is selected.
  final T value;

  /// The optional text label.
  final String? label;

  /// The optional leading icon.
  final Widget? icon;
}
