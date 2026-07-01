import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

/// A Material 3 Expressive badge.
///
/// Shows a small dot or a short count/label anchored to the top-end corner of
/// [child]. Omit [label] for the 6dp dot badge; provide it for a numeric badge.
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
        width: 6,
        height: 6,
        decoration: BoxDecoration(color: scheme.error, shape: BoxShape.circle),
      );
    }
    final typeScale = M3ETheme.of(context).typeScale;
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: scheme.error,
        borderRadius: M3EShapes.resolve(8),
      ),
      child: Text(
        label!,
        style: typeScale.labelSmall.copyWith(color: scheme.onError),
        maxLines: 1,
      ),
    );
  }
}
