import 'package:flutter/material.dart'
    show
        AdaptiveTextSelectionToolbar,
        InkWell,
        Material,
        MaterialType,
        WidgetStateProperty,
        WidgetStatePropertyAll,
        WidgetStatesController;
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../icon_buttons/m3e_icon_buttons.dart';
import 'res/m3e_search_constants.dart';
import 'styles/m3e_search_bar_theme.dart';

part 'components/m3e_search_bar_input.dart';

/// M3ESearchBar.

class M3ESearchBar extends StatefulWidget {
  /// M3ESearchBar.
  const M3ESearchBar({
    this.controller,
    this.focusNode,
    this.hintText,
    this.leading,
    this.trailing,
    this.onTap,
    this.onTapOutside,
    this.onChanged,
    this.onSubmitted,
    this.constraints,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.textCapitalization,
    this.enabled = true,
    this.autoFocus = false,
    this.textInputAction,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20),
    this.contextMenuBuilder = m3eDefaultSearchContextMenuBuilder,
    this.readOnly = false,
    this.expandOnFocus = true,
    this.expandRestPadding,
    this.smartDashesType,
    this.smartQuotesType,
    super.key,
  });

  /// controller.

  final TextEditingController? controller;

  /// focusNode.
  final FocusNode? focusNode;

  /// hintText.
  final String? hintText;

  /// leading.
  final Widget? leading;

  /// trailing.
  final Iterable<Widget>? trailing;

  /// onTap.
  final GestureTapCallback? onTap;

  /// onTapOutside.
  final TapRegionCallback? onTapOutside;

  /// onChanged.
  final ValueChanged<String>? onChanged;

  /// onSubmitted.
  final ValueChanged<String>? onSubmitted;

  /// constraints.
  final BoxConstraints? constraints;

  /// elevation.
  final WidgetStateProperty<double?>? elevation;

  /// backgroundColor.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// shadowColor.
  final WidgetStateProperty<Color?>? shadowColor;

  /// surfaceTintColor.
  final WidgetStateProperty<Color?>? surfaceTintColor;

  /// overlayColor.
  final WidgetStateProperty<Color?>? overlayColor;

  /// side.
  final WidgetStateProperty<BorderSide?>? side;

  /// shape.
  final WidgetStateProperty<OutlinedBorder?>? shape;

  /// padding.
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  /// textStyle.
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// hintStyle.
  final WidgetStateProperty<TextStyle?>? hintStyle;

  /// textCapitalization.
  final TextCapitalization? textCapitalization;

  /// enabled.
  final bool enabled;

  /// autoFocus.
  final bool autoFocus;

  /// textInputAction.
  final TextInputAction? textInputAction;

  /// keyboardType.
  final TextInputType? keyboardType;

  /// scrollPadding.
  final EdgeInsets scrollPadding;

  /// contextMenuBuilder.
  final EditableTextContextMenuBuilder contextMenuBuilder;

  /// readOnly.
  final bool readOnly;

  /// expandOnFocus.
  final bool expandOnFocus;

  /// expandRestPadding.
  final double? expandRestPadding;

  /// smartDashesType.
  final SmartDashesType? smartDashesType;

  /// smartQuotesType.
  final SmartQuotesType? smartQuotesType;

  @override
  State<M3ESearchBar> createState() => _M3ESearchBarState();
}

