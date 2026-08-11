import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/floating_action_buttons/enums/m3e_fab.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EFabMenu].
class FabMenuPlayground extends StatefulWidget {
  /// Creates the FAB menu playground.
  const FabMenuPlayground({super.key});

  @override
  State<FabMenuPlayground> createState() => _FabMenuPlaygroundState();
}

class _FabMenuPlaygroundState extends State<FabMenuPlayground> {
  M3EFabMenuPosition _position = M3EFabMenuPosition.right;
  M3EFabSize _size = M3EFabSize.medium;
  M3EFabColor _color = M3EFabColor.primary;

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'FAB menu',
          child: SizedBox(
            height: 280,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: M3EFabMenu(
                position: _position,
                size: _size,
                color: _color,
                items: <M3EFabMenuItem>[
                  M3EFabMenuItem(
                    icon: const Icon(M3EIcons.image),
                    label: 'Image',
                    onPressed: () {},
                  ),
                  M3EFabMenuItem(
                    icon: const Icon(M3EIcons.videocam),
                    label: 'Video',
                    onPressed: () {},
                  ),
                  M3EFabMenuItem(
                    icon: const Icon(M3EIcons.mic),
                    label: 'Audio',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumSegmented<M3EFabMenuPosition>(
              label: 'Position',
              value: _position,
              values: M3EFabMenuPosition.values,
              labelOf: (M3EFabMenuPosition v) => v.name,
              onChanged: (M3EFabMenuPosition v) {
                setState(() => _position = v);
              },
            ),
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
      ],
    );
  }
}
