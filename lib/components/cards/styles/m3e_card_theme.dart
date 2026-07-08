import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../../foundations/m3e_theme_extension.dart';
import '../enums/m3e_card_variant.dart';

/// Theme values for [M3ECard].
@immutable
class M3ECardTheme extends M3EThemeExtension<M3ECardTheme> {
  const M3ECardTheme({
    this.contentPadding = const EdgeInsets.all(16),
  });

  static const M3ECardTheme defaults = M3ECardTheme();

  final EdgeInsets contentPadding;

  BorderRadius get borderRadius => M3EShapes.radiusMedium;

  Color backgroundColor(M3EColorScheme scheme, M3ECardVariant variant) {
    switch (variant) {
      case M3ECardVariant.elevated:
        return scheme.surfaceContainerLow;
      case M3ECardVariant.filled:
        return scheme.surfaceContainerHighest;
      case M3ECardVariant.outlined:
        return scheme.surface;
    }
  }

  Color outlineColor(M3EColorScheme scheme) => scheme.outlineVariant;

  double elevation(M3ECardVariant variant, {required bool hovered}) {
    if (variant != M3ECardVariant.elevated) {
      return M3EElevation.level0;
    }
    return hovered ? M3EElevation.level2 : M3EElevation.level1;
  }

  @override
  M3ECardTheme copyWith({EdgeInsets? contentPadding}) {
    return M3ECardTheme(
      contentPadding: contentPadding ?? this.contentPadding,
    );
  }

  @override
  M3ECardTheme lerp(M3ECardTheme? other, double t) {
    if (other is! M3ECardTheme) {
      return this;
    }
    return M3ECardTheme(
      contentPadding: EdgeInsets.lerp(contentPadding, other.contentPadding, t)!,
    );
  }
}
