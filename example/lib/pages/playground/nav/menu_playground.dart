import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3EMenu].
class MenuPlayground extends PlaygroundWidget {
  /// Creates the menu playground.
  const MenuPlayground({super.key});

  @override
  PlaygroundState<MenuPlayground> createState() => _MenuPlaygroundState();
}

class _MenuPlaygroundState extends PlaygroundState<MenuPlayground> {
  M3EMenuColorStyle _colorStyle = M3EMenuColorStyle.standard;
  M3EMenuAnchorPosition _position = M3EMenuAnchorPosition.bottomStart;
  M3EMenuVariant _variant = M3EMenuVariant.vertical;
  M3EMenuSelectionMode _selectionMode = M3EMenuSelectionMode.single;
  bool _closeOnSelect = true;
  bool _leadingIcons = true;
  bool _groupLabels = true;
  bool _toggleable = true;
  bool _submenu = true;
  bool _shortcuts = false;
  String _selected = 'Inbox';
  final Set<String> _multi = <String>{'Inbox'};
  bool _starred = true;

  static const List<(String, IconData, String)> _boxes =
      <(String, IconData, String)>[
        ('Inbox', M3EIcons.inbox, '⌘1'),
        ('Sent', M3EIcons.send, '⌘2'),
        ('Drafts', M3EIcons.drafts, '⌘3'),
      ];

  bool get _isMulti => _selectionMode == M3EMenuSelectionMode.multi;

  bool _isSelected(String value) =>
      _isMulti ? _multi.contains(value) : _selected == value;

  List<M3EMenuNode> get _children {
    return <M3EMenuNode>[
      M3EMenuGroup(
        label: _groupLabels ? 'Mailbox' : null,
        children: <M3EMenuNode>[
          for (final (String label, IconData icon, String shortcut) in _boxes)
            M3EMenuSelectable(
              label: label,
              value: label,
              selected: _isSelected(label),
              leading: _leadingIcons ? Icon(icon) : null,
              trailingText: _shortcuts ? shortcut : null,
            ),
        ],
      ),
      if (_toggleable || _submenu)
        M3EMenuGroup(
          label: _groupLabels ? 'Options' : null,
          children: <M3EMenuNode>[
            if (_toggleable)
              M3EMenuToggleable(
                label: 'Starred',
                checked: _starred,
                onChanged: (bool value) => setState(() => _starred = value),
              ),
            if (_submenu)
              M3EMenuSubmenu(
                label: 'More actions',
                leading: _leadingIcons ? const Icon(M3EIcons.more_horiz) : null,
                children: <M3EMenuNode>[
                  M3EMenuEntry(
                    label: 'Archive',
                    leading: _leadingIcons
                        ? const Icon(M3EIcons.archive)
                        : null,
                    onPressed: () {},
                  ),
                  M3EMenuEntry(
                    label: 'Report',
                    leading: _leadingIcons ? const Icon(M3EIcons.report) : null,
                    onPressed: () {},
                  ),
                ],
              ),
          ],
        ),
    ];
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

  @override
  Widget buildPreview(BuildContext context) {
    return M3EMenu(
      position: _position,
      colorStyle: _colorStyle,
      variant: _variant,
      selectionMode: _selectionMode,
      closeOnSelect: _closeOnSelect,
      selectedValue: _isMulti ? null : _selected,
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
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final String leading = _leadingIcons
        ? '\n      leading: const Icon(M3EIcons.inbox),'
        : '';
    final String shortcut = _shortcuts ? "\n      trailingText: '⌘1'," : '';
    final String group = _groupLabels ? "\n    label: 'Mailbox'," : '';
    final String close = _isMulti ? '' : '\n  closeOnSelect: $_closeOnSelect,';
    final String toggle = _toggleable
        ? '''

  M3EMenuToggleable(
    label: 'Starred',
    checked: $_starred,
    onChanged: (bool value) {},
  ),'''
        : '';
    final String submenu = _submenu
        ? '''

  M3EMenuSubmenu(
    label: 'More actions',
    children: <M3EMenuNode>[
      M3EMenuEntry(label: 'Archive', onPressed: () {}),
    ],
  ),'''
        : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Anchored menu',
        code:
            '''
$kPlaySnippetImport

M3EMenu(
  variant: M3EMenuVariant.${_variant.name},
  colorStyle: M3EMenuColorStyle.${_colorStyle.name},
  position: M3EMenuAnchorPosition.${_position.name},
  selectionMode: M3EMenuSelectionMode.${_selectionMode.name},$close
  onSelected: (Object? value) {},
  anchorBuilder: (BuildContext context, VoidCallback open) {
    return M3EButton.tonal(onPressed: open, child: const Text('Menu'));
  },
  children: <M3EMenuNode>[
    M3EMenuGroup($group
      children: <M3EMenuNode>[
        M3EMenuSelectable(
          label: 'Inbox',
          value: 'Inbox',
          selected: ${_isSelected('Inbox')},$leading$shortcut
        ),
      ],
    ),$toggle$submenu
  ],
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
          PlayEnumChoice<M3EMenuVariant>(
            label: 'Variant',
            value: _variant,
            values: M3EMenuVariant.values,
            labelOf: (M3EMenuVariant v) => v.name,
            onChanged: (M3EMenuVariant v) => setState(() => _variant = v),
          ),
          PlayEnumChoice<M3EMenuColorStyle>(
            label: 'Color',
            value: _colorStyle,
            values: M3EMenuColorStyle.values,
            labelOf: (M3EMenuColorStyle v) => v.name,
            onChanged: (M3EMenuColorStyle v) => setState(() => _colorStyle = v),
          ),
          PlayEnumChoice<M3EMenuAnchorPosition>(
            label: 'Position',
            value: _position,
            values: M3EMenuAnchorPosition.values,
            labelOf: (M3EMenuAnchorPosition v) => v.name,
            onChanged: (M3EMenuAnchorPosition v) {
              setState(() => _position = v);
            },
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Leading icons',
            value: _leadingIcons,
            onChanged: (bool v) => setState(() => _leadingIcons = v),
          ),
          PlaySwitchItem(
            label: 'Shortcut text',
            description: 'Trailing text on the mailbox items',
            value: _shortcuts,
            onChanged: (bool v) => setState(() => _shortcuts = v),
          ),
          PlaySwitchItem(
            label: 'Group labels',
            value: _groupLabels,
            onChanged: (bool v) => setState(() => _groupLabels = v),
          ),
          PlaySwitchItem(
            label: 'Toggle item',
            description: 'A checkable Starred item',
            value: _toggleable,
            onChanged: (bool v) => setState(() => _toggleable = v),
          ),
          PlaySwitchItem(
            label: 'Submenu',
            value: _submenu,
            onChanged: (bool v) => setState(() => _submenu = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Selection',
        children: <Widget>[
          PlayEnumChoice<M3EMenuSelectionMode>(
            label: 'Mode',
            value: _selectionMode,
            values: M3EMenuSelectionMode.values,
            labelOf: (M3EMenuSelectionMode v) => v.name,
            onChanged: (M3EMenuSelectionMode v) {
              setState(() => _selectionMode = v);
            },
          ),
          if (!_isMulti)
            PlaySwitchItem(
              label: 'Close on select',
              description: 'Multi-select always stays open',
              value: _closeOnSelect,
              onChanged: (bool v) => setState(() => _closeOnSelect = v),
            ),
        ],
      ),
    ];
  }
}
