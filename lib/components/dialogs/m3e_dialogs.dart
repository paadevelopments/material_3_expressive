import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../buttons/enums/m3e_button_enums.dart';
import '../buttons/m3e_buttons.dart';
import '../checkbox/m3e_checkbox.dart';
import '../divider/m3e_divider.dart';
import '../radio_button/m3e_radio_button.dart';
import 'styles/m3e_dialog_theme.dart';

export 'styles/m3e_dialog_theme.dart';

const String _closeSemanticLabel = 'Close';
const String _cancelLabel = 'Cancel';
const String _confirmLabel = 'OK';

/// A Material 3 Expressive dialog surface plus helpers to present dialogs.
///
/// Use [M3EDialog.show] for a standard centred dialog and
/// [M3EDialog.showFullScreen] for a full-screen dialog.
class M3EDialog extends StatelessWidget {
  const M3EDialog({
    required this.title,
    this.icon,
    this.content,
    this.contentPadding,
    this.actions = const <Widget>[],
    this.topDivider = false,
    this.bottomDivider = false,
    super.key,
  });

  final String title;
  final Widget? icon;
  final Widget? content;
  final EdgeInsets? contentPadding;
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
          M3EComponentTheme(
            builder: (context) => Center(
              child: Padding(padding: dialogTheme.screenMargin, child: dialog),
            ),
          ),
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
        return M3EComponentTheme(
          builder: (context) =>
              _FullScreenDialog(title: title, body: body, action: action),
        );
      },
      transitionBuilder: _slide,
    );
  }

  /// Presents a centred [M3EDialog] with selectable [options].
  ///
  /// Uses [M3ERadio] for single selection and [M3ECheckbox] when
  /// [multiSelect] is true. Both section dividers are enabled. Confirm stays
  /// disabled until at least one option is selected; on confirm, returns the
  /// selected values (or `null` if dismissed).
  static Future<List<String>?> showSelectionScreen(
    BuildContext context, {
    required String title,
    required List<String> options,
    bool multiSelect = false,
    List<String> initialSelection = const <String>[],
    String cancelLabel = _cancelLabel,
    String confirmLabel = _confirmLabel,
    Widget? icon,
    bool barrierDismissible = true,
  }) {
    assert(options.isNotEmpty, 'options must not be empty.');
    return show<List<String>>(
      context,
      barrierDismissible: barrierDismissible,
      dialog: _M3ESelectionDialog(
        title: title,
        options: options,
        multiSelect: multiSelect,
        initialSelection: initialSelection,
        cancelLabel: cancelLabel,
        confirmLabel: confirmLabel,
        icon: icon,
      ),
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
        scale: Tween<double>(
          begin: dialogTheme.entranceScale,
          end: 1,
        ).animate(curved),
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
      position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
          .animate(
            CurvedAnimation(
              parent: animation,
              curve: M3EMotion.emphasizedDecelerate,
            ),
          ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildDialog);
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
        crossAxisAlignment: icon == null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: _buildChildren(theme, dialogTheme),
      ),
    );
  }

  List<Widget> _buildChildren(M3EThemeData theme, M3EDialogTheme dialogTheme) {
    final M3EColorScheme scheme = theme.colorScheme;
    final EdgeInsets padding = dialogTheme.padding;
    final hasContent = content != null;
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
              style: theme.typeScale.headlineSmall.copyWith(
                color: scheme.onSurface,
              ),
            ),
          ],
        ),
      ),
      if (topDivider && hasBelowHeader)
        M3EDivider(color: scheme.outlineVariant),
      if (hasContent)
        Padding(
          padding:
              contentPadding ??
              (topDivider && bottomDivider
                  ? padding
                  : EdgeInsets.only(left: padding.left, right: padding.right)),
          child: DefaultTextStyle(
            style: theme.typeScale.bodyMedium.copyWith(
              color: scheme.onSurfaceVariant,
            ),
            child: content!,
          ),
        ),
      if (bottomDivider && hasActions) M3EDivider(color: scheme.outlineVariant),
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

