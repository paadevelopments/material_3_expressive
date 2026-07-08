import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

export 'styles/m3e_badge_theme.dart';

/// A Material 3 Expressive badge.
///
/// Shows a small dot or a short count/label anchored to the top-end corner of
/// [child]. Omit [label] for the dot badge; provide it for a numeric badge.
class M3EBadge extends StatelessWidget {
  const M3EBadge({
    this.child,
    this.label,
    this.visible = true,
    this.alignment = const Alignment(0.75, -0.75),
    super.key,
  });

  final Widget? child;

  /// The count or short text. When null a small dot badge is shown.
  final String? label;

  final bool visible;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final Widget marker = _buildMarker(theme, scheme);
    if (child == null) {
      return visible ? marker : const SizedBox.shrink();
    }
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        child!,
        if (visible)
          Align(alignment: alignment, child: marker),
      ],
    );
  }

  Widget _buildMarker(M3EThemeData theme, M3EColorScheme scheme) {
    final badgeTheme = theme.badgeTheme;
    if (label == null) {
      return Container(
        width: badgeTheme.dotSize,
        height: badgeTheme.dotSize,
        decoration: BoxDecoration(
          color: badgeTheme.containerColor(scheme),
          shape: BoxShape.circle,
        ),
      );
    }
    return Container(
      constraints: BoxConstraints(minWidth: badgeTheme.largeSize),
      height: badgeTheme.largeSize,
      padding: EdgeInsets.symmetric(
        horizontal: badgeTheme.largeHorizontalPadding,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: badgeTheme.containerColor(scheme),
        borderRadius: badgeTheme.largeBorderRadius,
      ),
      child: Text(
        label!,
        style: badgeTheme.labelStyle(theme.typeScale, scheme),
        maxLines: 1,
      ),
    );
  }
}
