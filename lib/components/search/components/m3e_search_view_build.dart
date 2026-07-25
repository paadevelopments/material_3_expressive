part of 'm3e_search_view.dart';

extension _M3ESearchViewContentBuild on _M3ESearchViewContentState {
  Widget _buildSearchView(BuildContext context) {
    final theme = M3ETheme.of(context);
    final viewTheme = theme.searchViewTheme;
    final scheme = theme.colorScheme;
    final _ViewResolvedStyles styles = _resolveViewStyles(
      theme: theme,
      viewTheme: viewTheme,
      scheme: scheme,
    );
    final double minWidth = math.min(
      styles.constraints.minWidth,
      _viewRect.width,
    );
    final double minHeight = math.min(
      styles.constraints.minHeight,
      _viewRect.height,
    );
    final double headerBlockHeight =
        styles.headerHeight ??
        (widget.showFullScreenView
            ? M3ESearchConstants.fullScreenBarHeight
            : theme.searchBarTheme.minHeight);
    final bool showBody = _viewRect.height > headerBlockHeight + 1;
    return _buildViewSurface(
      styles: styles,
      minWidth: minWidth,
      minHeight: minHeight,
      showBody: showBody,
      headerBar: _buildHeaderBar(
        theme: theme,
        styles: styles,
        defaultLeading: M3EIconButton(
          icon: const Icon(M3EIcons.arrow_back),
          tooltip: M3ESearchConstants.backButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
        ),
        defaultTrailing: <Widget>[
          if (widget.searchController.text.isNotEmpty)
            M3EIconButton(
              icon: const Icon(M3EIcons.close),
              tooltip: M3ESearchConstants.clearButtonTooltip,
              onPressed: widget.searchController.clear,
            ),
        ],
      ),
    );
  }

