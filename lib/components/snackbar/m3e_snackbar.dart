import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../buttons/m3e_buttons.dart';
import '../icon_buttons/m3e_icon_buttons.dart';
import 'components/m3e_snackbar_host.dart';
import 'controllers/m3e_snackbar_controller.dart';
import 'styles/m3e_snackbar_theme.dart';

export 'components/m3e_snackbar_host.dart';
export 'controllers/m3e_snackbar_controller.dart';
export 'styles/m3e_snackbar_theme.dart';

/// A Material 3 Expressive snackbar.
///
/// Brief, low-emphasis feedback at the bottom of the screen with an optional
/// action and close affordance. Call [M3ESnackbar.show] to present one over the
/// nearest [Overlay] (one at a time via [defaultController]).
class M3ESnackbar extends StatelessWidget {
  /// M3ESnackbar.
  const M3ESnackbar({
    required this.message,
    this.actionLabel,
    this.onAction,
    this.showCloseButton = false,
    this.onClose,
    super.key,
  });

  /// Shared one-at-a-time controller used when [show] omits `controller`.
  static final M3ESnackbarController defaultController =
      M3ESnackbarController();

  /// Supporting text / message.
  final String message;

  /// Optional single action label (text button).
  final String? actionLabel;

  /// Called when the action is pressed (then the host dismisses if shown).
  final VoidCallback? onAction;

  /// Whether to show the optional close icon.
  final bool showCloseButton;

  /// Called when close is pressed (then the host dismisses if shown).
  final VoidCallback? onClose;

