import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_snackbar_host.dart';
import 'styles/m3e_snackbar_tokens.dart';

export 'components/m3e_snackbar_host.dart';
export 'styles/m3e_snackbar_tokens.dart';

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
    Duration duration = M3ESnackbarTokens.defaultDuration,
  }) {
    final OverlayState overlay = Overlay.of(context, rootOverlay: true);
    final M3EThemeData theme = M3ETheme.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext context) {
        return M3ETheme(
          data: theme,
          child: M3ESnackbarHost(
            duration: duration,
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
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      constraints: const BoxConstraints(
        minHeight: M3ESnackbarTokens.minHeight,
        maxWidth: M3ESnackbarTokens.maxWidth,
      ),
      padding: M3ESnackbarTokens.contentPadding,
      decoration: BoxDecoration(
        color: M3ESnackbarTokens.containerColor(scheme),
        borderRadius: M3ESnackbarTokens.borderRadius,
        boxShadow: M3EElevation.shadows(
          M3ESnackbarTokens.elevation,
          shadowColor: scheme.shadow,
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              message,
              style: M3ESnackbarTokens.messageStyle(theme.typeScale, scheme),
            ),
          ),
          if (actionLabel != null)
            Padding(
              padding: const EdgeInsets.only(left: M3ESnackbarTokens.actionGap),
              child: M3ETappable(
                onTap: onAction,
                semanticLabel: actionLabel,
                builder: (BuildContext context, M3EInteractionState state) {
                  return Padding(
                    padding: M3ESnackbarTokens.actionPadding,
                    child: Text(
                      actionLabel!,
                      style: M3ESnackbarTokens.actionStyle(
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
