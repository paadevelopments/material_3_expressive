// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/buttons/models/m3e_button_measurements.dart';
import 'package:material_3_expressive/components/buttons/res/m3e_button_constants.dart';
import 'package:material_3_expressive/components/buttons/styles/m3e_button_decoration.dart';
import 'package:material_3_expressive/components/buttons/styles/m3e_button_motion.dart';
import 'package:material_3_expressive/components/buttons/styles/m3e_button_theme.dart';
import 'package:material_3_expressive/foundations/foundations.dart';

import 'components/m3e_base_button_state.dart';
import 'components/m3e_focus_ring.dart';
import 'components/m3e_radius_and_padding_motion.dart';
import 'enums/m3e_button_enums.dart';

export 'models/m3e_button_measurements.dart';
export 'res/m3e_button_constants.dart';
export 'styles/m3e_button_theme.dart';

const Alignment _kAlignmentCenter = Alignment.center;
const VisualDensity _kVisualDensityStandard = VisualDensity.standard;
const Duration _kDurationZero = Duration.zero;
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

  /// A filled button (highest emphasis).
  const M3EButton.filled({
    super.key,
    required this.onPressed,
    this.child,
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
  }) : style = M3EButtonStyle.filled;

  /// A tonal button (medium emphasis).
  const M3EButton.tonal({
    super.key,
    required this.onPressed,
    this.child,
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
  }) : style = M3EButtonStyle.tonal;

  /// An elevated button (medium emphasis with a shadow).
  const M3EButton.elevated({
    super.key,
    required this.onPressed,
    this.child,
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
  }) : style = M3EButtonStyle.elevated;

  /// An outlined button (medium emphasis with a border).
  const M3EButton.outlined({
    super.key,
    required this.onPressed,
    this.child,
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
  }) : style = M3EButtonStyle.outlined;

  /// A text button (lowest emphasis).
  const M3EButton.text({
    super.key,
    required this.onPressed,
    this.child,
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
  }) : style = M3EButtonStyle.text;

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
    final m = M3ETheme.of(context).buttonTheme.measurements(size);
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
  late M3EButtonMeasurements _measurements;

  M3EButtonTheme get _buttonTheme => M3ETheme.of(context).buttonTheme;

  M3EColorScheme get _scheme => M3ETheme.of(context).colorScheme;

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
    _updateMeasurements();
    updateLabelStyle(context);
    updateSpringMotion();
  }

  void _updateMeasurements() {
    _measurements = _buttonTheme.measurements(widget.size);
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

    final defaultMinSize =
        Size(_buttonTheme.minWidthFloor, _measurements.height);
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
      dec?.splashFactory ?? widget.splashFactory ?? InkSparkle.splashFactory,
      foregroundColor: WidgetStateProperty.resolveWith((states) {
        if (dec?.foregroundColor != null) {
          final color = dec!.foregroundColor!.resolve(states);
          if (color != null) return color;
        }
        if (states.contains(WidgetState.disabled)) {
          return _scheme.onSurface.withValues(
            alpha: M3EButtonConstants.kDisabledForegroundAlpha,
          );
        }
        return _buttonTheme.foreground(_scheme, widget.style);
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
              : _scheme.onSurface.withValues(
            alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
          );
        }
        return (dec?.backgroundBuilder != null || isTransparent)
            ? Colors.transparent
            : _buttonTheme.container(_scheme, widget.style);
      }),
      elevation: WidgetStateProperty.resolveWith((states) {
        if (dec?.elevation != null) {
          final e = dec!.elevation!.resolve(states);
          if (e != null) return e;
        }
        return _buttonTheme.elevation(widget.style, states);
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
            color: _scheme.onSurface.withValues(
              alpha: M3EButtonConstants.kDisabledOutlineAlpha,
            ),
            width: 1,
          );
        }
        return BorderSide(color: _buttonTheme.outline(_scheme), width: 1);
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
      overlayColor: dec?.overlayColor ??
          WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return null;
            }
            if (states.contains(WidgetState.pressed)) {
              return null;
            }
            Color? foreground;
            if (dec?.foregroundColor != null) {
              foreground = dec!.foregroundColor!.resolve(states);
            }
            foreground ??= _buttonTheme.foreground(_scheme, widget.style);
            return M3EStateLayer.resolveOverlayColor(foreground, states);
          }),
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
    final double tokenPressed = _buttonTheme.pressedRadius(widget.size);
    final BorderRadius defaultShape = explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : widget.shape == M3EButtonShape.round
        ? fullyRound
        : BorderRadius.circular(_buttonTheme.squareRadius(widget.size));

    final double? explicitPressed = widget.decorationPressedRadius;
    final BorderRadius pressedShape = explicitPressed != null
        ? BorderRadius.circular(explicitPressed)
        : explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : BorderRadius.circular(tokenPressed);

    final double tokenHovered = _buttonTheme.hoveredRadius(widget.size);
    final double? defaultExplicitHovered = widget.decoration?.hoveredRadius;
    final BorderRadius hoveredShape = defaultExplicitHovered != null
        ? BorderRadius.circular(defaultExplicitHovered)
        : explicitBorderRadius != null
        ? BorderRadius.circular(explicitBorderRadius)
        : BorderRadius.circular(tokenHovered);

    final baseStyle = _buildBaseStyle();

    return wrapWithPointerPressTracking(
      enabled: widget.enabled && widget.onPressed != null,
      child: buildAnimatedContent(
      builder: (context, pressed, hovered, focused) {
        final effectivelyEnabled = widget.enabled && widget.onPressed != null;
        final targetRadius = (effectivelyEnabled && pressed)
            ? pressedShape
            : (effectivelyEnabled && hovered)
            ? hoveredShape
            : defaultShape;

        Widget core = RepaintBoundary(
          child: M3ERadiusAndPaddingMotion(
            snapToTarget: effectivelyEnabled && pressed,
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
              return M3EFocusRing(
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
    ),
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
          M3EButtonConstants.triggerHapticFeedback(widget.decoration!.haptic!);
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

    final dec = widget.decoration;
    Color inkSplashColor = _buttonTheme.foreground(_scheme, widget.style);
    if (dec?.foregroundColor != null) {
      inkSplashColor =
          dec!.foregroundColor!.resolve(const <WidgetState>{}) ?? inkSplashColor;
    }

    Widget result = M3EInkSplashTheme(
      color: inkSplashColor,
      child: button,
    );
    if (widget.tooltip != null) {
      result = Tooltip(message: widget.tooltip!, child: result);
    }

    if (widget.semanticLabel != null) {
      result = Semantics(label: widget.semanticLabel, child: result);
    }

    return result;
  }
}
