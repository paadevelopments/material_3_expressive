import 'package:flutter/foundation.dart';

import '../enums/m3e_button_enums.dart';

/// Resolved layout measurements for a button size variant.
@immutable
class M3EButtonMeasurements {
  const M3EButtonMeasurements({
    required this.height,
    required this.hPadding,
    required this.iconSize,
    required this.iconGap,
  });
  final double height;
  final double hPadding;
  final double iconSize;
  final double iconGap;

  M3EButtonMeasurements applyCustomSize(M3EButtonSize? custom) {
    if (custom == null) {
      return this;
    }
    return M3EButtonMeasurements(
      height: custom.height ?? height,
      hPadding: custom.hPadding ?? hPadding,
      iconSize: custom.iconSize ?? iconSize,
      iconGap: custom.iconGap ?? iconGap,
    );
  }
}
