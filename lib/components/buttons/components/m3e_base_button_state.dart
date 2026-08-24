import 'package:material_3_expressive/foundations/foundations.dart';
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3EButton, M3EToggleButton;
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../enums/m3e_button_enums.dart';
import '../styles/m3e_button_motion.dart';

/// Shared lifecycle infrastructure for [M3EButton] and [M3EToggleButton].
mixin M3EBaseButtonState<T extends StatefulWidget> on State<T> {
  /// buttonSize.
  M3EButtonSize get buttonSize;

  /// externalStatesController.
  WidgetStatesController? get externalStatesController;

  /// externalFocusNode.
  FocusNode? get externalFocusNode;

  /// effectiveMotion.
  M3EButtonMotion? get effectiveMotion;

  /// statesController.

  late WidgetStatesController statesController;
  bool _ownsController = false;

  /// isPressedNotifier.

  late final ValueNotifier<bool> isPressedNotifier;

  /// isPointerDownNotifier.
  late final ValueNotifier<bool> isPointerDownNotifier;

  /// isHoveredNotifier.
  late final ValueNotifier<bool> isHoveredNotifier;

  /// isFocusedNotifier.
  late final ValueNotifier<bool> isFocusedNotifier;

  /// wrapWithPointerPressTracking.

  @protected
  Widget wrapWithPointerPressTracking({
    required bool enabled,
    required Widget child,
  }) {
    if (!enabled) {
      return child;
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _setPointerDown(true),
      onPointerUp: (_) => _setPointerDown(false),
      onPointerCancel: (_) => _setPointerDown(false),
      child: child,
    );
  }

  void _setPointerDown(bool down) {
    if (isPointerDownNotifier.value == down) {
      return;
    }
    isPointerDownNotifier.value = down;
  }

  /// buildAnimatedContent.

  @protected
  Widget buildAnimatedContent({
    required Widget Function(
      BuildContext context, {
      required bool isPressed,
      required bool isHovered,
      required bool isFocused,
    })
    builder,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: isPressedNotifier,
      builder: (context, isPressed, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: isPointerDownNotifier,
          builder: (context, isPointerDown, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: isHoveredNotifier,
              builder: (context, isHovered, _) {
                return ValueListenableBuilder<bool>(
                  valueListenable: isFocusedNotifier,
                  builder: (context, isFocused, _) {
                    final effectivePressed = isPressed || isPointerDown;
                    return builder(
                      context,
                      isPressed: effectivePressed,
                      isHovered: isHovered,
                      isFocused: isFocused,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  /// isFocused.

  bool get isFocused => isFocusedNotifier.value;

  FocusNode? _internalFocusNode;

  /// labelStyle.
  late TextStyle labelStyle;

  /// springMotion.
  late SpringMotion springMotion;

  /// effectiveFocusNode.

  FocusNode get effectiveFocusNode => externalFocusNode ?? _internalFocusNode!;

  /// initBaseButtonState.

  void initBaseButtonState() {
    _initController();
    _initFocusNode();
    isPressedNotifier = ValueNotifier(
      statesController.value.contains(WidgetState.pressed),
    );
    isPointerDownNotifier = ValueNotifier(false);
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

  /// updateLabelStyle.

  void updateLabelStyle(BuildContext context) {
    final type = M3ETheme.of(context).typeScale;
    final base = switch (buttonSize.name) {
      'xs' => type.labelSmall,
      'sm' => type.labelMedium,
      'md' => type.labelLarge,
      'lg' => type.titleMedium,
      'xl' => type.titleLarge,
      _ => type.labelLarge,
    };
    labelStyle = base.copyWith(overflow: TextOverflow.ellipsis);
  }

  /// updateSpringMotion.

  void updateSpringMotion() {
    springMotion = (effectiveMotion ?? M3EButtonMotion.expressiveSpatialPress)
        .toMotion();
  }

  /// handleStatesControllerUpdate.

  void handleStatesControllerUpdate(
    WidgetStatesController? oldExternal,
    WidgetStatesController? newExternal,
  ) {
    if (oldExternal != newExternal) {
      statesController.removeListener(onStateChanged);
      if (_ownsController) {
        statesController.dispose();
      }
      _initController();
    }
  }

  /// handleFocusNodeUpdate.

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

  /// onStateChanged.

  void onStateChanged() {
    if (!mounted) {
      return;
    }
    isPressedNotifier.value = statesController.value.contains(
      WidgetState.pressed,
    );
    isHoveredNotifier.value = statesController.value.contains(
      WidgetState.hovered,
    );
  }

  /// disposeBaseButtonState.

  void disposeBaseButtonState() {
    statesController.removeListener(onStateChanged);
    if (_ownsController) {
      statesController.dispose();
    }
    effectiveFocusNode.removeListener(_onFocusChanged);
    _internalFocusNode?.dispose();
    isPressedNotifier.dispose();
    isPointerDownNotifier.dispose();
    isHoveredNotifier.dispose();
    isFocusedNotifier.dispose();
  }
}
