import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Design tokens for `M3ESnackbar`, following the Material 3 snackbar specs.
///
/// See https://m3.material.io/components/snackbar/specs.
class M3ESnackbarTokens {
  const M3ESnackbarTokens._();

  /// Size constraints of the snackbar surface.
  static const double minHeight = 48;
  static const double maxWidth = 600;

  /// Inner padding of the snackbar content.
  static const EdgeInsets contentPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  /// Elevation of the snackbar surface.
  static const double elevation = M3EElevation.level3;

  /// Default display duration.
  static const Duration defaultDuration = Duration(seconds: 4);

  /// Overlay positioning insets.
  static const double overlayHorizontalInset = 16;
  static const double overlayBottomInset = 16;

  /// Action button padding and gap from the message.
  static const EdgeInsets actionPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const double actionGap = 8;

  /// Container corner radius (M3 extra-small shape).
  static BorderRadius get borderRadius => M3EShapes.radiusExtraSmall;

  /// Container color of the snackbar.
  static Color containerColor(M3EColorScheme scheme) => scheme.inverseSurface;

  /// Message text style.
  static TextStyle messageStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyMedium.copyWith(color: scheme.onInverseSurface);

  /// Action label text style.
  static TextStyle actionStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelLarge.copyWith(color: scheme.inversePrimary);
}
