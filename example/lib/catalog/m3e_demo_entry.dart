import 'package:flutter/widgets.dart';

import 'm3e_demo_section.dart';

/// One component row in a section list and its playground builder.
@immutable
class M3EDemoEntry {
  /// Creates a catalog entry.
  const M3EDemoEntry({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.section,
    required this.playgroundBuilder,
  });

  /// Stable id (route / selection key).
  final String id;

  /// List headline.
  final String title;

  /// List supporting text.
  final String subtitle;

  /// Leading icon.
  final IconData icon;

  /// Parent gallery section.
  final M3EDemoSection section;

  /// Builds the playground body (no chrome).
  final WidgetBuilder playgroundBuilder;
}
