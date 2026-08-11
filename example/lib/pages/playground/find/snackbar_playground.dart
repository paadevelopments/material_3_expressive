import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ESnackbar].
class SnackbarPlayground extends StatefulWidget {
  /// Creates the snackbar playground.
  const SnackbarPlayground({super.key});

  @override
  State<SnackbarPlayground> createState() => _SnackbarPlaygroundState();
}

class _SnackbarPlaygroundState extends State<SnackbarPlayground> {
  String _message = 'Draft saved';
  String _actionLabel = 'Undo';
  bool _showAction = true;

  void _show(BuildContext context) {
    M3ESnackbar.show(
      context,
      message: _message,
      actionLabel: _showAction ? _actionLabel : null,
      onAction: _showAction ? () {} : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Inline preview',
          child: M3ESnackbar(
            message: _message,
            actionLabel: _showAction ? _actionLabel : null,
            onAction: _showAction ? () {} : null,
          ),
        ),
        PlayPreviewCard(
          label: 'Show overlay',
          child: M3EButton(
            onPressed: () => _show(context),
            child: const Text('Show snackbar'),
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlayTextField(
              label: 'Message',
              value: _message,
              onChanged: (String v) => setState(() => _message = v),
            ),
            PlaySwitch(
              label: 'Show action',
              value: _showAction,
              onChanged: (bool v) => setState(() => _showAction = v),
            ),
            if (_showAction)
              PlayTextField(
                label: 'Action label',
                value: _actionLabel,
                onChanged: (String v) => setState(() => _actionLabel = v),
              ),
          ],
        ),
      ],
    );
  }
}
