import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../navigation_bar/models/m3e_navigation_destination.dart';

/// A Material 3 Expressive navigation rail.
///
/// A vertical navigation surface for medium-width layouts. Destinations stack
/// vertically with a morphing pill indicator; an optional [leading] widget
/// (typically a FAB) sits above them.
class M3ENavigationRail extends StatelessWidget {
  const M3ENavigationRail({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.leading,
    this.trailing,
    this.labelType = M3ENavigationRailLabelType.all,
    super.key,
  }) : assert(destinations.length >= 2, 'A rail needs 2+ destinations.');

  final List<M3ENavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget? leading;
  final Widget? trailing;
  final M3ENavigationRailLabelType labelType;

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    return Container(
      width: 80,
      color: scheme.surface,
      child: SafeArea(
        right: false,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 8),
            if (leading != null) ...<Widget>[
              leading!,
              const SizedBox(height: 8),
            ],
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  for (int i = 0; i < destinations.length; i++)
                    _buildDestination(context, i),
                ],
              ),
            ),
            ?trailing,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildDestination(BuildContext context, int index) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final selected = index == selectedIndex;
    final M3ENavigationDestination dest = destinations[index];
    final Color iconColor =
        selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
    final bool showLabel = labelType == M3ENavigationRailLabelType.all ||
        (labelType == M3ENavigationRailLabelType.selected && selected);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: M3ETappable(
        onTap: () => onDestinationSelected(index),
        semanticLabel: dest.label,
        builder: (BuildContext context, M3EInteractionState state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildIndicator(scheme, dest, selected, state, iconColor),
              if (showLabel) ...<Widget>[
                const SizedBox(height: 4),
                Text(
                  dest.label,
                  style: theme.typeScale.labelMedium.copyWith(
                    color:
                        selected ? scheme.onSurface : scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildIndicator(
    M3EColorScheme scheme,
    M3ENavigationDestination dest,
    bool selected,
    M3EInteractionState state,
    Color iconColor,
  ) {
    return AnimatedContainer(
      duration: M3EMotion.medium2,
      curve: M3EMotion.emphasized,
      width: 56,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? scheme.secondaryContainer : const Color(0x00000000),
        borderRadius: M3EShapes.resolve(16),
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: iconColor, size: 24),
        child: selected ? (dest.selectedIcon ?? dest.icon) : dest.icon,
      ),
    );
  }
}

/// Controls when navigation rail labels are shown.
enum M3ENavigationRailLabelType {
  none,
  selected,
  all,
}
