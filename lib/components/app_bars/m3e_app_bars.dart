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

/// Dock edge for single-sided system inset padding (toolbar-compatible).
enum _M3EAppBarDockEdge { top, bottom }

/// A Material 3 Expressive app bar with `top`, `bottom`, and `sliver` variants.
class M3EAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// A fixed top app bar for use in `Scaffold.appBar`.
  ///
  /// When [safeArea] is true, only the top [MediaQuery.viewPadding] is applied
  /// outside the content band (same model as [M3EToolbar.docked]).
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
    this.safeArea = true,
    this.clipBehavior = Clip.none,
    this.semanticLabel,
  })  : _kind = _M3EAppBarKind.top,
        _dockEdge = _M3EAppBarDockEdge.top,
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
    WidgetStateProperty<Color?>? barBackgroundColor,
    bool isFullScreen = true,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    M3EAppBarShapeFamily shapeFamily = M3EAppBarShapeFamily.square,
    M3EAppBarDensity density = M3EAppBarDensity.regular,
    double? toolbarHeight,
    bool automaticallyImplyLeading = false,
    bool safeArea = true,
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
      safeArea: safeArea,
      clipBehavior: clipBehavior,
      semanticLabel: semanticLabel,
      title: _M3EAppBarSearchTitle(
        searchController: searchController,
        suggestionsBuilder: suggestionsBuilder,
        barHintText: barHintText,
        barLeading: barLeading,
        barTrailing: barTrailing,
        barBackgroundColor: barBackgroundColor,
        isFullScreen: isFullScreen,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        onClose: onClose,
        onOpen: onOpen,
        searchConstraints: searchConstraints,
      ),
    );
  }

  /// A bottom app bar with actions and an optional floating action button.
  ///
  /// When [safeArea] is true, only the bottom [MediaQuery.viewPadding] is
  /// applied outside the content band.
  const M3EAppBar.bottom({
    super.key,
    this.actions = const <Widget>[],
    this.floatingActionButton,
    this.safeArea = true,
  })  : _kind = _M3EAppBarKind.bottom,
        _dockEdge = _M3EAppBarDockEdge.bottom,
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
        _dockEdge = _M3EAppBarDockEdge.top,
        elevation = null,
        toolbarHeight = null,
        automaticallyImplyLeading = true,
        safeArea = true,
        clipBehavior = Clip.none,
        floatingActionButton = null;

  final _M3EAppBarKind _kind;
  final _M3EAppBarDockEdge _dockEdge;

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

  /// When true, applies [MediaQuery.viewPadding] on the docked edge only
  /// (top for [.top]/[.search], bottom for [.bottom]).
  final bool safeArea;
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
  Size get preferredSize => Size.fromHeight(toolbarHeight ?? 72);

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

  /// System inset for the docked edge only — same recipe as docked toolbars.
  EdgeInsets _edgeSafeAreaInset(BuildContext context) {
    if (!safeArea) {
      return EdgeInsets.zero;
    }
    final EdgeInsets mq = MediaQuery.viewPaddingOf(context);
    return EdgeInsets.only(
      top: _dockEdge == _M3EAppBarDockEdge.top ? mq.top : 0,
      bottom: _dockEdge == _M3EAppBarDockEdge.bottom ? mq.bottom : 0,
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
    final contentPadding =
        metrics.contentPadding.resolve(Directionality.of(context));

    final resolvedLeading = leading ??
        (automaticallyImplyLeading ? _maybeBackButton(context, fg) : null);

    final resolvedTitle = title ??
        (titleText != null
            ? Text(titleText!, style: tStyle, overflow: TextOverflow.ellipsis)
            : null);

    // Content band height includes content padding; system insets sit outside
    // it but inside Material (toolbar docked model).
    final Widget contentBand = SizedBox(
      height: height,
      child: Padding(
        padding: contentPadding,
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
    );

    final bar = Material(
      color: bg,
      elevation: elevation ?? metrics.elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      child: Padding(
        padding: _edgeSafeAreaInset(context),
        child: contentBand,
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
    final contentPadding =
        appBarTheme.bottomPadding.resolve(Directionality.of(context));

    final Widget contentBand = SizedBox(
      height: appBarTheme.bottomHeight,
      child: Padding(
        padding: contentPadding,
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

    return Material(
      color: appBarTheme.bottomBackgroundColor(scheme),
      child: Padding(
        padding: _edgeSafeAreaInset(context),
        child: contentBand,
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
/// Anchored search titles fill up to [maxContentWidth], then follow
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

    final bool fillSlot =
        child is M3ESearchAnchor || child is _M3EAppBarSearchTitle;
    if (!fillSlot) {
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

/// Read-only anchored search title with a default [ColorScheme.surface] fill.
class _M3EAppBarSearchTitle extends StatelessWidget {
  const _M3EAppBarSearchTitle({
    required this.searchController,
    required this.suggestionsBuilder,
    this.barHintText,
    this.barLeading,
    this.barTrailing,
    this.barBackgroundColor,
    this.isFullScreen = true,
    this.onSubmitted,
    this.onChanged,
    this.onClose,
    this.onOpen,
    this.searchConstraints,
  });

  final M3ESearchController searchController;
  final M3ESearchSuggestionsBuilder suggestionsBuilder;
  final String? barHintText;
  final Widget? barLeading;
  final Iterable<Widget>? barTrailing;
  final WidgetStateProperty<Color?>? barBackgroundColor;
  final bool isFullScreen;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClose;
  final VoidCallback? onOpen;
  final BoxConstraints? searchConstraints;

  @override
  Widget build(BuildContext context) {
    final Color surface = M3ETheme.of(context).colorScheme.surface;
    return M3ESearchAnchor.bar(
      searchController: searchController,
      suggestionsBuilder: suggestionsBuilder,
      barHintText: barHintText,
      barLeading: barLeading,
      barTrailing: barTrailing,
      // Surface contrasts against the app bar's surfaceContainerHigh.
      barBackgroundColor:
          barBackgroundColor ?? WidgetStatePropertyAll<Color>(surface),
      isFullScreen: isFullScreen,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      onClose: onClose,
      onOpen: onOpen,
      // minHeight 0 so the bar fills the content band after vertical padding.
      constraints:
          searchConstraints ?? const BoxConstraints(minWidth: 0, minHeight: 0),
      expandOnFocus: false,
      expandRestPadding: 0,
    );
  }
}
