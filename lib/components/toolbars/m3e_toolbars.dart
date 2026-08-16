// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// HorizontalFloatingToolbar / VerticalFloatingToolbar / FlexibleBottomAppBar
//
// FAB morph / scroll exit also reference m3e_core floating_toolbar (not vendored).
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import '../floating_action_buttons/enums/m3e_fab.dart';
import '../icon_buttons/enums/m3e_icon_button_enums.dart';
import '../icon_buttons/styles/m3e_icon_button_theme.dart';
import 'components/m3e_toolbar_actions_row.dart';
import 'components/m3e_toolbar_body.dart';
import 'components/m3e_toolbar_expanding_actions.dart';
import 'components/m3e_toolbar_fab_layout.dart';
import 'components/m3e_toolbar_fab_slot.dart';
import 'components/m3e_toolbar_measure_size.dart';
import 'components/m3e_toolbar_title_block.dart';
import 'controllers/m3e_toolbar_visibility_controller.dart';
import 'enums/m3e_toolbar_enums.dart';
import 'm3e_toolbar_scroll_behavior.dart';
import 'models/m3e_toolbar_item.dart';
import 'res/m3e_toolbar_tokens.dart';
import 'styles/m3e_toolbar_theme.dart';
import 'utils/m3e_toolbar_item_layout.dart';
import 'utils/m3e_toolbar_spring_motion.dart';

export 'controllers/m3e_toolbar_visibility_controller.dart';
export 'enums/m3e_toolbar_enums.dart';
export 'm3e_toolbar_scroll_behavior.dart';
export 'models/m3e_toolbar_item.dart';
export 'styles/m3e_toolbar_theme.dart';

part 'components/m3e_toolbar_build.dart';

