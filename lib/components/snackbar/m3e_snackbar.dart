import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_snackbar_host.dart';

export 'components/m3e_snackbar_host.dart';
export 'styles/m3e_snackbar_theme.dart';

/// A Material 3 Expressive snackbar.
///
/// A brief, low-emphasis message anchored to the bottom of the screen with an
/// optional single action. Call [M3ESnackbar.show] to present one over the
/// nearest [Overlay].
class M3ESnackbar extends StatelessWidget {
  const M3ESnackbar({
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Presents a snackbar over the overlay found from [context].
  static void show(
    BuildContext context, {
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    Duration? duration,
  }) {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    final M3EThemeData theme = M3ETheme.of(context);
    final Duration resolvedDuration =
        duration ?? theme.snackBarTheme.defaultDuration;
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext context) {
        return M3EComponentTheme(
          child: M3ESnackbarHost(
            duration: resolvedDuration,
            entry: entry,
            child: M3ESnackbar(
              message: message,
              actionLabel: actionLabel,
              onAction: onAction,
            ),
          ),
        );
      },
    );
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      child: _buildBar(context),
    );
  }

  Widget _buildBar(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final snackTheme = theme.snackBarTheme;
    return Container(
      constraints: BoxConstraints(
        minHeight: snackTheme.minHeight,
        maxWidth: snackTheme.maxWidth,
      ),
      padding: snackTheme.contentPadding,
      decoration: BoxDecoration(
        color: snackTheme.containerColor(scheme),
        borderRadius: snackTheme.borderRadius,
        boxShadow: M3EElevation.shadows(
          snackTheme.elevation,
          shadowColor: scheme.shadow,
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              message,
              style: snackTheme.messageStyle(theme.typeScale, scheme),
            ),
          ),
          if (actionLabel != null)
            Padding(
              padding: EdgeInsets.only(left: snackTheme.actionGap),
              child: M3ETappable(
                onTap: onAction,
                semanticLabel: actionLabel,
                builder: (BuildContext context, M3EInteractionState state) {
                  return Padding(
                    padding: snackTheme.actionPadding,
                    child: Text(
                      actionLabel!,
                      style: snackTheme.actionStyle(
                        theme.typeScale,
                        scheme,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
