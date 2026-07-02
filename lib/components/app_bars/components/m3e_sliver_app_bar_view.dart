// Vendored verbatim from the `app_bar_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/blob/main/packages/app_bar_m3e/lib/src/sliver_app_bar_m3e.dart).
// The logic is kept identical to the reference `SliverAppBarM3E`; only the
// public class names carry the `M3E` prefix and theme tokens are read from this
// package's own `M3ETheme` instead of the external `m3e_design` package.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderObject, RenderProxySliver;
import 'package:flutter/semantics.dart' show SemanticsConfiguration;

import '../../../foundations/foundations.dart';
import '../enums/m3e_app_bar_enums.dart';
import '../styles/m3e_app_bar_tokens.dart';

class M3ESliverAppBar extends StatelessWidget {
  const M3ESliverAppBar({
    super.key,
    this.leading,
    this.title,
    this.titleText,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
    this.foregroundColor,
    this.pinned = true,
    this.floating = false,
    this.snap = false,
    this.shapeFamily = M3EAppBarShapeFamily.round,
    this.density = M3EAppBarDensity.regular,
    this.variant = M3EAppBarVariant.medium,
    this.semanticLabel,
  });

  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final List<Widget>? actions;
  final bool centerTitle;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool pinned;
  final bool floating;
  final bool snap;
  final M3EAppBarShapeFamily shapeFamily;
  final M3EAppBarDensity density;
  final M3EAppBarVariant variant;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final metrics = appBarMetricsFor(context, density);
    final bg = backgroundColor ?? appBarBackgroundFor(context);
    final fg = foregroundColor ?? M3ETheme.of(context).colorScheme.onSurface;
    final shape = appBarShapeFor(context, shapeFamily);

    final collapsedStyle = appBarTitleStyleFor(context, collapsed: true);
    final expandedStyle = appBarTitleStyleFor(context, collapsed: false);

    final collapsed = metrics.collapsedHeight;
    final expanded = switch (variant) {
      M3EAppBarVariant.medium => metrics.mediumExpanded,
      M3EAppBarVariant.large => metrics.largeExpanded,
      M3EAppBarVariant.small => metrics.smallHeight,
    };

    final resolvedTitleWidget = title ??
        (titleText != null
            ? Text(titleText!,
                style: collapsedStyle, overflow: TextOverflow.ellipsis)
            : null);

    final bar = SliverAppBar(
      pinned: pinned,
      floating: floating,
      snap: snap && floating,
      backgroundColor: bg,
      foregroundColor: fg,
      collapsedHeight: collapsed,
      expandedHeight: expanded,
      centerTitle: centerTitle,
      leading: leading,
      title: resolvedTitleWidget,
      actions: actions,
      shape: shape,
      flexibleSpace: _buildFlexibleSpace(context, expandedStyle),
    );

    if (semanticLabel == null) return bar;
    return M3ESliverSemantic(
      label: semanticLabel!,
      child: bar,
    );
  }

  Widget? _buildFlexibleSpace(BuildContext context, TextStyle expandedStyle) {
    switch (variant) {
      case M3EAppBarVariant.small:
        return null;
      case M3EAppBarVariant.medium:
      case M3EAppBarVariant.large:
        final t = title ??
            (titleText != null ? Text(titleText!, style: expandedStyle) : null);
        if (t == null) return null;
        return FlexibleSpaceBar(
          titlePadding:
              const EdgeInsetsDirectional.only(start: 16, bottom: 16, end: 16),
          title: DefaultTextStyle(
            style: expandedStyle.copyWith(
              color: M3ETheme.of(context).colorScheme.onSurface,
            ),
            child: t,
          ),
          collapseMode: CollapseMode.pin,
          expandedTitleScale:
              1.0, // Typography already larger; avoid scale morph
        );
    }
  }
}

/// A helper to wrap a sliver with semantics label.
class M3ESliverSemantic extends SingleChildRenderObjectWidget {
  const M3ESliverSemantic({super.key, required this.label, required Widget child})
      : super(child: child);
  final String label;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _M3ESliverSemanticRender(label);
  @override
  void updateRenderObject(
      BuildContext context, covariant _M3ESliverSemanticRender renderObject) {
    renderObject.label = label;
  }
}

class _M3ESliverSemanticRender extends RenderProxySliver {
  _M3ESliverSemanticRender(this._label);
  String _label;
  set label(String v) {
    if (v == _label) return;
    _label = v;
    markNeedsSemanticsUpdate();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.label = _label;
    config.isSemanticBoundary = true;
  }
}
