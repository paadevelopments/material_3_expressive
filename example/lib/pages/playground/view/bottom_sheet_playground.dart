import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EBottomSheet].
class BottomSheetPlayground extends StatefulWidget {
  /// Creates the bottom sheet playground.
  const BottomSheetPlayground({super.key});

  @override
  State<BottomSheetPlayground> createState() => _BottomSheetPlaygroundState();
}

class _BottomSheetPlaygroundState extends State<BottomSheetPlayground> {
  bool _showDragHandle = true;
  String _body = 'A modal bottom sheet with a drag handle.';

  List<PlaySnippet> get _snippets {
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Bottom sheet',
        code:
            '''
$kPlaySnippetImport

M3EBottomSheet.show<void>(
  context,
  showDragHandle: $_showDragHandle,
  builder: (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Text(${playDartString(_body)}),
    );
  },
);''',
      ),
    ];
  }

  void _showSheet() {
    M3EBottomSheet.show<void>(
      context,
      showDragHandle: _showDragHandle,
      builder: (BuildContext context) {
        final M3EThemeData theme = M3ETheme.of(context);
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Text(_body, style: theme.typeScale.bodyLarge),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Trigger',
          child: M3EButton(
            style: M3EButtonStyle.tonal,
            onPressed: _showSheet,
            child: const Text('Show bottom sheet'),
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Sheet',
          children: <Widget>[
            PlaySwitch(
              label: 'Drag handle',
              value: _showDragHandle,
              onChanged: (bool v) => setState(() => _showDragHandle = v),
            ),
            PlayTextField(
              label: 'Body',
              value: _body,
              onChanged: (String v) => setState(() => _body = v),
            ),
          ],
        ),
      ],
    );
  }
}
