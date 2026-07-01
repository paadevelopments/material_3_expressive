// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

/// Visual styles for [M3EButton] and [M3EToggleButton].
///
/// See also:
/// - [M3EButton] for the standard button widget
/// - [M3EToggleButton] for the toggle button widget
enum M3EButtonStyle {
  /// Solid background, high prominence.
  filled,

  /// Transparent background with a visible border.
  outlined,

  /// No background or border, lowest prominence.
  text,

  /// Surface-colored background with a shadow.
  elevated,

  /// Subdued background color, medium prominence.
  tonal,
}

/// Overall corner-radius strategy for buttons.
///
/// Used by [M3EButton] and [M3EButtonGroup] to control the button's
/// corner radius. [round] produces a pill shape, while [square] uses the
/// token-defined radius for the current size.
///
/// See also:
/// - [M3EButton] for the standard button widget
/// - [M3EButtonGroup] for the connected toggle button group
enum M3EButtonShape {
  /// Fully round pill shape (`height / 2`).
  round,

  /// Square corners using the token radius for the current size.
  square,
}

/// Standard size variants that map to Material 3 Expressive tokens.
///
/// Heights: xs=32dp, sm=40dp, md=56dp, lg=96dp, xl=136dp.
///
/// Used by [M3EButton], [M3EToggleButton], and [M3EButtonGroup].
///
/// See also:
/// - [M3EButton] for the standard button widget
/// - [M3EToggleButton] for the toggle button widget
/// - [M3EButtonGroup] for the connected toggle button group
class M3EButtonSize {
  const M3EButtonSize._(
    this.name, {
    this.height,
    this.hPadding,
    this.iconSize,
    this.iconGap,
    this.width,
  });

  /// The name of the size variant.
  final String name;

  /// Custom height override.
  final double? height;

  /// Custom horizontal padding override.
  final double? hPadding;

  /// Custom icon size override.
  final double? iconSize;

  /// Custom icon gap override.
  final double? iconGap;

  /// Custom width override.
  final double? width;

  /// 32 dp height.
  static const M3EButtonSize xs = M3EButtonSize._('xs');

  /// 40 dp height.
  static const M3EButtonSize sm = M3EButtonSize._('sm');

  /// 56 dp height.
  static const M3EButtonSize md = M3EButtonSize._('md');

  /// 96 dp height.
  static const M3EButtonSize lg = M3EButtonSize._('lg');

  /// 136 dp height.
  static const M3EButtonSize xl = M3EButtonSize._('xl');

  /// Creates a custom size variant with the specified overrides.
  factory M3EButtonSize.custom({
    double? height,
    double? hPadding,
    double? iconSize,
    double? iconGap,
    double? width,
  }) {
    return M3EButtonSize._(
      'custom',
      height: height,
      hPadding: hPadding,
      iconSize: iconSize,
      iconGap: iconGap,
      width: width,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is M3EButtonSize &&
          name == other.name &&
          height == other.height &&
          hPadding == other.hPadding &&
          iconSize == other.iconSize &&
          iconGap == other.iconGap &&
          width == other.width);

  @override
  int get hashCode =>
      Object.hash(name, height, hPadding, iconSize, iconGap, width);

  @override
  String toString() => 'M3EButtonSize.$name';
}

/// Haptic feedback intensity levels for button interactions.
///
/// Use with [M3EButtonDecoration.haptic] or [M3EToggleButtonDecoration.haptic]
/// to provide tactile feedback when buttons are pressed.
///
/// ## Levels
/// - [none] — No haptic feedback (default)
/// - [light] — Light tap feedback for subtle interactions
/// - [medium] — Medium impact for standard button presses
/// - [heavy] — Heavy impact for significant actions
enum M3EHapticFeedback {
  /// No haptic feedback.
  none(0),

  /// Light tap feedback.
  light(1),

  /// Medium impact feedback.
  medium(2),

  /// Heavy impact feedback.
  heavy(3);

  final int value;
  const M3EHapticFeedback(this.value);
}
