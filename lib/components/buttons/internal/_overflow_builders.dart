// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:flutter/physics.dart';
import 'package:material_3_expressive/components/buttons/_vendor_exports.dart';
import 'package:motor/motor.dart';
import 'package:material_3_expressive/components/buttons/internal/button_constants.dart';

Future<int?> showOverflowPopup({
  required BuildContext context,
  required List<M3EButtonGroupAction> actions,
  required int firstHiddenIndex,
  required M3EOverflowPopupDecoration decoration,
  required M3EToggleButtonDecoration? groupDecoration,
  required double menuRadius,
}) {
  final triggerBox = context.findRenderObject() as RenderBox?;
  if (triggerBox == null) return Future.value(null);

  final screenSize = MediaQuery.of(context).size;
  final triggerTopLeft = triggerBox.localToGlobal(Offset.zero);
  final triggerBottomRight = triggerBox.localToGlobal(
    triggerBox.size.bottomRight(Offset.zero),
  );
  final theme = m3eMaterialTheme(context);
  final cs = theme.colorScheme;

  final menuWidth = (triggerBox.size.width + 176.0).clamp(
    decoration.minWidth,
    decoration.maxWidth,
  );

  final spaceBelow =
      screenSize.height -
      triggerBottomRight.dy -
      ButtonConstants.kScreenEdgePadding;
  final spaceAbove = triggerTopLeft.dy - ButtonConstants.kScreenEdgePadding;

  final approxHeight = ((actions.length - firstHiddenIndex) * 60.0).clamp(
    96.0,
    decoration.maxHeight,
  );
  final showAbove = spaceBelow < approxHeight && spaceAbove > spaceBelow;

  double left = triggerBottomRight.dx - menuWidth;
  left += decoration.offset.dx;
  left = left.clamp(
    ButtonConstants.kScreenEdgePadding,
    screenSize.width - menuWidth - ButtonConstants.kScreenEdgePadding,
  );

  final bool isClampedToLeft = left <= ButtonConstants.kScreenEdgePadding;
  final alignment = Alignment(
    isClampedToLeft ? -1.0 : 1.0,
    showAbove ? 1.0 : -1.0,
  );

  return showGeneralDialog<int>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: const Duration(milliseconds: 350),
    pageBuilder: (dialogContext, _, animation) {
      return Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(dialogContext).pop(),
            ),
          ),
          Positioned(
            left: left,
            top: showAbove
                ? null
                : triggerBottomRight.dy + decoration.offset.dy,
            bottom: showAbove
                ? screenSize.height - triggerTopLeft.dy + decoration.offset.dy
                : null,
            width: menuWidth,
            child: FocusScope(
              autofocus: true,
              child: Material(
                color: decoration.backgroundColor ?? cs.surfaceContainer,
                surfaceTintColor: Colors.transparent,
                elevation: decoration.elevation,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      decoration.borderRadius ??
                      BorderRadius.circular(menuRadius),
                  side:
                      decoration.border ??
                      BorderSide(
                        color: cs.outlineVariant.withValues(alpha: 0.7),
                      ),
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: (showAbove ? spaceAbove : spaceBelow).clamp(
                      0.0,
                      decoration.maxHeight,
                    ),
                  ),
                  child: ListView(
                    padding: decoration.padding,
                    shrinkWrap: true,
                    children: [
                      for (int i = firstHiddenIndex; i < actions.length; i++)
                        _buildPopupEntry(
                          context: dialogContext,
                          action: actions[i],
                          groupDecoration: groupDecoration,
                          radius: decoration.borderRadius?.topLeft.x ?? 18,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final spring = decoration.motion.toMotion();
      return _SpringScaleTransition(
        animation: animation,
        spring: spring,
        alignment: alignment,
        child: child,
      );
    },
  );
}

class _SpringScaleTransition extends StatelessWidget {
  const _SpringScaleTransition({
    required this.animation,
    required this.spring,
    required this.alignment,
    required this.child,
  });

  final Animation<double> animation;
  final SpringMotion spring;
  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        final desc = spring.description;
        final simulation = SpringSimulation(desc, 0.0, 1.0, 0.0);
        final t = simulation.x(animation.value);
        final scale = 0.88 + (0.12 * t.clamp(0.0, 1.5));
        return FadeTransition(
          opacity: AlwaysStoppedAnimation(t.clamp(0.0, 1.0)),
          child: Transform.scale(
            scale: scale.clamp(0.88, 1.08),
            alignment: alignment,
            child: child,
          ),
        );
      },
    );
  }
}

