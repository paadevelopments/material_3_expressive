import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
        onSelected: (Object? value) {
          if (!completer.isCompleted) {
            completer.complete(value as T?);
          }
        },
        onDismiss: () {
          if (!completer.isCompleted) {
            completer.complete(null);
          }
        },
        onRemove: () => entry.remove(),
      );
    },
  );

  Overlay.of(context, rootOverlay: true).insert(entry);
  return completer.future;
}

/// Overlay surface for [showM3EMenu] / [M3EMenu] (Compose `DropdownMenuPopup`).
class M3EMenuPopup<T> extends StatefulWidget {
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

  final Rect anchor;
  final List<M3EMenuNode> children;
  final M3EMenuAnchorPosition position;
  final M3EMenuColorStyle colorStyle;
  final T? selectedValue;
  final bool closeOnSelect;
  final double? preferredWidth;
  final FocusNode? callerFocusNode;
  final M3EMenuTheme? themeOverride;
  final ValueChanged<Object?> onSelected;
  final VoidCallback onDismiss;
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
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );

  M3EMenuTheme get _menuTheme =>
      widget.themeOverride ?? M3ETheme.of(context).menuTheme;

  @override
  void initState() {
    super.initState();
    _keyboardActivated = widget.callerFocusNode?.hasFocus ?? false;

    // Same controller setup as [M3EDropdownMenu].
    _expandCtrl = SingleMotionController(
      motion: M3EMotion.expressiveSpatialDefault.toMotion(),
      vsync: this,
    );
    _expandCtrl.addListener(_onExpandTick);
    // Expand immediately after insert (dropdown calls animateTo right after show).
    _expandCtrl.animateTo(1);

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
      if (_keyboardActivated) {
        _focusScopeNode.requestFocus();
      }
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
    if (_isDismissing &&
        !_removed &&
        _expandCtrl.value <= 0.01 &&
        mounted) {
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
    final screenSize = MediaQuery.sizeOf(context);
    final textDirection = Directionality.of(context);

    final placement = M3EMenuPlacer.compute(
      screenSize: screenSize,
      anchorRect: widget.anchor,
      theme: menuTheme,
      position: widget.position,
      textDirection: textDirection,
      approximateItemCount:
          M3EMenuPlacer.approximateItemCount(widget.children),
      preferredWidth: widget.preferredWidth,
    );

    // Same vertical scale origin as [M3EDropdownMenu] panel.
    final scaleAlignment =
        placement.opensAbove ? Alignment.bottomCenter : Alignment.topCenter;

    // No system-bar overlay override — menus use a transparent dismiss layer,
    // not a dark scrim that needs light status/nav icons.
    return FocusScope(
      node: _focusScopeNode,
      child: Focus(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            if (event is KeyDownEvent) {
              _dismiss(restoreFocus: true);
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _dismiss,
                child: ColoredBox(
                  color: menuTheme.scrimColor(scheme),
                ),
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
                  // Exact same transform as dropdown panel expand/collapse.
                  final progress = _expandCtrl.value.clamp(0.0, 1.5);
                  final clampedScale = progress.clamp(0.0, 1.2);

                  if (progress <= 0.01) {
                    return const SizedBox.shrink();
                  }

                  return Opacity(
                    opacity: progress.clamp(0.0, 1.0),
                    child: Transform.scale(
                      alignment: scaleAlignment,
                      scaleY: clampedScale,
                      child: child,
                    ),
                  );
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: menuTheme.minWidth,
                    maxWidth: placement.width,
                    maxHeight: placement.maxHeight,
                  ),
                  child: _buildSurfaces(
                    menuTheme: menuTheme,
                    scheme: scheme,
                  ),
                ),
              ),
            ),
          ],
        ),
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
                  autofocusFirst: i == 0,
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
