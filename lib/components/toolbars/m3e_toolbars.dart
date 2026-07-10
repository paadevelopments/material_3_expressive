import 'package:flutter/material.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_toolbar_actions_row.dart';
import 'components/m3e_toolbar_title_block.dart';
import 'enums/m3e_toolbar_enums.dart';
import 'models/m3e_toolbar_action.dart';
import 'styles/m3e_toolbar_theme.dart';

export 'enums/m3e_toolbar_enums.dart';
export 'models/m3e_toolbar_action.dart';
export 'styles/m3e_toolbar_theme.dart';

/// A Material 3 Expressive toolbar.
///
/// Hosts a leading affordance, title block, and action icons with overflow
/// support. Can be used as a [PreferredSizeWidget] in a scaffold app bar slot
/// or floated above content.
class M3EToolbar extends StatelessWidget implements PreferredSizeWidget {
  const M3EToolbar({
    this.leading,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.actions = const <M3EToolbarAction>[],
    this.maxInlineActions = 4,
    this.overflowIcon = const Icon(M3EIcons.more_vert),
    this.centerTitle = false,
    this.alignment = M3EToolbarAlignment.start,
    this.variant = M3EToolbarVariant.surface,
    this.size = M3EToolbarSize.medium,
    this.density = M3EToolbarDensity.regular,
    this.shapeFamily = M3EToolbarShapeFamily.round,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.padding,
    this.safeArea = true,
    this.clipBehavior = Clip.none,
    this.semanticLabel,
    super.key,
  });

  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final Widget? subtitle;
  final String? subtitleText;
  final List<M3EToolbarAction> actions;
  final int maxInlineActions;
  final Widget overflowIcon;
  final bool centerTitle;
  final M3EToolbarAlignment alignment;
  final M3EToolbarVariant variant;
  final M3EToolbarSize size;
  final M3EToolbarDensity density;
  final M3EToolbarShapeFamily shapeFamily;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;
  final Clip clipBehavior;
  final String? semanticLabel;

  @override
  Size get preferredSize {
    switch (size) {
      case M3EToolbarSize.small:
        return const Size.fromHeight(40);
      case M3EToolbarSize.medium:
        return const Size.fromHeight(48);
      case M3EToolbarSize.large:
        return const Size.fromHeight(56);
    }
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildToolbar);
  }

  Widget _buildToolbar(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EToolbarTheme toolbarTheme = theme.toolbarTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    final M3EToolbarMetrics metrics =
        toolbarTheme.metrics(density, theme.spacing);

    final double height = switch (size) {
      M3EToolbarSize.small => metrics.heightSmall,
      M3EToolbarSize.medium => metrics.heightMedium,
      M3EToolbarSize.large => metrics.heightLarge,
    };

    final Color background =
        backgroundColor ?? toolbarTheme.containerColor(scheme, variant);
    final Color foreground =
        foregroundColor ?? toolbarTheme.foregroundColor(scheme, variant);
    final ShapeBorder shape = toolbarTheme.shape(shapeFamily);
    final EdgeInsetsGeometry resolvedPadding =
        padding ?? metrics.horizontalPadding;

    final Widget? resolvedTitle = title ??
        (titleText != null
            ? Text(
                titleText!,
                style: toolbarTheme
                    .titleStyle(theme.typeScale)
                    .copyWith(color: foreground),
                overflow: TextOverflow.ellipsis,
              )
            : null);

    final Widget? resolvedSubtitle = subtitle ??
        (subtitleText != null
            ? Text(
                subtitleText!,
                style: toolbarTheme
                    .subtitleStyle(theme.typeScale)
                    .copyWith(color: foreground.withValues(alpha: 0.8)),
                overflow: TextOverflow.ellipsis,
              )
            : null);

    final bool hasTitleContent =
        resolvedTitle != null || resolvedSubtitle != null;

    final M3EToolbarActionsRow actionsRow = M3EToolbarActionsRow(
      actions: actions,
      maxInline: maxInlineActions,
      overflowIcon: overflowIcon,
      iconButtonSize: toolbarTheme.iconButtonSize(size),
      overflowTextStyle:
          theme.typeScale.labelLarge.copyWith(color: scheme.onSurface),
      destructiveColor: scheme.error,
    );

    final Widget toolbarRow = Row(
      mainAxisSize:
          hasTitleContent ? MainAxisSize.max : MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (leading != null) leading!,
        if (leading != null) SizedBox(width: metrics.gap),
        if (hasTitleContent) ...<Widget>[
          Expanded(
            child: M3EToolbarTitleBlock(
              title: resolvedTitle,
              subtitle: resolvedSubtitle,
              center: centerTitle,
              titleStyle: toolbarTheme
                  .titleStyle(theme.typeScale)
                  .copyWith(color: foreground),
              subtitleStyle: toolbarTheme
                  .subtitleStyle(theme.typeScale)
                  .copyWith(color: foreground.withValues(alpha: 0.8)),
            ),
          ),
          SizedBox(width: metrics.gap),
        ],
        actionsRow,
      ],
    );

    Widget bar = Material(
      color: background,
      elevation: elevation ??
          (variant == M3EToolbarVariant.surface
              ? metrics.elevationSurface
              : metrics.elevationProminent),
      shape: shape,
      clipBehavior: clipBehavior,
      child: SizedBox(
        height: height,
        width: hasTitleContent ? double.infinity : null,
        child: Padding(
          padding: resolvedPadding,
          child: M3ETheme(
            data: toolbarTheme.scopedTheme(theme, foreground),
            child: toolbarRow,
          ),
        ),
      ),
    );

    if (!hasTitleContent) {
      bar = Align(
        alignment: _alignmentFor(alignment),
        child: bar,
      );
    }

    if (safeArea) {
      bar = SafeArea(
        top: false,
        left: false,
        right: false,
        child: bar,
      );
    }

    if (semanticLabel != null) {
      bar = Semantics(
        container: true,
        label: semanticLabel,
        child: bar,
      );
    }
    return bar;
  }

  static AlignmentDirectional _alignmentFor(M3EToolbarAlignment alignment) {
    switch (alignment) {
      case M3EToolbarAlignment.start:
        return AlignmentDirectional.centerStart;
      case M3EToolbarAlignment.center:
        return AlignmentDirectional.center;
      case M3EToolbarAlignment.end:
        return AlignmentDirectional.centerEnd;
    }
  }
}
