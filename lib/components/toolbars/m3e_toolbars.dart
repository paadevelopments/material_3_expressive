// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// HorizontalFloatingToolbar / VerticalFloatingToolbar / FlexibleBottomAppBar
//
// build.gradle.kts (Module level)
// dependencies {
//   implementation("androidx.compose.material3:material3:1.4.0-alpha01") // or 1.3.x stable
// }

import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import '../floating_action_buttons/enums/m3e_fab.dart';
import '../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../icon_buttons/styles/m3e_icon_button_theme.dart';
import 'components/m3e_toolbar_actions_row.dart';
import 'components/m3e_toolbar_body.dart';
import 'components/m3e_toolbar_expanding_actions.dart';
import 'components/m3e_toolbar_fab_slot.dart';
import 'components/m3e_toolbar_title_block.dart';
import 'enums/m3e_toolbar_enums.dart';
import 'models/m3e_toolbar_item.dart';
import 'res/m3e_toolbar_tokens.dart';
import 'styles/m3e_toolbar_theme.dart';
import 'utils/m3e_toolbar_item_layout.dart';

export 'enums/m3e_toolbar_enums.dart';
export 'models/m3e_toolbar_item.dart';
export 'styles/m3e_toolbar_theme.dart';

/// A Material 3 Expressive toolbar.
///
/// Mirrors Compose Material 3:
/// - [M3EToolbar] / [M3EToolbar.floating] → `HorizontalFloatingToolbar` /
///   `VerticalFloatingToolbar`
/// - [M3EToolbar.docked] → `FlexibleBottomAppBar` (docked toolbar tokens)
///
/// Floating toolbars own expand/collapse when an action sets
/// [M3EToolbarAction.isExpandTrigger]. The pill grows left/right (or
/// top/bottom) from that filled trigger with a spatial spring.
class M3EToolbar extends StatefulWidget implements PreferredSizeWidget {
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
    this.actions = const <M3EToolbarItem>[],
    this.maxInlineActions = 4,
    this.overflowIcon = const Icon(M3EIcons.more_vert),
    this.centerTitle = false,
    this.alignment = Alignment.center,
    this.colorStyle = M3EToolbarColorStyle.standard,
    this.variant,
    this.size = M3EToolbarSize.medium,
    this.axis = Axis.horizontal,
    this.expanded = true,
    this.onExpandedChanged,
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
  const M3EToolbar.floating({
    this.leading,
    this.title,
    this.titleText,
    this.subtitle,
    this.subtitleText,
    this.trailing,
    this.actions = const <M3EToolbarItem>[],
    this.maxInlineActions = 4,
    this.overflowIcon = const Icon(M3EIcons.more_vert),
    this.centerTitle = false,
    this.alignment = Alignment.center,
    this.colorStyle = M3EToolbarColorStyle.standard,
    this.variant,
    this.size = M3EToolbarSize.medium,
    this.axis = Axis.horizontal,
    this.expanded = true,
    this.onExpandedChanged,
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
    this.actions = const <M3EToolbarItem>[],
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
        alignment = Alignment.center,
        expanded = true,
        onExpandedChanged = null,
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
  final List<M3EToolbarItem> actions;
  final int maxInlineActions;
  final Widget overflowIcon;
  final bool centerTitle;

  /// Positions a floating toolbar within its parent. Ignored when docked.
  final AlignmentGeometry alignment;
  final M3EToolbarColorStyle colorStyle;

  /// Legacy variant; when set, overrides [colorStyle].
  final M3EToolbarVariant? variant;
  final M3EToolbarSize size;

  /// Initial expand state for floating toolbars that have an expand trigger.
  ///
  /// The toolbar owns subsequent toggles. Listen via [onExpandedChanged].
  final bool expanded;

  /// Called whenever the owned expand state changes.
  final ValueChanged<bool>? onExpandedChanged;

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

  @override
  Size get preferredSize => Size.fromHeight(M3EToolbarTokens.containerSize);

  @override
  State<M3EToolbar> createState() => _M3EToolbarState();
}

class _M3EToolbarState extends State<M3EToolbar>
    with TickerProviderStateMixin {
  late bool _expanded;
  late SingleMotionController _expandCtrl;

  bool get _floating => widget.placement == M3EToolbarPlacement.floating;
  bool get _hasFab =>
      _floating &&
      (widget.floatingActionButton != null || widget.fabIcon != null);
  bool get _hasTrigger => widget.actions.any(
        (M3EToolbarItem item) =>
            item is M3EToolbarAction && item.isExpandTrigger,
      );

  @override
  void initState() {
    super.initState();
    assert(
      widget.actions
              .whereType<M3EToolbarAction>()
              .where((M3EToolbarAction a) => a.isExpandTrigger)
              .length <=
          1,
      'At most one M3EToolbarAction may set isExpandTrigger.',
    );
    _expanded = widget.expanded;
    _expandCtrl = SingleMotionController(
      motion: m3eToolbarExpandMotion(),
      vsync: this,
      initialValue: _expanded || !_hasTrigger ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant M3EToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Docked / no-trigger always stay fully open.
    if (!_floating || !_hasTrigger) {
      if (_expandCtrl.value != 1) {
        _expandCtrl.value = 1;
      }
      if (!_expanded) {
        _expanded = true;
      }
    }
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  void _setExpanded(bool value) {
    if (!_floating || !_hasTrigger || _expanded == value) {
      return;
    }
    setState(() => _expanded = value);
    widget.onExpandedChanged?.call(value);
    _expandCtrl
      ..motion = m3eToolbarExpandMotion()
      ..animateTo(value ? 1 : 0);
  }

  void _toggleExpanded() => _setExpanded(!_expanded);

  void _onTriggerPressed(M3EToolbarAction trigger) {
    _toggleExpanded();
    trigger.onPressed();
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
        toolbarTheme.metricsFor(widget.placement);
    final M3EToolbarColorStyle style = widget.variant != null
        ? toolbarTheme.colorStyleFromVariant(widget.variant!)
        : widget.colorStyle;
    final M3EToolbarColors colors = toolbarTheme.colors(scheme, style);

    final Color background = widget.backgroundColor ?? colors.container;
    final Color foreground = widget.foregroundColor ?? colors.content;
    final ShapeBorder shape = _floating
        ? toolbarTheme.floatingShape()
        : toolbarTheme.dockedShape();

    final EdgeInsets contentPadding =
        metrics.contentPadding.resolve(Directionality.of(context));

    final EdgeInsets resolvedPadding =
        widget.padding?.resolve(Directionality.of(context)) ?? contentPadding;
    // Content padding (incl. vertical) applies to floating and docked; safe
    // area insets stay outside Material via [_edgeSafeAreaInset].
    final EdgeInsets innerPadding = resolvedPadding;
    final double availableExtent = M3EToolbarItemLayout.availableCrossExtent(
      crossAxisSize: metrics.crossAxisSize,
      padding: innerPadding,
      axis: widget.axis,
    );
    final M3EIconButtonSize iconButtonSize =
        toolbarTheme.iconButtonSize(widget.size);
    // Match action↔action optical gaps: icon buttons overhang their visual
    // inside the target; widget slots get the same inset on each side.
    final Size iconTarget = theme.iconButtonTheme.target(
      iconButtonSize,
      M3EIconButtonWidth.defaultWidth,
    );
    final Size iconVisual = theme.iconButtonTheme.visual(
      iconButtonSize,
      M3EIconButtonWidth.defaultWidth,
    );
    final double opticalInset = widget.axis == Axis.horizontal
        ? (iconTarget.width - iconVisual.width) / 2
        : (iconTarget.height - iconVisual.height) / 2;

    final Widget? resolvedTitle = widget.title ??
        (widget.titleText != null
            ? Text(
                widget.titleText!,
                style: toolbarTheme
                    .titleStyle(theme.typeScale)
                    .copyWith(color: foreground),
                overflow: TextOverflow.ellipsis,
              )
            : null);
    final Widget? resolvedSubtitle = widget.subtitle ??
        (widget.subtitleText != null
            ? Text(
                widget.subtitleText!,
                style: toolbarTheme
                    .subtitleStyle(theme.typeScale)
                    .copyWith(color: foreground.withValues(alpha: 0.8)),
                overflow: TextOverflow.ellipsis,
              )
            : null);
    final bool hasTitle =
        resolvedTitle != null || resolvedSubtitle != null;

    final bool iconsOnly = !hasTitle &&
        widget.leading == null &&
        widget.trailing == null &&
        widget.actions.isNotEmpty;
    final bool dockedIconsOnly = !_floating && iconsOnly;

    final bool useExpanding =
        _floating && _hasTrigger && !hasTitle;

    final Widget actionsContent = useExpanding
        ? AnimatedBuilder(
            animation: _expandCtrl,
            builder: (BuildContext context, Widget? child) {
              return M3EToolbarExpandingActions(
                actions: widget.actions,
                maxInline: widget.maxInlineActions,
                overflowIcon: widget.overflowIcon,
                iconButtonSize: iconButtonSize,
                overflowTextStyle: theme.typeScale.labelLarge
                    .copyWith(color: scheme.onSurface),
                destructiveColor: scheme.error,
                axis: widget.axis,
                expandProgress: _expandCtrl.value,
                availableExtent: availableExtent,
                opticalInset: opticalInset,
                onTriggerPressed: () {
                  final M3EToolbarAction trigger = widget.actions
                      .whereType<M3EToolbarAction>()
                      .firstWhere(
                        (M3EToolbarAction a) => a.isExpandTrigger,
                      );
                  _onTriggerPressed(trigger);
                },
                leading: widget.leading,
                trailing: widget.trailing,
                gap: metrics.gap,
              );
            },
          )
        : M3EToolbarActionsRow(
            actions: widget.actions,
            maxInline: widget.maxInlineActions,
            overflowIcon: widget.overflowIcon,
            iconButtonSize: iconButtonSize,
            overflowTextStyle:
                theme.typeScale.labelLarge.copyWith(color: scheme.onSurface),
            destructiveColor: scheme.error,
            axis: widget.axis,
            availableExtent: availableExtent,
            opticalInset: opticalInset,
            gap: metrics.gap,
            expand: dockedIconsOnly,
            mainAxisAlignment: dockedIconsOnly
                ? MainAxisAlignment.spaceBetween
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
                center: widget.centerTitle,
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
          actionsContent,
        ],
      );
    } else if (widget.actions.isNotEmpty || useExpanding) {
      content = actionsContent;
    }

    // Expanding actions already host leading/trailing inside the morph.
    final Widget body = useExpanding
        ? (content ?? const SizedBox.shrink())
        : M3EToolbarBody(
            axis: widget.axis,
            gap: metrics.gap,
            leading: widget.leading,
            trailing: widget.trailing,
            content: content,
            mainAxisSize:
                _floating && !hasTitle ? MainAxisSize.min : MainAxisSize.max,
            mainAxisAlignment: _floating
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            expandContent: !_floating || hasTitle,
          );

    final double elev = widget.elevation ??
        (_hasFab ? metrics.elevationWithFab : metrics.elevation);

    final Widget contentBand = SizedBox(
      height: widget.axis == Axis.horizontal ? metrics.crossAxisSize : null,
      width: widget.axis == Axis.vertical
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

    Widget bar = Material(
      color: background,
      elevation: elev,
      shape: shape,
      clipBehavior: widget.clipBehavior,
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

    if (_floating && widget.safeArea) {
      bar = Padding(
        padding: _edgeSafeAreaInset(context),
        child: bar,
      );
    }

    if (_floating) {
      bar = Align(
        alignment: widget.alignment,
        child: bar,
      );
    }

    if (widget.semanticLabel != null) {
      bar = Semantics(
        container: true,
        label: widget.semanticLabel,
        child: bar,
      );
    }
    return bar;
  }

  EdgeInsets _edgeSafeAreaInset(BuildContext context) {
    if (!widget.safeArea) {
      return EdgeInsets.zero;
    }
    final EdgeInsets mq = MediaQuery.viewPaddingOf(context);
    return EdgeInsets.only(
      top: widget.dockEdge == M3EToolbarDockEdge.top ? mq.top : 0,
      bottom: widget.dockEdge == M3EToolbarDockEdge.bottom ? mq.bottom : 0,
    );
  }

  double _titleOpticalStartInset(
    M3EToolbarTheme toolbarTheme,
    M3EIconButtonTheme iconButtonTheme,
  ) {
    final M3EIconButtonSize buttonSize =
        toolbarTheme.iconButtonSize(widget.size);
    final double targetWidth = iconButtonTheme
        .target(buttonSize, M3EIconButtonWidth.defaultWidth)
        .width;
    final double iconPx = iconButtonTheme.iconSize(buttonSize);
    return (targetWidth - iconPx) / 2;
  }

  Widget _withFab(Widget toolbar, M3EToolbarColorStyle style) {
    final Widget fab = M3EToolbarFabSlot(
      fab: widget.floatingActionButton,
      icon: widget.fabIcon,
      onPressed: widget.onFabPressed,
      color: style == M3EToolbarColorStyle.vibrant
          ? M3EFabColor.tertiary
          : M3EFabColor.primary,
    );

    final bool horizontal = widget.axis == Axis.horizontal;
    // FAB stays on the outer end — never toggles or hides with the pill.
    final bool fabFirst = switch (widget.fabPosition) {
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

    return horizontal
        ? Row(mainAxisSize: MainAxisSize.min, children: children)
        : Column(mainAxisSize: MainAxisSize.min, children: children);
  }
}
