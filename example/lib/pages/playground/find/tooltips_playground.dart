import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Plain or rich tooltip.
enum _TooltipKind { plain, rich }

/// Placement preset; default follows the kind.
enum _PlacementChoice { defaults, above, below, bottomStart, bottomEnd }

/// Live playground for [M3ETooltip].
class TooltipsPlayground extends PlaygroundWidget {
  /// Creates the tooltips playground.
  const TooltipsPlayground({super.key});

  @override
  PlaygroundState<TooltipsPlayground> createState() =>
      _TooltipsPlaygroundState();
}

class _TooltipsPlaygroundState extends PlaygroundState<TooltipsPlayground> {
  final M3ETooltipController _controller = M3ETooltipController();

  _TooltipKind _kind = _TooltipKind.plain;
  bool _persistent = false;
  String _message = 'Compose a new message';
  bool _showTitle = true;
  String _richTitle = 'Compose';
  String _richMessage = 'Start a new draft with expressive defaults.';
  double _actionCount = 1;
  _PlacementChoice _placement = _PlacementChoice.defaults;
  bool _customDelay = false;
  double _delayMs = 1500;

  bool get _rich => _kind == _TooltipKind.rich;

  M3ETooltipPlacement? get _resolvedPlacement => switch (_placement) {
    _PlacementChoice.defaults => null,
    _PlacementChoice.above => M3ETooltipPlacement.above,
    _PlacementChoice.below => M3ETooltipPlacement.below,
    _PlacementChoice.bottomStart => M3ETooltipPlacement.bottomStart,
    _PlacementChoice.bottomEnd => M3ETooltipPlacement.bottomEnd,
  };

  /// Persistent tooltips stay until dismissed, so the delay does not apply.
  bool get _hasDelay => !(_rich && _persistent);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Widget> get _actions => <Widget>[
    if (_actionCount >= 1)
      M3EButton.text(onPressed: () {}, child: const Text('Got it')),
    if (_actionCount >= 2)
      M3EButton.text(onPressed: () {}, child: const Text('Learn more')),
  ];

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final Widget anchor = M3EIconButton(
      icon: const Icon(M3EIcons.edit),
      variant: M3EIconButtonVariant.tonal,
      onPressed: () {},
    );
    final Duration? delay = _hasDelay && _customDelay
        ? Duration(milliseconds: _delayMs.round())
        : null;
    final Widget tooltip = _rich
        ? M3ETooltip(
            // Persistence only applies when the tooltip is created.
            key: ValueKey<bool>(_persistent),
            persistent: _persistent,
            richTitle: _showTitle ? _richTitle : null,
            richMessage: _richMessage,
            actions: _actions,
            preferredPlacement: _resolvedPlacement,
            dismissDelay: delay,
            controller: _controller,
            child: anchor,
          )
        : M3ETooltip(
            message: _message,
            preferredPlacement: _resolvedPlacement,
            dismissDelay: delay,
            controller: _controller,
            child: anchor,
          );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        tooltip,
        const SizedBox(height: 32),
        Text(
          _rich && _persistent
              ? 'Tap the button to show the tooltip.'
              : 'Hover, focus or long-press the button.',
          style: theme.typeScale.bodyMedium.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        M3EButton.text(
          onPressed: _controller.show,
          child: const Text('Show with controller'),
        ),
      ],
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer();
    if (_rich) {
      if (_persistent) {
        args.writeln('  persistent: true,');
      }
      if (_showTitle) {
        args.writeln('  richTitle: ${playDartString(_richTitle)},');
      }
      args.writeln('  richMessage: ${playDartString(_richMessage)},');
      if (_actionCount >= 1) {
        args.writeln('  actions: <Widget>[');
        args.writeln(
          "    M3EButton.text(onPressed: () {}, child: const Text('Got it')),",
        );
        if (_actionCount >= 2) {
          args.writeln(
            '    M3EButton.text(onPressed: () {}, '
            "child: const Text('Learn more')),",
          );
        }
        args.writeln('  ],');
      }
    } else {
      args.writeln('  message: ${playDartString(_message)},');
    }
    if (_resolvedPlacement != null) {
      args.writeln(
        '  preferredPlacement: M3ETooltipPlacement.${_resolvedPlacement!.name},',
      );
    }
    if (_hasDelay && _customDelay) {
      args.writeln(
        '  dismissDelay: Duration(milliseconds: ${_delayMs.round()}),',
      );
    }
    args.writeln('  controller: controller, // controller.show()');
    return <PlaySnippet>[
      PlaySnippet(
        label: _rich ? 'Rich tooltip' : 'Plain tooltip',
        code:
            '$kPlaySnippetImport\n\nM3ETooltip(\n$args'
            '  child: M3EIconButton(\n'
            '    icon: const Icon(M3EIcons.edit),\n'
            '    onPressed: () {},\n'
            '  ),\n);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_TooltipKind>(
            label: 'Kind',
            value: _kind,
            values: _TooltipKind.values,
            labelOf: (_TooltipKind v) => v.name,
            onChanged: (_TooltipKind v) => setState(() => _kind = v),
          ),
          if (_rich)
            PlaySwitchItem(
              label: 'Persistent',
              description: 'Shows on tap or controller, not hover or focus',
              value: _persistent,
              onChanged: (bool v) => setState(() => _persistent = v),
            ),
          PlayEnumChoice<_PlacementChoice>(
            label: 'Placement',
            value: _placement,
            values: _PlacementChoice.values,
            labelOf: (_PlacementChoice v) => switch (v) {
              _PlacementChoice.defaults =>
                _rich ? 'default (bottom end)' : 'default (above)',
              _PlacementChoice.above => 'above',
              _PlacementChoice.below => 'below',
              _PlacementChoice.bottomStart => 'bottom start',
              _PlacementChoice.bottomEnd => 'bottom end',
            },
            onChanged: (_PlacementChoice v) => setState(() => _placement = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          if (!_rich)
            PlayTextField(
              label: 'Message',
              value: _message,
              onChanged: (String v) => setState(() => _message = v),
            ),
          if (_rich) ...<Widget>[
            PlaySwitchItem(
              label: 'Title',
              value: _showTitle,
              onChanged: (bool v) => setState(() => _showTitle = v),
            ),
            if (_showTitle)
              PlayTextField(
                label: 'Title text',
                value: _richTitle,
                onChanged: (String v) => setState(() => _richTitle = v),
              ),
            PlayTextField(
              label: 'Supporting text',
              value: _richMessage,
              onChanged: (String v) => setState(() => _richMessage = v),
            ),
            PlaySlider(
              label: 'Actions',
              value: _actionCount,
              max: 2,
              divisions: 2,
              onChanged: (double v) => setState(() => _actionCount = v),
            ),
          ],
        ],
      ),
      if (_hasDelay)
        PlayControlGroup(
          title: 'Timing',
          children: <Widget>[
            PlaySwitchItem(
              label: 'Custom dismiss delay',
              value: _customDelay,
              onChanged: (bool v) => setState(() => _customDelay = v),
            ),
            if (_customDelay)
              PlaySlider(
                label: 'Dismiss delay (ms)',
                value: _delayMs,
                min: 500,
                max: 5000,
                divisions: 18,
                onChanged: (double v) => setState(() => _delayMs = v),
              ),
          ],
        ),
    ];
  }
}
