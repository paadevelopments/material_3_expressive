import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_tabs_variant.dart';
import 'models/m3e_tab.dart';
import 'styles/m3e_tabs_tokens.dart';

export 'enums/m3e_tabs_variant.dart';
export 'models/m3e_tab.dart';
export 'styles/m3e_tabs_tokens.dart';

/// A Material 3 Expressive tab bar.
///
/// Organises content across views. The active indicator slides between tabs
/// with an emphasized spring, and each tab shows hover/press state layers.
class M3ETabs extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final double align =
        tabs.length == 1 ? 0 : -1 + 2 * selectedIndex / (tabs.length - 1);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: M3ETabsTokens.backgroundColor(scheme),
        border: Border(
          bottom: BorderSide(color: M3ETabsTokens.dividerColor(scheme)),
        ),
      ),
      child: SizedBox(
        height: M3ETabsTokens.height,
        child: Stack(
          children: <Widget>[
            Row(children: _buildTabs(theme)),
            _buildIndicator(scheme, align),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTabs(M3EThemeData theme) {
    return <Widget>[
      for (int i = 0; i < tabs.length; i++)
        Expanded(child: _buildTab(theme, i)),
    ];
  }

  Widget _buildTab(M3EThemeData theme, int index) {
    final scheme = theme.colorScheme;
    final selected = index == selectedIndex;
    final M3ETab tab = tabs[index];

    return M3ETappable(
      onTap: () => onTabSelected(index),
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
            Center(child: _buildTabContent(theme, tab, selected)),
          ],
        );
      },
    );
  }

  Widget _buildTabContent(M3EThemeData theme, M3ETab tab, bool selected) {
    final scheme = theme.colorScheme;
    final children = <Widget>[
      if (tab.icon != null)
        IconTheme.merge(
          data: IconThemeData(
            color: M3ETabsTokens.tabColor(scheme, selected: selected),
            size: M3ETabsTokens.iconSize,
          ),
          child: tab.icon!,
        ),
      if (tab.label != null)
        Text(
          tab.label!,
          style: M3ETabsTokens.labelStyle(
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

  Widget _buildIndicator(M3EColorScheme scheme, double align) {
    final bool fullWidth = M3ETabsTokens.indicatorFullWidth(variant);
    return AnimatedAlign(
      duration: M3EMotion.medium2,
      curve: M3EMotion.emphasized,
      alignment: Alignment(align, 1),
      child: FractionallySizedBox(
        widthFactor: 1 / tabs.length,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: M3ETabsTokens.indicatorHeight,
            width: fullWidth ? null : M3ETabsTokens.primaryIndicatorWidth,
            decoration: BoxDecoration(
              color: M3ETabsTokens.indicatorColor(scheme),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(M3ETabsTokens.indicatorCornerRadius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