  Widget _buildViewSurface({
    required _ViewResolvedStyles styles,
    required double minWidth,
    required double minHeight,
    required bool showBody,
    required Widget headerBar,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Transform.translate(
        offset: _viewRect.topLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: minWidth,
            maxWidth: _viewRect.width,
            minHeight: minHeight,
            maxHeight: _viewRect.height,
          ),
          child: Padding(
            padding: widget.showFullScreenView
                ? EdgeInsets.zero
                : styles.padding,
            child: Material(
              clipBehavior: Clip.antiAlias,
              shape: styles.shape,
              color: styles.background,
              surfaceTintColor: styles.surfaceTint,
              elevation: styles.elevation,
              child: OverflowBox(
                alignment: Alignment.topLeft,
                maxWidth: math.min(widget.viewMaxWidth, _screenSize!.width),
                minWidth: 0,
                fit: OverflowBoxFit.deferToChild,
                child: FadeTransition(
                  opacity: _viewIconsFadeCurve,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: widget.topPadding),
                        child: SafeArea(
                          top: false,
                          bottom: false,
                          child: widget.showFullScreenView
                              ? Padding(
                                  padding: styles.fullScreenHeaderPadding,
                                  child: headerBar,
                                )
                              : headerBar,
                        ),
                      ),
                      if (showBody &&
                          (!styles.shrinkWrap ||
                              minHeight > 0 ||
                              widget.showFullScreenView ||
                              _suggestions.isNotEmpty))
                        ..._buildBodySlivers(styles),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBodySlivers(_ViewResolvedStyles styles) {
    return <Widget>[
      FadeTransition(
        opacity: _viewDividerFadeCurve,
        child: M3EDivider(color: styles.dividerColor),
      ),
      Flexible(
        fit: styles.shrinkWrap && !widget.showFullScreenView
            ? FlexFit.loose
            : FlexFit.tight,
        child: FadeTransition(
          opacity: _viewListFadeCurve,
          child: widget.viewBuilder == null
              ? MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.viewInsetsOf(context).bottom,
                    ),
                    shrinkWrap: styles.shrinkWrap,
                    children: _suggestions.toList(),
                  ),
                )
              : widget.viewBuilder!(_suggestions),
        ),
      ),
    ];
  }

  Widget _buildHeaderBar({
    required M3EThemeData theme,
    required _ViewResolvedStyles styles,
    required Widget defaultLeading,
    required List<Widget> defaultTrailing,
  }) {
    if (widget.showFullScreenView) {
      return M3ESearchBar(
        autoFocus: true,
        expandOnFocus: false,
        leading: widget.viewLeading ?? defaultLeading,
        trailing: widget.viewTrailing ?? defaultTrailing,
        hintText: widget.viewHintText,
        controller: widget.searchController,
        onChanged: (String value) {
          widget.viewOnChanged?.call(value);
          _updateSuggestions();
        },
        onSubmitted: widget.viewOnSubmitted,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        keyboardType: widget.keyboardType,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
      );
    }
    return M3ESearchBar(
      autoFocus: true,
      expandOnFocus: false,
      constraints: styles.headerConstraints,
      padding: WidgetStatePropertyAll<EdgeInsetsGeometry>(styles.barPadding),
      leading: widget.viewLeading ?? defaultLeading,
      trailing: widget.viewTrailing ?? defaultTrailing,
      hintText: widget.viewHintText,
      backgroundColor: const WidgetStatePropertyAll<Color>(Color(0x00000000)),
      overlayColor: const WidgetStatePropertyAll<Color>(Color(0x00000000)),
      elevation: const WidgetStatePropertyAll<double>(0),
      textStyle: WidgetStatePropertyAll<TextStyle>(styles.textStyle),
      hintStyle: WidgetStatePropertyAll<TextStyle>(styles.hintStyle),
      controller: widget.searchController,
      onChanged: (String value) {
        widget.viewOnChanged?.call(value);
        _updateSuggestions();
      },
      onSubmitted: widget.viewOnSubmitted,
      textCapitalization: widget.textCapitalization,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
    );
  }

  _ViewResolvedStyles _resolveViewStyles({
    required M3EThemeData theme,
    required M3ESearchViewTheme viewTheme,
    required M3EColorScheme scheme,
  }) {
    final Color background = widget.showFullScreenView
        ? (widget.viewBackgroundColor ??
              viewTheme.fullScreenBackgroundColor(scheme))
        : (widget.viewBackgroundColor ?? viewTheme.backgroundColor(scheme));
    final Color surfaceTint = widget.showFullScreenView
        ? (widget.viewSurfaceTintColor ?? viewTheme.surfaceTintColor(scheme))
        : (widget.viewSurfaceTintColor ?? viewTheme.surfaceTintColor(scheme));
    final double elevation = widget.showFullScreenView
        ? (widget.viewElevation ?? 0)
        : (widget.viewElevation ?? viewTheme.elevation);
    OutlinedBorder shape =
        widget.viewShape ??
        (widget.showFullScreenView
            ? viewTheme.fullScreenShape() as OutlinedBorder
            : viewTheme.dockedShape(viewTheme.cornerRadius) as OutlinedBorder);
    if (widget.viewSide != null) {
      shape = shape.copyWith(side: widget.viewSide);
    }
    final double? headerHeight =
        widget.viewHeaderHeight ??
        (widget.showFullScreenView ? viewTheme.headerHeight : null);
    return _ViewResolvedStyles(
      background: background,
      surfaceTint: surfaceTint,
      elevation: elevation,
      shape: shape,
      dividerColor: widget.dividerColor ?? Colors.transparent,
      headerHeight: headerHeight,
      headerConstraints: headerHeight == null
          ? null
          : BoxConstraints.tightFor(height: headerHeight),
      textStyle:
          widget.viewHeaderTextStyle ??
          viewTheme.headerTextStyle(theme.typeScale, scheme),
      hintStyle:
          widget.viewHeaderHintStyle ??
          widget.viewHeaderTextStyle ??
          viewTheme.headerHintStyle(theme.typeScale, scheme),
      padding: widget.viewPadding ?? EdgeInsets.zero,
      barPadding: widget.viewBarPadding ?? viewTheme.barPadding(),
      fullScreenHeaderPadding: viewTheme.fullScreenHeaderPadding(),
      constraints: widget.viewConstraints ?? viewTheme.constraints(),
      shrinkWrap: widget.shrinkWrap ?? viewTheme.shrinkWrap,
    );
  }
}

class _ViewResolvedStyles {
  const _ViewResolvedStyles({
    required this.background,
    required this.surfaceTint,
    required this.elevation,
    required this.shape,
    required this.dividerColor,
    required this.headerHeight,
    required this.headerConstraints,
    required this.textStyle,
    required this.hintStyle,
    required this.padding,
    required this.barPadding,
    required this.fullScreenHeaderPadding,
    required this.constraints,
    required this.shrinkWrap,
  });

  final Color background;
  final Color surfaceTint;
  final double elevation;
  final OutlinedBorder shape;
  final Color dividerColor;
  final double? headerHeight;
  final BoxConstraints? headerConstraints;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry barPadding;
  final EdgeInsetsGeometry fullScreenHeaderPadding;
  final BoxConstraints constraints;
  final bool shrinkWrap;
}
