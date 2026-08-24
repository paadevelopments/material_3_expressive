// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
part of '../m3e_toggle_button_group.dart';

class _SpringMenuWrapper extends StatefulWidget {
  final Widget child;
  final M3EButtonMotion motion;
  final Alignment alignment;
  final bool isBottomSheet;

  const _SpringMenuWrapper({
    required this.child,
    required this.motion,
    required this.alignment,
    this.isBottomSheet = false,
  });

  @override
  State<_SpringMenuWrapper> createState() => _SpringMenuWrapperState();
}

class _SpringMenuWrapperState extends State<_SpringMenuWrapper>
    with SingleTickerProviderStateMixin {
  late SingleMotionController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = SingleMotionController(
      motion: widget.motion.toMotion(),
      vsync: this,
    );
    _ctrl.animateTo(1);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final val = _ctrl.value;
        if (widget.isBottomSheet) {
          return Transform.translate(
            offset: Offset(0, 40 * (1.0 - val.clamp(0.0, 1.5))),
            child: child,
          );
        } else {
          // Match SplitButton popup feel: anchored uniform spring scale.
          // Keep spring overshoot visible by not clamping the upper bound.
          final scale = 0.72 + (val * 0.28);
          return Opacity(
            opacity: val.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: scale,
              alignment: widget.alignment,
              child: child,
            ),
          );
        }
      },
      child: widget.child,
    );
  }
}

class _MoveFocusAction extends Action<_MoveFocusIntent> {
  _MoveFocusAction(this._onMove);

  final void Function(int direction) _onMove;

  @override
  Object? invoke(_MoveFocusIntent intent) {
    _onMove(intent.direction);
    return null;
  }
}

class _ToggleGroupFocusManager {
  _ToggleGroupFocusManager._();

  static List<FocusNode?> buildInternalFocusNodes(
    List<M3EButtonGroupAction> actions,
  ) {
    return List<FocusNode?>.generate(actions.length, (i) {
      final actionNode = actions[i].focusNode;
      if (actionNode != null) {
        return null;
      }
      return FocusNode(debugLabel: 'M3EButtonGroup Button $i');
    });
  }

  static void disposeInternalFocusNodes(List<FocusNode?> nodes) {
    for (final node in nodes) {
      node?.dispose();
    }
    nodes.clear();
  }

  static int computeFocusNodeSignature(List<M3EButtonGroupAction> actions) {
    var hash = 0;
    for (final action in actions) {
      hash = Object.hash(hash, action.focusNode);
    }
    return hash;
  }

  static int? nextEnabledIndex(
    List<M3EButtonGroupAction> actions, {
    required int currentIndex,
    required int direction,
  }) {
    if (actions.isEmpty) {
      return null;
    }
    final start = currentIndex + direction;
    var nextIndex = start;

    while (true) {
      nextIndex = _wrapIndex(nextIndex, actions.length);
      if (actions[nextIndex].enabled) {
        return nextIndex;
      }
      nextIndex += direction;
      if (nextIndex == start || nextIndex == currentIndex) {
        return null;
      }
    }
  }

  static int _wrapIndex(int index, int length) {
    if (index < 0) {
      return length - 1;
    }
    if (index >= length) {
      return 0;
    }
    return index;
  }
}

class _ToggleGroupPressCoordinator {
  _ToggleGroupPressCoordinator({required this._isMounted});

  final bool Function() _isMounted;

  int? _lastPressedIndex;
  int? get lastPressedIndex => _lastPressedIndex;

  final ValueNotifier<int?> pressedIndexNotifier = ValueNotifier<int?>(null);

  double _pressProgress = 0;
  bool _isWaitingForRelease = false;
  Duration? _releaseDeadline;

  void dispose() {
    pressedIndexNotifier.dispose();
  }

  void clearPressedIndex() {
    _setPressedIndex(null);
  }

  void handlePressedStateChange({required int index, required bool isPressed}) {
    if (isPressed && pressedIndexNotifier.value != index) {
      _isWaitingForRelease = false;
      _releaseDeadline = null;
      _setPressedIndex(index);
    } else if (!isPressed && pressedIndexNotifier.value == index) {
      _isWaitingForRelease = true;
      _scheduleReleaseCheck();
    }
  }

  void onAnimationProgress(double animValue) {
    if (animValue > 0.01 && _lastPressedIndex != null) {
      _pressProgress = animValue;
      if (_isWaitingForRelease) {
        _checkRelease();
      }
    }
  }

