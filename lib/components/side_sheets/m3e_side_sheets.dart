import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../divider/m3e_divider.dart';
import 'styles/m3e_side_sheet_theme.dart';

export 'styles/m3e_side_sheet_theme.dart';

const String _closeSemanticLabel = 'Close';

/// A Material 3 Expressive side sheet.
///
/// Shows secondary content anchored to the trailing edge of the screen. Use
/// [M3ESideSheet.show] for a modal sheet that slides in from the side with a
/// header, body and optional actions.
class M3ESideSheet extends StatelessWidget {
  const M3ESideSheet({
    required this.title,
    required this.body,
    this.actions = const <Widget>[],
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;

  /// Presents a modal side sheet and completes with the popped result.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget body,
    List<Widget> actions = const <Widget>[],
  }) {
    final M3EThemeData theme = M3ETheme.of(context);
    final sheetTheme = theme.sideSheetTheme;
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: sheetTheme.scrimColor(theme.colorScheme),
      transitionDuration: M3EMotion.long1,
      pageBuilder: (BuildContext context, _, _) {
        return M3ETheme(
          data: theme,
          child: Align(
            alignment: Alignment.centerRight,
            child: M3ESideSheet(title: title, body: body, actions: actions),
          ),
        );
      },
      transitionBuilder: (BuildContext context, Animation<double> a, _, Widget c) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
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
    final sheetTheme = theme.sideSheetTheme;
    final scheme = theme.colorScheme;
    return Container(
      width: sheetTheme.width,
      height: double.infinity,
      decoration: BoxDecoration(
        color: sheetTheme.containerColor(scheme),
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(sheetTheme.cornerRadius),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeader(context, theme, sheetTheme),
            Expanded(child: body),
            if (actions.isNotEmpty) _buildActions(scheme, sheetTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    M3EThemeData theme,
    M3ESideSheetTheme sheetTheme,
  ) {
    final scheme = theme.colorScheme;
    return Padding(
      padding: sheetTheme.headerPadding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: sheetTheme.titleStyle(theme.typeScale, scheme),
            ),
          ),
          M3ETappable(
            onTap: () => Navigator.of(context).maybePop(),
            semanticLabel: _closeSemanticLabel,
            builder: (BuildContext context, M3EInteractionState state) {
              return Padding(
                padding: sheetTheme.closeButtonPadding,
                child: Icon(
                  M3EIcons.close,
                  color: scheme.onSurface,
                  size: sheetTheme.iconSize,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActions(M3EColorScheme scheme, M3ESideSheetTheme sheetTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        M3EDivider(color: sheetTheme.dividerColor(scheme)),
        Padding(
          padding: sheetTheme.actionsPadding,
          child: Row(children: actions),
        ),
      ],
    );
  }
}
