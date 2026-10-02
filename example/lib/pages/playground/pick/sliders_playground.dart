import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Single value or range.
enum _SliderType { single, range }

/// Live playground for [M3ESlider] and [M3ERangeSlider].
class SlidersPlayground extends PlaygroundWidget {
  /// Creates the sliders playground.
  const SlidersPlayground({super.key});

  @override
  PlaygroundState<SlidersPlayground> createState() => _SlidersPlaygroundState();
}

class _SlidersPlaygroundState extends PlaygroundState<SlidersPlayground> {
  _SliderType _type = _SliderType.single;
  Axis _axis = Axis.horizontal;
  M3ESliderTrackKind _track = M3ESliderTrackKind.standard;
  bool _wavy = false;
  M3ESliderSize _size = M3ESliderSize.xs;
  double _value = 0.45;
  M3ESliderRange _range = const M3ESliderRange(0.2, 0.7);
  bool _enabled = true;
  bool _stops = false;
  double _divisions = 10;
  M3EHapticFeedback _haptic = M3EHapticFeedback.none;
  bool _customLabel = false;
  String _labelText = 'Volume';
  double _wavelength = 40;
  double _amplitude = 1;
  bool _topToBottom = false;
  bool _icon = false;
  M3ESliderIconPosition _iconPosition = M3ESliderIconPosition.end;
  bool _trackIcons = false;
  bool _customGeometry = false;
  double _trackThickness = 16;
  double _thumbLength = 44;
  double _cornerRadius = 8;

  bool get _single => _type == _SliderType.single;

  bool get _vertical => _single && _axis == Axis.vertical;

  bool get _centered => _single && _track == M3ESliderTrackKind.centered;

  /// Wavy tracks are horizontal only.
  bool get _canWave => !_vertical;

  bool get _isWavy => _canWave && _wavy;

  /// The end icon exists on non-centered single sliders from size M up, and
  /// is exclusive with stops.
  bool get _canIcon =>
      _single && !_centered && !_stops && _size.index >= M3ESliderSize.m.index;

  bool get _hasIcon => _canIcon && _icon;

  int? get _divs => _stops ? _divisions.round() : null;

  double get _min => _centered ? -100 : 0;

  double get _max => _centered ? 100 : 1;

  double get _scaled => _min + _value * (_max - _min);

  String get _ctor {
    if (!_single) {
      return _isWavy ? 'M3ERangeSlider.wavy' : 'M3ERangeSlider';
    }
    if (_vertical) {
      return _centered ? 'M3ESlider.verticalCentered' : 'M3ESlider.vertical';
    }
    if (_isWavy) {
      return _centered ? 'M3ESlider.wavyCentered' : 'M3ESlider.wavy';
    }
    return _centered ? 'M3ESlider.centered' : 'M3ESlider';
  }

  M3ESliderTrackIcons? get _trackIconsValue => _trackIcons
      ? const M3ESliderTrackIcons(
          activeStart: Icon(M3EIcons.volume_mute),
          inactiveEnd: Icon(M3EIcons.volume_up),
        )
      : null;

