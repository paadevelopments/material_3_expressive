import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_app_bar_semantics.dart';
import 'enums/m3e_app_bar_enums.dart';

export 'enums/m3e_app_bar_enums.dart';

/// Which app bar layout an [M3EAppBar] renders.
enum _M3EAppBarKind { top, bottom, sliver }

/// A Material 3 Expressive app bar with `top`, `bottom`, and `sliver` variants.
class M3EAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// A fixed top app bar for use in `Scaffold.appBar`.
  const M3EAppBar.top({
    super.key,
    this.leading,
    this.title,
    this.titleText,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shapeFamily = M3EAppBarShapeFamily.square,
    this.density = M3EAppBarDensity.regular,
    this.toolbarHeight,
    this.automaticallyImplyLeading = true,
    this.clipBehavior = Clip.none,
    this.semanticLabel,
  })  : _kind = _M3EAppBarKind.top,
        floatingActionButton = null,
        pinned = true,
        floating = false,
        snap = false,
        variant = M3EAppBarVariant.medium;

  /// A bottom app bar with actions and an optional floating action button.
  const M3EAppBar.bottom({
    super.key,
    this.actions = const <Widget>[],
    this.floatingActionButton,
  })  : _kind = _M3EAppBarKind.bottom,
        leading = null,
        title = null,
        titleText = null,
        centerTitle = false,
        backgroundColor = null,
        foregroundColor = null,
        elevation = null,
        shapeFamily = M3EAppBarShapeFamily.square,
        density = M3EAppBarDensity.regular,
        toolbarHeight = null,
        automaticallyImplyLeading = true,
        clipBehavior = Clip.none,
        semanticLabel = null,
        pinned = true,
        floating = false,
        snap = false,
        variant = M3EAppBarVariant.medium;

  /// A scrolling sliver app bar for use in `CustomScrollView.slivers`.
  const M3EAppBar.sliver({
    super.key,
    this.leading,
    this.title,
    this.titleText,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.shapeFamily = M3EAppBarShapeFamily.round,
    this.density = M3EAppBarDensity.regular,
    this.variant = M3EAppBarVariant.medium,
    this.semanticLabel,
  })  : _kind = _M3EAppBarKind.sliver,
        elevation = null,
        toolbarHeight = null,
        automaticallyImplyLeading = true,
        clipBehavior = Clip.none,
        floatingActionButton = null;

  final _M3EAppBarKind _kind;

  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final M3EAppBarShapeFamily shapeFamily;
  final M3EAppBarDensity density;
  final double? toolbarHeight;
  final bool automaticallyImplyLeading;
  final Clip clipBehavior;
  final String? semanticLabel;

  // Bottom-only.
  final Widget? floatingActionButton;

  // Sliver-only.
  final bool pinned;
  final bool floating;
  final bool snap;
  final M3EAppBarVariant variant;

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 64);

  @override
  Widget build(BuildContext context) {
    return switch (_kind) {
      _M3EAppBarKind.top => _buildTop(context),
      _M3EAppBarKind.bottom => _buildBottom(context),
      _M3EAppBarKind.sliver => _buildSliver(context),
    };
  }

  Widget _buildTop(BuildContext context) {
    final theme = M3ETheme.of(context);
    final appBarTheme = theme.appBarTheme;
    final metrics = appBarTheme.metrics(density);
    final bg = backgroundColor ?? appBarTheme.backgroundColor(theme.colorScheme);
    final fg = foregroundColor ?? theme.colorScheme.onSurface;
    final shape = appBarTheme.shape(shapeFamily);
    final height = toolbarHeight ?? metrics.smallHeight;
    final tStyle = appBarTheme.titleStyle(theme.typeScale, collapsed: true);

    final resolvedLeading = leading ??
        (automaticallyImplyLeading ? _maybeBackButton(context, fg) : null);

    final resolvedTitle = title ??
        (titleText != null
            ? Text(titleText!, style: tStyle, overflow: TextOverflow.ellipsis)
            : null);

    final bar = Material(
      color: bg,
      elevation: elevation ?? metrics.elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: metrics.horizontalPadding,
            child: IconTheme.merge(
              data: IconThemeData(size: metrics.iconSize, color: fg),
              child: DefaultTextStyle(
                style: tStyle.copyWith(color: fg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (resolvedLeading != null) resolvedLeading,
                    if (resolvedLeading != null) const SizedBox(width: 8),
                    if (resolvedTitle != null)
                      Expanded(
                        child: Align(
                          alignment: centerTitle
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: resolvedTitle,
                        ),
                      )
                    else
                      const Spacer(),
                    if (actions != null) ...[
                      const SizedBox(width: 8),
                      ..._withSpacers(actions!),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (semanticLabel == null) return bar;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: bar,
    );
  }

  Widget _buildBottom(BuildContext context) {
    final theme = M3ETheme.of(context);
    final appBarTheme = theme.appBarTheme;
    final scheme = theme.colorScheme;
    return Container(
      height: appBarTheme.bottomHeight,
      color: appBarTheme.bottomBackgroundColor(scheme),
      padding: appBarTheme.bottomPadding,
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            IconTheme.merge(
              data: IconThemeData(
                color: scheme.onSurfaceVariant,
                size: appBarTheme.bottomIconSize,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions ?? const <Widget>[],
              ),
            ),
            const Spacer(),
            ?floatingActionButton,
          ],
        ),
      ),
    );
  }

  Widget _buildSliver(BuildContext context) {
    final theme = M3ETheme.of(context);
    final appBarTheme = theme.appBarTheme;
    final metrics = appBarTheme.metrics(density);
    final bg = backgroundColor ?? appBarTheme.backgroundColor(theme.colorScheme);
    final fg = foregroundColor ?? theme.colorScheme.onSurface;
    final shape = appBarTheme.shape(shapeFamily);

    final collapsedStyle =
        appBarTheme.titleStyle(theme.typeScale, collapsed: true);
    final expandedStyle =
        appBarTheme.titleStyle(theme.typeScale, collapsed: false);

    final collapsed = metrics.collapsedHeight;
    final expanded = switch (variant) {
      M3EAppBarVariant.medium => metrics.mediumExpanded,
      M3EAppBarVariant.large => metrics.largeExpanded,
      M3EAppBarVariant.small => metrics.smallHeight,
    };

    final resolvedTitleWidget = title ??
        (titleText != null
            ? Text(titleText!,
                style: collapsedStyle, overflow: TextOverflow.ellipsis)
            : null);

    final bar = SliverAppBar(
      pinned: pinned,
      floating: floating,
      snap: snap && floating,
      backgroundColor: bg,
      foregroundColor: fg,
      collapsedHeight: collapsed,
      expandedHeight: expanded,
      centerTitle: centerTitle,
      leading: leading,
      title: resolvedTitleWidget,
      actions: actions,
      shape: shape,
      flexibleSpace: _buildFlexibleSpace(context, expandedStyle),
    );

    if (semanticLabel == null) return bar;
    return M3ESliverSemantic(
      label: semanticLabel!,
      child: bar,
    );
  }

  List<Widget> _withSpacers(List<Widget> items) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i < items.length - 1) out.add(const SizedBox(width: 4));
    }
    return out;
  }

  Widget? _maybeBackButton(BuildContext context, Color fg) {
    final canPop = Navigator.maybeOf(context)?.canPop() ?? false;
    if (!canPop) return null;
    return IconButton(
      icon: const BackButtonIcon(),
      color: fg,
      onPressed: () => Navigator.maybeOf(context)?.maybePop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }

  Widget? _buildFlexibleSpace(BuildContext context, TextStyle expandedStyle) {
    switch (variant) {
      case M3EAppBarVariant.small:
        return null;
      case M3EAppBarVariant.medium:
      case M3EAppBarVariant.large:
        final t = title ??
            (titleText != null ? Text(titleText!, style: expandedStyle) : null);
        if (t == null) return null;
        return FlexibleSpaceBar(
          titlePadding:
              const EdgeInsetsDirectional.only(start: 16, bottom: 16, end: 16),
          title: DefaultTextStyle(
            style: expandedStyle.copyWith(
              color: M3ETheme.of(context).colorScheme.onSurface,
            ),
            child: t,
          ),
          collapseMode: CollapseMode.pin,
          expandedTitleScale: 1.0,
        );
    }
  }
}
