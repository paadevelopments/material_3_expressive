part of '../m3e_icon_buttons.dart';

extension _M3EIconButtonBuild on _M3EIconButtonState {
  Widget _buildContent(BuildContext context) {
    final theme = M3ETheme.of(context);
    final iconButtonTheme = theme.iconButtonTheme;
    final scheme = theme.colorScheme;
    final ({Size visual, Size target}) sizes = _resolveLayoutSizes(
      iconButtonTheme,
    );
    final bool selected = widget.isSelected ?? false;
    final bool isToggle =
        widget.isSelected != null || widget.selectedIcon != null;
    final ({Color bg, Color fg, BorderSide? side}) colors = _resolveColors(
      scheme,
      selected,
      iconButtonTheme.outlineWidth,
    );
    final Widget innerIcon = IconTheme.merge(
      data: IconThemeData(
        size: iconButtonTheme.iconSize(widget.size),
        color: colors.fg,
      ),
      child: (selected && widget.selectedIcon != null)
          ? widget.selectedIcon!
          : widget.icon,
    );
    Widget paintedButton = SizedBox(
      width: sizes.visual.width,
      height: sizes.visual.height,
      child: _wrapWithBadge(
        theme,
        scheme,
        _buildMorphingFace(
          iconButtonTheme: iconButtonTheme,
          visual: sizes.visual,
          colors: colors,
          isToggle: isToggle,
          selected: selected,
          innerIcon: innerIcon,
        ),
      ),
    );
    paintedButton = _wrapPointerDown(paintedButton);
    return Semantics(
      button: true,
      selected: selected,
      label: widget.semanticLabel ?? widget.tooltip,
      child: SizedBox(
        width: sizes.target.width,
        height: sizes.target.height,
        child: Center(child: paintedButton),
      ),
    );
  }

  ({Size visual, Size target}) _resolveLayoutSizes(
    M3EIconButtonTheme iconButtonTheme,
  ) {
    final Size themeVisual = iconButtonTheme.visual(widget.size, widget.width);
    final Size themeTarget = iconButtonTheme.target(widget.size, widget.width);
    final Size visual = widget.visualSize ?? themeVisual;
    return (
      visual: visual,
      target: Size(
        math.max(themeTarget.width, visual.width),
        math.max(themeTarget.height, visual.height),
      ),
    );
  }

  Widget _buildMorphingFace({
    required M3EIconButtonTheme iconButtonTheme,
    required Size visual,
    required ({Color bg, Color fg, BorderSide? side}) colors,
    required bool isToggle,
    required bool selected,
    required Widget innerIcon,
  }) {
    return ListenableBuilder(
      listenable: Listenable.merge(<Listenable>[
        _isPointerDownNotifier,
        _isHoveredNotifier,
        _isPressedNotifier,
      ]),
      builder: (BuildContext context, Widget? child) {
        final bool pressed =
            widget.onPressed != null &&
            (_isPointerDownNotifier.value || _isPressedNotifier.value);
        final morphStates = <WidgetState>{
          if (pressed) WidgetState.pressed,
          if (_isHoveredNotifier.value) WidgetState.hovered,
        };
        return _buildMorphButton(
          visual: visual,
          colors: colors,
          targetRadius: M3EIconButtonShapes.effectiveRadius(
            theme: iconButtonTheme,
            size: widget.size,
            baseVariant: widget.shape,
            isToggle: isToggle,
            isSelected: selected,
            states: morphStates,
          ),
          innerIcon: innerIcon,
          morphStates: morphStates,
        );
      },
    );
  }

