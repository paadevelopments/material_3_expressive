import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3EChip].
class ChipsPlayground extends PlaygroundWidget {
  /// Creates the chips playground.
  const ChipsPlayground({super.key});

  @override
  PlaygroundState<ChipsPlayground> createState() => _ChipsPlaygroundState();
}

class _ChipsPlaygroundState extends PlaygroundState<ChipsPlayground> {
  M3EChipType _type = M3EChipType.assist;
  String _label = 'Chip';
  bool _selected = false;
  bool _elevated = false;
  bool _leading = true;
  bool _avatar = true;
  bool _trailing = false;
  bool _removable = true;
  bool _enabled = true;
  bool _removed = false;

  /// Filter and input chips carry a selected state.
  bool get _selectable =>
      _type == M3EChipType.filter || _type == M3EChipType.input;

  bool get _isInput => _type == M3EChipType.input;

  bool get _hasAvatar => _isInput && _avatar;

  /// A leading icon is ignored when an avatar is set.
  bool get _canLead => !_hasAvatar;

  @override
  Widget buildPreview(BuildContext context) {
    if (_removed) {
      return M3EButton.tonal(
        onPressed: () => setState(() => _removed = false),
        child: const Text('Restore chip'),
      );
    }
    return M3EChip(
      label: _label,
      type: _type,
      selected: _selectable && _selected,
      elevated: _elevated,
      leading: _canLead && _leading ? const Icon(M3EIcons.edit) : null,
      avatar: _hasAvatar ? const Icon(M3EIcons.person) : null,
      trailing: _trailing ? const Icon(M3EIcons.expand_more) : null,
      onPressed: _enabled
          ? () {
              if (_selectable) {
                setState(() => _selected = !_selected);
              }
            }
          : null,
      onDeleted: _enabled && _isInput && _removable
          ? () => setState(() => _removed = true)
          : null,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln('  label: ${playDartString(_label)},')
      ..writeln('  type: M3EChipType.${_type.name},');
    if (_selectable) {
      args.writeln('  selected: $_selected,');
    }
    if (_elevated) {
      args.writeln('  elevated: true,');
    }
    if (_canLead && _leading) {
      args.writeln('  leading: const Icon(M3EIcons.edit),');
    }
    if (_hasAvatar) {
      args.writeln('  avatar: const Icon(M3EIcons.person),');
    }
    if (_trailing) {
      args.writeln('  trailing: const Icon(M3EIcons.expand_more),');
    }
    args.writeln('  onPressed: ${_enabled ? '() {}' : 'null'},');
    if (_enabled && _isInput && _removable) {
      args.writeln('  onDeleted: () {},');
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Chip',
        code: '$kPlaySnippetImport\n\nM3EChip(\n$args);',
      ),
      const PlaySnippet(
        label: 'Chip group',
        code:
            '''
$kPlaySnippetImport

M3EChipGroup(
  groupLabel: 'Filters',
  child: Wrap(
    spacing: 8,
    runSpacing: 8,
    children: <Widget>[
      M3EChip(label: 'Assist', onPressed: () {}),
      M3EChip(label: 'Filter', type: M3EChipType.filter, onPressed: () {}),
    ],
  ),
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3EChipType>(
            label: 'Type',
            value: _type,
            values: M3EChipType.values,
            labelOf: (M3EChipType v) => v.name,
            onChanged: (M3EChipType v) => setState(() => _type = v),
          ),
          PlaySwitchItem(
            label: 'Elevated',
            description: 'Elevated container instead of an outline',
            value: _elevated,
            onChanged: (bool v) => setState(() => _elevated = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlayTextField(
            label: 'Label',
            value: _label,
            onChanged: (String v) => setState(() => _label = v),
          ),
          if (_isInput)
            PlaySwitchItem(
              label: 'Avatar',
              description: 'Replaces the leading icon',
              value: _avatar,
              onChanged: (bool v) => setState(() => _avatar = v),
            ),
          if (_canLead)
            PlaySwitchItem(
              label: 'Leading icon',
              value: _leading,
              onChanged: (bool v) => setState(() => _leading = v),
            ),
          PlaySwitchItem(
            label: 'Trailing icon',
            value: _trailing,
            onChanged: (bool v) => setState(() => _trailing = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'State',
        children: <Widget>[
          if (_selectable)
            PlaySwitchItem(
              label: 'Selected',
              description: 'Pressing the chip also toggles it',
              value: _selected,
              onChanged: (bool v) => setState(() => _selected = v),
            ),
          if (_isInput)
            PlaySwitchItem(
              label: 'Removable',
              description: 'Remove icon; Backspace or Delete also removes',
              value: _removable,
              onChanged: (bool v) => setState(() => _removable = v),
            ),
          PlaySwitchItem(
            label: 'Enabled',
            value: _enabled,
            onChanged: (bool v) => setState(() => _enabled = v),
          ),
        ],
      ),
    ];
  }
}
