import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_tabs_variant.dart';
import 'models/m3e_tab.dart';
import 'styles/m3e_tab_theme.dart';

export 'enums/m3e_tabs_variant.dart';
export 'models/m3e_tab.dart';
export 'styles/m3e_tab_theme.dart';

/// A Material 3 Expressive tab bar.
///
/// Organises content across views. The active indicator slides between tabs
/// with an emphasized spring, and each tab shows hover/press state layers.
///
/// Primary indicators match each tab's label/content width; secondary
/// indicators span the full tab slot.
class M3ETabs extends StatefulWidget {
  const M3ETabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.variant = M3ETabsVariant.primary,
    super.key,
  }) : assert(tabs.length >= 2, 'A tab bar needs 2+ tabs.');

  final List<M3ETab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final M3ETabsVariant variant;

  @override
  State<M3ETabs> createState() => _M3ETabsState();
}

class _M3ETabsState extends State<M3ETabs> {
  final GlobalKey _barKey = GlobalKey();
  late List<GlobalKey> _contentKeys;

  double? _indicatorLeft;
  double? _indicatorWidth;

  @override
  void initState() {
    super.initState();
    _contentKeys = List<GlobalKey>.generate(
      widget.tabs.length,
      (_) => GlobalKey(),
    );
    _scheduleMeasure();
  }

  @override
  void didUpdateWidget(covariant M3ETabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabs.length != widget.tabs.length) {
      _contentKeys = List<GlobalKey>.generate(
        widget.tabs.length,
        (_) => GlobalKey(),
      );
      _indicatorLeft = null;
      _indicatorWidth = null;
    }
    if (oldWidget.selectedIndex != widget.selectedIndex ||
        oldWidget.tabs.length != widget.tabs.length ||
        oldWidget.variant != widget.variant) {
      _scheduleMeasure();
    }
  }

  void _scheduleMeasure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _measureIndicator();
      }
    });
  }

  void _measureIndicator() {
    final RenderBox? barBox =
        _barKey.currentContext?.findRenderObject() as RenderBox?;
    if (barBox == null || !barBox.hasSize) {
      return;
    }

    final int index = widget.selectedIndex.clamp(0, widget.tabs.length - 1);
    final M3ETabTheme tabTheme = M3ETheme.of(context).tabTheme;
    final bool fullWidth = tabTheme.indicatorFullWidth(widget.variant);

    late final double left;
    late final double width;

    if (fullWidth) {
      width = barBox.size.width / widget.tabs.length;
      left = width * index;
    } else {
      final RenderBox? contentBox =
          _contentKeys[index].currentContext?.findRenderObject() as RenderBox?;
      if (contentBox == null || !contentBox.hasSize) {
        return;
      }
      final Offset contentOrigin =
          contentBox.localToGlobal(Offset.zero, ancestor: barBox);
      width = contentBox.size.width;
      left = contentOrigin.dx;
    }

    if (_indicatorLeft == left && _indicatorWidth == width) {
      return;
    }
    setState(() {
      _indicatorLeft = left;
      _indicatorWidth = width;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final tabTheme = theme.tabTheme;
    final scheme = theme.colorScheme;

    return M3EComponentTheme(
      builder: (BuildContext context) => NotificationListener<SizeChangedLayoutNotification>(
        onNotification: (SizeChangedLayoutNotification notification) {
          _scheduleMeasure();
          return false;
        },
        child: SizeChangedLayoutNotifier(
          child: DecoratedBox(
            key: _barKey,
            decoration: BoxDecoration(
              color: tabTheme.backgroundColor(scheme),
              border: Border(
                bottom: BorderSide(color: tabTheme.dividerColor(scheme)),
              ),
            ),
            child: SizedBox(
              height: tabTheme.height,
              child: Stack(
                children: <Widget>[
                  Row(children: _buildTabs(theme, tabTheme)),
                  if (_indicatorLeft != null && _indicatorWidth != null)
                    AnimatedPositioned(
                      duration: M3EMotion.medium2,
                      curve: M3EMotion.emphasized,
                      left: _indicatorLeft,
                      width: _indicatorWidth,
                      bottom: 0,
                      height: tabTheme.indicatorHeight,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: tabTheme.indicatorColor(scheme),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              tabTheme.indicatorCornerRadius,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs(M3EThemeData theme, M3ETabTheme tabTheme) {
    return <Widget>[
      for (int i = 0; i < widget.tabs.length; i++)
        Expanded(child: _buildTab(theme, tabTheme, i)),
    ];
  }

  Widget _buildTab(M3EThemeData theme, M3ETabTheme tabTheme, int index) {
    final scheme = theme.colorScheme;
    final selected = index == widget.selectedIndex;
    final M3ETab tab = widget.tabs[index];

    return M3ETappable(
      onTap: () => widget.onTabSelected(index),
      semanticLabel: tab.label,
      builder: (BuildContext context, M3EInteractionState state) {
        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: scheme.primary.withValues(alpha: state.opacity),
                ),
              ),
            ),
            Center(
              child: KeyedSubtree(
                key: _contentKeys[index],
                child: _buildTabContent(theme, tabTheme, tab, selected),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTabContent(
    M3EThemeData theme,
    M3ETabTheme tabTheme,
    M3ETab tab,
    bool selected,
  ) {
    final scheme = theme.colorScheme;
    final children = <Widget>[
      if (tab.icon != null)
        IconTheme.merge(
          data: IconThemeData(
            color: tabTheme.tabColor(scheme, selected: selected),
            size: tabTheme.iconSize,
          ),
          child: tab.icon!,
        ),
      if (tab.label != null)
        Text(
          tab.label!,
          style: tabTheme.labelStyle(
            theme.typeScale,
            scheme,
            selected: selected,
          ),
        ),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
