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
  bool _showClose = false;
  bool _autoDismiss = false;
  final M3ESnackbarController _controller = M3ESnackbarController();

  bool get _actionable => _showAction || _showClose;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _show(BuildContext context) {
    final Duration? duration = _actionable
        ? (_autoDismiss ? const Duration(seconds: 4) : null)
        : null;
    M3ESnackbar.show(
      context,
      controller: _controller,
      message: _message,
      actionLabel: _showAction ? _actionLabel : null,
      onAction: _showAction ? () {} : null,
      showCloseButton: _showClose,
      duration: duration,
    );
  }

  List<PlaySnippet> get _snippets {
    final String action = _showAction
        ? '''
  actionLabel: ${playDartString(_actionLabel)},
  onAction: () {},'''
        : '';
    final String close = _showClose ? '\n  showCloseButton: true,' : '';
    final String durationArg = _actionable && _autoDismiss
        ? '\n  duration: const Duration(seconds: 4),'
        : '';
    final String widgetSample =
        '''
M3ESnackbar(
  message: ${playDartString(_message)},$action$close
);''';
    final String showSample =
        '''
M3ESnackbar.show(
  context,
  message: ${playDartString(_message)},${_showAction ? '''
  actionLabel: ${playDartString(_actionLabel)},
  onAction: () {},''' : ''}${_showClose ? '''
  showCloseButton: true,''' : ''}$durationArg
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Inline preview',
        code: '$kPlaySnippetImport\n$widgetSample',
      ),
      PlaySnippet(
        label: 'Show overlay',
        code: '$kPlaySnippetImport\n$showSample',
      ),
    ];
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
            showCloseButton: _showClose,
          ),
        ),
        PlayPreviewCard(
          label: 'Show overlay',
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              M3EButton(
                onPressed: () => _show(context),
                child: const Text('Show snackbar'),
              ),
              const SizedBox(width: 8),
              M3EButton.text(
                onPressed: () => _controller.dismiss(),
                child: const Text('Dismiss'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
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
            PlaySwitch(
              label: 'Show close',
              value: _showClose,
              onChanged: (bool v) => setState(() => _showClose = v),
            ),
            if (_actionable)
              PlaySwitch(
                label: 'Auto-dismiss (4s)',
                value: _autoDismiss,
                onChanged: (bool v) => setState(() => _autoDismiss = v),
              ),
          ],
        ),
      ],
    );
  }
}
