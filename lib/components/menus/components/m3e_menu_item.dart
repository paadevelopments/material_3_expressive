import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_menu_item_shape.dart';

/// A single interactive row inside an [M3EMenu] popup.
class M3EMenuItem extends StatelessWidget {
  const M3EMenuItem({
    required this.label,
    required this.onTap,
    this.leading,
    this.trailing,
    this.trailingText,
    this.badge,
    this.supportingText,
    this.enabled = true,
    this.isDestructive = false,
    this.selected = false,
    this.shape = M3EMenuItemShape.standalone,
    this.autofocus = false,
    super.key,
  });

  final String label;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget? trailing;
  final String? trailingText;
  final Widget? badge;
  final String? supportingText;
  final bool enabled;
  final bool isDestructive;
  final bool selected;
  final M3EMenuItemShape shape;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final menuTheme = theme.menuTheme;
    final scheme = theme.colorScheme;
    final foreground = menuTheme.entryForegroundColor(
      scheme,
      enabled: enabled,
      isDestructive: isDestructive,
    );
    final radius = menuTheme.itemShape(shape);
    final background = selected
        ? menuTheme.selectedContainerColor(scheme)
        : const Color(0x00000000);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: menuTheme.itemGap / 2),
      child: M3ETappable(
        enabled: enabled,
        onTap: onTap,
        autofocus: autofocus && enabled,
        semanticLabel: label,
        builder: (BuildContext context, M3EInteractionState state) {
          return Container(
            constraints: BoxConstraints(minHeight: menuTheme.entryHeight),
            padding: EdgeInsets.symmetric(
              horizontal: menuTheme.entryHorizontalPadding,
              vertical: supportingText == null ? 0 : 8,
            ),
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                scheme.onSurface.withValues(alpha: state.opacity),
                background,
              ),
              borderRadius: radius,
            ),
            child: Row(
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  IconTheme.merge(
                    data: IconThemeData(
                      color: foreground,
                      size: menuTheme.iconSize,
                    ),
                    child: leading!,
                  ),
                  SizedBox(width: menuTheme.iconGap),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        label,
                        style: menuTheme.entryLabelStyle(
                          theme.typeScale,
                          scheme,
                          enabled: enabled,
                          isDestructive: isDestructive,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (supportingText != null)
                        Text(
                          supportingText!,
                          style: menuTheme.supportingTextStyle(
                            theme.typeScale,
                            scheme,
                            enabled: enabled,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (badge != null) ...<Widget>[
                  SizedBox(width: menuTheme.iconGap),
                  badge!,
                ],
                if (trailingText != null) ...<Widget>[
                  SizedBox(width: menuTheme.iconGap),
                  Text(
                    trailingText!,
                    style: menuTheme.trailingTextStyle(
                      theme.typeScale,
                      scheme,
                      enabled: enabled,
                    ),
                  ),
                ],
                if (trailing != null) ...<Widget>[
                  SizedBox(width: menuTheme.iconGap),
                  IconTheme.merge(
                    data: IconThemeData(
                      color: foreground,
                      size: menuTheme.iconSize,
                    ),
                    child: trailing!,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
