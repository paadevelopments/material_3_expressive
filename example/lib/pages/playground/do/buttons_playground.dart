import 'package:flutter/material.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EButton] variants.
class ButtonsPlayground extends StatefulWidget {
  /// Creates the buttons playground.
  const ButtonsPlayground({super.key});

  @override
  State<ButtonsPlayground> createState() => _ButtonsPlaygroundState();
}

class _ButtonsPlaygroundState extends State<ButtonsPlayground> {
  M3EButtonStyle _style = M3EButtonStyle.filled;
  M3EButtonSize _size = M3EButtonSize.sm;
  M3EButtonShape _shape = M3EButtonShape.round;
  bool _enabled = true;
  bool _showIcon = true;
  String _label = 'Label';

  static const List<M3EButtonSize> _sizes = <M3EButtonSize>[
    M3EButtonSize.xs,
    M3EButtonSize.sm,
    M3EButtonSize.md,
    M3EButtonSize.lg,
    M3EButtonSize.xl,
  ];

  VoidCallback? get _onPressed => _enabled ? () {} : null;

  M3EButton _buildStyled() {
    if (_showIcon) {
      return M3EButton.icon(
        onPressed: _onPressed,
        icon: const Icon(M3EIcons.add),
        label: Text(_label),
        style: _style,
        size: _size,
        shape: _shape,
      );
    }
    return switch (_style) {
      M3EButtonStyle.filled => M3EButton.filled(
        onPressed: _onPressed,
        size: _size,
        shape: _shape,
        child: Text(_label),
      ),
      M3EButtonStyle.tonal => M3EButton.tonal(
        onPressed: _onPressed,
        size: _size,
        shape: _shape,
        child: Text(_label),
      ),
      M3EButtonStyle.elevated => M3EButton.elevated(
        onPressed: _onPressed,
        size: _size,
        shape: _shape,
        child: Text(_label),
      ),
      M3EButtonStyle.outlined => M3EButton.outlined(
        onPressed: _onPressed,
        size: _size,
        shape: _shape,
        child: Text(_label),
      ),
      M3EButtonStyle.text => M3EButton.text(
        onPressed: _onPressed,
        size: _size,
        shape: _shape,
        child: Text(_label),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Selected style',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[_buildStyled()],
          ),
        ),
        PlayPreviewCard(
          label: 'All styles',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              for (final M3EButtonStyle style in M3EButtonStyle.values)
                M3EButton(
                  onPressed: _onPressed,
                  style: style,
                  size: _size,
                  shape: _shape,
                  child: Text(style.name),
                ),
            ],
          ),
        ),
        PlayPreviewCard(
          label: 'Gradient fill',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              M3EButton(
                decoration: M3EButtonDecoration(
                  foregroundColor: WidgetStateProperty.all(
                    Colors.white,
                  ),
                  backgroundGradient: WidgetStateProperty.all(
                    const LinearGradient(
                      colors: <Color>[Color(0xFF6750A4), Color(0xFF9A82DB)],
                    ),
                  ),
                ),
                onPressed: _onPressed,
                size: _size,
                shape: _shape,
                child: const Text('Gradient'),
              ),
              M3EButton.icon(
                decoration: M3EButtonDecoration(
                  foregroundColor: WidgetStateProperty.all(
                    Colors.white,
                  ),
                  backgroundGradient: WidgetStateProperty.all(
                    const LinearGradient(
                      colors: <Color>[Color(0xFFB3261E), Color(0xFFE46962)],
                    ),
                  ),
                ),
                onPressed: _onPressed,
                icon: const Icon(M3EIcons.favorite),
                label: const Text('Favorite'),
                size: _size,
                shape: _shape,
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
              values: M3EButtonStyle.values,
              labelOf: (M3EButtonStyle v) => v.name,
              onChanged: (M3EButtonStyle v) => setState(() => _style = v),
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
              label: 'Show icon',
              value: _showIcon,
              onChanged: (bool v) => setState(() => _showIcon = v),
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
