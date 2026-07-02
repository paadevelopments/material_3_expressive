// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:motor/motor.dart';

import '../enums/m3e_button_enums.dart';
import '../styles/m3e_button_motion.dart';

/// Shared lifecycle infrastructure for [M3EButton] and [M3EToggleButton].
mixin M3EBaseButtonState<T extends StatefulWidget> on State<T> {
  M3EButtonSize get buttonSize;
  WidgetStatesController? get externalStatesController;
  FocusNode? get externalFocusNode;
  M3EButtonMotion? get effectiveMotion;

  late WidgetStatesController statesController;
  bool _ownsController = false;

  late final ValueNotifier<bool> isPressedNotifier;
  late final ValueNotifier<bool> isHoveredNotifier;
  late final ValueNotifier<bool> isFocusedNotifier;

  @protected
  Widget buildAnimatedContent({
    required Widget Function(
      BuildContext context,
      bool isPressed,
      bool isHovered,
      bool isFocused,
    )
    builder,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: isPressedNotifier,
      builder: (context, isPressed, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: isHoveredNotifier,
          builder: (context, isHovered, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: isFocusedNotifier,
              builder: (context, isFocused, _) {
                return builder(context, isPressed, isHovered, isFocused);
              },
            );
          },
        );
      },
    );
  }

  bool get isFocused => isFocusedNotifier.value;

  FocusNode? _internalFocusNode;
  late TextStyle labelStyle;
  late SpringMotion springMotion;

  FocusNode get effectiveFocusNode => externalFocusNode ?? _internalFocusNode!;

  void initBaseButtonState() {
    _initController();
    _initFocusNode();
    isPressedNotifier = ValueNotifier(
      statesController.value.contains(WidgetState.pressed),
    );
    isHoveredNotifier = ValueNotifier(
      statesController.value.contains(WidgetState.hovered),
    );
    isFocusedNotifier = ValueNotifier(effectiveFocusNode.hasFocus);
  }

  void _initController() {
    _ownsController = externalStatesController == null;
    statesController = externalStatesController ?? WidgetStatesController();
    statesController.addListener(onStateChanged);
  }

  void _initFocusNode() {
    if (externalFocusNode == null) {
      _internalFocusNode = FocusNode(debugLabel: '$T');
    }
    effectiveFocusNode.addListener(_onFocusChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void updateLabelStyle(BuildContext context) {
    final tt = m3eMaterialTheme(context).textTheme;
    final base = switch (buttonSize.name) {
      'xs' => tt.labelSmall ?? const TextStyle(fontSize: 11),
      'sm' => tt.labelMedium ?? const TextStyle(fontSize: 12),
      'md' => tt.labelLarge ?? const TextStyle(fontSize: 14),
      'lg' => tt.titleMedium ?? const TextStyle(fontSize: 16),
      'xl' => tt.titleLarge ?? const TextStyle(fontSize: 22),
      _ => tt.labelLarge ?? const TextStyle(fontSize: 14),
    };
    labelStyle = base.copyWith(overflow: TextOverflow.ellipsis);
  }

  void updateSpringMotion() {
    springMotion = (effectiveMotion ?? M3EButtonMotion.standard).toMotion();
  }

  void handleStatesControllerUpdate(
    WidgetStatesController? oldExternal,
    WidgetStatesController? newExternal,
  ) {
    if (oldExternal != newExternal) {
      statesController.removeListener(onStateChanged);
      if (_ownsController) statesController.dispose();
      _initController();
    }
  }

  void handleFocusNodeUpdate(FocusNode? oldExternal, FocusNode? newExternal) {
    if (oldExternal != newExternal) {
      final old = oldExternal ?? _internalFocusNode;
      old?.removeListener(_onFocusChanged);
      if (oldExternal == null) {
        _internalFocusNode?.dispose();
        _internalFocusNode = null;
      }
      _initFocusNode();
    }
  }

  void _onFocusChanged() {
    isFocusedNotifier.value = effectiveFocusNode.hasFocus;
  }

  void onStateChanged() {
    if (!mounted) return;
    isPressedNotifier.value = statesController.value.contains(
      WidgetState.pressed,
    );
    isHoveredNotifier.value = statesController.value.contains(
      WidgetState.hovered,
    );
  }

  void disposeBaseButtonState() {
    statesController.removeListener(onStateChanged);
    if (_ownsController) statesController.dispose();
    effectiveFocusNode.removeListener(_onFocusChanged);
    _internalFocusNode?.dispose();
    isPressedNotifier.dispose();
    isHoveredNotifier.dispose();
    isFocusedNotifier.dispose();
  }
}
