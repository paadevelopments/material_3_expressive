import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_badge_tokens.dart';

export 'styles/m3e_badge_tokens.dart';

/// A Material 3 Expressive badge.
///
/// Shows a small dot or a short count/label anchored to the top-end corner of
/// [child]. Omit [label] for the dot badge; provide it for a numeric badge.
class M3EBadge extends StatelessWidget {
  const M3EBadge({
    this.child,
    this.label,
    this.visible = true,
    this.alignment = M3EBadgeTokens.defaultAlignment,
    super.key,
  });

  final Widget? child;

  /// The count or short text. When null a small dot badge is shown.
  final String? label;

  final bool visible;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    final Widget marker = _buildMarker(context, scheme);
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

  Widget _buildMarker(BuildContext context, M3EColorScheme scheme) {
    if (label == null) {
      return Container(
        width: M3EBadgeTokens.dotSize,
        height: M3EBadgeTokens.dotSize,
        decoration: BoxDecoration(
          color: M3EBadgeTokens.containerColor(scheme),
          shape: BoxShape.circle,
        ),
      );
    }
    final typeScale = M3ETheme.of(context).typeScale;
    return Container(
      constraints: const BoxConstraints(minWidth: M3EBadgeTokens.largeSize),
      height: M3EBadgeTokens.largeSize,
      padding: const EdgeInsets.symmetric(
        horizontal: M3EBadgeTokens.largeHorizontalPadding,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: M3EBadgeTokens.containerColor(scheme),
        borderRadius: M3EShapes.resolve(M3EBadgeTokens.largeCornerRadius),
      ),
      child: Text(
        label!,
        style: M3EBadgeTokens.labelStyle(typeScale, scheme),
        maxLines: 1,
      ),
    );
  }
}
