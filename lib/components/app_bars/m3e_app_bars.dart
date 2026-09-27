import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/rendering.dart' show FloatingHeaderSnapConfiguration;

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
    ValueChanged<String>? onSubmitted,
    ValueChanged<String>? onChanged,
    VoidCallback? onClose,
    VoidCallback? onOpen,
    BoxConstraints? searchConstraints,
    AlignmentGeometry barAlignment = Alignment.center,
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
        barAlignment: barAlignment,
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
  M3EAppBarController? _bound;
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
    if (!defaultScrollNotificationPredicate(notification)) {
      return;
    }
    if (notification.metrics.axis != Axis.vertical) {
      return;
    }
    final BuildContext? target = notification.context;
    if (target != null && target.mounted) {
      _position = Scrollable.maybeOf(target)?.position;
    }
    _applyOffset(notification.metrics.extentBefore);
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

  void _applyOffset(double offset) {
    final double previous = _offset;
    _offset = offset;
    final under = offset > 0;
    final changed = under != _under;
    _under = under;
    if (_follow && bar._effectiveHideMode != M3EAppBarHideMode.none) {
      final double delta = offset - previous;
      final double range = math.max(0, _expanded - _collapsed);
      if (delta > 0.5 && offset > range) {
        _visibility.reverse();
      } else if (delta < -0.5) {
        _visibility.forward();
      }
    }
    _commitExtent(_slotHeight());
    _publish();
    if (mounted && (changed || (offset - previous).abs() > 0.5)) {
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
    _m3eAppBarWriteHeight(bar, height);
    if (previous != null && (previous - height).abs() < 0.5) {
      return;
    }
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
    if ((_m3eAppBarHeightOf(bar) ?? -1) != slot && bar.toolbarHeight == null) {
      _m3eAppBarWriteHeight(bar, slot);
    }

    final bool under = _under;
    final Color bg = _m3eBarColor(
      bar: bar,
      theme: appBarTheme,
      scheme: scheme,
      under: under,
      titleHide: motion.titleHide,
    );
    final double elevation =
        bar.elevation ??
        (under ? metrics.scrolledElevation : metrics.elevation);
    final Widget body = _M3EBarBody(
      expand: motion.titleExpand,
      hide: motion.titleHide,
      band: _collapsed,
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
      tonal: appBarTheme.actionsTonalColor(scheme),
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
    final Widget material = Material(
      color: bg,
      elevation: elevation,
      shadowColor: scheme.shadow,
      surfaceTintColor: const Color(0x00000000),
      shape: appBarTheme.shape(bar.shapeFamily),
      clipBehavior: bar.clipBehavior,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double inset = safe.top + safe.bottom;
          final double available = constraints.maxHeight.isFinite
              ? math.max(0, constraints.maxHeight - inset)
              : slot;
          final double height = math.min(math.max(0, slot), available);
          return Padding(
            padding: safe,
            child: SizedBox(height: height, child: clipped),
          );
        },
      ),
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
    if (!defaultScrollNotificationPredicate(notification)) {
      return;
    }
    if (notification.metrics.axis != Axis.vertical) {
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
    _lastPixels = pixels;
    _offset = pixels;
    if (_follow && bar._effectiveHideMode != M3EAppBarHideMode.none) {
      final double range = math.max(0, _expanded - _collapsed);
      if (delta > 0.5 && pixels > range) {
        _visibility.reverse();
      } else if (delta < -0.5) {
        _visibility.forward();
      }
    }
    _publish();
    if (mounted) {
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
        ? _collapsed * _visibility.value
        : _collapsed;
    final double maxContent = motion.entire
        ? math.max(_expanded * _visibility.value, minContent)
        : motion.actions
        ? math.max(motion.slot, minContent)
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

    final Widget sliver = SliverPersistentHeader(
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
              final bool under = shrinkOffset > 0 || overlaps || _offset > 0;
              final Color bg = _m3eBarColor(
                bar: bar,
                theme: appBarTheme,
                scheme: scheme,
                under: under,
                titleHide: motion.titleHide,
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
                hide: motion.titleHide,
                band: _collapsed,
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
                title: _sliverTitle(theme, appBarTheme, scheme, titleExpand),
                leadingColor:
                    bar.foregroundColor ?? appBarTheme.leadingColor(scheme),
                trailingColor: appBarTheme.trailingColor(scheme),
                iconSize: metrics.iconSize,
                tonal: appBarTheme.actionsTonalColor(scheme),
              );
              return _M3EScrolledUnder(
                scrolledUnder: under,
                child: Material(
                  color: bg,
                  elevation: elevation,
                  shadowColor: scheme.shadow,
                  surfaceTintColor: const Color(0x00000000),
                  shape: appBarTheme.shape(bar.shapeFamily),
                  child: SizedBox(
                    height: current,
                    child: Padding(
                      padding: EdgeInsets.only(top: top),
                      child: ClipRect(
                        child: motion.entire
                            ? OverflowBox(
                                alignment: Alignment.bottomCenter,
                                minHeight: painted,
                                maxHeight: painted,
                                child: SizedBox(height: painted, child: body),
                              )
                            : body,
                      ),
                    ),
                  ),
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
  required double titleHide,
}) {
  final Color rest = bar.backgroundColor ?? theme.backgroundColor(scheme);
  final Color scrolled =
      bar.backgroundColor ?? theme.scrolledBackgroundColor(scheme);
  final base = under ? scrolled : rest;
  if (titleHide <= 0) {
    return base;
  }
  return Color.lerp(base, theme.actionsTonalColor(scheme), titleHide) ?? base;
}

/// One title block, the action row, and the tonal fill while actions stay.
class _M3EBarBody extends StatelessWidget {
  const _M3EBarBody({
    required this.expand,
    required this.hide,
    required this.band,
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
    required this.tonal,
  });

  final double expand;
  final double hide;
  final double band;
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
  final Color tonal;

  @override
  Widget build(BuildContext context) {
    final EdgeInsets padding = contentPadding.resolve(
      Directionality.of(context),
    );
    final double pad = padding.left;
    final int actionCount = actions?.length ?? 0;
    final double lead = leading == null ? pad : pad + 48;
    final double trail = actionCount == 0 ? pad : pad + 48.0 * actionCount;
    final double shownExpand = expand.clamp(0.0, 1.0);
    final double shift = hide.clamp(0.0, 1.0) * band;
    final double boxTop =
        (lerpDouble(0, topPadding + actionRow, shownExpand) ?? 0) - shift;
    final double boxBottom =
        (lerpDouble(0, search ? 0 : bottomPadding, shownExpand) ?? 0) + shift;
    final double alignY = search
        ? (lerpDouble(0, -1, shownExpand) ?? 0)
        : (lerpDouble(0, 1, shownExpand) ?? 0);
    return Stack(
      children: <Widget>[
        if (hide > 0)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: band,
            child: IgnorePointer(
              child: ColoredBox(
                color: tonal.withValues(alpha: hide.clamp(0.0, 1.0)),
              ),
            ),
          ),
        if (title != null)
          PositionedDirectional(
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
          ),
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
              child: Row(mainAxisSize: MainAxisSize.min, children: actions!),
            ),
          ),
      ],
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
