import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundations/foundations.dart';
import '../search/controllers/m3e_search_controller.dart';
import '../search/m3e_search_anchor.dart';
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
    this.automaticallyImplyLeading = false,
    this.clipBehavior = Clip.none,
    this.semanticLabel,
  })  : _kind = _M3EAppBarKind.top,
        floatingActionButton = null,
        pinned = true,
        floating = false,
        snap = false,
        variant = M3EAppBarVariant.medium;

  /// A top app bar whose title is a read-only anchored [M3ESearchAnchor.bar].
  ///
  /// Tapping the bar opens the fullscreen (or docked) search view. Below the
  /// search bar theme max width, the bar fills the space between [leading] and
  /// [actions] while keeping the existing action gaps. Above that width it is
  /// capped and positioned with [centerTitle].
  factory M3EAppBar.search({
    Key? key,
    required M3ESearchController searchController,
    required M3ESearchSuggestionsBuilder suggestionsBuilder,
    Widget? leading,
    List<Widget>? actions,
    bool centerTitle = false,
    String? barHintText,
    Widget? barLeading,
    Iterable<Widget>? barTrailing,
    bool isFullScreen = true,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    M3EAppBarShapeFamily shapeFamily = M3EAppBarShapeFamily.square,
    M3EAppBarDensity density = M3EAppBarDensity.regular,
    double? toolbarHeight,
    bool automaticallyImplyLeading = false,
    Clip clipBehavior = Clip.none,
    String? semanticLabel,
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
    VoidCallback? onClose,
    VoidCallback? onOpen,
    BoxConstraints? searchConstraints,
  }) {
    return M3EAppBar.top(
      key: key,
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      shapeFamily: shapeFamily,
      density: density,
      toolbarHeight: toolbarHeight,
      automaticallyImplyLeading: automaticallyImplyLeading,
      clipBehavior: clipBehavior,
      semanticLabel: semanticLabel,
      title: M3ESearchAnchor.bar(
        searchController: searchController,
        suggestionsBuilder: suggestionsBuilder,
        barHintText: barHintText,
        barLeading: barLeading,
        barTrailing: barTrailing,
        isFullScreen: isFullScreen,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        onClose: onClose,
        onOpen: onOpen,
        // Fill the title slot; theme minWidth (360) would overflow toolbars.
        constraints: searchConstraints ??
            const BoxConstraints(minWidth: 0, minHeight: 56),
        expandOnFocus: false,
        expandRestPadding: 0,
      ),
    );
  }

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
    return M3EComponentTheme(
      builder: (context) => switch (_kind) {
        _M3EAppBarKind.top => _buildTop(context),
        _M3EAppBarKind.bottom => _buildBottom(context),
        _M3EAppBarKind.sliver => _buildSliver(context),
      },
    );
  }

  Widget _buildTop(BuildContext context) {
    final theme = M3ETheme.of(context);
    final appBarTheme = theme.appBarTheme;
    final metrics = appBarTheme.metrics(density);
    final bg = backgroundColor ?? appBarTheme.backgroundColor(theme.colorScheme);
    final fg = foregroundColor ?? theme.colorScheme.onSurface;
    final shape = appBarTheme.shape(shapeFamily);
    final height = toolbarHeight ?? metrics.smallHeight;
    final tStyle = appBarTheme.titleStyle(theme.typeScale);
    final searchMaxWidth = theme.searchBarTheme.maxWidth;

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
                  children: [
                    ?resolvedLeading,
                    if (resolvedLeading != null) const SizedBox(width: 8),
                    if (resolvedTitle != null)
                      Expanded(
                        child: _TitleSlot(
                          centerTitle: centerTitle,
                          maxContentWidth: searchMaxWidth,
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

    if (semanticLabel == null) {
      return bar;
    }
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

    final collapsedStyle = appBarTheme.titleStyle(theme.typeScale);
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

    if (semanticLabel == null) {
      return bar;
    }
    return M3ESliverSemantic(
      label: semanticLabel!,
      child: bar,
    );
  }

  List<Widget> _withSpacers(List<Widget> items) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i < items.length - 1) {
        out.add(const SizedBox(width: 4));
      }
    }
    return out;
  }

  Widget? _maybeBackButton(BuildContext context, Color fg) {
    final canPop = Navigator.maybeOf(context)?.canPop() ?? false;
    if (!canPop) {
      return null;
    }
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
        if (t == null) {
          return null;
        }
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
          expandedTitleScale: 1,
        );
    }
  }
}

/// Places an app bar title between leading and actions.
///
/// [M3ESearchAnchor] titles fill up to [maxContentWidth], then follow
/// [centerTitle]. Other titles keep intrinsic width and only use alignment.
class _TitleSlot extends StatelessWidget {
  const _TitleSlot({
    required this.centerTitle,
    required this.maxContentWidth,
    required this.child,
  });

  final bool centerTitle;
  final double maxContentWidth;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final alignment =
        centerTitle ? Alignment.center : AlignmentDirectional.centerStart;

    if (child is! M3ESearchAnchor) {
      return Align(alignment: alignment, child: child);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.min(constraints.maxWidth, maxContentWidth);
        return Align(
          alignment: alignment,
          child: SizedBox(width: width, child: child),
        );
      },
    );
  }
}
