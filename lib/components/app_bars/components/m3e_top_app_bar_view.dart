// Vendored verbatim from the `app_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/blob/main/packages/app_bar_m3e/lib/src/app_bar_m3e_widget.dart).
// The logic is kept identical to the reference `AppBarM3E`; only the public
// class name carries the `M3E` prefix and theme tokens are read from this
// package's own `M3ETheme` instead of the external `m3e_design` package.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_app_bar_enums.dart';
import 'm3e_app_bar_tokens.dart';

class M3ETopAppBar extends StatelessWidget implements PreferredSizeWidget {
  const M3ETopAppBar({
    super.key,
    this.leading,
    this.title,
    this.titleText,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.shapeFamily = M3EAppBarShapeFamily.round,
    this.density = M3EAppBarDensity.regular,
    this.toolbarHeight,
    this.automaticallyImplyLeading = true,
    this.clipBehavior = Clip.none,
    this.semanticLabel,
  });

  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final bool centerTitle;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final M3EAppBarShapeFamily shapeFamily;
  final M3EAppBarDensity density;
  final double? toolbarHeight;
  final bool automaticallyImplyLeading;
  final Clip clipBehavior;
  final String? semanticLabel;

  @override
  Size get preferredSize {
    // Provide a reasonable non-null size; actual height applied in build.
    return Size.fromHeight(toolbarHeight ?? 64);
  }

  @override
  Widget build(BuildContext context) {
    final metrics = appBarMetricsFor(context, density);
    final bg = backgroundColor ?? appBarBackgroundFor(context);
    final fg = foregroundColor ?? M3ETheme.of(context).colorScheme.onSurface;
    final shape = appBarShapeFor(context, shapeFamily);
    final height = toolbarHeight ?? metrics.smallHeight;
    final tStyle = appBarTitleStyleFor(context, collapsed: true);

    final resolvedLeading = leading ?? (automaticallyImplyLeading
        ? _maybeBackButton(context, fg)
        : null);

    final resolvedTitle = title ??
        (titleText != null
            ? Text(titleText!, style: tStyle, overflow: TextOverflow.ellipsis)
            : null);

    final bar = Material(
      color: bg,
      elevation: elevation ?? metrics.elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: metrics.horizontalPadding,
            child: IconTheme.merge(
              data: IconThemeData(size: metrics.iconSize, color: fg),
              child: DefaultTextStyle(
                style: tStyle.copyWith(color: fg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (resolvedLeading != null) resolvedLeading,
                    if (resolvedLeading != null) const SizedBox(width: 8),
                    if (resolvedTitle != null)
                      Expanded(
                        child: Align(
                          alignment: centerTitle ? Alignment.center : Alignment.centerLeft,
                          child: resolvedTitle,
                        ),
                      )
                    else
                      const Spacer(),
                    if (actions != null) ...[
                      const SizedBox(width: 8),
                      ..._withSpacers(actions!),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    if (semanticLabel == null) return bar;
    return Semantics(
      container: true,
      label: semanticLabel,
      child: bar,
    );
  }

  List<Widget> _withSpacers(List<Widget> items) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      out.add(items[i]);
      if (i < items.length - 1) out.add(const SizedBox(width: 4));
    }
    return out;
  }

  Widget? _maybeBackButton(BuildContext context, Color fg) {
    final canPop = Navigator.maybeOf(context)?.canPop() ?? false;
    if (!canPop) return null;
    return IconButton(
      icon: const BackButtonIcon(),
      color: fg,
      onPressed: () => Navigator.maybeOf(context)?.maybePop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }
}
