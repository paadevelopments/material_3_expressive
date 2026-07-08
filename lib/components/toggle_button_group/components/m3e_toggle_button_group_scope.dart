// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

import '../../buttons/enums/m3e_button_enums.dart';
import '../enums/m3e_toggle_button_group_enums.dart';

// ---------------------------------------------------------------------------
// M3EButtonGroupScope
// ---------------------------------------------------------------------------

/// Provides group-level configuration to every descendant button.
///
/// [M3EButtonGroup] and [M3EButtonGroup] insert this widget at their
/// root. Individual buttons call [M3EButtonGroupScope.maybeOf] to read the
/// group's [type], [shape], [size], [density], and [direction] so they can
/// adapt their appearance without needing explicit props drilled through every
/// layer.
///
/// This is the Flutter equivalent of Compose's `ButtonGroupScope` — an
/// implicit ambient context rather than an explicit parameter cascade.
@immutable
class M3EButtonGroupScope extends InheritedWidget {
  const M3EButtonGroupScope({
    super.key,
    required super.child,
    required this.type,
    required this.shape,
    required this.size,
    required this.density,
    required this.direction,
  });

  final M3EButtonGroupType type;
  final M3EButtonShape shape;
  final M3EButtonSize size;
  final M3EButtonGroupDensity density;

  /// Primary layout axis of the group.
  final Axis direction;

  /// Convenience getter; avoids importing the enum at call sites.
  bool get isConnected => type == M3EButtonGroupType.connected;

  /// Returns null when there is no [M3EButtonGroupScope] ancestor.
  static M3EButtonGroupScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<M3EButtonGroupScope>();

  /// Returns the nearest [M3EButtonGroupScope].
  ///
  /// Throws a [FlutterError] with a useful message when no scope is found,
  /// rather than a null-deref crash.
  static M3EButtonGroupScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, '''
M3EButtonGroupScope.of() called but no M3EButtonGroupScope was found in the
widget tree above this context.

Make sure the button is a descendant of M3EButtonGroup or M3EButtonGroup.
''');
    return scope!;
  }

  @override
  bool updateShouldNotify(M3EButtonGroupScope old) =>
      type != old.type ||
      shape != old.shape ||
      size != old.size ||
      density != old.density ||
      direction != old.direction;
}
