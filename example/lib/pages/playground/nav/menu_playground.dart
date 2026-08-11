import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
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
  bool _closeOnSelect = true;
  String _selected = 'Inbox';
  bool _starred = true;

  List<M3EMenuNode> get _children {
    return <M3EMenuNode>[
      M3EMenuGroup(
        label: 'Mailbox',
        children: <M3EMenuNode>[
          M3EMenuSelectable(
            label: 'Inbox',
            value: 'Inbox',
            selected: _selected == 'Inbox',
            leading: const Icon(M3EIcons.inbox),
          ),
          M3EMenuSelectable(
            label: 'Sent',
            value: 'Sent',
            selected: _selected == 'Sent',
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

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Anchored menu',
          child: M3EMenu(
            position: _position,
            colorStyle: _colorStyle,
            closeOnSelect: _closeOnSelect,
            selectedValue: _selected,
            onSelected: (Object? value) {
              if (value is String) {
                setState(() => _selected = value);
              }
            },
            anchorBuilder: (BuildContext context, VoidCallback open) {
              return M3EButton.icon(
                style: M3EButtonStyle.tonal,
                icon: const Icon(M3EIcons.more_vert),
                label: Text(_selected),
                onPressed: open,
              );
            },
            children: _children,
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
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
