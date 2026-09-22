import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import '../buttons/utils/m3e_button_gradient_layer.dart';
import '../floating_action_buttons/components/m3e_fab_container_transform.dart';
import '../floating_action_buttons/m3e_floating_action_buttons.dart';
import 'controllers/m3e_fab_menu_controller.dart';
import 'enums/m3e_fab_menu_color_set.dart';
import 'enums/m3e_fab_menu_position.dart';
import 'models/m3e_fab_menu_item.dart';
import 'styles/m3e_fab_menu_theme.dart';

export 'controllers/m3e_fab_menu_controller.dart';
export 'enums/m3e_fab_menu_color_set.dart';
export 'enums/m3e_fab_menu_position.dart';
export 'models/m3e_fab_menu_item.dart';
export 'styles/m3e_fab_menu_theme.dart';

/// A Material 3 Expressive FAB menu.
///
/// Opens from a FAB to show 2–6 related actions. The FAB morphs into a 56dp
/// circular close button while menu pills spring in from the trailing edge.
/// When viewport height is limited, items scroll behind the close button.
class M3EFabMenu extends StatefulWidget {
  /// Creates a FAB menu.
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
    this.controller,
    super.key,
  }) : assert(
         items.length >= 2 && items.length <= 6,
         'A FAB menu needs 2–6 items.',
       );

  /// Menu actions (2–6).
  final List<M3EFabMenuItem> items;

  /// Closed-state FAB icon (alias for [expandIcon] when that is null).
  final Widget icon;

  /// Open-state FAB icon (alias for [collapseIcon] when that is null).
  final Widget closeIcon;

  /// Icon when the menu is closed. Defaults to [icon] (add).
  final Widget? expandIcon;

  /// Icon when the menu is open. Defaults to [closeIcon] (close).
  final Widget? collapseIcon;

  /// FAB / menu color style. Maps to a primary/secondary/tertiary set.
  final M3EFabColor color;

  /// Closed FAB size. Open close button is always 56dp.
  final M3EFabSize size;

  /// Which horizontal corner the open FAB morphs toward.
  final M3EFabMenuPosition position;

  /// Styling for the trigger FAB. Menu items use [M3EFabMenuTheme].
  final M3EFabDecoration? decoration;

  /// Optional controller for programmatic open / close.
  final M3EFabMenuController? controller;

  @override
  State<M3EFabMenu> createState() => _M3EFabMenuState();
}

