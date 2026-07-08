import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_search_bar_tokens.dart';

export 'styles/m3e_search_bar_tokens.dart';

/// A Material 3 Expressive search bar.
///
/// A rounded input that lets people enter a keyword or phrase. Provide a
/// [controller] for live typing, or supply [onTap] to open a dedicated search
/// view. Leading defaults to a search icon; [trailing] can host actions.
class M3ESearchBar extends StatefulWidget {
  const M3ESearchBar({
    this.controller,
    this.focusNode,
    this.hintText = 'Search',
    this.leading,
    this.trailing = const <Widget>[],
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.elevated = true,
    super.key,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final Widget? leading;
  final List<Widget> trailing;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool elevated;

  @override
  State<M3ESearchBar> createState() => _M3ESearchBarState();
}

class _M3ESearchBarState extends State<M3ESearchBar> {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleChange);
  }

  void _handleChange() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_handleChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    return GestureDetector(
      onTap: widget.onTap ?? _focusNode.requestFocus,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: M3ESearchBarTokens.height,
        padding: const EdgeInsets.symmetric(
          horizontal: M3ESearchBarTokens.horizontalPadding,
        ),
        decoration: BoxDecoration(
          color: M3ESearchBarTokens.containerColor(scheme),
          borderRadius: M3EShapes.resolve(M3ESearchBarTokens.cornerRadius),
          boxShadow: widget.elevated
              ? M3EElevation.shadows(
                  M3ESearchBarTokens.elevation,
                  shadowColor: scheme.shadow,
                )
              : null,
        ),
        child: Row(
          children: <Widget>[
            IconTheme.merge(
              data: IconThemeData(
                color: M3ESearchBarTokens.iconColor(scheme),
                size: M3ESearchBarTokens.iconSize,
              ),
              child: widget.leading ?? const Icon(M3EIcons.search),
            ),
            const SizedBox(width: M3ESearchBarTokens.leadingGap),
            Expanded(child: _buildInput(theme, scheme)),
            for (final Widget action in widget.trailing)
              IconTheme.merge(
                data: IconThemeData(
                  color: M3ESearchBarTokens.iconColor(scheme),
                  size: M3ESearchBarTokens.iconSize,
                ),
                child: action,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(M3EThemeData theme, M3EColorScheme scheme) {
    if (widget.onTap != null) {
      return Text(
        widget.hintText,
        style: M3ESearchBarTokens.hintStyle(theme.typeScale, scheme),
      );
    }
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        if (_controller.text.isEmpty)
          Text(
            widget.hintText,
            style: M3ESearchBarTokens.hintStyle(theme.typeScale, scheme),
          ),
        EditableText(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: M3ESearchBarTokens.inputStyle(theme.typeScale, scheme),
          cursorColor: M3ESearchBarTokens.cursorColor(scheme),
          backgroundCursorColor: scheme.outlineVariant,
          selectionColor: M3ESearchBarTokens.selectionColor(scheme),
        ),
      ],
    );
  }
}
