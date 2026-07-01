import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

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
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHigh,
          borderRadius: M3EShapes.resolve(28),
          boxShadow: widget.elevated
              ? M3EElevation.shadows(
                  M3EElevation.level1,
                  shadowColor: scheme.shadow,
                )
              : null,
        ),
        child: Row(
          children: <Widget>[
            IconTheme.merge(
              data: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
              child: widget.leading ?? const Icon(M3EIcons.search),
            ),
            const SizedBox(width: 16),
            Expanded(child: _buildInput(theme, scheme)),
            for (final Widget action in widget.trailing)
              IconTheme.merge(
                data: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
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
        style:
            theme.typeScale.bodyLarge.copyWith(color: scheme.onSurfaceVariant),
      );
    }
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        if (_controller.text.isEmpty)
          Text(
            widget.hintText,
            style: theme.typeScale.bodyLarge
                .copyWith(color: scheme.onSurfaceVariant),
          ),
        EditableText(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          style: theme.typeScale.bodyLarge.copyWith(color: scheme.onSurface),
          cursorColor: scheme.primary,
          backgroundCursorColor: scheme.outlineVariant,
          selectionColor: scheme.primary.withValues(alpha: 0.4),
        ),
      ],
    );
  }
}
