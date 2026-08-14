import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/floating_action_buttons/enums/m3e_fab.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EFab] and [M3EExtendedFab].
class FabsPlayground extends StatefulWidget {
  /// Creates the FABs playground.
  const FabsPlayground({super.key});

  @override
  State<FabsPlayground> createState() => _FabsPlaygroundState();
}

class _FabsPlaygroundState extends State<FabsPlayground> {
  M3EFabSize _size = M3EFabSize.medium;
  M3EFabColor _color = M3EFabColor.primary;
  bool _extended = true;
  String _label = 'Compose';

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'FAB',
          child: M3EFab(
            onPressed: () {},
            icon: const Icon(M3EIcons.add),
            size: _size,
            color: _color,
            tooltip: 'Add',
          ),
        ),
        PlayPreviewCard(
          label: 'Extended FAB',
          child: M3EExtendedFab(
            onPressed: () {},
            icon: const Icon(M3EIcons.edit),
            label: _label,
            extended: _extended,
            color: _color,
          ),
        ),
        PlayPreviewCard(
          label: 'Gradient fill',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              M3EFab(
                onPressed: () {},
                icon: const Icon(M3EIcons.add),
                size: _size,
                decoration: M3EFabDecoration(
                  backgroundGradient: WidgetStateProperty.all(
                    const LinearGradient(
                      colors: <Color>[Color(0xFF006A6A), Color(0xFF4ECDC4)],
                    ),
                  ),
                ),
                tooltip: 'Add',
              ),
              M3EExtendedFab(
                onPressed: () {},
                icon: const Icon(M3EIcons.edit),
                label: _label,
                extended: _extended,
                decoration: M3EFabDecoration(
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
                ),
              ),
            ],
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'FAB',
          children: <Widget>[
            PlayEnumSegmented<M3EFabSize>(
              label: 'Size',
              value: _size,
              values: M3EFabSize.values,
              labelOf: (M3EFabSize v) => v.name,
              onChanged: (M3EFabSize v) => setState(() => _size = v),
            ),
            PlayEnumSegmented<M3EFabColor>(
              label: 'Color',
              value: _color,
              values: M3EFabColor.values,
              labelOf: (M3EFabColor v) => v.name,
              onChanged: (M3EFabColor v) => setState(() => _color = v),
            ),
          ],
        ),
        PlayControlPanel(
          title: 'Extended FAB',
          children: <Widget>[
            PlaySwitch(
              label: 'Extended',
              value: _extended,
              onChanged: (bool v) => setState(() => _extended = v),
            ),
            PlayTextField(
              label: 'Label',
              value: _label,
              onChanged: (String v) => setState(() => _label = v),
            ),
          ],
        ),
      ],
    );
  }
}
