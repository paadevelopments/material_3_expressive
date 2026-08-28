import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import 'play_code_snippet.dart';

export 'play_code_snippet.dart';

/// Scrollable playground: previews, optional code, then controls.
class PlaygroundBody extends StatefulWidget {
  /// Creates a playground body.
  const PlaygroundBody({
    required this.previews,
    required this.controls,
    this.snippets = const <PlaySnippet>[],
    this.pinPreviewsByDefault = false,
    super.key,
  });

  /// Live variation previews.
  final List<Widget> previews;

  /// Paste-ready samples for the current controls.
  final List<PlaySnippet> snippets;

  /// Live control widgets.
  final List<Widget> controls;

  /// Initial pin state. Short preview areas should pass `true`; tall previews
  /// should leave the default `false`.
  final bool pinPreviewsByDefault;

  @override
  State<PlaygroundBody> createState() => _PlaygroundBodyState();
}

class _PlaygroundBodyState extends State<PlaygroundBody> {
  static const EdgeInsets _tailPadding = EdgeInsets.fromLTRB(16, 16, 16, 32);

  late bool _pinPreviews = widget.pinPreviewsByDefault;

  @override
  void didUpdateWidget(covariant PlaygroundBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pinPreviewsByDefault != widget.pinPreviewsByDefault) {
      _pinPreviews = widget.pinPreviewsByDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final _PreviewSection preview = _PreviewSection(
      theme: theme,
      previews: widget.previews,
      pinned: _pinPreviews,
      onTogglePin: () => setState(() => _pinPreviews = !_pinPreviews),
    );
    final List<Widget> tail = _tailChildren(
      theme,
      widget.snippets,
      widget.controls,
    );
    final Widget tailSection = Padding(
      padding: _tailPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: tail,
      ),
    );

    if (_pinPreviews) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          preview,
          Expanded(
            child: ListView(
              primary: false,
              padding: _tailPadding,
              children: tail,
            ),
          ),
        ],
      );
    }

    return ListView(
      primary: false,
      padding: EdgeInsets.zero,
      children: <Widget>[preview, tailSection],
    );
  }

  static List<Widget> _tailChildren(
    M3EThemeData theme,
    List<PlaySnippet> snippets,
    List<Widget> controls,
  ) {
    return <Widget>[
      if (snippets.isNotEmpty) ...<Widget>[
        const SizedBox(height: 24),
        Text('Code', style: theme.typeScale.titleMedium),
        const SizedBox(height: 12),
        for (final PlaySnippet snippet in snippets)
          PlayCodeSnippet(snippet: snippet),
      ],
      if (controls.isNotEmpty) ...<Widget>[
        const SizedBox(height: 24),
        Text('Controls', style: theme.typeScale.titleMedium),
        const SizedBox(height: 12),
        ...controls,
      ],
    ];
  }
}

class _PreviewSection extends StatelessWidget {
  const _PreviewSection({
    required this.theme,
    required this.previews,
    required this.pinned,
    required this.onTogglePin,
  });

  final M3EThemeData theme;
  final List<Widget> previews;
  final bool pinned;
  final VoidCallback onTogglePin;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text('Preview', style: theme.typeScale.titleMedium),
                ),
                M3EIconButton(
                  icon: Icon(
                    pinned ? M3EIcons.push_pin : M3EIcons.push_pin_outlined,
                  ),
                  tooltip: pinned ? 'Unpin preview' : 'Pin preview',
                  onPressed: onTogglePin,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...previews,
          ],
        ),
      ),
    );
  }
}
