// Vendored from the `icon_button_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/icon_button_m3e/lib).
// Adapted for material_3_expressive: spatial spring press morph via
// [M3ERadiusAndPaddingMotion] (Phase 2 button morph).
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.

import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../buttons/components/m3e_radius_and_padding_motion.dart';
import '../buttons/styles/m3e_button_motion.dart';
import 'enums/m3e_icon_button_enums.dart';
import 'styles/m3e_icon_button_shapes.dart';
import 'styles/m3e_icon_button_theme.dart';

export 'enums/m3e_icon_button_enums.dart';
export 'styles/m3e_icon_button_theme.dart';

part 'components/m3e_icon_button_build.dart';

final SpringMotion _kIconButtonMorphMotion = M3EButtonMotion
    .expressiveSpatialPress
    .toMotion();

/// Material 3 Expressive Icon Button
///
/// - Visual sizes are defined by [M3EIconButtonTheme.visual] (per size × width)
/// - Tap target respects [M3EIconButtonTheme.target] with a minimum of 48×48 on XS/SM
/// - Variants: standard, filled, tonal, outlined
/// - Shapes: round (pill) or square (rounded rect). Toggle can flip shape when selected.
/// - Widths: default, narrow, wide
/// - Toggle: [isSelected] + [selectedIcon]
///  - Badge: [String] or [num]
class M3EIconButton extends StatefulWidget {
  /// M3EIconButton.
  const M3EIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.semanticLabel,
    this.variant = M3EIconButtonVariant.standard,
    this.size = M3EIconButtonSize.sm,
    this.shape = M3EIconButtonShapeVariant.round,
    this.width = M3EIconButtonWidth.defaultWidth,
    this.isSelected,
    this.selectedIcon,
    this.enableFeedback,
    this.badgeValue,
    this.suppressInk = false,
  });

  /// icon.

  final Widget icon;

  /// onPressed.
  final VoidCallback? onPressed;

  /// tooltip.
  final String? tooltip;

  /// semanticLabel.
  final String? semanticLabel;

  /// variant.
  final M3EIconButtonVariant variant;

  /// size.
  final M3EIconButtonSize size;

  /// shape.
  final M3EIconButtonShapeVariant shape;

  /// width.
  final M3EIconButtonWidth width;

  /// isSelected.
  final bool? isSelected;

  /// selectedIcon.
  final Widget? selectedIcon;

  /// enableFeedback.
  final bool? enableFeedback;

  /// badgeValue.
  final Object? badgeValue;

  /// When true, suppresses splash/hover ink effects.
  final bool suppressInk;

  @override
  State<M3EIconButton> createState() => _M3EIconButtonState();
}

class _M3EIconButtonState extends State<M3EIconButton> {
  late final WidgetStatesController _statesController;
  bool _isPointerDown = false;

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController();
  }

  @override
  void dispose() {
    _statesController.dispose();
    super.dispose();
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.onPressed == null || !mounted) {
      return;
    }
    setState(() => _isPointerDown = true);
    _statesController.update(WidgetState.pressed, true);
  }

  void _handlePointerUp() {
    if (!_isPointerDown) {
      return;
    }
    _isPointerDown = false;
    // onPressed may rebuild/remove this button (e.g. toolbar expand trigger)
    // before pointer-up is delivered to the Listener.
    if (!mounted) {
      return;
    }
    setState(() {});
    _statesController.update(WidgetState.pressed, false);
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildContent);
  }
}
