part of '../m3e_app_bars.dart';

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

  /// Re-derives on-scroll state from the live scroll position whenever a
  /// dependency changes (e.g. a theme rebuild). Notifications are the normal
  /// source of truth, but nothing else corrects [_offset]/[_under] if a
  /// dependency-driven rebuild ever leaves them stale, so this resyncs them
  /// unconditionally rather than only when [_offset] happens to be zero.
  void _seedPrimary() {
    final ScrollController? primary = PrimaryScrollController.maybeOf(context);
    if (primary == null || !primary.hasClients) {
      return;
    }
    _position = primary.position;
    if (primary.offset != _offset) {
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
    _maybeSlideForScroll(offset, scrollDelta);
    _commitExtent(_slotHeight());
    _publish();
    // A small bar only changes color at the top. Rebuilding it on every
    // pixel restarts hover under the pointer and the list appears to flicker.
    _maybeRebuild(changed: changed, offset: offset, previous: previous);
  }

  /// Starts or stops the hide-on-scroll travel for [offset]/[scrollDelta].
  void _maybeSlideForScroll(double offset, double? scrollDelta) {
    if (!_follow ||
        scrollDelta == null ||
        bar._effectiveHideMode == M3EAppBarHideMode.none) {
      return;
    }
    final double range = math.max(0, _expanded - _collapsed);
    if (scrollDelta > 0.5 && offset > range) {
      _m3eSlideAway(_visibility);
    } else if (scrollDelta < -0.5) {
      _m3eSlideBack(_visibility);
    }
  }

  void _maybeRebuild({
    required bool changed,
    required double offset,
    required double previous,
  }) {
    final bool flexible = _expanded > _collapsed + 0.5;
    final bool shouldRebuild =
        changed || (flexible && (offset - previous).abs() > 0.5);
    if (mounted && shouldRebuild) {
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
