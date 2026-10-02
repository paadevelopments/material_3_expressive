import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Indicator shape.
enum _Shape { circular, linear }

/// Live playground for [M3EProgressIndicator].
class ProgressPlayground extends PlaygroundWidget {
  /// Creates the progress playground.
  const ProgressPlayground({super.key});

  @override
  PlaygroundState<ProgressPlayground> createState() =>
      _ProgressPlaygroundState();
}

class _ProgressPlaygroundState extends PlaygroundState<ProgressPlayground> {
  _Shape _shape = _Shape.linear;
  bool _wavy = false;
  bool _determinate = true;
  bool _showTrack = true;
  double _value = 0.6;
  M3EProgressIndicatorSize _linearSize = M3EProgressIndicatorSize.m;
  bool _customSize = false;
  double _size = 48;
  double _strokeWidth = 8;
  double _trackStrokeWidth = 8;
  bool _customWave = false;
  double _wavelength = 40;
  double _amplitude = 1;
  double _gapSize = 4;
  double _stopSize = 4;
  bool _tertiary = false;

  bool get _linear => _shape == _Shape.linear;

  double? get _progress => _determinate ? _value : null;

  String get _ctor => switch ((_shape, _wavy)) {
    (_Shape.circular, false) => 'circular',
    (_Shape.circular, true) => 'circularWavy',
    (_Shape.linear, false) => 'linear',
    (_Shape.linear, true) => 'linearWavy',
  };

