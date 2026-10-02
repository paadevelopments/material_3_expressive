import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// How the snackbar is presented.
enum _Presentation { overlay, inline }

/// Live playground for [M3ESnackbar].
class SnackbarPlayground extends PlaygroundWidget {
  /// Creates the snackbar playground.
  const SnackbarPlayground({super.key});

  @override
  PlaygroundState<SnackbarPlayground> createState() =>
      _SnackbarPlaygroundState();
}

class _SnackbarPlaygroundState extends PlaygroundState<SnackbarPlayground> {
  final M3ESnackbarController _controller = M3ESnackbarController();

  _Presentation _presentation = _Presentation.overlay;
  String _message = 'Draft saved';
  bool _longMessage = false;
  String _actionLabel = 'Undo';
  bool _showAction = true;
  bool _showClose = false;
  bool _autoDismiss = false;
  double _seconds = 4;

  static const String _longText =
      'Your draft was saved to the cloud and will sync to your other devices';

  String get _text => _longMessage ? _longText : _message;

  /// Snackbars without actions always time out.
  bool get _actionable => _showAction || _showClose;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _show(BuildContext context) {
    M3ESnackbar.show(
      context,
      controller: _controller,
      message: _text,
      actionLabel: _showAction ? _actionLabel : null,
      onAction: _showAction ? () {} : null,
      showCloseButton: _showClose,
      duration: !_actionable || _autoDismiss
          ? Duration(milliseconds: (_seconds * 1000).round())
          : null,
    );
  }

  @override
  Widget buildPreview(BuildContext context) {
    if (_presentation == _Presentation.inline) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: M3ESnackbar(
          message: _text,
          actionLabel: _showAction ? _actionLabel : null,
          onAction: _showAction ? () {} : null,
          showCloseButton: _showClose,
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: <Widget>[
        M3EButton(
          onPressed: () => _show(context),
          child: const Text('Show snackbar'),
        ),
        M3EButton.text(
          onPressed: _controller.dismiss,
          child: const Text('Dismiss'),
        ),
      ],
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln('  message: ${playDartString(_text)},');
    if (_showAction) {
      args
        ..writeln('  actionLabel: ${playDartString(_actionLabel)},')
        ..writeln('  onAction: () {},');
    }
    if (_showClose) {
      args.writeln('  showCloseButton: true,');
    }
    if (_presentation == _Presentation.inline) {
      return <PlaySnippet>[
        PlaySnippet(
          label: 'Inline snackbar',
          code: '$kPlaySnippetImport\n\nM3ESnackbar(\n$args);',
        ),
      ];
    }
    if (!_actionable || _autoDismiss) {
      args.writeln(
        '  duration: Duration(milliseconds: ${(_seconds * 1000).round()}),',
      );
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Show snackbar',
        code:
            '$kPlaySnippetImport\n\n'
            'final controller = M3ESnackbarController();\n\n'
            'M3ESnackbar.show(\n  context,\n  controller: controller,\n$args);\n\n'
            'controller.dismiss();',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    final bool overlay = _presentation == _Presentation.overlay;
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_Presentation>(
            label: 'Presentation',
            value: _presentation,
            values: _Presentation.values,
            labelOf: (_Presentation v) => switch (v) {
              _Presentation.overlay => 'shown at the bottom',
              _Presentation.inline => 'inline widget',
            },
            onChanged: (_Presentation v) => setState(() => _presentation = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Long message',
            description: 'Wraps to two lines',
            value: _longMessage,
            onChanged: (bool v) => setState(() => _longMessage = v),
          ),
          if (!_longMessage)
            PlayTextField(
              label: 'Message',
              value: _message,
              onChanged: (String v) => setState(() => _message = v),
            ),
          PlaySwitchItem(
            label: 'Action',
            value: _showAction,
            onChanged: (bool v) => setState(() => _showAction = v),
          ),
          if (_showAction)
            PlayTextField(
              label: 'Action label',
              value: _actionLabel,
              onChanged: (String v) => setState(() => _actionLabel = v),
            ),
          PlaySwitchItem(
            label: 'Close button',
            value: _showClose,
            onChanged: (bool v) => setState(() => _showClose = v),
          ),
        ],
      ),
      if (overlay)
        PlayControlGroup(
          title: 'Timing',
          children: <Widget>[
            if (_actionable)
              PlaySwitchItem(
                label: 'Auto-dismiss',
                description: 'Snackbars with actions stay until closed',
                value: _autoDismiss,
                onChanged: (bool v) => setState(() => _autoDismiss = v),
              ),
            if (!_actionable || _autoDismiss)
              PlaySlider(
                label: 'Duration (s)',
                value: _seconds,
                min: 2,
                max: 10,
                divisions: 8,
                onChanged: (double v) => setState(() => _seconds = v),
              ),
          ],
        ),
    ];
  }
}
