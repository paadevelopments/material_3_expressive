// Ported from https://github.com/Mudit200408/m3e_dropdown_menu
// Adapted for material_3_expressive: import paths, foundations wiring, M3E naming.

import 'package:flutter/material.dart';

import '../models/m3e_dropdown_item.dart';
import '../styles/m3e_dropdown_item_style.dart';

/// Internal widget for a single dropdown menu item.
/// Handles hover/press interactions and snappy radius morphing.
class M3EDropdownMenuItemWidget<T> extends StatefulWidget {
  final M3EDropdownItem<T> item;
  final int index;
  final int total;
  final M3EDropdownItemStyle style;
  final InteractiveInkFeatureFactory? splashFactory;
  final VoidCallback onTap;

  const M3EDropdownMenuItemWidget({
    super.key,
    required this.item,
    required this.index,
    required this.total,
    required this.style,
    required this.splashFactory,
    required this.onTap,
  });

  @override
  State<M3EDropdownMenuItemWidget<T>> createState() =>
      _M3EDropdownMenuItemWidgetState<T>();
}

class _M3EDropdownMenuItemWidgetState<T>
    extends State<M3EDropdownMenuItemWidget<T>> {
  bool _isHovered = false;
  bool _isPressed = false;
  bool _lastSelected = false;

  @override
  void initState() {
    super.initState();
    _lastSelected = widget.item.selected;
  }

  BorderRadius _calculateBaseRadius(double currentRadius) {
    final id = widget.style;
    final isFirst = widget.index == 0;
    final isLast = widget.index == widget.total - 1;
    final isSingle = widget.total == 1;

    final outerR = id.outerRadius ?? 12.0;

    if (widget.item.selected) {
      return BorderRadius.circular(currentRadius);
    } else if (isSingle) {
      return BorderRadius.circular(outerR);
    } else if (isFirst) {
      return BorderRadius.vertical(
        top: Radius.circular(outerR),
        bottom: Radius.circular(currentRadius),
      );
    } else if (isLast) {
      return BorderRadius.vertical(
        top: Radius.circular(currentRadius),
        bottom: Radius.circular(outerR),
      );
    } else {
      return BorderRadius.circular(currentRadius);
    }
  }

  BorderRadius _buildEffectiveRadius() {
    final id = widget.style;

    // 1. Determine the "dynamic" radius (Selected vs Hover vs Pressed vs Inner)
    double targetR = id.innerRadius;

    if (widget.item.selected) {
      targetR = id.selectedBorderRadius ?? id.outerRadius ?? 12.0;
    }

    if (_isPressed) {
      targetR = id.pressedRadius;
    } else if (_isHovered) {
      targetR = id.hoverRadius;
    }

    // 2. Apply this dynamic radius to the correct corners, PRESERVING outerRadius
    return _calculateBaseRadius(targetR);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final id = widget.style;
    final item = widget.item;

    Color bgColor;
    if (item.disabled) {
      bgColor =
          id.disabledBackgroundColor ?? cs.onSurface.withValues(alpha: 0.04);
    } else if (item.selected) {
      bgColor = id.selectedBackgroundColor ?? cs.secondaryContainer;
    } else {
      bgColor = id.backgroundColor ?? cs.surfaceContainerHigh;
    }

    Color textColor;
    if (item.disabled) {
      textColor = id.disabledTextColor ?? cs.onSurface.withValues(alpha: 0.38);
    } else if (item.selected) {
      textColor = id.selectedTextColor ?? cs.onSecondaryContainer;
    } else {
      textColor = id.textColor ?? cs.onSurface;
    }

    final content = Padding(
      padding: id.itemPadding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.label,
              style:
                  (item.selected ? id.selectedTextStyle : id.textStyle) ??
                  theme.textTheme.bodyLarge?.copyWith(color: textColor),
            ),
          ),
          if (item.selected)
            id.selectedIcon ??
                Icon(Icons.check_rounded, color: textColor, size: 20),
        ],
      ),
    );

    final selectionChanged = _lastSelected != widget.item.selected;
    _lastSelected = widget.item.selected;

    final duration = selectionChanged
        ? const Duration(milliseconds: 20)
        : const Duration(milliseconds: 40);

    return TweenAnimationBuilder<BorderRadius?>(
      duration: duration,
      curve: Curves.easeOut,
      tween: BorderRadiusTween(
        begin: _buildEffectiveRadius(),
        end: _buildEffectiveRadius(),
      ),
      builder: (context, animatedRadius, child) {
        final radius = animatedRadius ?? _buildEffectiveRadius();
        return Material(
          color: bgColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: radius),
          child: InkWell(
            splashFactory: id.splashFactory ?? widget.splashFactory,
            splashColor: id.splashColor,
            highlightColor: id.highlightColor,
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return textColor.withValues(alpha: 0.10);
              }
              if (states.contains(WidgetState.hovered)) {
                return textColor.withValues(alpha: 0.05);
              }
              return Colors.transparent;
            }),
            mouseCursor: id.mouseCursor,
            onTap: item.disabled ? null : widget.onTap,
            onHover: (hover) => setState(() => _isHovered = hover),
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapUp: (_) => setState(() => _isPressed = false),
            onTapCancel: () => setState(() => _isPressed = false),
            child: child,
          ),
        );
      },
      child: content,
    );
  }
}
