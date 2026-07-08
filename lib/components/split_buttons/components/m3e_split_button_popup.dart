// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'dart:async';
import 'package:material_3_expressive/foundations/foundations.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor/motor.dart';
import '../models/m3e_split_button_item.dart';
import '../styles/m3e_split_button_popup_decoration.dart';
import '../../buttons/res/m3e_button_constants.dart';

Future<T?> showSplitButtonPopup<T>({
  required BuildContext context,
  required List<M3ESplitButtonItem<T>> items,
  required M3ESplitButtonPopupDecoration decoration,
  required Color foregroundColor,
  required double iconSize,
  required RenderBox triggerRenderBox,
  FocusNode? callerFocusNode,
  T? selectedValue,
}) {
  final completer = Completer<T?>();

  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => _PopupOverlay<T>(
      items: items,
      foregroundColor: foregroundColor,
      iconSize: iconSize,
      decoration: decoration,
      triggerRenderBox: triggerRenderBox,
      selectedValue: selectedValue,
      callerFocusNode: callerFocusNode,
      onSelected: (value) {
        completer.complete(value);
      },
      onDismiss: () {
        completer.complete(null);
      },
      onRemove: () {
        overlayEntry.remove();
      },
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  return completer.future;
}

class _PopupOverlay<T> extends StatefulWidget {
  const _PopupOverlay({
    required this.items,
    required this.foregroundColor,
    required this.iconSize,
    required this.decoration,
    required this.triggerRenderBox,
    required this.onSelected,
    required this.onDismiss,
    required this.onRemove,
    this.callerFocusNode,
    this.selectedValue,
  });

  final List<M3ESplitButtonItem<T>> items;
  final Color foregroundColor;
  final double iconSize;
  final M3ESplitButtonPopupDecoration decoration;
  final RenderBox triggerRenderBox;
  final void Function(T value) onSelected;
  final VoidCallback onDismiss;
  final VoidCallback onRemove;
  final FocusNode? callerFocusNode;
  final T? selectedValue;

  @override
  State<_PopupOverlay<T>> createState() => _PopupOverlayState<T>();
}

class _PopupOverlayState<T> extends State<_PopupOverlay<T>> {
  double _springTarget = 0.0;
  bool _selected = false;
  bool _isDismissing = false;
  double _opacity = 0.0;

  late final bool _keyboardActivated;

  final FocusScopeNode _focusScopeNode = FocusScopeNode(
    debugLabel: 'SplitButtonPopup',
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );

  @override
  void initState() {
    super.initState();
    _keyboardActivated = widget.callerFocusNode?.hasFocus ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _springTarget = 1.0;
          _opacity = 1.0;
        });
        if (_keyboardActivated) {
          _focusScopeNode.requestFocus();
        }
      }
    });
  }

  @override
  void dispose() {
    _focusScopeNode.dispose();
    super.dispose();
  }

  void _dismiss({bool restoreFocus = false}) {
    if (_isDismissing) return;
    if (!_selected) widget.onDismiss();
    setState(() {
      _isDismissing = true;
      _springTarget = 0.0;
      _opacity = 0.0;
    });
    if (_keyboardActivated && restoreFocus) {
      widget.callerFocusNode?.requestFocus();
    }
    Future.delayed(const Duration(milliseconds: 180), () {
      widget.onRemove();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final triggerTopLeft = widget.triggerRenderBox.localToGlobal(Offset.zero);
    final triggerBottomRight = widget.triggerRenderBox.localToGlobal(
      widget.triggerRenderBox.size.bottomRight(Offset.zero),
    );
    final m3eTheme = M3ETheme.of(context);
    final scheme = m3eTheme.colorScheme;
    final splitTheme = M3ETheme.of(context).splitButtonTheme;

    final menuWidth = (widget.triggerRenderBox.size.width + 176.0).clamp(
      widget.decoration.minWidth,
      widget.decoration.maxWidth,
    );

    final spaceBelow =
        screenSize.height -
        triggerBottomRight.dy -
        M3EButtonConstants.kScreenEdgePadding;
    final spaceAbove = triggerTopLeft.dy - M3EButtonConstants.kScreenEdgePadding;

    final approxHeight = (widget.items.length * 60.0).clamp(
      96.0,
      widget.decoration.maxHeight,
    );
    final showAbove = spaceBelow < approxHeight && spaceAbove > spaceBelow;

    double left = triggerBottomRight.dx - menuWidth;
    left += widget.decoration.offset.dx;
    left = left.clamp(
      M3EButtonConstants.kScreenEdgePadding,
      screenSize.width - menuWidth - M3EButtonConstants.kScreenEdgePadding,
    );

    final bool isClampedToLeft = left <= M3EButtonConstants.kScreenEdgePadding;
    final scaleAlignment = Alignment(
      isClampedToLeft ? -1.0 : 1.0,
      showAbove ? 1.0 : -1.0,
    );

    final motion = widget.decoration.motion.toMotion();

    return FocusScope(
      node: _focusScopeNode,
      child: Focus(
        focusNode: FocusNode(skipTraversal: true),
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            if (event is KeyDownEvent) {
              _dismiss(restoreFocus: true);
            }
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _dismiss,
                  child: Container(
                    color: m3eTheme.colorScheme.scrim.withValues(
                      alpha: splitTheme.popupScrimAlpha,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: left,
                top: showAbove
                    ? null
                    : triggerBottomRight.dy + widget.decoration.offset.dy,
                bottom: showAbove
                    ? screenSize.height -
                          triggerTopLeft.dy +
                          widget.decoration.offset.dy
                    : null,
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: Duration(milliseconds: _isDismissing ? 80 : 200),
                  curve: Curves.easeOut,
                  child: SingleMotionBuilder(
                    motion: motion,
                    value: _springTarget,
                    builder: (context, t, _) {
                      final scale = 0.72 + (t * 0.28);
                      return Transform.scale(
                        scale: scale,
                        alignment: scaleAlignment,
                        child: SizedBox(
                          width: menuWidth,
                          child: Material(
                            color: widget.decoration.backgroundColor ??
                                splitTheme.popupBackgroundColor(scheme),
                            surfaceTintColor: Colors.transparent,
                            elevation:
                                widget.decoration.elevation ??
                                splitTheme.popupElevation,
                            shape: RoundedRectangleBorder(
                              borderRadius: widget.decoration.borderRadius ??
                                  BorderRadius.circular(
                                    splitTheme.popupBorderRadius,
                                  ),
                              side: BorderSide.none,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: (showAbove ? spaceAbove : spaceBelow)
                                    .clamp(0.0, widget.decoration.maxHeight),
                              ),
                              child: ListView(
                                padding: widget.decoration.padding ??
                                    splitTheme.popupPadding,
                                shrinkWrap: true,
                                children: [
                                  for (int i = 0; i < widget.items.length; i++)
                                    _buildPopupItem(widget.items[i], i),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopupItem(M3ESplitButtonItem<T> item, int index) {
    final bool isFirstEnabled =
        _keyboardActivated &&
        item.enabled &&
        index == widget.items.indexWhere((e) => e.enabled);

    final isSelected =
        widget.selectedValue != null && widget.selectedValue == item.value;
    final effectiveColor = item.enabled
        ? widget.foregroundColor
        : widget.foregroundColor.withValues(
            alpha: M3EButtonConstants.kDisabledForegroundAlpha,
          );

    Widget child;
    if (item.child is IconData) {
      child = Row(
        children: [
          Icon(
            item.child as IconData,
            size: widget.iconSize,
            color: effectiveColor,
          ),
          const SizedBox(width: 12),
          Text(
            item.child.toString(),
            style: M3ETheme.of(context)
                .typeScale
                .labelLarge
                .copyWith(color: effectiveColor),
          ),
        ],
      );
    } else if (item.child is Widget) {
      child = item.child as Widget;
    } else {
      child = Text(
        item.child.toString(),
        style: M3ETheme.of(context)
            .typeScale
            .labelLarge
            .copyWith(color: effectiveColor),
      );
    }

    final borderRadius =
        widget.decoration.selectedBorderRadius ??
        widget.decoration.borderRadius ??
        BorderRadius.circular(18);

    final bgColor = isSelected
        ? (widget.decoration.selectedColor ??
              effectiveColor.withValues(
                alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
              ))
        : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Material(
        color: bgColor,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          autofocus: isFirstEnabled,
          onTap: item.enabled
              ? () {
                  _selected = true;
                  widget.onSelected(item.value);
                  _dismiss(restoreFocus: _focusScopeNode.hasFocus);
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Expanded(child: child),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      M3EIcons.check_rounded,
                      size: widget.iconSize * 0.9,
                      color: effectiveColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
