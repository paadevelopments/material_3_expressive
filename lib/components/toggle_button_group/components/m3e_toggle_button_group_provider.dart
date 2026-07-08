// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/widgets.dart';

import '../controllers/m3e_button_group_overflow_controller.dart';

/// Inherited widget for sharing the [M3EButtonGroupOverflowController].
///
/// [M3EButtonGroup] inserts this widget to provide its reactive
/// overflow state to internal components like the paging controls and
/// overflow triggers.
class M3EButtonGroupProvider extends InheritedWidget {
  /// Creates a button group provider.
  const M3EButtonGroupProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  /// The reactive overflow controller.
  final M3EButtonGroupOverflowController controller;

  /// Returns the [M3EButtonGroupOverflowController] from the nearest [M3EButtonGroupProvider].
  static M3EButtonGroupOverflowController? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<M3EButtonGroupProvider>()
        ?.controller;
  }

  /// Returns the nearest [M3EButtonGroupOverflowController].
  ///
  /// Throws a [FlutterError] if no provider is found.
  static M3EButtonGroupOverflowController of(BuildContext context) {
    final controller = maybeOf(context);
    assert(controller != null, '''
M3EButtonGroupProvider.of() called but no M3EButtonGroupProvider was found in the
widget tree.
''');
    return controller!;
  }

  @override
  bool updateShouldNotify(M3EButtonGroupProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
