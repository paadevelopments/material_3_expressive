import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'enums/m3e_text_field_variant.dart';

/// A Material 3 Expressive text field.
///
/// Supports the filled and outlined variants, a floating label, leading and
/// trailing widgets, supporting text and an error state. The label floats on
/// focus or when the field holds text, and the active indicator/outline and
/// label recolor to reflect focus and error states.
class M3ETextField extends StatefulWidget {
  const M3ETextField({
    this.controller,
    this.focusNode,
    this.label,
    this.supportingText,
    this.errorText,
    this.leading,
    this.trailing,
    this.variant = M3ETextFieldVariant.filled,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.onTapOutside,
    this.maxLines = 1,
    super.key,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? supportingText;
  final String? errorText;
  final Widget? leading;
  final Widget? trailing;
  final M3ETextFieldVariant variant;
  final bool obscureText;
  final bool enabled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TapRegionCallback? onTapOutside;
  final int maxLines;

  bool get hasError => errorText != null;

  @override
  State<M3ETextField> createState() => _M3ETextFieldState();
}

class _M3ETextFieldState extends State<M3ETextField> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
    _controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _controller.removeListener(_handleTextChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _handleFocusChange() => setState(() => _focused = _focusNode.hasFocus);

  void _handleTextChange() {
    widget.onChanged?.call(_controller.text);
    setState(() {});
  }

  bool get _floating => _focused || _controller.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return M3EComponentTheme(builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildContainer(theme),
          _buildSupporting(theme),
        ],
      ),
    );
  }

  Widget _buildContainer(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    final textFieldTheme = theme.textFieldTheme;
    final accent = textFieldTheme.accentColor(
      scheme,
      enabled: widget.enabled,
      hasError: widget.hasError,
    );
    final outlined = widget.variant == M3ETextFieldVariant.outlined;

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: M3EMotion.short3,
        curve: M3EMotion.standard,
        padding: textFieldTheme.horizontalPadding,
        constraints: BoxConstraints(minHeight: textFieldTheme.minHeight),
        decoration: textFieldTheme.decoration(
          scheme,
          accent: accent,
          outlined: outlined,
          focused: _focused,
          hasError: widget.hasError,
        ),
        child: Row(
          children: _buildRowChildren(theme, scheme, accent),
        ),
      ),
    );
  }

  List<Widget> _buildRowChildren(
      M3EThemeData theme,
      M3EColorScheme scheme,
      Color accent,
      ) {
    final textFieldTheme = theme.textFieldTheme;
    return <Widget>[
      if (widget.leading != null) ...<Widget>[
        IconTheme.merge(
          data: IconThemeData(
            color: scheme.onSurfaceVariant,
            size: textFieldTheme.iconSize,
          ),
          child: widget.leading!,
        ),
        SizedBox(width: textFieldTheme.iconGap),
      ],
      Expanded(child: _buildField(theme, scheme, accent)),
      if (widget.trailing != null) ...<Widget>[
        SizedBox(width: textFieldTheme.iconGap),
        IconTheme.merge(
          data: IconThemeData(
            color: widget.hasError ? scheme.error : scheme.onSurfaceVariant,
            size: textFieldTheme.iconSize,
          ),
          child: widget.trailing!,
        ),
      ],
    ];
  }

  Widget _buildField(
      M3EThemeData theme,
      M3EColorScheme scheme,
      Color accent,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.label != null) _buildLabel(theme, scheme, accent),
        EditableText(
          controller: _controller,
          focusNode: _focusNode,
          readOnly: !widget.enabled,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onSubmitted: widget.onSubmitted,
          onTapOutside:
              widget.onTapOutside ?? M3EFocus.tapOutsideHandler(_focusNode),
          style: theme.typeScale.bodyLarge.copyWith(color: scheme.onSurface),
          cursorColor: accent,
          backgroundCursorColor: scheme.outlineVariant,
          selectionColor: scheme.primary
              .withValues(alpha: theme.textFieldTheme.selectionOpacity),
        ),
      ],
    );
  }

  Widget _buildLabel(
      M3EThemeData theme,
      M3EColorScheme scheme,
      Color accent,
      ) {
    final TextStyle style = _floating
        ? theme.typeScale.bodySmall.copyWith(color: accent)
        : theme.typeScale.bodyLarge.copyWith(color: scheme.onSurfaceVariant);
    return AnimatedDefaultTextStyle(
      duration: M3EMotion.short3,
      curve: M3EMotion.standard,
      style: style,
      child: Padding(
        padding: EdgeInsets.only(
          top: _floating
              ? theme.textFieldTheme.labelFloatingTopPadding
              : theme.textFieldTheme.labelRestingTopPadding,
          bottom: theme.textFieldTheme.labelBottomPadding,
        ),
        child: Text(widget.label!),
      ),
    );
  }

  Widget _buildSupporting(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    final String? text = widget.errorText ?? widget.supportingText;
    if (text == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: theme.textFieldTheme.supportingTextPadding,
      child: Text(
        text,
        style: theme.typeScale.bodySmall.copyWith(
          color: widget.hasError ? scheme.error : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
