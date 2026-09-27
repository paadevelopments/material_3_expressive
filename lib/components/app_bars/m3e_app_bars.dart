import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/rendering.dart'
    show
        FloatingHeaderSnapConfiguration,
        RenderSliver,
        RenderSliverSingleBoxAdapter,
        ScrollDirection,
        SliverGeometry;

import 'package:material_3_expressive/components/toolbars/m3e_toolbars.dart'
    show M3EToolbar;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3EToolbar;
import 'package:material_ui/material_ui.dart';

import '../../foundations/foundations.dart';
import '../search/controllers/m3e_search_controller.dart';
import '../search/m3e_search_anchor.dart';
import '../tooltips/m3e_tooltips.dart';
import 'components/m3e_app_bar_semantics.dart';
import 'controllers/m3e_app_bar_controller.dart';
import 'enums/m3e_app_bar_enums.dart';
import 'styles/m3e_app_bar_theme.dart';

export 'controllers/m3e_app_bar_controller.dart';
export 'enums/m3e_app_bar_enums.dart';
export 'styles/m3e_app_bar_theme.dart';

const Duration _kAppBarTravel = Duration(milliseconds: 250);

/// Which app bar layout an [M3EAppBar] renders.
enum _M3EAppBarKind { top, bottom, sliver }

/// Dock edge for single-sided system inset padding (toolbar-compatible).
enum _M3EAppBarDockEdge { top, bottom }

/// A Material 3 Expressive app bar with `top`, `bottom`, and `sliver` variants.
class M3EAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// A fixed top app bar for use in `Scaffold.appBar`.
  ///
  /// When [safeArea] is true, only the top [M3ESafeArea] inset is applied
  /// outside the content band (same model as [M3EToolbar.docked]).
  const M3EAppBar.top({
    super.key,
    this.leading,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
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
    this.controller,
    this.variant = M3EAppBarVariant.small,
    this.hideOnScroll = false,
    this.hideMode = M3EAppBarHideMode.none,
  }) : _kind = _M3EAppBarKind.top,
       _dockEdge = _M3EAppBarDockEdge.top,
       floatingActionButton = null,
       pinned = true,
       floating = false,
       snap = false;

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
    M3EAppBarController? controller,
    M3EAppBarVariant variant = M3EAppBarVariant.small,
    bool hideOnScroll = false,
    M3EAppBarHideMode hideMode = M3EAppBarHideMode.none,
    bool wrapActions = false,
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
    VoidCallback? onClose,
    VoidCallback? onOpen,
    BoxConstraints? searchConstraints,
    AlignmentGeometry? barAlignment,
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
      controller: controller,
      variant: variant,
      hideOnScroll: hideOnScroll,
      hideMode: hideMode,
      title: _M3EAppBarSearchTitle(
        searchController: searchController,
        suggestionsBuilder: suggestionsBuilder,
        barHintText: barHintText,
        barLeading: barLeading,
        barTrailing: barTrailing,
        barBackgroundColor: barBackgroundColor,
        barAlignment:
            barAlignment ??
            (centerTitle ? Alignment.center : AlignmentDirectional.centerStart),
        wrapActions: wrapActions,
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
  /// When [safeArea] is true, only the bottom [M3ESafeArea] inset is
  /// applied outside the content band.
  const M3EAppBar.bottom({
    super.key,
    this.actions = const <Widget>[],
    this.floatingActionButton,
    this.safeArea = true,
  }) : _kind = _M3EAppBarKind.bottom,
       _dockEdge = _M3EAppBarDockEdge.bottom,
       leading = null,
       title = null,
       titleText = null,
       subtitle = null,
       subtitleText = null,
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
       hideOnScroll = false,
       hideMode = M3EAppBarHideMode.none,
       controller = null,
       variant = M3EAppBarVariant.medium;

  /// A scrolling sliver app bar for use in `CustomScrollView.slivers`.
  ///
  /// Flexible variants are pinned. They collapse to the small content height
  /// and stay there until the scroll offset returns to the top. [hideOnScroll]
  /// additionally moves that bar away while content scrolls forward and brings
  /// it back when the user scrolls back.
  const M3EAppBar.sliver({
    super.key,
    this.leading,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.hideOnScroll = false,
    this.hideMode = M3EAppBarHideMode.none,
    this.controller,
    this.shapeFamily = M3EAppBarShapeFamily.square,
    this.density = M3EAppBarDensity.regular,
    this.variant = M3EAppBarVariant.medium,
    this.semanticLabel,
  }) : _kind = _M3EAppBarKind.sliver,
       _dockEdge = _M3EAppBarDockEdge.top,
       elevation = null,
       toolbarHeight = null,
       automaticallyImplyLeading = true,
       safeArea = true,
       clipBehavior = Clip.none,
       floatingActionButton = null;

  final _M3EAppBarKind _kind;
  final _M3EAppBarDockEdge _dockEdge;

  /// leading.

  final Widget? leading;

  /// title.
  final Widget? title;

  /// titleText.
  final String? titleText;

  /// Optional subtitle widget. Shown under the headline.
  final Widget? subtitle;

  /// Optional subtitle string. Ignored when [subtitle] is set.
  final String? subtitleText;

  /// actions.
  final List<Widget>? actions;

  /// centerTitle.
  final bool centerTitle;

  /// backgroundColor.
  final Color? backgroundColor;

  /// foregroundColor.
  final Color? foregroundColor;

  /// elevation.
  final double? elevation;

  /// shapeFamily.
  final M3EAppBarShapeFamily shapeFamily;

  /// density.
  final M3EAppBarDensity density;

  /// toolbarHeight.
  final double? toolbarHeight;

  /// automaticallyImplyLeading.
  final bool automaticallyImplyLeading;

  /// When true, applies [M3ESafeArea] padding on the docked edge only
  /// (top for [M3EAppBar.top]/[M3EAppBar.search], bottom for [M3EAppBar.bottom]).
  final bool safeArea;

  /// clipBehavior.
  final Clip clipBehavior;

  /// semanticLabel.
  final String? semanticLabel;

  /// floatingActionButton.

  // Bottom-only.
  final Widget? floatingActionButton;

  /// pinned.

  // Sliver-only.
  final bool pinned;

  /// floating.
  final bool floating;

  /// snap.
  final bool snap;

  /// When true, the bar slides away as content scrolls forward and returns
  /// when the user scrolls back. Same as [hideMode] [M3EAppBarHideMode.entire].
  final bool hideOnScroll;

  /// Which parts slide away on scroll. [hideOnScroll] selects
  /// [M3EAppBarHideMode.entire] when this is [M3EAppBarHideMode.none].
  final M3EAppBarHideMode hideMode;

  /// Optional controller for expand, collapse, show, and hide.
  final M3EAppBarController? controller;

  /// variant.
  final M3EAppBarVariant variant;

  @override
  Size get preferredSize {
    if (_kind == _M3EAppBarKind.bottom) {
      return Size.fromHeight(M3EAppBarTheme.defaults.bottomHeight);
    }
    final double? live = _m3eAppBarHeightOf(this);
    if (live != null) {
      return Size.fromHeight(math.max(0, live));
    }
    return Size.fromHeight(_fallbackContentHeight());
  }

  /// Content-band height before the first scroll frame.
  double _fallbackContentHeight() {
    if (toolbarHeight != null) {
      return toolbarHeight!;
    }
    final M3EAppBarMetrics metrics = M3EAppBarTheme.defaults.metrics(density);
    if (variant == M3EAppBarVariant.small) {
      return metrics.smallHeight;
    }
    return metrics.expandedHeight(
      variant,
      hasSubtitle: subtitle != null || subtitleText != null,
    );
  }

  /// [hideOnScroll] means the whole bar when [hideMode] is [M3EAppBarHideMode.none].
  M3EAppBarHideMode get _effectiveHideMode {
    if (hideMode != M3EAppBarHideMode.none) {
      return hideMode;
    }
    if (hideOnScroll) {
      return M3EAppBarHideMode.entire;
    }
    return M3EAppBarHideMode.none;
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (context) => switch (_kind) {
        _M3EAppBarKind.top => _M3EDockedAppBar(bar: this),
        _M3EAppBarKind.bottom => _M3EBottomAppBar(bar: this),
        _M3EAppBarKind.sliver => _M3ESliverAppBar(bar: this),
      },
    );
  }

  /// System inset for the docked edge only — same recipe as docked toolbars.
  EdgeInsets _edgeSafeAreaInset(BuildContext context) {
    if (!safeArea) {
      return EdgeInsets.zero;
    }
    final EdgeInsets mq = M3ESafeArea.paddingOf(context);
    return EdgeInsets.only(
      top: _dockEdge == _M3EAppBarDockEdge.top ? mq.top : 0,
      bottom: _dockEdge == _M3EAppBarDockEdge.bottom ? mq.bottom : 0,
    );
  }
}

