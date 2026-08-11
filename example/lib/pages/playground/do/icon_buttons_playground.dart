import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EIconButton].
class IconButtonsPlayground extends StatefulWidget {
  /// Creates the icon buttons playground.
  const IconButtonsPlayground({super.key});

  @override
  State<IconButtonsPlayground> createState() => _IconButtonsPlaygroundState();
}

class _IconButtonsPlaygroundState extends State<IconButtonsPlayground> {
  M3EIconButtonVariant _variant = M3EIconButtonVariant.standard;
  M3EIconButtonSize _size = M3EIconButtonSize.sm;
  M3EIconButtonShapeVariant _shape = M3EIconButtonShapeVariant.round;
  M3EIconButtonWidth _width = M3EIconButtonWidth.defaultWidth;
  bool _enabled = true;
  bool _selected = false;
  bool _badge = false;

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Icon button',
          child: M3EIconButton(
            icon: const Icon(M3EIcons.favorite),
            selectedIcon: const Icon(M3EIcons.favorite),
            onPressed: _enabled ? () {} : null,
            variant: _variant,
            size: _size,
            shape: _shape,
            width: _width,
            isSelected: _selected,
            badgeValue: _badge ? 3 : null,
            tooltip: 'Favorite',
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumMenu<M3EIconButtonVariant>(
              label: 'Variant',
              value: _variant,
              values: M3EIconButtonVariant.values,
              labelOf: (M3EIconButtonVariant v) => v.name,
              onChanged: (M3EIconButtonVariant v) {
                setState(() => _variant = v);
              },
            ),
            PlayEnumMenu<M3EIconButtonSize>(
              label: 'Size',
              value: _size,
              values: M3EIconButtonSize.values,
              labelOf: (M3EIconButtonSize v) => v.name,
              onChanged: (M3EIconButtonSize v) => setState(() => _size = v),
            ),
            PlayEnumSegmented<M3EIconButtonShapeVariant>(
              label: 'Shape',
              value: _shape,
              values: M3EIconButtonShapeVariant.values,
              labelOf: (M3EIconButtonShapeVariant v) => v.name,
              onChanged: (M3EIconButtonShapeVariant v) {
                setState(() => _shape = v);
              },
            ),
            PlayEnumMenu<M3EIconButtonWidth>(
              label: 'Width',
              value: _width,
              values: M3EIconButtonWidth.values,
              labelOf: (M3EIconButtonWidth v) => v.name,
              onChanged: (M3EIconButtonWidth v) {
                setState(() => _width = v);
              },
            ),
          ],
        ),
        PlayControlPanel(
          title: 'State',
          children: <Widget>[
            PlaySwitch(
              label: 'Enabled',
              value: _enabled,
              onChanged: (bool v) => setState(() => _enabled = v),
            ),
            PlaySwitch(
              label: 'Selected',
              value: _selected,
              onChanged: (bool v) => setState(() => _selected = v),
            ),
            PlaySwitch(
              label: 'Badge',
              value: _badge,
              onChanged: (bool v) => setState(() => _badge = v),
            ),
          ],
        ),
      ],
    );
  }
}