  Widget _wrapPointerDown(Widget child) {
    if (widget.onPressed == null) {
      return child;
    }
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _setPointerDown(true),
      onPointerUp: (_) => _setPointerDown(false),
      onPointerCancel: (_) => _setPointerDown(false),
      child: child,
    );
  }

  ({Color bg, Color fg, BorderSide? side}) _resolveColors(
    M3EColorScheme scheme,
    bool selected,
    double outlineWidth,
  ) {
    final ({Color bg, Color fg, BorderSide? side}) defaults = _variantColors(
      scheme,
      selected,
      outlineWidth,
    );
    final dec = widget.decoration;
    final states = <WidgetState>{
      if (widget.onPressed == null) WidgetState.disabled,
      if (selected) WidgetState.selected,
    };
    final useFgGradient = dec?.foregroundGradient != null;
    final paintInnerOutline = dec?.outlineGradient != null || dec?.side != null;
    return (
      bg: dec?.backgroundColor?.resolve(states) ?? defaults.bg,
      fg: useFgGradient
          ? m3eGradientForegroundSourceColor
          : (dec?.foregroundColor?.resolve(states) ?? defaults.fg),
      side: paintInnerOutline
          ? null
          : (dec?.side?.resolve(states) ?? defaults.side),
    );
  }

  ({Color bg, Color fg, BorderSide? side}) _variantColors(
    M3EColorScheme scheme,
    bool selected,
    double outlineWidth,
  ) {
    switch (widget.variant) {
      case M3EIconButtonVariant.standard:
        return (
          bg: Colors.transparent,
          fg: selected ? scheme.primary : scheme.onSurfaceVariant,
          side: null,
        );
      case M3EIconButtonVariant.filled:
        return (bg: scheme.primary, fg: scheme.onPrimary, side: null);
      case M3EIconButtonVariant.tonal:
        return (
          bg: scheme.secondaryContainer,
          fg: scheme.onSecondaryContainer,
          side: null,
        );
      case M3EIconButtonVariant.outlined:
        return (
          bg: Colors.transparent,
          fg: scheme.primary,
          side: BorderSide(color: scheme.outline, width: outlineWidth),
        );
    }
  }

  Widget _buildMorphButton({
    required Size visual,
    required ({Color bg, Color fg, BorderSide? side}) colors,
    required double targetRadius,
    required Widget innerIcon,
    required Set<WidgetState> morphStates,
  }) {
    return M3ERadiusAndPaddingMotion(
      motion: _kIconButtonMorphMotion,
      internalLeft: 0,
      internalRight: 0,
      internalTop: 0,
      internalBottom: 0,
      targetRadius: BorderRadius.circular(targetRadius),
      builder: (padding, animatedRadius) {
        final dec = widget.decoration;
        final fill =
            dec?.backgroundGradient?.resolve(morphStates) ??
            _themeGradientForVariant(M3ETheme.of(context).iconButtonTheme);
        final useGradient = fill != null;
        final gradientOverlay = m3eUsesGradientOverlay(dec?.overlayGradient);
        var icon = innerIcon;
        final fgGradient = dec?.foregroundGradient?.resolve(morphStates);
        if (fgGradient != null) {
          icon = m3eGradientForegroundLayer(
            clipRadius: animatedRadius,
            gradient: fgGradient,
            child: icon,
          );
        }
        Widget button = M3EInkSplashTheme(
          color: colors.fg,
          child: IconButton(
            onPressed: widget.onPressed == null
                ? null
                : () {
                    M3EHaptics.trigger(widget.haptic);
                    widget.onPressed!();
                  },
            isSelected: widget.isSelected,
            selectedIcon: widget.selectedIcon,
            icon: icon,
            tooltip: widget.tooltip,
            enableFeedback: widget.haptic != M3EHapticFeedback.none
                ? false
                : widget.enableFeedback,
            statesController: _statesController,
            style: ButtonStyle(
              fixedSize: WidgetStateProperty.all(visual),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: animatedRadius),
              ),
              backgroundColor: WidgetStateProperty.all(
                useGradient ? Colors.transparent : colors.bg,
              ),
              backgroundBuilder: m3eGradientSurfaceBuilder(
                clipRadius: animatedRadius,
                backgroundGradient: fill == null
                    ? null
                    : WidgetStatePropertyAll<Gradient?>(fill),
                overlayGradient: dec?.overlayGradient,
                outlineGradient: dec?.outlineGradient,
                outlineSide: dec?.side,
                outlineFallbackWidth: M3ETheme.of(
                  context,
                ).iconButtonTheme.outlineWidth,
              ),
              foregroundColor: WidgetStateProperty.resolveWith(
                (_) => colors.fg,
              ),
              side: WidgetStateProperty.resolveWith((_) => colors.side),
              splashFactory: widget.suppressInk || gradientOverlay
                  ? NoSplash.splashFactory
                  : InkSparkle.splashFactory,
              overlayColor: widget.suppressInk || gradientOverlay
                  ? WidgetStateProperty.all(Colors.transparent)
                  : (dec?.overlayColor ??
                        M3EStateLayer.overlayColorHoverFocus(colors.fg)),
              animationDuration: Duration.zero,
              visualDensity: VisualDensity.standard,
            ),
          ),
        );
        return button;
      },
    );
  }

  Gradient? _themeGradientForVariant(M3EIconButtonTheme theme) {
    return switch (widget.variant) {
      M3EIconButtonVariant.filled => theme.filledBackgroundGradient,
      M3EIconButtonVariant.tonal => theme.tonalBackgroundGradient,
      M3EIconButtonVariant.standard || M3EIconButtonVariant.outlined => null,
    };
  }

  Widget _wrapWithBadge(
    M3EThemeData theme,
    M3EColorScheme scheme,
    Widget button,
  ) {
    final Widget? badge = _buildBadge(theme, scheme);
    if (badge == null) {
      return button;
    }
    return Stack(
      clipBehavior: Clip.none,
      children: [
        button,
        PositionedDirectional(top: 0, end: 0, child: badge),
      ],
    );
  }

  Widget? _buildBadge(M3EThemeData theme, M3EColorScheme scheme) {
    final Object? v = widget.badgeValue;
    if (v == null) {
      return null;
    }
    if (v is num) {
      final int c = v.round().clamp(0, 999999);
      if (c == 0) {
        return Badge(
          smallSize: 8,
          backgroundColor: scheme.primary,
          textColor: scheme.onPrimary,
        );
      }
      return Badge.count(
        count: c,
        backgroundColor: scheme.primary,
        textColor: scheme.onPrimary,
      );
    }
    if (v is String) {
      if (v.isEmpty) {
        return null;
      }
      return Badge(
        label: Text(
          v,
          style: theme.typeScale.labelSmall.copyWith(color: scheme.onPrimary),
        ),
        backgroundColor: scheme.primary,
        textColor: scheme.onPrimary,
      );
    }
    assert(() {
      throw FlutterError(
        "M3EIconButton.badgeValue must be a String or num, but got '${v.runtimeType}'.",
      );
    }(), 'badgeValue must be String or num');
    return null;
  }
}