/// Live content-band height for [M3EAppBar.preferredSize].
final Expando<double> _m3eAppBarHeights = Expando<double>();

double? _m3eAppBarHeightOf(M3EAppBar bar) => _m3eAppBarHeights[bar];

void _m3eAppBarWriteHeight(M3EAppBar bar, double height) {
  _m3eAppBarHeights[bar] = height;
}

void _m3eAppBarClearHeight(M3EAppBar bar) {
  _m3eAppBarHeights[bar] = null;
}

/// Fixed top bar. Scroll-under follows the body scroll offset.
class _M3EDockedAppBar extends StatefulWidget {
  const _M3EDockedAppBar({required this.bar});

  final M3EAppBar bar;

  @override
  State<_M3EDockedAppBar> createState() => _M3EDockedAppBarState();
}

class _M3EDockedAppBarState extends State<_M3EDockedAppBar>
    with SingleTickerProviderStateMixin {
  ScrollNotificationObserverState? _observer;
  ScrollPosition? _position;
  final _M3EPageScroll _pageScroll = _M3EPageScroll();
  M3EAppBarController? _bound;
  final OverlayPortalController _actionsOverlay = OverlayPortalController();
  late final AnimationController _visibility;
  bool _under = false;
  bool _follow = true;
  double _offset = 0;
  double _collapsed = 0;
  double _expanded = 0;

  M3EAppBar get bar => widget.bar;

  @override
  void initState() {
    super.initState();
    _actionsOverlay.show();
    _visibility = AnimationController(
      vsync: this,
      value: 1,
      duration: _kAppBarTravel,
    )..addListener(_onVisibility);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindObserver();
    _bindController();
    _seedPrimary();
  }

  @override
  void didUpdateWidget(_M3EDockedAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    final double? live = _m3eAppBarHeightOf(oldWidget.bar);
    if (live != null) {
      _m3eAppBarWriteHeight(bar, live);
    }
    if (oldWidget.bar.controller != bar.controller) {
      _bindController();
    }
  }

  @override
  void dispose() {
    _observer?.removeListener(_onNotification);
    if (_bound == bar.controller) {
      bar.controller?.detach();
    }
    _m3eAppBarClearHeight(bar);
    _visibility
      ..removeListener(_onVisibility)
      ..dispose();
    super.dispose();
  }

  void _bindObserver() {
    final ScrollNotificationObserverState? next =
        ScrollNotificationObserver.maybeOf(context);
    if (next == _observer) {
      return;
    }
    _observer?.removeListener(_onNotification);
    _observer = next;
    _observer?.addListener(_onNotification);
  }

  void _seedPrimary() {
    final ScrollController? primary = PrimaryScrollController.maybeOf(context);
    if (primary == null || !primary.hasClients) {
      return;
    }
    _position = primary.position;
    if (_offset == 0 && primary.offset > 0) {
      _applyOffset(primary.offset);
    }
  }

  void _onNotification(ScrollNotification notification) {
    if (!mounted || !_pageScroll.accepts(notification, context)) {
      return;
    }
    final BuildContext? target = notification.context;
    if (target != null && target.mounted) {
      _position = Scrollable.maybeOf(target)?.position;
    }
    // Metrics updates report a null delta. Those are layout corrections from
    // the bar itself changing size, and must not reverse the slide.
    final double? scrollDelta = notification is ScrollUpdateNotification
        ? notification.scrollDelta
        : null;
    _applyOffset(notification.metrics.extentBefore, scrollDelta: scrollDelta);
  }

  void _onVisibility() {
    if (mounted) {
      setState(() {});
    }
    _commitExtent(_slotHeight());
    _publish();
  }

  void _bindController() {
    final M3EAppBarController? next = bar.controller;
    if (_bound == next) {
      _publish();
      return;
    }
    _bound?.detach();
    _bound = next;
    next?.attach(
      collapsed: _collapsedNow,
      visible: _visibleNow,
      expand: _expand,
      collapse: _collapse,
      show: _show,
      hide: _hide,
      followScroll: _resumeScroll,
    );
  }

  bool get _visibleNow {
    if (bar._effectiveHideMode == M3EAppBarHideMode.actions) {
      return true;
    }
    return _visibility.value > 0.01;
  }

  bool get _collapsedNow {
    if (_expanded <= _collapsed + 0.5) {
      return true;
    }
    return _offset >= _expanded - _collapsed - 0.5;
  }

  void _publish() {
    _bound?.update(collapsed: _collapsedNow, visible: _visibleNow);
  }

  void _applyOffset(double offset, {double? scrollDelta}) {
    final double previous = _offset;
    _offset = offset;
    final under = offset > 0;
    final changed = under != _under;
    _under = under;
    if (_follow &&
        scrollDelta != null &&
        bar._effectiveHideMode != M3EAppBarHideMode.none) {
      final double range = math.max(0, _expanded - _collapsed);
      if (scrollDelta > 0.5 && offset > range) {
        _m3eSlideAway(_visibility);
      } else if (scrollDelta < -0.5) {
        _m3eSlideBack(_visibility);
      }
    }
    _commitExtent(_slotHeight());
    _publish();
    // A small bar only changes color at the top. Rebuilding it on every
    // pixel restarts hover under the pointer and the list appears to flicker.
    final bool flexible = _expanded > _collapsed + 0.5;
    if (mounted && (changed || (flexible && (offset - previous).abs() > 0.5))) {
      setState(() {});
    }
  }

  double _slotHeight() {
    if (bar.toolbarHeight != null) {
      return bar.toolbarHeight!;
    }
    return _M3EBarMotion(
      offset: _offset,
      collapsed: _collapsed,
      expanded: _expanded,
      shown: _visibility.value,
      mode: bar._effectiveHideMode,
      manual: !_follow,
    ).slot;
  }

  void _commitExtent(double height) {
    if (bar.toolbarHeight != null || _collapsed <= 0) {
      return;
    }
    final double? previous = _m3eAppBarHeightOf(bar);
    // preferredSize is only the scaffold's max. The child can be shorter, and
    // that shorter size is what moves the body. Rebuilding the scaffold while
    // the bar shrinks restarts the list and fights the slide.
    if (previous != null && height <= previous + 0.5) {
      return;
    }
    _m3eAppBarWriteHeight(bar, height);
    final ScaffoldState? scaffold = Scaffold.maybeOf(context);
    if (scaffold == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scaffold.mounted) {
        scaffold.setState(() {});
      }
    });
  }

  ScrollPosition? _activePosition() {
    final ScrollPosition? current = _position;
    if (current != null && current.hasPixels) {
      return current;
    }
    final ScrollController? primary = PrimaryScrollController.maybeOf(context);
    if (primary != null && primary.hasClients) {
      return primary.position;
    }
    return current;
  }

  Future<void> _expand() {
    final ScrollPosition? position = _activePosition();
    if (position == null || !position.hasPixels) {
      return Future<void>.value();
    }
    return position.animateTo(
      0,
      duration: _kAppBarTravel,
      curve: Curves.easeOut,
    );
  }

  Future<void> _collapse() {
    final ScrollPosition? position = _activePosition();
    if (position == null || !position.hasPixels) {
      return Future<void>.value();
    }
    final double target = (_expanded - _collapsed).clamp(
      0.0,
      position.maxScrollExtent,
    );
    return position.animateTo(
      target,
      duration: _kAppBarTravel,
      curve: Curves.easeOut,
    );
  }

  Future<void> _show() {
    _follow = false;
    return _visibility.forward();
  }

  Future<void> _hide() {
    _follow = false;
    return _visibility.reverse();
  }

  Future<void> _resumeScroll() {
    _follow = true;
    if (_offset <= math.max(0, _expanded - _collapsed) + 0.5) {
      return _visibility.forward();
    }
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final appBarTheme = theme.appBarTheme;
    final scheme = theme.colorScheme;
    final metrics = appBarTheme.metrics(bar.density);
    final hasSubtitle = bar.subtitle != null || bar.subtitleText != null;
    _collapsed = metrics.collapsedHeight;
    _expanded = bar.toolbarHeight != null
        ? bar.toolbarHeight!
        : metrics.expandedHeight(bar.variant, hasSubtitle: hasSubtitle);
    final motion = _M3EBarMotion(
      offset: _offset,
      collapsed: _collapsed,
      expanded: _expanded,
      shown: _visibility.value,
      mode: bar._effectiveHideMode,
      manual: !_follow,
    );
    final double slot = bar.toolbarHeight ?? motion.slot;
    if (bar.toolbarHeight == null) {
      _commitExtent(slot);
    }

    final bool under = _under;
    final Color bg = _m3eBarColor(
      bar: bar,
      theme: appBarTheme,
      scheme: scheme,
      under: under,
    );
    final double elevation =
        bar.elevation ??
        (under ? metrics.scrolledElevation : metrics.elevation);
    final Widget body = _M3EBarBody(
      expand: motion.titleExpand,
      topPadding: appBarTheme.flexibleTopPadding,
      actionRow: appBarTheme.actionRowHeight,
      bottomPadding: metrics.flexibleBottomPadding,
      titleInset: metrics.titleInset,
      contentPadding: metrics.contentPadding,
      centerTitle: bar.centerTitle,
      search: bar.title is _M3EAppBarSearchTitle,
      leading: _resolvedLeading(context, scheme, appBarTheme),
      actions: bar.actions,
      title: _resolvedTitle(
        context,
        theme,
        appBarTheme,
        scheme,
        motion.titleExpand,
      ),
      leadingColor: bar.foregroundColor ?? appBarTheme.leadingColor(scheme),
      trailingColor: appBarTheme.trailingColor(scheme),
      iconSize: metrics.iconSize,
      separateActions: motion.actions,
      containerColor: bg,
      shadowColor: scheme.shadow,
      shape: appBarTheme.shape(bar.shapeFamily),
    );
    final Widget clipped = motion.entire
        ? ClipRect(
            child: OverflowBox(
              alignment: Alignment.bottomCenter,
              minHeight: motion.painted,
              maxHeight: motion.painted,
              child: SizedBox(height: motion.painted, child: body),
            ),
          )
        : body;
    final EdgeInsets safe = bar._edgeSafeAreaInset(context);
    final Widget? leading = _resolvedLeading(context, scheme, appBarTheme);
    final Widget material = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double inset = safe.top + safe.bottom;
        final double available = constraints.maxHeight.isFinite
            ? math.max(0, constraints.maxHeight - inset)
            : slot;
        final double height = math.min(math.max(0, slot), available);
        final double shown = motion.shown.clamp(0.0, 1.0);
        final Widget padded = Padding(
          padding: safe,
          child: motion.actions
              ? _m3eClipSliding(
                  push: math.min(motion.painted * shown, available),
                  visual: motion.painted,
                  child: body,
                )
              : SizedBox(height: height, child: clipped),
        );
        if (!motion.actions) {
          return Material(
            color: bg,
            elevation: elevation,
            shadowColor: scheme.shadow,
            surfaceTintColor: const Color(0x00000000),
            shape: appBarTheme.shape(bar.shapeFamily),
            clipBehavior: bar.clipBehavior,
            child: padded,
          );
        }
        return _M3EActionOverlay(
          controller: _actionsOverlay,
          color: bg,
          inset: safe.top,
          topPadding: appBarTheme.flexibleTopPadding,
          actionRow: appBarTheme.actionRowHeight,
          contentPadding: metrics.contentPadding,
          hide: motion.titleHide,
          tonal: appBarTheme.actionsTonalColor(scheme),
          leadingColor: bar.foregroundColor ?? appBarTheme.leadingColor(scheme),
          trailingColor: appBarTheme.trailingColor(scheme),
          iconSize: metrics.iconSize,
          leading: leading,
          actions: bar.actions,
          child: Material(
            color: bg,
            elevation: elevation,
            shadowColor: scheme.shadow,
            surfaceTintColor: const Color(0x00000000),
            shape: appBarTheme.shape(bar.shapeFamily),
            clipBehavior: bar.clipBehavior,
            child: padded,
          ),
        );
      },
    );
    final Widget scoped = _M3EScrolledUnder(
      scrolledUnder: under,
      child: material,
    );
    if (bar.semanticLabel == null) {
      return scoped;
    }
    return Semantics(container: true, label: bar.semanticLabel, child: scoped);
  }

  Widget? _resolvedLeading(
    BuildContext context,
    M3EColorScheme scheme,
    M3EAppBarTheme appBarTheme,
  ) {
    return bar.leading ??
        (bar.automaticallyImplyLeading
            ? _maybeBackButton(
                context,
                bar.foregroundColor ?? appBarTheme.leadingColor(scheme),
              )
            : null);
  }

  Widget? _resolvedTitle(
    BuildContext context,
    M3EThemeData theme,
    M3EAppBarTheme appBarTheme,
    M3EColorScheme scheme,
    double expand,
  ) {
    if (bar.title is _M3EAppBarSearchTitle) {
      return bar.title;
    }
    final Color titleColor =
        bar.foregroundColor ?? appBarTheme.titleColor(scheme);
    final TextStyle style =
        TextStyle.lerp(
          appBarTheme
              .titleStyle(theme.typeScale, variant: bar.variant)
              .copyWith(color: titleColor),
          appBarTheme
              .titleStyle(
                theme.typeScale,
                collapsed: false,
                variant: bar.variant,
              )
              .copyWith(color: titleColor),
          expand,
        ) ??
        appBarTheme.titleStyle(theme.typeScale, variant: bar.variant);
    final TextStyle subtitleStyle = appBarTheme
        .subtitleStyle(theme.typeScale, bar.variant)
        .copyWith(color: appBarTheme.subtitleColor(scheme));
    final bool wrap = expand > 0.5;
    final Widget? title = _headline(
      title: bar.title,
      titleText: bar.titleText,
      style: style,
      centerTitle: bar.centerTitle,
      wrap: wrap,
    );
    final Widget? subtitle = _supporting(
      subtitle: bar.subtitle,
      subtitleText: bar.subtitleText,
      style: subtitleStyle,
      centerTitle: bar.centerTitle,
      wrap: wrap,
    );
    if (title == null && subtitle == null) {
      return null;
    }
    return _M3ETitleBlock(
      title: title,
      subtitle: subtitle,
      centerTitle: bar.centerTitle,
    );
  }
}

