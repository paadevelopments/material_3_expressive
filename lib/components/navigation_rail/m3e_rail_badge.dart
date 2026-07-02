// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `RailBadgeM3E`; only the public
// class name carries the `M3E` prefix.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

import 'style/m3e_navigation_rail_tokens_adapter.dart';

/// Large numeric badgeValue for rail items (0..999+). One class per file.
class M3ERailBadge extends StatelessWidget {
  /// Creates a large numeric badgeValue.
  const M3ERailBadge({
    super.key,
    this.count,
    this.maxDigits = 3,
    this.dense = false,
  });

  /// The numeric value to display in the badgeValue.
  final int? count;

  /// Maximum digits before showing a trailing '+' (e.g. 999+).
  final int maxDigits;

  /// Whether to use a denser (smaller padding) variant.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    if (count == null) {
      return const SizedBox.shrink();
    }
    final tokens = M3ENavigationRailTokensAdapter(context);
    final String text = count! > (10 * (pow10(maxDigits) - 1))
        ? '${pow10(maxDigits) - 1}+'
        : '$count';
    final double pad = dense ? 2 : 4;
    return count == 0
        ? Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: tokens.badgeBackground,
              shape: BoxShape.circle,
            ),
          )
        : Container(
            padding: EdgeInsets.symmetric(horizontal: pad + 2, vertical: pad),
            decoration: BoxDecoration(
              color: tokens.badgeBackground,
              borderRadius: BorderRadius.circular(999),
            ),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                color: tokens.badgeLargeLabel,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              child: Text(text, maxLines: 1),
            ),
          );
  }

  /// Returns 10 to the power of [n].
  static int pow10(int n) {
    var v = 1;
    for (var i = 0; i < n; i++) {
      v *= 10;
    }
    return v;
  }
}
