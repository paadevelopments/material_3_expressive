// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

import 'package:material_3_expressive/components/buttons/internal/_tokens_adapter.dart';
import 'package:material_3_expressive/components/buttons/internal/_button_motion.dart';
import 'package:material_3_expressive/components/buttons/internal/m3e_base_button_state.dart';
import 'package:material_3_expressive/components/buttons/style/button_tokens_adapter.dart';
import 'package:material_3_expressive/components/buttons/style/m3e_button_decoration.dart';
import 'package:material_3_expressive/components/buttons/style/m3e_button_enums.dart';
import 'package:material_3_expressive/components/buttons/style/m3e_button_motion.dart';
import 'package:material_3_expressive/components/buttons/internal/button_constants.dart';

const Alignment _kAlignmentCenter = Alignment.center;
const VisualDensity _kVisualDensityStandard = VisualDensity.standard;
const Duration _kDurationZero = Duration.zero;
const InteractiveInkFeatureFactory _kDefaultSplashFactory =
    InkRipple.splashFactory;
const bool _kDefaultEnableFeedback = true;
const double _kLabelSlideDistance = 10.0;
final SpringMotion _kPressedRadiusMotion = M3EButtonMotion.expressiveEffectsFast
    .toMotion();

// ---------------------------------------------------------------------------
// M3EToggleButton
// ---------------------------------------------------------------------------

/// Material 3 Expressive Toggle Button.
///
/// Morphs between round (unchecked) and square (checked) shapes.
///
/// Supports icon-only, icon+label, and label-only content. When used inside
/// [M3EButtonGroup], group-level layout can animate available width while
/// this widget keeps its own content and shape animation behavior consistent.
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
  ///
  /// See [M3EButtonStyle] for available styles (filled, outlined, tonal, etc.).
  final M3EButtonStyle style;

  /// Size variant of the toggle button.
  ///
  /// See [M3EButtonSize] for available sizes (xs, sm, md, lg, xl).
  final M3EButtonSize size;

  /// Whether the toggle button is enabled.
  final bool enabled;

  /// Whether this button is part of a connected button group.
  ///
  /// When true, the button shares its inner corners with adjacent buttons.
  final bool isGroupConnected;

  /// Whether this is the first button in a connected group.
  ///
  /// Controls the outer corner radius on the leading edge.
  final bool isFirstInGroup;

  /// Whether this is the last button in a connected group.
  ///
  /// Controls the outer corner radius on the trailing edge.
  final bool isLastInGroup;

  /// Optional decoration that bundles styling properties together.
  ///
  /// When provided, decoration values take precedence over individual flat
  /// parameters (e.g. [backgroundColor], [foregroundColor], etc.).
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
  ///
  /// Allows programmatic control of pressed, hovered, focused states.
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
  ///
  /// Defaults to true.
  final bool enableFeedback;

  /// The splash factory for the ink ripple effect.
  ///
  /// See [InteractiveInkFeatureFactory] for available options.
  final InteractiveInkFeatureFactory? splashFactory;

  @override
  State<M3EToggleButton> createState() => _M3EToggleButtonState();
}

