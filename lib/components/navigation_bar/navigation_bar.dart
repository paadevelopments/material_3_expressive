import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../badges/badges.dart';
import 'models/m3e_navigation_destination.dart';

export 'models/m3e_navigation_destination.dart';

/// A Material 3 Expressive navigation bar.
///
/// A bottom bar for switching between 3-5 top-level [destinations] on compact
/// screens. The active pill indicator morphs behind the selected icon and the
/// label appears beneath.
class M3ENavigationBar extends StatelessWidget {
  const M3ENavigationBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    super.key,
  }) : assert(
          destinations.length >= 3 && destinations.length <= 5,
          'A navigation bar holds 3-5 destinations.',
        );

  final List<M3ENavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 80,
          child: Row(
            children: <Widget>[
              for (int i = 0; i < destinations.length; i++)
                Expanded(child: _buildDestination(context, i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDestination(BuildContext context, int index) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final selected = index == selectedIndex;
    final M3ENavigationDestination dest = destinations[index];

    return M3ETappable(
      onTap: () => onDestinationSelected(index),
      semanticLabel: dest.label,
      builder: (BuildContext context, M3EInteractionState state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildIndicator(scheme, dest, selected, state),
            const SizedBox(height: 4),
            Text(
              dest.label,
              style: theme.typeScale.labelMedium.copyWith(
                color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      },
    );
  }

  Widget _buildIndicator(
    M3EColorScheme scheme,
    M3ENavigationDestination dest,
    bool selected,
    M3EInteractionState state,
  ) {
    final Color iconColor =
        selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
    return AnimatedContainer(
      duration: M3EMotion.medium2,
      curve: M3EMotion.emphasized,
      width: 64,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? scheme.secondaryContainer : const Color(0x00000000),
        borderRadius: M3EShapes.resolve(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: M3EShapes.resolve(16),
                  color: scheme.onSurface.withValues(alpha: state.opacity),
                ),
              ),
            ),
          ),
          M3EBadge(
            visible: dest.showBadge || dest.badgeLabel != null,
            label: dest.badgeLabel,
            child: IconTheme.merge(
              data: IconThemeData(color: iconColor, size: 24),
              child: selected ? (dest.selectedIcon ?? dest.icon) : dest.icon,
            ),
          ),
        ],
      ),
    );
  }
}
