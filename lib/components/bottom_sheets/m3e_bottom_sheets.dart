import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_bottom_sheet_tokens.dart';

export 'styles/m3e_bottom_sheet_tokens.dart';

/// A Material 3 Expressive bottom sheet.
///
/// Shows secondary content anchored to the bottom of the screen. Use
/// [M3EBottomSheet.show] for a modal sheet with a scrim; a drag handle lets
/// people flick it away.
class M3EBottomSheet extends StatelessWidget {
  const M3EBottomSheet({
    required this.child,
    this.showDragHandle = true,
    super.key,
  });

  final Widget child;
  final bool showDragHandle;

  /// Presents a modal bottom sheet and completes with the popped result.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
    bool showDragHandle = true,
  }) {
    final M3EThemeData theme = M3ETheme.of(context);
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: M3EBottomSheetTokens.scrimColor(theme.colorScheme),
      transitionDuration: M3EMotion.long1,
      pageBuilder: (BuildContext context, _, _) {
        return M3ETheme(
          data: theme,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: M3EBottomSheet(
              showDragHandle: showDragHandle,
              child: Builder(builder: builder),
            ),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> a, _, Widget c) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(
            CurvedAnimation(parent: a, curve: M3EMotion.emphasizedDecelerate),
          ),
          child: c,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: M3EBottomSheetTokens.maxWidth),
      child: GestureDetector(
        onVerticalDragEnd: (DragEndDetails details) =>
            _handleDragEnd(context, details),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: M3EBottomSheetTokens.containerColor(scheme),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(M3EBottomSheetTokens.topCornerRadius),
            ),
            boxShadow: M3EElevation.shadows(
              M3EElevation.level1,
              shadowColor: scheme.shadow,
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (showDragHandle) _buildHandle(scheme),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(M3EColorScheme scheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: M3EBottomSheetTokens.handleVerticalPadding,
      ),
      child: Container(
        width: M3EBottomSheetTokens.handleWidth,
        height: M3EBottomSheetTokens.handleHeight,
        decoration: BoxDecoration(
          color: M3EBottomSheetTokens.handleColor(scheme),
          borderRadius: M3EShapes.resolve(M3EBottomSheetTokens.handleCornerRadius),
        ),
      ),
    );
  }

  void _handleDragEnd(BuildContext context, DragEndDetails details) {
    final double velocity = details.primaryVelocity ?? 0;
    if (velocity > M3EBottomSheetTokens.dismissVelocity) {
      Navigator.of(context).maybePop();
    }
  }
}