class _M3EToggleButtonState extends State<M3EToggleButton>
    with M3EBaseButtonState<M3EToggleButton> {
  late bool _localChecked;
  late M3EButtonTokensAdapter _tokens;
  late M3EButtonMeasurements _measurements;

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
    _cachedIconChecked = checked;
    _cachedIcon = checked ? (widget.checkedIcon ?? widget.icon) : widget.icon;
    return _cachedIcon;
  }

  Widget? get _effectiveLabel {
    final checked = _isChecked;
    if (_cachedLabelChecked == checked && _cachedLabel != null) {
      return _cachedLabel;
    }
    _cachedLabelChecked = checked;
    _cachedLabel = checked
        ? (widget.checkedLabel ?? widget.label)
        : widget.label;
    return _cachedLabel;
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
      widget.decorationMotion ?? M3EButtonMotion.expressiveSpatialDefault;

  @override
  void initState() {
    super.initState();
    _localChecked = widget.checked ?? false;
    initBaseButtonState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tokens = M3EButtonTokensAdapter(context);
    _tokens.didChangeDependencies();
    _updateMeasurements();
    updateLabelStyle(context);
    updateSpringMotion();
  }

  void _updateMeasurements() {
    _measurements = _tokens.measurements(widget.size);
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
    if (!widget.enabled) return;
    if (widget.decorationHaptic != M3EHapticFeedback.none) {
      ButtonConstants.triggerHapticFeedback(widget.decorationHaptic);
    }
    final newChecked = !_isChecked;
    if (widget.checked == null) setState(() => _localChecked = newChecked);
    widget.onCheckedChange?.call(newChecked);
  }

  @override
  Widget build(BuildContext context) {
    final m = _measurements;
    final checked = _isChecked;

    final double halfHeight = m.height / 2;
    final double? explicitBorderRadius = widget.decorationBorderRadius;
    final double squareRad = _tokens.squareRadius(widget.size);
    final double pressRad = _tokens.pressedRadius(widget.size);
    final BorderRadius fullyRound = BorderRadius.circular(halfHeight);
    final bool isRtl = Directionality.of(context) == TextDirection.rtl;

    final double outerRad = explicitBorderRadius ?? halfHeight;
    final double innerRad =
        explicitBorderRadius ??
        widget.decorationConnectedInnerRadius ??
        ButtonGroupTokens.kConnectedInnerRadius;
    final double pressInnerRad =
        widget.decorationPressedRadius ??
        explicitBorderRadius ??
        ButtonGroupTokens.kConnectedPressedInnerRadius;

    final bool freezeStart = widget.isFirstInGroup;
    final bool freezeEnd = widget.isLastInGroup;
    final bool freezeLeft = isRtl ? freezeEnd : freezeStart;
    final bool freezeRight = isRtl ? freezeStart : freezeEnd;

    final BorderRadius restingShape = widget.decorationUncheckedRadius != null
        ? BorderRadius.circular(widget.decorationUncheckedRadius!)
        : explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : fullyRound;
    final BorderRadius squareShape = BorderRadius.circular(
      widget.decorationCheckedRadius ?? explicitBorderRadius ?? squareRad,
    );
    final BorderRadius pressSquish = BorderRadius.circular(
      widget.decorationPressedRadius ?? explicitBorderRadius ?? pressRad,
    );
    final BorderRadius checkedConnectedShape = explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : fullyRound;

    final double hPad = _hasLabel ? m.hPadding : m.hPadding / 2;

    return buildAnimatedContent(
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
              _tokens.hoveredRadius(widget.size);
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
          final BorderRadius hoverShape =
              widget.decoration?.hoveredRadius != null
              ? BorderRadius.circular(widget.decoration!.hoveredRadius!)
              : explicitBorderRadius != null
              ? BorderRadius.circular(explicitBorderRadius)
              : BorderRadius.circular(_tokens.hoveredRadius(widget.size));

          targetRadius = (effectivelyEnabled && pressed)
              ? pressSquish
              : (effectivelyEnabled && hovered)
              ? hoverShape
              : checked
              ? squareShape
              : restingShape;
        }

        Widget core = RepaintBoundary(
          child: RadiusAndPaddingMotion(
            motion: (effectivelyEnabled && pressed)
                ? _kPressedRadiusMotion
                : springMotion,
            internalLeft: hPad,
            internalRight: hPad,
            internalTop: 0,
            internalBottom: 0,
            targetRadius: targetRadius,
            freezeTopLeft: widget.isGroupConnected ? freezeLeft : false,
            freezeBottomLeft: widget.isGroupConnected ? freezeLeft : false,
            freezeTopRight: widget.isGroupConnected ? freezeRight : false,
            freezeBottomRight: widget.isGroupConnected ? freezeRight : false,
            builder: (animatedPadding, animatedRadius) {
              final buttonCore = _buildCore(m, animatedPadding, animatedRadius);
              return FocusRing(
                focused: focused,
                radius: animatedRadius,
                child: buttonCore,
              );
            },
          ),
        );

        final fixedWidth = widget.size.width;
        if (fixedWidth != null) core = SizedBox(width: fixedWidth, child: core);

        return core;
      },
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

    Widget result = button;
    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }

    return Semantics(
      label: widget.semanticLabel,
      checked: _isChecked,
      child: result,
    );
  }

  ButtonStyle _buildButtonStyle(
    bool checked,
    WidgetStateProperty<OutlinedBorder> buttonShape,
    WidgetStateProperty<EdgeInsetsGeometry> padding,
  ) {
    final tokens = _tokens;
    final cs = tokens.c;

    final Color bgColor;
    final Color fgColor;

    switch (widget.style) {
      case M3EButtonStyle.filled:
        bgColor = checked ? cs.primary : cs.surfaceContainerHighest;
        fgColor = checked ? cs.onPrimary : cs.onSurfaceVariant;
        break;

      case M3EButtonStyle.elevated:
        bgColor = checked ? cs.primary : cs.surfaceContainerLow;
        fgColor = checked ? cs.onPrimary : cs.primary;
        break;

      case M3EButtonStyle.tonal:
        bgColor = checked ? cs.secondaryContainer : cs.surfaceContainerHighest;
        fgColor = checked ? cs.onSecondaryContainer : cs.onSurfaceVariant;
        break;

      case M3EButtonStyle.outlined:
        bgColor = checked ? cs.secondaryContainer : Colors.transparent;
        fgColor = checked ? cs.onSecondaryContainer : cs.onSurface;
        break;

      case M3EButtonStyle.text:
        bgColor = Colors.transparent;
        fgColor = checked ? cs.primary : cs.onSurface;
        break;
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
          if (color != null) return color;
        }

        if (states.contains(WidgetState.disabled)) {
          return cs.onSurface.withValues(
            alpha: ButtonConstants.kDisabledForegroundAlpha,
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
          if (color != null) return color;
        }

        if (states.contains(WidgetState.disabled)) {
          return transparent
              ? Colors.transparent
              : cs.onSurface.withValues(
                  alpha: ButtonConstants.kDisabledBackgroundAlpha,
                );
        }
        return transparent ? Colors.transparent : bgColor;
      }),
      shape: buttonShape,
      elevation: WidgetStateProperty.resolveWith((states) {
        return tokens.elevation(widget.style, states);
      }),
      side: WidgetStateProperty.resolveWith((states) {
        final activeStates = checked
            ? {...states, WidgetState.selected}
            : states;
        if (widget.decoration?.side != null) {
          final s = widget.decoration!.side!.resolve(activeStates);
          if (s != null) return s;
        }
        final isOutlined = widget.style == M3EButtonStyle.outlined;
        if (!isOutlined) return BorderSide.none;

        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: cs.onSurface.withValues(
              alpha: ButtonConstants.kDisabledOutlineAlpha,
            ),
            width: 1,
          );
        }
        return BorderSide(color: tokens.outline(), width: 1);
      }),
      mouseCursor: WidgetStateProperty.resolveWith((states) {
        if (widget.decoration?.mouseCursor != null) {
          final cursor = widget.decoration!.mouseCursor!.resolve(states);
          if (cursor != null) return cursor;
        }
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.basic;
        }
        return widget.mouseCursor ?? SystemMouseCursors.click;
      }),
      animationDuration: _kDurationZero,
      visualDensity: _kVisualDensityStandard,
      splashFactory: widget.splashFactory ?? _kDefaultSplashFactory,
      overlayColor: widget.decorationOverlayColor,
      surfaceTintColor: widget.decorationSurfaceTintColor,
      enableFeedback: widget.enableFeedback,
    );
  }

  /// Builds icon-only, icon+label, or label-only content.
  ///
  /// The button always renders at its natural preferred size. Any
  /// neighbor-squish compression is applied externally by `_AnimatedWidthToggle`.
  ///
  /// The content row uses a `SizedBox(height: m.height)` + `FittedBox` wrapper
  /// so Flutter measures it at natural width first, then clips it to the
  /// squeezed width without overflow assertions. The same path is used by the
  /// offstage measurer so measured widths match visible output.
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

    final bool hasUncheckedLabel = uncheckedLabel != null;
    final bool hasCheckedLabel = checkedLabel != null;
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
          ? SizedBox(width: m.iconGap.toDouble() * activeLabelProgress)
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
            alignment: _kAlignmentCenter,
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

    // In one-sided transitions (label -> none or none -> label), sliding plus
    // clipping can make text disappear too early. Keep slide only for
    // two-sided swaps, except the explicit unchecked-empty -> checked-content
    // case where we want text fade+slide in.
    final outgoingSlide = hasBothLabels ? _kLabelSlideDistance * p : 0.0;
    final incomingSlide =
        (hasBothLabels ||
            (shouldSlideOneSidedCheckedAppear &&
                unchecked == null &&
                checked != null))
        ? _kLabelSlideDistance * (1.0 - p)
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
    final base = effectiveMotion ?? M3EButtonMotion.expressiveSpatialDefault;

    // Keep label transitions monotonic near the destination and a touch slower
    // than structural motion so collapse remains visible and continuous.
    final damping = base.damping < 1.05 ? 1.05 : base.damping;
    final stiffness = base.stiffness * 0.5;
    return M3EButtonMotion.custom(stiffness, damping).toMotion();
  }

  double _boundedProgress(double t) => t.clamp(0.0, 1.0);

  double _lingerOpacity(double t) {
    final p = _boundedProgress(t);
    // Keep text visible for most of the travel and fade near the end.
    if (p >= 0.45) return 1.0;
    return p / 0.45;
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

// ── Specialized subclasses ────────────────────────────────────────────────────

/// A filled-style [M3EToggleButton].
///
/// Equivalent to `M3EToggleButton(style: M3EButtonStyle.filled, ...)`.
///
/// The group-connectivity parameters (`isGroupConnected`, `isFirstInGroup`,
/// `isLastInGroup`) are intentionally hidden — they are managed automatically
/// by [M3EButtonGroup] and should not be set by consumers.
class M3EFilledToggleButton extends M3EToggleButton {
  const M3EFilledToggleButton({
    super.key,
    super.onCheckedChange,
    super.icon,
    super.checkedIcon,
    super.label,
    super.checkedLabel,
    super.checked,
    super.size,
    super.enabled,
    super.decoration,
    super.mouseCursor,
    super.statesController,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.filled,
         isGroupConnected: false,
         isFirstInGroup: true,
         isLastInGroup: true,
       );

  /// A tonal-style [M3EToggleButton].
  ///
  /// Equivalent to `M3EToggleButton(style: M3EButtonStyle.tonal, ...)`.
  const M3EFilledToggleButton.tonal({
    super.key,
    super.onCheckedChange,
    super.icon,
    super.checkedIcon,
    super.label,
    super.checkedLabel,
    super.checked,
    super.size,
    super.enabled,
    super.decoration,
    super.mouseCursor,
    super.statesController,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.tonal,
         isGroupConnected: false,
         isFirstInGroup: true,
         isLastInGroup: true,
       );
}

/// An elevated-style [M3EToggleButton].
///
/// Equivalent to `M3EToggleButton(style: M3EButtonStyle.elevated, ...)`.
///
/// The group-connectivity parameters are intentionally hidden — they are managed
/// automatically by [M3EButtonGroup].
class M3EElevatedToggleButton extends M3EToggleButton {
  const M3EElevatedToggleButton({
    super.key,
    super.onCheckedChange,
    super.icon,
    super.checkedIcon,
    super.label,
    super.checkedLabel,
    super.checked,
    super.size,
    super.enabled,
    super.decoration,
    super.mouseCursor,
    super.statesController,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.elevated,
         isGroupConnected: false,
         isFirstInGroup: true,
         isLastInGroup: true,
       );
}

/// An outlined-style [M3EToggleButton].
///
/// Equivalent to `M3EToggleButton(style: M3EButtonStyle.outlined, ...)`.
///
/// The group-connectivity parameters are intentionally hidden — they are managed
/// automatically by [M3EButtonGroup].
class M3EOutlinedToggleButton extends M3EToggleButton {
  const M3EOutlinedToggleButton({
    super.key,
    super.onCheckedChange,
    super.icon,
    super.checkedIcon,
    super.label,
    super.checkedLabel,
    super.checked,
    super.size,
    super.enabled,
    super.decoration,
    super.mouseCursor,
    super.statesController,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.outlined,
         isGroupConnected: false,
         isFirstInGroup: true,
         isLastInGroup: true,
       );
}

/// A text-style [M3EToggleButton].
///
/// Equivalent to `M3EToggleButton(style: M3EButtonStyle.text, ...)`.
///
/// The group-connectivity parameters are intentionally hidden — they are managed
/// automatically by [M3EButtonGroup].
class M3ETextToggleButton extends M3EToggleButton {
  const M3ETextToggleButton({
    super.key,
    super.onCheckedChange,
    super.icon,
    super.checkedIcon,
    super.label,
    super.checkedLabel,
    super.checked,
    super.size,
    super.enabled,
    super.decoration,
    super.mouseCursor,
    super.statesController,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.text,
         isGroupConnected: false,
         isFirstInGroup: true,
         isLastInGroup: true,
       );
}
