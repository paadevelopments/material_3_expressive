import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_split_button_variant.dart';

export 'enums/m3e_split_button_variant.dart';

const String _moreOptionsSemanticLabel = 'More options';

/// A Material 3 Expressive split button.
///
/// Combines a primary labelled action on the leading side with a trailing icon
/// button that reveals more options. The trailing chevron rotates and its inner
/// corners morph while [expanded] to signal the open menu.
class M3ESplitButton extends StatelessWidget {
  const M3ESplitButton({
    required this.label,
    this.leadingIcon,
    this.onPressed,
    this.onMenuPressed,
    this.expanded = false,
    this.variant = M3ESplitButtonVariant.filled,
    super.key,
  });

  static const double _height = 56;
  static const double _gap = 2;

  final String label;
  final Widget? leadingIcon;
  final VoidCallback? onPressed;
  final VoidCallback? onMenuPressed;
  final bool expanded;
  final M3ESplitButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final _SplitPalette palette = _resolvePalette(theme.colorScheme);
    final double innerRadius = expanded ? _height / 2 : M3EShapes.small;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildLeading(theme, palette, innerRadius),
        const SizedBox(width: _gap),
        _buildTrailing(palette, innerRadius),
      ],
    );
  }

  Widget _buildLeading(
    M3EThemeData theme,
    _SplitPalette palette,
    double innerRadius,
  ) {
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(_height / 2),
      bottomLeft: const Radius.circular(_height / 2),
      topRight: Radius.circular(innerRadius),
      bottomRight: Radius.circular(innerRadius),
    );
    return M3ETappable(
      onTap: onPressed,
      enabled: onPressed != null,
      semanticLabel: label,
      builder: (BuildContext context, M3EInteractionState state) {
        return _surface(
          palette: palette,
          radius: radius,
          state: state,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildLeadingContent(theme, palette),
        );
      },
    );
  }

  Widget _buildLeadingContent(M3EThemeData theme, _SplitPalette palette) {
    final Widget text = Text(
      label,
      style: theme.typeScale.titleMedium.copyWith(color: palette.foreground),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    if (leadingIcon == null) {
      return text;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconTheme.merge(
          data: IconThemeData(color: palette.foreground, size: 24),
          child: leadingIcon!,
        ),
        const SizedBox(width: 8),
        text,
      ],
    );
  }

  Widget _buildTrailing(_SplitPalette palette, double innerRadius) {
    final radius = BorderRadius.only(
      topLeft: Radius.circular(innerRadius),
      bottomLeft: Radius.circular(innerRadius),
      topRight: const Radius.circular(_height / 2),
      bottomRight: const Radius.circular(_height / 2),
    );
    return M3ETappable(
      onTap: onMenuPressed,
      enabled: onMenuPressed != null,
      semanticLabel: _moreOptionsSemanticLabel,
      builder: (BuildContext context, M3EInteractionState state) {
        return _surface(
          palette: palette,
          radius: radius,
          state: state,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: AnimatedRotation(
            turns: expanded ? 0.5 : 0,
            duration: M3EMotion.short4,
            curve: M3EMotion.emphasized,
            child: Icon(
              M3EIcons.arrowDropDown,
              color: palette.foreground,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _surface({
    required _SplitPalette palette,
    required BorderRadius radius,
    required M3EInteractionState state,
    required EdgeInsets padding,
    required Widget child,
  }) {
    return AnimatedContainer(
      duration: M3EMotion.short4,
      curve: M3EMotion.emphasized,
      height: _height,
      padding: padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: radius,
        border: palette.outline == null
            ? null
            : Border.all(color: palette.outline!),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          M3EStateLayerOverlay(
            state: state,
            color: palette.foreground,
            shape: RoundedRectangleBorder(borderRadius: radius),
          ),
          child,
        ],
      ),
    );
  }

  _SplitPalette _resolvePalette(M3EColorScheme scheme) {
    switch (variant) {
      case M3ESplitButtonVariant.filled:
        return _SplitPalette(scheme.primary, scheme.onPrimary, null);
      case M3ESplitButtonVariant.tonal:
        return _SplitPalette(
          scheme.secondaryContainer,
          scheme.onSecondaryContainer,
          null,
        );
      case M3ESplitButtonVariant.outlined:
        return _SplitPalette(
          const Color(0x00000000),
          scheme.primary,
          scheme.outlineVariant,
        );
    }
  }
}

@immutable
class _SplitPalette {
  const _SplitPalette(this.background, this.foreground, this.outline);

  final Color background;
  final Color foreground;
  final Color? outline;
}
