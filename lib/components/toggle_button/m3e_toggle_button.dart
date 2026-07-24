// File exceeds length guideline due to combined toggle button states and motion.
// ignore: file_length
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

const Alignment _kAlignmentCenter = Alignment.center;
const VisualDensity _kVisualDensityStandard = VisualDensity.standard;
const Duration _kDurationZero = Duration.zero;
const bool _kDefaultEnableFeedback = true;

/// Material 3 Expressive Toggle Button.
///
/// Morphs between round (unchecked) and square (checked) shapes.
class M3EToggleButton extends StatefulWidget {
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

  // ── Decoration property helpers ───────────────────────────────────────────

  WidgetStateProperty<Color?>? get decorationBackgroundColor =>
      decoration?.backgroundColor;
  WidgetStateProperty<Color?>? get decorationForegroundColor =>
      decoration?.foregroundColor;
  WidgetStateProperty<BorderSide?>? get decorationBorderSide =>
      decoration?.side;
  M3EButtonMotion? get decorationMotion => decoration?.motion;
  M3EHapticFeedback get decorationHaptic =>
      decoration?.haptic ?? M3EHapticFeedback.none;
  double? get decorationBorderRadius => decoration?.borderRadius;
  double? get decorationCheckedRadius => decoration?.checkedRadius;
  double? get decorationUncheckedRadius => decoration?.uncheckedRadius;
  double? get decorationPressedRadius => decoration?.pressedRadius;
  double? get decorationConnectedInnerRadius =>
      decoration?.connectedInnerRadius;
  WidgetStateProperty<Color?>? get decorationOverlayColor =>
      decoration?.overlayColor;
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

class _M3EToggleButtonState extends State<M3EToggleButton>
    with M3EBaseButtonState<M3EToggleButton> {
  late bool _localChecked;
  late M3EButtonMeasurements _measurements;

  M3EButtonTheme get _buttonTheme => M3ETheme.of(context).buttonTheme;

  M3EToggleButtonTheme get _toggleTheme =>
      M3ETheme.of(context).toggleButtonTheme;

  M3EToggleButtonGroupTheme get _groupTheme =>
      M3ETheme.of(context).toggleButtonGroupTheme;

  M3EColorScheme get _scheme => M3ETheme.of(context).colorScheme;

  Widget? _cachedIcon;
  Widget? _cachedLabel;
  bool _cachedIconChecked = false;
  bool _cachedLabelChecked = false;

  bool get _isChecked => widget.checked ?? _localChecked;
  bool get _hasLabel => _isChecked
      ? (widget.checkedLabel != null || widget.label != null)
      : widget.label != null;

  Widget? get _effectiveIcon {
    final checked = _isChecked;
    if (_cachedIconChecked == checked && _cachedIcon != null) {
      return _cachedIcon;
    }
    return _cachedIcon = () {
      _cachedIconChecked = checked;
      return checked ? (widget.checkedIcon ?? widget.icon) : widget.icon;
    }();
  }

  Widget? get _effectiveLabel {
    final checked = _isChecked;
    if (_cachedLabelChecked == checked && _cachedLabel != null) {
      return _cachedLabel;
    }
    return _cachedLabel = () {
      _cachedLabelChecked = checked;
      return checked
          ? (widget.checkedLabel ?? widget.label)
          : widget.label;
    }();
  }

  @override
  M3EButtonSize get buttonSize => widget.size;

  @override
  WidgetStatesController? get externalStatesController =>
      widget.statesController;

  @override
  FocusNode? get externalFocusNode => widget.focusNode;

  @override
  M3EButtonMotion? get effectiveMotion =>
      widget.decorationMotion ?? M3EButtonMotion.expressiveSpatialPress;

  @override
  void initState() {
    super.initState();
    _localChecked = widget.checked ?? false;
    initBaseButtonState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMeasurements();
    updateLabelStyle(context);
    updateSpringMotion();
  }

  void _updateMeasurements() {
    _measurements = _buttonTheme.measurements(widget.size);
  }

  @override
  void didUpdateWidget(covariant M3EToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleStatesControllerUpdate(
      oldWidget.statesController,
      widget.statesController,
    );
    handleFocusNodeUpdate(oldWidget.focusNode, widget.focusNode);
    if (widget.checked != null && oldWidget.checked != widget.checked) {
      _localChecked = widget.checked!;
    }
    if (oldWidget.size != widget.size) {
      _updateMeasurements();
    }
    if (oldWidget.size != widget.size ||
        oldWidget.checked != widget.checked ||
        oldWidget.decoration?.foregroundColor !=
            widget.decoration?.foregroundColor ||
        oldWidget.style != widget.style) {
      updateLabelStyle(context);
    }
    if (widget.decoration?.motion != oldWidget.decoration?.motion) {
      updateSpringMotion();
    }
    if (widget.icon != oldWidget.icon ||
        widget.checkedIcon != oldWidget.checkedIcon ||
        widget.label != oldWidget.label ||
        widget.checkedLabel != oldWidget.checkedLabel) {
      _cachedIcon = null;
      _cachedLabel = null;
    }
  }

  void _handleTap() {
    if (!widget.enabled) {
      return;
    }
    if (widget.decorationHaptic != M3EHapticFeedback.none) {
      M3EButtonConstants.triggerHapticFeedback(widget.decorationHaptic);
    }
    final newChecked = !_isChecked;
    if (widget.checked == null) {
      setState(() => _localChecked = newChecked);
    }
    widget.onCheckedChange?.call(newChecked);
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: _buildWidget,
    );
  }

