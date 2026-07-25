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
      for (final section in widget.sections) {
        if (section.header != null) {
          children.add(
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 16,
                end: 16,
                top: theme.sectionHeaderSpacingTop,
                bottom: theme.sectionHeaderSpacingBottom,
              ),
              child: DefaultTextStyle(
                style: M3ETheme.of(context).typeScale.titleSmall.copyWith(
                  color: M3ETheme.of(context).colorScheme.onSurfaceVariant,
                ),
                child: section.header!,
              ),
            ),
          );
        }
        for (final dest in section.destinations) {
          final index = _M3ENavigationRailState._destinationIndex(
            widget.sections,
            dest,
          );
          children.add(
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 16,
                end: 16,
                top: theme.itemVerticalGap,
                bottom: theme.itemVerticalGap,
              ),
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
    } else {
      final all = widget.sections.expand((s) => s.destinations).toList();
      for (var i = 0; i < all.length; i++) {
        children.add(
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: M3ENavigationRailLayout.horizontalInset,
              end: M3ENavigationRailLayout.horizontalInset,
              top: theme.itemVerticalGap,
              bottom: theme.itemVerticalGap,
            ),
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
        );
      }
    }
    if (widget.trailing != null && !widget.trailingAtBottom) {
      final trailingWidget = _buildTrailing(context);
      if (trailingWidget != null) {
        children.add(trailingWidget);
      }
    }
    return children;
  }
}
