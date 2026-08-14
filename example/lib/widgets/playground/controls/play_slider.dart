import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Continuous value control using [M3ESlider].
class PlaySlider extends StatelessWidget {
  /// Creates a slider control.
  const PlaySlider({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    super.key,
  });

  /// Row label.
  final String label;

  /// Current value.
  final double value;

  /// Change callback.
  final ValueChanged<double> onChanged;

  /// Minimum.
  final double min;

  /// Maximum.
  final double max;

  /// Optional divisions.
  final int? divisions;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            '$label (${value.toStringAsFixed(divisions == null ? 2 : 0)})',
            style: theme.typeScale.bodyLarge,
          ),
          M3ESlider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
