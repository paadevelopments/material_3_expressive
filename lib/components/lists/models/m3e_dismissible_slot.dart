import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

enum _SlotStatus { visible, collapsing }

/// Lightweight per-item bookkeeping for a dismissible card slot.
class M3EDismissibleSlot {
  _SlotStatus _status;
  double capturedHeight = 0;
  double capturedWidth = 0;
  DismissDirection? dismissedDirection;
  SingleMotionController? collapseCtrl;
  SingleMotionController? flyCtrl;
  final ValueNotifier<double> flyNotifier = ValueNotifier(0);
  bool _flyDisposed = false;
  Widget? frozenChild;
  final Object identity = Object();

  M3EDismissibleSlot() : _status = _SlotStatus.visible;

  bool get isVisible => _status == _SlotStatus.visible;
  bool get isCollapsing => _status == _SlotStatus.collapsing;

  /// Transitions the slot into the collapsing state.
  void markCollapsing() => _status = _SlotStatus.collapsing;

  void dispose() {
    collapseCtrl?.dispose();
    flyCtrl?.dispose();
    disposeFlyNotifier();
  }

  void disposeFlyNotifier() {
    if (!_flyDisposed) {
      _flyDisposed = true;
      flyNotifier.dispose();
    }
  }
}
