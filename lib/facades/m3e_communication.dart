import 'package:flutter/widgets.dart';

import '../components/badges/badges.dart';
import '../components/loading_indicator/loading_indicator.dart';
import '../components/progress_indicators/progress_indicators.dart';
import '../components/snackbar/snackbar.dart';
import '../components/tooltips/tooltips.dart';

/// Static factories for the Material 3 *Communication* components, such as
/// `M3ECommunication.badge(...)` and `M3ECommunication.showSnackbar(...)`.
class M3ECommunication {
  const M3ECommunication._();

  /// Creates a badge. See [M3EBadge].
  static Widget badge({
    Widget? child,
    String? label,
    bool visible = true,
    Alignment alignment = const Alignment(0.75, -0.75),
    Key? key,
  }) {
    return M3EBadge(
      key: key,
      label: label,
      visible: visible,
      alignment: alignment,
      child: child,
    );
  }

  /// Creates a linear progress indicator. See [M3ELinearProgress].
  static Widget linearProgress({double? value, double height = 4, Key? key}) {
    return M3ELinearProgress(key: key, value: value, height: height);
  }

  /// Creates a circular progress indicator. See [M3ECircularProgress].
  static Widget circularProgress({
    double? value,
    double size = 40,
    double strokeWidth = 4,
    Key? key,
  }) {
    return M3ECircularProgress(
      key: key,
      value: value,
      size: size,
      strokeWidth: strokeWidth,
    );
  }

  /// Creates a loading indicator. See [M3ELoadingIndicator].
  static Widget loadingIndicator({
    double size = 48,
    Color? color,
    bool contained = false,
    Key? key,
  }) {
    return M3ELoadingIndicator(
      key: key,
      size: size,
      color: color,
      contained: contained,
    );
  }

  /// Wraps [child] with a tooltip. See [M3ETooltip].
  static Widget tooltip({
    required Widget child,
    String? message,
    String? richTitle,
    String? richMessage,
    List<Widget> actions = const <Widget>[],
    Key? key,
  }) {
    return M3ETooltip(
      key: key,
      message: message,
      richTitle: richTitle,
      richMessage: richMessage,
      actions: actions,
      child: child,
    );
  }

  /// Shows a snackbar over the nearest overlay. See [M3ESnackbar.show].
  static void showSnackbar(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    M3ESnackbar.show(
      context,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }
}