/// A Material 3 Expressive toolbar.
///
/// Mirrors Compose Material 3:
/// - [M3EToolbar] / [M3EToolbar.floating] → `HorizontalFloatingToolbar` /
///   `VerticalFloatingToolbar`
/// - [M3EToolbar.docked] → `FlexibleBottomAppBar` (docked toolbar tokens)
///
/// Floating expand:
/// - With an adjacent FAB: FAB press toggles **whole-pill** expand/collapse
///   (FAB 80→56) with [M3EMotion.expressiveSpatialFast].
/// - Without a FAB: [M3EToolbarAction.isExpandTrigger] toggles neighbor reveal.
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
    this.fabExpandIcon,
    this.fabCollapseIcon,
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
    this.visibilityController,
    this.scrollBehavior,
    this.exitExtent,
    this.activeIndex,
    this.onActiveIndexChanged,
    this.fabExpandsToolbar = true,
    this.pillActiveSpring = true,
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
    this.fabExpandIcon,
    this.fabCollapseIcon,
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
    this.visibilityController,
    this.scrollBehavior,
    this.exitExtent,
    this.activeIndex,
    this.onActiveIndexChanged,
    this.fabExpandsToolbar = true,
    this.pillActiveSpring = true,
    super.key,
  }) : placement = M3EToolbarPlacement.floating;

  /// Docked full-bleed bar (Compose `FlexibleBottomAppBar`).
  ///
  /// Optional [scrollBehavior] / [visibilityController] enable scroll-exit
  /// (default: no scroll detection). No FAB expand morph.
  /// [M3EToolbarAction.isExpandTrigger] styling is ignored when docked.
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
    this.visibilityController,
    this.scrollBehavior,
    this.exitExtent,
    this.activeIndex,
    this.onActiveIndexChanged,
    super.key,
  }) : placement = M3EToolbarPlacement.docked,
       axis = Axis.horizontal,
       alignment = Alignment.center,
       expanded = true,
       onExpandedChanged = null,
       floatingActionButton = null,
       fabIcon = null,
       fabExpandIcon = null,
       fabCollapseIcon = null,
       onFabPressed = null,
       fabPosition = M3EToolbarFabPosition.end,
       fabExpandsToolbar = true,
       pillActiveSpring = true;

  /// placement.
  final M3EToolbarPlacement placement;

  /// dockEdge.
  final M3EToolbarDockEdge dockEdge;

  /// axis.
  final Axis axis;

  /// leading.
  final Widget? leading;

  /// title.
  final Widget? title;

  /// titleText.
  final String? titleText;

  /// subtitle.
  final Widget? subtitle;

  /// subtitleText.
  final String? subtitleText;

  /// trailing.
  final Widget? trailing;

  /// actions.
  final List<M3EToolbarItem> actions;

  /// maxInlineActions.
  final int maxInlineActions;

  /// overflowIcon.
  final Widget overflowIcon;

  /// centerTitle.
  final bool centerTitle;

  /// Positions a floating toolbar within its parent. Ignored when docked.
  final AlignmentGeometry alignment;

  /// colorStyle.
  final M3EToolbarColorStyle colorStyle;

  /// Legacy variant; when set, overrides [colorStyle].
  final M3EToolbarVariant? variant;

  /// size.
  final M3EToolbarSize size;

  /// Expand state for floating toolbars with a FAB or expand trigger.
  ///
  /// Parent changes are synced via spring. Listen via [onExpandedChanged].
  final bool expanded;

  /// Called whenever the expand state changes.
  final ValueChanged<bool>? onExpandedChanged;

  /// floatingActionButton.
  final Widget? floatingActionButton;

  /// Expand-state FAB icon fallback / opt-in for the default adjacent FAB.
  ///
  /// Used when [fabExpandIcon] is null. Prefer [fabExpandIcon] /
  /// [fabCollapseIcon] when providing both states.
  final Widget? fabIcon;

  /// Icon shown on the default FAB when the toolbar is collapsed.
  ///
  /// Defaults to [M3EIcons.add] when resolving the default FAB.
  final Widget? fabExpandIcon;

  /// Icon shown on the default FAB when the toolbar is expanded.
  ///
  /// Defaults to [M3EIcons.close] when resolving the default FAB.
  final Widget? fabCollapseIcon;

  /// Called when the FAB is pressed. When null and a default FAB is built,
  /// the FAB toggles whole-pill expand. When set, it is invoked in addition
  /// to the expand toggle (for default FAB) or alone (custom [floatingActionButton]
  /// that does not wire expand — keep [expanded] true for always-open pill).
  ///
  /// When [fabExpandsToolbar] is false, this is the only FAB callback (no
  /// expand toggle). If null, the FAB tap is a no-op.
  final VoidCallback? onFabPressed;

  /// When true (default), an adjacent FAB toggles whole-pill expand/collapse
  /// and morphs between large (80) and small (56) sizes.
  ///
  /// When false, the pill stays open, the FAB stays at [M3EToolbarTokens.fabBaseline]
  /// (56), and only [onFabPressed] runs. [expanded] / [onExpandedChanged] are
  /// ignored. Floating toolbars only.
  final bool fabExpandsToolbar;

  /// When true (default), labeled action selection springs the toolbar pill
  /// width in sync with each action's label morph.
  ///
  /// When false, the pill reserves a fixed width (widest labeled action +
  /// icon-only neighbors + gaps) so the outer pill does not resize while
  /// action labels still morph.
  final bool pillActiveSpring;

  /// fabPosition.
  final M3EToolbarFabPosition fabPosition;

  /// backgroundColor.
  final Color? backgroundColor;

  /// foregroundColor.
  final Color? foregroundColor;

  /// elevation.
  final double? elevation;

  /// padding.
  final EdgeInsetsGeometry? padding;

  /// safeArea.
  final bool safeArea;

  /// clipBehavior.
  final Clip clipBehavior;

  /// semanticLabel.
  final String? semanticLabel;

  /// Optional manual visibility controller (show / hide / toggle).
  final M3EToolbarVisibilityController? visibilityController;

  /// Optional scroll-exit behavior. Default null = no scroll detection.
  ///
  /// When set, uses the behavior's controller unless [visibilityController]
  /// is also provided (then they should be the same instance).
  final M3EToolbarScrollBehavior? scrollBehavior;

  /// Overrides measured exit distance when non-null.
  final double? exitExtent;

  /// Optional seed / external sync for the active action index.
  ///
  /// Selection is owned internally only when [onActiveIndexChanged] is set.
  /// Expand triggers do not become active. When selection is enabled,
  /// per-action [M3EToolbarAction.active] is ignored.
  final int? activeIndex;

  /// Enables toolbar-owned selection and notifies when the active index changes.
  ///
  /// When non-null, taps update internal selection then invoke this callback;
  /// [M3EToolbarAction.onPressed] is not called. When null, taps only run the
  /// action (or expand-trigger toggle) — no internal selection.
  final ValueChanged<int>? onActiveIndexChanged;

  @override
  Size get preferredSize =>
      const Size.fromHeight(M3EToolbarTokens.containerSize);

  @override
  State<M3EToolbar> createState() => _M3EToolbarState();
}

