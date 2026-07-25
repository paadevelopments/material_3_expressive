part of '../m3e_navigation_rail.dart';

mixin _M3ENavigationRailChildrenMixin on State<M3ENavigationRail> {
  bool get _isExpanded;
  bool get _suppressInk;
  bool get _traveling;
  List<GlobalKey> get _destinationKeys;
  Widget _buildMenuButton(BuildContext context, {required Alignment alignment});
  Widget? _buildFab(BuildContext context);
  Widget? _buildTrailing(BuildContext context) {
    final tr = widget.trailing;
    if (tr == null) {
      return null;
    }
    final isExpanded = _isExpanded;
    return Padding(
      padding: M3ENavigationRailLayout.sectionPadding,
      child: Align(
        alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
        child: tr,
      ),
    );
  }

  List<Widget> _buildChildren(
    BuildContext context, {
    required bool showLabels,
  }) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final isExpanded = _isExpanded;
    final children = <Widget>[
      const SizedBox(height: M3ENavigationRailLayout.topGap),
      _buildMenuButton(
        context,
        alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
      ),
    ];
    final fabWidget = _buildFab(context);
    if (fabWidget != null) {
      children.add(fabWidget);
    }
    if (isExpanded) {
      children.addAll(_buildExpandedDestinations(context, theme));
    } else {
      children.addAll(_buildCollapsedDestinations(theme));
    }
    if (widget.trailing != null && !widget.trailingAtBottom) {
      final trailingWidget = _buildTrailing(context);
      if (trailingWidget != null) {
        children.add(trailingWidget);
      }
    }
    return children;
  }

  List<Widget> _buildExpandedDestinations(
    BuildContext context,
    M3ENavigationRailTheme theme,
  ) {
    final children = <Widget>[];
    for (final section in widget.sections) {
      if (section.header != null) {
        children.add(_sectionHeader(context, theme, section.header!));
      }
      for (final dest in section.destinations) {
        final index = _M3ENavigationRailState._destinationIndex(
          widget.sections,
          dest,
        );
        children.add(
          _destinationPadding(
            theme: theme,
            start: 16,
            end: 16,
            child: M3ERailItem(
              destination: dest,
              selected: index == widget.selectedIndex,
              onTap: () => widget.onDestinationSelected(index),
              expanded: true,
              labelBehavior: widget.labelBehavior,
              suppressInk: _suppressInk,
              useLocalIndicator: !_traveling,
              indicatorKey: _destinationKeys[index],
            ),
          ),
        );
      }
    }
    return children;
  }

  List<Widget> _buildCollapsedDestinations(M3ENavigationRailTheme theme) {
    final all = widget.sections.expand((s) => s.destinations).toList();
    return <Widget>[
      for (var i = 0; i < all.length; i++)
        _destinationPadding(
          theme: theme,
          start: M3ENavigationRailLayout.horizontalInset,
          end: M3ENavigationRailLayout.horizontalInset,
          child: M3ERailItem(
            destination: all[i],
            selected: i == widget.selectedIndex,
            onTap: () => widget.onDestinationSelected(i),
            expanded: false,
            labelBehavior: widget.labelBehavior,
            suppressInk: _suppressInk,
            useLocalIndicator: !_traveling,
            indicatorKey: _destinationKeys[i],
          ),
        ),
    ];
  }

  Widget _sectionHeader(
    BuildContext context,
    M3ENavigationRailTheme theme,
    Widget header,
  ) {
    final m3e = M3ETheme.of(context);
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 16,
        top: theme.sectionHeaderSpacingTop,
        bottom: theme.sectionHeaderSpacingBottom,
      ),
      child: DefaultTextStyle(
        style: m3e.typeScale.titleSmall.copyWith(
          color: m3e.colorScheme.onSurfaceVariant,
        ),
        child: header,
      ),
    );
  }

  Widget _destinationPadding({
    required M3ENavigationRailTheme theme,
    required double start,
    required double end,
    required Widget child,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: start,
        end: end,
        top: theme.itemVerticalGap,
        bottom: theme.itemVerticalGap,
      ),
      child: child,
    );
  }
}
