import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../../buttons/res/m3e_button_constants.dart';
import '../models/m3e_dismissible_slot.dart';
import '../styles/m3e_dismissible_list_style.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Spring presets (Material 3 Expressive via motor)
// ─────────────────────────────────────────────────────────────────────────────

final _kSpatialSpringBack = MaterialSpringMotion.expressiveSpatialDefault()
    .copyWith(stiffness: 200, damping: 0.8);

final _kReEngageSpring = MaterialSpringMotion.standardSpatialFast();

final _kDetachPush = MaterialSpringMotion.expressiveSpatialDefault().copyWith(
  stiffness: 800,
  damping: 0.95,
);

final _kRoundnessSnap = MaterialSpringMotion.expressiveSpatialDefault()
    .copyWith(stiffness: 1000, damping: 0.4);

const _kCardSettleCurve = Cubic(0.34, 1.56, 0.64, 1);

// ─────────────────────────────────────────────────────────────────────────────
// Mixin — all shared drag / animation / build logic
// ─────────────────────────────────────────────────────────────────────────────

mixin M3EDismissibleCardMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  int get swipeItemCount;
  Widget swipeItemBuilder(BuildContext context, int dataIndex);
  M3EDismissibleListStyle get style;
  Future<bool> Function(int index, DismissDirection direction)?
      get onDismissCallback;
  void Function(int index)? get onTapCallback;

  final List<M3EDismissibleSlot> _slots = [];
  M3EDismissibleSlot? _dragSlotRef;
  int _dragSlotIndex = -1;
  double _dragOffset = 0.0;
  bool _pastThreshold = false;
  bool _reEngaging = false;
  double _neighbourFraction = 0.0;
  double _roundnessFraction = 0.0;
  double _detachPush = 0.0;
  int _collapsingCount = 0;
  final Stopwatch _hapticStopwatch = Stopwatch()..start();
  final Map<M3EDismissibleSlot, GlobalKey> _measureKeys = {};

  SingleMotionController? _springCtrl;
  SingleMotionController? _nbrCtrl;
  SingleMotionController? _pushCtrl;
  SingleMotionController? _roundnessCtrl;

  static const int _kVibrationThresholdMs = 60;
  static const double _kMaxPreDetachRoundness = 0.6;
  static const double _kPreThresholdRoundnessScale = 0.4;
  static const double _kDetachPushPixels = 30.0;

  List<int> computeVisibleIndices() => [
        for (int i = 0; i < _slots.length; i++)
          if (_slots[i].isVisible) i,
      ];

  List<M3EDismissibleSlot> get slots => List.unmodifiable(_slots);
  bool get isInteractionLocked => _dragSlotRef != null || _collapsingCount > 0;

  void initSlots() => _syncSlots();

  void syncSlotsIfNeeded(int oldItemCount) {
    if (swipeItemCount != oldItemCount) _syncSlots();
  }

  void disposeSlots() {
    _springCtrl?.dispose();
    _nbrCtrl?.dispose();
    _pushCtrl?.dispose();
    _roundnessCtrl?.dispose();
    for (final slot in _slots) {
      slot.dispose();
      slot.disposeFlyNotifier();
    }
    _collapsingCount = 0;
  }

  void _syncSlots() {
    final visibleCount = _slots.where((s) => s.isVisible).length;
    if (visibleCount > swipeItemCount) {
      int toRemove = visibleCount - swipeItemCount;
      for (int i = _slots.length - 1; i >= 0 && toRemove > 0; i--) {
        if (_slots[i].isVisible) {
          final slot = _slots[i];
          _slots.removeAt(i);
          _measureKeys.remove(slot);
          slot.dispose();
          toRemove--;
        }
      }
    } else if (visibleCount < swipeItemCount) {
      final toAdd = swipeItemCount - visibleCount;
      for (int i = 0; i < toAdd; i++) {
        _slots.add(M3EDismissibleSlot());
      }
    }
    _reindexDragSlot();
  }

  void _reindexDragSlot() {
    if (_dragSlotRef != null) {
      _dragSlotIndex = _slots.indexOf(_dragSlotRef!);
      if (_dragSlotIndex < 0) {
        _dragSlotRef = null;
        _dragOffset = 0.0;
        _detachPush = 0.0;
      }
    } else {
      _dragSlotIndex = -1;
    }
  }

  GlobalKey _measureKey(M3EDismissibleSlot slot) =>
      _measureKeys.putIfAbsent(slot, () => GlobalKey());

  Size _cardSize(M3EDismissibleSlot slot) {
    final box =
        _measureKeys[slot]?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return const Size(320, 52);
    return box.size;
  }

  double get _dragProgress {
    if (_dragSlotRef == null) return 0.0;
    final w = _cardSize(_dragSlotRef!).width;
    return (_dragOffset.abs() / (w * style.dismissThreshold)).clamp(0.0, 1.0);
  }

  BorderRadius computeRadius(
    int slotIndex,
    int slotPos,
    int dragPos,
    List<int> visible,
  ) {
    final s = style;
    if (slotPos < 0) return BorderRadius.circular(s.outerRadius);

    final total = visible.length;
    final isFirst = slotPos == 0;
    final isLast = slotPos == total - 1;

    final or = s.outerRadius;
    final sr = s.selectedBorderRadius ?? or;
    final ir = s.innerRadius;

    if (total == 1) return BorderRadius.circular(or);

    if (dragPos < 0 || (slotPos - dragPos).abs() > 1) {
      return BorderRadius.only(
        topLeft: Radius.circular(isFirst ? or : ir),
        topRight: Radius.circular(isFirst ? or : ir),
        bottomLeft: Radius.circular(isLast ? or : ir),
        bottomRight: Radius.circular(isLast ? or : ir),
      );
    }

    final facingR = lerpDouble(ir, or, _roundnessFraction)!;
    final subtleR =
        _pastThreshold ? ir : lerpDouble(ir, or, _roundnessFraction * 0.3)!;

    final isDragged = slotIndex == _dragSlotIndex;
    final isAbove = slotPos < dragPos;

    if (isDragged) {
      if (_pastThreshold) return BorderRadius.circular(sr);
      return BorderRadius.only(
        topLeft: Radius.circular(isFirst ? or : facingR),
        topRight: Radius.circular(isFirst ? or : facingR),
        bottomLeft: Radius.circular(isLast ? or : facingR),
        bottomRight: Radius.circular(isLast ? or : facingR),
      );
    }

    if (isAbove) {
      return BorderRadius.only(
        topLeft: Radius.circular(isFirst ? or : subtleR),
        topRight: Radius.circular(isFirst ? or : subtleR),
        bottomLeft: Radius.circular(isLast ? or : facingR),
        bottomRight: Radius.circular(isLast ? or : facingR),
      );
    }

    return BorderRadius.only(
      topLeft: Radius.circular(isFirst ? or : facingR),
      topRight: Radius.circular(isFirst ? or : facingR),
      bottomLeft: Radius.circular(isLast ? or : subtleR),
      bottomRight: Radius.circular(isLast ? or : subtleR),
    );
  }

  double computeNeighbourOffset(int slotPos, int dragPos) {
    if (dragPos < 0 || slotPos < 0) return 0.0;
    final distance = (slotPos - dragPos).abs();
    if (distance == 0 || distance > style.neighbourReach) return 0.0;

    final reach = style.neighbourReach;
    final falloff = reach > 1 ? (reach - distance) / (reach - 1) : 1.0;

    return _neighbourFraction * style.neighbourPull * falloff * _dragOffset.sign;
  }

  void handleDragStart(M3EDismissibleSlot slot) {
    if (!slot.isVisible) return;

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

  void handleDragUpdate(DragUpdateDetails d) {
    if (_dragSlotRef == null) return;

    final double swipeSpeed = d.delta.dx.abs();
    final double multiplier = (1.0 + (swipeSpeed / 5.0)).clamp(1.0, 4.0);

    double newOffset = _dragOffset + d.delta.dx;
    double newNeighbour = _neighbourFraction;
    double newRoundness = _roundnessFraction;

    final savedOffset = _dragOffset;
    _dragOffset = newOffset;
    final newProgress = _dragProgress;
    _dragOffset = savedOffset;

    final crossedNow = newProgress >= 1.0;

    if (crossedNow && !_pastThreshold) {
      _pastThreshold = true;
      M3EButtonConstants.triggerHapticFeedback(style.hapticOnThreshold);

      final pushDir = newOffset.sign;
      _pushCtrl?.dispose();
      _pushCtrl = SingleMotionController(
        motion: _kDetachPush.copyWith(stiffness: 800 * multiplier),
        vsync: this,
        initialValue: 0.0,
      )
        ..addListener(() {
          if (mounted) setState(() => _detachPush = _pushCtrl!.value);
        })
        ..animateTo(
          style.background == null || style.secondaryBackground == null
              ? pushDir * _kDetachPushPixels
              : 0,
        );

      _nbrCtrl?.dispose();
      _nbrCtrl = SingleMotionController(
        motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
          stiffness: 800 * multiplier,
          damping: 0.7,
        ),
        vsync: this,
        initialValue: _neighbourFraction,
      )
        ..addListener(() {
          if (mounted) setState(() => _neighbourFraction = _nbrCtrl!.value);
        })
        ..animateTo(0.0);

      _roundnessCtrl?.dispose();
      _roundnessCtrl = SingleMotionController(
        motion: _kRoundnessSnap.copyWith(stiffness: 1000 * multiplier),
        vsync: this,
        initialValue: _roundnessFraction,
      )
        ..addListener(() {
          if (mounted) setState(() => _roundnessFraction = _roundnessCtrl!.value);
        })
        ..animateTo(1.0);
    } else if (!crossedNow && _pastThreshold) {
      _pastThreshold = false;
      _reEngaging = true;
      M3EButtonConstants.triggerHapticFeedback(style.hapticOnThreshold);

      _pushCtrl?.dispose();
      _pushCtrl = SingleMotionController(
        motion: _kDetachPush.copyWith(stiffness: 800 * multiplier),
        vsync: this,
        initialValue: _detachPush,
      )
        ..addListener(() {
          if (mounted) setState(() => _detachPush = _pushCtrl!.value);
        })
        ..animateTo(0.0);

      _dragOffset = newOffset;
      final target = _dragProgress;
      _dragOffset = savedOffset;

      _nbrCtrl?.dispose();
      _nbrCtrl = SingleMotionController(
        motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
          stiffness: 800 * multiplier,
          damping: 0.7,
        ),
        vsync: this,
        initialValue: _neighbourFraction,
      )
        ..addListener(() {
          if (mounted) setState(() => _neighbourFraction = _nbrCtrl!.value);
        })
        ..addStatusListener((s) {
          if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
            _reEngaging = false;
          }
        })
        ..animateTo(target);

      _roundnessCtrl?.dispose();
      _roundnessCtrl = SingleMotionController(
        motion: _kReEngageSpring.copyWith(stiffness: 800 * multiplier),
        vsync: this,
        initialValue: _roundnessFraction,
      )
        ..addListener(() {
          if (mounted) setState(() => _roundnessFraction = _roundnessCtrl!.value);
        })
        ..animateTo(target * _kPreThresholdRoundnessScale);
    } else if (!_pastThreshold) {
      if (_reEngaging) {
        _reEngaging = false;
        _nbrCtrl?.stop(canceled: true);
        _roundnessCtrl?.stop(canceled: true);
      }
      newNeighbour = newProgress;
      newRoundness = (newProgress * _kMaxPreDetachRoundness).clamp(
        0.0,
        _kMaxPreDetachRoundness,
      );
      if (style.dismissHapticStream) _playPullHaptics();
    }

    setState(() {
      _dragOffset = newOffset;
      _neighbourFraction = newNeighbour;
      _roundnessFraction = newRoundness;
    });
  }

  void handleDragEnd(DragEndDetails d) {
    if (_dragSlotRef == null) return;
    _reindexDragSlot();
    if (_dragSlotIndex < 0) {
      _resetDragState();
      return;
    }

    final velocity = d.velocity.pixelsPerSecond.dx.abs();
    final double speedMul = (1.0 + (velocity / 1000.0)).clamp(1.0, 4.0);

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
    if (!style.enableFeedback) return;
    if (_hapticStopwatch.elapsedMilliseconds < _kVibrationThresholdMs) return;
    _hapticStopwatch.reset();
    HapticFeedback.selectionClick();
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
    _springCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: 380 * speedMul,
        damping: 0.6,
      ),
      vsync: this,
      initialValue: _dragOffset,
    )
      ..addListener(() {
        if (mounted) setState(() => _dragOffset = _springCtrl!.value);
      })
      ..addStatusListener((s) {
        if ((s == AnimationStatus.completed || s == AnimationStatus.dismissed) &&
            mounted &&
            _dragSlotRef == ref) {
          _resetDragState();
        }
      })
      ..animateTo(0.0);

    _nbrCtrl?.dispose();
    _nbrCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: 380 * speedMul,
        damping: 0.6,
      ),
      vsync: this,
      initialValue: _neighbourFraction,
    )
      ..addListener(() {
        if (mounted) setState(() => _neighbourFraction = _nbrCtrl!.value);
      })
      ..animateTo(0.0);
  }

  Future<void> _dismiss(
    int slotIndex,
    double speedMul,
    DismissDirection direction,
  ) async {
    if (slotIndex < 0 || slotIndex >= _slots.length) return;
    final slot = _slots[slotIndex];
    final visible = computeVisibleIndices();
    final dataIndex = visible.indexOf(slotIndex);
    if (dataIndex < 0) return;

    final size = _cardSize(slot);
    slot.capturedHeight = size.height;
    slot.capturedWidth = size.width;
    slot.frozenChild = swipeItemBuilder(context, dataIndex);
    slot.dismissedDirection = direction;

    final flyInitial = _dragOffset + _detachPush;
    slot.flyNotifier.value = flyInitial;

    _pushCtrl?.dispose();
    _pushCtrl = null;
    _nbrCtrl?.dispose();
    _nbrCtrl = null;
    _roundnessCtrl?.dispose();
    _roundnessCtrl = null;

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

    final colCtrl = SingleMotionController(
      motion: _kSpatialSpringBack.copyWith(stiffness: style.collapseSpeed * speedMul),
      vsync: this,
      initialValue: 0.0,
    );
    slot.collapseCtrl = colCtrl;

    colCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
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
        slot.disposeFlyNotifier();
        slot.dispose();
        colCtrl.dispose();
      }
    });

    final flySign = flyInitial.sign;
    final flyTarget = flySign == 0
        ? slot.capturedWidth + 80.0
        : flySign * (slot.capturedWidth + 80.0);

    slot.flyCtrl?.dispose();
    final flyCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveSpatialDefault().copyWith(
        stiffness: 400 * speedMul,
        damping: 0.8,
      ),
      vsync: this,
      initialValue: flyInitial,
    );
    slot.flyCtrl = flyCtrl;

    bool collapseStarted = false;
    flyCtrl
      ..addListener(() {
        slot.flyNotifier.value = flyCtrl.value;
        final totalDist = (flyTarget - flyInitial).abs();
        if (totalDist > 0) {
          final currentDist = (flyCtrl.value - flyInitial).abs();
          if (currentDist / totalDist > 0.9 && !collapseStarted) {
            collapseStarted = true;
            colCtrl.animateTo(1.0);
          }
        }
      })
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed || s == AnimationStatus.dismissed) {
          slot.flyCtrl = null;
          flyCtrl.dispose();
          if (!collapseStarted) {
            collapseStarted = true;
            colCtrl.animateTo(1.0);
          }
        }
      })
      ..animateTo(flyTarget);

    onDismissCallback?.call(dataIndex, direction);
  }

  Widget buildSlot(BuildContext context, int slotIndex, [List<int>? visible]) {
    final slot = _slots[slotIndex];
    if (slot.isCollapsing) return _buildCollapsingCard(context, slotIndex);
    return _buildActiveCard(context, slotIndex, visible ?? computeVisibleIndices());
  }

  Widget _buildCollapsingCard(BuildContext context, int slotIndex) {
    final slot = _slots[slotIndex];
    final ctrl = slot.collapseCtrl!;
    final totalH = slot.capturedHeight + style.gap;
    final s = style;

    final bool swipingRight = slot.dismissedDirection == DismissDirection.startToEnd;
    final bgRadius = swipingRight
        ? s.backgroundBorderRadius
        : (s.secondaryBackgroundBorderRadius ?? s.backgroundBorderRadius);
    final cardRadius = s.selectedBorderRadius ?? s.outerRadius;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: ctrl,
        child: slot.frozenChild == null
            ? null
            : Stack(
                children: [
                  if (slot.dismissedDirection != null)
                    ValueListenableBuilder<double>(
                      valueListenable: slot.flyNotifier,
                      builder: (_, flyOff, child) {
                        final progress = flyOff.abs();
                        final swipingRight =
                            slot.dismissedDirection == DismissDirection.startToEnd;
                        return Positioned.fill(
                          bottom: s.gap,
                          child: Align(
                            alignment: swipingRight ? Alignment.centerLeft : Alignment.centerRight,
                            child: SizedBox(
                              width: progress,
                              height: double.infinity,
                              child: Padding(
                                padding: s.margin ?? EdgeInsets.zero,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(bgRadius),
                                  child: swipingRight
                                      ? s.background
                                      : (s.secondaryBackground ?? s.background),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  Padding(
                    padding: EdgeInsets.only(bottom: s.gap),
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      minWidth: slot.capturedWidth > 0 ? slot.capturedWidth : 0,
                      maxWidth: slot.capturedWidth > 0
                          ? slot.capturedWidth
                          : MediaQuery.sizeOf(context).width,
                      minHeight: 0,
                      maxHeight: slot.capturedHeight,
                      child: IgnorePointer(
                        child: ValueListenableBuilder<double>(
                          valueListenable: slot.flyNotifier,
                          builder: (_, flyOff, child) => Transform.translate(
                            offset: Offset(flyOff, 0),
                            child: child,
                          ),
                          child: Padding(
                            padding: s.margin ?? EdgeInsets.zero,
                            child: _FlyingCard(
                              borderRadius: BorderRadius.circular(cardRadius),
                              color: s.color ?? M3ETheme.of(context).colorScheme.surfaceContainerHighest,
                              elevation: s.elevation + 6,
                              border: s.border,
                              padding: s.padding ?? const EdgeInsets.all(16),
                              child: slot.frozenChild!,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        builder: (ctx, child) {
          final h = (totalH * (1.0 - ctrl.value)).clamp(0.0, totalH);
          return SizedBox(height: h, width: double.infinity, child: child);
        },
      ),
    );
  }

  Widget _buildActiveCard(BuildContext context, int slotIndex, List<int> visible) {
    final slot = _slots[slotIndex];
    final s = style;
    final slotPos = visible.indexOf(slotIndex);
    if (slotPos < 0 || slotPos >= swipeItemCount) return const SizedBox.shrink();

    final total = visible.length;
    final isLast = slotPos == total - 1;
    final isDragged = slotIndex == _dragSlotIndex;
    final dragPos = _dragSlotIndex >= 0 ? visible.indexOf(_dragSlotIndex) : -1;
    final br = computeRadius(slotIndex, slotPos, dragPos, visible);
    final nOff = computeNeighbourOffset(slotPos, dragPos);

    final bool swipingRight = _dragOffset > 0;
    final Widget? activeBg = swipingRight ? s.background : (s.secondaryBackground ?? s.background);
    final bgRadius = swipingRight ? s.backgroundBorderRadius : (s.secondaryBackgroundBorderRadius ?? s.backgroundBorderRadius);

    return RepaintBoundary(
      child: Padding(
        padding: s.margin ?? EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isDragged && _dragOffset != 0 && activeBg != null)
              Positioned.fill(
                bottom: isLast ? 0 : s.gap,
                child: RepaintBoundary(
                  child: Align(
                    alignment: swipingRight ? Alignment.centerLeft : Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(bgRadius),
                      child: SizedBox(
                        width: _dragOffset.abs(),
                        height: double.infinity,
                        child: Opacity(
                          opacity: (_dragProgress * 3.0).clamp(0.0, 1.0),
                          child: _buildActiveBackground(activeBg, _dragProgress),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : s.gap),
              child: Transform.translate(
                offset: Offset(isDragged ? _dragOffset + _detachPush : nOff, 0),
                child: GestureDetector(
                  onHorizontalDragStart: (_) => handleDragStart(slot),
                  onHorizontalDragUpdate: handleDragUpdate,
                  onHorizontalDragEnd: handleDragEnd,
                  child: _AnimatedCard(
                    cardKey: _measureKey(slot),
                    borderRadius: br,
                    color: s.color ?? M3ETheme.of(context).colorScheme.surfaceContainerHighest,
                    elevation: isDragged ? s.elevation + 6 : s.elevation,
                    border: s.border,
                    isDragged: isDragged,
                    hasActiveDrag: _dragSlotRef != null,
                    child: InkWell(
                      splashColor: s.splashColor,
                      highlightColor: s.highlightColor,
                      splashFactory: s.splashFactory,
                      enableFeedback: s.enableFeedback,
                      onTap: isInteractionLocked || onTapCallback == null ? null : () {
                        onTapCallback!(slotPos);
                        M3EButtonConstants.triggerHapticFeedback(s.hapticOnTap);
                      },
                      child: Padding(
                        padding: s.padding ?? const EdgeInsets.all(16.0),
                        child: swipeItemBuilder(context, slotPos),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveBackground(Widget? bg, double progress) {
    if (bg == null) return const SizedBox.shrink();
    final iconOpacity = progress < 0.3 ? 0.0 : ((progress - 0.3) / 0.7).clamp(0.0, 1.0);
    final iconScale = progress < 0.3 ? 0.8 : (0.8 + ((progress - 0.3) / 0.7) * 0.2).clamp(0.0, 1.0);

    Widget wrapChild(Widget? child) {
      if (child == null) return const SizedBox.shrink();
      return Transform.scale(
        scale: iconScale,
        child: Opacity(opacity: iconOpacity, child: child),
      );
    }

    if (bg is Container) {
      return Container(
        alignment: bg.alignment,
        padding: bg.padding,
        color: bg.color,
        decoration: bg.decoration,
        foregroundDecoration: bg.foregroundDecoration,
        constraints: bg.constraints,
        margin: bg.margin,
        transform: bg.transform,
        transformAlignment: bg.transformAlignment,
        clipBehavior: bg.clipBehavior,
        child: bg.child != null ? wrapChild(bg.child) : null,
      );
    }
    if (bg is ColoredBox) return ColoredBox(color: bg.color, child: wrapChild(bg.child));
    if (bg is DecoratedBox) {
      return DecoratedBox(
        decoration: bg.decoration,
        position: bg.position,
        child: wrapChild(bg.child),
      );
    }
    return wrapChild(bg);
  }
}

class _AnimatedCard extends StatefulWidget {
  final GlobalKey cardKey;
  final BorderRadius borderRadius;
  final Color color;
  final double elevation;
  final BorderSide? border;
  final bool isDragged;
  final bool hasActiveDrag;
  final Widget child;

  const _AnimatedCard({
    required this.cardKey,
    required this.borderRadius,
    required this.color,
    required this.elevation,
    required this.isDragged,
    required this.hasActiveDrag,
    this.border,
    required this.child,
  });

  @override
  State<_AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> {
  late BoxDecoration _decoration;

  @override
  void initState() {
    super.initState();
    _decoration = _buildDecoration();
  }

  @override
  void didUpdateWidget(_AnimatedCard old) {
    super.didUpdateWidget(old);
    if (old.color != widget.color ||
        old.borderRadius != widget.borderRadius ||
        old.elevation != widget.elevation ||
        old.isDragged != widget.isDragged ||
        old.border != widget.border) {
      _decoration = _buildDecoration();
    }
  }

  BoxDecoration _buildDecoration() => BoxDecoration(
        color: widget.color,
        borderRadius: widget.borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06 + widget.elevation * 0.015),
            blurRadius: 4 + widget.elevation * 2,
            spreadRadius: widget.isDragged ? 1 : 0,
            offset: Offset(0, widget.isDragged ? 4 : 2),
          ),
        ],
        border: widget.border != null
            ? Border.all(color: widget.border!.color, width: widget.border!.width)
            : null,
      );

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.infinity,
      duration: widget.hasActiveDrag ? Duration.zero : const Duration(milliseconds: 520),
      curve: _kCardSettleCurve,
      decoration: _decoration,
      clipBehavior: Clip.antiAlias,
      child: Material(
        key: widget.cardKey,
        color: Colors.transparent,
        child: widget.child,
      ),
    );
  }
}

class _FlyingCard extends StatelessWidget {
  final BorderRadius borderRadius;
  final Color color;
  final double elevation;
  final BorderSide? border;
  final EdgeInsetsGeometry padding;
  final Widget child;

  const _FlyingCard({
    required this.borderRadius,
    required this.color,
    required this.elevation,
    this.border,
    required this.padding,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06 + elevation * 0.015),
            blurRadius: 4 + elevation * 2,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
        border: border != null
            ? Border.all(color: border!.color, width: border!.width)
            : null,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Material(
          color: Colors.transparent,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
