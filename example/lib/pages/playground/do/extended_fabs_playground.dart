import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EExtendedFab].
class ExtendedFabsPlayground extends StatefulWidget {
  /// Creates the extended FABs playground.
  const ExtendedFabsPlayground({super.key});

  @override
  State<ExtendedFabsPlayground> createState() => _ExtendedFabsPlaygroundState();
}

class _ExtendedFabsPlaygroundState extends State<ExtendedFabsPlayground> {
  M3EFabColor _color = M3EFabColor.primary;
  bool _extended = true;
  bool _enabled = true;
  bool _gradient = false;
  String _label = 'Compose';

  List<PlaySnippet> get _snippets {
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Extended FAB',
        code:
            '''
$kPlaySnippetImport
M3EExtendedFab(
  onPressed: ${_enabled ? '() {}' : 'null'},
  icon: const Icon(M3EIcons.edit),
  label: ${playDartString(_label)},
  extended: $_extended,
  color: M3EFabColor.${_color.name},
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Extended FAB',
          child: M3EExtendedFab(
            onPressed: _enabled ? () {} : null,
            icon: const Icon(M3EIcons.edit),
            label: _label,
            extended: _extended,
            color: _color,
            decoration: _gradient
                ? M3EFabDecoration(
                    backgroundGradient: WidgetStateProperty.all(
                      const LinearGradient(
                        colors: <Color>[Color(0xFF006A6A), Color(0xFF4ECDC4)],
                      ),
                    ),
                    outlineGradient: WidgetStateProperty.all(
                      const LinearGradient(
                        colors: <Color>[Color(0xFF003F3F), Color(0xFF99F6E4)],
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Extended FAB',
          children: <Widget>[
            PlayEnumMenu<M3EFabColor>(
              label: 'Color',
              value: _color,
              values: M3EFabColor.values,
              labelOf: (M3EFabColor v) => v.name,
              onChanged: (M3EFabColor v) => setState(() => _color = v),
            ),
            PlayTextField(
              label: 'Label',
              value: _label,
              onChanged: (String v) => setState(() => _label = v),
            ),
            PlaySwitch(
              label: 'Extended',
              value: _extended,
              onChanged: (bool v) => setState(() => _extended = v),
            ),
            PlaySwitch(
              label: 'Enabled',
              value: _enabled,
              onChanged: (bool v) => setState(() => _enabled = v),
            ),
            PlaySwitch(
              label: 'Gradient fill',
              value: _gradient,
              onChanged: (bool v) => setState(() => _gradient = v),
            ),
          ],
        ),
      ],
    );
  }
}
