import 'package:flutter/widgets.dart';

import '../components/checkbox/checkbox.dart';
import '../components/chips/chips.dart';
import '../components/date_pickers/date_pickers.dart';
import '../components/radio_button/radio_button.dart';
import '../components/sliders/sliders.dart';
import '../components/switch_control/switch_control.dart';
import '../components/time_pickers/time_pickers.dart';

/// Static factories for the Material 3 *Selection* components, such as
/// `M3ESelection.checkbox(...)` and `M3ESelection.datePicker(...)`.
class M3ESelection {
  const M3ESelection._();

  /// Creates a checkbox. See [M3ECheckbox].
  static Widget checkbox({
    required bool? value,
    required ValueChanged<bool?>? onChanged,
    bool tristate = false,
    bool error = false,
    String? semanticLabel,
    Key? key,
  }) {
    return M3ECheckbox(
      key: key,
      value: value,
      onChanged: onChanged,
      tristate: tristate,
      error: error,
      semanticLabel: semanticLabel,
    );
  }

  /// Creates a radio button. See [M3ERadio].
  static Widget radio<T>({
    required T value,
    required T? groupValue,
    required ValueChanged<T>? onChanged,
    bool error = false,
    String? semanticLabel,
    Key? key,
  }) {
    return M3ERadio<T>(
      key: key,
      value: value,
      groupValue: groupValue,
      onChanged: onChanged,
      error: error,
      semanticLabel: semanticLabel,
    );
  }

  /// Creates a switch. See [M3ESwitch].
  static Widget switchControl({
    required bool value,
    required ValueChanged<bool>? onChanged,
    Widget? selectedIcon,
    Widget? unselectedIcon,
    String? semanticLabel,
    Key? key,
  }) {
    return M3ESwitch(
      key: key,
      value: value,
      onChanged: onChanged,
      selectedIcon: selectedIcon,
      unselectedIcon: unselectedIcon,
      semanticLabel: semanticLabel,
    );
  }

  /// Creates a chip. See [M3EChip].
  static Widget chip({
    required String label,
    M3EChipType type = M3EChipType.assist,
    Widget? leading,
    bool selected = false,
    bool elevated = false,
    VoidCallback? onPressed,
    VoidCallback? onDeleted,
    Key? key,
  }) {
    return M3EChip(
      key: key,
      label: label,
      type: type,
      leading: leading,
      selected: selected,
      elevated: elevated,
      onPressed: onPressed,
      onDeleted: onDeleted,
    );
  }

  /// Creates a slider. See [M3ESlider].
  static Widget slider({
    required double value,
    required ValueChanged<double>? onChanged,
    double min = 0,
    double max = 1,
    int? divisions,
    Key? key,
  }) {
    return M3ESlider(
      key: key,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      divisions: divisions,
    );
  }

  /// Creates a date picker. See [M3EDatePicker].
  static Widget datePicker({
    required ValueChanged<DateTime> onDateSelected,
    DateTime? selectedDate,
    DateTime? firstDate,
    DateTime? lastDate,
    Key? key,
  }) {
    return M3EDatePicker(
      key: key,
      onDateSelected: onDateSelected,
      selectedDate: selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
  }

  /// Creates a time picker. See [M3ETimePicker].
  static Widget timePicker({
    required M3ETime value,
    required ValueChanged<M3ETime> onChanged,
    Key? key,
  }) {
    return M3ETimePicker(key: key, value: value, onChanged: onChanged);
  }
}
