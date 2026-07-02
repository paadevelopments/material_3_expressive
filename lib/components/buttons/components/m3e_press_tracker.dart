// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/scheduler.dart';
import '../styles/m3e_button_tokens.dart';

class PressTracker {
  int? _pressedIndex;
  double _pressProgress = 0.0;
  bool _isWaitingForRelease = false;
  Duration? _releaseDeadline;

  int? get pressedIndex => _pressedIndex;
  double get pressProgress => _pressProgress;
  bool get isWaitingForRelease => _isWaitingForRelease;

  void setPressedIndex(int? index) {
    _pressedIndex = index;
  }

  void updateProgress(double progress) {
    _pressProgress = progress;
  }

  bool checkRelease() {
    if (!_isWaitingForRelease) return false;

    final timedOut =
        _releaseDeadline != null &&
        SchedulerBinding.instance.currentFrameTimeStamp >= _releaseDeadline!;

    if (_pressProgress >= M3EButtonConstants.kPressReleaseThreshold || timedOut) {
      _isWaitingForRelease = false;
      _releaseDeadline = null;
      _pressProgress = 0.0;
      return true;
    }
    return false;
  }

  void scheduleReleaseCheck(void Function() onRelease) {
    _isWaitingForRelease = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _releaseDeadline =
          SchedulerBinding.instance.currentFrameTimeStamp +
          M3EButtonConstants.kReleaseTimeout;
      if (checkRelease()) {
        onRelease();
      }
    });
  }

  void cancelRelease() {
    _isWaitingForRelease = false;
    _releaseDeadline = null;
  }

  void reset() {
    _pressedIndex = null;
    _pressProgress = 0.0;
    _isWaitingForRelease = false;
    _releaseDeadline = null;
  }
}
