import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_menu_anchor_position.dart';
import '../models/m3e_menu_node.dart';
import '../styles/m3e_menu_theme.dart';
import '../utils/m3e_menu_placer.dart';
import 'm3e_menu_content.dart';

/// Shows an expressive menu popup anchored to [anchor].
///
/// Returns the selected value from a [M3EMenuSelectable] / [M3EMenuEntry.value],
/// or `null` if dismissed.
Future<T?> showM3EMenu<T>({
  required BuildContext context,
  required Rect anchor,
  required List<M3EMenuNode> children,
  M3EMenuAnchorPosition position = M3EMenuAnchorPosition.bottomEnd,
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

class _M3EMenuPopupState<T> extends State<M3EMenuPopup<T>> {
  double _springTarget = 0;
  double _opacity = 0;
  bool _isDismissing = false;
  bool _selected = false;
  late final bool _keyboardActivated;

  OverlayEntry? _submenuEntry;

  final FocusScopeNode _focusScopeNode = FocusScopeNode(
    debugLabel: 'M3EMenuPopup',
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );

  @override
  void initState() {
    super.initState();
    _keyboardActivated = widget.callerFocusNode?.hasFocus ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _springTarget = 1;
        _opacity = 1;
      });
      if (_keyboardActivated) {
        _focusScopeNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _removeSubmenu();
    _focusScopeNode.dispose();
    super.dispose();
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
    setState(() {
      _isDismissing = true;
      _springTarget = 0;
      _opacity = 0;
    });
    if (_keyboardActivated && restoreFocus) {
      widget.callerFocusNode?.requestFocus();
    }
    Future<void>.delayed(const Duration(milliseconds: 180), () {
      widget.onRemove();
    });
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

    final motion = menuTheme.motion.toMotion();

    return M3EScrimSystemUi.wrap(
      FocusScope(
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
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(
                    milliseconds: _isDismissing ? 80 : 200,
                  ),
                  curve: Curves.easeOut,
                  child: SingleMotionBuilder(
                    motion: motion,
                    value: _springTarget,
                    builder: (BuildContext context, double t, Widget? child) {
                      final scale =
                          menuTheme.scaleFrom + (t * (1 - menuTheme.scaleFrom));
                      // Grow away from the anchor: down when below, up when above.
                      final slideY = (1 - t) * (placement.opensAbove ? 8.0 : -8.0);
                      return Transform.translate(
                        offset: Offset(0, slideY),
                        child: Transform.scale(
                          scale: scale,
                          alignment: placement.scaleAlignment,
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
                      child: Container(
                        width: placement.width,
                        decoration: BoxDecoration(
                          color: menuTheme.containerColor(scheme),
                          borderRadius: menuTheme.borderRadius,
                          boxShadow: M3EElevation.shadows(
                            menuTheme.elevation,
                            shadowColor: scheme.shadow,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                            vertical: menuTheme.verticalPadding,
                          ),
                          shrinkWrap: true,
                          children: <Widget>[
                            M3EMenuContent(
                              nodes: widget.children,
                              selectedValue: widget.selectedValue,
                              closeOnSelect: widget.closeOnSelect,
                              onSelect: _handleSelect,
                              onOpenSubmenu: _openSubmenu,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