  /// Presents a snackbar over the overlay found from [context].
  ///
  /// Snackbars with an action or close button do not auto-dismiss unless
  /// [duration] is explicitly passed. Plain snackbars use
  /// [M3ESnackbarTheme.defaultDuration] (4s) by default.
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseButton = false,
    VoidCallback? onClose,
    Duration? duration,
    M3ESnackbarController? controller,
  }) {
    final M3EThemeData theme = M3ETheme.of(context);
    final bool actionable =
        (actionLabel != null && actionLabel.isNotEmpty) || showCloseButton;
    final Duration? resolvedDuration =
        duration ?? (actionable ? null : theme.snackBarTheme.defaultDuration);
    final M3ESnackbarController resolved =
        controller ?? M3ESnackbar.defaultController;

    resolved.present(
      context,
      duration: resolvedDuration,
      child: M3EComponentTheme(
        builder: (BuildContext context) {
          return M3ESnackbar(
            message: message,
            actionLabel: actionLabel,
            onAction: onAction,
            showCloseButton: showCloseButton,
            onClose: onClose,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildBar);
  }

  Widget _buildBar(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final snackTheme = theme.snackBarTheme;
    final TextDirection direction = Directionality.of(context);
    final bool hasAction =
        actionLabel != null && actionLabel!.trim().isNotEmpty;
    final bool hasTrailing = hasAction || showCloseButton;
    final EdgeInsets padding = EdgeInsetsDirectional.only(
      start: snackTheme.startPadding,
      end: hasTrailing
          ? snackTheme.endPaddingWithTrailing
          : snackTheme.endPadding,
      top: snackTheme.verticalPadding,
      bottom: snackTheme.verticalPadding,
    ).resolve(direction);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double maxBarWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth.clamp(0, snackTheme.maxWidth)
            : snackTheme.maxWidth;
        final double trailingControlSize = theme.buttonTheme
            .measurements(M3EButtonSize.sm)
            .height;
        final double textMaxWidth = _textMaxWidth(
          snackTheme: snackTheme,
          maxBarWidth: maxBarWidth,
          padding: padding,
          hasAction: hasAction,
          actionBelow: false,
          closeVisualSize: showCloseButton ? trailingControlSize : 0,
        );
        final TextStyle messageStyle = snackTheme.messageStyle(
          theme.typeScale,
          scheme,
        );
        final bool multiLine =
            _messageLineCount(
              message: message,
              style: messageStyle,
              maxWidth: textMaxWidth,
              textDirection: direction,
            ) >
            1;
        final bool actionBelow =
            hasAction &&
            (multiLine ||
                actionLabel!.length > snackTheme.longActionLabelThreshold);
        final double minHeight = multiLine || actionBelow
            ? snackTheme.twoLineMinHeight
            : snackTheme.singleLineMinHeight;

        final Widget messageText = Text(
          message,
          style: messageStyle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        );

        final Widget? action = hasAction
            ? _buildAction(context, theme, snackTheme, scheme)
            : null;
        final Widget? close = showCloseButton
            ? _buildClose(context, theme, snackTheme, scheme)
            : null;

        final Widget body = actionBelow
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(child: messageText),
                      if (close != null) close,
                    ],
                  ),
                  SizedBox(height: snackTheme.actionGap),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: action!,
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: messageText),
                  if (action != null) ...<Widget>[
                    SizedBox(width: snackTheme.actionGap),
                    action,
                  ],
                  if (close != null) close,
                ],
              );

        return Semantics(
          liveRegion: true,
          container: true,
          child: Container(
            constraints: BoxConstraints(
              minHeight: minHeight,
              maxWidth: snackTheme.maxWidth,
            ),
            padding: padding,
            decoration: BoxDecoration(
              color: snackTheme.containerColor(scheme),
              borderRadius: snackTheme.borderRadius,
              boxShadow: M3EElevation.shadows(
                snackTheme.elevation,
                shadowColor: scheme.shadow,
              ),
            ),
            child: body,
          ),
        );
      },
    );
  }

  double _textMaxWidth({
    required M3ESnackbarTheme snackTheme,
    required double maxBarWidth,
    required EdgeInsets padding,
    required bool hasAction,
    required bool actionBelow,
    required double closeVisualSize,
  }) {
    var width = maxBarWidth - padding.left - padding.right;
    if (closeVisualSize > 0) {
      width -= closeVisualSize;
    }
    if (hasAction && !actionBelow) {
      // Reserve approximate action width; layout still expands as needed.
      width -= snackTheme.actionGap + 48;
    }
    return width.clamp(0, maxBarWidth);
  }

  int _messageLineCount({
    required String message,
    required TextStyle style,
    required double maxWidth,
    required TextDirection textDirection,
  }) {
    final TextPainter painter = TextPainter(
      text: TextSpan(text: message, style: style),
      textDirection: textDirection,
      maxLines: 2,
    )..layout(maxWidth: maxWidth);
    return painter.computeLineMetrics().length.clamp(1, 2);
  }

  Widget _buildAction(
    BuildContext context,
    M3EThemeData theme,
    M3ESnackbarTheme snackTheme,
    M3EColorScheme scheme,
  ) {
    return M3EButton.text(
      semanticLabel: actionLabel,
      decoration: M3EButtonDecoration(
        foregroundColor: WidgetStateProperty.all(scheme.inversePrimary),
        textStyle: snackTheme.actionStyle(theme.typeScale, scheme),
        padding: snackTheme.actionPadding,
      ),
      onPressed: () {
        onAction?.call();
        M3ESnackbarDismissScope.maybeOf(context)?.call();
      },
      child: Text(actionLabel!),
    );
  }

  Widget _buildClose(
    BuildContext context,
    M3EThemeData theme,
    M3ESnackbarTheme snackTheme,
    M3EColorScheme scheme,
  ) {
    // Match text-button (sm) height so the close control does not grow the bar.
    final double visual = theme.buttonTheme
        .measurements(M3EButtonSize.sm)
        .height;
    return M3EIconButton(
      variant: M3EIconButtonVariant.standard,
      visualSize: Size(visual, visual),
      inflateHitTarget: false,
      semanticLabel: 'Dismiss',
      decoration: M3EIconButtonDecoration(
        foregroundColor: WidgetStateProperty.all(
          snackTheme.closeIconColor(scheme),
        ),
        backgroundColor: const WidgetStatePropertyAll<Color?>(null),
      ),
      icon: Icon(M3EIcons.close, size: snackTheme.closeIconSize),
      onPressed: () {
        onClose?.call();
        M3ESnackbarDismissScope.maybeOf(context)?.call();
      },
    );
  }
}
