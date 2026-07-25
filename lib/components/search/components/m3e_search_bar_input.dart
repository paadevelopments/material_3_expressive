part of '../m3e_search_bar.dart';

double _resolveActionIconSize({
  required M3EIconButtonTheme iconButtonTheme,
  required Iterable<Widget>? trailing,
  required Widget? leading,
}) {
  final Widget? referenceAction = _resolveReferenceAction(
    trailing: trailing,
    leading: leading,
  );
  if (referenceAction is M3EIconButton) {
    final M3EIconButton button = referenceAction;
    return iconButtonTheme.iconSize(button.size);
  }
  if (referenceAction is Icon) {
    final Icon icon = referenceAction;
    if (icon.size != null) {
      return icon.size!;
    }
  }
  return iconButtonTheme.iconSize(M3EIconButtonSize.sm);
}

Widget? _resolveReferenceAction({
  required Iterable<Widget>? trailing,
  required Widget? leading,
}) {
  if (trailing != null && trailing.isNotEmpty) {
    return trailing.last;
  }
  return leading;
}

double _resolveActionSlotWidth({
  required M3EIconButtonTheme iconButtonTheme,
  required Iterable<Widget>? trailing,
  required Widget? leading,
}) {
  final Widget? referenceAction = _resolveReferenceAction(
    trailing: trailing,
    leading: leading,
  );
  if (referenceAction is M3EIconButton) {
    final M3EIconButton button = referenceAction;
    return iconButtonTheme.target(button.size, button.width).width;
  }
  if (referenceAction is Icon) {
    final Icon icon = referenceAction;
    return icon.size ??
        iconButtonTheme
            .target(M3EIconButtonSize.sm, M3EIconButtonWidth.defaultWidth)
            .width;
  }
  return iconButtonTheme
      .target(M3EIconButtonSize.sm, M3EIconButtonWidth.defaultWidth)
      .width;
}

Widget _wrapActionSlot({required double width, required Widget child}) {
  return SizedBox(
    width: width,
    child: Center(child: child),
  );
}

/// m3eDefaultSearchContextMenuBuilder.

Widget m3eDefaultSearchContextMenuBuilder(
  BuildContext context,
  EditableTextState editableTextState,
) {
  return AdaptiveTextSelectionToolbar.editableText(
    editableTextState: editableTextState,
  );
}

/// Shared editable search field used by [M3ESearchBar] and the search view header.
class M3ESearchBarInput extends StatefulWidget {
  /// M3ESearchBarInput.
  const M3ESearchBarInput({
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.enabled,
    required this.readOnly,
    required this.autoFocus,
    required this.textStyle,
    required this.hintStyle,
    required this.cursorColor,
    required this.selectionColor,
    this.onTap,
    this.onTapOutside,
    this.onChanged,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20),
    this.contextMenuBuilder = m3eDefaultSearchContextMenuBuilder,
    this.smartDashesType,
    this.smartQuotesType,
    this.contentPadding = EdgeInsets.zero,
    super.key,
  });

  /// controller.

  final TextEditingController controller;

  /// focusNode.
  final FocusNode focusNode;

  /// hintText.
  final String? hintText;

  /// enabled.
  final bool enabled;

  /// readOnly.
  final bool readOnly;

  /// autoFocus.
  final bool autoFocus;

  /// textStyle.
  final TextStyle textStyle;

  /// hintStyle.
  final TextStyle hintStyle;

  /// cursorColor.
  final Color cursorColor;

  /// selectionColor.
  final Color selectionColor;

  /// onTap.
  final GestureTapCallback? onTap;

  /// onTapOutside.
  final TapRegionCallback? onTapOutside;

  /// onChanged.
  final ValueChanged<String>? onChanged;

  /// onSubmitted.
  final ValueChanged<String>? onSubmitted;

  /// textCapitalization.
  final TextCapitalization textCapitalization;

  /// textInputAction.
  final TextInputAction? textInputAction;

  /// keyboardType.
  final TextInputType? keyboardType;

  /// scrollPadding.
  final EdgeInsets scrollPadding;

  /// contextMenuBuilder.
  final EditableTextContextMenuBuilder contextMenuBuilder;

  /// smartDashesType.
  final SmartDashesType? smartDashesType;

  /// smartQuotesType.
  final SmartQuotesType? smartQuotesType;

  /// contentPadding.
  final EdgeInsetsGeometry contentPadding;

  @override
  State<M3ESearchBarInput> createState() => _M3ESearchBarInputState();
}

class _M3ESearchBarInputState extends State<M3ESearchBarInput> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void didUpdateWidget(M3ESearchBarInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleTextChange);
      widget.controller.addListener(_handleTextChange);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.hintText,
      textField: true,
      child: Padding(
        padding: widget.contentPadding,
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: <Widget>[
            if (widget.controller.text.isEmpty && widget.hintText != null)
              IgnorePointer(
                child: Text(
                  widget.hintText!,
                  style: widget.hintStyle,
                  maxLines: 1,
                ),
              ),
            Listener(
              behavior: HitTestBehavior.translucent,
              onPointerDown: (_) => widget.onTap?.call(),
              child: EditableText(
                controller: widget.controller,
                focusNode: widget.focusNode,
                readOnly: widget.readOnly || !widget.enabled,
                autofocus: widget.autoFocus,
                onTapOutside:
                    widget.onTapOutside ??
                    M3EFocus.tapOutsideHandler(widget.focusNode),
                onChanged: widget.onChanged,
                onSubmitted: widget.onSubmitted,
                style: widget.textStyle,
                cursorColor: widget.cursorColor,
                backgroundCursorColor: widget.cursorColor.withValues(
                  alpha: 0.4,
                ),
                selectionColor: widget.selectionColor,
                textCapitalization: widget.textCapitalization,
                textInputAction: widget.textInputAction,
                keyboardType: widget.keyboardType,
                scrollPadding: widget.scrollPadding,
                contextMenuBuilder: widget.contextMenuBuilder,
                smartDashesType: widget.smartDashesType,
                smartQuotesType: widget.smartQuotesType,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A Material 3 Expressive search bar.
