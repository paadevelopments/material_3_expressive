import 'package:flutter/widgets.dart';
import 'package:material_new_shapes/material_new_shapes.dart';

import '../components/badges/badges.dart';
import '../components/loading_indicator/loading_indicator.dart';
import '../components/progress_indicators/enums/m3e_progress_enums.dart';
import '../components/progress_indicators/progress_indicators.dart';
import '../components/refresh_indicator/enums/m3e_refresh_status.dart';
import '../components/refresh_indicator/refresh_indicator.dart';
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
  static Widget linearProgress({
    double? value,
    M3ELinearProgressSize size = M3ELinearProgressSize.m,
    M3EProgressShape shape = M3EProgressShape.wavy,
    Color? activeColor,
    Color? trackColor,
    double phase = 0,
    double inset = 4,
    Key? key,
  }) {
    return M3ELinearProgress(
      key: key,
      value: value,
      size: size,
      shape: shape,
      activeColor: activeColor,
      trackColor: trackColor,
      phase: phase,
      inset: inset,
    );
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
    M3ELoadingIndicatorVariant variant = M3ELoadingIndicatorVariant.defaultStyle,
    Color? color,
    Color? containerColor,
    List<RoundedPolygon>? polygons,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? padding,
    String? semanticLabel,
    String? semanticValue,
    Key? key,
  }) {
    return M3ELoadingIndicator(
      key: key,
      variant: variant,
      color: color,
      containerColor: containerColor,
      polygons: polygons,
      constraints: constraints,
      padding: padding,
      semanticLabel: semanticLabel,
      semanticValue: semanticValue,
    );
  }

  /// Wraps a scrollable [child] with pull-to-refresh. See [M3ERefreshIndicator].
  ///
  /// When [contained] is true the morphing shape sits on a filled circular
  /// surface. Supply [polygons] to customise the shapes it morphs between.
  static Widget refreshIndicator({
    required Widget child,
    required M3ERefreshCallback onRefresh,
    bool contained = false,
    double displacement = 40,
    double edgeOffset = 0,
    Color? color,
    Color? backgroundColor,
    List<RoundedPolygon>? polygons,
    BoxConstraints? indicatorConstraints,
    M3ERefreshTriggerMode triggerMode = M3ERefreshTriggerMode.onEdge,
    ValueChanged<M3ERefreshStatus?>? onStatusChange,
    String? semanticsLabel,
    String? semanticsValue,
    double elevation = 2,
    Key? key,
  }) {
    if (contained) {
      return M3ERefreshIndicator.contained(
        key: key,
        onRefresh: onRefresh,
        displacement: displacement,
        edgeOffset: edgeOffset,
        color: color,
        backgroundColor: backgroundColor,
        polygons: polygons,
        indicatorConstraints: indicatorConstraints,
        triggerMode: triggerMode,
        onStatusChange: onStatusChange,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        elevation: elevation,
        child: child,
      );
    }
    return M3ERefreshIndicator(
      key: key,
      onRefresh: onRefresh,
      displacement: displacement,
      edgeOffset: edgeOffset,
      color: color,
      backgroundColor: backgroundColor,
      polygons: polygons,
      indicatorConstraints: indicatorConstraints,
      triggerMode: triggerMode,
      onStatusChange: onStatusChange,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      elevation: elevation,
      child: child,
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