Widget _buildPopupEntry({
  required BuildContext context,
  required M3EButtonGroupAction action,
  required M3EToggleButtonDecoration? groupDecoration,
  required double radius,
}) {
  final theme = m3eMaterialTheme(context);
  final cs = theme.colorScheme;

  return Material(
    color: Colors.transparent,
    child: Ink(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(radius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: action.enabled ? () => Navigator.of(context).pop(0) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              _buildLeading(context, action, groupDecoration, cs),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTitle(context, action, groupDecoration, cs),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildLeading(
  BuildContext context,
  M3EButtonGroupAction action,
  M3EToggleButtonDecoration? groupDecoration,
  ColorScheme cs,
) {
  final Widget? icon = action.icon;
  if (icon == null) return const SizedBox.shrink();

  final Color color =
      action.decoration?.foregroundColor?.resolve({}) ??
      groupDecoration?.foregroundColor?.resolve({}) ??
      cs.onSurface;
  final Color effectiveColor = action.enabled
      ? color
      : (action.decoration?.foregroundColor?.resolve({WidgetState.disabled}) ??
            color.withValues(alpha: ButtonConstants.kDisabledForegroundAlpha));

  return IconTheme.merge(
    data: IconThemeData(size: 18, color: effectiveColor),
    child: icon,
  );
}

Widget _buildTitle(
  BuildContext context,
  M3EButtonGroupAction action,
  M3EToggleButtonDecoration? groupDecoration,
  ColorScheme cs,
) {
  final theme = m3eMaterialTheme(context);
  final Color color =
      action.decoration?.foregroundColor?.resolve({}) ??
      groupDecoration?.foregroundColor?.resolve({}) ??
      cs.onSurface;
  final Color effectiveColor = action.enabled
      ? color
      : (action.decoration?.foregroundColor?.resolve({WidgetState.disabled}) ??
            color.withValues(alpha: ButtonConstants.kDisabledForegroundAlpha));

  final Widget label =
      action.label ?? action.checkedLabel ?? const Text('Option');

  return DefaultTextStyle.merge(
    style: theme.textTheme.labelLarge?.copyWith(color: effectiveColor),
    child: label,
  );
}

Future<int?> showOverflowBottomSheet({
  required BuildContext context,
  required List<M3EButtonGroupAction> actions,
  required int firstHiddenIndex,
  required M3EOverflowBottomSheetDecoration decoration,
  required bool Function(int) isSelected,
}) {
  return showModalBottomSheet<int>(
    context: context,
    showDragHandle: decoration.showDragHandle,
    backgroundColor: decoration.backgroundColor,
    elevation: decoration.elevation,
    shape: decoration.shape,
    builder: (sheetContext) {
      return SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (decoration.title != null)
                Padding(
                  padding: decoration.titlePadding,
                  child: DefaultTextStyle.merge(
                    style: m3eMaterialTheme(sheetContext).textTheme.titleMedium,
                    child: decoration.title!,
                  ),
                ),
              for (int i = firstHiddenIndex; i < actions.length; i++)
                ListTile(
                  enabled: actions[i].enabled,
                  leading: _buildBottomSheetLeading(actions[i]),
                  title: _buildBottomSheetTitle(actions[i]),
                  trailing: isSelected(i)
                      ? const Icon(Icons.check_rounded)
                      : null,
                  onTap: actions[i].enabled
                      ? () => Navigator.of(sheetContext).pop(i)
                      : null,
                ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildBottomSheetLeading(M3EButtonGroupAction action) {
  return action.icon ?? const SizedBox.shrink();
}

Widget _buildBottomSheetTitle(M3EButtonGroupAction action) {
  return action.label ?? action.checkedLabel ?? Text('Option');
}
