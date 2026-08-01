import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/menus/m3e_menus.dart'
    show M3EMenu;
import 'package:material_3_expressive/material_3_expressive.dart' show M3EMenu;
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_menu_anchor_position.dart';
import '../enums/m3e_menu_color_style.dart';
import '../models/m3e_menu_node.dart';
import '../styles/m3e_menu_theme.dart';
import '../utils/m3e_menu_placer.dart';
import '../utils/m3e_menu_spring_motion.dart';
import 'm3e_menu_content.dart';
import 'm3e_menu_style_scope.dart';

/// Shows an expressive menu popup anchored to [anchor].
///
/// Returns the selected value from a [M3EMenuSelectable] / [M3EMenuEntry.value],
/// or `null` if dismissed.
Future<T?> showM3EMenu<T>({
  required BuildContext context,
  required Rect anchor,
  required List<M3EMenuNode> children,
  M3EMenuAnchorPosition position = M3EMenuAnchorPosition.bottomEnd,
  M3EMenuColorStyle colorStyle = M3EMenuColorStyle.standard,
  T? selectedValue,
  bool closeOnSelect = true,
  double? preferredWidth,
  FocusNode? callerFocusNode,
  M3EMenuTheme? themeOverride,
}) {
  final completer = Completer<T?>();
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (BuildContext overlayContext) {
      return M3EMenuPopup<T>(
        anchor: anchor,
        children: children,
        position: position,
        colorStyle: colorStyle,
        selectedValue: selectedValue,
        closeOnSelect: closeOnSelect,
        preferredWidth: preferredWidth,
        callerFocusNode: callerFocusNode,
        themeOverride: themeOverride,
        onSelected: (Object? value) => _completeOnce(completer, value as T?),
        onDismiss: () => _completeOnce(completer, null),
        onRemove: () => entry.remove(),
      );
    },
  );
  Overlay.of(context, rootOverlay: true).insert(entry);
  return completer.future;
}

void _completeOnce<T>(Completer<T?> completer, T? value) {
  if (!completer.isCompleted) {
    completer.complete(value);
  }
}

/// Overlay surface for [showM3EMenu] / [M3EMenu] (Compose `DropdownMenuPopup`).
class M3EMenuPopup<T> extends StatefulWidget {
  /// M3EMenuPopup.
  const M3EMenuPopup({
    required this.anchor,
    required this.children,
    required this.onSelected,
    required this.onDismiss,
    required this.onRemove,
    this.position = M3EMenuAnchorPosition.bottomEnd,
    this.colorStyle = M3EMenuColorStyle.standard,
    this.selectedValue,
    this.closeOnSelect = true,
    this.preferredWidth,
    this.callerFocusNode,
    this.themeOverride,
    super.key,
  });

  /// anchor.

  final Rect anchor;

  /// children.
  final List<M3EMenuNode> children;

  /// position.
  final M3EMenuAnchorPosition position;

  /// colorStyle.
  final M3EMenuColorStyle colorStyle;

  /// selectedValue.
  final T? selectedValue;

  /// closeOnSelect.
  final bool closeOnSelect;

  /// preferredWidth.
  final double? preferredWidth;

  /// callerFocusNode.
  final FocusNode? callerFocusNode;

  /// themeOverride.
  final M3EMenuTheme? themeOverride;

  /// onSelected.
  final ValueChanged<Object?> onSelected;

  /// onDismiss.
  final VoidCallback onDismiss;

  /// onRemove.
  final VoidCallback onRemove;

  @override
  State<M3EMenuPopup<T>> createState() => _M3EMenuPopupState<T>();
}

