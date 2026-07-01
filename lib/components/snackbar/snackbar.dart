import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_snackbar_host.dart';

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
    Duration duration = const Duration(seconds: 4),
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
      constraints: const BoxConstraints(minHeight: 48, maxWidth: 600),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.inverseSurface,
        borderRadius: M3EShapes.radiusExtraSmall,
        boxShadow: M3EElevation.shadows(
          M3EElevation.level3,
          shadowColor: scheme.shadow,
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              message,
              style: theme.typeScale.bodyMedium
                  .copyWith(color: scheme.onInverseSurface),
            ),
          ),
          if (actionLabel != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: M3ETappable(
                onTap: onAction,
                semanticLabel: actionLabel,
                builder: (BuildContext context, M3EInteractionState state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Text(
                      actionLabel!,
                      style: theme.typeScale.labelLarge
                          .copyWith(color: scheme.inversePrimary),
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