/// Bottom bar. Resting fill stays surface container; elevation follows scroll.
class _M3EBottomAppBar extends StatefulWidget {
  const _M3EBottomAppBar({required this.bar});

  final M3EAppBar bar;

  @override
  State<_M3EBottomAppBar> createState() => _M3EBottomAppBarState();
}

class _M3EBottomAppBarState extends State<_M3EBottomAppBar> {
  ScrollNotificationObserverState? _observer;
  bool _under = false;
  final _M3EPageScroll _pageScroll = _M3EPageScroll();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ScrollNotificationObserverState? next =
        ScrollNotificationObserver.maybeOf(context);
    if (next == _observer) {
      return;
    }
    _observer?.removeListener(_onNotification);
    _observer = next;
    _observer?.addListener(_onNotification);
  }

  @override
  void dispose() {
    _observer?.removeListener(_onNotification);
    super.dispose();
  }

  void _onNotification(ScrollNotification notification) {
    if (!mounted || !_pageScroll.accepts(notification, context)) {
      return;
    }
    final bool under = notification.metrics.extentBefore > 0;
    if (under != _under && mounted) {
      setState(() => _under = under);
    }
  }

  @override
  Widget build(BuildContext context) {
    final M3EAppBar bar = widget.bar;
    final theme = M3ETheme.of(context);
    final appBarTheme = theme.appBarTheme;
    final scheme = theme.colorScheme;
    final metrics = appBarTheme.metrics(bar.density);
    final contentPadding = appBarTheme.bottomPadding.resolve(
      Directionality.of(context),
    );
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
                children: bar.actions ?? const <Widget>[],
              ),
            ),
            const Spacer(),
            ?bar.floatingActionButton,
          ],
        ),
      ),
    );
    return Material(
      color: appBarTheme.bottomBackgroundColor(scheme),
      elevation: _under ? metrics.scrolledElevation : metrics.elevation,
      shadowColor: scheme.shadow,
      surfaceTintColor: const Color(0x00000000),
      child: Padding(
        padding: bar._edgeSafeAreaInset(context),
        child: contentBand,
      ),
    );
  }
}

