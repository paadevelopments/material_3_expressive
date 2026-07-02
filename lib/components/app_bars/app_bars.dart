import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/app_bars/styles/m3e_app_bar_tokens.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_app_bar_enums.dart';

export 'components/m3e_sliver_app_bar_view.dart';
export 'enums/m3e_app_bar_enums.dart';

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

/// A Material 3 Expressive bottom app bar.
///
/// Hosts a row of primary actions with an optional trailing floating action
/// button, anchored to the bottom of the screen.
class M3EBottomAppBar extends StatelessWidget {
  const M3EBottomAppBar({
    this.actions = const <Widget>[],
    this.floatingActionButton,
    super.key,
  });

  final List<Widget> actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    return Container(
      height: 80,
      color: scheme.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            IconTheme.merge(
              data: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
              child: Row(mainAxisSize: MainAxisSize.min, children: actions),
            ),
            const Spacer(),
            ?floatingActionButton,
          ],
        ),
      ),
    );
  }
}