  Widget _buildWidget(BuildContext context) {
    final m = _measurements;
    final checked = _isChecked;

    final double halfHeight = m.height / 2;
    final double? explicitBorderRadius = widget.decorationBorderRadius;
    final double squareRad = _buttonTheme.squareRadius(widget.size);
    final double pressRad = _buttonTheme.pressedRadius(widget.size);
    final fullyRound = BorderRadius.circular(halfHeight);
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    final double outerRad = explicitBorderRadius ?? halfHeight;
    final double innerRad =
        explicitBorderRadius ??
            widget.decorationConnectedInnerRadius ??
            _groupTheme.connectedInnerRadius;
    final double pressInnerRad =
        widget.decorationPressedRadius ??
            explicitBorderRadius ??
            _groupTheme.connectedPressedInnerRadius;

    final bool freezeStart = widget.isFirstInGroup;
    final bool freezeEnd = widget.isLastInGroup;
    final freezeLeft = isRtl ? freezeEnd : freezeStart;
    final freezeRight = isRtl ? freezeStart : freezeEnd;

    final restingShape = widget.decorationUncheckedRadius != null
        ? BorderRadius.circular(widget.decorationUncheckedRadius!)
        : explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : fullyRound;
    final squareShape = BorderRadius.circular(
      widget.decorationCheckedRadius ?? explicitBorderRadius ?? squareRad,
    );
    final pressSquish = BorderRadius.circular(
      widget.decorationPressedRadius ?? explicitBorderRadius ?? pressRad,
    );
    final checkedConnectedShape = explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : fullyRound;

    final double hPad = _hasLabel ? m.hPadding : m.hPadding / 2;

    return wrapWithPointerPressTracking(
      enabled: widget.enabled,
      child: buildAnimatedContent(
      builder: (context, pressed, hovered, focused) {
        final BorderRadius targetRadius;
        final effectivelyEnabled = widget.enabled;
        if (widget.isGroupConnected) {
          final BorderRadius restingRadius = BorderRadiusDirectional.horizontal(
            start: Radius.circular(widget.isFirstInGroup ? outerRad : innerRad),
            end: Radius.circular(widget.isLastInGroup ? outerRad : innerRad),
          ).resolve(Directionality.of(context));

          final BorderRadius pressRadius = BorderRadiusDirectional.horizontal(
            start: Radius.circular(
              widget.isFirstInGroup ? outerRad : pressInnerRad,
            ),
            end: Radius.circular(
              widget.isLastInGroup ? outerRad : pressInnerRad,
            ),
          ).resolve(Directionality.of(context));

          final double hoverInnerRad =
              widget.decoration?.hoveredRadius ??
                  explicitBorderRadius ??
                  _buttonTheme.hoveredRadius(widget.size);
          final BorderRadius hoverRadius = BorderRadiusDirectional.horizontal(
            start: Radius.circular(
              widget.isFirstInGroup ? outerRad : hoverInnerRad,
            ),
            end: Radius.circular(
              widget.isLastInGroup ? outerRad : hoverInnerRad,
            ),
          ).resolve(Directionality.of(context));

          targetRadius = (effectivelyEnabled && pressed)
              ? pressRadius
              : (effectivelyEnabled && hovered)
              ? hoverRadius
              : checked
              ? checkedConnectedShape
              : restingRadius;
        } else {
          final hoverShape =
          widget.decoration?.hoveredRadius != null
              ? BorderRadius.circular(widget.decoration!.hoveredRadius!)
              : explicitBorderRadius != null
              ? BorderRadius.circular(explicitBorderRadius)
              : BorderRadius.circular(_buttonTheme.hoveredRadius(widget.size));

          targetRadius = (effectivelyEnabled && pressed)
              ? pressSquish
              : (effectivelyEnabled && hovered)
              ? hoverShape
              : checked
              ? squareShape
              : restingShape;
        }

        Widget core = RepaintBoundary(
          child: M3ERadiusAndPaddingMotion(
            motion: springMotion,
            internalLeft: hPad,
            internalRight: hPad,
            internalTop: 0,
            internalBottom: 0,
            targetRadius: targetRadius,
            freezeTopLeft: widget.isGroupConnected && freezeLeft,
            freezeBottomLeft: widget.isGroupConnected && freezeLeft,
            freezeTopRight: widget.isGroupConnected && freezeRight,
            freezeBottomRight: widget.isGroupConnected && freezeRight,
            builder: (animatedPadding, animatedRadius) {
              final buttonCore = _buildCore(m, animatedPadding, animatedRadius);
              return M3EFocusRing(
                focused: focused,
                radius: animatedRadius,
                child: buttonCore,
              );
            },
          ),
        );

        final fixedWidth = widget.size.width;
        if (fixedWidth != null) {
          core = SizedBox(width: fixedWidth, child: core);
        }

        return core;
      },
    ),
    );
  }

