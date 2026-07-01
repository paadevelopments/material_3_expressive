// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:material_3_expressive/components/buttons/internal/_button_motion.dart';
import 'package:material_3_expressive/components/buttons/internal/button_constants.dart';
import 'package:material_3_expressive/components/buttons/internal/m3e_base_button_state.dart';
import 'package:material_3_expressive/components/buttons/style/button_tokens_adapter.dart';
import 'package:material_3_expressive/components/buttons/style/m3e_button_decoration.dart';
import 'package:material_3_expressive/components/buttons/style/m3e_button_enums.dart';
import 'package:material_3_expressive/components/buttons/style/m3e_button_motion.dart';

const Alignment _kAlignmentCenter = Alignment.center;
const VisualDensity _kVisualDensityStandard = VisualDensity.standard;
const Duration _kDurationZero = Duration.zero;
const InteractiveInkFeatureFactory _kDefaultSplashFactory =
    InkRipple.splashFactory;
const bool _kDefaultEnableFeedback = true;
final _kPressedRadiusMotion = M3EButtonMotion.expressiveEffectsFast.toMotion();

class M3EButton extends StatefulWidget {
  const M3EButton({
    super.key,
    required this.onPressed,
    this.child,
    this.style = M3EButtonStyle.filled,
    this.size = M3EButtonSize.sm,
    this.shape = M3EButtonShape.round,
    this.enabled = true,
    this.statesController,
    this.decoration,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.semanticLabel,
    this.tooltip,
    this.mouseCursor = SystemMouseCursors.click,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  });

  /// Factory for a button with an icon and label.
  factory M3EButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    M3EButtonStyle style = M3EButtonStyle.filled,
    M3EButtonSize size = M3EButtonSize.sm,
    M3EButtonShape shape = M3EButtonShape.round,
    bool enabled = true,
    WidgetStatesController? statesController,
    M3EButtonDecoration? decoration,
    FocusNode? focusNode,
    bool autofocus = false,
    ValueChanged<bool>? onFocusChange,
    String? semanticLabel,
    String? tooltip,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    bool enableFeedback = _kDefaultEnableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return M3EButton(
      key: key,
      onPressed: onPressed,
      style: style,
      size: size,
      shape: shape,
      enabled: enabled,
      statesController: statesController,
      decoration: decoration,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      mouseCursor: mouseCursor,
      onLongPress: onLongPress,
      onHover: onHover,
      enableFeedback: enableFeedback,
      splashFactory: splashFactory,
      child: _M3EButtonIconLayout(
        icon: icon,
        label: label,
        size: size,
        iconAlignment: decoration?.iconAlignment ?? IconAlignment.start,
      ),
    );
  }

  /// Callback invoked when the button is pressed. Null disables the button.
  final VoidCallback? onPressed;

  /// The child content of the button.
  final Widget? child;

  /// Visual style of the button.
  ///
  /// See [M3EButtonStyle] for available styles (filled, outlined, tonal, etc.).
  final M3EButtonStyle style;

  /// Size variant of the button.
  ///
  /// See [M3EButtonSize] for available sizes (xs, sm, md, lg, xl).
  final M3EButtonSize size;

  /// Corner radius strategy for the button.
  ///
  /// See [M3EButtonShape] for available shapes (round, square).
  final M3EButtonShape shape;

  /// Whether the button is enabled. Defaults to true.
  final bool enabled;

  /// Optional controller for managing widget states externally.
  ///
  /// Allows programmatic control of pressed, hovered, focused states.
  final WidgetStatesController? statesController;

  /// Optional decoration that bundles styling properties together.
  ///
  /// When provided, decoration values take precedence over individual flat
  /// parameters (e.g. [backgroundColor], [foregroundColor], etc.).
  final M3EButtonDecoration? decoration;

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

  /// Custom mouse cursor.
  final MouseCursor mouseCursor;

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
  WidgetStateProperty<MouseCursor?>? get decorationMouseCursor =>
      decoration?.mouseCursor;
  double? get decorationPressedRadius => decoration?.pressedRadius;
  double? get decorationBorderRadius => decoration?.borderRadius;
  WidgetStateProperty<Color?>? get decorationOverlayColor =>
      decoration?.overlayColor;
  WidgetStateProperty<Color?>? get decorationSurfaceTintColor =>
      decoration?.surfaceTintColor;

  @override
  State<M3EButton> createState() => _M3EButtonState();
}

