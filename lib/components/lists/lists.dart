import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

/// A Material 3 Expressive list item.
///
/// A single row of a list with optional leading and trailing widgets, a
/// headline and up to three lines of supporting text. Becomes interactive with
/// state layers when [onTap] is supplied.
class M3EListItem extends StatelessWidget {
  const M3EListItem({
    required this.headline,
    this.supportingText,
    this.overline,
    this.leading,
    this.trailing,
    this.onTap,
    this.selected = false,
    super.key,
  });

  final String headline;
  final String? supportingText;
  final String? overline;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    if (onTap == null) {
      return _buildRow(theme, const M3EInteractionState());
    }
    return M3ETappable(
      onTap: onTap,
      semanticButton: false,
      semanticLabel: headline,
      builder: (BuildContext context, M3EInteractionState state) {
        return _buildRow(theme, state);
      },
    );
  }

  Widget _buildRow(M3EThemeData theme, M3EInteractionState state) {
    final scheme = theme.colorScheme;
    final bool threeLine = _isThreeLine;
    final CrossAxisAlignment alignment =
        threeLine ? CrossAxisAlignment.start : CrossAxisAlignment.center;

    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: IgnorePointer(
            child: ColoredBox(
              color: selected
                  ? scheme.secondaryContainer
                  : scheme.onSurface.withValues(alpha: state.opacity),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: threeLine ? 12 : 8,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 40),
            child: Row(
              crossAxisAlignment: alignment,
              children: _buildChildren(theme),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildChildren(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return <Widget>[
      if (leading != null) ...<Widget>[
        IconTheme.merge(
          data: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
          child: leading!,
        ),
        const SizedBox(width: 16),
      ],
      Expanded(child: _buildText(theme)),
      if (trailing != null) ...<Widget>[
        const SizedBox(width: 16),
        IconTheme.merge(
          data: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
          child: trailing!,
        ),
      ],
    ];
  }

  Widget _buildText(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (overline != null)
          Text(
            overline!,
            style: theme.typeScale.labelSmall
                .copyWith(color: scheme.onSurfaceVariant),
          ),
        Text(
          headline,
          style: theme.typeScale.bodyLarge.copyWith(color: scheme.onSurface),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (supportingText != null)
          Text(
            supportingText!,
            style: theme.typeScale.bodyMedium
                .copyWith(color: scheme.onSurfaceVariant),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  bool get _isThreeLine =>
      supportingText != null && overline != null;
}