  Widget _buildCore(
      M3EButtonMeasurements m,
      EdgeInsets internalPadding,
      BorderRadius animatedRadius,
      ) {
    final checked = _isChecked;

    final buttonShape = WidgetStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: animatedRadius),
    );
    final padding = WidgetStateProperty.all<EdgeInsetsGeometry>(
      internalPadding,
    );

    final style = _buildButtonStyle(checked, buttonShape, padding);

    final Widget content = _buildContent(m, checked);

    final VoidCallback? onPressed = widget.enabled ? _handleTap : null;

    Widget button;
    switch (widget.style) {
      case M3EButtonStyle.filled:
        button = FilledButton(
          style: style,
          onPressed: onPressed,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: content,
        );
      case M3EButtonStyle.tonal:
        button = FilledButton.tonal(
          style: style,
          onPressed: onPressed,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: content,
        );
      case M3EButtonStyle.elevated:
        button = ElevatedButton(
          style: style,
          onPressed: onPressed,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: content,
        );
      case M3EButtonStyle.outlined:
        button = OutlinedButton(
          style: style,
          onPressed: onPressed,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: content,
        );
      case M3EButtonStyle.text:
        button = TextButton(
          style: style,
          onPressed: onPressed,
          onLongPress: widget.enabled ? widget.onLongPress : null,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: content,
        );
    }

    Widget result = M3EInkSplashTheme(
      color: _resolvedForegroundColor(checked),
      child: button,
    );
    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip, child: result);
    }

    return Semantics(
      label: widget.semanticLabel,
      checked: _isChecked,
      child: result,
    );
  }

  Color _resolvedForegroundColor(bool checked) {
    final cs = _scheme;
    switch (widget.style) {
      case M3EButtonStyle.filled:
        return checked ? cs.onPrimary : cs.onSurfaceVariant;
      case M3EButtonStyle.elevated:
        return checked ? cs.onPrimary : cs.primary;
      case M3EButtonStyle.tonal:
        return checked ? cs.onSecondaryContainer : cs.onSurfaceVariant;
      case M3EButtonStyle.outlined:
        return checked ? cs.onSecondaryContainer : cs.onSurface;
      case M3EButtonStyle.text:
        return checked ? cs.primary : cs.onSurface;
    }
  }

  ButtonStyle _buildButtonStyle(
      bool checked,
      WidgetStateProperty<OutlinedBorder> buttonShape,
      WidgetStateProperty<EdgeInsetsGeometry> padding,
      ) {
    final cs = _scheme;

    final Color bgColor;
    final Color fgColor = _resolvedForegroundColor(checked);

    switch (widget.style) {
      case M3EButtonStyle.filled:
        bgColor = checked ? cs.primary : cs.surfaceContainerHighest;

      case M3EButtonStyle.elevated:
        bgColor = checked ? cs.primary : cs.surfaceContainerLow;

      case M3EButtonStyle.tonal:
        bgColor = checked ? cs.secondaryContainer : cs.surfaceContainerHighest;

      case M3EButtonStyle.outlined:
        bgColor = checked ? cs.secondaryContainer : Colors.transparent;

      case M3EButtonStyle.text:
        bgColor = Colors.transparent;
    }

    final bool transparent =
        widget.style == M3EButtonStyle.outlined ||
            widget.style == M3EButtonStyle.text;

    return ButtonStyle(
      alignment: _kAlignmentCenter,
      textStyle: WidgetStateProperty.all(labelStyle),
      minimumSize: WidgetStateProperty.all(Size(0, _measurements.height)),
      padding: padding,
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        final activeStates = checked
            ? {...states, WidgetState.selected}
            : states;

        if (widget.decoration?.foregroundColor != null) {
          final color = widget.decoration!.foregroundColor!.resolve(
            activeStates,
          );
          if (color != null) {
            return color;
          }
        }

        if (states.contains(WidgetState.disabled)) {
          return cs.onSurface.withValues(
            alpha: M3EButtonConstants.kDisabledForegroundAlpha,
          );
        }
        return fgColor;
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        final activeStates = checked
            ? {...states, WidgetState.selected}
            : states;

        if (widget.decoration?.backgroundColor != null) {
          final color = widget.decoration!.backgroundColor!.resolve(
            activeStates,
          );
          if (color != null) {
            return color;
          }
        }

        if (states.contains(WidgetState.disabled)) {
          return transparent
              ? Colors.transparent
              : cs.onSurface.withValues(
            alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
          );
        }
        return transparent ? Colors.transparent : bgColor;
      }),
      shape: buttonShape,
      elevation: WidgetStateProperty.resolveWith((states) {
        return _buttonTheme.elevation(widget.style, states);
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final activeStates = checked
            ? {...states, WidgetState.selected}
            : states;
        if (widget.decoration?.side != null) {
          final s = widget.decoration!.side!.resolve(activeStates);
          if (s != null) {
            return s;
          }
        }
        final isOutlined = widget.style == M3EButtonStyle.outlined;
        if (!isOutlined) {
          return BorderSide.none;
        }

        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: cs.onSurface.withValues(
              alpha: M3EButtonConstants.kDisabledOutlineAlpha,
            ),
          );
        }
        return BorderSide(color: _buttonTheme.outline(_scheme));
      }),
      mouseCursor: WidgetStateProperty.resolveWith((states) {
        if (widget.decoration?.mouseCursor != null) {
          final cursor = widget.decoration!.mouseCursor!.resolve(states);
          if (cursor != null) {
            return cursor;
          }
        }
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.basic;
        }
        return widget.mouseCursor ?? SystemMouseCursors.click;
      }),
      animationDuration: _kDurationZero,
      visualDensity: _kVisualDensityStandard,
      splashFactory: widget.splashFactory ?? InkSparkle.splashFactory,
      overlayColor: widget.decorationOverlayColor ??
          WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.pressed)) {
              return null;
            }
            final activeStates = checked
                ? {...states, WidgetState.selected}
                : states;
            Color? foreground;
            if (widget.decoration?.foregroundColor != null) {
              foreground =
                  widget.decoration!.foregroundColor!.resolve(activeStates);
            }
            foreground ??= fgColor;
            return M3EStateLayer.resolveOverlayColor(foreground, states);
          }),
      surfaceTintColor: widget.decorationSurfaceTintColor,
      enableFeedback: widget.enableFeedback,
    );
  }

  Widget _buildContent(M3EButtonMeasurements m, bool checked) {
    final Widget? effectiveIcon = _effectiveIcon;
    final Widget? uncheckedLabel = widget.label;
    final Widget? checkedLabel = widget.checkedLabel ?? widget.label;
    final bool animateIconToCheckedLabel =
        widget.icon != null &&
            widget.checkedLabel != null &&
            widget.label == null &&
            widget.checkedIcon == null;
    final bool animateLabelToCheckedIcon =
        widget.checkedIcon != null &&
            widget.label != null &&
            widget.icon == null &&
            widget.checkedLabel == null;

    if (effectiveIcon == null &&
        uncheckedLabel == null &&
        checkedLabel == null) {
      return const SizedBox.shrink();
    }

    Widget? iconWidget;
    if (effectiveIcon != null) {
      iconWidget = RepaintBoundary(
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: m.height / 3,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
          softWrap: false,
          child: IconTheme.merge(
            data: IconThemeData(size: m.iconSize),
            child: effectiveIcon,
          ),
        ),
      );
    }

    final hasUncheckedLabel = uncheckedLabel != null;
    final hasCheckedLabel = checkedLabel != null;
    final bool hasDistinctLabelStates =
        animateIconToCheckedLabel || animateLabelToCheckedIcon;

    final motion = _labelTransitionMotion();

    Widget buildRow(double progress) {
      final p = _boundedProgress(progress);
      final activeLabelProgress = _lerp(
        hasUncheckedLabel ? 1.0 : 0.0,
        hasCheckedLabel ? 1.0 : 0.0,
        p,
      );

      Widget? labelWidget;
      if (hasDistinctLabelStates) {
        labelWidget = _buildAnimatedLabelSlot(
          uncheckedLabel: uncheckedLabel,
          checkedLabel: checkedLabel,
          progress: p,
        );
      } else if (_effectiveLabel != null) {
        labelWidget = _buildLabelText(_effectiveLabel!, checked: checked);
      }

      final Widget? gapWidget = (iconWidget != null && labelWidget != null)
          ? SizedBox(width: m.iconGap * activeLabelProgress)
          : null;

      if (iconWidget != null && labelWidget != null) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [iconWidget, gapWidget!, labelWidget],
        );
      }

      return iconWidget ?? labelWidget ?? const SizedBox.shrink();
    }

    final Widget naturalRow = hasDistinctLabelStates
        ? SingleMotionBuilder(
      motion: motion,
      value: checked ? 1.0 : 0.0,
      builder: (context, progress, _) => buildRow(progress),
    )
        : buildRow(checked ? 1.0 : 0.0);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (!constraints.hasBoundedWidth) {
          return naturalRow;
        }
        return SizedBox(
          height: m.height,
          child: FittedBox(
            fit: BoxFit.none,
            clipBehavior: Clip.hardEdge,
            child: naturalRow,
          ),
        );
      },
    );
  }

  Widget _buildLabelText(Widget child, {required bool checked}) {
    return KeyedSubtree(
      key: ValueKey('toggle-label-$checked-${child.hashCode}'),
      child: DefaultTextStyle.merge(maxLines: 1, softWrap: false, child: child),
    );
  }

  Widget _buildAnimatedLabelSlot({
    required Widget? uncheckedLabel,
    required Widget? checkedLabel,
    required double progress,
  }) {
    final unchecked = uncheckedLabel != null
        ? _buildLabelText(uncheckedLabel, checked: false)
        : null;
    final checked = checkedLabel != null
        ? _buildLabelText(checkedLabel, checked: true)
        : null;

    final p = _boundedProgress(progress);
    final hasBothLabels = unchecked != null && checked != null;
    final shouldSlideOneSidedCheckedAppear =
        widget.icon != null &&
            widget.checkedLabel != null &&
            widget.label == null &&
            widget.checkedIcon == null;

    final outgoingSlide =
        hasBothLabels ? _toggleTheme.labelSlideDistance * p : 0.0;
    final incomingSlide =
    (hasBothLabels ||
        (shouldSlideOneSidedCheckedAppear &&
            unchecked == null &&
            checked != null))
        ? _toggleTheme.labelSlideDistance * (1.0 - p)
        : 0.0;

    final outgoingOpacity = hasBothLabels ? (1.0 - p) : _lingerOpacity(1.0 - p);
    final incomingOpacity = hasBothLabels ? p : _lingerOpacity(p);

    return ClipRect(
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          if (unchecked != null)
            Align(
              widthFactor: 1.0 - p,
              alignment: Alignment.centerLeft,
              child: Opacity(
                opacity: outgoingOpacity,
                child: Transform.translate(
                  offset: Offset(-outgoingSlide, 0),
                  child: unchecked,
                ),
              ),
            ),
          if (checked != null)
            Align(
              widthFactor: p,
              alignment: Alignment.centerLeft,
              child: Opacity(
                opacity: incomingOpacity,
                child: Transform.translate(
                  offset: Offset(incomingSlide, 0),
                  child: checked,
                ),
              ),
            ),
        ],
      ),
    );
  }

  SpringMotion _labelTransitionMotion() {
    final base = effectiveMotion ?? M3EButtonMotion.standard;
    final damping = base.damping < 1.05 ? 1.05 : base.damping;
    final stiffness = base.stiffness * 0.5;
    return M3EButtonMotion.custom(stiffness, damping).toMotion();
  }

  double _boundedProgress(double t) => t.clamp(0.0, 1.0);

  double _lingerOpacity(double t) {
    final p = _boundedProgress(t);
    if (p >= 0.45) {
      return 1;
    }
    return p / 0.45;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}