class _M3EToolbarState extends State<M3EToolbar> with TickerProviderStateMixin {
  late bool _expanded;
  late SingleMotionController _expandCtrl;
  double _fabSize = M3EToolbarTokens.fabBaseline;
  int? _activeIndex;

  bool get _floating => widget.placement == M3EToolbarPlacement.floating;
  bool get _hasFab =>
      _floating &&
      (widget.floatingActionButton != null ||
          widget.fabIcon != null ||
          widget.fabExpandIcon != null ||
          widget.fabCollapseIcon != null);
  bool get _hasTrigger => widget.actions.any(
    (M3EToolbarItem item) => item is M3EToolbarAction && item.isExpandTrigger,
  );

  /// Neighbor-reveal expand (no FAB). FAB path uses whole-pill morph instead.
  bool get _usesTriggerExpand => _floating && !_hasFab && _hasTrigger;
  bool get _usesFabExpand => _hasFab && widget.fabExpandsToolbar;

  M3EToolbarVisibilityController? get _visibility {
    return widget.visibilityController ?? widget.scrollBehavior?.controller;
  }

  M3EToolbarExitDirection get _exitDirection =>
      widget.scrollBehavior?.exitDirection ?? M3EToolbarExitDirection.bottom;

  /// Actions with toolbar-owned active / press wiring applied.
  List<M3EToolbarItem> get _resolvedActions {
    return <M3EToolbarItem>[
      for (int i = 0; i < widget.actions.length; i++)
        _resolveItem(i, widget.actions[i]),
    ];
  }

  bool get _selectionEnabled => widget.onActiveIndexChanged != null;

  M3EToolbarItem _resolveItem(int index, M3EToolbarItem item) {
    if (item is! M3EToolbarAction) {
      return item;
    }
    final bool triggerExpand = item.isExpandTrigger && _usesTriggerExpand;
    // Docked: never treat as expand trigger for styling / expand behavior.
    final bool showAsTrigger = _floating && item.isExpandTrigger;
    final bool active =
        !triggerExpand &&
        (_selectionEnabled ? _activeIndex == index : item.active);
    return M3EToolbarAction(
      icon: item.icon,
      onPressed: () => _handleActionPressed(index, item),
      tooltip: item.tooltip,
      semanticLabel: item.semanticLabel,
      enabled: item.enabled,
      label: item.label,
      isDestructive: item.isDestructive,
      active: active,
      isExpandTrigger: showAsTrigger,
    );
  }

  void _handleActionPressed(int index, M3EToolbarAction action) {
    if (action.isExpandTrigger && _usesTriggerExpand) {
      _toggleExpanded();
      return;
    }
    if (_selectionEnabled) {
      _setActiveIndex(index);
      return;
    }
    action.onPressed();
  }