class _M3EMenuPopupState<T> extends State<M3EMenuPopup<T>>
    with SingleTickerProviderStateMixin {
  late final SingleMotionController _expandCtrl;
  bool _isDismissing = false;
  bool _selected = false;
  bool _removed = false;
  late final bool _keyboardActivated;

  OverlayEntry? _submenuEntry;

  final FocusScopeNode _focusScopeNode = FocusScopeNode(
    debugLabel: 'M3EMenuPopup',
  );

  M3EMenuTheme get _menuTheme =>
      widget.themeOverride ?? M3ETheme.of(context).menuTheme;

  @override
  void initState() {
    super.initState();
    _keyboardActivated = widget.callerFocusNode?.hasFocus ?? false;

    // Same controller setup as [M3EDropdownMenu].
    _expandCtrl =
        SingleMotionController(
            motion: M3EMotion.expressiveSpatialDefault.toMotion(),
            vsync: this,
          )
          ..addListener(_onExpandTick)
          // Expand immediately after insert (dropdown calls animateTo right after show).
          ..animateTo(1);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      // Apply theme open spring if it differs from the default used above.
      final open = _menuTheme.openMotion;
      _expandCtrl.motion = open.toMotion();
      if (_expandCtrl.value < 1) {
        _expandCtrl.animateTo(1);
      }
      _focusScopeNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _expandCtrl
      ..removeListener(_onExpandTick)
      ..dispose();
    _removeSubmenu();
    _focusScopeNode.dispose();
    super.dispose();
  }

  void _onExpandTick() {
    if (_isDismissing && !_removed && _expandCtrl.value <= 0.01 && mounted) {
      _removed = true;
      widget.onRemove();
    }
  }

  void _removeSubmenu() {
    _submenuEntry?.remove();
    _submenuEntry = null;
  }

  void _dismiss({bool restoreFocus = false}) {
    if (_isDismissing) {
      return;
    }
    _removeSubmenu();
    if (!_selected) {
      widget.onDismiss();
    }
    _isDismissing = true;
    if (_keyboardActivated && restoreFocus) {
      widget.callerFocusNode?.requestFocus();
    }
    _expandCtrl.motion = _menuTheme.closeMotion.toMotion();
    _expandCtrl.animateTo(0);
  }

  void _handleSelect(Object? value) {
    _selected = true;
    widget.onSelected(value);
    _dismiss(restoreFocus: _focusScopeNode.hasFocus);
  }

  void _openSubmenu(Rect itemRect, List<M3EMenuNode> children) {
    _removeSubmenu();
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext context) {
        return M3EMenuPopup<T>(
          anchor: itemRect,
          children: children,
          position: M3EMenuAnchorPosition.end,
          colorStyle: widget.colorStyle,
          selectedValue: widget.selectedValue,
          closeOnSelect: widget.closeOnSelect,
          callerFocusNode: widget.callerFocusNode,
          themeOverride: widget.themeOverride,
          onSelected: (Object? value) {
            _selected = true;
            widget.onSelected(value);
            _dismiss(restoreFocus: _focusScopeNode.hasFocus);
          },
          onDismiss: () {
            entry.remove();
            _submenuEntry = null;
          },
          onRemove: () {
            entry.remove();
            _submenuEntry = null;
          },
        );
      },
    );
    _submenuEntry = entry;
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final menuTheme = widget.themeOverride ?? theme.menuTheme;
    final scheme = theme.colorScheme;
    final placement = M3EMenuPlacer.compute(
      screenSize: MediaQuery.sizeOf(context),
      anchorRect: widget.anchor,
      theme: menuTheme,
      position: widget.position,
      textDirection: Directionality.of(context),
      approximateItemCount: M3EMenuPlacer.approximateItemCount(widget.children),
      preferredWidth: widget.preferredWidth,
    );
    // Same vertical scale origin as [M3EDropdownMenu] panel.
    final scaleAlignment = placement.opensAbove
        ? Alignment.bottomCenter
        : Alignment.topCenter;

    // No system-bar overlay override — menus use a transparent dismiss layer,
    // not a dark scrim that needs light status/nav icons.
    return FocusScope(
      node: _focusScopeNode,
      child: Focus(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: _onKeyEvent,
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _dismiss,
                child: ColoredBox(color: menuTheme.scrimColor(scheme)),
              ),
            ),
            Positioned(
              left: placement.left,
              width: placement.width,
              top: placement.top,
              bottom: placement.bottom,
              child: AnimatedBuilder(
                animation: _expandCtrl,
                builder: (BuildContext context, Widget? child) {
                  return _expandTransform(
                    progress: _expandCtrl.value,
                    scaleAlignment: scaleAlignment,
                    child: child,
                  );
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: menuTheme.minWidth,
                    maxWidth: placement.width,
                    maxHeight: placement.maxHeight,
                  ),
                  child: _buildSurfaces(menuTheme: menuTheme, scheme: scheme),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event.logicalKey != LogicalKeyboardKey.escape) {
      return KeyEventResult.ignored;
    }
    if (event is KeyDownEvent) {
      _dismiss(restoreFocus: true);
    }
    return KeyEventResult.handled;
  }

  Widget _expandTransform({
    required double progress,
    required Alignment scaleAlignment,
    required Widget? child,
  }) {
    // Exact same transform as dropdown panel expand/collapse.
    final clampedProgress = progress.clamp(0.0, 1.5);
    final clampedScale = clampedProgress.clamp(0.0, 1.2);
    if (clampedProgress <= 0.01) {
      return const SizedBox.shrink();
    }
    return Opacity(
      opacity: clampedProgress.clamp(0.0, 1.0),
      child: Transform.scale(
        alignment: scaleAlignment,
        scaleY: clampedScale,
        child: child,
      ),
    );
  }

  Widget _buildSurfaces({
    required M3EMenuTheme menuTheme,
    required M3EColorScheme scheme,
  }) {
    final palette = menuTheme.colors(scheme, widget.colorStyle);
    // Ambient blur reaches ~2x elevation; keep it inside the scroll viewport.
    // Do not clip the same box that paints [boxShadow] — that hides elevation.
    final double shadowPad = menuTheme.elevation * 2;
    final surfaces = m3eMenuPartitionSurfaces(widget.children);
    final cards = <Widget>[];
    for (var i = 0; i < surfaces.length; i++) {
      if (i > 0) {
        cards.add(SizedBox(height: menuTheme.sectionGap));
      }
      final surface = surfaces[i];
      cards.add(
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: menuTheme.borderRadius,
            boxShadow: M3EElevation.shadows(
              menuTheme.elevation,
              shadowColor: scheme.shadow,
            ),
          ),
          child: ClipRRect(
            borderRadius: menuTheme.borderRadius,
            child: ColoredBox(
              color: palette.container,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: menuTheme.verticalPadding,
                  horizontal: menuTheme.contentHorizontalPadding,
                ),
                child: M3EMenuContent(
                  nodes: surface.children,
                  sectionLabel: surface.label,
                  selectedValue: widget.selectedValue,
                  closeOnSelect: widget.closeOnSelect,
                  onSelect: _handleSelect,
                  onOpenSubmenu: _openSubmenu,
                  autofocusFirst: false,
                  applyGroupShapes: false,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return M3EMenuStyleScope(
      colorStyle: widget.colorStyle,
      colors: palette,
      child: ListView(
        padding: EdgeInsets.all(shadowPad),
        shrinkWrap: true,
        children: cards,
      ),
    );
  }
}
