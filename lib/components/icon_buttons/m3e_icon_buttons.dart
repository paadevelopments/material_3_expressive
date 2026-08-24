import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../buttons/components/m3e_radius_and_padding_motion.dart';
import '../buttons/styles/m3e_button_motion.dart';
import '../buttons/utils/m3e_button_gradient_layer.dart';
import 'enums/m3e_icon_button_enums.dart';
import 'styles/m3e_icon_button_decoration.dart';
import 'styles/m3e_icon_button_shapes.dart';
import 'styles/m3e_icon_button_theme.dart';

export 'enums/m3e_icon_button_enums.dart';
export 'styles/m3e_icon_button_decoration.dart';
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
    this.haptic = M3EHapticFeedback.none,
    this.badgeValue,
    this.suppressInk = false,
    this.visualSize,
    this.decoration,
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

  /// Haptic intensity on press. Defaults to [M3EHapticFeedback.none].
  final M3EHapticFeedback haptic;

  /// badgeValue.
  final Object? badgeValue;

  /// When true, suppresses splash/hover ink effects.
  final bool suppressInk;

  /// Overrides theme visual size when non-null (e.g. sprung toolbar label width).
  ///
  /// Height should typically match [M3EIconButtonTheme.visual] height for
  /// [size]/[width]. The outer tap target uses at least the theme target,
  /// or this size when larger.
  final Size? visualSize;

  /// Optional decoration for solid and gradient surfaces.
  final M3EIconButtonDecoration? decoration;

  @override
  State<M3EIconButton> createState() => _M3EIconButtonState();
}

class _M3EIconButtonState extends State<M3EIconButton> {
  late final WidgetStatesController _statesController;
  late final ValueNotifier<bool> _isPointerDownNotifier;
  late final ValueNotifier<bool> _isHoveredNotifier;
  late final ValueNotifier<bool> _isPressedNotifier;

  @override
  void initState() {
    super.initState();
    _statesController = WidgetStatesController()..addListener(_onStatesChanged);
    _isPointerDownNotifier = ValueNotifier(false);
    _isHoveredNotifier = ValueNotifier(false);
    _isPressedNotifier = ValueNotifier(false);
  }

  @override
  void dispose() {
    _statesController
      ..removeListener(_onStatesChanged)
      ..dispose();
    _isPointerDownNotifier.dispose();
    _isHoveredNotifier.dispose();
    _isPressedNotifier.dispose();
    super.dispose();
  }

  void _onStatesChanged() {
    if (!mounted) {
      return;
    }
    final Set<WidgetState> states = _statesController.value;
    _isHoveredNotifier.value = states.contains(WidgetState.hovered);
    _isPressedNotifier.value = states.contains(WidgetState.pressed);
  }

  void _setPointerDown(bool down) {
    if (_isPointerDownNotifier.value == down) {
      return;
    }
    _isPointerDownNotifier.value = down;
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildContent);
  }
}
