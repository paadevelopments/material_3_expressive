// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// HorizontalFloatingToolbar / VerticalFloatingToolbar / FlexibleBottomAppBar
//
// build.gradle.kts (Module level)
// dependencies {
//   implementation("androidx.compose.material3:material3:1.4.0-alpha01") // or 1.3.x stable
// }

import 'package:flutter/material.dart';

import '../../foundations/foundations.dart';
import '../floating_action_buttons/enums/m3e_fab.dart';
import '../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../icon_buttons/styles/m3e_icon_button_theme.dart';
import 'components/m3e_toolbar_actions_row.dart';
import 'components/m3e_toolbar_body.dart';
import 'components/m3e_toolbar_fab_slot.dart';
import 'components/m3e_toolbar_title_block.dart';
import 'enums/m3e_toolbar_enums.dart';
import 'models/m3e_toolbar_action.dart';
import 'res/m3e_toolbar_tokens.dart';
import 'styles/m3e_toolbar_theme.dart';

export 'enums/m3e_toolbar_enums.dart';
export 'models/m3e_toolbar_action.dart';
export 'styles/m3e_toolbar_theme.dart';

/// A Material 3 Expressive toolbar.
///
/// Mirrors Compose Material 3:
/// - [M3EToolbar] / [M3EToolbar.floating] → `HorizontalFloatingToolbar` /
///   `VerticalFloatingToolbar`
/// - [M3EToolbar.docked] → `FlexibleBottomAppBar` (docked toolbar tokens)
class M3EToolbar extends StatelessWidget implements PreferredSizeWidget {
  /// Floating toolbar (default). Horizontal unless [axis] is vertical.
  ///
  /// When [safeArea] is true, only [dockEdge] gets an **external** system
  /// inset (outside the pill) — never inside [Material].
  const M3EToolbar({
    this.leading,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.trailing,
    this.actions = const <M3EToolbarAction>[],
    this.maxInlineActions = 4,
    this.overflowIcon = const Icon(M3EIcons.more_vert),
    this.centerTitle = false,
    this.alignment = M3EToolbarAlignment.center,
    this.colorStyle = M3EToolbarColorStyle.standard,
    this.variant,
    this.size = M3EToolbarSize.medium,
    this.axis = Axis.horizontal,
    this.expanded = true,
    this.floatingActionButton,
    this.fabIcon,
    this.onFabPressed,
    this.fabPosition = M3EToolbarFabPosition.end,
    this.dockEdge = M3EToolbarDockEdge.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.padding,
    this.safeArea = false,
    this.clipBehavior = Clip.none,
    this.semanticLabel,
    super.key,
  }) : placement = M3EToolbarPlacement.floating;

  /// Explicit floating constructor (same as default).
  ///
  /// When [safeArea] is true, only [dockEdge] gets an **external** system
  /// inset (outside the pill) — never inside [Material].
  const M3EToolbar.floating({
    this.leading,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.trailing,
    this.actions = const <M3EToolbarAction>[],
    this.maxInlineActions = 4,
    this.overflowIcon = const Icon(M3EIcons.more_vert),
    this.centerTitle = false,
    this.alignment = M3EToolbarAlignment.center,
    this.colorStyle = M3EToolbarColorStyle.standard,
    this.variant,
    this.size = M3EToolbarSize.medium,
    this.axis = Axis.horizontal,
    this.expanded = true,
    this.floatingActionButton,
    this.fabIcon,
    this.onFabPressed,
    this.fabPosition = M3EToolbarFabPosition.end,
    this.dockEdge = M3EToolbarDockEdge.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.padding,
    this.safeArea = false,
    this.clipBehavior = Clip.none,
    this.semanticLabel,
    super.key,
  }) : placement = M3EToolbarPlacement.floating;

  /// Docked full-bleed bar (Compose `FlexibleBottomAppBar`).
  ///
  /// When [safeArea] is true, only [dockEdge] receives system inset padding.
  const M3EToolbar.docked({
    this.leading,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.trailing,
    this.actions = const <M3EToolbarAction>[],
    this.maxInlineActions = 4,
    this.overflowIcon = const Icon(M3EIcons.more_vert),
    this.centerTitle = false,
    this.colorStyle = M3EToolbarColorStyle.standard,
    this.variant,
    this.size = M3EToolbarSize.medium,
    this.dockEdge = M3EToolbarDockEdge.bottom,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.padding,
    this.safeArea = true,
    this.clipBehavior = Clip.none,
    this.semanticLabel,
    super.key,
  })  : placement = M3EToolbarPlacement.docked,
        axis = Axis.horizontal,
        alignment = M3EToolbarAlignment.start,
        expanded = true,
        floatingActionButton = null,
        fabIcon = null,
        onFabPressed = null,
        fabPosition = M3EToolbarFabPosition.end;

