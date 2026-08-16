import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

enum _SliderKind { continuous, wavy, centered, discrete, vertical, range }

/// Live playground for [M3ESlider] and [M3ERangeSlider].
class SlidersPlayground extends StatefulWidget {
  /// Creates the sliders playground.
  const SlidersPlayground({super.key});

  @override
  State<SlidersPlayground> createState() => _SlidersPlaygroundState();
}

class _SlidersPlaygroundState extends State<SlidersPlayground> {
  _SliderKind _kind = _SliderKind.continuous;
  double _value = 0.45;
  M3ESliderRange _range = const M3ESliderRange(0.2, 0.7);
  bool _enabled = true;
  double _trackThickness = 16;
  M3ESliderIconPosition _iconPosition = M3ESliderIconPosition.end;

  String _num(double value) {
    return value == value.roundToDouble() ? '${value.toInt()}' : '$value';
  }

  List<PlaySnippet> get _snippets {
    final String thickness = _num(_trackThickness);
    final String sample = switch (_kind) {
      _SliderKind.continuous =>
        '''
M3ESlider(
  value: ${_num(_value)},
  enabled: $_enabled,
  trackThickness: $thickness,
  onChanged: (double v) {},
);''',
      _SliderKind.wavy =>
        '''
M3ESlider.wavy(
  value: ${_num(_value)},
  enabled: $_enabled,
  trackThickness: $thickness,
  onChanged: (double v) {},
);''',
      _SliderKind.centered =>
        '''
M3ESlider.centered(
  value: ${_num((_value * 200) - 100)},
  min: -100,
  max: 100,
  enabled: $_enabled,
  trackThickness: $thickness,
  onChanged: (double v) {},
);''',
      _SliderKind.discrete =>
        '''
M3ESlider(
  value: ${_num((_value * 5).roundToDouble())},
  max: 5,
  divisions: 5,
  enabled: $_enabled,
  trackThickness: $thickness,
  haptic: M3EHapticFeedback.light,
  onChanged: (double v) {},
);''',
      _SliderKind.vertical =>
        '''
M3ESlider.vertical(
  value: ${_num(_value)},
  enabled: $_enabled,
  trackThickness: $thickness,
  thumbLength: 80,
  icon: const Icon(M3EIcons.volume_up),
  iconPosition: M3ESliderIconPosition.${_iconPosition.name},
  onChanged: (double v) {},
);''',
      _SliderKind.range =>
        '''
M3ERangeSlider(
  values: M3ESliderRange(${_num(_range.start)}, ${_num(_range.end)}),
  enabled: $_enabled,
  trackThickness: $thickness,
  onChanged: (M3ESliderRange v) {},
);''',
    };
    return <PlaySnippet>[
      PlaySnippet(label: 'Slider', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Slider',
          child: _kind == _SliderKind.vertical
              ? SizedBox(height: 180, width: 80, child: _buildPreview())
              : SizedBox(width: 280, child: _buildPreview()),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumMenu<_SliderKind>(
              label: 'Kind',
              value: _kind,
              values: _SliderKind.values,
              labelOf: (_SliderKind v) => v.name,
              onChanged: (_SliderKind v) => setState(() => _kind = v),
            ),
            PlaySlider(
              label: 'Track thickness',
              value: _trackThickness,
              min: 8,
              max: 40,
              divisions: 16,
              onChanged: (double v) => setState(() => _trackThickness = v),
            ),
            if (_kind == _SliderKind.vertical)
              PlayEnumMenu<M3ESliderIconPosition>(
                label: 'Icon position',
                value: _iconPosition,
                values: M3ESliderIconPosition.values,
                labelOf: (M3ESliderIconPosition v) => v.name,
                onChanged: (M3ESliderIconPosition v) {
                  setState(() => _iconPosition = v);
                },
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

  Widget _buildPreview() {
    final ValueChanged<double>? onChanged = _enabled
        ? (double v) => setState(() => _value = v)
        : null;
    final ValueChanged<M3ESliderRange>? onRangeChanged = _enabled
        ? (M3ESliderRange v) => setState(() => _range = v)
        : null;

    return switch (_kind) {
      _SliderKind.continuous => M3ESlider(
        value: _value,
        enabled: _enabled,
        trackThickness: _trackThickness,
        onChanged: onChanged ?? (_) {},
      ),
      _SliderKind.wavy => M3ESlider.wavy(
        value: _value,
        enabled: _enabled,
        trackThickness: _trackThickness,
        onChanged: onChanged ?? (_) {},
      ),
      _SliderKind.centered => M3ESlider.centered(
        value: (_value * 200) - 100,
        min: -100,
        max: 100,
        enabled: _enabled,
        trackThickness: _trackThickness,
        onChanged: _enabled
            ? (double v) => setState(() => _value = (v + 100) / 200)
            : (_) {},
      ),
      _SliderKind.discrete => M3ESlider(
        value: (_value * 5).roundToDouble(),
        max: 5,
        divisions: 5,
        enabled: _enabled,
        trackThickness: _trackThickness,
        haptic: M3EHapticFeedback.light,
        onChanged: _enabled
            ? (double v) => setState(() => _value = v / 5)
            : (_) {},
      ),
      _SliderKind.vertical => M3ESlider.vertical(
        value: _value,
        enabled: _enabled,
        trackThickness: _trackThickness,
        thumbLength: 80,
        icon: const Icon(M3EIcons.volume_up),
        iconPosition: _iconPosition,
        onChanged: onChanged ?? (_) {},
      ),
      _SliderKind.range => M3ERangeSlider(
        values: _range,
        enabled: _enabled,
        trackThickness: _trackThickness,
        onChanged: onRangeChanged ?? (_) {},
      ),
    };
  }
}