  @override
  Widget buildPreview(BuildContext context) {
    final Widget slider = _single ? _singleSlider() : _rangeSlider();
    if (_vertical) {
      return SizedBox(height: 280, child: slider);
    }
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: slider,
    );
  }

  Widget _rangeSlider() {
    final ValueChanged<M3ESliderRange> onChanged = _enabled
        ? (M3ESliderRange v) => setState(() => _range = v)
        : (_) {};
    if (_isWavy) {
      return M3ERangeSlider.wavy(
        values: _range,
        divisions: _divs,
        haptic: _haptic,
        size: _size,
        enabled: _enabled,
        trackIcons: _trackIconsValue,
        wavelength: _wavelength,
        amplitude: _amplitude,
        trackThickness: _customGeometry ? _trackThickness : null,
        thumbLength: _customGeometry ? _thumbLength : null,
        cornerRadius: _customGeometry ? _cornerRadius : null,
        semanticLabel: _labelText,
        onChanged: onChanged,
      );
    }
    return M3ERangeSlider(
      values: _range,
      divisions: _divs,
      haptic: _haptic,
      size: _size,
      enabled: _enabled,
      trackIcons: _trackIconsValue,
      trackThickness: _customGeometry ? _trackThickness : null,
      thumbLength: _customGeometry ? _thumbLength : null,
      cornerRadius: _customGeometry ? _cornerRadius : null,
      semanticLabel: _labelText,
      onChanged: onChanged,
    );
  }

  Widget _singleSlider() {
    final ValueChanged<double> onChanged = _enabled
        ? (double v) => setState(() => _value = (v - _min) / (_max - _min))
        : (_) {};
    final double? thickness = _customGeometry ? _trackThickness : null;
    final double? thumb = _customGeometry ? _thumbLength : null;
    final double? radius = _customGeometry ? _cornerRadius : null;
    final String? label = _customLabel ? _labelText : null;
    final Widget? icon = _hasIcon ? const Icon(M3EIcons.volume_up) : null;
    if (_vertical) {
      return _centered
          ? M3ESlider.verticalCentered(
              value: _scaled,
              min: _min,
              max: _max,
              divisions: _divs,
              haptic: _haptic,
              label: label,
              topToBottom: _topToBottom,
              size: _size,
              enabled: _enabled,
              trackIcons: _trackIconsValue,
              trackThickness: thickness,
              thumbLength: thumb,
              cornerRadius: radius,
              semanticLabel: _labelText,
              onChanged: onChanged,
            )
          : M3ESlider.vertical(
              value: _scaled,
              min: _min,
              max: _max,
              divisions: _divs,
              haptic: _haptic,
              label: label,
              topToBottom: _topToBottom,
              size: _size,
              enabled: _enabled,
              icon: icon,
              iconPosition: _iconPosition,
              trackIcons: _trackIconsValue,
              trackThickness: thickness,
              thumbLength: thumb,
              cornerRadius: radius,
              semanticLabel: _labelText,
              onChanged: onChanged,
            );
    }
    if (_isWavy) {
      return _centered
          ? M3ESlider.wavyCentered(
              value: _scaled,
              min: _min,
              max: _max,
              divisions: _divs,
              haptic: _haptic,
              label: label,
              wavelength: _wavelength,
              amplitude: _amplitude,
              size: _size,
              enabled: _enabled,
              trackIcons: _trackIconsValue,
              trackThickness: thickness,
              thumbLength: thumb,
              cornerRadius: radius,
              semanticLabel: _labelText,
              onChanged: onChanged,
            )
          : M3ESlider.wavy(
              value: _scaled,
              min: _min,
              max: _max,
              divisions: _divs,
              haptic: _haptic,
              label: label,
              wavelength: _wavelength,
              amplitude: _amplitude,
              size: _size,
              enabled: _enabled,
              icon: icon,
              iconPosition: _iconPosition,
              trackIcons: _trackIconsValue,
              trackThickness: thickness,
              thumbLength: thumb,
              cornerRadius: radius,
              semanticLabel: _labelText,
              onChanged: onChanged,
            );
    }
    return _centered
        ? M3ESlider.centered(
            value: _scaled,
            min: _min,
            max: _max,
            divisions: _divs,
            haptic: _haptic,
            label: label,
            size: _size,
            enabled: _enabled,
            trackIcons: _trackIconsValue,
            trackThickness: thickness,
            thumbLength: thumb,
            cornerRadius: radius,
            semanticLabel: _labelText,
            onChanged: onChanged,
          )
        : M3ESlider(
            value: _scaled,
            min: _min,
            max: _max,
            divisions: _divs,
            haptic: _haptic,
            label: label,
            size: _size,
            enabled: _enabled,
            icon: icon,
            iconPosition: _iconPosition,
            trackIcons: _trackIconsValue,
            trackThickness: thickness,
            thumbLength: thumb,
            cornerRadius: radius,
            semanticLabel: _labelText,
            onChanged: onChanged,
          );
  }

  String _num(double value) {
    return value == value.roundToDouble()
        ? '${value.toInt()}'
        : value.toStringAsFixed(2);
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer();
    if (_single) {
      args.writeln('  value: ${_num(_scaled)},');
      if (_centered) {
        args
          ..writeln('  min: ${_num(_min)},')
          ..writeln('  max: ${_num(_max)},');
      }
    } else {
      args.writeln(
        '  values: M3ESliderRange(${_num(_range.start)}, '
        '${_num(_range.end)}),',
      );
    }
    args.writeln('  size: M3ESliderSize.${_size.name},');
    if (_stops) {
      args.writeln('  divisions: ${_divs!},');
      if (_haptic != M3EHapticFeedback.none) {
        args.writeln('  haptic: M3EHapticFeedback.${_haptic.name},');
      }
    }
    if (_single && _customLabel) {
      args.writeln('  label: ${playDartString(_labelText)},');
    }
    if (_vertical && _topToBottom) {
      args.writeln('  topToBottom: true,');
    }
    if (_isWavy) {
      args
        ..writeln('  wavelength: ${_num(_wavelength)},')
        ..writeln('  amplitude: ${_num(_amplitude)},');
    }
    if (_hasIcon) {
      args
        ..writeln('  icon: const Icon(M3EIcons.volume_up),')
        ..writeln(
          '  iconPosition: M3ESliderIconPosition.${_iconPosition.name},',
        );
    }
    if (_trackIcons) {
      args.writeln(
        '  trackIcons: const M3ESliderTrackIcons(\n'
        '    activeStart: Icon(M3EIcons.volume_mute),\n'
        '    inactiveEnd: Icon(M3EIcons.volume_up),\n'
        '  ),',
      );
    }
    if (_customGeometry) {
      args
        ..writeln('  trackThickness: ${_num(_trackThickness)},')
        ..writeln('  thumbLength: ${_num(_thumbLength)},')
        ..writeln('  cornerRadius: ${_num(_cornerRadius)},');
    }
    args
      ..writeln('  enabled: $_enabled,')
      ..writeln('  semanticLabel: ${playDartString(_labelText)},')
      ..writeln(
        _single
            ? '  onChanged: (double value) {},'
            : '  onChanged: (M3ESliderRange values) {},',
      );
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Slider',
        code: '$kPlaySnippetImport\n\n$_ctor(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_SliderType>(
            label: 'Type',
            value: _type,
            values: _SliderType.values,
            labelOf: (_SliderType v) => v.name,
            onChanged: (_SliderType v) => setState(() => _type = v),
          ),
          if (_single) ...<Widget>[
            PlayEnumChoice<Axis>(
              label: 'Axis',
              value: _axis,
              values: Axis.values,
              labelOf: (Axis v) => v.name,
              onChanged: (Axis v) => setState(() => _axis = v),
            ),
            PlayEnumChoice<M3ESliderTrackKind>(
              label: 'Track',
              value: _track,
              values: M3ESliderTrackKind.values,
              labelOf: (M3ESliderTrackKind v) => v.name,
              onChanged: (M3ESliderTrackKind v) => setState(() => _track = v),
            ),
          ],
          if (_canWave)
            PlaySwitchItem(
              label: 'Wavy',
              description: 'Active value is a traveling sine wave',
              value: _wavy,
              onChanged: (bool v) => setState(() => _wavy = v),
            ),
          if (_isWavy) ...<Widget>[
            PlaySlider(
              label: 'Wavelength',
              value: _wavelength,
              min: 16,
              max: 120,
              divisions: 104,
              onChanged: (double v) => setState(() => _wavelength = v),
            ),
            PlaySlider(
              label: 'Amplitude',
              value: _amplitude,
              onChanged: (double v) => setState(() => _amplitude = v),
            ),
          ],
          if (_vertical)
            PlaySwitchItem(
              label: 'Top to bottom',
              description: 'Minimum at the top edge',
              value: _topToBottom,
              onChanged: (bool v) => setState(() => _topToBottom = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3ESliderSize>(
            label: 'Size',
            value: _size,
            values: M3ESliderSize.values,
            labelOf: (M3ESliderSize v) => v.name,
            onChanged: (M3ESliderSize v) => setState(() => _size = v),
          ),
          if (_canIcon)
            PlaySwitchItem(
              label: 'End icon',
              description: 'Moves along the track with the value',
              value: _icon,
              onChanged: (bool v) => setState(() => _icon = v),
            ),
          if (_hasIcon)
            PlayEnumChoice<M3ESliderIconPosition>(
              label: 'Icon position',
              value: _iconPosition,
              values: M3ESliderIconPosition.values,
              labelOf: (M3ESliderIconPosition v) => v.name,
              onChanged: (M3ESliderIconPosition v) {
                setState(() => _iconPosition = v);
              },
            ),
          PlaySwitchItem(
            label: 'Track icons',
            description: 'Inset icons on the track segments',
            value: _trackIcons,
            onChanged: (bool v) => setState(() => _trackIcons = v),
          ),
          PlaySwitchItem(
            label: 'Custom geometry',
            description: 'Track thickness, thumb length and corners',
            value: _customGeometry,
            onChanged: (bool v) => setState(() => _customGeometry = v),
          ),
          if (_customGeometry) ...<Widget>[
            PlaySlider(
              label: 'Track thickness',
              value: _trackThickness,
              min: 4,
              max: 96,
              divisions: 92,
              onChanged: (double v) => setState(() => _trackThickness = v),
            ),
            PlaySlider(
              label: 'Thumb length',
              value: _thumbLength,
              min: 24,
              max: 120,
              divisions: 96,
              onChanged: (double v) => setState(() => _thumbLength = v),
            ),
            PlaySlider(
              label: 'Corner radius',
              value: _cornerRadius,
              max: 32,
              divisions: 32,
              onChanged: (double v) => setState(() => _cornerRadius = v),
            ),
          ],
        ],
      ),
      PlayControlGroup(
        title: 'Values',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Stops',
            description: 'Snap to discrete values',
            value: _stops,
            onChanged: (bool v) => setState(() => _stops = v),
          ),
          if (_stops) ...<Widget>[
            PlaySlider(
              label: 'Divisions',
              value: _divisions,
              min: 2,
              max: 20,
              divisions: 18,
              onChanged: (double v) => setState(() => _divisions = v),
            ),
            PlayEnumChoice<M3EHapticFeedback>(
              label: 'Haptic on step',
              value: _haptic,
              values: M3EHapticFeedback.values,
              labelOf: (M3EHapticFeedback v) => v.name,
              onChanged: (M3EHapticFeedback v) => setState(() => _haptic = v),
            ),
          ],
          if (_single)
            PlaySwitchItem(
              label: 'Static value label',
              description: 'Replaces the numeric value indicator',
              value: _customLabel,
              onChanged: (bool v) => setState(() => _customLabel = v),
            ),
          PlayTextField(
            label: _single && _customLabel
                ? 'Label and semantic label'
                : 'Semantic label',
            value: _labelText,
            onChanged: (String v) => setState(() => _labelText = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'State',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Enabled',
            value: _enabled,
            onChanged: (bool v) => setState(() => _enabled = v),
          ),
        ],
      ),
    ];
  }
}
