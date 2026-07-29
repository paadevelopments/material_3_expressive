import 'dart:ui' show lerpDouble;
import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../../cards/m3e_cards.dart';
import '../components/m3e_list_item_scope.dart';
import '../models/m3e_dismissible_slot.dart';
import '../styles/m3e_dismissible_list_style.dart';

part 'm3e_dismissible_card_drag_mixin.dart';
part 'm3e_dismissible_card_build_mixin.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Spring presets (Material 3 Expressive via motor)
// ─────────────────────────────────────────────────────────────────────────────

final _kSpatialSpringBack =
    const MaterialSpringMotion.expressiveSpatialDefault().copyWith(
      stiffness: 200,
      damping: 0.8,
    );

final _kReEngageSpring = const MaterialSpringMotion.standardSpatialFast();

final _kDetachPush = const MaterialSpringMotion.expressiveSpatialDefault()
    .copyWith(stiffness: 800, damping: 0.95);

final _kRoundnessSnap = const MaterialSpringMotion.expressiveSpatialDefault()
    .copyWith(stiffness: 1000, damping: 0.4);

const _kCardSettleCurve = Cubic(0.34, 1.56, 0.64, 1);

const int _kVibrationThresholdMs = 60;
const double _kMaxPreDetachRoundness = 0.6;
const double _kPreThresholdRoundnessScale = 0.4;
const double _kDetachPushPixels = 30;

/// M3EDismissibleCardMixin.

// ─────────────────────────────────────────────────────────────────────────────
// Mixin — all shared drag / animation / build logic
// ─────────────────────────────────────────────────────────────────────────────

mixin M3EDismissibleCardMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  /// The swipeItemCount.
  int get swipeItemCount;

  /// swipeItemBuilder.
  Widget swipeItemBuilder(BuildContext context, int dataIndex);

  /// The style.
  M3EDismissibleListStyle get style;

  /// Callback invoked when a dismissible item is dismissed.
  Future<bool> Function(int index, DismissDirection direction)?
  get onDismissCallback;

  /// The Function.
  void Function(int index)? get onTapCallback;

  final List<M3EDismissibleSlot> _slots = [];
  M3EDismissibleSlot? _dragSlotRef;
  int _dragSlotIndex = -1;
  double _dragOffset = 0;
  bool _pastThreshold = false;
  bool _reEngaging = false;
  double _neighbourFraction = 0;
  double _roundnessFraction = 0;
  double _detachPush = 0;
  int _collapsingCount = 0;
  final Stopwatch _hapticStopwatch = Stopwatch()..start();
  final Map<M3EDismissibleSlot, GlobalKey> _measureKeys = {};

  SingleMotionController? _springCtrl;
  SingleMotionController? _nbrCtrl;
  SingleMotionController? _pushCtrl;
  SingleMotionController? _roundnessCtrl;

  /// computeVisibleIndices.

  List<int> computeVisibleIndices() => [
    for (int i = 0; i < _slots.length; i++)
      if (_slots[i].isVisible) i,
  ];

  /// The slots.

  List<M3EDismissibleSlot> get slots => List.unmodifiable(_slots);

  /// The isInteractionLocked.
  bool get isInteractionLocked => _dragSlotRef != null || _collapsingCount > 0;

  /// initSlots.

  void initSlots() => _syncSlots();

  /// syncSlotsIfNeeded.

  void syncSlotsIfNeeded(int oldItemCount) {
    if (swipeItemCount != oldItemCount) {
      _syncSlots();
    }
  }

  /// disposeSlots.

  void disposeSlots() {
    _springCtrl?.dispose();
    _nbrCtrl?.dispose();
    _pushCtrl?.dispose();
    _roundnessCtrl?.dispose();
    for (final slot in _slots) {
      slot
        ..dispose()
        ..disposeFlyNotifier();
    }
    _collapsingCount = 0;
  }

  void _syncSlots() {
    final visibleCount = _slots.where((s) => s.isVisible).length;
    if (visibleCount > swipeItemCount) {
      _removeExcessVisibleSlots(visibleCount - swipeItemCount);
    } else if (visibleCount < swipeItemCount) {
      _addMissingSlots(swipeItemCount - visibleCount);
    }
    _reindexDragSlot();
  }

  void _removeExcessVisibleSlots(int toRemove) {
    var remaining = toRemove;
    for (var i = _slots.length - 1; i >= 0 && remaining > 0; i--) {
      if (!_slots[i].isVisible) {
        continue;
      }
      final slot = _slots[i];
      _slots.removeAt(i);
      _measureKeys.remove(slot);
      slot.dispose();
      remaining--;
    }
  }

  void _addMissingSlots(int toAdd) {
    for (var i = 0; i < toAdd; i++) {
      _slots.add(M3EDismissibleSlot());
    }
  }

  void _reindexDragSlot() {
    if (_dragSlotRef == null) {
      _dragSlotIndex = -1;
      return;
    }
    _dragSlotIndex = _slots.indexOf(_dragSlotRef!);
    if (_dragSlotIndex < 0) {
      _dragSlotRef = null;
      _dragOffset = 0.0;
      _detachPush = 0.0;
    }
  }

  GlobalKey _measureKey(M3EDismissibleSlot slot) =>
      _measureKeys.putIfAbsent(slot, () => GlobalKey());

  Size _cardSize(M3EDismissibleSlot slot) {
    final box =
        _measureKeys[slot]?.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) {
      return const Size(320, 52);
    }
    return box.size;
  }

  double get _dragProgress {
    if (_dragSlotRef == null) {
      return 0;
    }
    final w = _cardSize(_dragSlotRef!).width;
    return (_dragOffset.abs() / (w * style.dismissThreshold)).clamp(0.0, 1.0);
  }

  /// computeRadius.

  BorderRadius computeRadius(
    int slotIndex,
    int slotPos,
    int dragPos,
    List<int> visible,
  ) {
    final s = style;
    if (slotPos < 0) {
      return BorderRadius.circular(s.outerRadius);
    }

    final total = visible.length;
    final isFirst = slotPos == 0;
    final isLast = slotPos == total - 1;

    final or = s.outerRadius;
    final sr = s.selectedBorderRadius ?? or;
    final ir = s.innerRadius;

    if (total == 1) {
      return BorderRadius.circular(or);
    }

    if (dragPos < 0 || (slotPos - dragPos).abs() > 1) {
      return BorderRadius.only(
        topLeft: Radius.circular(isFirst ? or : ir),
        topRight: Radius.circular(isFirst ? or : ir),
        bottomLeft: Radius.circular(isLast ? or : ir),
        bottomRight: Radius.circular(isLast ? or : ir),
      );
    }

    final facingR = lerpDouble(ir, or, _roundnessFraction)!;
    final subtleR = _pastThreshold
        ? ir
        : lerpDouble(ir, or, _roundnessFraction * 0.3)!;

    final isDragged = slotIndex == _dragSlotIndex;
    final isAbove = slotPos < dragPos;

    if (isDragged) {
      if (_pastThreshold) {
        return BorderRadius.circular(sr);
      }
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

  /// computeNeighbourOffset.

  // Implemented by M3EDismissibleCardDragMixin / M3EDismissibleCardBuildMixin
  double computeNeighbourOffset(int slotPos, int dragPos);

  /// handleDragStart.
  void handleDragStart(M3EDismissibleSlot slot);

  /// handleDragUpdate.
  void handleDragUpdate(DragUpdateDetails d);

  /// handleDragEnd.
  void handleDragEnd(DragEndDetails d);

  /// buildSlot.
  Widget buildSlot(BuildContext context, int slotIndex, [List<int>? visible]);
}
