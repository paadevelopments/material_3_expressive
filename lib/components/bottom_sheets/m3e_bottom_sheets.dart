import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_bottom_sheet_theme.dart';

export 'styles/m3e_bottom_sheet_theme.dart';

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
    final M3EThemeData theme =
        M3EThemeScope.resolveOf(context) ?? M3ETheme.of(context);
    final sheetTheme = theme.bottomSheetTheme;
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: sheetTheme.scrimColor(theme.colorScheme),
      transitionDuration: M3EMotion.long1,
      pageBuilder: (BuildContext context, _, _) {
        return M3EComponentTheme(builder: (context) => Align(
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
    return M3EComponentTheme(
      builder: _buildSheet,
    );
  }

  Widget _buildSheet(BuildContext context) {
    final theme = M3ETheme.of(context);
    final sheetTheme = theme.bottomSheetTheme;
    final scheme = theme.colorScheme;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: sheetTheme.maxWidth),
      child: GestureDetector(
        onVerticalDragEnd: (DragEndDetails details) =>
            _handleDragEnd(context, details, sheetTheme),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: sheetTheme.containerColor(scheme),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(sheetTheme.topCornerRadius),
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
                if (showDragHandle) _buildHandle(scheme, sheetTheme),
                Flexible(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHandle(M3EColorScheme scheme, M3EBottomSheetTheme sheetTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: sheetTheme.handleVerticalPadding,
      ),
      child: Container(
        width: sheetTheme.handleWidth,
        height: sheetTheme.handleHeight,
        decoration: BoxDecoration(
          color: sheetTheme.handleColor(scheme),
          borderRadius: M3EShapes.resolve(sheetTheme.handleCornerRadius),
        ),
      ),
    );
  }

  void _handleDragEnd(
    BuildContext context,
    DragEndDetails details,
    M3EBottomSheetTheme sheetTheme,
  ) {
    final double velocity = details.primaryVelocity ?? 0;
    if (velocity > sheetTheme.dismissVelocity) {
      Navigator.of(context).maybePop();
    }
  }
}
