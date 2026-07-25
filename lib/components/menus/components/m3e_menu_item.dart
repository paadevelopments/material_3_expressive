import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/menus/m3e_menus.dart'
    show M3EMenu;
import 'package:material_3_expressive/material_3_expressive.dart' show M3EMenu;

import '../../../foundations/foundations.dart';
import '../enums/m3e_menu_item_shape.dart';
import 'm3e_menu_style_scope.dart';

/// A single interactive row inside an [M3EMenu] popup.
class M3EMenuItem extends StatelessWidget {
  /// M3EMenuItem.
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

  /// label.

  final String label;

  /// onTap.
  final VoidCallback? onTap;

  /// leading.
  final Widget? leading;

  /// trailing.
  final Widget? trailing;

  /// trailingText.
  final String? trailingText;

  /// badge.
  final Widget? badge;

  /// supportingText.
  final String? supportingText;

  /// enabled.
  final bool enabled;

  /// isDestructive.
  final bool isDestructive;

  /// selected.
  final bool selected;

  /// shape.
  final M3EMenuItemShape shape;

  /// autofocus.
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final menuTheme = theme.menuTheme;
    final scheme = theme.colorScheme;
    final style = M3EMenuStyleScope.styleOf(context);
    final palette =
        M3EMenuStyleScope.colorsOf(context) ?? menuTheme.colors(scheme, style);
    final iconForeground = menuTheme.entryIconForegroundColor(
      scheme,
      enabled: enabled,
      isDestructive: isDestructive,
      selected: selected,
      style: style,
    );
    final radius = menuTheme.itemShape(shape);
    final background = selected
        ? palette.selectedContainer
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
                palette.stateLayer.withValues(alpha: state.opacity),
                background,
              ),
              borderRadius: radius,
            ),
            child: Row(
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  IconTheme.merge(
                    data: IconThemeData(
                      color: iconForeground,
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
                          selected: selected,
                          style: style,
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
                            selected: selected,
                            style: style,
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
                      selected: selected,
                      style: style,
                    ),
                  ),
                ],
                if (trailing != null) ...<Widget>[
                  SizedBox(width: menuTheme.iconGap),
                  IconTheme.merge(
                    data: IconThemeData(
                      color: iconForeground,
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
