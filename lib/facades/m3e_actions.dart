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
  static Widget button({
    required String label,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    M3EButtonVariant variant = M3EButtonVariant.filled,
    M3EButtonSize size = M3EButtonSize.small,
    M3EButtonShape shape = M3EButtonShape.round,
    Widget? icon,
    FocusNode? focusNode,
    bool autofocus = false,
    Key? key,
  }) {
    return M3EButton(
      key: key,
      label: label,
      onPressed: onPressed,
      onLongPress: onLongPress,
      variant: variant,
      size: size,
      shape: shape,
      icon: icon,
      focusNode: focusNode,
      autofocus: autofocus,
    );
  }

  /// Creates an icon button. See [M3EIconButton].
  static Widget iconButton({
    required Widget icon,
    VoidCallback? onPressed,
    bool? selected,
    Widget? selectedIcon,
    M3EIconButtonVariant variant = M3EIconButtonVariant.standard,
    M3EIconButtonSize size = M3EIconButtonSize.small,
    M3EIconButtonShape shape = M3EIconButtonShape.round,
    String? tooltip,
    FocusNode? focusNode,
    bool autofocus = false,
    Key? key,
  }) {
    return M3EIconButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      selected: selected,
      selectedIcon: selectedIcon,
      variant: variant,
      size: size,
      shape: shape,
      tooltip: tooltip,
      focusNode: focusNode,
      autofocus: autofocus,
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
    required List<M3EButtonGroupItem> items,
    double height = 48,
    double spacing = 4,
    Key? key,
  }) {
    return M3EButtonGroup(
      key: key,
      items: items,
      height: height,
      spacing: spacing,
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
  static Widget splitButton({
    required String label,
    Widget? leadingIcon,
    VoidCallback? onPressed,
    VoidCallback? onMenuPressed,
    bool expanded = false,
    M3ESplitButtonVariant variant = M3ESplitButtonVariant.filled,
    Key? key,
  }) {
    return M3ESplitButton(
      key: key,
      label: label,
      leadingIcon: leadingIcon,
      onPressed: onPressed,
      onMenuPressed: onMenuPressed,
      expanded: expanded,
      variant: variant,
    );
  }
}
