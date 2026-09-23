import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EMenu].
class MenuPlayground extends StatefulWidget {
  /// Creates the menu playground.
  const MenuPlayground({super.key});

  @override
  State<MenuPlayground> createState() => _MenuPlaygroundState();
}

class _MenuPlaygroundState extends State<MenuPlayground> {
  M3EMenuColorStyle _colorStyle = M3EMenuColorStyle.standard;
  M3EMenuAnchorPosition _position = M3EMenuAnchorPosition.bottomStart;
  M3EMenuVariant _variant = M3EMenuVariant.vertical;
  M3EMenuSelectionMode _selectionMode = M3EMenuSelectionMode.single;
  bool _closeOnSelect = true;
  String _selected = 'Inbox';
  final Set<String> _multi = <String>{'Inbox'};
  bool _starred = true;

  bool get _isMulti => _selectionMode == M3EMenuSelectionMode.multi;

  List<M3EMenuNode> get _children {
    return <M3EMenuNode>[
      M3EMenuGroup(
        label: 'Mailbox',
        children: <M3EMenuNode>[
          M3EMenuSelectable(
            label: 'Inbox',
            value: 'Inbox',
            selected: _isSelected('Inbox'),
            leading: const Icon(M3EIcons.inbox),
          ),
          M3EMenuSelectable(
            label: 'Sent',
            value: 'Sent',
            selected: _isSelected('Sent'),
            leading: const Icon(M3EIcons.send),
          ),
        ],
      ),
      M3EMenuGroup(
        children: <M3EMenuNode>[
          M3EMenuToggleable(
            label: 'Starred',
            checked: _starred,
            onChanged: (bool value) => setState(() => _starred = value),
          ),
          M3EMenuSubmenu(
            label: 'More actions',
            leading: const Icon(M3EIcons.more_horiz),
            children: <M3EMenuNode>[
              M3EMenuEntry(
                label: 'Archive',
                leading: const Icon(M3EIcons.archive),
                onPressed: () {},
              ),
              M3EMenuEntry(
                label: 'Report',
                leading: const Icon(M3EIcons.report),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ];
  }

  bool _isSelected(String value) {
    if (_isMulti) {
      return _multi.contains(value);
    }
    return _selected == value;
  }

  void _onSelected(Object? value) {
    if (value is! String) {
      return;
    }
    setState(() {
      if (_isMulti) {
        if (!_multi.add(value)) {
          _multi.remove(value);
        }
      } else {
        _selected = value;
      }
    });
  }

  List<PlaySnippet> get _snippets {
    final String sample =
        '''
M3EMenu(
  variant: M3EMenuVariant.${_variant.name},
  selectionMode: M3EMenuSelectionMode.${_selectionMode.name},
  position: M3EMenuAnchorPosition.${_position.name},
  colorStyle: M3EMenuColorStyle.${_colorStyle.name},
  closeOnSelect: $_closeOnSelect,
  selectedValue: ${playDartString(_selected)},
  onSelected: (Object? value) {},
  anchorBuilder: (BuildContext context, VoidCallback open) {
    return M3EButton.icon(
      style: M3EButtonStyle.tonal,
      icon: const Icon(M3EIcons.more_vert),
      label: Text(${playDartString(_selected)}),
      onPressed: open,
    );
  },
  children: <M3EMenuNode>[
    M3EMenuSelectable(
      label: 'Inbox',
      value: 'Inbox',
      selected: ${_isSelected('Inbox')},
    ),
    M3EMenuToggleable(
      label: 'Starred',
      checked: $_starred,
      onChanged: (bool value) {},
    ),
  ],
);''';
    return <PlaySnippet>[
      PlaySnippet(label: 'Anchored menu', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Anchored menu',
          child: M3EMenu(
            position: _position,
            colorStyle: _colorStyle,
            variant: _variant,
            selectionMode: _selectionMode,
            closeOnSelect: _closeOnSelect,
            selectedValue: _selected,
            onSelected: _onSelected,
            anchorBuilder: (BuildContext context, VoidCallback open) {
              return M3EButton.icon(
                style: M3EButtonStyle.tonal,
                icon: const Icon(M3EIcons.more_vert),
                label: Text(_isMulti ? _multi.join(', ') : _selected),
                onPressed: open,
              );
            },
            children: _children,
          ),
        ),
        PlayPreviewCard(
          label: 'Baseline',
          child: M3EMenu(
            variant: M3EMenuVariant.baseline,
            anchorBuilder: (BuildContext context, VoidCallback open) {
              return M3EButton.tonal(
                onPressed: open,
                child: const Text('Baseline'),
              );
            },
            children: const <M3EMenuNode>[
              M3EMenuEntry(
                label: 'Cut',
                leading: Icon(M3EIcons.content_cut),
                trailingText: '⌘X',
              ),
              M3EMenuEntry(
                label: 'Copy',
                leading: Icon(M3EIcons.content_copy),
                trailingText: '⌘C',
              ),
              M3EMenuDivider(),
              M3EMenuEntry(
                label: 'Paste',
                leading: Icon(M3EIcons.content_paste),
                trailingText: '⌘V',
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
            PlayEnumMenu<M3EMenuVariant>(
              label: 'Variant',
              value: _variant,
              values: M3EMenuVariant.values,
              labelOf: (M3EMenuVariant v) => v.name,
              onChanged: (M3EMenuVariant v) => setState(() => _variant = v),
            ),
            PlayEnumSegmented<M3EMenuColorStyle>(
              label: 'Color',
              value: _colorStyle,
              values: M3EMenuColorStyle.values,
              labelOf: (M3EMenuColorStyle v) => v.name,
              onChanged: (M3EMenuColorStyle v) {
                setState(() => _colorStyle = v);
              },
            ),
            PlayEnumMenu<M3EMenuAnchorPosition>(
              label: 'Position',
              value: _position,
              values: const <M3EMenuAnchorPosition>[
                M3EMenuAnchorPosition.bottomStart,
                M3EMenuAnchorPosition.bottomEnd,
                M3EMenuAnchorPosition.topStart,
                M3EMenuAnchorPosition.topEnd,
              ],
              labelOf: (M3EMenuAnchorPosition v) => v.name,
              onChanged: (M3EMenuAnchorPosition v) {
                setState(() => _position = v);
              },
            ),
            PlayEnumSegmented<M3EMenuSelectionMode>(
              label: 'Selection',
              value: _selectionMode,
              values: M3EMenuSelectionMode.values,
              labelOf: (M3EMenuSelectionMode v) => v.name,
              onChanged: (M3EMenuSelectionMode v) {
                setState(() => _selectionMode = v);
              },
            ),
            PlaySwitch(
              label: 'Close on select',
              value: _closeOnSelect,
              onChanged: (bool v) => setState(() => _closeOnSelect = v),
            ),
          ],
        ),
      ],
    );
  }
}
