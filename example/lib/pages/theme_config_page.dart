import 'package:flutter/material.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../theme/example_theme_scope.dart';
import '../theme/example_theme_settings.dart';

/// Screen for switching auto theming, dynamic color and the seed color.
///
/// Every change is applied to the running app immediately.
class ThemeConfigPage extends StatelessWidget {
  /// Creates the theme config screen.
  const ThemeConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final ExampleThemeSettings settings = ExampleThemeScope.of(context);

    return Scaffold(
      body: ColoredBox(
        color: theme.colorScheme.surface,
        child: Column(
          children: <Widget>[
            M3EAppBar.top(
              titleText: 'Theme',
              leading: M3EIconButton(
                icon: const Icon(M3EIcons.arrow_back),
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: <Widget>[
                  _toggles(theme, settings),
                  const SizedBox(height: 24),
                  _seeds(theme, settings),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _toggles(M3EThemeData theme, ExampleThemeSettings settings) {
    final List<Widget> rows = <Widget>[
      M3EListItem(
        headline: 'Auto theming',
        supportingText: 'Follow the platform light and dark setting',
        trailing: M3ESwitch(
          value: settings.autoTheming,
          semanticLabel: 'Auto theming',
          onChanged: (bool value) => settings.autoTheming = value,
        ),
      ),
      M3EListItem(
        headline: 'Dynamic color',
        supportingText:
            'Use the device wallpaper palette where the platform supports it',
        trailing: M3ESwitch(
          value: settings.dynamicColoring,
          semanticLabel: 'Dynamic color',
          onChanged: (bool value) => settings.dynamicColoring = value,
        ),
      ),
    ];

    return M3ECardList(
      itemCount: rows.length,
      itemBuilder: (BuildContext context, int index) => rows[index],
    );
  }

  Widget _seeds(M3EThemeData theme, ExampleThemeSettings settings) {
    final M3EColorScheme scheme = theme.colorScheme;
    final bool enabled = !settings.dynamicColoring;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Seed color',
          style: theme.typeScale.titleMedium.copyWith(color: scheme.onSurface),
        ),
        const SizedBox(height: 4),
        Text(
          enabled
              ? 'Generates the scheme for both brightnesses.'
              : 'Turn dynamic color off to pick a seed.',
          style: theme.typeScale.bodyMedium.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: <Widget>[
            for (int i = 0; i < ExampleThemeSettings.seedOptions.length; i++)
              _SeedSwatch(
                color: ExampleThemeSettings.seedOptions[i],
                label: ExampleThemeSettings.seedLabels[i],
                selected:
                    enabled &&
                    settings.seedColor == ExampleThemeSettings.seedOptions[i],
                onTap: enabled
                    ? () => settings.seedColor =
                          ExampleThemeSettings.seedOptions[i]
                    : null,
              ),
          ],
        ),
      ],
    );
  }
}

/// One seed choice: a filled circle with its label underneath.
class _SeedSwatch extends StatelessWidget {
  const _SeedSwatch({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  static const double _size = 56;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EColorScheme scheme = theme.colorScheme;
    final Color tick =
        ThemeData.estimateBrightnessForColor(color) == Brightness.dark
        ? const Color(0xFFFFFFFF)
        : const Color(0xFF000000);

    return M3ETappable(
      onTap: onTap,
      enabled: onTap != null,
      semanticLabel: '$label seed',
      pressedScale: 0.94,
      haptic: M3EHapticFeedback.light,
      builder: (BuildContext context, M3EInteractionState state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AnimatedContainer(
              duration: M3EMotion.short3,
              curve: M3EMotion.standard,
              width: _size,
              height: _size,
              decoration: BoxDecoration(
                color: onTap == null ? color.withValues(alpha: 0.38) : color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? scheme.onSurface : scheme.outlineVariant,
                  width: selected ? 3 : 1,
                ),
              ),
              child: selected
                  ? Icon(M3EIcons.check, size: 24, color: tick)
                  : null,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: theme.typeScale.labelMedium.copyWith(
                color: selected ? scheme.onSurface : scheme.onSurfaceVariant,
              ),
            ),
          ],
        );
      },
    );
  }
}
