import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:motor/motor.dart';
import '../buttons/components/m3e_base_button_state.dart';
import '../buttons/components/m3e_focus_ring.dart';
import '../buttons/components/m3e_radius_and_padding_motion.dart';
import '../buttons/enums/m3e_button_enums.dart';
import '../buttons/models/m3e_button_measurements.dart';
import '../buttons/res/m3e_button_constants.dart';
import '../buttons/styles/m3e_button_decoration.dart';
import '../buttons/styles/m3e_button_motion.dart';
import '../buttons/styles/m3e_button_theme.dart';
import '../toggle_button_group/styles/m3e_toggle_button_group_theme.dart';
import 'styles/m3e_toggle_button_theme.dart';

export 'styles/m3e_toggle_button_theme.dart';

part 'components/m3e_toggle_button_state.dart';
part 'components/m3e_toggle_button_shape.dart';
part 'components/m3e_toggle_button_style.dart';
part 'components/m3e_toggle_button_content.dart';

const Alignment _kAlignmentCenter = Alignment.center;
const VisualDensity _kVisualDensityStandard = VisualDensity.standard;
const Duration _kDurationZero = Duration.zero;
const bool _kDefaultEnableFeedback = true;

/// Material 3 Expressive Toggle Button.
///
/// Morphs between round (unchecked) and square (checked) shapes.
class M3EToggleButton extends StatefulWidget {
  /// const.
  const M3EToggleButton({
    super.key,
    this.onCheckedChange,
    this.icon,
    this.checkedIcon,
    this.label,
    this.checkedLabel,
    this.checked,
    this.style = M3EButtonStyle.filled,
    this.size = M3EButtonSize.sm,
    this.enabled = true,
    this.isGroupConnected = false,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
    this.decoration,
    this.mouseCursor,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  });

  /// A filled toggle button (highest emphasis).
  const M3EToggleButton.filled({
    super.key,
    this.onCheckedChange,
    this.icon,
    this.checkedIcon,
    this.label,
    this.checkedLabel,
    this.checked,
    this.size = M3EButtonSize.sm,
    this.enabled = true,
    this.decoration,
    this.mouseCursor,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  }) : style = M3EButtonStyle.filled,
       isGroupConnected = false,
       isFirstInGroup = true,
       isLastInGroup = true;

  /// A tonal toggle button (medium emphasis).
  const M3EToggleButton.tonal({
    super.key,
    this.onCheckedChange,
    this.icon,
    this.checkedIcon,
    this.label,
    this.checkedLabel,
    this.checked,
    this.size = M3EButtonSize.sm,
    this.enabled = true,
    this.decoration,
    this.mouseCursor,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  }) : style = M3EButtonStyle.tonal,
       isGroupConnected = false,
       isFirstInGroup = true,
       isLastInGroup = true;

  /// An elevated toggle button (medium emphasis with a shadow).
  const M3EToggleButton.elevated({
    super.key,
    this.onCheckedChange,
    this.icon,
    this.checkedIcon,
    this.label,
    this.checkedLabel,
    this.checked,
    this.size = M3EButtonSize.sm,
    this.enabled = true,
    this.decoration,
    this.mouseCursor,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  }) : style = M3EButtonStyle.elevated,
       isGroupConnected = false,
       isFirstInGroup = true,
       isLastInGroup = true;

  /// An outlined toggle button (medium emphasis with a border).
  const M3EToggleButton.outlined({
    super.key,
    this.onCheckedChange,
    this.icon,
    this.checkedIcon,
    this.label,
    this.checkedLabel,
    this.checked,
    this.size = M3EButtonSize.sm,
    this.enabled = true,
    this.decoration,
    this.mouseCursor,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  }) : style = M3EButtonStyle.outlined,
       isGroupConnected = false,
       isFirstInGroup = true,
       isLastInGroup = true;

  /// A text toggle button (lowest emphasis).
  const M3EToggleButton.text({
    super.key,
    this.onCheckedChange,
    this.icon,
    this.checkedIcon,
    this.label,
    this.checkedLabel,
    this.checked,
    this.size = M3EButtonSize.sm,
    this.enabled = true,
    this.decoration,
    this.mouseCursor,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  }) : style = M3EButtonStyle.text,
       isGroupConnected = false,
       isFirstInGroup = true,
       isLastInGroup = true;

  /// Icon displayed in the unchecked state.
  final Widget? icon;

  /// Icon displayed in the checked state. Falls back to [icon] when null.
  final Widget? checkedIcon;

  /// Optional text label. When set, button is content-width (not square).
  final Widget? label;

  /// Label shown when checked. Falls back to [label] when null.
  final Widget? checkedLabel;

  /// Current checked state. Null for internal state management.
  final bool? checked;

  /// Callback fired when the checked state changes.
  final ValueChanged<bool>? onCheckedChange;

  /// Visual style of the toggle button.
  final M3EButtonStyle style;

  /// Size variant of the toggle button.
  final M3EButtonSize size;

  /// Whether the toggle button is enabled.
  final bool enabled;

  /// Whether this button is part of a connected button group.
  final bool isGroupConnected;

  /// Whether this is the first button in a connected group.
  final bool isFirstInGroup;

  /// Whether this is the last button in a connected group.
  final bool isLastInGroup;

  /// Optional decoration that bundles styling properties together.
  final M3EToggleButtonDecoration? decoration;

  /// Optional mouse cursor to show when hovering over the button.
  final MouseCursor? mouseCursor;

  /// WidgetStateProperty.

  // ── Decoration property helpers ───────────────────────────────────────────

  WidgetStateProperty<Color?>? get decorationBackgroundColor =>
      decoration?.backgroundColor;

  /// WidgetStateProperty.
  WidgetStateProperty<Color?>? get decorationForegroundColor =>
      decoration?.foregroundColor;

  /// WidgetStateProperty.
  WidgetStateProperty<BorderSide?>? get decorationBorderSide =>
      decoration?.side;

  /// M3EButtonMotion.
  M3EButtonMotion? get decorationMotion => decoration?.motion;

  /// M3EHapticFeedback.
  M3EHapticFeedback get decorationHaptic =>
      decoration?.haptic ?? M3EHapticFeedback.none;

  /// double.
  double? get decorationBorderRadius => decoration?.borderRadius;

  /// double.
  double? get decorationCheckedRadius => decoration?.checkedRadius;

  /// double.
  double? get decorationUncheckedRadius => decoration?.uncheckedRadius;

  /// double.
  double? get decorationPressedRadius => decoration?.pressedRadius;

  /// double.
  double? get decorationConnectedInnerRadius =>
      decoration?.connectedInnerRadius;

  /// WidgetStateProperty.
  WidgetStateProperty<Color?>? get decorationOverlayColor =>
      decoration?.overlayColor;

  /// WidgetStateProperty.
  WidgetStateProperty<Color?>? get decorationSurfaceTintColor =>
      decoration?.surfaceTintColor;

  /// Optional controller for managing widget states externally.
  final WidgetStatesController? statesController;

  /// External focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether this button should focus itself on mount.
  final bool autofocus;

  /// Callback fired when focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Accessibility label. Merged on top of the button's own semantics.
  final String? semanticLabel;

  /// Tooltip text.
  final String? tooltip;

  /// Callback invoked when the button is long-pressed.
  final VoidCallback? onLongPress;

  /// Callback invoked when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Whether to show a ripple/splash effect and haptic feedback on press.
  final bool enableFeedback;

  /// The splash factory for the ink ripple effect.
  final InteractiveInkFeatureFactory? splashFactory;

  @override
  State<M3EToggleButton> createState() => _M3EToggleButtonState();
}
