import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/components/split_buttons/enums/m3e_split_button_menu_style.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ESplitButton].
class SplitButtonPlayground extends StatefulWidget {
  /// Creates the split button playground.
  const SplitButtonPlayground({super.key});

  @override
  State<SplitButtonPlayground> createState() => _SplitButtonPlaygroundState();
}

class _SplitButtonPlaygroundState extends State<SplitButtonPlayground> {
  M3EButtonStyle _style = M3EButtonStyle.filled;
  M3EButtonSize _size = M3EButtonSize.sm;
  M3EButtonShape _shape = M3EButtonShape.round;
  M3ESplitButtonMenuStyle _menuStyle = M3ESplitButtonMenuStyle.popup;
  bool _enabled = true;
  String _label = 'Save';
  String? _selected;

  static const List<M3EButtonSize> _sizes = <M3EButtonSize>[
    M3EButtonSize.xs,
    M3EButtonSize.sm,
    M3EButtonSize.md,
  ];

  static const List<M3EButtonStyle> _styles = <M3EButtonStyle>[
    M3EButtonStyle.filled,
    M3EButtonStyle.tonal,
    M3EButtonStyle.elevated,
    M3EButtonStyle.outlined,
  ];

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Split button',
          child: M3ESplitButton<String>(
            label: _label,
            leadingIcon: M3EIcons.save,
            style: _style,
            size: _size,
            shape: _shape,
            enabled: _enabled,
            selectedValue: _selected,
            decoration: M3ESplitButtonDecoration(menuStyle: _menuStyle),
            onPressed: _enabled ? () {} : null,
            onSelected: _enabled
                ? (String value) => setState(() => _selected = value)
                : null,
            items: const <M3ESplitButtonItem<String>>[
              M3ESplitButtonItem<String>(
                value: 'draft',
                child: Text('Save draft'),
              ),
              M3ESplitButtonItem<String>(
                value: 'copy',
                child: Text('Save a copy'),
              ),
            ],
          ),
        ),
        PlayPreviewCard(
          label: 'Custom M3E menu',
          child: M3ESplitButton<String>(
            label: 'Share',
            leadingIcon: M3EIcons.share,
            style: _style,
            size: _size,
            shape: _shape,
            enabled: _enabled,
            items: null,
            onPressed: _enabled ? () {} : null,
            m3eMenuBuilder: (BuildContext context) {
              return <M3EMenuNode>[
                const M3EMenuEntry(
                  label: 'Email',
                  leading: Icon(M3EIcons.mail),
                  value: 'email',
                ),
                M3EMenuSubmenu(
                  label: 'More',
                  children: const <M3EMenuNode>[
                    M3EMenuEntry(label: 'Message', value: 'message'),
                    M3EMenuEntry(label: 'QR code', value: 'qr'),
                  ],
                ),
              ];
            },
            onSelected: _enabled
                ? (String value) => setState(() => _selected = value)
                : null,
          ),
        ),
        PlayPreviewCard(
          label: 'Gradient fill',
          child: M3ESplitButton<String>(
            label: 'Save',
            leadingIcon: M3EIcons.save,
            style: M3EButtonStyle.filled,
            size: _size,
            shape: _shape,
            enabled: _enabled,
            decoration: M3ESplitButtonDecoration(
              menuStyle: _menuStyle,
              backgroundGradient: WidgetStateProperty.all(
                const LinearGradient(
                  colors: <Color>[Color(0xFF6750A4), Color(0xFF9A82DB)],
                ),
              ),
              foregroundGradient: WidgetStateProperty.all(
                const LinearGradient(
                  colors: <Color>[Color(0xFFFFFFFF), Color(0xFFEADDFF)],
                ),
              ),
              outlineGradient: WidgetStateProperty.all(
                const LinearGradient(
                  colors: <Color>[Color(0xFF4F378B), Color(0xFFD0BCFF)],
                ),
              ),
            ),
            onPressed: _enabled ? () {} : null,
            onSelected: _enabled
                ? (String value) => setState(() => _selected = value)
                : null,
            items: const <M3ESplitButtonItem<String>>[
              M3ESplitButtonItem<String>(
                value: 'draft',
                child: Text('Save draft'),
              ),
              M3ESplitButtonItem<String>(
                value: 'copy',
                child: Text('Save a copy'),
              ),
            ],
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumMenu<M3EButtonStyle>(
              label: 'Style',
              value: _style,
              values: _styles,
              labelOf: (M3EButtonStyle v) => v.name,
              onChanged: (M3EButtonStyle v) => setState(() => _style = v),
            ),
            PlayEnumMenu<M3EButtonSize>(
              label: 'Size',
              value: _size,
              values: _sizes,
              labelOf: (M3EButtonSize v) => v.name,
              onChanged: (M3EButtonSize v) => setState(() => _size = v),
            ),
            PlayEnumSegmented<M3EButtonShape>(
              label: 'Shape',
              value: _shape,
              values: M3EButtonShape.values,
              labelOf: (M3EButtonShape v) => v.name,
              onChanged: (M3EButtonShape v) => setState(() => _shape = v),
            ),
            PlayEnumMenu<M3ESplitButtonMenuStyle>(
              label: 'Menu style',
              value: _menuStyle,
              values: M3ESplitButtonMenuStyle.values,
              labelOf: (M3ESplitButtonMenuStyle v) => v.name,
              onChanged: (M3ESplitButtonMenuStyle v) {
                setState(() => _menuStyle = v);
              },
            ),
          ],
        ),
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlayTextField(
              label: 'Label',
              value: _label,
              onChanged: (String v) => setState(() => _label = v),
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
