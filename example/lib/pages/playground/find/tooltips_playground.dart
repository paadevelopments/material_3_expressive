import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
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

class _TooltipsPlaygroundState extends State<TooltipsPlayground> {
  bool _rich = false;
  String _message = 'Compose a new message';
  String _richTitle = 'Compose';
  String _richMessage = 'Start a new draft with expressive defaults.';

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
          label: _rich ? 'Rich tooltip' : 'Plain tooltip',
          child: _rich
              ? M3ETooltip(
                  richTitle: _richTitle,
                  richMessage: _richMessage,
                  actions: <Widget>[
                    M3EButton.text(
                      onPressed: () {},
                      child: const Text('Got it'),
                    ),
                  ],
                  child: child,
                )
              : M3ETooltip(message: _message, child: child),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlaySwitch(
              label: 'Rich tooltip',
              value: _rich,
              onChanged: (bool v) => setState(() => _rich = v),
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
