part of '../m3e_toolbars.dart';

extension _M3EToolbarBuild on _M3EToolbarState {
  Widget _buildToolbar(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EToolbarTheme toolbarTheme = theme.toolbarTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    final M3EToolbarMetrics metrics = toolbarTheme.metricsFor(widget.placement);
    final M3EToolbarColorStyle style = widget.variant != null
        ? toolbarTheme.colorStyleFromVariant(widget.variant!)
        : widget.colorStyle;
    final M3EToolbarColors colors = toolbarTheme.colors(scheme, style);
    final Color background = widget.backgroundColor ?? colors.container;
    final Color foreground = widget.foregroundColor ?? colors.content;
    final ShapeBorder shape = _floating
        ? toolbarTheme.floatingShape()
        : toolbarTheme.dockedShape();
    final EdgeInsets contentPadding = metrics.contentPadding.resolve(
      Directionality.of(context),
    );
    final EdgeInsets resolvedPadding =
        widget.padding?.resolve(Directionality.of(context)) ?? contentPadding;
    final innerPadding = resolvedPadding;
    final double availableExtent = M3EToolbarItemLayout.availableCrossExtent(
      crossAxisSize: metrics.crossAxisSize,
      padding: innerPadding,
      axis: widget.axis,
    );
    final M3EIconButtonSize iconButtonSize = toolbarTheme.iconButtonSize(
      widget.size,
    );
    final double opticalInset = _opticalInset(theme, iconButtonSize);
    final ({Widget? title, Widget? subtitle, bool hasTitle}) titles =
        _resolveTitles(toolbarTheme, theme.typeScale, foreground);
    final bool useExpanding = _floating && _hasTrigger && !titles.hasTitle;
    final bool dockedIconsOnly =
        !_floating &&
        !titles.hasTitle &&
        widget.leading == null &&
        widget.trailing == null &&
        widget.actions.isNotEmpty;
    final Widget body = _buildBody(
      toolbarTheme: toolbarTheme,
      theme: theme,
      metrics: metrics,
      foreground: foreground,
      titles: titles,
      actionsContent: _buildActionsContent(
        theme: theme,
        scheme: scheme,
        metrics: metrics,
        iconButtonSize: iconButtonSize,
        availableExtent: availableExtent,
        opticalInset: opticalInset,
        useExpanding: useExpanding,
        dockedIconsOnly: dockedIconsOnly,
      ),
      useExpanding: useExpanding,
    );
    return _composeBar(
      background: background,
      elev:
          widget.elevation ??
          (_hasFab ? metrics.elevationWithFab : metrics.elevation),
      shape: shape,
      contentBand: _buildContentBand(
        metrics: metrics,
        toolbarTheme: toolbarTheme,
        theme: theme,
        foreground: foreground,
        innerPadding: innerPadding,
        body: body,
        hasTitle: titles.hasTitle,
      ),
      style: style,
      hasTitle: titles.hasTitle,
    );
  }

  Widget _buildContentBand({
    required M3EToolbarMetrics metrics,
    required M3EToolbarTheme toolbarTheme,
    required M3EThemeData theme,
    required Color foreground,
    required EdgeInsets innerPadding,
    required Widget body,
    required bool hasTitle,
  }) {
    return SizedBox(
      height: widget.axis == Axis.horizontal ? metrics.crossAxisSize : null,
      width: widget.axis == Axis.vertical
          ? metrics.crossAxisSize
          : (_floating && !hasTitle ? null : double.infinity),
      child: Padding(
        padding: innerPadding,
        child: M3ETheme(
          data: toolbarTheme.scopedTheme(theme, foreground),
          child: body,
        ),
      ),
    );
  }

  double _opticalInset(M3EThemeData theme, M3EIconButtonSize iconButtonSize) {
    final Size iconTarget = theme.iconButtonTheme.target(
      iconButtonSize,
      M3EIconButtonWidth.defaultWidth,
    );
    final Size iconVisual = theme.iconButtonTheme.visual(
      iconButtonSize,
      M3EIconButtonWidth.defaultWidth,
    );
    return widget.axis == Axis.horizontal
        ? (iconTarget.width - iconVisual.width) / 2
        : (iconTarget.height - iconVisual.height) / 2;
  }

  ({Widget? title, Widget? subtitle, bool hasTitle}) _resolveTitles(
    M3EToolbarTheme toolbarTheme,
    M3ETypeScale typeScale,
    Color foreground,
  ) {
    final Widget? resolvedTitle =
        widget.title ??
        (widget.titleText != null
            ? Text(
                widget.titleText!,
                style: toolbarTheme
                    .titleStyle(typeScale)
                    .copyWith(color: foreground),
                overflow: TextOverflow.ellipsis,
              )
            : null);
    final Widget? resolvedSubtitle =
        widget.subtitle ??
        (widget.subtitleText != null
            ? Text(
                widget.subtitleText!,
                style: toolbarTheme
                    .subtitleStyle(typeScale)
                    .copyWith(color: foreground.withValues(alpha: 0.8)),
                overflow: TextOverflow.ellipsis,
              )
            : null);
    return (
      title: resolvedTitle,
      subtitle: resolvedSubtitle,
      hasTitle: resolvedTitle != null || resolvedSubtitle != null,
    );
  }