class _M3EButtonIconLayout extends StatelessWidget {
  const _M3EButtonIconLayout({
    required this.icon,
    required this.label,
    required this.size,
    required this.iconAlignment,
  });

  final Widget icon;
  final Widget label;
  final M3EButtonSize size;
  final IconAlignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    final tokens = M3EButtonTokensAdapter(context);
    final m = tokens.measurements(size);
    final children = <Widget>[
      RepaintBoundary(
        child: IconTheme.merge(
          data: IconThemeData(size: m.iconSize),
          child: icon,
        ),
      ),
      SizedBox(width: m.iconGap),
      Flexible(
        child: DefaultTextStyle.merge(
          maxLines: 2,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          child: label,
        ),
      ),
    ];

    if (iconAlignment == IconAlignment.end) {
      children.setAll(0, [children[2], children[1], children[0]]);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class _M3EButtonState extends State<M3EButton>
    with M3EBaseButtonState<M3EButton> {
  late M3EButtonTokensAdapter _tokens;
  late M3EButtonMeasurements _measurements;

  @override
  M3EButtonSize get buttonSize => widget.size;

  @override
  WidgetStatesController? get externalStatesController =>
      widget.statesController;

  @override
  FocusNode? get externalFocusNode => widget.focusNode;

  @override
  M3EButtonMotion? get effectiveMotion => widget.decorationMotion;

  @override
  void initState() {
    super.initState();
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
  void didUpdateWidget(covariant M3EButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleStatesControllerUpdate(
      oldWidget.statesController,
      widget.statesController,
    );
    handleFocusNodeUpdate(oldWidget.focusNode, widget.focusNode);

    if (oldWidget.size != widget.size) {
      _updateMeasurements();
    }

    if (oldWidget.size != widget.size ||
        oldWidget.decoration?.foregroundColor !=
            widget.decoration?.foregroundColor ||
        oldWidget.style != widget.style) {
      updateLabelStyle(context);
    }

    if (widget.decoration?.motion != oldWidget.decoration?.motion) {
      updateSpringMotion();
    }
  }

  @override
  void dispose() {
    disposeBaseButtonState();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<M3EButtonStyle>('style', widget.style));
    properties.add(DiagnosticsProperty<M3EButtonSize>('size', widget.size));
    properties.add(EnumProperty<M3EButtonShape>('shape', widget.shape));
    properties.add(
      FlagProperty('enabled', value: widget.enabled, ifFalse: 'disabled'),
    );
  }

  ButtonStyle _buildBaseStyle() {
    final dec = widget.decoration;

    final effectivePadding = dec?.padding != null
        ? WidgetStateProperty.all<EdgeInsetsGeometry>(dec!.padding!)
        : null;

    final defaultMinSize = Size(_tokens.minWidthFloor(), _measurements.height);
    final effectiveMinSize = dec?.minimumSize != null
        ? WidgetStateProperty.all(dec!.minimumSize!)
        : WidgetStateProperty.all(defaultMinSize);

    return ButtonStyle(
      alignment: dec?.alignment ?? _kAlignmentCenter,
      padding: effectivePadding,
      textStyle: WidgetStateProperty.all(dec?.textStyle ?? labelStyle),
      minimumSize: effectiveMinSize,
      fixedSize: dec?.fixedSize != null
          ? WidgetStateProperty.all(dec!.fixedSize!)
          : null,
      maximumSize: dec?.maximumSize != null
          ? WidgetStateProperty.all(dec!.maximumSize!)
          : null,
      iconSize: dec?.iconSize != null
          ? WidgetStateProperty.all(dec!.iconSize!)
          : null,
      iconAlignment: dec?.iconAlignment,
      shadowColor: dec?.shadowColor,
      visualDensity: dec?.visualDensity ?? _kVisualDensityStandard,
      tapTargetSize: dec?.tapTargetSize,
      animationDuration: dec?.animationDuration ?? _kDurationZero,
      splashFactory:
          dec?.splashFactory ?? widget.splashFactory ?? _kDefaultSplashFactory,
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (dec?.foregroundColor != null) {
          final color = dec!.foregroundColor!.resolve(states);
          if (color != null) return color;
        }
        if (states.contains(WidgetState.disabled)) {
          return _tokens.c.onSurface.withValues(
            alpha: ButtonConstants.kDisabledForegroundAlpha,
          );
        }
        return _tokens.foreground(widget.style);
      }),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (dec?.backgroundColor != null) {
          final color = dec!.backgroundColor!.resolve(states);
          if (color != null) return color;
        }
        final isTransparent =
            widget.style == M3EButtonStyle.outlined ||
            widget.style == M3EButtonStyle.text;

        if (states.contains(WidgetState.disabled)) {
          return isTransparent
              ? Colors.transparent
              : _tokens.c.onSurface.withValues(
                  alpha: ButtonConstants.kDisabledBackgroundAlpha,
                );
        }
        return (dec?.backgroundBuilder != null || isTransparent)
            ? Colors.transparent
            : _tokens.container(widget.style);
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (dec?.elevation != null) {
          final e = dec!.elevation!.resolve(states);
          if (e != null) return e;
        }
        return _tokens.elevation(widget.style, states);
      }),
      side: WidgetStateProperty.resolveWith((states) {
        if (dec?.side != null) {
          final s = dec!.side!.resolve(states);
          if (s != null) return s;
        }
        final isOutlined = widget.style == M3EButtonStyle.outlined;
        if (!isOutlined) return BorderSide.none;

        if (states.contains(WidgetState.disabled)) {
          return BorderSide(
            color: _tokens.c.onSurface.withValues(
              alpha: ButtonConstants.kDisabledOutlineAlpha,
            ),
            width: 1,
          );
        }
        return BorderSide(color: _tokens.outline(), width: 1);
      }),
      mouseCursor: WidgetStateProperty.resolveWith((states) {
        if (dec?.mouseCursor != null) {
          final cursor = dec!.mouseCursor!.resolve(states);
          if (cursor != null) return cursor;
        }
        if (states.contains(WidgetState.disabled)) {
          return SystemMouseCursors.basic;
        }
        return widget.mouseCursor;
      }),
      overlayColor: dec?.overlayColor,
      surfaceTintColor: dec?.surfaceTintColor,
      enableFeedback:
          (dec?.haptic != null && dec!.haptic != M3EHapticFeedback.none)
          ? false
          : dec?.enableFeedback ?? widget.enableFeedback,
    );
  }

  @override
  Widget build(BuildContext context) {
    final m = _measurements;

    final EdgeInsets baseInternalPadding = EdgeInsets.symmetric(
      horizontal: m.hPadding,
    );

    final BorderRadius fullyRound = BorderRadius.circular(m.height / 2);
    final double? explicitBorderRadius = widget.decorationBorderRadius;
    final double tokenPressed = _tokens.pressedRadius(widget.size);
    final BorderRadius defaultShape = explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : widget.shape == M3EButtonShape.round
        ? fullyRound
        : BorderRadius.circular(_tokens.squareRadius(widget.size));

    final double? explicitPressed = widget.decorationPressedRadius;
    final BorderRadius pressedShape = explicitPressed != null
        ? BorderRadius.circular(explicitPressed)
        : explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : BorderRadius.circular(tokenPressed);

    final double tokenHovered = _tokens.hoveredRadius(widget.size);
    final double? defaultExplicitHovered = widget.decoration?.hoveredRadius;
    final BorderRadius hoveredShape = defaultExplicitHovered != null
        ? BorderRadius.circular(defaultExplicitHovered)
        : explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : BorderRadius.circular(tokenHovered);

    final baseStyle = _buildBaseStyle();

    return buildAnimatedContent(
      builder: (context, pressed, hovered, focused) {
        final effectivelyEnabled = widget.enabled && widget.onPressed != null;
        final targetRadius = (effectivelyEnabled && pressed)
            ? pressedShape
            : (effectivelyEnabled && hovered)
            ? hoveredShape
            : defaultShape;

        Widget core = RepaintBoundary(
          child: RadiusAndPaddingMotion(
            motion: (effectivelyEnabled && pressed)
                ? _kPressedRadiusMotion
                : springMotion,
            internalLeft: baseInternalPadding.left,
            internalRight: baseInternalPadding.right,
            internalTop: baseInternalPadding.top,
            internalBottom: baseInternalPadding.bottom,
            targetRadius: targetRadius,
            freezeTopLeft: false,
            freezeBottomLeft: false,
            freezeTopRight: false,
            freezeBottomRight: false,
            builder: (animatedInternal, animatedRadius) {
              final buttonCore = _buildButtonCore(
                m,
                baseStyle,
                animatedInternal,
                animatedRadius,
              );
              return FocusRing(
                focused: focused,
                radius: animatedRadius,
                child: buttonCore,
              );
            },
          ),
        );

        final dec = widget.decoration;
        final hasDecorationSize =
            dec?.fixedSize != null ||
            dec?.minimumSize != null ||
            dec?.maximumSize != null;
        final fixedWidth = hasDecorationSize ? null : widget.size.width;

        if (fixedWidth != null) {
          core = SizedBox(width: fixedWidth, child: core);
        }

        return core;
      },
    );
  }

  Widget _buildButtonCore(
    M3EButtonMeasurements m,
    ButtonStyle baseStyle,
    EdgeInsets internalPadding,
    BorderRadius animatedRadius,
  ) {
    Widget child = widget.child ?? const SizedBox.shrink();
    if (widget.semanticLabel != null) {
      child = ExcludeSemantics(child: child);
    }

    final shape = WidgetStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: animatedRadius),
    );
    final padding = widget.decoration?.padding != null
        ? WidgetStateProperty.all<EdgeInsetsGeometry>(
            widget.decoration!.padding!,
          )
        : WidgetStateProperty.all<EdgeInsetsGeometry>(internalPadding);

    final ButtonLayerBuilder? wrappedBackgroundBuilder =
        widget.decoration?.backgroundBuilder != null
        ? (context, states, child) => ClipRRect(
            // Clips the gradient/background to the animated border radius
            // so it morphs correctly on hover/press. The Material's own
            // backgroundColor is forced to transparent (see _buildBaseStyle)
            // when backgroundBuilder is set, so no solid color bleeds
            // through at anti-aliased corner edges.
            borderRadius: animatedRadius,
            child: widget.decoration!.backgroundBuilder!(
              context,
              states,
              child,
            ),
          )
        : null;

    final ButtonLayerBuilder? wrappedForegroundBuilder =
        widget.decoration?.foregroundBuilder != null
        ? (context, states, child) => ClipRRect(
            borderRadius: animatedRadius,
            child: widget.decoration!.foregroundBuilder!(
              context,
              states,
              child,
            ),
          )
        : null;

    final style = baseStyle.copyWith(
      padding: padding,
      shape: shape,
      backgroundBuilder: wrappedBackgroundBuilder,
      foregroundBuilder: wrappedForegroundBuilder,
    );

    VoidCallback? onPressed;
    if (widget.enabled && widget.onPressed != null) {
      onPressed = () {
        if (widget.decoration?.haptic != null &&
            widget.decoration!.haptic != M3EHapticFeedback.none) {
          ButtonConstants.triggerHapticFeedback(widget.decoration!.haptic!);
        }
        widget.onPressed?.call();
      };
    }

    VoidCallback? onLongPress;
    if (widget.enabled && widget.onLongPress != null) {
      onLongPress = widget.onLongPress;
    }

    Widget button;
    switch (widget.style) {
      case M3EButtonStyle.filled:
        button = FilledButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.tonal:
        button = FilledButton.tonal(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.elevated:
        button = ElevatedButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.outlined:
        button = OutlinedButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
      case M3EButtonStyle.text:
        button = TextButton(
          style: style,
          onPressed: onPressed,
          onLongPress: onLongPress,
          onHover: widget.onHover,
          statesController: statesController,
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          child: child,
        );
    }

    Widget result = button;
    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }

    if (widget.semanticLabel != null) {
      result = Semantics(label: widget.semanticLabel, child: result);
    }

    return result;
  }
}

