import 'package:flutter/material.dart'
    show
        AdaptiveTextSelectionToolbar,
        InkWell,
        Material,
        MaterialType,
        WidgetStateProperty,
        WidgetStatePropertyAll,
        WidgetStatesController;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'res/m3e_search_constants.dart';

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
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? hintText;
  final bool enabled;
  final bool readOnly;
  final bool autoFocus;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final Color cursorColor;
  final Color selectionColor;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final EdgeInsets scrollPadding;
  final EditableTextContextMenuBuilder contextMenuBuilder;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;

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
          EditableText(
            controller: widget.controller,
            focusNode: widget.focusNode,
            readOnly: widget.readOnly || !widget.enabled,
            autofocus: widget.autoFocus,
            onTapOutside: widget.onTapOutside,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: widget.textStyle,
            cursorColor: widget.cursorColor,
            backgroundCursorColor:
                widget.cursorColor.withValues(alpha: 0.4),
            selectionColor: widget.selectionColor,
            textCapitalization: widget.textCapitalization,
            textInputAction: widget.textInputAction,
            keyboardType: widget.keyboardType,
            scrollPadding: widget.scrollPadding,
            contextMenuBuilder: widget.contextMenuBuilder,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}

/// A Material 3 Expressive search bar.
class M3ESearchBar extends StatefulWidget {
  const M3ESearchBar({
    this.controller,
    this.focusNode,
    this.hintText,
    this.leading,
    this.trailing,
    this.onTap,
    this.onTapOutside,
    this.onChanged,
    this.onSubmitted,
    this.constraints,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.textCapitalization,
    this.enabled = true,
    this.autoFocus = false,
    this.textInputAction,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20),
    this.contextMenuBuilder = m3eDefaultSearchContextMenuBuilder,
    this.readOnly = false,
    this.smartDashesType,
    this.smartQuotesType,
    super.key,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? hintText;
  final Widget? leading;
  final Iterable<Widget>? trailing;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final BoxConstraints? constraints;
  final WidgetStateProperty<double?>? elevation;
  final WidgetStateProperty<Color?>? backgroundColor;
  final WidgetStateProperty<Color?>? shadowColor;
  final WidgetStateProperty<Color?>? surfaceTintColor;
  final WidgetStateProperty<Color?>? overlayColor;
  final WidgetStateProperty<BorderSide?>? side;
  final WidgetStateProperty<OutlinedBorder?>? shape;
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;
  final WidgetStateProperty<TextStyle?>? textStyle;
  final WidgetStateProperty<TextStyle?>? hintStyle;
  final TextCapitalization? textCapitalization;
  final bool enabled;
  final bool autoFocus;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final EdgeInsets scrollPadding;
  final EditableTextContextMenuBuilder contextMenuBuilder;
  final bool readOnly;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;

  @override
  State<M3ESearchBar> createState() => _M3ESearchBarState();
}

class _M3ESearchBarState extends State<M3ESearchBar> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final WidgetStatesController _statesController =
      WidgetStatesController();
  FocusNode? _internalFocusNode;

  FocusNode get _focusNode => widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _statesController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _statesController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _internalFocusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (BuildContext context) {
        final theme = M3ETheme.of(context);
        final barTheme = theme.searchBarTheme;
        final scheme = theme.colorScheme;
        final states = _statesController.value;
        final textDirection = Directionality.of(context);

        final effectiveElevation = barTheme.resolveElevation(
          states: states,
          widgetValue: widget.elevation,
        );
        final effectiveBackground = barTheme.resolveBackground(
          scheme: scheme,
          states: states,
          widgetValue: widget.backgroundColor,
        );
        final effectiveShadow = barTheme.resolveShadowColor(
          scheme: scheme,
          states: states,
          widgetValue: widget.shadowColor,
        );
        final effectiveSurfaceTint = barTheme.resolveSurfaceTint(
          scheme: scheme,
          states: states,
          widgetValue: widget.surfaceTintColor,
        );
        final effectiveOverlay = barTheme.resolveOverlay(
          scheme: scheme,
          states: states,
          widgetValue: widget.overlayColor,
        );
        final effectivePadding = widget.padding?.resolve(states) ??
            barTheme.padding();
        final effectiveShape = widget.shape?.resolve(states) ??
            barTheme.shape() as OutlinedBorder;
        final effectiveSide = widget.side?.resolve(states);
        final effectiveTextStyle = barTheme.resolveTextStyle(
          theme: theme,
          states: states,
          widgetValue: widget.textStyle,
        );
        final effectiveHintStyle = barTheme.resolveHintStyle(
          theme: theme,
          states: states,
          widgetValue: widget.hintStyle,
          textStyleOverride: widget.textStyle,
        );
        final effectiveTextCapitalization =
            widget.textCapitalization ?? TextCapitalization.none;

        final Widget? leading = widget.leading == null
            ? null
            : IconTheme.merge(
                data: IconThemeData(
                  color: barTheme.leadingIconColor(scheme),
                  size: barTheme.iconSize,
                ),
                child: widget.leading!,
              );

        final List<Widget>? trailing = widget.trailing
            ?.map(
              (Widget action) => IconTheme.merge(
                data: IconThemeData(
                  color: barTheme.trailingIconColor(scheme),
                  size: barTheme.iconSize,
                ),
                child: action,
              ),
            )
            .toList();

        return ConstrainedBox(
          constraints: barTheme.constraints(override: widget.constraints),
          child: Opacity(
            opacity: widget.enabled ? 1 : M3ESearchConstants.disabledOpacity,
            child: Material(
              elevation: effectiveElevation,
              shadowColor: effectiveShadow,
              color: effectiveBackground,
              surfaceTintColor: effectiveSurfaceTint,
              shape: effectiveShape.copyWith(side: effectiveSide),
              clipBehavior: Clip.antiAlias,
              child: IgnorePointer(
                ignoring: !widget.enabled,
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {
                      widget.onTap?.call();
                      if (!_focusNode.hasFocus) {
                        _focusNode.requestFocus();
                      }
                    },
                    overlayColor: effectiveOverlay == null
                        ? null
                        : WidgetStatePropertyAll<Color?>(effectiveOverlay),
                    customBorder: effectiveShape.copyWith(side: effectiveSide),
                    statesController: _statesController,
                    child: Padding(
                      padding: effectivePadding,
                      child: Row(
                        textDirection: textDirection,
                        children: <Widget>[
                          if (leading != null) leading,
                          Expanded(
                            child: Padding(
                              padding: effectivePadding,
                              child: M3ESearchBarInput(
                                controller: _controller,
                                focusNode: _focusNode,
                                hintText: widget.hintText,
                                enabled: widget.enabled,
                                readOnly: widget.readOnly,
                                autoFocus: widget.autoFocus,
                                onTap: widget.onTap,
                                onTapOutside: widget.onTapOutside,
                                onChanged: widget.onChanged,
                                onSubmitted: widget.onSubmitted,
                                textStyle: effectiveTextStyle,
                                hintStyle: effectiveHintStyle,
                                cursorColor: barTheme.cursorColor(scheme),
                                selectionColor:
                                    barTheme.selectionColor(scheme),
                                textCapitalization: effectiveTextCapitalization,
                                textInputAction: widget.textInputAction,
                                keyboardType: widget.keyboardType,
                                scrollPadding: widget.scrollPadding,
                                contextMenuBuilder: widget.contextMenuBuilder,
                                smartDashesType: widget.smartDashesType,
                                smartQuotesType: widget.smartQuotesType,
                              ),
                            ),
                          ),
                          ...?trailing,
                        ],
                      ),
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
}
