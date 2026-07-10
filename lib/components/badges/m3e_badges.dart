import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_badge_theme.dart';

export 'styles/m3e_badge_theme.dart';

/// A Material 3 Expressive badge.
///
/// Shows a small dot or a numeric count anchored to the top-end corner of
/// [child]. Set [showDot] for a dot badge, or provide [count] for a numeric
/// badge.
class M3EBadge extends StatelessWidget {
  const M3EBadge({
    super.key,
    required this.child,
    this.count,
    this.showDot = false,
    this.maxCount = 99,
    this.offset,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticLabel,
  }) : assert(count == null || count >= 0);

  final Widget child;
  final int? count;
  final bool showDot;
  final int maxCount;
  final Offset? offset;
  final Color? backgroundColor;
  final Color? foregroundColor;
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
            badgeTheme,
            scheme,
            bg,
            fg,
            _format(count!, maxCount),
          );

    return M3EComponentTheme(builder: (context) => Stack(
        clipBehavior: Clip.none,
        children: <Widget>[
          child,
          Positioned(
            right: effectiveOffset.dx,
            top: effectiveOffset.dy,
            child: Semantics(
              label: semanticLabel ??
                  (count != null ? 'Notifications: $count' : 'Notifications'),
              child: badge,
            ),
          ),
        ],
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
        style: badgeTheme.labelStyle(scheme).copyWith(color: fg),
        child: Text(text, textAlign: TextAlign.center),
      ),
    );
  }

  String _format(int value, int max) => value > max ? '$max+' : '$value';
}
