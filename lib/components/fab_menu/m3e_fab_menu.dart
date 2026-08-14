import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import '../buttons/utils/m3e_button_gradient_layer.dart';
import '../floating_action_buttons/enums/m3e_fab.dart';
import '../floating_action_buttons/m3e_floating_action_buttons.dart';
import 'enums/m3e_fab_menu_position.dart';
import 'models/m3e_fab_menu_item.dart';
import 'styles/m3e_fab_menu_theme.dart';

export 'enums/m3e_fab_menu_position.dart';
export 'models/m3e_fab_menu_item.dart';
export 'styles/m3e_fab_menu_theme.dart';

/// A Material 3 Expressive FAB menu.
///
/// Items stay hidden while closed. On open the FAB shrinks (80→56) and morphs
/// rounded-square ↔ circle while menu pills appear at ~50% width and spring
/// from the [position] edge. On close, items hide immediately and the FAB
/// grows back to the large square.
class M3EFabMenu extends StatefulWidget {
  /// M3EFabMenu.
  const M3EFabMenu({
    required this.items,
    this.icon = const Icon(M3EIcons.add),
    this.closeIcon = const Icon(M3EIcons.close),
    this.expandIcon,
    this.collapseIcon,
    this.color = M3EFabColor.primary,
    this.size = M3EFabSize.medium,
    this.position = M3EFabMenuPosition.right,
    this.decoration,
    super.key,
  }) : assert(items.length > 0, 'A FAB menu needs at least one item.');

  /// items.

  final List<M3EFabMenuItem> items;

  /// Closed-state FAB icon (alias for [expandIcon] when that is null).
  final Widget icon;

  /// Open-state FAB icon (alias for [collapseIcon] when that is null).
  final Widget closeIcon;

  /// Icon when the menu is closed. Defaults to [icon] (add).
  final Widget? expandIcon;

  /// Icon when the menu is open. Defaults to [closeIcon] (close).
  final Widget? collapseIcon;

  /// color.
  final M3EFabColor color;

  /// size.
  final M3EFabSize size;

  /// Which horizontal corner the open FAB morphs toward, and from which edge
  /// menu items grow. Defaults to [M3EFabMenuPosition.right].
  final M3EFabMenuPosition position;

  /// Styling for the trigger FAB. Menu items are styled by `M3EFabMenuTheme`.
  final M3EFabDecoration? decoration;

  @override
  State<M3EFabMenu> createState() => _M3EFabMenuState();
}

class _M3EFabMenuState extends State<M3EFabMenu> with TickerProviderStateMixin {
  final LayerLink _link = LayerLink();
  final OverlayPortalController _portal = OverlayPortalController();

  late List<SingleMotionController> _itemCtrls;
  late List<bool> _itemVisible;
  late SingleMotionController _fabShapeCtrl;
  final List<Timer> _staggerTimers = <Timer>[];

  bool _open = false;

