import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_list_item_tokens.dart';

export 'styles/m3e_list_item_tokens.dart';

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
                  ? M3EListItemTokens.selectedColor(scheme)
                  : scheme.onSurface.withValues(alpha: state.opacity),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: M3EListItemTokens.horizontalPadding,
            vertical: threeLine
                ? M3EListItemTokens.threeLineVerticalPadding
                : M3EListItemTokens.verticalPadding,
          ),
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(minHeight: M3EListItemTokens.minHeight),
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
          data: IconThemeData(
            color: M3EListItemTokens.iconColor(scheme),
            size: M3EListItemTokens.iconSize,
          ),
          child: leading!,
        ),
        const SizedBox(width: M3EListItemTokens.gap),
      ],
      Expanded(child: _buildText(theme)),
      if (trailing != null) ...<Widget>[
        const SizedBox(width: M3EListItemTokens.gap),
        IconTheme.merge(
          data: IconThemeData(
            color: M3EListItemTokens.iconColor(scheme),
            size: M3EListItemTokens.iconSize,
          ),
          child: trailing!,
        ),
      ],
    ];
  }

  Widget _buildText(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    final type = theme.typeScale;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (overline != null)
          Text(
            overline!,
            style: M3EListItemTokens.overlineStyle(type, scheme),
          ),
        Text(
          headline,
          style: M3EListItemTokens.headlineStyle(type, scheme),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (supportingText != null)
          Text(
            supportingText!,
            style: M3EListItemTokens.supportingStyle(type, scheme),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    );
  }

  bool get _isThreeLine => supportingText != null && overline != null;
}