  final M3EToolbarPlacement placement;
  final M3EToolbarDockEdge dockEdge;
  final Axis axis;

  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final Widget? subtitle;
  final String? subtitleText;
  final Widget? trailing;
  final List<M3EToolbarAction> actions;
  final int maxInlineActions;
  final Widget overflowIcon;
  final bool centerTitle;
  final M3EToolbarAlignment alignment;
  final M3EToolbarColorStyle colorStyle;

  /// Legacy variant; when set, overrides [colorStyle].
  final M3EToolbarVariant? variant;
  final M3EToolbarSize size;

  /// When false, floating leading/trailing slots collapse.
  final bool expanded;

  final Widget? floatingActionButton;
  final Widget? fabIcon;
  final VoidCallback? onFabPressed;
  final M3EToolbarFabPosition fabPosition;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final EdgeInsetsGeometry? padding;
  final bool safeArea;
  final Clip clipBehavior;
  final String? semanticLabel;

  bool get _floating => placement == M3EToolbarPlacement.floating;
  bool get _hasFab =>
      _floating && (floatingActionButton != null || fabIcon != null);

  @override
  Size get preferredSize => Size.fromHeight(M3EToolbarTokens.containerSize);

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildToolbar);
  }

  Widget _buildToolbar(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EToolbarTheme toolbarTheme = theme.toolbarTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    final M3EToolbarMetrics metrics = toolbarTheme.metricsFor(placement);
    final M3EToolbarColorStyle style =
        variant != null ? toolbarTheme.colorStyleFromVariant(variant!) : colorStyle;
    final M3EToolbarColors colors = toolbarTheme.colors(scheme, style);

    final Color background = backgroundColor ?? colors.container;
    final Color foreground = foregroundColor ?? colors.content;
    final ShapeBorder shape =
        _floating ? toolbarTheme.floatingShape() : toolbarTheme.dockedShape();

    final EdgeInsets contentPadding =
        metrics.contentPadding.resolve(Directionality.of(context));

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
    final bool hasTitle =
        resolvedTitle != null || resolvedSubtitle != null;

    final bool iconsOnly = !hasTitle &&
        leading == null &&
        trailing == null &&
        actions.isNotEmpty;
    final bool dockedIconsOnly = !_floating && iconsOnly;

    final Widget actionsRow = M3EToolbarActionsRow(
      actions: actions,
      maxInline: maxInlineActions,
      overflowIcon: overflowIcon,
      iconButtonSize: toolbarTheme.iconButtonSize(size),
      overflowTextStyle:
          theme.typeScale.labelLarge.copyWith(color: scheme.onSurface),
      destructiveColor: scheme.error,
      axis: axis,
      expand: dockedIconsOnly,
      mainAxisAlignment: dockedIconsOnly
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.start,
    );

    Widget? content;
    if (hasTitle) {
      final double titleStartExtra = _floating
          ? _titleOpticalStartInset(toolbarTheme, theme.iconButtonTheme)
          : 0;
      content = Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: titleStartExtra),
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
          ),
          SizedBox(width: metrics.gap),
          actionsRow,
        ],
      );
    } else if (actions.isNotEmpty) {
      content = actionsRow;
    }

    final Widget body = M3EToolbarBody(
      axis: axis,
      expanded: expanded,
      gap: metrics.gap,
      leading: leading,
      trailing: trailing,
      content: content,
      mainAxisSize: _floating && !hasTitle ? MainAxisSize.min : MainAxisSize.max,
      mainAxisAlignment: _floating
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      expandContent: !_floating || hasTitle,
    );

    final double elev = elevation ??
        (_hasFab && expanded
            ? metrics.elevationWithFab
            : metrics.elevation);

    final EdgeInsets resolvedPadding =
        padding?.resolve(Directionality.of(context)) ?? contentPadding;
    // Design-token padding only inside the pill / 64dp band — never system insets.
    final EdgeInsets innerPadding = EdgeInsets.only(
      left: resolvedPadding.left,
      right: resolvedPadding.right,
      top: _floating ? resolvedPadding.top : 0,
      bottom: _floating ? resolvedPadding.bottom : 0,
    );

    final Widget contentBand = SizedBox(
      height: axis == Axis.horizontal ? metrics.crossAxisSize : null,
      width: axis == Axis.vertical
          ? metrics.crossAxisSize
          : (_floating && !hasTitle ? null : double.infinity),
      child: Padding(
        padding: innerPadding,
        child: M3ETheme(
          data: toolbarTheme.scopedTheme(theme, foreground),
          child: body,
        ),
      ),
    );

    // Floating: Material is the pill only (token padding, fixed 64dp).
    // Docked: edge safe-area may grow Material outside the 64dp band.
    Widget bar = Material(
      color: background,
      elevation: elev,
      shape: shape,
      clipBehavior: clipBehavior,
      child: _floating
          ? contentBand
          : Padding(
              padding: _edgeSafeAreaInset(context),
              child: contentBand,
            ),
    );

    if (_hasFab) {
      bar = _withFab(bar, style);
    }

    if (_floating && !hasTitle && !_hasFab) {
      bar = Align(
        alignment: _alignmentFor(alignment),
        widthFactor: 1,
        heightFactor: 1,
        child: bar,
      );
    }

    // Floating safe-area: external, single-edge only (never inside the pill).
    if (_floating && safeArea) {
      bar = Padding(
        padding: _edgeSafeAreaInset(context),
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

  /// System inset for [dockEdge] only — top XOR bottom, never all sides.
  EdgeInsets _edgeSafeAreaInset(BuildContext context) {
    if (!safeArea) {
      return EdgeInsets.zero;
    }
    final EdgeInsets mq = MediaQuery.paddingOf(context);
    return EdgeInsets.only(
      top: dockEdge == M3EToolbarDockEdge.top ? mq.top : 0,
      bottom: dockEdge == M3EToolbarDockEdge.bottom ? mq.bottom : 0,
    );
  }

  /// Extra start inset so title text matches trailing icon glyph edge inset.
  double _titleOpticalStartInset(
    M3EToolbarTheme toolbarTheme,
    M3EIconButtonTheme iconButtonTheme,
  ) {
    final M3EIconButtonSize buttonSize = toolbarTheme.iconButtonSize(size);
    final double targetWidth = iconButtonTheme
        .target(buttonSize, M3EIconButtonWidth.defaultWidth)
        .width;
    final double iconPx = iconButtonTheme.iconSize(buttonSize);
    return (targetWidth - iconPx) / 2;
  }

  Widget _withFab(Widget toolbar, M3EToolbarColorStyle style) {
    final Widget fab = M3EToolbarFabSlot(
      expanded: expanded,
      fab: floatingActionButton,
      icon: fabIcon,
      onPressed: onFabPressed,
      color: style == M3EToolbarColorStyle.vibrant
          ? M3EFabColor.tertiary
          : M3EFabColor.primary,
    );

    if (!expanded) {
      return fab;
    }

    final bool horizontal = axis == Axis.horizontal;
    final bool fabFirst = switch (fabPosition) {
      M3EToolbarFabPosition.start || M3EToolbarFabPosition.top => true,
      M3EToolbarFabPosition.end || M3EToolbarFabPosition.bottom => false,
    };

    final Widget gap = SizedBox(
      width: horizontal ? M3EToolbarTokens.toolbarToFabGap : 0,
      height: horizontal ? 0 : M3EToolbarTokens.toolbarToFabGap,
    );

    final List<Widget> children = fabFirst
        ? <Widget>[fab, gap, toolbar]
        : <Widget>[toolbar, gap, fab];

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: horizontal
          ? Row(mainAxisSize: MainAxisSize.min, children: children)
          : Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }

  static AlignmentDirectional _alignmentFor(M3EToolbarAlignment alignment) {
    return switch (alignment) {
      M3EToolbarAlignment.start => AlignmentDirectional.centerStart,
      M3EToolbarAlignment.center => AlignmentDirectional.center,
      M3EToolbarAlignment.end => AlignmentDirectional.centerEnd,
    };
  }
}
