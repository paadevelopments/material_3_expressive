part of 'm3e_dismissible_card_controller.dart';

/// M3EDismissibleCardDragMixin.

mixin M3EDismissibleCardDragMixin<T extends StatefulWidget>
    on M3EDismissibleCardMixin<T> {
  @override
  double computeNeighbourOffset(int slotPos, int dragPos) {
    if (dragPos < 0 || slotPos < 0) {
      return 0;
    }
    final distance = (slotPos - dragPos).abs();
    if (distance == 0 || distance > style.neighbourReach) {
      return 0;
    }

    final reach = style.neighbourReach;
    final falloff = reach > 1 ? (reach - distance) / (reach - 1) : 1.0;

    return _neighbourFraction *
        style.neighbourPull *
        falloff *
        _dragOffset.sign;
  }

  /// handleDragStart.

  @override
  void handleDragStart(M3EDismissibleSlot slot) {
    if (!slot.isVisible) {
      return;
    }

    _springCtrl?.stop(canceled: true);
    _nbrCtrl?.stop(canceled: true);
    _pushCtrl?.stop(canceled: true);
    _roundnessCtrl?.stop(canceled: true);

    setState(() {
      _dragSlotRef = slot;
      _dragSlotIndex = _slots.indexOf(slot);
      _dragOffset = 0.0;
      _neighbourFraction = 0.0;
      _pastThreshold = false;
      _detachPush = 0.0;
      _roundnessFraction = 0.0;
    });
  }

  /// handleDragUpdate.

  @override
  void handleDragUpdate(DragUpdateDetails d) {
    if (_dragSlotRef == null) {
      return;
    }

    final swipeSpeed = d.delta.dx.abs();
    final multiplier = (1.0 + (swipeSpeed / 5.0)).clamp(1.0, 4.0);
    final newOffset = _dragOffset + d.delta.dx;
    var newNeighbour = _neighbourFraction;
    var newRoundness = _roundnessFraction;

    final savedOffset = _dragOffset;
    _dragOffset = newOffset;
    final newProgress = _dragProgress;
    _dragOffset = savedOffset;

    final crossedNow = newProgress >= 1.0;
    if (crossedNow && !_pastThreshold) {
      _onCrossThreshold(newOffset, multiplier);
    } else if (!crossedNow && _pastThreshold) {
      _onReEngageThreshold(newOffset, savedOffset, multiplier);
    } else if (!_pastThreshold) {
      final pre = _onPreThreshold(newProgress);
      newNeighbour = pre.neighbour;
      newRoundness = pre.roundness;
    }

    setState(() {
      _dragOffset = newOffset;
      _neighbourFraction = newNeighbour;
      _roundnessFraction = newRoundness;
    });
  }

  void _onCrossThreshold(double newOffset, double multiplier) {
    _pastThreshold = true;

    final pushDir = newOffset.sign;
    _startPushController(
      multiplier: multiplier,
      target: style.background == null || style.secondaryBackground == null
          ? pushDir * _kDetachPushPixels
          : 0,
    );
    _startNeighbourController(multiplier: multiplier, target: 0);
    _startRoundnessController(multiplier: multiplier, target: 1);
  }

  void _onReEngageThreshold(
    double newOffset,
    double savedOffset,
    double multiplier,
  ) {
    _pastThreshold = false;
    _reEngaging = true;

    _startPushController(
      multiplier: multiplier,
      initialValue: _detachPush,
      target: 0,
    );

    _dragOffset = newOffset;
    final target = _dragProgress;
    _dragOffset = savedOffset;

    _nbrCtrl?.dispose();
    _nbrCtrl =
        SingleMotionController(
            motion: const MaterialSpringMotion.expressiveSpatialDefault()
                .copyWith(stiffness: 800 * multiplier, damping: 0.7),
            vsync: this,
            initialValue: _neighbourFraction,
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _neighbourFraction = _nbrCtrl!.value);
            }
          })
          ..addStatusListener((s) {
            if (s == AnimationStatus.completed ||
                s == AnimationStatus.dismissed) {
              _reEngaging = false;
            }
          })
          ..animateTo(target);

    _roundnessCtrl?.dispose();
    _roundnessCtrl =
        SingleMotionController(
            motion: _kReEngageSpring.copyWith(stiffness: 800 * multiplier),
            vsync: this,
            initialValue: _roundnessFraction,
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _roundnessFraction = _roundnessCtrl!.value);
            }
          })
          ..animateTo(target * _kPreThresholdRoundnessScale);
  }

  ({double neighbour, double roundness}) _onPreThreshold(double newProgress) {
    if (_reEngaging) {
      _reEngaging = false;
      _nbrCtrl?.stop(canceled: true);
      _roundnessCtrl?.stop(canceled: true);
    }
    if (style.dismissHapticStream) {
      _playPullHaptics();
    }
    return (
      neighbour: newProgress,
      roundness: (newProgress * _kMaxPreDetachRoundness).clamp(
        0.0,
        _kMaxPreDetachRoundness,
      ),
    );
  }

  void _startPushController({
    required double multiplier,
    required double target,
    double? initialValue,
  }) {
    _pushCtrl?.dispose();
    _pushCtrl =
        SingleMotionController(
            motion: _kDetachPush.copyWith(stiffness: 800 * multiplier),
            vsync: this,
            initialValue: initialValue ?? 0,
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _detachPush = _pushCtrl!.value);
            }
          })
          ..animateTo(target);
  }

  void _startNeighbourController({
    required double multiplier,
    required double target,
  }) {
    _nbrCtrl?.dispose();
    _nbrCtrl =
        SingleMotionController(
            motion: const MaterialSpringMotion.expressiveSpatialDefault()
                .copyWith(stiffness: 800 * multiplier, damping: 0.7),
            vsync: this,
            initialValue: _neighbourFraction,
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _neighbourFraction = _nbrCtrl!.value);
            }
          })
          ..animateTo(target);
  }

  void _startRoundnessController({
    required double multiplier,
    required double target,
  }) {
    _roundnessCtrl?.dispose();
    _roundnessCtrl =
        SingleMotionController(
            motion: _kRoundnessSnap.copyWith(stiffness: 1000 * multiplier),
            vsync: this,
            initialValue: _roundnessFraction,
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _roundnessFraction = _roundnessCtrl!.value);
            }
          })
          ..animateTo(target);
  }

  /// handleDragEnd.

  @override
  void handleDragEnd(DragEndDetails d) {
    if (_dragSlotRef == null) {
      return;
    }
    _reindexDragSlot();
    if (_dragSlotIndex < 0) {
      _resetDragState();
      return;
    }

    final velocity = d.velocity.pixelsPerSecond.dx.abs();
    final speedMul = (1.0 + (velocity / 1000.0)).clamp(1.0, 4.0);

    if (_dragProgress >= 1.0) {
      final direction = _dragOffset > 0
          ? DismissDirection.startToEnd
          : DismissDirection.endToStart;
      _dismiss(_dragSlotIndex, speedMul, direction);
    } else {
      _springBack(speedMul);
    }
  }

  void _resetDragState() {
    setState(() {
      _dragSlotRef = null;
      _dragSlotIndex = -1;
      _dragOffset = 0.0;
      _detachPush = 0.0;
      _neighbourFraction = 0.0;
      _pastThreshold = false;
      _reEngaging = false;
      _roundnessFraction = 0.0;
    });
  }

  void _playPullHaptics() {
    if (!style.enableFeedback) {
      return;
    }
    if (_hapticStopwatch.elapsedMilliseconds < _kVibrationThresholdMs) {
      return;
    }
    _hapticStopwatch.reset();
    M3EHaptics.selection();
  }

  void _springBack(double speedMul) {
    _pushCtrl?.dispose();
    _pushCtrl = null;
    _detachPush = 0.0;
    _roundnessCtrl?.dispose();
    _roundnessCtrl = null;
    _roundnessFraction = 0.0;

    final ref = _dragSlotRef;
    _springCtrl?.dispose();
    _springCtrl =
        SingleMotionController(
            motion: const MaterialSpringMotion.expressiveSpatialDefault()
                .copyWith(stiffness: 380 * speedMul, damping: 0.6),
            vsync: this,
            initialValue: _dragOffset,
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _dragOffset = _springCtrl!.value);
            }
          })
          ..addStatusListener((s) {
            if ((s == AnimationStatus.completed ||
                    s == AnimationStatus.dismissed) &&
                mounted &&
                _dragSlotRef == ref) {
              _resetDragState();
            }
          })
          ..animateTo(0);

    _nbrCtrl?.dispose();
    _nbrCtrl =
        SingleMotionController(
            motion: const MaterialSpringMotion.expressiveSpatialDefault()
                .copyWith(stiffness: 380 * speedMul, damping: 0.6),
            vsync: this,
            initialValue: _neighbourFraction,
          )
          ..addListener(() {
            if (mounted) {
              setState(() => _neighbourFraction = _nbrCtrl!.value);
            }
          })
          ..animateTo(0);
  }

  Future<void> _dismiss(
    int slotIndex,
    double speedMul,
    DismissDirection direction,
  ) async {
    if (slotIndex < 0 || slotIndex >= _slots.length) {
      return;
    }
    final slot = _slots[slotIndex];
    final visible = computeVisibleIndices();
    final dataIndex = visible.indexOf(slotIndex);
    if (dataIndex < 0) {
      return;
    }

    final flyInitial = _captureDismissSlot(slot, dataIndex, direction);
    _disposeDragControllers();
    _markSlotCollapsing(slot);

    M3EHaptics.trigger(style.hapticOnThreshold);

    final colCtrl = _createCollapseController(slot, speedMul);
    _startFlyOut(slot, flyInitial, speedMul, colCtrl);
    onDismissCallback?.call(dataIndex, direction);
  }

  double _captureDismissSlot(
    M3EDismissibleSlot slot,
    int dataIndex,
    DismissDirection direction,
  ) {
    final size = _cardSize(slot);
    slot
      ..capturedHeight = size.height
      ..capturedWidth = size.width
      ..frozenChild = swipeItemBuilder(context, dataIndex)
      ..dismissedDirection = direction;

    final flyInitial = _dragOffset + _detachPush;
    slot.flyNotifier.value = flyInitial;
    return flyInitial;
  }

  void _disposeDragControllers() {
    _pushCtrl?.dispose();
    _pushCtrl = null;
    _nbrCtrl?.dispose();
    _nbrCtrl = null;
    _roundnessCtrl?.dispose();
    _roundnessCtrl = null;
  }

  void _markSlotCollapsing(M3EDismissibleSlot slot) {
    setState(() {
      slot.markCollapsing();
      _collapsingCount++;
      _dragSlotRef = null;
      _dragSlotIndex = -1;
      _dragOffset = 0.0;
      _detachPush = 0.0;
      _neighbourFraction = 0.0;
      _pastThreshold = false;
      _reEngaging = false;
      _roundnessFraction = 0.0;
    });
  }

  SingleMotionController _createCollapseController(
    M3EDismissibleSlot slot,
    double speedMul,
  ) {
    final colCtrl = SingleMotionController(
      motion: _kSpatialSpringBack.copyWith(
        stiffness: style.collapseSpeed * speedMul,
      ),
      vsync: this,
    );
    slot.collapseCtrl = colCtrl;
    colCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
        _finishCollapse(slot, colCtrl);
      }
    });
    return colCtrl;
  }

  void _finishCollapse(
    M3EDismissibleSlot slot,
    SingleMotionController colCtrl,
  ) {
    if (mounted) {
      final idx = _slots.indexOf(slot);
      if (idx >= 0) {
        setState(() {
          _slots.removeAt(idx);
          _collapsingCount--;
          _reindexDragSlot();
        });
        _measureKeys.remove(slot);
      }
    }
    slot
      ..disposeFlyNotifier()
      ..dispose();
    colCtrl.dispose();
  }

  void _startFlyOut(
    M3EDismissibleSlot slot,
    double flyInitial,
    double speedMul,
    SingleMotionController colCtrl,
  ) {
    final flySign = flyInitial.sign;
    final flyTarget = flySign == 0
        ? slot.capturedWidth + 80.0
        : flySign * (slot.capturedWidth + 80.0);

    slot.flyCtrl?.dispose();
    final flyCtrl = SingleMotionController(
      motion: const MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: 400 * speedMul,
        damping: 0.8,
      ),
      vsync: this,
      initialValue: flyInitial,
    );
    slot.flyCtrl = flyCtrl;

    var collapseStarted = false;
    void startCollapse() {
      if (collapseStarted) {
        return;
      }
      collapseStarted = true;
      colCtrl.animateTo(1);
    }

    flyCtrl
      ..addListener(() {
        slot.flyNotifier.value = flyCtrl.value;
        final totalDist = (flyTarget - flyInitial).abs();
        if (totalDist > 0) {
          final currentDist = (flyCtrl.value - flyInitial).abs();
          if (currentDist / totalDist > 0.9) {
            startCollapse();
          }
        }
      })
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
          slot.flyCtrl = null;
          flyCtrl.dispose();
          startCollapse();
        }
      })
      ..animateTo(flyTarget);
  }

  /// buildSlot.
}
