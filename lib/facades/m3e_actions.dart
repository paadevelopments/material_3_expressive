import 'package:flutter/widgets.dart';

import '../components/button_groups/button_groups.dart';
import '../components/buttons/buttons.dart';
import '../components/extended_fabs/extended_fabs.dart';
import '../components/fab_menu/fab_menu.dart';
import '../components/floating_action_buttons/floating_action_buttons.dart';
import '../components/icon_buttons/icon_buttons.dart';
import '../components/segmented_buttons/segmented_buttons.dart';
import '../components/split_buttons/split_buttons.dart';
import '../foundations/foundations.dart';

/// Static factories for the Material 3 *Actions* components, such as
/// `M3EActions.button(...)` and `M3EActions.buttonGroup(...)`.
class M3EActions {
  const M3EActions._();

  /// Creates a common button. See [M3EButton].
  ///
  /// When [enabled] is omitted the button is enabled whenever [onPressed] is
  /// non-null.
  static Widget button({
    required String label,
    VoidCallback? onPressed,
    Widget? icon,
    M3EButtonStyle style = M3EButtonStyle.filled,
    M3EButtonSize size = M3EButtonSize.sm,
    M3EButtonShape shape = M3EButtonShape.round,
    bool? enabled,
    Key? key,
  }) {
    final bool resolvedEnabled = enabled ?? (onPressed != null);
    if (icon != null) {
      return M3EButton.icon(
        key: key,
        onPressed: onPressed,
        icon: icon,
        label: Text(label),
        style: style,
        size: size,
        shape: shape,
        enabled: resolvedEnabled,
      );
    }
    return M3EButton(
      key: key,
      onPressed: onPressed,
      style: style,
      size: size,
      shape: shape,
      enabled: resolvedEnabled,
      child: Text(label),
    );
  }

  /// Creates an icon button. See [M3EIconButton].
  static Widget iconButton({
    required Widget icon,
    VoidCallback? onPressed,
    bool? selected,
    Widget? selectedIcon,
    M3EIconButtonVariant variant = M3EIconButtonVariant.standard,
    M3EIconButtonSize size = M3EIconButtonSize.sm,
    M3EIconButtonShapeVariant shape = M3EIconButtonShapeVariant.round,
    M3EIconButtonWidth width = M3EIconButtonWidth.defaultWidth,
    String? tooltip,
    String? semanticLabel,
    Object? badgeValue,
    Key? key,
  }) {
    return M3EIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      isSelected: selected,
      selectedIcon: selectedIcon,
      variant: variant,
      size: size,
      shape: shape,
      width: width,
      tooltip: tooltip,
      semanticLabel: semanticLabel,
      badgeValue: badgeValue,
    );
  }

  /// Creates a floating action button. See [M3EFab].
  static Widget fab({
    required Widget icon,
    VoidCallback? onPressed,
    M3EFabSize size = M3EFabSize.medium,
    M3EFabColor color = M3EFabColor.primary,
    String? tooltip,
    FocusNode? focusNode,
    bool autofocus = false,
    Key? key,
  }) {
    return M3EFab(
      key: key,
      icon: icon,
      onPressed: onPressed,
      size: size,
      color: color,
      tooltip: tooltip,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Creates an extended floating action button. See [M3EExtendedFab].
  static Widget extendedFab({
    required String label,
    required Widget icon,
    VoidCallback? onPressed,
    M3EFabColor color = M3EFabColor.primary,
    bool extended = true,
    FocusNode? focusNode,
    bool autofocus = false,
    Key? key,
  }) {
    return M3EExtendedFab(
      key: key,
      label: label,
      icon: icon,
      onPressed: onPressed,
      color: color,
      extended: extended,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Creates a FAB menu. See [M3EFabMenu].
  static Widget fabMenu({
    required List<M3EFabMenuItem> items,
    Widget icon = const Icon(M3EIcons.add),
    Widget closeIcon = const Icon(M3EIcons.close),
    M3EFabColor color = M3EFabColor.primary,
    Key? key,
  }) {
    return M3EFabMenu(
      key: key,
      items: items,
      icon: icon,
      closeIcon: closeIcon,
      color: color,
    );
  }

  /// Creates a button group. See [M3EButtonGroup].
  static Widget buttonGroup({
    required List<M3EButtonGroupAction> actions,
    M3EButtonGroupType type = M3EButtonGroupType.standard,
    M3EButtonShape shape = M3EButtonShape.round,
    M3EButtonSize size = M3EButtonSize.sm,
    M3EButtonStyle style = M3EButtonStyle.filled,
    M3EButtonGroupDensity density = M3EButtonGroupDensity.regular,
    Axis direction = Axis.horizontal,
    int? selectedIndex,
    ValueChanged<int?>? onSelectedIndexChanged,
    M3EButtonGroupOverflow overflow = M3EButtonGroupOverflow.scroll,
    String? semanticLabel,
    Key? key,
  }) {
    return M3EButtonGroup(
      key: key,
      actions: actions,
      type: type,
      shape: shape,
      size: size,
      style: style,
      density: density,
      direction: direction,
      selectedIndex: selectedIndex,
      onSelectedIndexChanged: onSelectedIndexChanged,
      overflow: overflow,
      semanticLabel: semanticLabel,
    );
  }

  /// Creates a segmented button. See [M3ESegmentedButton].
  static Widget segmentedButton<T>({
    required List<M3ESegment<T>> segments,
    required Set<T> selected,
    required ValueChanged<Set<T>> onSelectionChanged,
    bool multiSelect = false,
    bool showSelectedIcon = true,
    Key? key,
  }) {
    return M3ESegmentedButton<T>(
      key: key,
      segments: segments,
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      multiSelect: multiSelect,
      showSelectedIcon: showSelectedIcon,
    );
  }

  /// Creates a split button. See [M3ESplitButton].
  static Widget splitButton<T>({
    required List<M3ESplitButtonItem<T>> items,
    ValueChanged<T>? onSelected,
    VoidCallback? onPressed,
    String? label,
    IconData? leadingIcon,
    M3EButtonStyle style = M3EButtonStyle.filled,
    M3EButtonSize size = M3EButtonSize.sm,
    M3EButtonShape shape = M3EButtonShape.round,
    bool enabled = true,
    Key? key,
  }) {
    return M3ESplitButton<T>(
      key: key,
      items: items,
      onSelected: onSelected,
      onPressed: onPressed,
      label: label,
      leadingIcon: leadingIcon,
      style: style,
      size: size,
      shape: shape,
      enabled: enabled,
    );
  }
}