  void _scheduleReleaseCheck() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _releaseDeadline =
          SchedulerBinding.instance.currentFrameTimeStamp +
          M3EButtonConstants.kReleaseTimeout;
      _checkRelease();
    });
  }

  void _checkRelease() {
    if (!_isWaitingForRelease || !_isMounted()) {
      return;
    }
    final timedOut =
        _releaseDeadline != null &&
        SchedulerBinding.instance.currentFrameTimeStamp >= _releaseDeadline!;
    if (_pressProgress >= M3EButtonConstants.kPressReleaseThreshold ||
        timedOut) {
      _isWaitingForRelease = false;
      _releaseDeadline = null;
      _pressProgress = 0.0;
      _setPressedIndex(null);
    }
  }

  void _setPressedIndex(int? index) {
    if (index != null) {
      _lastPressedIndex = index;
    }
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (_isMounted()) {
          pressedIndexNotifier.value = index;
        }
      });
    } else {
      pressedIndexNotifier.value = index;
    }
  }
}

class _ToggleGroupMeasurementOrchestrator {
  int generation = 0;
  bool hasAnyLabel = false;

  List<GlobalKey> uncheckedKeys = <GlobalKey>[];
  List<GlobalKey> checkedKeys = <GlobalKey>[];
  List<double?> measuredUncheckedWidths = <double?>[];
  List<double?> measuredCheckedWidths = <double?>[];

  List<WidgetStatesController>? _measurerUncheckedControllers;
  List<WidgetStatesController>? _measurerCheckedControllers;

  void initMeasurementState({
    required int actionCount,
    required M3EButtonGroupOverflowController overflowController,
  }) {
    uncheckedKeys = List.generate(actionCount, (_) => GlobalKey());
    checkedKeys = List.generate(actionCount, (_) => GlobalKey());

    // Same count: keep last-known widths so interim frames do not collapse
    // labeled buttons to the icon-only fallback while remotion runs.
    if (measuredUncheckedWidths.length != actionCount ||
        measuredCheckedWidths.length != actionCount) {
      measuredUncheckedWidths = List.filled(actionCount, null);
      measuredCheckedWidths = List.filled(actionCount, null);
    }

    // Remotion may produce new extents; remeasure before treating as stable.
    overflowController.stableAllOverflowMeasured.value = false;

    disposeMeasurerControllers();
    initMeasurerControllers(actionCount);
  }

  void initMeasurerControllers(int actionCount) {
    _measurerUncheckedControllers = List.generate(
      actionCount,
      (_) => WidgetStatesController(),
    );
    _measurerCheckedControllers = List.generate(
      actionCount,
      (_) => WidgetStatesController(),
    );
  }

  void disposeMeasurerControllers() {
    if (_measurerUncheckedControllers != null) {
      for (final c in _measurerUncheckedControllers!) {
        c.dispose();
      }
      _measurerUncheckedControllers = null;
    }
    if (_measurerCheckedControllers != null) {
      for (final c in _measurerCheckedControllers!) {
        c.dispose();
      }
      _measurerCheckedControllers = null;
    }
  }

  bool isMeasured(int index) {
    return measuredUncheckedWidths[index] != null &&
        measuredCheckedWidths[index] != null;
  }
}

class _ToggleGroupKeyboardConfig {
  _ToggleGroupKeyboardConfig._();

  static Map<ShortcutActivator, Intent> arrowKeyShortcuts({
    required Axis direction,
    required bool isRtl,
  }) {
    final rtlFlip = isRtl ? -1 : 1;
    if (direction == Axis.horizontal) {
      return {
        const SingleActivator(LogicalKeyboardKey.arrowRight): _MoveFocusIntent(
          1 * rtlFlip,
        ),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): _MoveFocusIntent(
          -1 * rtlFlip,
        ),
      };
    }
    return {
      const SingleActivator(LogicalKeyboardKey.arrowDown):
          const _MoveFocusIntent(1),
      const SingleActivator(LogicalKeyboardKey.arrowUp): const _MoveFocusIntent(
        -1,
      ),
    };
  }
}

class _FocusRingGapRenderer {
  _FocusRingGapRenderer._();

  static double resolveGap({
    required bool connected,
    required int? focusedIndex,
    required int beforeIndex,
    required double spacing,
    required double connectedGap,
  }) {
    var gap = connected ? connectedGap : spacing;
    if (connected) {
      final isFocusedLeft = focusedIndex == beforeIndex;
      final isFocusedRight = focusedIndex == beforeIndex + 1;
      if (isFocusedLeft || isFocusedRight) {
        gap +=
            M3EButtonConstants.kFocusRingGap +
            M3EButtonConstants.kFocusRingWidth;
      }
    }
    return gap;
  }
}