class _M3ESearchBarState extends State<M3ESearchBar>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final WidgetStatesController _statesController =
      WidgetStatesController();
  late final AnimationController _expandPaddingController;
  FocusNode? _internalFocusNode;
  bool _expandPaddingSyncScheduled = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _expandPaddingController = AnimationController.unbounded(vsync: this);
    _statesController.addListener(() => setState(() {}));
    _focusNode.addListener(_handleFocusChange);
    _syncFocusedState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _syncExpandPaddingController(M3ETheme.of(context).searchBarTheme);
    });
  }

  void _scheduleExpandPaddingSync(
    M3ESearchBarTheme barTheme, {
    bool animate = false,
  }) {
    if (_expandPaddingSyncScheduled) {
      return;
    }
    _expandPaddingSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _expandPaddingSyncScheduled = false;
      if (!mounted) {
        return;
      }
      _syncExpandPaddingController(barTheme, animate: animate);
    });
  }

  @override
  void didUpdateWidget(covariant M3ESearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _handleFocusChange,
      );
      _focusNode.addListener(_handleFocusChange);
      _syncFocusedState();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _expandPaddingController.dispose();
    _statesController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _syncFocusedState() {
    _statesController.update(WidgetState.focused, _focusNode.hasFocus);
  }

  double _restingExpandPadding(M3ESearchBarTheme barTheme) {
    return widget.expandRestPadding ?? barTheme.restingExpandPadding;
  }

  double _focusedExpandPadding(M3ESearchBarTheme barTheme) {
    return _restingExpandPadding(barTheme) / 2;
  }

  bool _shouldAnimateExpandPadding(M3ESearchBarTheme barTheme) {
    // Read-only bars can still use the resting (unexpanded) inset; they just
    // never animate to the focused width because they do not take focus.
    if (!widget.expandOnFocus || !barTheme.expandOnFocus || !widget.enabled) {
      return false;
    }
    return _restingExpandPadding(barTheme) > 0.5;
  }

  double _targetExpandPadding(M3ESearchBarTheme barTheme) {
    if (!_shouldAnimateExpandPadding(barTheme)) {
      return 0;
    }
    return _focusNode.hasFocus
        ? _focusedExpandPadding(barTheme)
        : _restingExpandPadding(barTheme);
  }

  void _syncExpandPaddingController(
    M3ESearchBarTheme barTheme, {
    bool animate = false,
  }) {
    final double target = _targetExpandPadding(barTheme);
    if (!_shouldAnimateExpandPadding(barTheme)) {
      _expandPaddingController.value = target;
      return;
    }
    if (animate &&
        (_expandPaddingController.isAnimating ||
            (target - _expandPaddingController.value).abs() > 0.5)) {
      _expandPaddingController
        ..stop()
        ..animateWith(
          SpringSimulation(
            barTheme.focusExpandSpring.toDescription(),
            _expandPaddingController.value,
            target,
            _expandPaddingController.velocity,
          ),
        );
      return;
    }
    if (!_expandPaddingController.isAnimating) {
      _expandPaddingController.value = target;
    }
  }

  void _handleFocusChange() {
    _syncFocusedState();
    _syncExpandPaddingController(
      M3ETheme.of(context).searchBarTheme,
      animate: true,
    );
  }

  void _handleTap() {
    widget.onTap?.call();
    // Read-only bars (e.g. SearchAnchor.bar) open a view and must not take
    // keyboard focus — the view's search field owns editing.
    if (widget.readOnly || !widget.enabled) {
      return;
    }
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    } else {
      _syncExpandPaddingController(
        M3ETheme.of(context).searchBarTheme,
        animate: true,
      );
    }
  }

  Widget _buildBarContent({
    required M3EThemeData theme,
    required M3ESearchBarTheme barTheme,
    required M3EColorScheme scheme,
    required Set<WidgetState> states,
    required TextDirection textDirection,
  }) {
    final effectiveElevation = barTheme.resolveElevation(
      states: states,
      widgetValue: widget.elevation,
    );
    final effectiveBackground = barTheme.resolveBackground(
      scheme: scheme,
      states: states,
      widgetValue: widget.backgroundColor,
    );
    final effectiveShadow = barTheme.resolveShadowColor(
      scheme: scheme,
      states: states,
      widgetValue: widget.shadowColor,
    );
    final effectiveSurfaceTint = barTheme.resolveSurfaceTint(
      scheme: scheme,
      states: states,
      widgetValue: widget.surfaceTintColor,
    );
    final effectiveOverlay = barTheme.resolveOverlay(
      scheme: scheme,
      states: states,
      widgetValue: widget.overlayColor,
    );
    final effectivePadding =
        widget.padding?.resolve(states) ?? barTheme.padding();
    final effectiveShape =
        widget.shape?.resolve(states) ?? barTheme.shape() as OutlinedBorder;
    final effectiveSide = widget.side?.resolve(states);
    final effectiveTextStyle = barTheme.resolveTextStyle(
      theme: theme,
      states: states,
      widgetValue: widget.textStyle,
    );
    final effectiveHintStyle = barTheme.resolveHintStyle(
      theme: theme,
      states: states,
      widgetValue: widget.hintStyle,
      textStyleOverride: widget.textStyle,
    );
    final effectiveTextCapitalization =
        widget.textCapitalization ?? TextCapitalization.none;
    final M3EIconButtonTheme iconButtonTheme = theme.iconButtonTheme;
    final double actionIconSize = _resolveActionIconSize(
      iconButtonTheme: iconButtonTheme,
      trailing: widget.trailing,
      leading: widget.leading,
    );
    final double actionSlotWidth = _resolveActionSlotWidth(
      iconButtonTheme: iconButtonTheme,
      trailing: widget.trailing,
      leading: widget.leading,
    );
    final EdgeInsetsDirectional inputPadding = widget.leading == null
        ? EdgeInsetsDirectional.only(start: barTheme.noLeadingHintExtraPadding)
        : EdgeInsetsDirectional.zero;

    final Widget? leading = widget.leading == null
        ? null
        : _wrapActionSlot(
            width: actionSlotWidth,
            child: widget.leading is M3EIconButton
                ? widget.leading!
                : IconTheme.merge(
                    data: IconThemeData(
                      color: barTheme.leadingIconColor(scheme),
                      size: actionIconSize,
                    ),
                    child: widget.leading!,
                  ),
          );

    final List<Widget>? trailing = widget.trailing
        ?.map(
          (Widget action) => action is M3EIconButton
              ? _wrapActionSlot(width: actionSlotWidth, child: action)
              : _wrapActionSlot(
                  width: actionSlotWidth,
                  child: IconTheme.merge(
                    data: IconThemeData(
                      color: barTheme.trailingIconColor(scheme),
                      size: actionIconSize,
                    ),
                    child: action,
                  ),
                ),
        )
        .toList();

    return Opacity(
      opacity: widget.enabled ? 1 : M3ESearchConstants.disabledOpacity,
      child: Material(
        elevation: effectiveElevation,
        shadowColor: effectiveShadow,
        color: effectiveBackground,
        surfaceTintColor: effectiveSurfaceTint,
        shape: effectiveShape.copyWith(side: effectiveSide),
        clipBehavior: Clip.antiAlias,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _handleTap,
              overlayColor: effectiveOverlay == null
                  ? null
                  : WidgetStatePropertyAll<Color?>(effectiveOverlay),
              customBorder: effectiveShape.copyWith(side: effectiveSide),
              statesController: _statesController,
              child: Padding(
                padding: effectivePadding,
                child: Row(
                  textDirection: textDirection,
                  children: <Widget>[
                    ?leading,
                    Expanded(
                      child: M3ESearchBarInput(
                        controller: _controller,
                        focusNode: _focusNode,
                        hintText: widget.hintText,
                        enabled: widget.enabled,
                        readOnly: widget.readOnly,
                        autoFocus: widget.autoFocus,
                        onTap: _handleTap,
                        onTapOutside:
                            widget.onTapOutside ??
                            M3EFocus.tapOutsideHandler(_focusNode),
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        textStyle: effectiveTextStyle,
                        hintStyle: effectiveHintStyle,
                        cursorColor: barTheme.cursorColor(scheme),
                        selectionColor: barTheme.selectionColor(scheme),
                        textCapitalization: effectiveTextCapitalization,
                        textInputAction: widget.textInputAction,
                        keyboardType: widget.keyboardType,
                        scrollPadding: widget.scrollPadding,
                        contextMenuBuilder: widget.contextMenuBuilder,
                        smartDashesType: widget.smartDashesType,
                        smartQuotesType: widget.smartQuotesType,
                        contentPadding: inputPadding,
                      ),
                    ),
                    ...?trailing,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (BuildContext context) {
        final theme = M3ETheme.of(context);
        final barTheme = theme.searchBarTheme;
        final scheme = theme.colorScheme;
        final states = _statesController.value;
        final textDirection = Directionality.of(context);

        if (_expandPaddingController.value == 0 &&
            !_expandPaddingController.isAnimating &&
            _shouldAnimateExpandPadding(barTheme)) {
          _scheduleExpandPaddingSync(barTheme);
        }

        final Widget bar = _buildBarContent(
          theme: theme,
          barTheme: barTheme,
          scheme: scheme,
          states: states,
          textDirection: textDirection,
        );

        final BoxConstraints barConstraints = barTheme.constraints(
          override: widget.constraints,
        );

        if (!_shouldAnimateExpandPadding(barTheme)) {
          return ConstrainedBox(constraints: barConstraints, child: bar);
        }

        return AnimatedBuilder(
          animation: _expandPaddingController,
          builder: (BuildContext context, Widget? child) {
            // Allow spring overshoot past the resting inset; never go negative.
            final pad = _expandPaddingController.value;
            final horizontal = pad.isFinite && pad > 0 ? pad : 0.0;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: ConstrainedBox(constraints: barConstraints, child: bar),
            );
          },
        );
      },
    );
  }
}
