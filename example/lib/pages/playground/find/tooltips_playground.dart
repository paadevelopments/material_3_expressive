import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ETooltip].
class TooltipsPlayground extends StatefulWidget {
  /// Creates the tooltips playground.
  const TooltipsPlayground({super.key});

  @override
  State<TooltipsPlayground> createState() => _TooltipsPlaygroundState();
}

enum _PlacementChoice { defaults, above, below, bottomStart, bottomEnd }

class _TooltipsPlaygroundState extends State<TooltipsPlayground> {
  bool _rich = false;
  bool _persistent = false;
  String _message = 'Compose a new message';
  String _richTitle = 'Compose';
  String _richMessage = 'Start a new draft with expressive defaults.';
  _PlacementChoice _placement = _PlacementChoice.defaults;
  final M3ETooltipController _controller = M3ETooltipController();

  M3ETooltipPlacement? get _resolvedPlacement => switch (_placement) {
    _PlacementChoice.defaults => null,
    _PlacementChoice.above => M3ETooltipPlacement.above,
    _PlacementChoice.below => M3ETooltipPlacement.below,
    _PlacementChoice.bottomStart => M3ETooltipPlacement.bottomStart,
    _PlacementChoice.bottomEnd => M3ETooltipPlacement.bottomEnd,
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<PlaySnippet> get _snippets {
    final String placementArg = _resolvedPlacement == null
        ? ''
        : '\n  preferredPlacement: M3ETooltipPlacement.${_resolvedPlacement!.name},';
    final String sample = _rich
        ? '''
M3ETooltip(
  persistent: $_persistent,
  richTitle: ${playDartString(_richTitle)},
  richMessage: ${playDartString(_richMessage)},$placementArg
  actions: <Widget>[
    M3EButton.text(onPressed: () {}, child: const Text('Got it')),
  ],
  child: M3EIconButton(
    icon: const Icon(M3EIcons.edit),
    variant: M3EIconButtonVariant.tonal,
    onPressed: () {},
  ),
);'''
        : '''
M3ETooltip(
  message: ${playDartString(_message)},$placementArg
  child: M3EIconButton(
    icon: const Icon(M3EIcons.edit),
    variant: M3EIconButtonVariant.tonal,
    onPressed: () {},
  ),
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: _rich ? 'Rich tooltip' : 'Plain tooltip',
        code: '$kPlaySnippetImport\n$sample',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Widget child = M3EIconButton(
      icon: const Icon(M3EIcons.edit),
      variant: M3EIconButtonVariant.tonal,
      onPressed: () {},
    );
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: _rich
              ? (_persistent ? 'Persistent rich' : 'Rich tooltip')
              : 'Plain tooltip',
          child: _rich
              ? M3ETooltip(
                  persistent: _persistent,
                  richTitle: _richTitle,
                  richMessage: _richMessage,
                  preferredPlacement: _resolvedPlacement,
                  controller: _persistent ? _controller : null,
                  actions: <Widget>[
                    M3EButton.text(
                      onPressed: () {},
                      child: const Text('Got it'),
                    ),
                  ],
                  child: child,
                )
              : M3ETooltip(
                  message: _message,
                  preferredPlacement: _resolvedPlacement,
                  child: child,
                ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlaySwitch(
              label: 'Rich tooltip',
              value: _rich,
              onChanged: (bool v) => setState(() {
                _rich = v;
                if (!v) {
                  _persistent = false;
                }
              }),
            ),
            if (_rich)
              PlaySwitch(
                label: 'Persistent (tap / controller)',
                value: _persistent,
                onChanged: (bool v) => setState(() => _persistent = v),
              ),
            if (_rich && _persistent)
              M3EButton.text(
                onPressed: () => _controller.show(),
                child: const Text('Controller show'),
              ),
            PlayEnumSegmented<_PlacementChoice>(
              label: 'Placement',
              value: _placement,
              values: _PlacementChoice.values,
              labelOf: (_PlacementChoice v) => switch (v) {
                _PlacementChoice.defaults => 'default',
                _PlacementChoice.above => 'above',
                _PlacementChoice.below => 'below',
                _PlacementChoice.bottomStart => 'bottomStart',
                _PlacementChoice.bottomEnd => 'bottomEnd',
              },
              onChanged: (_PlacementChoice v) {
                setState(() => _placement = v);
              },
            ),
            if (!_rich)
              PlayTextField(
                label: 'Message',
                value: _message,
                onChanged: (String v) => setState(() => _message = v),
              ),
            if (_rich)
              PlayTextField(
                label: 'Rich title',
                value: _richTitle,
                onChanged: (String v) => setState(() => _richTitle = v),
              ),
            if (_rich)
              PlayTextField(
                label: 'Rich message',
                value: _richMessage,
                onChanged: (String v) => setState(() => _richMessage = v),
              ),
          ],
        ),
      ],
    );
  }
}
