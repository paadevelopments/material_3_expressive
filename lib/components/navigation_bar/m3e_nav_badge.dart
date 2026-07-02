// Vendored from the `navigation_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e/lib).
// The logic is kept identical to the reference `NavBadgeM3E`; only the public
// class name carries the `M3E` prefix and theme tokens are read from this
// package's own `M3ETheme` instead of the external `m3e_design` package.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

import '../../foundations/foundations.dart';

class M3ENavBadge extends StatelessWidget {
  const M3ENavBadge({
    super.key,
    required this.child,
    this.count,
    this.showDot = false,
    this.maxCount = 99,
    this.backgroundColor,
    this.foregroundColor,
    this.semanticLabel,
    this.offset = const Offset(8, -6),
  }) : assert(count == null || count >= 0);

  final Widget child;
  final int? count;
  final bool showDot;
  final int maxCount;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final String? semanticLabel;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final m3e = M3ETheme.of(context);
    final bg = backgroundColor ?? m3e.colorScheme.errorContainer;
    final fg = foregroundColor ?? m3e.colorScheme.onErrorContainer;

    final badge = showDot
        ? _dot(bg)
        : _label(bg, fg, count == null ? '' : _format(count!, maxCount));

    final stack = Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: offset.dx,
          top: offset.dy,
          child: Semantics(
            label: semanticLabel ??
                (count != null ? 'Notifications: ${count!}' : 'Notifications'),
            child: badge,
          ),
        ),
      ],
    );

    return stack;
  }

  Widget _dot(Color bg) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
    );
  }

  Widget _label(Color bg, Color fg, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        child:
            Text(text, textAlign: TextAlign.center, style: TextStyle(color: fg)),
      ),
    );
  }

  String _format(int c, int max) => (c > max) ? '$max+' : '$c';
}
