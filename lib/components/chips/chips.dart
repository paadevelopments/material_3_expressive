import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_chip_type.dart';

export 'enums/m3e_chip_type.dart';

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

  static const double _height = 32;

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
    final borderRadius = M3EShapes.radiusSmall;
    final border = RoundedRectangleBorder(borderRadius: borderRadius);

    return M3ETappable(
      onTap: onPressed,
      enabled: onPressed != null,
      semanticLabel: label,
      builder: (BuildContext context, M3EInteractionState state) {
        return _buildSurface(theme, borderRadius, border, state);
      },
    );
  }

  Widget _buildSurface(
    M3EThemeData theme,
    BorderRadius borderRadius,
    RoundedRectangleBorder border,
    M3EInteractionState state,
  ) {
    final scheme = theme.colorScheme;
    final Color container = _container(scheme);
    final Color foreground = _foreground(scheme);
    final bool outlined = !selected && !elevated;

    return Container(
      height: _height,
      padding: EdgeInsets.only(left: leading == null ? 16 : 8, right: 12),
      decoration: BoxDecoration(
        color: container,
        borderRadius: borderRadius,
        border: outlined ? Border.all(color: scheme.outlineVariant) : null,
        boxShadow: elevated
            ? M3EElevation.shadows(M3EElevation.level1, shadowColor: scheme.shadow)
            : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          M3EStateLayerOverlay(
            state: state,
            color: foreground,
            shape: border,
          ),
          _buildContent(theme, foreground),
        ],
      ),
    );
  }

  Widget _buildContent(M3EThemeData theme, Color foreground) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (leading != null) ...<Widget>[
          IconTheme.merge(
            data: IconThemeData(color: foreground, size: 18),
            child: leading!,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: theme.typeScale.labelLarge.copyWith(color: foreground),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (onDeleted != null) ...<Widget>[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onDeleted,
            child: Icon(M3EIcons.close, size: 18, color: foreground),
          ),
        ],
      ],
    );
  }

  Color _container(M3EColorScheme scheme) {
    if (!_enabled) {
      return selected
          ? M3EColorUtils.withOpacity(scheme.onSurface, 0.12)
          : const Color(0x00000000);
    }
    if (selected) {
      return scheme.secondaryContainer;
    }
    if (elevated) {
      return scheme.surfaceContainerLow;
    }
    return const Color(0x00000000);
  }

  Color _foreground(M3EColorScheme scheme) {
    if (!_enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
  }
}
