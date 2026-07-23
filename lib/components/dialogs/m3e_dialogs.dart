import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../divider/m3e_divider.dart';
import 'styles/m3e_dialog_theme.dart';

export 'styles/m3e_dialog_theme.dart';

const String _closeSemanticLabel = 'Close';

/// A Material 3 Expressive dialog surface plus helpers to present dialogs.
///
/// Use [M3EDialog.show] for a standard centred dialog and
/// [M3EDialog.showFullScreen] for a full-screen dialog.
class M3EDialog extends StatelessWidget {
  const M3EDialog({
    required this.title,
    this.icon,
    this.content,
    this.actions = const <Widget>[],
    this.topDivider = false,
    this.bottomDivider = false,
    super.key,
  });

  final String title;
  final Widget? icon;
  final Widget? content;
  final List<Widget> actions;

  /// Full-bleed divider between the header and the section below it.
  final bool topDivider;

  /// Full-bleed divider above the actions row.
  final bool bottomDivider;

  /// Presents a standard dialog and completes with the popped result.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget dialog,
    bool barrierDismissible = true,
  }) {
    final M3EThemeData theme =
        M3EThemeScope.resolveOf(context) ?? M3ETheme.of(context);
    final dialogTheme = theme.dialogTheme;
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: dialogTheme.scrimColor(theme.colorScheme),
      transitionDuration: M3EMotion.medium2,
      pageBuilder: (BuildContext context, _, _) {
        return M3EScrimSystemUi.wrap(
          M3EComponentTheme(builder: (context) => Center(
            child: Padding(
              padding: dialogTheme.screenMargin,
              child: dialog,
            ),
          )),
        );
      },
      transitionBuilder: (context, animation, secondary, child) =>
          _transition(context, animation, secondary, child, dialogTheme),
    );
  }

  /// Presents a full-screen dialog with a header of [title] and [action].
  static Future<T?> showFullScreen<T>(
    BuildContext context, {
    required String title,
    required Widget body,
    Widget? action,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierLabel: 'Full screen dialog',
      transitionDuration: M3EMotion.long2,
      pageBuilder: (BuildContext context, _, _) {
        return M3EComponentTheme(builder: (context) => _FullScreenDialog(title: title, body: body, action: action),
        );
      },
      transitionBuilder: _slide,
    );
  }

  static Widget _transition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondary,
    Widget child,
    M3EDialogTheme dialogTheme,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: M3EMotion.emphasizedDecelerate,
    );
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween<double>(begin: dialogTheme.entranceScale, end: 1)
            .animate(curved),
        child: child,
      ),
    );
  }

  static Widget _slide(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondary,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: M3EMotion.emphasizedDecelerate),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: _buildDialog,
    );
  }

  Widget _buildDialog(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EDialogTheme dialogTheme = theme.dialogTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    return Container(
      constraints: BoxConstraints(
        minWidth: dialogTheme.minWidth,
        maxWidth: dialogTheme.maxWidth,
      ),
      decoration: BoxDecoration(
        color: dialogTheme.containerColor(scheme),
        borderRadius: dialogTheme.borderRadius,
        boxShadow: M3EElevation.shadows(
          M3EElevation.level3,
          shadowColor: scheme.shadow,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment:
            icon == null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: _buildChildren(theme, dialogTheme),
      ),
    );
  }

  List<Widget> _buildChildren(M3EThemeData theme, M3EDialogTheme dialogTheme) {
    final M3EColorScheme scheme = theme.colorScheme;
    final EdgeInsets padding = dialogTheme.padding;
    final bool hasContent = content != null;
    final bool hasActions = actions.isNotEmpty;
    final bool hasBelowHeader = hasContent || hasActions;

    return <Widget>[
      Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: icon == null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              IconTheme.merge(
                data: IconThemeData(
                  color: scheme.secondary,
                  size: dialogTheme.iconSize,
                ),
                child: icon!,
              ),
              SizedBox(height: dialogTheme.gapAfterIcon),
            ],
            Text(
              title,
              textAlign: icon == null ? TextAlign.start : TextAlign.center,
              style: theme.typeScale.headlineSmall
                  .copyWith(color: scheme.onSurface),
            ),
          ],
        ),
      ),
      if (topDivider && hasBelowHeader)
        M3EDivider(color: scheme.outlineVariant),
      if (hasContent)
        Padding(
          padding: padding,
          child: DefaultTextStyle(
            style: theme.typeScale.bodyMedium
                .copyWith(color: scheme.onSurfaceVariant),
            child: content!,
          ),
        ),
      if (bottomDivider && hasActions)
        M3EDivider(color: scheme.outlineVariant),
      if (hasActions)
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              for (int i = 0; i < actions.length; i++) ...<Widget>[
                if (i > 0) SizedBox(width: dialogTheme.actionGap),
                actions[i],
              ],
            ],
          ),
        ),
    ];
  }
}

class _FullScreenDialog extends StatelessWidget {
  const _FullScreenDialog({
    required this.title,
    required this.body,
    this.action,
  });

  final String title;
  final Widget body;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: _buildFullScreen,
    );
  }

  Widget _buildFullScreen(BuildContext context) {
    final theme = M3ETheme.of(context);
    final dialogTheme = theme.dialogTheme;
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: dialogTheme.fullScreenBackground(scheme),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _buildHeader(context, theme, dialogTheme),
            M3EDivider(color: scheme.outlineVariant),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    M3EThemeData theme,
    M3EDialogTheme dialogTheme,
  ) {
    final scheme = theme.colorScheme;
    return SizedBox(
      height: dialogTheme.fullScreenHeaderHeight,
      child: Row(
        children: <Widget>[
          SizedBox(width: dialogTheme.headerEdgeGap),
          M3ETappable(
            onTap: () => Navigator.of(context).pop(),
            semanticLabel: _closeSemanticLabel,
            builder: (BuildContext context, M3EInteractionState state) {
              return Padding(
                padding: dialogTheme.closeButtonPadding,
                child: IconTheme.merge(
                  data: IconThemeData(size: dialogTheme.iconSize),
                  child: const Icon(M3EIcons.close),
                ),
              );
            },
          ),
          SizedBox(width: dialogTheme.headerEdgeGap),
          Expanded(
            child: Text(
              title,
              style:
                  theme.typeScale.titleLarge.copyWith(color: scheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (action != null) ...<Widget>[
            action!,
            SizedBox(width: dialogTheme.headerActionGap),
          ],
        ],
      ),
    );
  }
}
