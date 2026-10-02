import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Primary banner floating over a narrow preview; opens the controls.
class PreviewControlsBanner extends StatelessWidget {
  /// Creates the controls banner.
  const PreviewControlsBanner({required this.onPressed, super.key});

  /// Space the banner takes from the top of the body, margins included.
  static const double extent = _margin + _height + 16;

  static const double _margin = 8;
  static const double _height = 48;

  /// Opens the controls.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EColorScheme scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, _margin, 16, 0),
      child: M3ECard(
        variant: M3ECardVariant.filled,
        color: scheme.primary,
        onPressed: onPressed,
        semanticLabel: 'Show controls',
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: _height,
          child: Row(
            children: <Widget>[
              Icon(M3EIcons.tune, color: scheme.onPrimary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tap for controls',
                  style: theme.typeScale.labelLarge.copyWith(
                    color: scheme.onPrimary,
                  ),
                ),
              ),
              Icon(M3EIcons.keyboard_arrow_up, color: scheme.onPrimary),
            ],
          ),
        ),
      ),
    );
  }
}