/// A filled-style M3EButton.
class M3EFilledButton extends M3EButton {
  const M3EFilledButton({
    super.key,
    required super.onPressed,
    super.child,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(style: M3EButtonStyle.filled);

  const M3EFilledButton.tonal({
    super.key,
    required super.onPressed,
    super.child,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(style: M3EButtonStyle.tonal);

  factory M3EFilledButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    M3EButtonSize size = M3EButtonSize.sm,
    M3EButtonShape shape = M3EButtonShape.round,
    bool enabled = true,
    WidgetStatesController? statesController,
    M3EButtonDecoration? decoration,
    FocusNode? focusNode,
    bool autofocus = false,
    ValueChanged<bool>? onFocusChange,
    String? semanticLabel,
    String? tooltip,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    bool enableFeedback = _kDefaultEnableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return _M3EFilledButtonIcon(
      key: key,
      onPressed: onPressed,
      icon: icon,
      label: label,
      size: size,
      shape: shape,
      enabled: enabled,
      statesController: statesController,
      decoration: decoration,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      mouseCursor: mouseCursor,
      onLongPress: onLongPress,
      onHover: onHover,
      enableFeedback: enableFeedback,
      splashFactory: splashFactory,
    );
  }

  factory M3EFilledButton.tonalIcon({
    Key? key,
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    M3EButtonSize size = M3EButtonSize.sm,
    M3EButtonShape shape = M3EButtonShape.round,
    bool enabled = true,
    WidgetStatesController? statesController,
    M3EButtonDecoration? decoration,
    FocusNode? focusNode,
    bool autofocus = false,
    ValueChanged<bool>? onFocusChange,
    String? semanticLabel,
    String? tooltip,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    bool enableFeedback = _kDefaultEnableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return _M3EFilledButtonTonalIcon(
      key: key,
      onPressed: onPressed,
      icon: icon,
      label: label,
      size: size,
      shape: shape,
      enabled: enabled,
      statesController: statesController,
      decoration: decoration,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      mouseCursor: mouseCursor,
      onLongPress: onLongPress,
      onHover: onHover,
      enableFeedback: enableFeedback,
      splashFactory: splashFactory,
    );
  }
}

class _M3EFilledButtonIcon extends M3EButton implements M3EFilledButton {
  _M3EFilledButtonIcon({
    super.key,
    required super.onPressed,
    required Widget icon,
    required Widget label,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.filled,
         child: _M3EButtonIconLayout(
           icon: icon,
           label: label,
           size: size,
           iconAlignment: decoration?.iconAlignment ?? IconAlignment.start,
         ),
       );
}

class _M3EFilledButtonTonalIcon extends M3EButton implements M3EFilledButton {
  _M3EFilledButtonTonalIcon({
    super.key,
    required super.onPressed,
    required Widget icon,
    required Widget label,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.tonal,
         child: _M3EButtonIconLayout(
           icon: icon,
           label: label,
           size: size,
           iconAlignment: decoration?.iconAlignment ?? IconAlignment.start,
         ),
       );
}

/// An elevated-style M3EButton.
class M3EElevatedButton extends M3EButton {
  const M3EElevatedButton({
    super.key,
    required super.onPressed,
    super.child,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(style: M3EButtonStyle.elevated);

  factory M3EElevatedButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    M3EButtonSize size = M3EButtonSize.sm,
    M3EButtonShape shape = M3EButtonShape.round,
    bool enabled = true,
    WidgetStatesController? statesController,
    M3EButtonDecoration? decoration,
    FocusNode? focusNode,
    bool autofocus = false,
    ValueChanged<bool>? onFocusChange,
    String? semanticLabel,
    String? tooltip,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    bool enableFeedback = _kDefaultEnableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return _M3EElevatedButtonIcon(
      key: key,
      onPressed: onPressed,
      icon: icon,
      label: label,
      size: size,
      shape: shape,
      enabled: enabled,
      statesController: statesController,
      decoration: decoration,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      mouseCursor: mouseCursor,
      onLongPress: onLongPress,
      onHover: onHover,
      enableFeedback: enableFeedback,
      splashFactory: splashFactory,
    );
  }
}

class _M3EElevatedButtonIcon extends M3EButton implements M3EElevatedButton {
  _M3EElevatedButtonIcon({
    super.key,
    required super.onPressed,
    required Widget icon,
    required Widget label,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.elevated,
         child: _M3EButtonIconLayout(
           icon: icon,
           label: label,
           size: size,
           iconAlignment: decoration?.iconAlignment ?? IconAlignment.start,
         ),
       );
}

/// An outlined-style M3EButton.
class M3EOutlinedButton extends M3EButton {
  const M3EOutlinedButton({
    super.key,
    required super.onPressed,
    super.child,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(style: M3EButtonStyle.outlined);

  factory M3EOutlinedButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    M3EButtonSize size = M3EButtonSize.sm,
    M3EButtonShape shape = M3EButtonShape.round,
    bool enabled = true,
    WidgetStatesController? statesController,
    M3EButtonDecoration? decoration,
    FocusNode? focusNode,
    bool autofocus = false,
    ValueChanged<bool>? onFocusChange,
    String? semanticLabel,
    String? tooltip,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    bool enableFeedback = _kDefaultEnableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return _M3EOutlinedButtonIcon(
      key: key,
      onPressed: onPressed,
      icon: icon,
      label: label,
      size: size,
      shape: shape,
      enabled: enabled,
      statesController: statesController,
      decoration: decoration,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      mouseCursor: mouseCursor,
      onLongPress: onLongPress,
      onHover: onHover,
      enableFeedback: enableFeedback,
      splashFactory: splashFactory,
    );
  }
}

class _M3EOutlinedButtonIcon extends M3EButton implements M3EOutlinedButton {
  _M3EOutlinedButtonIcon({
    super.key,
    required super.onPressed,
    required Widget icon,
    required Widget label,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.outlined,
         child: _M3EButtonIconLayout(
           icon: icon,
           label: label,
           size: size,
           iconAlignment: decoration?.iconAlignment ?? IconAlignment.start,
         ),
       );
}

/// A text-style M3EButton.
class M3ETextButton extends M3EButton {
  const M3ETextButton({
    super.key,
    required super.onPressed,
    super.child,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(style: M3EButtonStyle.text);

  factory M3ETextButton.icon({
    Key? key,
    required VoidCallback? onPressed,
    required Widget icon,
    required Widget label,
    M3EButtonSize size = M3EButtonSize.sm,
    M3EButtonShape shape = M3EButtonShape.round,
    bool enabled = true,
    WidgetStatesController? statesController,
    M3EButtonDecoration? decoration,
    FocusNode? focusNode,
    bool autofocus = false,
    ValueChanged<bool>? onFocusChange,
    String? semanticLabel,
    String? tooltip,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHover,
    bool enableFeedback = _kDefaultEnableFeedback,
    InteractiveInkFeatureFactory? splashFactory,
  }) {
    return _M3ETextButtonIcon(
      key: key,
      onPressed: onPressed,
      icon: icon,
      label: label,
      size: size,
      shape: shape,
      enabled: enabled,
      statesController: statesController,
      decoration: decoration,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      semanticLabel: semanticLabel,
      tooltip: tooltip,
      mouseCursor: mouseCursor,
      onLongPress: onLongPress,
      onHover: onHover,
      enableFeedback: enableFeedback,
      splashFactory: splashFactory,
    );
  }
}

class _M3ETextButtonIcon extends M3EButton implements M3ETextButton {
  _M3ETextButtonIcon({
    super.key,
    required super.onPressed,
    required Widget icon,
    required Widget label,
    super.size,
    super.shape,
    super.enabled,
    super.statesController,
    super.decoration,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.semanticLabel,
    super.tooltip,
    super.mouseCursor,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(
         style: M3EButtonStyle.text,
         child: _M3EButtonIconLayout(
           icon: icon,
           label: label,
           size: size,
           iconAlignment: decoration?.iconAlignment ?? IconAlignment.start,
         ),
       );
}
