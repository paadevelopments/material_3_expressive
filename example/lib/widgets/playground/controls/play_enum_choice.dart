import 'package:flutter/widgets.dart';

import 'play_enum_menu.dart';
import 'play_enum_segmented.dart';

/// Preset-option control: a segmented button for up to two options, a
/// dropdown menu for more.
class PlayEnumChoice<T> extends StatelessWidget {
  /// Creates a preset-option control.
  const PlayEnumChoice({
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
    super.key,
  });

  /// Control label.
  final String label;

  /// Selected value.
  final T value;

  /// All options.
  final List<T> values;

  /// Label for each option.
  final String Function(T value) labelOf;

  /// Change callback.
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    if (values.length > 2) {
      return PlayEnumMenu<T>(
        label: label,
        value: value,
        values: values,
        labelOf: labelOf,
        onChanged: onChanged,
      );
    }
    return PlayEnumSegmented<T>(
      label: label,
      value: value,
      values: values,
      labelOf: labelOf,
      onChanged: onChanged,
    );
  }
}