  /// Expand: expressiveSpatialDefault with lower damping for left-end overshoot.
  SpringMotion get _expandMotion =>
      const MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        damping: 0.55,
      );

  /// FAB shape morph: same spatial spring, slightly more damped.
  SpringMotion get _fabShapeMotion =>
      const MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        damping: 0.7,
      );

  static const int _expandStaggerMs = 30;

  /// Width factor when an item first becomes visible (then springs to 1.0).
  static const double _openWidthStart = 0.5;

  Widget get _resolvedExpandIcon => widget.expandIcon ?? widget.icon;

  Widget get _resolvedCollapseIcon => widget.collapseIcon ?? widget.closeIcon;

  bool get _isRight => widget.position == M3EFabMenuPosition.right;

  Alignment get _fabAlign => _isRight ? Alignment.topRight : Alignment.topLeft;

  Alignment get _menuItemAlign =>
      _isRight ? Alignment.centerRight : Alignment.centerLeft;

  @override
  void initState() {
    super.initState();
    _itemCtrls = _createControllers(widget.items.length);
    _itemVisible = List<bool>.filled(widget.items.length, false);
    _fabShapeCtrl = SingleMotionController(
      motion: _fabShapeMotion,
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(covariant M3EFabMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items.length != widget.items.length) {
      _disposeItemControllers();
      _itemCtrls = _createControllers(widget.items.length);
      _itemVisible = List<bool>.filled(widget.items.length, _open);
      if (_open) {
        for (final SingleMotionController c in _itemCtrls) {
          c.value = 1;
        }
      }
    }
  }

  @override
  void dispose() {
    _cancelStagger();
    _disposeItemControllers();
    _fabShapeCtrl.dispose();
    super.dispose();
  }

  List<SingleMotionController> _createControllers(int count) {
    return List<SingleMotionController>.generate(
      count,
      (_) => SingleMotionController(motion: _expandMotion, vsync: this),
    );
  }

  void _disposeItemControllers() {
    for (final SingleMotionController c in _itemCtrls) {
      c.dispose();
    }
  }

  void _cancelStagger() {
    for (final Timer t in _staggerTimers) {
      t.cancel();
    }
    _staggerTimers.clear();
  }

  void _toggle() {
    if (_open) {
      _close();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    _cancelStagger();
    for (final SingleMotionController c in _itemCtrls) {
      c.value = 0;
    }
    _itemVisible = List<bool>.filled(_itemCtrls.length, false);
    setState(() => _open = true);
    // FAB size/radius morph and menu item cascade run together.
    _fabShapeCtrl
      ..motion = _fabShapeMotion
      ..animateTo(1);
    _revealMenuItems();
  }

  void _revealMenuItems() {
    _portal.show();
    // Cascade from the FAB upward: bottom item (nearest FAB) first.
    final int count = _itemCtrls.length;
    for (var i = 0; i < count; i++) {
      final int fromFab = count - 1 - i;
      final int delayMs = fromFab * _expandStaggerMs;
      _staggerTimers.add(
        Timer(Duration(milliseconds: delayMs), () {
          if (!mounted || !_open) {
            return;
          }
          setState(() => _itemVisible[i] = true);
          _itemCtrls[i]
            ..motion = _expandMotion
            ..value = 0
            ..animateTo(1);
        }),
      );
    }
  }

  void _close() {
    if (!_open) {
      return;
    }
    _cancelStagger();
    // Instant hide — no reverse width morph.
    for (final SingleMotionController c in _itemCtrls) {
      c.value = 0;
    }
    _itemVisible = List<bool>.filled(_itemCtrls.length, false);
    _portal.hide();
    setState(() => _open = false);
    // FAB morphs back to large rounded square while items are already gone.
    _fabShapeCtrl
      ..motion = _fabShapeMotion
      ..animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (BuildContext context) {
        final theme = M3ETheme.of(context);
        final fabMenuTheme = theme.fabMenuTheme;
        final metrics = theme.fabTheme.resolve(
          size: widget.size,
          color: widget.color,
          scheme: theme.colorScheme,
        );
        final double closedRadius = metrics.radius;
        final double openRadius = metrics.container / 2;

        return OverlayPortal(
          controller: _portal,
          overlayChildBuilder: _buildOverlay,
          child: CompositedTransformTarget(
            link: _link,
            child: AnimatedBuilder(
              animation: _fabShapeCtrl,
              builder: (BuildContext context, Widget? child) {
                final double t = _fabShapeCtrl.value;
                final double radius = lerpDouble(closedRadius, openRadius, t)!;
                final double fabSize = lerpDouble(
                  fabMenuTheme.closedFabContainer,
                  fabMenuTheme.openFabContainer,
                  t,
                )!;
                return SizedBox(
                  width: fabMenuTheme.closedFabContainer,
                  height: fabMenuTheme.closedFabContainer,
                  child: Align(
                    alignment: _fabAlign,
                    child: SizedBox(
                      width: fabSize,
                      height: fabSize,
                      child: FittedBox(
                        child: M3EFab(
                          icon: _open
                              ? _resolvedCollapseIcon
                              : _resolvedExpandIcon,
                          color: widget.color,
                          size: widget.size,
                          cornerRadius: radius,
                          decoration: widget.decoration,
                          onPressed: _toggle,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final bool right = _isRight;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        _buildDismissBarrier(context),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: right ? Alignment.topRight : Alignment.topLeft,
          followerAnchor: right ? Alignment.bottomRight : Alignment.bottomLeft,
          offset: Offset(0, -M3ETheme.of(context).fabMenuTheme.menuOffset),
          child: _buildMenu(context),
        ),
      ],
    );
  }

  Widget _buildDismissBarrier(BuildContext context) {
    final theme = M3ETheme.of(context);
    final fabMenuTheme = theme.fabMenuTheme;
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _close,
        child: ColoredBox(color: fabMenuTheme.scrimColor(theme.colorScheme)),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    final theme = M3ETheme.of(context);
    final fabMenuTheme = theme.fabMenuTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: _isRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < widget.items.length; i++)
          if (_itemVisible[i])
            Padding(
              padding: EdgeInsets.only(
                bottom: _isLastVisibleItem(i) ? 0 : fabMenuTheme.itemGap,
              ),
              child: _buildItem(theme, widget.items[i], i),
            ),
      ],
    );
  }

  bool _isLastVisibleItem(int index) {
    for (int i = index + 1; i < _itemVisible.length; i++) {
      if (_itemVisible[i]) {
        return false;
      }
    }
    return true;
  }

  /// Maps spring progress `t` (0→1, may overshoot) to width factor.
  /// Starts at [_openWidthStart] (~50%) and reaches 1.0 at rest.
  double _widthFactor(double t) =>
      _openWidthStart + (1.0 - _openWidthStart) * t;

  Widget _buildItem(M3EThemeData theme, M3EFabMenuItem item, int index) {
    final scheme = theme.colorScheme;
    final fabMenuTheme = theme.fabMenuTheme;
    final SingleMotionController ctrl = _itemCtrls[index];
    final Gradient? fill = fabMenuTheme.itemBackgroundGradient;

    // Only the pill width springs (and may overshoot). Icon + label stay at
    // their intrinsic size, edge-aligned, and clipped by the stadium shape.
    return AnimatedBuilder(
      animation: ctrl,
      builder: (BuildContext context, Widget? child) {
        final double widthFactor = _widthFactor(ctrl.value).clamp(0.001, 1.5);
        final Alignment edge = _menuItemAlign;
        final Widget body = Align(
          alignment: edge,
          widthFactor: widthFactor,
          child: child,
        );

        return Align(
          alignment: edge,
          child: _itemOutline(
            fabMenuTheme,
            Material(
              color: fill == null
                  ? fabMenuTheme.itemContainerColor(scheme)
                  : const Color(0x00000000),
              elevation: fabMenuTheme.itemElevation,
              shadowColor: scheme.shadow,
              surfaceTintColor: const Color(0x00000000),
              shape: const StadiumBorder(),
              clipBehavior: Clip.antiAlias,
              child: fill == null
                  ? body
                  : DecoratedBox(
                      decoration: BoxDecoration(gradient: fill),
                      child: body,
                    ),
            ),
          ),
        );
      },
      child: M3ETappable(
        onTap: () {
          item.onPressed?.call();
          _close();
        },
        semanticLabel: item.label,
        materialInk: true,
        builder: (BuildContext context, M3EInteractionState state) {
          return _itemBody(theme, item, scheme, state);
        },
      ),
    );
  }

  /// Strokes the pill edge with the item outline color or gradient.
  Widget _itemOutline(M3EFabMenuTheme fabMenuTheme, Widget child) {
    final Gradient? gradient = fabMenuTheme.itemOutlineGradient;
    final Color? color = fabMenuTheme.itemOutlineColor;
    if (gradient == null && color == null) {
      return child;
    }
    return m3eGradientOutlineLayer(
      clipRadius: BorderRadius.circular(fabMenuTheme.itemHeight / 2),
      gradient: gradient,
      color: gradient == null ? color : null,
      width: fabMenuTheme.itemBorderWidth,
      child: child,
    );
  }

  Widget _itemBody(
    M3EThemeData theme,
    M3EFabMenuItem item,
    M3EColorScheme scheme,
    M3EInteractionState state,
  ) {
    final fabMenuTheme = theme.fabMenuTheme;
    final Gradient? foreground = fabMenuTheme.itemForegroundGradient;
    final Color contentColor = foreground == null
        ? fabMenuTheme.itemForegroundColor(scheme)
        : m3eGradientForegroundSourceColor;
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconTheme.merge(
          data: IconThemeData(color: contentColor, size: fabMenuTheme.iconSize),
          child: item.icon,
        ),
        SizedBox(width: fabMenuTheme.iconLabelGap),
        Text(
          item.label,
          style: fabMenuTheme
              .itemLabelStyle(theme.typeScale, scheme)
              .copyWith(color: contentColor),
        ),
      ],
    );
    if (foreground != null) {
      content = ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (Rect bounds) => foreground.createShader(bounds),
        child: content,
      );
    }
    return SizedBox(
      height: fabMenuTheme.itemHeight,
      child: M3EStateLayerOverlay(
        state: state,
        // Ripple keeps the solid color so it reads on any fill.
        color: fabMenuTheme.itemForegroundColor(scheme),
        shape: M3EShapes.stadium,
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: fabMenuTheme.itemHorizontalPadding,
          ),
          child: content,
        ),
      ),
    );
  }
}
