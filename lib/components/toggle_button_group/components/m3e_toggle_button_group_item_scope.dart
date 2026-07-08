// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

/// Provides per-button positional data within the group.
///
/// Inserted by the group's layout pass around each child so that buttons can
/// decide:
/// - which outer corners to lock at the full-round radius (first / last)
/// - which inner corners to animate (all middle edges)
/// - whether to suppress the minimum-width floor when being squeezed by the
///   neighbor-squish animation
@immutable
class M3EButtonGroupItemScope extends InheritedWidget {
  const M3EButtonGroupItemScope({
    super.key,
    required super.child,
    required this.index,
    required this.count,
    bool? visualIsFirst,
    bool? visualIsLast,
  }) : _visualIsFirst = visualIsFirst,
       _visualIsLast = visualIsLast;

  final bool? _visualIsFirst;
  final bool? _visualIsLast;

  /// Zero-based position in the group's action list.
  final int index;

  /// Total number of visible buttons (excludes the overflow trigger).
  final int count;

  bool get isFirst => _visualIsFirst ?? index == 0;
  bool get isLast => _visualIsLast ?? index == count - 1;
  bool get isOnly => count == 1;

  static M3EButtonGroupItemScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<M3EButtonGroupItemScope>();

  static M3EButtonGroupItemScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, '''
M3EButtonGroupItemScope.of() called but no M3EButtonGroupItemScope ancestor was
found. Each button in M3EButtonGroup/M3EButtonGroup is automatically
wrapped in one — this error means you are calling of() from outside a group.
''');
    return scope!;
  }

  @override
  bool updateShouldNotify(M3EButtonGroupItemScope old) =>
      index != old.index ||
      count != old.count ||
      _visualIsFirst != old._visualIsFirst ||
      _visualIsLast != old._visualIsLast;
}
