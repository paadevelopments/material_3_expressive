import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EChip].
class ChipsPlayground extends StatefulWidget {
  /// Creates the chips playground.
  const ChipsPlayground({super.key});

  @override
  State<ChipsPlayground> createState() => _ChipsPlaygroundState();
}

class _ChipsPlaygroundState extends State<ChipsPlayground> {
  M3EChipType _type = M3EChipType.assist;
  bool _selected = false;
  bool _elevated = false;
  bool _showLeading = true;
  bool _enabled = true;
  String _label = 'Chip';

  VoidCallback? get _onPressed => _enabled
      ? () {
          if (_type == M3EChipType.filter) {
            setState(() => _selected = !_selected);
          }
        }
      : null;

  VoidCallback? get _onDeleted =>
      _enabled && _type == M3EChipType.input ? () {} : null;

  List<PlaySnippet> get _snippets {
    final String leading = _showLeading
        ? '\n  leading: const Icon(M3EIcons.edit),'
        : '';
    final String deleted = _onDeleted != null ? '\n  onDeleted: () {},' : '';
    final String pressed = _onPressed != null ? '() {}' : 'null';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Selected type',
        code:
            '''
$kPlaySnippetImport

M3EChip(
  label: ${playDartString(_label)},
  type: M3EChipType.${_type.name},
  selected: $_selected,
  elevated: $_elevated,$leading
  onPressed: $pressed,$deleted
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Selected type',
          child: M3EChip(
            label: _label,
            type: _type,
            selected: _selected,
            elevated: _elevated,
            leading: _showLeading ? const Icon(M3EIcons.edit) : null,
            onPressed: _onPressed,
            onDeleted: _onDeleted,
          ),
        ),
        PlayPreviewCard(
          label: 'All types',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final M3EChipType type in M3EChipType.values)
                M3EChip(
                  label: type.name,
                  type: type,
                  selected: type == M3EChipType.filter && _selected,
                  elevated: _elevated,
                  leading: _showLeading ? const Icon(M3EIcons.tag) : null,
                  onPressed: _enabled ? () {} : null,
                  onDeleted: type == M3EChipType.input && _enabled
                      ? () {}
                      : null,
                ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumMenu<M3EChipType>(
              label: 'Type',
              value: _type,
              values: M3EChipType.values,
              labelOf: (M3EChipType v) => v.name,
              onChanged: (M3EChipType v) => setState(() => _type = v),
            ),
            PlayTextField(
              label: 'Label',
              value: _label,
              onChanged: (String v) => setState(() => _label = v),
            ),
            PlaySwitch(
              label: 'Leading icon',
              value: _showLeading,
              onChanged: (bool v) => setState(() => _showLeading = v),
            ),
            PlaySwitch(
              label: 'Elevated',
              value: _elevated,
              onChanged: (bool v) => setState(() => _elevated = v),
            ),
            PlaySwitch(
              label: 'Selected',
              value: _selected,
              onChanged: (bool v) => setState(() => _selected = v),
            ),
            PlaySwitch(
              label: 'Enabled',
              value: _enabled,
              onChanged: (bool v) => setState(() => _enabled = v),
            ),
          ],
        ),
      ],
    );
  }
}
