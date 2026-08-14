import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_badge_layout.dart';
import 'enums/m3e_badge_alignment.dart';
import 'styles/m3e_badge_theme.dart';

export 'enums/m3e_badge_alignment.dart';
export 'styles/m3e_badge_theme.dart';

/// A Material 3 Expressive badge.
///
/// Shows a small dot or a numeric count anchored to a top edge of [child].
///
/// [alignment] places the indicator at the top-left, top-center, or top-right
/// of [child]'s own box, and [offset] nudges it away from that edge. The badge
/// sizes itself to cover both, so a parent never has to reserve room.
/// Set [showDot] for a dot badge, or provide [count] for a numeric badge.
class M3EBadge extends StatelessWidget {
  /// M3EBadge.
  const M3EBadge({
    super.key,
    required this.child,
    this.count,
    this.showDot = false,
    this.maxCount = 99,
    this.alignment = M3EBadgeAlignment.topRight,
    this.offset,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticLabel,
  }) : assert(count == null || count >= 0, 'count must be non-negative');

  /// child.

  final Widget child;

  /// count.
  final int? count;

  /// showDot.
  final bool showDot;

  /// maxCount.
  final int maxCount;

  /// Top-edge placement of the indicator. Defaults to [M3EBadgeAlignment.topRight].
  final M3EBadgeAlignment alignment;

  /// Nudge away from the anchored edge. `dx` is ignored when centered.
  final Offset? offset;

  /// backgroundColor.
  final Color? backgroundColor;

  /// foregroundColor.
  final Color? foregroundColor;

  /// semanticLabel.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    if (!showDot && count == null) {
      return child;
    }

    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final badgeTheme = theme.badgeTheme;
    final effectiveOffset = offset ?? badgeTheme.defaultOffset;
    final bg = backgroundColor ?? badgeTheme.containerColor(scheme);
    final fg = foregroundColor ?? badgeTheme.labelColor(scheme);

    final Widget badge = showDot
        ? _dot(badgeTheme, bg)
        : _label(
            theme.typeScale,
            badgeTheme,
            scheme,
            bg,
            fg,
            _format(count!, maxCount),
          );

    return M3EComponentTheme(
      builder: (context) => M3EBadgeLayout(
        alignment: alignment,
        offset: effectiveOffset,
        content: child,
        indicator: Semantics(
          label:
              semanticLabel ??
              (count != null ? 'Notifications: $count' : 'Notifications'),
          child: badge,
        ),
      ),
    );
  }

  Widget _dot(M3EBadgeTheme badgeTheme, Color bg) {
    return Container(
      width: badgeTheme.dotSize,
      height: badgeTheme.dotSize,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
    );
  }

  Widget _label(
    M3ETypeScale typeScale,
    M3EBadgeTheme badgeTheme,
    M3EColorScheme scheme,
    Color bg,
    Color fg,
    String text,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: badgeTheme.labelHorizontalPadding,
        vertical: badgeTheme.labelVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: badgeTheme.labelBorderRadius,
      ),
      constraints: BoxConstraints(
        minWidth: badgeTheme.labelMinSize,
        minHeight: badgeTheme.labelMinSize,
      ),
      child: DefaultTextStyle(
        style: badgeTheme.labelStyle(typeScale, scheme).copyWith(color: fg),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  String _format(int value, int max) => value > max ? '$max+' : '$value';
}