/// Selection list hosted inside [M3EDialog.showSelectionScreen].
class _M3ESelectionDialog extends StatefulWidget {
  const _M3ESelectionDialog({
    required this.title,
    required this.options,
    required this.multiSelect,
    required this.initialSelection,
    required this.cancelLabel,
    required this.confirmLabel,
    this.icon,
  });

  final String title;
  final List<String> options;
  final bool multiSelect;
  final List<String> initialSelection;
  final String cancelLabel;
  final String confirmLabel;
  final Widget? icon;

  @override
  State<_M3ESelectionDialog> createState() => _M3ESelectionDialogState();
}

class _M3ESelectionDialogState extends State<_M3ESelectionDialog> {
  late final Set<String> _selected;

  @override
  void initState() {
    super.initState();
    final Set<String> allowed = widget.options.toSet();
    _selected = widget.initialSelection
        .where(allowed.contains)
        .toSet();
    if (!widget.multiSelect && _selected.length > 1) {
      final String first = _selected.first;
      _selected
        ..clear()
        ..add(first);
    }
  }

  bool get _hasSelection => _selected.isNotEmpty;

  void _selectSingle(String value) {
    setState(() {
      _selected
        ..clear()
        ..add(value);
    });
  }

  void _toggleMulti(String value) {
    setState(() {
      if (_selected.contains(value)) {
        _selected.remove(value);
      } else {
        _selected.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EDialogTheme dialogTheme = theme.dialogTheme;
    final double maxListHeight = MediaQuery.sizeOf(context).height * 0.45;

    return M3EDialog(
      title: widget.title,
      icon: widget.icon,
      topDivider: true,
      bottomDivider: true,
      contentPadding: EdgeInsets.zero,
      content: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxListHeight),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: dialogTheme.padding.top / 2,
            bottom: dialogTheme.padding.bottom / 2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              for (final String option in widget.options)
                _buildSelectionItem(
                  theme: theme,
                  dialogTheme: dialogTheme,
                  option: option,
                ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        M3EButton(
          style: M3EButtonStyle.text,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(widget.cancelLabel),
        ),
        M3EButton(
          onPressed: _hasSelection
              ? () => Navigator.of(context).pop(
                    List<String>.unmodifiable(_selected.toList()),
                  )
              : null,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }

  Widget _buildSelectionItem({
    required M3EThemeData theme,
    required M3EDialogTheme dialogTheme,
    required String option,
  }) {
    final EdgeInsets padding = dialogTheme.padding;
    final ShapeBorder shape = const RoundedRectangleBorder();

    return M3ETappable(
      onTap: () {
        if (widget.multiSelect) {
          _toggleMulti(option);
        } else {
          _selectSingle(option);
        }
      },
      materialInk: true,
      semanticLabel: option,
      builder: (BuildContext context, M3EInteractionState state) {
        return SizedBox(
          height: dialogTheme.selectionItemHeight,
          width: double.infinity,
          child: M3EStateLayerOverlay(
            state: state,
            color: theme.colorScheme.onSurface,
            shape: shape,
            child: Padding(
              padding: EdgeInsets.only(
                left: padding.left,
                right: padding.right,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ExcludeSemantics(
                  child: widget.multiSelect
                      ? _buildCheckboxVisual(theme, option)
                      : IgnorePointer(
                          child: M3ERadio<String>(
                            value: option,
                            groupValue:
                                _selected.isEmpty ? null : _selected.first,
                            label: Text(option),
                            onChanged: (_) {},
                          ),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckboxVisual(M3EThemeData theme, String option) {
    final bool checked = _selected.contains(option);
    return Row(
      children: <Widget>[
        IgnorePointer(
          child: M3ECheckbox(
            value: checked,
            onChanged: (_) {},
          ),
        ),
        SizedBox(width: theme.radioTheme.labelGap),
        Expanded(
          child: Text(
            option,
            style: theme.typeScale.bodyLarge.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
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
    return M3EComponentTheme(builder: _buildFullScreen);
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
              style: theme.typeScale.titleLarge.copyWith(
                color: scheme.onSurface,
              ),
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
