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
import '../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../icon_buttons/m3e_icon_buttons.dart';
import 'res/m3e_search_constants.dart';
import 'styles/m3e_search_bar_theme.dart';

double _resolveActionIconSize({
  required M3EIconButtonTheme iconButtonTheme,
  required Iterable<Widget>? trailing,
  required Widget? leading,
}) {
  final Widget? referenceAction = _resolveReferenceAction(
    trailing: trailing,
    leading: leading,
  );
  if (referenceAction is M3EIconButton) {
    final M3EIconButton button = referenceAction;
    return iconButtonTheme.iconSize(button.size);
  }
  if (referenceAction is Icon) {
    final Icon icon = referenceAction;
    if (icon.size != null) {
      return icon.size!;
    }
  }
  return iconButtonTheme.iconSize(M3EIconButtonSize.sm);
}

Widget? _resolveReferenceAction({
  required Iterable<Widget>? trailing,
  required Widget? leading,
}) {
  if (trailing != null && trailing.isNotEmpty) {
    return trailing.last;
  }
  return leading;
}

double _resolveActionSlotWidth({
  required M3EIconButtonTheme iconButtonTheme,
  required Iterable<Widget>? trailing,
  required Widget? leading,
}) {
  final Widget? referenceAction = _resolveReferenceAction(
    trailing: trailing,
    leading: leading,
  );
  if (referenceAction is M3EIconButton) {
    final M3EIconButton button = referenceAction;
    return iconButtonTheme.target(button.size, button.width).width;
  }
  if (referenceAction is Icon) {
    final Icon icon = referenceAction;
    return icon.size ??
        iconButtonTheme
            .target(M3EIconButtonSize.sm, M3EIconButtonWidth.defaultWidth)
            .width;
  }
  return iconButtonTheme
      .target(M3EIconButtonSize.sm, M3EIconButtonWidth.defaultWidth)
      .width;
}

Widget _wrapActionSlot({
  required double width,
  required Widget child,
}) {
  return SizedBox(
    width: width,
    child: Center(child: child),
  );
}

Widget m3eDefaultSearchContextMenuBuilder(
  BuildContext context,
  EditableTextState editableTextState,
) {
  return AdaptiveTextSelectionToolbar.editableText(
    editableTextState: editableTextState,
  );
}

/// Shared editable search field used by [M3ESearchBar] and the search view header.
class M3ESearchBarInput extends StatefulWidget {
  const M3ESearchBarInput({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.enabled,
    required this.readOnly,
    required this.autoFocus,
    required this.textStyle,
    required this.hintStyle,
    required this.cursorColor,
    required this.selectionColor,
    this.onTap,
    this.onTapOutside,
    this.onChanged,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20),
    this.contextMenuBuilder = m3eDefaultSearchContextMenuBuilder,
    this.smartDashesType,
    this.smartQuotesType,
    this.contentPadding = EdgeInsets.zero,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hintText;
  final bool enabled;
  final bool readOnly;
  final bool autoFocus;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final Color cursorColor;
  final Color selectionColor;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final EdgeInsets scrollPadding;
  final EditableTextContextMenuBuilder contextMenuBuilder;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final EdgeInsetsGeometry contentPadding;

  @override
  State<M3ESearchBarInput> createState() => _M3ESearchBarInputState();
}

class _M3ESearchBarInputState extends State<M3ESearchBarInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(M3ESearchBarInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleTextChange);
      widget.controller.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.hintText,
      textField: true,
      child: Padding(
        padding: widget.contentPadding,
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: <Widget>[
            if (widget.controller.text.isEmpty && widget.hintText != null)
              IgnorePointer(
                child: Text(
                  widget.hintText!,
                  style: widget.hintStyle,
                  maxLines: 1,
                ),
              ),
            Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => widget.onTap?.call(),
              child: EditableText(
                controller: widget.controller,
                focusNode: widget.focusNode,
                readOnly: widget.readOnly || !widget.enabled,
                autofocus: widget.autoFocus,
                onTapOutside: widget.onTapOutside,
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                style: widget.textStyle,
                cursorColor: widget.cursorColor,
                backgroundCursorColor:
                    widget.cursorColor.withValues(alpha: 0.4),
                selectionColor: widget.selectionColor,
                textCapitalization: widget.textCapitalization,
                textInputAction: widget.textInputAction,
                keyboardType: widget.keyboardType,
                scrollPadding: widget.scrollPadding,
                contextMenuBuilder: widget.contextMenuBuilder,
                smartDashesType: widget.smartDashesType,
                smartQuotesType: widget.smartQuotesType,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A Material 3 Expressive search bar.
class M3ESearchBar extends StatefulWidget {
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

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? leading;
  final Iterable<Widget>? trailing;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final BoxConstraints? constraints;
  final WidgetStateProperty<double?>? elevation;
  final WidgetStateProperty<Color?>? backgroundColor;
  final WidgetStateProperty<Color?>? shadowColor;
  final WidgetStateProperty<Color?>? surfaceTintColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final WidgetStateProperty<BorderSide?>? side;
  final WidgetStateProperty<OutlinedBorder?>? shape;
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;
  final WidgetStateProperty<TextStyle?>? textStyle;
  final WidgetStateProperty<TextStyle?>? hintStyle;
  final TextCapitalization? textCapitalization;
  final bool enabled;
  final bool autoFocus;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final EdgeInsets scrollPadding;
  final EditableTextContextMenuBuilder contextMenuBuilder;
  final bool readOnly;
  final bool expandOnFocus;
  final double? expandRestPadding;
  final SmartDashesType? smartDashesType;
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
      _syncExpandPaddingController(
        M3ETheme.of(context).searchBarTheme,
      );
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
    if (!widget.expandOnFocus ||
        !barTheme.expandOnFocus ||
        !widget.enabled ||
        widget.readOnly) {
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
        ? EdgeInsetsDirectional.only(
            start: barTheme.noLeadingHintExtraPadding,
          )
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
                    if (leading != null) leading,
                    Expanded(
                      child: M3ESearchBarInput(
                        controller: _controller,
                        focusNode: _focusNode,
                        hintText: widget.hintText,
                        enabled: widget.enabled,
                        readOnly: widget.readOnly,
                        autoFocus: widget.autoFocus,
                        onTap: _handleTap,
                        onTapOutside: widget.onTapOutside,
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

        final BoxConstraints barConstraints =
            barTheme.constraints(override: widget.constraints);

        if (!_shouldAnimateExpandPadding(barTheme)) {
          return ConstrainedBox(
            constraints: barConstraints,
            child: bar,
          );
        }

        return AnimatedBuilder(
          animation: _expandPaddingController,
          builder: (BuildContext context, Widget? child) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _expandPaddingController.value,
              ),
              child: ConstrainedBox(
                constraints: barConstraints,
                child: bar,
              ),
            );
          },
        );
      },
    );
  }
}