  void _setActiveIndex(int index) {
    if (_activeIndex == index) {
      return;
    }
    setState(() => _activeIndex = index);
    widget.onActiveIndexChanged!(index);
  }

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
    _activeIndex = widget.activeIndex;
    _expanded = widget.expanded;
    final bool startExpanded =
        _expanded || (!_usesTriggerExpand && !_usesFabExpand);
    _expandCtrl = SingleMotionController(
      motion: m3eToolbarExpandMotion(),
      vsync: this,
      initialValue: startExpanded ? 1 : 0,
    )..addListener(_handleExpandTick);
    _fabSize = _resolvedFabSize(_expandCtrl.value);
    _visibility?.attach(this);
    _applyExitExtent();
  }

  @override
  void didUpdateWidget(covariant M3EToolbar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncVisibilityAttachment(oldWidget);
    _applyExitExtent();
    _syncActiveIndex(oldWidget);
    _syncExpandFromWidget(oldWidget);
  }

  void _syncVisibilityAttachment(M3EToolbar oldWidget) {
    if (oldWidget.visibilityController != widget.visibilityController ||
        oldWidget.scrollBehavior?.controller !=
            widget.scrollBehavior?.controller) {
      oldWidget.visibilityController?.detach();
      oldWidget.scrollBehavior?.controller.detach();
      _visibility?.attach(this);
    }
  }

  void _syncActiveIndex(M3EToolbar oldWidget) {
    if (widget.activeIndex != oldWidget.activeIndex &&
        widget.activeIndex != _activeIndex) {
      _activeIndex = widget.activeIndex;
    }
  }

  void _syncExpandFromWidget(M3EToolbar oldWidget) {
    if (!_floating || (!_usesTriggerExpand && !_usesFabExpand)) {
      if (_expandCtrl.value != 1) {
        _expandCtrl.value = 1;
      }
      if (!_expanded) {
        _expanded = true;
      }
      return;
    }

    if (widget.expanded != oldWidget.expanded && widget.expanded != _expanded) {
      _setExpanded(widget.expanded, notify: false);
    }
  }

  @override
  void dispose() {
    _expandCtrl
      ..removeListener(_handleExpandTick)
      ..dispose();
    _visibility?.detach();
    super.dispose();
  }

  void _handleExpandTick() {
    if (!_usesFabExpand) {
      return;
    }
    setState(() {
      _fabSize = _resolvedFabSize(_expandCtrl.value);
    });
  }

  double _resolvedFabSize(double progress) {
    if (_hasFab && !widget.fabExpandsToolbar) {
      return M3EToolbarTokens.fabBaseline;
    }
    return M3EToolbarTokens.fabMedium +
        (M3EToolbarTokens.fabBaseline - M3EToolbarTokens.fabMedium) * progress;
  }

  double get _fabLayoutProgress => _usesFabExpand ? _expandCtrl.value : 1.0;

  void _applyExitExtent() {
    final double? extent = widget.exitExtent ?? _visibility?.exitExtent;
    if (extent != null) {
      _visibility?.offsetLimit = -extent.abs();
    }
  }

  void _setExpanded(bool value, {bool notify = true}) {
    if ((!_usesTriggerExpand && !_usesFabExpand) || _expanded == value) {
      return;
    }
    setState(() => _expanded = value);
    if (notify) {
      widget.onExpandedChanged?.call(value);
    }
    _expandCtrl
      ..motion = m3eToolbarExpandMotion()
      ..animateTo(value ? 1 : 0);
  }

  void _toggleExpanded() => _setExpanded(!_expanded);

  void _onFabPressed() {
    if (_usesFabExpand) {
      _toggleExpanded();
      widget.onFabPressed?.call();
      return;
    }
    widget.onFabPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildToolbar);
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
    final M3EIconButtonSize buttonSize = toolbarTheme.iconButtonSize(
      widget.size,
    );
    final double targetWidth = iconButtonTheme
        .target(buttonSize, M3EIconButtonWidth.defaultWidth)
        .width;
    final double iconPx = iconButtonTheme.iconSize(buttonSize);
    return (targetWidth - iconPx) / 2;
  }

  Widget _withFab(Widget toolbar, M3EToolbarColorStyle style) {
    final Widget expandIcon =
        widget.fabExpandIcon ?? widget.fabIcon ?? const Icon(M3EIcons.add);
    final Widget collapseIcon =
        widget.fabCollapseIcon ?? const Icon(M3EIcons.close);
    final bool fabExpands = widget.fabExpandsToolbar;
    final fabIcon = fabExpands && _expanded ? collapseIcon : expandIcon;
    final VoidCallback? fabOnPressed = widget.floatingActionButton == null
        ? (fabExpands ? _onFabPressed : widget.onFabPressed)
        : widget.onFabPressed;
    final Widget fab = M3EToolbarFabSlot(
      fab: widget.floatingActionButton,
      icon: fabIcon,
      onPressed: fabOnPressed,
      color: style == M3EToolbarColorStyle.vibrant
          ? M3EFabColor.tertiary
          : M3EFabColor.primary,
      containerSize: fabExpands ? _fabSize : M3EToolbarTokens.fabBaseline,
    );

    final horizontal = widget.axis == Axis.horizontal;
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return AnimatedBuilder(
      animation: _expandCtrl,
      builder: (BuildContext context, Widget? child) {
        if (horizontal) {
          final M3EToolbarFabPosition pos =
              widget.fabPosition == M3EToolbarFabPosition.start ||
                  widget.fabPosition == M3EToolbarFabPosition.end
              ? widget.fabPosition
              : M3EToolbarFabPosition.end;
          return M3EToolbarHorizontalFabLayout(
            progress: _fabLayoutProgress,
            fabPosition: pos,
            isRtl: isRtl,
            toolbar: toolbar,
            fab: fab,
          );
        }
        final M3EToolbarFabPosition pos =
            widget.fabPosition == M3EToolbarFabPosition.top ||
                widget.fabPosition == M3EToolbarFabPosition.bottom
            ? widget.fabPosition
            : M3EToolbarFabPosition.bottom;
        return M3EToolbarVerticalFabLayout(
          progress: _fabLayoutProgress,
          fabPosition: pos,
          toolbar: toolbar,
          fab: fab,
        );
      },
    );
  }

  Widget _wrapVisibility(Widget bar) {
    final M3EToolbarVisibilityController? controller = _visibility;
    if (controller == null && widget.scrollBehavior == null) {
      return bar;
    }
    final M3EToolbarVisibilityController resolved =
        controller ?? widget.scrollBehavior!.controller;

    Widget measured = M3EToolbarMeasureSize(
      onChange: (Size size) {
        if (widget.exitExtent != null || resolved.exitExtent != null) {
          final double extent = widget.exitExtent ?? resolved.exitExtent ?? 0;
          resolved.offsetLimit = -extent.abs();
          return;
        }
        final bool vertical =
            _exitDirection == M3EToolbarExitDirection.top ||
            _exitDirection == M3EToolbarExitDirection.bottom;
        final double extent =
            (vertical ? size.height : size.width) +
            M3EToolbarTokens.screenOffset;
        resolved.offsetLimit = -extent;
      },
      child: bar,
    );

    return ClipRect(
      child: ListenableBuilder(
        listenable: resolved,
        builder: (BuildContext context, Widget? child) {
          final Offset offset = _exitOffset(context, resolved.offset);
          final bool hidden = resolved.collapsedFraction >= 1;
          return Transform.translate(
            offset: offset,
            child: ExcludeFocus(excluding: hidden, child: child!),
          );
        },
        child: measured,
      ),
    );
  }

  Offset _exitOffset(BuildContext context, double offset) {
    switch (_exitDirection) {
      case M3EToolbarExitDirection.top:
        return Offset(0, offset);
      case M3EToolbarExitDirection.bottom:
        return Offset(0, -offset);
      case M3EToolbarExitDirection.start:
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        return Offset(isRtl ? -offset : offset, 0);
      case M3EToolbarExitDirection.end:
        final isRtl = Directionality.of(context) == TextDirection.rtl;
        return Offset(isRtl ? offset : -offset, 0);
    }
  }
}