class _M3EFabMenuState extends State<M3EFabMenu>
    with TickerProviderStateMixin
    implements M3EFabMenuControllerClient {
  final LayerLink _link = LayerLink();
  final GlobalKey _fabKey = GlobalKey();
  final OverlayPortalController _portal = OverlayPortalController();
  final FocusNode _closeFocusNode = FocusNode(debugLabel: 'M3EFabMenuClose');

  late List<SingleMotionController> _itemCtrls;
  late List<bool> _itemVisible;
  late List<GlobalKey> _itemKeys;
  final GlobalKey _itemsStackKey = GlobalKey();

  final ValueNotifier<int?> _focusedItemIndex = ValueNotifier<int?>(null);
  late SingleMotionController _fabShapeCtrl;
  final List<Timer> _staggerTimers = <Timer>[];
  final FocusScopeNode _menuFocusScope = FocusScopeNode(
    debugLabel: 'M3EFabMenu',
    skipTraversal: true,
  );

  bool _open = false;
  M3EFabContainerTransformHandle<dynamic>? _transformHandle;

  SpringMotion _springMotion(M3ESpring spring) =>
      const MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: spring.stiffness,
        damping: spring.damping,
      );

  SpringMotion get _expandMotion =>
      _springMotion(M3ETheme.of(context).fabMenuTheme.expandSpring);

  SpringMotion get _fabShapeMotion =>
      _springMotion(M3ETheme.of(context).fabMenuTheme.fabShapeSpring);

  Duration get _stagger => M3ETheme.of(context).fabMenuTheme.expandStagger;

  static const double _openWidthStart = 0.5;

  Widget get _resolvedExpandIcon => widget.expandIcon ?? widget.icon;

  Widget get _resolvedCollapseIcon => widget.collapseIcon ?? widget.closeIcon;

  bool get _isRight => widget.position == M3EFabMenuPosition.right;

  Alignment get _fabAlign => _isRight ? Alignment.topRight : Alignment.topLeft;

  Alignment get _menuItemAlign =>
      _isRight ? Alignment.centerRight : Alignment.centerLeft;

  M3EFabMenuColorSet get _colorSet => M3EFabMenuTheme.colorSetFor(widget.color);

  @override
  void initState() {
    super.initState();
    _itemCtrls = _createControllers(widget.items.length);
    _itemVisible = List<bool>.filled(widget.items.length, false);
    _itemKeys = List<GlobalKey>.generate(
      widget.items.length,
      (_) => GlobalKey(),
    );
    _fabShapeCtrl = SingleMotionController(
      motion: _springMotion(M3EFabMenuTheme.defaults.fabShapeSpring),
      vsync: this,
    );
    _menuFocusScope.traversalEdgeBehavior = TraversalEdgeBehavior.closedLoop;
    M3EFocusInteraction.instance.addListener(_onFocusInteractionChanged);
    widget.controller?.attachClient(this);
    widget.controller?.updateOpen(open: false);
  }

  void _onFocusInteractionChanged() {
    if (!M3EFocusInteraction.instance.ringsAllowed) {
      _focusedItemIndex.value = null;
    }
  }

  @override
  void didUpdateWidget(covariant M3EFabMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detachClient(this);
      widget.controller?.attachClient(this);
      widget.controller?.updateOpen(open: _open);
    }
    if (oldWidget.items.length != widget.items.length) {
      _disposeItemControllers();
      _itemCtrls = _createControllers(widget.items.length);
      _itemVisible = List<bool>.filled(widget.items.length, _open);
      _itemKeys = List<GlobalKey>.generate(
        widget.items.length,
        (_) => GlobalKey(),
      );
      _focusedItemIndex.value = null;
      if (_open) {
        for (final SingleMotionController c in _itemCtrls) {
          c.value = 1;
        }
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.detachClient(this);
    M3EFocusInteraction.instance.removeListener(_onFocusInteractionChanged);
    _cancelStagger();
    _disposeItemControllers();
    _fabShapeCtrl.dispose();
    _menuFocusScope.dispose();
    _closeFocusNode.dispose();
    _focusedItemIndex.dispose();
    _transformHandle?.close();
    super.dispose();
  }

  List<SingleMotionController> _createControllers(int count) {
    final motion = _springMotion(M3EFabMenuTheme.defaults.expandSpring);
    return List<SingleMotionController>.generate(
      count,
      (_) => SingleMotionController(motion: motion, vsync: this),
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

  @override
  void onOpenRequested() => _openMenu();

  @override
  void onCloseRequested() => _close();

  void _toggle() {
    if (_open) {
      _close();
    } else {
      _openMenu();
    }
  }

  void _scheduleItemReveal(int itemIndex, int delayMs) {
    _staggerTimers.add(
      Timer(Duration(milliseconds: delayMs), () {
        if (!mounted || !_open) {
          return;
        }
        setState(() => _itemVisible[itemIndex] = true);
        _itemCtrls[itemIndex]
          ..motion = _expandMotion
          ..value = 0
          ..animateTo(1);
        // After the last item mounts, focus the close button (spec a11y).
        if (itemIndex == 0) {
          _focusCloseAfterFrame();
        }
      }),
    );
  }

  void _focusCloseAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_open) {
        return;
      }
      _closeFocusNode.requestFocus();
    });
  }

  void _revealMenuItems() {
    _portal.show();
    // Cascade from the FAB upward: bottom item (nearest FAB) first.
    final int count = _itemCtrls.length;
    final int staggerMs = _stagger.inMilliseconds;
    for (var i = 0; i < count; i++) {
      final int fromFab = count - 1 - i;
      _scheduleItemReveal(i, fromFab * staggerMs);
    }
  }

  void _close() {
    if (!_open) {
      return;
    }
    _cancelStagger();
    // Instant hide — no reverse width morph (entry springs only).
    for (final SingleMotionController c in _itemCtrls) {
      c.value = 0;
    }
    _itemVisible = List<bool>.filled(_itemCtrls.length, false);
    _focusedItemIndex.value = null;
    _closeFocusNode.unfocus();
    _portal.hide();
    setState(() => _open = false);
    widget.controller?.updateOpen(open: false);
    _fabShapeCtrl
      ..motion = _fabShapeMotion
      ..animateTo(0);
  }

  void _openMenu() {
    if (_open) {
      return;
    }
    _cancelStagger();
    for (final SingleMotionController c in _itemCtrls) {
      c.value = 0;
    }
    _itemVisible = List<bool>.filled(_itemCtrls.length, false);
    _focusedItemIndex.value = null;
    setState(() => _open = true);
    widget.controller?.updateOpen(open: true);
    _fabShapeCtrl
      ..motion = _fabShapeMotion
      ..animateTo(1);
    _revealMenuItems();
  }

  Future<void> _openItemTransform(M3EFabMenuItem item, int index) async {
    if (_transformHandle != null || item.openBuilder == null) {
      return;
    }
    final BuildContext? originContext = _itemKeys[index].currentContext;
    if (originContext == null || !originContext.mounted) {
      return;
    }
    final RenderObject? renderObject = originContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return;
    }
    final theme = M3ETheme.of(context);
    final fabMenuTheme = theme.fabMenuTheme;
    final Rect origin =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final handle = M3EFabContainerTransform.show(
      context: context,
      origin: origin,
      originRadius: fabMenuTheme.itemHeight / 2,
      originColor: fabMenuTheme.itemContainerColor(
        theme.colorScheme,
        _colorSet,
      ),
      openColor: item.openColor,
      scrimColor: item.transformScrimColor,
      builder: item.openBuilder!,
    );
    _transformHandle = handle;
    item.onPressed?.call();
    await handle.future;
    _transformHandle = null;
  }

  Future<void> _onItemTap(M3EFabMenuItem item, int index) async {
    if (item.openBuilder != null) {
      await _openItemTransform(item, index);
    } else {
      item.onPressed?.call();
    }
    if (mounted) {
      _close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (BuildContext context) {
        final theme = M3ETheme.of(context);
        final fabMenuTheme = theme.fabMenuTheme;
        final fabTheme = theme.fabTheme;
        final metrics = fabTheme.resolve(
          size: widget.size,
          color: widget.color,
          scheme: theme.colorScheme,
        );
        final double closedSize = fabMenuTheme.resolveClosedContainer(
          size: widget.size,
          fabTheme: fabTheme,
        );
        final double openSize = fabMenuTheme.openFabContainer;
        final double closedRadius = metrics.radius;
        final double openRadius = openSize / 2;
        return OverlayPortal(
          controller: _portal,
          overlayChildBuilder: (BuildContext context) => _buildOverlay(
            context,
            closedSize: closedSize,
            openSize: openSize,
          ),
          child: CompositedTransformTarget(
            link: _link,
            child: AnimatedBuilder(
              animation: _fabShapeCtrl,
              builder: (BuildContext context, Widget? child) {
                final double t = _fabShapeCtrl.value;
                final double radius = lerpDouble(closedRadius, openRadius, t)!;
                final double fabSize = lerpDouble(closedSize, openSize, t)!;
                final M3EFabColor closeColor = M3EFabMenuTheme.closeFabColor(
                  _colorSet,
                );
                final bool showClose = t > 0.5;
                final double regularIcon = fabTheme
                    .resolve(
                      size: M3EFabSize.regular,
                      color: closeColor,
                      scheme: theme.colorScheme,
                    )
                    .iconSize;
                final double iconSize = lerpDouble(
                  metrics.iconSize,
                  fabMenuTheme.closeIconSize,
                  t.clamp(0.0, 1.0),
                )!;
                // Morph toward the top trailing corner (shared with the bottom
                // of the menu stack / close button top).
                return SizedBox(
                  key: _fabKey,
                  width: closedSize,
                  height: closedSize,
                  child: Align(
                    alignment: _fabAlign,
                    child: Opacity(
                      // Overlay owns the interactive close while open.
                      opacity: _open ? 0 : 1,
                      child: IgnorePointer(
                        ignoring: _open,
                        child: SizedBox(
                          width: fabSize,
                          height: fabSize,
                          child: FittedBox(
                            child: Semantics(
                              button: true,
                              label: 'Toggle menu',
                              expanded: _open,
                              child: M3EFab(
                                icon: Transform.scale(
                                  scale: iconSize / regularIcon,
                                  child: showClose
                                      ? _resolvedCollapseIcon
                                      : _resolvedExpandIcon,
                                ),
                                color: showClose ? closeColor : widget.color,
                                size: showClose
                                    ? M3EFabSize.regular
                                    : widget.size,
                                cornerRadius: radius,
                                decoration: showClose
                                    ? null
                                    : widget.decoration,
                                elevation: fabMenuTheme.closeElevation,
                                hoverElevation:
                                    fabMenuTheme.closeHoverElevation,
                                onPressed: _toggle,
                              ),
                            ),
                          ),
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

  Widget _buildOverlay(
    BuildContext context, {
    required double closedSize,
    required double openSize,
  }) {
    final bool right = _isRight;
    // Close top trailing corner shares the FAB's top trailing morph anchor.
    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: FocusScope(
        node: _menuFocusScope,
        skipTraversal: true,
        child: CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.escape): _close,
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              _buildDismissBarrier(context),
              CompositedTransformFollower(
                link: _link,
                showWhenUnlinked: false,
                targetAnchor: right ? Alignment.topRight : Alignment.topLeft,
                followerAnchor: right ? Alignment.topRight : Alignment.topLeft,
                child: _buildMenuStack(
                  context,
                  closedSize: closedSize,
                  openSize: openSize,
                ),
              ),
            ],
          ),
        ),
      ),
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

  double _spaceAboveFab() {
    final box = _fabKey.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize) {
      return 240;
    }
    final fabTop = box.localToGlobal(Offset.zero).dy;
    final safeTop = MediaQuery.paddingOf(context).top;
    return (fabTop - safeTop).clamp(0.0, double.infinity);
  }

  Widget _buildMenuStack(
    BuildContext context, {
    required double closedSize,
    required double openSize,
  }) {
    final theme = M3ETheme.of(context);
    final fabMenuTheme = theme.fabMenuTheme;
    final double spaceAbove = _spaceAboveFab();
    final double mediaWidth = MediaQuery.sizeOf(context).width;

    // Shift upward so the closed-FAB-sized close slot sits on the FAB top
    // trailing corner, while the full scroll area (above + slot) receives hits.
    return Transform.translate(
      offset: Offset(0, -spaceAbove),
      child: SizedBox(
        width: mediaWidth,
        height: spaceAbove + closedSize,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              // Clear the closed-size close slot (top-trailing morph anchor) plus
              // menuOffset — not openSize, or medium/large FABs overlap items.
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: closedSize + fabMenuTheme.menuOffset,
                ),
                child: Align(
                  alignment: _isRight
                      ? Alignment.bottomRight
                      : Alignment.bottomLeft,
                  child: SingleChildScrollView(
                    reverse: true,
                    child: _buildItemsColumn(theme),
                  ),
                ),
              ),
            ),
            Positioned(
              right: _isRight ? 0 : null,
              left: _isRight ? null : 0,
              bottom: 0,
              width: closedSize,
              height: closedSize,
              child: Align(
                alignment: _fabAlign,
                child: FocusTraversalOrder(
                  order: const NumericFocusOrder(0),
                  child: _buildOverlayClose(theme, openSize: openSize),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlayClose(M3EThemeData theme, {required double openSize}) {
    final fabMenuTheme = theme.fabMenuTheme;
    final fabTheme = theme.fabTheme;
    final M3EFabColor closeColor = M3EFabMenuTheme.closeFabColor(_colorSet);
    final double closedSize = fabMenuTheme.resolveClosedContainer(
      size: widget.size,
      fabTheme: fabTheme,
    );
    final metrics = fabTheme.resolve(
      size: widget.size,
      color: widget.color,
      scheme: theme.colorScheme,
    );
    final double closedRadius = metrics.radius;
    final double openRadius = openSize / 2;
    final double regularIcon = fabTheme
        .resolve(
          size: M3EFabSize.regular,
          color: closeColor,
          scheme: theme.colorScheme,
        )
        .iconSize;

    return AnimatedBuilder(
      animation: _fabShapeCtrl,
      builder: (BuildContext context, Widget? child) {
        final double t = _fabShapeCtrl.value.clamp(0.0, 1.0);
        // Shrink toward top trailing: large closed square → 56 circle.
        final double fabSize = lerpDouble(closedSize, openSize, t)!;
        final double radius = lerpDouble(closedRadius, openRadius, t)!;
        final double iconSize = lerpDouble(
          metrics.iconSize,
          fabMenuTheme.closeIconSize,
          t,
        )!;
        final double iconScale = iconSize / regularIcon;
        final bool filled = t > 0.35;
        return Align(
          alignment: _fabAlign,
          child: Semantics(
            button: true,
            label: 'Toggle menu',
            expanded: true,
            child: SizedBox(
              width: fabSize,
              height: fabSize,
              child: FittedBox(
                child: M3EFab(
                  focusNode: _closeFocusNode,
                  icon: Transform.scale(
                    scale: iconScale,
                    child: t > 0.5
                        ? _resolvedCollapseIcon
                        : _resolvedExpandIcon,
                  ),
                  color: filled ? closeColor : widget.color,
                  size: filled ? M3EFabSize.regular : widget.size,
                  cornerRadius: radius,
                  decoration: filled ? null : widget.decoration,
                  elevation: fabMenuTheme.closeElevation,
                  hoverElevation: fabMenuTheme.closeHoverElevation,
                  onPressed: _close,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemsColumn(M3EThemeData theme) {
    final fabMenuTheme = theme.fabMenuTheme;
    // Stack paints the focus ring after all pills so neighbors cannot cover it.
    // (itemGap 4 < ring outset 5; overlay transforms also defeat elevation.)
    return Stack(
      key: _itemsStackKey,
      clipBehavior: Clip.none,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: _isRight
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: <Widget>[
            for (int i = 0; i < widget.items.length; i++)
              if (_itemVisible[i])
                FocusTraversalOrder(
                  order: NumericFocusOrder(i + 1.0),
                  child: Padding(
                    key: ValueKey<Object>('fab-menu-item-$i'),
                    padding: EdgeInsets.only(
                      bottom: i == widget.items.length - 1
                          ? 0
                          : fabMenuTheme.itemGap,
                    ),
                    child: _buildItem(theme, widget.items[i], i),
                  ),
                ),
          ],
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: ValueListenableBuilder<int?>(
              valueListenable: _focusedItemIndex,
              builder: (BuildContext context, int? focusedIndex, _) {
                if (focusedIndex == null) {
                  return const SizedBox.shrink();
                }
                return AnimatedBuilder(
                  animation: _itemCtrls[focusedIndex],
                  builder: (BuildContext context, _) {
                    return _buildFocusedItemRing(theme, focusedIndex);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFocusedItemRing(M3EThemeData theme, int index) {
    final stackBox =
        _itemsStackKey.currentContext?.findRenderObject() as RenderBox?;
    final itemBox =
        _itemKeys[index].currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null ||
        itemBox == null ||
        !stackBox.hasSize ||
        !itemBox.hasSize) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _focusedItemIndex.value == index) {
          setState(() {});
        }
      });
      return const SizedBox.shrink();
    }

    final topLeft = itemBox.localToGlobal(Offset.zero, ancestor: stackBox);
    final fabMenuTheme = theme.fabMenuTheme;
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        Positioned(
          left: topLeft.dx,
          top: topLeft.dy,
          width: itemBox.size.width,
          height: itemBox.size.height,
          child: M3EFocusRing(
            focused: true,
            radius: BorderRadius.circular(fabMenuTheme.itemHeight / 2),
            width: fabMenuTheme.focusRingWidth,
            gap: fabMenuTheme.focusRingGap,
            color: fabMenuTheme.resolveFocusRingColor(theme.colorScheme),
            child: const SizedBox.expand(),
          ),
        ),
      ],
    );
  }

  void _setItemFocused(int index, bool focused) {
    final bool show = focused && M3EFocusInteraction.instance.ringsAllowed;
    final int? next = show ? index : null;
    if (_focusedItemIndex.value == next) {
      return;
    }
    if (!show && _focusedItemIndex.value != index) {
      return;
    }
    _focusedItemIndex.value = next;
  }

  double _widthFactor(double t) =>
      _openWidthStart + (1.0 - _openWidthStart) * t;

  Widget _buildItem(M3EThemeData theme, M3EFabMenuItem item, int index) {
    final scheme = theme.colorScheme;
    final fabMenuTheme = theme.fabMenuTheme;
    final SingleMotionController ctrl = _itemCtrls[index];
    final Gradient? fill = fabMenuTheme.itemBackgroundGradient;
    final Color containerColor = fabMenuTheme.itemContainerColor(
      scheme,
      _colorSet,
    );

    // Only the pill container width springs (and may overshoot). Icon + label
    // stay at their intrinsic size, edge-aligned, and clipped by the stadium.
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
          child: KeyedSubtree(
            key: _itemKeys[index],
            child: _itemOutline(
              fabMenuTheme,
              Material(
                color: fill == null ? containerColor : const Color(0x00000000),
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
          ),
        );
      },
      child: M3ETappable(
        onTap: () => _onItemTap(item, index),
        semanticLabel: item.label,
        materialInk: true,
        onStateChanged: (M3EInteractionState state) =>
            _setItemFocused(index, state.focused),
        builder: (BuildContext context, M3EInteractionState state) {
          return _itemBody(theme, item, scheme, state);
        },
      ),
    );
  }

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
        ? fabMenuTheme.itemForegroundColor(scheme, _colorSet)
        : m3eGradientForegroundSourceColor;
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ExcludeSemantics(
          child: IconTheme.merge(
            data: IconThemeData(
              color: contentColor,
              size: fabMenuTheme.iconSize,
            ),
            child: item.icon,
          ),
        ),
        SizedBox(width: fabMenuTheme.iconLabelGap),
        Text(
          item.label,
          style: fabMenuTheme
              .itemLabelStyle(theme.typeScale, scheme, _colorSet)
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
        color: fabMenuTheme.itemForegroundColor(scheme, _colorSet),
        shape: M3EShapes.stadium,
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: fabMenuTheme.itemLeading,
            end: fabMenuTheme.itemTrailing,
          ),
          child: content,
        ),
      ),
    );
  }
}
