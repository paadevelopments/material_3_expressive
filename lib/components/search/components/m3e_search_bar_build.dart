part of '../m3e_search_bar.dart';

extension _M3ESearchBarContentBuild on _M3ESearchBarState {
  Widget _buildBarContent({
    required M3EThemeData theme,
    required M3ESearchBarTheme barTheme,
    required M3EColorScheme scheme,
    required Set<WidgetState> states,
    required TextDirection textDirection,
  }) {
    final _BarResolvedStyles styles = _resolveBarStyles(
      theme: theme,
      barTheme: barTheme,
      scheme: scheme,
      states: states,
    );
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
    return _buildBarShell(
      styles: styles,
      textDirection: textDirection,
      leading: _buildLeading(
        barTheme: barTheme,
        scheme: scheme,
        actionSlotWidth: actionSlotWidth,
        actionIconSize: actionIconSize,
      ),
      trailing: _buildTrailing(
        barTheme: barTheme,
        scheme: scheme,
        actionSlotWidth: actionSlotWidth,
        actionIconSize: actionIconSize,
      ),
      input: M3ESearchBarInput(
        controller: _controller,
        focusNode: _focusNode,
        hintText: widget.hintText,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        autoFocus: widget.autoFocus,
        onTap: _handleTap,
        onTapOutside:
            widget.onTapOutside ?? M3EFocus.tapOutsideHandler(_focusNode),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        textStyle: styles.textStyle,
        hintStyle: styles.hintStyle,
        cursorColor: barTheme.cursorColor(scheme),
        selectionColor: barTheme.selectionColor(scheme),
        textCapitalization: styles.textCapitalization,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        scrollPadding: widget.scrollPadding,
        contextMenuBuilder: widget.contextMenuBuilder,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        contentPadding: widget.leading == null
            ? EdgeInsetsDirectional.only(
                start: barTheme.noLeadingHintExtraPadding,
              )
            : EdgeInsetsDirectional.zero,
      ),
    );
  }

  Widget _buildBarShell({
    required _BarResolvedStyles styles,
    required TextDirection textDirection,
    required Widget? leading,
    required List<Widget>? trailing,
    required Widget input,
  }) {
    return Opacity(
      opacity: widget.enabled ? 1 : M3ESearchConstants.disabledOpacity,
      child: Material(
        elevation: styles.elevation,
        shadowColor: styles.shadow,
        color: styles.background,
        surfaceTintColor: styles.surfaceTint,
        shape: styles.shape.copyWith(side: styles.side),
        clipBehavior: Clip.antiAlias,
        child: IgnorePointer(
          ignoring: !widget.enabled,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _handleTap,
              overlayColor: styles.overlay == null
                  ? null
                  : WidgetStatePropertyAll<Color?>(styles.overlay),
              customBorder: styles.shape.copyWith(side: styles.side),
              statesController: _statesController,
              child: Padding(
                padding: styles.padding,
                child: Row(
                  textDirection: textDirection,
                  children: <Widget>[
                    ?leading,
                    Expanded(child: input),
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

  _BarResolvedStyles _resolveBarStyles({
    required M3EThemeData theme,
    required M3ESearchBarTheme barTheme,
    required M3EColorScheme scheme,
    required Set<WidgetState> states,
  }) {
    return _BarResolvedStyles(
      elevation: barTheme.resolveElevation(
        states: states,
        widgetValue: widget.elevation,
      ),
      background: barTheme.resolveBackground(
        scheme: scheme,
        states: states,
        widgetValue: widget.backgroundColor,
      ),
      shadow: barTheme.resolveShadowColor(
        scheme: scheme,
        states: states,
        widgetValue: widget.shadowColor,
      ),
      surfaceTint: barTheme.resolveSurfaceTint(
        scheme: scheme,
        states: states,
        widgetValue: widget.surfaceTintColor,
      ),
      overlay: barTheme.resolveOverlay(
        scheme: scheme,
        states: states,
        widgetValue: widget.overlayColor,
      ),
      padding: widget.padding?.resolve(states) ?? barTheme.padding(),
      shape:
          widget.shape?.resolve(states) ?? barTheme.shape() as OutlinedBorder,
      side: widget.side?.resolve(states),
      textStyle: barTheme.resolveTextStyle(
        theme: theme,
        states: states,
        widgetValue: widget.textStyle,
      ),
      hintStyle: barTheme.resolveHintStyle(
        theme: theme,
        states: states,
        widgetValue: widget.hintStyle,
        textStyleOverride: widget.textStyle,
      ),
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
    );
  }

  Widget? _buildLeading({
    required M3ESearchBarTheme barTheme,
    required M3EColorScheme scheme,
    required double actionSlotWidth,
    required double actionIconSize,
  }) {
    if (widget.leading == null) {
      return null;
    }
    return _wrapActionSlot(
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
  }

  List<Widget>? _buildTrailing({
    required M3ESearchBarTheme barTheme,
    required M3EColorScheme scheme,
    required double actionSlotWidth,
    required double actionIconSize,
  }) {
    return widget.trailing
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
  }
}

class _BarResolvedStyles {
  const _BarResolvedStyles({
    required this.elevation,
    required this.background,
    required this.shadow,
    required this.surfaceTint,
    required this.overlay,
    required this.padding,
    required this.shape,
    required this.side,
    required this.textStyle,
    required this.hintStyle,
    required this.textCapitalization,
  });

  final double elevation;
  final Color background;
  final Color shadow;
  final Color surfaceTint;
  final Color? overlay;
  final EdgeInsetsGeometry padding;
  final OutlinedBorder shape;
  final BorderSide? side;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final TextCapitalization textCapitalization;
}