/// Pinned sliver. One title block moves inside the bar as it collapses.
class _M3ESliverAppBar extends StatefulWidget {
  const _M3ESliverAppBar({required this.bar});

  final M3EAppBar bar;

  @override
  State<_M3ESliverAppBar> createState() => _M3ESliverAppBarState();
}

class _M3ESliverAppBarState extends State<_M3ESliverAppBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _visibility;
  ScrollPosition? _position;
  M3EAppBarController? _bound;
  bool _follow = true;
  double _offset = 0;
  double _lastPixels = 0;
  double _collapsed = 0;
  double _expanded = 0;

  M3EAppBar get bar => widget.bar;

  @override
  void initState() {
    super.initState();
    _visibility = AnimationController(
      vsync: this,
      value: 1,
      duration: _kAppBarTravel,
    )..addListener(_onVisibility);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bindScrollable();
    _bindController();
  }

  @override
  void didUpdateWidget(_M3ESliverAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bar.controller != bar.controller) {
      _bindController();
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_onScroll);
    if (_bound == bar.controller) {
      bar.controller?.detach();
    }
    _visibility
      ..removeListener(_onVisibility)
      ..dispose();
    super.dispose();
  }

  void _onVisibility() {
    if (mounted) {
      setState(() {});
    }
    _publish();
  }

  void _bindScrollable() {
    final ScrollPosition? next = Scrollable.maybeOf(context)?.position;
    if (next == _position) {
      return;
    }
    _position?.removeListener(_onScroll);
    _position = next;
    _lastPixels = next?.pixels ?? 0;
    _offset = _lastPixels;
    _position?.addListener(_onScroll);
  }

  void _bindController() {
    final M3EAppBarController? next = bar.controller;
    if (_bound == next) {
      _publish();
      return;
    }
    _bound?.detach();
    _bound = next;
    next?.attach(
      collapsed: _collapsedNow,
      visible: _visibleNow,
      expand: _expand,
      collapse: _collapse,
      show: _show,
      hide: _hide,
      followScroll: _resumeScroll,
    );
  }

  bool get _visibleNow {
    if (bar._effectiveHideMode == M3EAppBarHideMode.actions) {
      return true;
    }
    return _visibility.value > 0.01;
  }

  bool get _collapsedNow {
    if (_expanded <= _collapsed + 0.5) {
      return true;
    }
    return _offset >= _expanded - _collapsed - 0.5;
  }

  void _publish() {
    _bound?.update(collapsed: _collapsedNow, visible: _visibleNow);
  }

  void _onScroll() {
    final ScrollPosition? position = _position;
    if (position == null || !position.hasPixels) {
      return;
    }
    final double pixels = position.pixels;
    final double delta = pixels - _lastPixels;
    final underChanged = (_lastPixels > 0) != (pixels > 0);
    _lastPixels = pixels;
    _offset = pixels;
    if (_follow && bar._effectiveHideMode != M3EAppBarHideMode.none) {
      final double range = math.max(0, _expanded - _collapsed);
      // Pixel corrections from the shrinking header keep the user's direction.
      final ScrollDirection direction = position.userScrollDirection;
      if (direction == ScrollDirection.reverse && pixels > range) {
        _m3eSlideAway(_visibility);
      } else if (direction == ScrollDirection.forward) {
        _m3eSlideBack(_visibility);
      }
    }
    _publish();
    final bool flexible = _expanded > _collapsed + 0.5;
    if (mounted && (underChanged || (flexible && delta.abs() > 0.5))) {
      setState(() {});
    }
  }

  Future<void> _expand() {
    final ScrollPosition? position = _position;
    if (position == null || !position.hasPixels) {
      return Future<void>.value();
    }
    return position.animateTo(
      0,
      duration: _kAppBarTravel,
      curve: Curves.easeOut,
    );
  }

  Future<void> _collapse() {
    final ScrollPosition? position = _position;
    if (position == null || !position.hasPixels) {
      return Future<void>.value();
    }
    final double target = (_expanded - _collapsed).clamp(
      0.0,
      position.maxScrollExtent,
    );
    return position.animateTo(
      target,
      duration: _kAppBarTravel,
      curve: Curves.easeOut,
    );
  }

  Future<void> _show() {
    _follow = false;
    return _visibility.forward();
  }

  Future<void> _hide() {
    _follow = false;
    return _visibility.reverse();
  }

  Future<void> _resumeScroll() {
    _follow = true;
    if (_offset <= math.max(0, _expanded - _collapsed) + 0.5) {
      return _visibility.forward();
    }
    return Future<void>.value();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final appBarTheme = theme.appBarTheme;
    final scheme = theme.colorScheme;
    final metrics = appBarTheme.metrics(bar.density);
    final hasSubtitle = bar.subtitle != null || bar.subtitleText != null;
    _collapsed = metrics.collapsedHeight;
    _expanded = metrics.expandedHeight(bar.variant, hasSubtitle: hasSubtitle);
    final motion = _M3EBarMotion(
      offset: _offset,
      collapsed: _collapsed,
      expanded: _expanded,
      shown: _visibility.value,
      mode: bar._effectiveHideMode,
      manual: !_follow,
    );
    final double top = MediaQuery.paddingOf(context).top;
    final double minContent = motion.entire
        ? _collapsed * motion.shown
        : _collapsed;
    final double maxContent = motion.entire
        ? math.max(_expanded * motion.shown, minContent)
        : _expanded;
    if (_bound != null &&
        (_collapsedNow != _bound!.isCollapsed ||
            _visibleNow != _bound!.isVisible)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _publish();
        }
      });
    }

    final Widget sliver = motion.actions
        ? _actionSliver(theme, appBarTheme, scheme, metrics, motion, top)
        : SliverPersistentHeader(
            pinned: bar.pinned,
            floating: bar.floating,
            delegate: _M3EAppBarDelegate(
              minExtent: top + minContent,
              maxExtent: top + math.max(maxContent, minContent),
              snap: bar.snap && bar.floating,
              vsync: this,
              builder:
                  (
                    BuildContext context,
                    double shrinkOffset, {
                    required bool overlaps,
                  }) {
                    final double current = math.max(
                      top + minContent,
                      top + math.max(maxContent, minContent) - shrinkOffset,
                    );
                    final double range = math.max(0, maxContent - minContent);
                    final double expand = range <= 0.5
                        ? 0
                        : (1 - (shrinkOffset / range).clamp(0.0, 1.0));
                    final double titleExpand = motion.actions
                        ? expand * motion.shown
                        : expand;
                    final bool under =
                        shrinkOffset > 0 || overlaps || _offset > 0;
                    final Color bg = _m3eBarColor(
                      bar: bar,
                      theme: appBarTheme,
                      scheme: scheme,
                      under: under,
                    );
                    final double elevation = under
                        ? metrics.scrolledElevation
                        : metrics.elevation;
                    final double contentSlot = math.max(0, current - top);
                    final double painted = motion.entire && motion.shown > 0.001
                        ? contentSlot / motion.shown
                        : contentSlot;
                    final Widget body = _M3EBarBody(
                      expand: titleExpand,
                      topPadding: appBarTheme.flexibleTopPadding,
                      actionRow: appBarTheme.actionRowHeight,
                      bottomPadding: metrics.flexibleBottomPadding,
                      titleInset: metrics.titleInset,
                      contentPadding: metrics.contentPadding,
                      centerTitle: bar.centerTitle,
                      search: bar.title is _M3EAppBarSearchTitle,
                      leading:
                          bar.leading ??
                          (bar.automaticallyImplyLeading
                              ? _maybeBackButton(
                                  context,
                                  bar.foregroundColor ??
                                      appBarTheme.leadingColor(scheme),
                                )
                              : null),
                      actions: bar.actions,
                      title: _sliverTitle(
                        theme,
                        appBarTheme,
                        scheme,
                        titleExpand,
                      ),
                      leadingColor:
                          bar.foregroundColor ??
                          appBarTheme.leadingColor(scheme),
                      trailingColor: appBarTheme.trailingColor(scheme),
                      iconSize: metrics.iconSize,
                      separateActions: motion.actions,
                      containerColor: bg,
                      shadowColor: scheme.shadow,
                      shape: appBarTheme.shape(bar.shapeFamily),
                    );
                    final Widget inner = ClipRect(
                      child: motion.entire
                          ? OverflowBox(
                              alignment: Alignment.bottomCenter,
                              minHeight: painted,
                              maxHeight: painted,
                              child: SizedBox(height: painted, child: body),
                            )
                          : body,
                    );
                    final Widget padded = SizedBox(
                      height: current,
                      child: Padding(
                        padding: EdgeInsets.only(top: top),
                        child: inner,
                      ),
                    );
                    return _M3EScrolledUnder(
                      scrolledUnder: under,
                      child: Material(
                        color: bg,
                        elevation: elevation,
                        shadowColor: scheme.shadow,
                        surfaceTintColor: const Color(0x00000000),
                        shape: appBarTheme.shape(bar.shapeFamily),
                        child: padded,
                      ),
                    );
                  },
            ),
          );
    if (bar.semanticLabel == null) {
      return sliver;
    }
    return M3ESliverSemantic(label: bar.semanticLabel!, child: sliver);
  }

  Widget _actionSliver(
    M3EThemeData theme,
    M3EAppBarTheme appBarTheme,
    M3EColorScheme scheme,
    M3EAppBarMetrics metrics,
    _M3EBarMotion motion,
    double top,
  ) {
    final double shown = motion.shown.clamp(0.0, 1.0);
    final double push = motion.painted * shown;
    final double paintContent = math.max(push, _collapsed);
    final bool under = _offset > 0;
    final Color bg = _m3eBarColor(
      bar: bar,
      theme: appBarTheme,
      scheme: scheme,
      under: under,
    );
    final double elevation = under
        ? metrics.scrolledElevation
        : metrics.elevation;
    final Widget? leading =
        bar.leading ??
        (bar.automaticallyImplyLeading
            ? _maybeBackButton(
                context,
                bar.foregroundColor ?? appBarTheme.leadingColor(scheme),
              )
            : null);
    final Widget body = _M3EBarBody(
      expand: motion.titleExpand,
      topPadding: appBarTheme.flexibleTopPadding,
      actionRow: appBarTheme.actionRowHeight,
      bottomPadding: metrics.flexibleBottomPadding,
      titleInset: metrics.titleInset,
      contentPadding: metrics.contentPadding,
      centerTitle: bar.centerTitle,
      search: bar.title is _M3EAppBarSearchTitle,
      leading: leading,
      actions: bar.actions,
      title: _sliverTitle(theme, appBarTheme, scheme, motion.titleExpand),
      leadingColor: bar.foregroundColor ?? appBarTheme.leadingColor(scheme),
      trailingColor: appBarTheme.trailingColor(scheme),
      iconSize: metrics.iconSize,
      separateActions: true,
      containerColor: bg,
      shadowColor: scheme.shadow,
      shape: appBarTheme.shape(bar.shapeFamily),
    );
    return _M3EActionSliver(
      layoutExtent: top + push,
      paintExtent: top + paintContent,
      child: _M3EScrolledUnder(
        scrolledUnder: under,
        child: SizedBox(
          height: top + paintContent,
          child: Padding(
            padding: EdgeInsets.only(top: top),
            child: Stack(
              children: <Widget>[
                Material(
                  color: bg,
                  elevation: elevation,
                  shadowColor: scheme.shadow,
                  surfaceTintColor: const Color(0x00000000),
                  shape: appBarTheme.shape(bar.shapeFamily),
                  child: _m3eClipSliding(
                    push: push,
                    visual: math.max(motion.painted, push),
                    child: body,
                  ),
                ),
                Positioned(
                  top: appBarTheme.flexibleTopPadding,
                  left: 0,
                  right: 0,
                  height: appBarTheme.actionRowHeight,
                  child: _M3EActionRow(
                    contentPadding: metrics.contentPadding,
                    actionRow: appBarTheme.actionRowHeight,
                    hide: motion.titleHide,
                    tonal: appBarTheme.actionsTonalColor(scheme),
                    leadingColor:
                        bar.foregroundColor ?? appBarTheme.leadingColor(scheme),
                    trailingColor: appBarTheme.trailingColor(scheme),
                    iconSize: metrics.iconSize,
                    leading: leading,
                    actions: bar.actions,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _sliverTitle(
    M3EThemeData theme,
    M3EAppBarTheme appBarTheme,
    M3EColorScheme scheme,
    double expand,
  ) {
    if (bar.title is _M3EAppBarSearchTitle) {
      return bar.title;
    }
    final Color titleColor =
        bar.foregroundColor ?? appBarTheme.titleColor(scheme);
    final TextStyle style =
        TextStyle.lerp(
          appBarTheme
              .titleStyle(theme.typeScale, variant: bar.variant)
              .copyWith(color: titleColor),
          appBarTheme
              .titleStyle(
                theme.typeScale,
                collapsed: false,
                variant: bar.variant,
              )
              .copyWith(color: titleColor),
          expand,
        ) ??
        appBarTheme.titleStyle(theme.typeScale, variant: bar.variant);
    final bool wrap = expand > 0.5;
    final Widget? title = _headline(
      title: bar.title,
      titleText: bar.titleText,
      style: style,
      centerTitle: bar.centerTitle,
      wrap: wrap,
    );
    final Widget? subtitle = _supporting(
      subtitle: bar.subtitle,
      subtitleText: bar.subtitleText,
      style: appBarTheme
          .subtitleStyle(theme.typeScale, bar.variant)
          .copyWith(color: appBarTheme.subtitleColor(scheme)),
      centerTitle: bar.centerTitle,
      wrap: wrap,
    );
    if (title == null && subtitle == null) {
      return null;
    }
    return _M3ETitleBlock(
      title: title,
      subtitle: subtitle,
      centerTitle: bar.centerTitle,
    );
  }
}

class _M3EAppBarDelegate extends SliverPersistentHeaderDelegate {
  _M3EAppBarDelegate({
    required this.minExtent,
    required this.maxExtent,
    required this.snap,
    required this.vsync,
    required this.builder,
  });

  @override
  final double minExtent;

  @override
  final double maxExtent;

  final bool snap;

  @override
  final TickerProvider vsync;

  final Widget Function(
    BuildContext context,
    double shrinkOffset, {
    required bool overlaps,
  })
  builder;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(context, shrinkOffset, overlaps: overlapsContent);
  }

  @override
  bool shouldRebuild(_M3EAppBarDelegate oldDelegate) => true;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration {
    if (!snap) {
      return null;
    }
    return FloatingHeaderSnapConfiguration(
      curve: Curves.easeOut,
      duration: _kAppBarTravel,
    );
  }
}

/// Maps scroll offset and hide progress onto the content band.
class _M3EBarMotion {
  const _M3EBarMotion({
    required this.offset,
    required this.collapsed,
    required this.expanded,
    required this.shown,
    required this.mode,
    required this.manual,
  });

  final double offset;
  final double collapsed;
  final double expanded;
  final double shown;
  final M3EAppBarHideMode mode;
  final bool manual;

  double get range => math.max(0, expanded - collapsed);

  double get expand {
    if (range <= 0.5) {
      return 0;
    }
    return (1 - (offset / range).clamp(0.0, 1.0)).clamp(0.0, 1.0);
  }

  bool get entire {
    if (mode == M3EAppBarHideMode.entire) {
      return true;
    }
    return mode == M3EAppBarHideMode.none && manual;
  }

  bool get actions => mode == M3EAppBarHideMode.actions;

  double get painted => lerpDouble(collapsed, expanded, expand) ?? collapsed;

  double get slot {
    final double open = painted;
    if (entire) {
      return open * shown.clamp(0.0, 1.0);
    }
    if (actions) {
      return lerpDouble(collapsed, open, shown.clamp(0.0, 1.0)) ?? collapsed;
    }
    return open;
  }

  double get titleExpand => actions ? expand * shown.clamp(0.0, 1.0) : expand;

  double get titleHide => actions ? 1 - shown.clamp(0.0, 1.0) : 0;
}

Color _m3eBarColor({
  required M3EAppBar bar,
  required M3EAppBarTheme theme,
  required M3EColorScheme scheme,
  required bool under,
}) {
  final Color rest = bar.backgroundColor ?? theme.backgroundColor(scheme);
  final Color scrolled =
      bar.backgroundColor ?? theme.scrolledBackgroundColor(scheme);
  return under ? scrolled : rest;
}

/// Follows the page scrollable and ignores overlay scrollables.
class _M3EPageScroll {
  ScrollPosition? tracked;

  /// Whether [notification] comes from the page this bar should follow.
  bool accepts(ScrollNotification notification, BuildContext context) {
    if (!defaultScrollNotificationPredicate(notification)) {
      return false;
    }
    if (notification.metrics.axis != Axis.vertical) {
      return false;
    }
    final BuildContext? target = notification.context;
    if (target == null || !target.mounted) {
      return false;
    }
    final ScrollPosition? position = Scrollable.maybeOf(target)?.position;
    if (position == null) {
      return false;
    }
    final ModalRoute<Object?>? barRoute = ModalRoute.of(context);
    final ModalRoute<Object?>? targetRoute = ModalRoute.of(target);
    if (barRoute != null &&
        targetRoute != null &&
        !identical(barRoute, targetRoute)) {
      return false;
    }
    final ScrollController? primary = PrimaryScrollController.maybeOf(context);
    if (primary != null && primary.hasClients) {
      return position == primary.position;
    }
    final replacing = tracked != null;
    if (!_scrollPositionAlive(tracked)) {
      tracked = null;
    }
    if (tracked != null) {
      return identical(position, tracked);
    }
    // Desktop lists do not attach to the route's primary controller.
    // An idle scrollable must not clear a bar that is already scrolled under.
    // A replaced position (refresh rebuilds the scrollable) is adopted so the
    // bar keeps following the list, including when that list is back at rest.
    if (notification.metrics.extentBefore > 0 || replacing) {
      tracked = position;
      return true;
    }
    return false;
  }
}

bool _scrollPositionAlive(ScrollPosition? position) {
  if (position == null || !position.hasPixels) {
    return false;
  }
  final ScrollContext scrollContext = position.context;
  if (scrollContext is ScrollableState &&
      (!scrollContext.mounted ||
          !identical(scrollContext.position, position))) {
    return false;
  }
  final BuildContext? notificationContext = scrollContext.notificationContext;
  return notificationContext != null && notificationContext.mounted;
}

/// Starts a hide once. Repeating [AnimationController.reverse] every pixel
/// stops and restarts the travel, which reads as a twitch.
void _m3eSlideAway(AnimationController visibility) {
  if (visibility.status == AnimationStatus.reverse ||
      visibility.value <= 0.001) {
    return;
  }
  visibility.reverse();
}

/// Starts a show once. See [_m3eSlideAway].
void _m3eSlideBack(AnimationController visibility) {
  if (visibility.status == AnimationStatus.forward ||
      visibility.value >= 0.999) {
    return;
  }
  visibility.forward();
}

/// Title block and action row. Actions mode splits them into two layers.
class _M3EBarBody extends StatelessWidget {
  const _M3EBarBody({
    required this.expand,
    required this.topPadding,
    required this.actionRow,
    required this.bottomPadding,
    required this.titleInset,
    required this.contentPadding,
    required this.centerTitle,
    required this.search,
    required this.leading,
    required this.actions,
    required this.title,
    required this.leadingColor,
    required this.trailingColor,
    required this.iconSize,
    required this.separateActions,
    required this.containerColor,
    required this.shadowColor,
    required this.shape,
  });

  final double expand;
  final double topPadding;
  final double actionRow;
  final double bottomPadding;
  final double titleInset;
  final EdgeInsetsGeometry contentPadding;
  final bool centerTitle;
  final bool search;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? title;
  final Color leadingColor;
  final Color trailingColor;
  final double iconSize;
  final bool separateActions;
  final Color containerColor;
  final Color shadowColor;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = contentPadding.resolve(
      Directionality.of(context),
    );
    final double pad = padding.left;
    final int actionCount = actions?.length ?? 0;
    final double lead = leading == null ? titleInset : pad + 48;
    final double trail = actionCount == 0 ? pad : pad + 48.0 * actionCount;
    final double shownExpand = expand.clamp(0.0, 1.0);
    final double boxTop =
        lerpDouble(0, topPadding + actionRow, shownExpand) ?? 0;
    final double boxBottom =
        lerpDouble(0, search ? 0 : bottomPadding, shownExpand) ?? 0;
    final double alignY = search
        ? (lerpDouble(0, -1, shownExpand) ?? 0)
        : (lerpDouble(0, 1, shownExpand) ?? 0);
    final Widget? titleBox = title == null
        ? null
        : PositionedDirectional(
            start: lerpDouble(lead, titleInset, shownExpand),
            end: lerpDouble(trail, titleInset, shownExpand),
            top: boxTop,
            bottom: boxBottom,
            child: Align(
              alignment: AlignmentDirectional(centerTitle ? 0 : -1, alignY),
              child: search
                  ? SizedBox(width: double.infinity, child: title)
                  : title,
            ),
          );
    final controls = <Widget>[
      PositionedDirectional(
        top: topPadding,
        start: pad,
        height: actionRow,
        child: IconTheme.merge(
          data: IconThemeData(size: iconSize, color: leadingColor),
          child: leading ?? const SizedBox.shrink(),
        ),
      ),
      if (actions != null && actions!.isNotEmpty)
        PositionedDirectional(
          top: topPadding,
          end: pad,
          height: actionRow,
          child: IconTheme.merge(
            data: IconThemeData(size: iconSize, color: trailingColor),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[for (final Widget action in actions!) action],
            ),
          ),
        ),
    ];
    if (!separateActions) {
      return Stack(children: <Widget>[?titleBox, ...controls]);
    }
    return Material(
      color: containerColor,
      shadowColor: shadowColor,
      surfaceTintColor: const Color(0x00000000),
      shape: shape,
      child: Stack(children: <Widget>[?titleBox]),
    );
  }
}

/// Paints the action band over the page. The layout slot shrinks with the bar.
class _M3EActionSliver extends SingleChildRenderObjectWidget {
  const _M3EActionSliver({
    required this.layoutExtent,
    required this.paintExtent,
    required super.child,
  });

  final double layoutExtent;
  final double paintExtent;

  @override
  RenderSliver createRenderObject(BuildContext context) {
    return _RenderM3EActionSliver(
      layoutExtent: layoutExtent,
      paintExtent: paintExtent,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderM3EActionSliver renderObject,
  ) {
    if (renderObject.layoutExtent == layoutExtent &&
        renderObject.paintExtent == paintExtent) {
      return;
    }
    renderObject
      ..layoutExtent = layoutExtent
      ..paintExtent = paintExtent
      ..markNeedsLayout();
  }
}

class _RenderM3EActionSliver extends RenderSliverSingleBoxAdapter {
  _RenderM3EActionSliver({
    required this.layoutExtent,
    required this.paintExtent,
  });

  double layoutExtent;
  double paintExtent;

  @override
  double childMainAxisPosition(RenderBox child) => 0;

  @override
  void performLayout() {
    final double paint = math.max(0, paintExtent);
    final double layout = math.min(math.max(0, layoutExtent), paint);
    child?.layout(
      constraints.asBoxConstraints(minExtent: paint, maxExtent: paint),
      parentUsesSize: true,
    );
    final double remaining = math.max(
      0,
      constraints.remainingPaintExtent - constraints.overlap,
    );
    final double painted = math.min(paint, remaining);
    geometry = SliverGeometry(
      scrollExtent: layout,
      paintOrigin: math.min(constraints.overlap, 0),
      paintExtent: painted,
      layoutExtent: math.min(layout, remaining),
      maxPaintExtent: math.max(paint, painted),
      hitTestExtent: painted,
      hasVisualOverflow: paint > layout + 0.5,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final RenderBox? box = child;
    if (box == null || geometry?.visible != true) {
      return;
    }
    context.paintChild(box, offset);
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    applyPaintTransformForBoxChild(child as RenderBox, transform);
  }
}

/// Slides [child] up out of a shrinking window.
Widget _m3eClipSliding({
  required double push,
  required double visual,
  required Widget child,
}) {
  final double open = math.max(visual, push);
  return SizedBox(
    height: math.max(0, push),
    child: ClipRect(
      child: OverflowBox(
        alignment: Alignment.bottomCenter,
        minHeight: open,
        maxHeight: open,
        child: SizedBox(height: open, child: child),
      ),
    ),
  );
}

/// Actions painted above the page, with no bar behind them.
class _M3EActionOverlay extends StatelessWidget {
  const _M3EActionOverlay({
    required this.controller,
    required this.color,
    required this.inset,
    required this.topPadding,
    required this.actionRow,
    required this.contentPadding,
    required this.hide,
    required this.tonal,
    required this.leadingColor,
    required this.trailingColor,
    required this.iconSize,
    required this.leading,
    required this.actions,
    required this.child,
  });

  final OverlayPortalController controller;
  final Color color;
  final double inset;
  final double topPadding;
  final double actionRow;
  final EdgeInsetsGeometry contentPadding;
  final double hide;
  final Color tonal;
  final Color leadingColor;
  final Color trailingColor;
  final double iconSize;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color,
      child: OverlayPortal.overlayChildLayoutBuilder(
        controller: controller,
        overlayChildBuilder:
            (BuildContext context, OverlayChildLayoutInfo info) {
              final double dy = info.childPaintTransform.getTranslation().y;
              return Positioned(
                top: dy + inset + topPadding,
                left: 0,
                right: 0,
                height: actionRow,
                child: _M3EActionRow(
                  contentPadding: contentPadding,
                  actionRow: actionRow,
                  hide: hide,
                  tonal: tonal,
                  leadingColor: leadingColor,
                  trailingColor: trailingColor,
                  iconSize: iconSize,
                  leading: leading,
                  actions: actions,
                ),
              );
            },
        child: child,
      ),
    );
  }
}

/// Leading and trailing controls. Each one carries its own fill.
class _M3EActionRow extends StatelessWidget {
  const _M3EActionRow({
    required this.contentPadding,
    required this.actionRow,
    required this.hide,
    required this.tonal,
    required this.leadingColor,
    required this.trailingColor,
    required this.iconSize,
    required this.leading,
    required this.actions,
  });

  final EdgeInsetsGeometry contentPadding;
  final double actionRow;
  final double hide;
  final Color tonal;
  final Color leadingColor;
  final Color trailingColor;
  final double iconSize;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = contentPadding.resolve(
      Directionality.of(context),
    );
    final double alpha = hide.clamp(0.0, 1.0);
    return Padding(
      padding: EdgeInsets.only(left: padding.left, right: padding.right),
      child: Row(
        children: <Widget>[
          if (leading != null)
            IconTheme.merge(
              data: IconThemeData(size: iconSize, color: leadingColor),
              child: _plate(leading!, alpha),
            ),
          const Spacer(),
          if (actions != null)
            IconTheme.merge(
              data: IconThemeData(size: iconSize, color: trailingColor),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  for (final Widget action in actions!) _plate(action, alpha),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _plate(Widget child, double alpha) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: alpha <= 0 ? null : tonal.withValues(alpha: alpha),
        borderRadius: BorderRadius.circular(actionRow / 2),
      ),
      child: SizedBox(
        width: actionRow,
        height: actionRow,
        child: Center(child: child),
      ),
    );
  }
}

/// Reports whether the app bar's content has scrolled under it.
class _M3EScrolledUnder extends InheritedWidget {
  const _M3EScrolledUnder({required this.scrolledUnder, required super.child});

  final bool scrolledUnder;

  static bool of(BuildContext context) {
    final _M3EScrolledUnder? scope = context
        .dependOnInheritedWidgetOfExactType<_M3EScrolledUnder>();
    return scope?.scrolledUnder ?? false;
  }

  @override
  bool updateShouldNotify(_M3EScrolledUnder oldWidget) {
    return scrolledUnder != oldWidget.scrolledUnder;
  }
}

/// Headline and subtitle, announced as a header.
class _M3ETitleBlock extends StatelessWidget {
  const _M3ETitleBlock({
    required this.title,
    required this.subtitle,
    required this.centerTitle,
  });

  final Widget? title;
  final Widget? subtitle;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    if (title == null && subtitle == null) {
      return const SizedBox.shrink();
    }
    return Semantics(
      header: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: <Widget>[?title, ?subtitle],
      ),
    );
  }
}

Widget? _headline({
  required Widget? title,
  required String? titleText,
  required TextStyle style,
  required bool centerTitle,
  required bool wrap,
}) {
  if (title != null) {
    return DefaultTextStyle(style: style, child: title);
  }
  if (titleText == null) {
    return null;
  }
  return Text(
    titleText,
    style: style,
    textAlign: centerTitle ? TextAlign.center : TextAlign.start,
    maxLines: wrap ? null : 1,
    overflow: wrap ? TextOverflow.clip : TextOverflow.ellipsis,
  );
}

Widget? _supporting({
  required Widget? subtitle,
  required String? subtitleText,
  required TextStyle style,
  required bool centerTitle,
  required bool wrap,
}) {
  if (subtitle != null) {
    return DefaultTextStyle(style: style, child: subtitle);
  }
  if (subtitleText == null) {
    return null;
  }
  return Text(
    subtitleText,
    style: style,
    textAlign: centerTitle ? TextAlign.center : TextAlign.start,
    maxLines: wrap ? null : 1,
    overflow: wrap ? TextOverflow.clip : TextOverflow.ellipsis,
  );
}

Widget? _maybeBackButton(BuildContext context, Color color) {
  final bool canPop = Navigator.maybeOf(context)?.canPop() ?? false;
  if (!canPop) {
    return null;
  }
  final String message = MaterialLocalizations.of(context).backButtonTooltip;
  return M3ETooltip(
    message: message,
    dismissDelay: Duration.zero,
    child: IconButton(
      icon: const BackButtonIcon(),
      color: color,
      onPressed: () => Navigator.maybeOf(context)?.maybePop(),
    ),
  );
}

/// Anchored search title sized to the search-bar spec.
class _M3EAppBarSearchTitle extends StatelessWidget {
  const _M3EAppBarSearchTitle({
    required this.searchController,
    required this.suggestionsBuilder,
    this.barHintText,
    this.barLeading,
    this.barTrailing,
    this.barBackgroundColor,
    this.barAlignment = Alignment.center,
    this.wrapActions = false,
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
  final AlignmentGeometry barAlignment;
  final bool wrapActions;
  final bool isFullScreen;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClose;
  final VoidCallback? onOpen;
  final BoxConstraints? searchConstraints;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final appBarTheme = theme.appBarTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    final bool under = _M3EScrolledUnder.of(context);
    final Color field = appBarTheme.searchFieldColor(
      scheme,
      scrolledUnder: under,
    );
    final TextStyle input = appBarTheme.searchTextStyle(
      theme.typeScale,
      scheme,
    );
    final TextStyle hint = appBarTheme.searchHintStyle(theme.typeScale, scheme);
    return M3ESearchAnchor.bar(
      searchController: searchController,
      suggestionsBuilder: suggestionsBuilder,
      barHintText: barHintText,
      barLeading: barLeading,
      barTrailing: barTrailing,
      barAlignment: barAlignment,
      wrapActions: wrapActions,
      barBackgroundColor:
          barBackgroundColor ?? WidgetStatePropertyAll<Color>(field),
      barElevation: WidgetStatePropertyAll<double>(appBarTheme.searchElevation),
      barShape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(appBarTheme.searchBarRadius),
        ),
      ),
      barPadding: WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: appBarTheme.titleGap),
      ),
      barOverlayColor: WidgetStateProperty.resolveWith((
        Set<WidgetState> states,
      ) {
        if (states.contains(WidgetState.pressed)) {
          return scheme.onSurface.withValues(alpha: appBarTheme.pressedOpacity);
        }
        if (states.contains(WidgetState.hovered)) {
          return scheme.onSurface.withValues(alpha: appBarTheme.hoverOpacity);
        }
        return null;
      }),
      barTextStyle: WidgetStatePropertyAll<TextStyle>(input),
      barHintStyle: WidgetStatePropertyAll<TextStyle>(hint),
      viewBackgroundColor: appBarTheme.searchViewColor(scheme),
      viewElevation: appBarTheme.searchViewElevation,
      viewHeaderHeight: isFullScreen
          ? appBarTheme.searchFullScreenHeader
          : appBarTheme.searchDockedHeader,
      dividerColor: scheme.outline,
      isFullScreen: isFullScreen,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      onClose: onClose,
      onOpen: onOpen,
      constraints:
          searchConstraints ??
          BoxConstraints.tightFor(height: appBarTheme.searchBarHeight),
      expandOnFocus: false,
      expandRestPadding: 0,
    );
  }
}
