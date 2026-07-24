// Vendored from the `icon_button_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/icon_button_m3e/lib).
// Adapted for material_3_expressive: spatial spring press morph via
// [M3ERadiusAndPaddingMotion] (Phase 2 button morph).
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../buttons/components/m3e_radius_and_padding_motion.dart';
import '../buttons/styles/m3e_button_motion.dart';
import 'enums/m3e_icon_button_enums.dart';
import 'styles/m3e_icon_button_shapes.dart';
import 'styles/m3e_icon_button_theme.dart';

export 'styles/m3e_icon_button_theme.dart';
export 'enums/m3e_icon_button_enums.dart';

final SpringMotion _kIconButtonMorphMotion =
    M3EButtonMotion.expressiveSpatialPress.toMotion();

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

  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final String? semanticLabel;
  final M3EIconButtonVariant variant;
  final M3EIconButtonSize size;
  final M3EIconButtonShapeVariant shape;
  final M3EIconButtonWidth width;
  final bool? isSelected;
  final Widget? selectedIcon;
  final bool? enableFeedback;
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
    if (widget.onPressed == null || !mounted) return;
    setState(() => _isPointerDown = true);
    _statesController.update(WidgetState.pressed, true);
  }

  void _handlePointerUp() {
    if (!_isPointerDown) return;
    _isPointerDown = false;
    // onPressed may rebuild/remove this button (e.g. toolbar expand trigger)
    // before pointer-up is delivered to the Listener.
    if (!mounted) return;
    setState(() {});
    _statesController.update(WidgetState.pressed, false);
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: _buildContent,
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = M3ETheme.of(context);
    final iconButtonTheme = theme.iconButtonTheme;
    final scheme = theme.colorScheme;

    final Size visual = iconButtonTheme.visual(widget.size, widget.width);
    final Size target = iconButtonTheme.target(widget.size, widget.width);
    final double iconPx = iconButtonTheme.iconSize(widget.size);

    final bool selected = widget.isSelected ?? false;
    // Consider it a toggle control if selection can be represented.
    final bool isToggle =
        widget.isSelected != null || widget.selectedIcon != null;

    // Colors per variant (selected tint for standard).
    Color bg;
    Color fg;
    BorderSide? side;
    switch (widget.variant) {
      case M3EIconButtonVariant.standard:
        bg = Colors.transparent;
        fg = selected ? scheme.primary : scheme.onSurfaceVariant;
        side = null;
        break;
      case M3EIconButtonVariant.filled:
        bg = scheme.primary;
        fg = scheme.onPrimary;
        side = null;
        break;
      case M3EIconButtonVariant.tonal:
        bg = scheme.secondaryContainer;
        fg = scheme.onSecondaryContainer;
        side = null;
        break;
      case M3EIconButtonVariant.outlined:
        bg = Colors.transparent;
        fg = scheme.primary;
        side = BorderSide(
          color: scheme.outline,
          width: iconButtonTheme.outlineWidth,
        );
        break;
    }

    final Set<WidgetState> morphStates = <WidgetState>{
      if (_isPointerDown && widget.onPressed != null) WidgetState.pressed,
    };
    final double targetRadius = M3EIconButtonShapes.effectiveRadius(
      theme: iconButtonTheme,
      size: widget.size,
      baseVariant: widget.shape,
      isToggle: isToggle,
      isSelected: selected,
      states: morphStates,
    );

    final Widget innerIcon = IconTheme.merge(
      data: IconThemeData(size: iconPx, color: fg),
      child: (selected && widget.selectedIcon != null)
          ? widget.selectedIcon!
          : widget.icon,
    );

    final Widget button = M3ERadiusAndPaddingMotion(
      motion: _kIconButtonMorphMotion,
      internalLeft: 0,
      internalRight: 0,
      internalTop: 0,
      internalBottom: 0,
      targetRadius: BorderRadius.circular(targetRadius),
      builder: (padding, animatedRadius) {
        return M3EInkSplashTheme(
          color: fg,
          child: IconButton(
            onPressed: widget.onPressed,
            isSelected: widget.isSelected,
            selectedIcon: widget.selectedIcon,
            icon: innerIcon,
            tooltip: widget.tooltip,
            enableFeedback: widget.enableFeedback,
            statesController: _statesController,
            style: ButtonStyle(
              // Visual (painted) size
              fixedSize: WidgetStateProperty.all(visual),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: animatedRadius),
              ),
              backgroundColor: WidgetStateProperty.all(bg),
              foregroundColor: WidgetStateProperty.resolveWith((_) => fg),
              side: WidgetStateProperty.resolveWith((_) => side),
              splashFactory: widget.suppressInk
                  ? NoSplash.splashFactory
                  : InkSparkle.splashFactory,
              overlayColor: widget.suppressInk
                  ? WidgetStateProperty.all(Colors.transparent)
                  : M3EStateLayer.overlayColorHoverFocus(fg),
              // Radius morph is owned by [M3ERadiusAndPaddingMotion].
              animationDuration: Duration.zero,
              visualDensity: VisualDensity.standard,
            ),
          ),
        );
      },
    );

    Widget paintedButton = SizedBox(
      width: visual.width,
      height: visual.height,
      child: () {
        final Object? v = widget.badgeValue;
        Widget? badge;
        if (v == null) {
          badge = null;
        } else if (v is num) {
          final int c = v.round().clamp(0, 999999);
          if (c == 0) {
            badge = Badge(
              smallSize: 8,
              backgroundColor: scheme.primary,
              textColor: scheme.onPrimary,
            );
          } else {
            badge = Badge.count(
              count: c,
              backgroundColor: scheme.primary,
              textColor: scheme.onPrimary,
            );
          }
        } else if (v is String) {
          if (v.isEmpty) {
            badge = null;
          } else {
            badge = Badge(
              label: Text(
                v,
                style: theme.typeScale.labelSmall.copyWith(
                  color: scheme.onPrimary,
                ),
              ),
              backgroundColor: scheme.primary,
              textColor: scheme.onPrimary,
            );
          }
        } else {
          assert(() {
            throw FlutterError(
              'M3EIconButton.badgeValue must be a String or num, but got \'${v.runtimeType}\'.',
            );
          }());
          badge = null;
        }
        return badge == null
            ? button
            : Stack(
                clipBehavior: Clip.none,
                children: [
                  button,
                  PositionedDirectional(top: 0, end: 0, child: badge),
                ],
              );
      }(),
    );

    if (widget.onPressed != null) {
      paintedButton = Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _handlePointerDown,
        onPointerUp: (_) => _handlePointerUp(),
        onPointerCancel: (_) => _handlePointerUp(),
        child: paintedButton,
      );
    }

    // Compose into an outer box sized to the minimum interactive target.
    final Widget core = SizedBox(
      width: target.width,
      height: target.height,
      child: Center(child: paintedButton),
    );

    final semanticsText = widget.semanticLabel ?? widget.tooltip;
    return Semantics(
      button: true,
      selected: selected,
      label: semanticsText,
      child: core,
    );
  }
}
