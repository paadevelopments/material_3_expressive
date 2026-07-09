import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'enums/m3e_chip_type.dart';
import 'styles/m3e_chip_theme.dart';

export 'enums/m3e_chip_type.dart';
export 'styles/m3e_chip_theme.dart';

/// A Material 3 Expressive chip.
///
/// A compact element for entering information, making selections, filtering or
/// triggering actions. Filter and input chips can be selected; input chips can
/// expose a trailing delete affordance.
class M3EChip extends StatelessWidget {
  const M3EChip({
    required this.label,
    this.type = M3EChipType.assist,
    this.leading,
    this.selected = false,
    this.elevated = false,
    this.onPressed,
    this.onDeleted,
    super.key,
  });

  final String label;
  final M3EChipType type;
  final Widget? leading;
  final bool selected;
  final bool elevated;
  final VoidCallback? onPressed;
  final VoidCallback? onDeleted;

  bool get _enabled => onPressed != null || onDeleted != null;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final chipTheme = theme.chipTheme;
    final borderRadius = chipTheme.borderRadius;
    final border = chipTheme.shape as RoundedRectangleBorder;

    return M3ETappable(
      onTap: onPressed,
      enabled: onPressed != null,
      semanticLabel: label,
      materialInk: true,
      builder: (BuildContext context, M3EInteractionState state) {
        return _buildSurface(theme, chipTheme, borderRadius, border, state);
      },
    );
  }

  Widget _buildSurface(
    M3EThemeData theme,
    M3EChipTheme chipTheme,
    BorderRadius borderRadius,
    RoundedRectangleBorder border,
    M3EInteractionState state,
  ) {
    final scheme = theme.colorScheme;
    final Color container = chipTheme.containerColor(
      scheme,
      enabled: _enabled,
      selected: selected,
      elevated: elevated,
      type: type,
    );
    final Color foreground = chipTheme.foregroundColor(
      scheme,
      enabled: _enabled,
      selected: selected,
    );
    final bool outlined = !selected && !elevated;

    return Container(
      height: chipTheme.height,
      decoration: BoxDecoration(
        color: container,
        borderRadius: borderRadius,
        border: outlined ? Border.all(color: scheme.outlineVariant) : null,
        boxShadow: elevated
            ? M3EElevation.shadows(M3EElevation.level1, shadowColor: scheme.shadow)
            : null,
      ),
      child: M3EStateLayerOverlay(
        state: state,
        color: foreground,
        shape: border,
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.only(
            left: leading == null
                ? chipTheme.labelStartPadding
                : chipTheme.iconStartPadding,
            right: chipTheme.endPadding,
          ),
          child: _buildContent(theme, chipTheme, foreground),
        ),
      ),
    );
  }

  Widget _buildContent(
    M3EThemeData theme,
    M3EChipTheme chipTheme,
    Color foreground,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (leading != null) ...<Widget>[
          IconTheme.merge(
            data: IconThemeData(color: foreground, size: chipTheme.iconSize),
            child: leading!,
          ),
          SizedBox(width: chipTheme.iconLabelGap),
        ],
        Text(
          label,
          style: theme.typeScale.labelLarge.copyWith(color: foreground),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (onDeleted != null) ...<Widget>[
          SizedBox(width: chipTheme.iconLabelGap),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(
              M3EIcons.close,
              size: chipTheme.iconSize,
              color: foreground,
            ),
          ),
        ],
      ],
    );
  }
}
