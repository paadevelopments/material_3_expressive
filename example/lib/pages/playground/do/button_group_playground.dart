import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EButtonGroup] and [M3EToggleButton].
class ButtonGroupPlayground extends StatefulWidget {
  /// Creates the button group playground.
  const ButtonGroupPlayground({super.key});

  @override
  State<ButtonGroupPlayground> createState() => _ButtonGroupPlaygroundState();
}

class _ButtonGroupPlaygroundState extends State<ButtonGroupPlayground> {
  M3EButtonGroupType _type = M3EButtonGroupType.standard;
  M3EButtonShape _shape = M3EButtonShape.round;
  M3EButtonSize _size = M3EButtonSize.sm;
  M3EButtonStyle _style = M3EButtonStyle.filled;
  bool _neighborSquish = true;
  int _selectedIndex = 0;
  bool _toggleChecked = false;

  static const List<M3EButtonSize> _sizes = <M3EButtonSize>[
    M3EButtonSize.xs,
    M3EButtonSize.sm,
    M3EButtonSize.md,
  ];

  List<PlaySnippet> get _snippets {
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Button group',
        code:
            '''
$kPlaySnippetImport
M3EButtonGroup(
  type: M3EButtonGroupType.${_type.name},
  shape: M3EButtonShape.${_shape.name},
  size: M3EButtonSize.${_size.name},
  style: M3EButtonStyle.${_style.name},
  neighborSquish: $_neighborSquish,
  selectedIndex: $_selectedIndex,
  onSelectedIndexChanged: (int? index) {},
  actions: const <M3EButtonGroupAction>[
    M3EButtonGroupAction(
      icon: Icon(M3EIcons.format_align_left),
      label: Text('Left'),
    ),
    M3EButtonGroupAction(
      icon: Icon(M3EIcons.format_align_center),
      label: Text('Center'),
    ),
    M3EButtonGroupAction(
      icon: Icon(M3EIcons.format_align_right),
      label: Text('Right'),
    ),
  ],
);''',
      ),
      PlaySnippet(
        label: 'Toggle button',
        code:
            '''
$kPlaySnippetImport
M3EToggleButton(
  checked: $_toggleChecked,
  onCheckedChange: (bool value) {},
  icon: const Icon(M3EIcons.star),
  checkedIcon: const Icon(M3EIcons.star),
  label: const Text('Star'),
  style: M3EButtonStyle.${_style.name},
  size: M3EButtonSize.${_size.name},
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Compact xs (scroll overflow)',
          child: SizedBox(
            height: 32,
            child: M3EButtonGroup(
              type: _type,
              shape: _shape,
              size: M3EButtonSize.xs,
              style: _style,
              density: M3EButtonGroupDensity.compact,
              spacing: 8,
              neighborSquish: _neighborSquish,
              selectedIndex: _selectedIndex,
              onSelectedIndexChanged: (int? index) {
                if (index != null) {
                  setState(() => _selectedIndex = index);
                }
              },
              actions: const <M3EButtonGroupAction>[
                M3EButtonGroupAction(label: Text('Every day')),
                M3EButtonGroupAction(label: Text('Days per week')),
                M3EButtonGroupAction(label: Text('Selected days')),
              ],
            ),
          ),
        ),
        PlayPreviewCard(
          label: 'Button group',
          child: M3EButtonGroup(
            type: _type,
            shape: _shape,
            size: _size,
            style: _style,
            neighborSquish: _neighborSquish,
            selectedIndex: _selectedIndex,
            onSelectedIndexChanged: (int? index) {
              if (index != null) {
                setState(() => _selectedIndex = index);
              }
            },
            actions: const <M3EButtonGroupAction>[
              M3EButtonGroupAction(
                icon: Icon(M3EIcons.format_align_left),
                label: Text('Left'),
              ),
              M3EButtonGroupAction(
                icon: Icon(M3EIcons.format_align_center),
                label: Text('Center'),
              ),
              M3EButtonGroupAction(
                icon: Icon(M3EIcons.format_align_right),
                label: Text('Right'),
              ),
            ],
          ),
        ),
        PlayPreviewCard(
          label: 'Toggle button',
          child: M3EToggleButton(
            checked: _toggleChecked,
            onCheckedChange: (bool value) {
              setState(() => _toggleChecked = value);
            },
            icon: const Icon(M3EIcons.star),
            checkedIcon: const Icon(M3EIcons.star),
            label: const Text('Star'),
            style: _style,
            size: _size,
          ),
        ),
        PlayPreviewCard(
          label: 'Toggle gradient fill',
          child: M3EToggleButton(
            checked: _toggleChecked,
            onCheckedChange: (bool value) {
              setState(() => _toggleChecked = value);
            },
            icon: const Icon(M3EIcons.favorite_border),
            checkedIcon: const Icon(M3EIcons.favorite),
            label: const Text('Favorite'),
            style: M3EButtonStyle.filled,
            size: _size,
            decoration: M3EToggleButtonDecoration(
              backgroundGradient: WidgetStateProperty.all(
                const LinearGradient(
                  colors: <Color>[Color(0xFFB3261E), Color(0xFFE46962)],
                ),
              ),
              foregroundGradient: WidgetStateProperty.all(
                const LinearGradient(
                  colors: <Color>[Color(0xFFFFFFFF), Color(0xFFFECACA)],
                ),
              ),
              outlineGradient: WidgetStateProperty.all(
                const LinearGradient(
                  colors: <Color>[Color(0xFF7F1D1D), Color(0xFFFECACA)],
                ),
              ),
            ),
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Group',
          children: <Widget>[
            PlayEnumSegmented<M3EButtonGroupType>(
              label: 'Type',
              value: _type,
              values: M3EButtonGroupType.values,
              labelOf: (M3EButtonGroupType v) => v.name,
              onChanged: (M3EButtonGroupType v) => setState(() => _type = v),
            ),
            PlayEnumSegmented<M3EButtonShape>(
              label: 'Shape',
              value: _shape,
              values: M3EButtonShape.values,
              labelOf: (M3EButtonShape v) => v.name,
              onChanged: (M3EButtonShape v) => setState(() => _shape = v),
            ),
            PlayEnumMenu<M3EButtonSize>(
              label: 'Size',
              value: _size,
              values: _sizes,
              labelOf: (M3EButtonSize v) => v.name,
              onChanged: (M3EButtonSize v) => setState(() => _size = v),
            ),
            PlayEnumMenu<M3EButtonStyle>(
              label: 'Style',
              value: _style,
              values: M3EButtonStyle.values,
              labelOf: (M3EButtonStyle v) => v.name,
              onChanged: (M3EButtonStyle v) => setState(() => _style = v),
            ),
            PlaySwitch(
              label: 'Neighbor squish',
              value: _neighborSquish,
              onChanged: (bool v) => setState(() => _neighborSquish = v),
            ),
          ],
        ),
      ],
    );
  }
}