  @override
  Widget buildPreview(BuildContext context) {
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    final Color? color = _tertiary ? scheme.tertiary : null;
    final Color? trackColor = _tertiary ? scheme.tertiaryContainer : null;
    final double? trackStroke = _showTrack ? _trackStrokeWidth : null;
    final double? size = _customSize ? _size : null;
    final double? wavelength = _customWave ? _wavelength : null;
    final double? amplitude = _customWave ? _amplitude : null;
    final double? gap = _customWave ? _gapSize : null;
    final Widget indicator = switch ((_shape, _wavy)) {
      (_Shape.circular, false) => M3EProgressIndicator.circular(
        value: _progress,
        size: size,
        strokeWidth: _strokeWidth,
        trackStrokeWidth: trackStroke,
        color: color,
        trackColor: trackColor,
        showTrack: _showTrack,
      ),
      (_Shape.circular, true) => M3EProgressIndicator.circularWavy(
        value: _progress,
        size: size,
        strokeWidth: _strokeWidth,
        trackStrokeWidth: trackStroke,
        color: color,
        trackColor: trackColor,
        wavelength: wavelength,
        amplitude: amplitude,
        gapSize: gap,
        showTrack: _showTrack,
      ),
      (_Shape.linear, false) => M3EProgressIndicator.linear(
        value: _progress,
        linearSize: _linearSize,
        strokeWidth: _strokeWidth,
        trackStrokeWidth: trackStroke,
        color: color,
        trackColor: trackColor,
        showTrack: _showTrack,
      ),
      (_Shape.linear, true) => M3EProgressIndicator.linearWavy(
        value: _progress,
        linearSize: _linearSize,
        strokeWidth: _strokeWidth,
        trackStrokeWidth: trackStroke,
        color: color,
        trackColor: trackColor,
        wavelength: wavelength,
        amplitude: amplitude,
        gapSize: gap,
        stopSize: _customWave ? _stopSize : null,
        showTrack: _showTrack,
      ),
    };
    return _linear ? SizedBox(width: 320, child: indicator) : indicator;
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln(
        '  value: ${_determinate ? _value.toStringAsFixed(2) : 'null'},',
      );
    if (_linear) {
      args.writeln(
        '  linearSize: M3EProgressIndicatorSize.${_linearSize.name},',
      );
    } else if (_customSize) {
      args.writeln('  size: ${_size.round()},');
    }
    args.writeln('  strokeWidth: ${_strokeWidth.round()},');
    if (_showTrack) {
      args.writeln('  trackStrokeWidth: ${_trackStrokeWidth.round()},');
    } else {
      args.writeln('  showTrack: false,');
    }
    if (_wavy && _customWave) {
      args
        ..writeln('  wavelength: ${_wavelength.round()},')
        ..writeln('  amplitude: ${_amplitude.toStringAsFixed(2)},')
        ..writeln('  gapSize: ${_gapSize.round()},');
      if (_linear) {
        args.writeln('  stopSize: ${_stopSize.round()},');
      }
    }
    if (_tertiary) {
      args
        ..writeln('  color: scheme.tertiary,')
        ..writeln('  trackColor: scheme.tertiaryContainer,');
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Progress indicator',
        code: '$kPlaySnippetImport\n\nM3EProgressIndicator.$_ctor(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_Shape>(
            label: 'Shape',
            value: _shape,
            values: _Shape.values,
            labelOf: (_Shape v) => v.name,
            onChanged: (_Shape v) => setState(() => _shape = v),
          ),
          PlaySwitchItem(
            label: 'Wavy',
            description: 'Active indicator is a sine wave',
            value: _wavy,
            onChanged: (bool v) => setState(() => _wavy = v),
          ),
          PlaySwitchItem(
            label: 'Determinate',
            description: 'Off spins without a value',
            value: _determinate,
            onChanged: (bool v) => setState(() => _determinate = v),
          ),
          if (_determinate)
            PlaySlider(
              label: 'Value',
              value: _value,
              onChanged: (double v) => setState(() => _value = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Size',
        children: <Widget>[
          if (_linear)
            PlayEnumChoice<M3EProgressIndicatorSize>(
              label: 'Linear size',
              value: _linearSize,
              values: M3EProgressIndicatorSize.values,
              labelOf: (M3EProgressIndicatorSize v) => v.name,
              onChanged: (M3EProgressIndicatorSize v) {
                setState(() {
                  _linearSize = v;
                  final double h = v == M3EProgressIndicatorSize.s ? 4 : 8;
                  _strokeWidth = h;
                  _trackStrokeWidth = h;
                });
              },
            ),
          if (!_linear) ...<Widget>[
            PlaySwitchItem(
              label: 'Custom diameter',
              value: _customSize,
              onChanged: (bool v) => setState(() => _customSize = v),
            ),
            if (_customSize)
              PlaySlider(
                label: 'Diameter',
                value: _size,
                min: 24,
                max: 160,
                divisions: 34,
                onChanged: (double v) => setState(() => _size = v),
              ),
          ],
          PlaySlider(
            label: 'Stroke',
            value: _strokeWidth,
            min: 2,
            max: 16,
            divisions: 14,
            onChanged: (double v) => setState(() => _strokeWidth = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Track',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Show track',
            value: _showTrack,
            onChanged: (bool v) => setState(() => _showTrack = v),
          ),
          if (_showTrack)
            PlaySlider(
              label: 'Track stroke',
              value: _trackStrokeWidth,
              min: 2,
              max: 16,
              divisions: 14,
              onChanged: (double v) => setState(() => _trackStrokeWidth = v),
            ),
          PlaySwitchItem(
            label: 'Tertiary colors',
            value: _tertiary,
            onChanged: (bool v) => setState(() => _tertiary = v),
          ),
        ],
      ),
      if (_wavy)
        PlayControlGroup(
          title: 'Wave',
          children: <Widget>[
            PlaySwitchItem(
              label: 'Custom wave',
              value: _customWave,
              onChanged: (bool v) => setState(() => _customWave = v),
            ),
            if (_customWave) ...<Widget>[
              PlaySlider(
                label: 'Wavelength',
                value: _wavelength,
                min: 10,
                max: 80,
                divisions: 70,
                onChanged: (double v) => setState(() => _wavelength = v),
              ),
              PlaySlider(
                label: 'Amplitude',
                value: _amplitude,
                onChanged: (double v) => setState(() => _amplitude = v),
              ),
              PlaySlider(
                label: 'Gap',
                value: _gapSize,
                max: 16,
                divisions: 16,
                onChanged: (double v) => setState(() => _gapSize = v),
              ),
              if (_linear)
                PlaySlider(
                  label: 'Stop size',
                  value: _stopSize,
                  max: 12,
                  divisions: 12,
                  onChanged: (double v) => setState(() => _stopSize = v),
                ),
            ],
          ],
        ),
    ];
  }
}