  Widget _buildActionsContent({
    required M3EThemeData theme,
    required M3EColorScheme scheme,
    required M3EToolbarMetrics metrics,
    required M3EIconButtonSize iconButtonSize,
    required double availableExtent,
    required double opticalInset,
    required bool useExpanding,
    required bool dockedIconsOnly,
  }) {
    if (useExpanding) {
      return AnimatedBuilder(
        animation: _expandCtrl,
        builder: (BuildContext context, Widget? child) {
          return M3EToolbarExpandingActions(
            actions: widget.actions,
            maxInline: widget.maxInlineActions,
            overflowIcon: widget.overflowIcon,
            iconButtonSize: iconButtonSize,
            overflowTextStyle: theme.typeScale.labelLarge.copyWith(
              color: scheme.onSurface,
            ),
            destructiveColor: scheme.error,
            axis: widget.axis,
            expandProgress: _expandCtrl.value,
            availableExtent: availableExtent,
            opticalInset: opticalInset,
            onTriggerPressed: () {
              final M3EToolbarAction trigger = widget.actions
                  .whereType<M3EToolbarAction>()
                  .firstWhere((M3EToolbarAction a) => a.isExpandTrigger);
              _onTriggerPressed(trigger);
            },
            leading: widget.leading,
            trailing: widget.trailing,
            gap: metrics.gap,
          );
        },
      );
    }
    return M3EToolbarActionsRow(
      actions: widget.actions,
      maxInline: widget.maxInlineActions,
      overflowIcon: widget.overflowIcon,
      iconButtonSize: iconButtonSize,
      overflowTextStyle: theme.typeScale.labelLarge.copyWith(
        color: scheme.onSurface,
      ),
      destructiveColor: scheme.error,
      axis: widget.axis,
      availableExtent: availableExtent,
      opticalInset: opticalInset,
      gap: metrics.gap,
      expand: dockedIconsOnly,
      mainAxisAlignment: dockedIconsOnly
          ? MainAxisAlignment.spaceBetween
          : MainAxisAlignment.start,
    );
  }

  Widget _buildBody({
    required M3EToolbarTheme toolbarTheme,
    required M3EThemeData theme,
    required M3EToolbarMetrics metrics,
    required Color foreground,
    required ({Widget? title, Widget? subtitle, bool hasTitle}) titles,
    required Widget actionsContent,
    required bool useExpanding,
  }) {
    Widget? content;
    if (titles.hasTitle) {
      final double titleStartExtra = _floating
          ? _titleOpticalStartInset(toolbarTheme, theme.iconButtonTheme)
          : 0;
      content = Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: titleStartExtra),
              child: M3EToolbarTitleBlock(
                title: titles.title,
                subtitle: titles.subtitle,
                center: widget.centerTitle,
                titleStyle: toolbarTheme
                    .titleStyle(theme.typeScale)
                    .copyWith(color: foreground),
                subtitleStyle: toolbarTheme
                    .subtitleStyle(theme.typeScale)
                    .copyWith(color: foreground.withValues(alpha: 0.8)),
              ),
            ),
          ),
          SizedBox(width: metrics.gap),
          actionsContent,
        ],
      );
    } else if (widget.actions.isNotEmpty || useExpanding) {
      content = actionsContent;
    }
    if (useExpanding) {
      return content ?? const SizedBox.shrink();
    }
    return M3EToolbarBody(
      axis: widget.axis,
      gap: metrics.gap,
      leading: widget.leading,
      trailing: widget.trailing,
      content: content,
      mainAxisSize: _floating && !titles.hasTitle
          ? MainAxisSize.min
          : MainAxisSize.max,
      mainAxisAlignment: _floating
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      expandContent: !_floating || titles.hasTitle,
    );
  }

  Widget _composeBar({
    required Color background,
    required double elev,
    required ShapeBorder shape,
    required Widget contentBand,
    required M3EToolbarColorStyle style,
    required bool hasTitle,
  }) {
    Widget bar = Material(
      color: background,
      elevation: elev,
      shape: shape,
      clipBehavior: widget.clipBehavior,
      child: _floating
          ? contentBand
          : Padding(padding: _edgeSafeAreaInset(context), child: contentBand),
    );
    if (_hasFab) {
      bar = _withFab(bar, style);
    }
    if (_floating && widget.safeArea) {
      bar = Padding(padding: _edgeSafeAreaInset(context), child: bar);
    }
    if (_floating) {
      bar = Align(alignment: widget.alignment, child: bar);
    }
    if (widget.semanticLabel != null) {
      bar = Semantics(container: true, label: widget.semanticLabel, child: bar);
    }
    return bar;
  }
}
