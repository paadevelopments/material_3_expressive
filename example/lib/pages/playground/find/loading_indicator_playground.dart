import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Indicator color presets.
enum _IndicatorColor { theme, tertiary, multicolor }

/// Live playground for [M3ELoadingIndicator].
class LoadingIndicatorPlayground extends PlaygroundWidget {
  /// Creates the loading indicator playground.
  const LoadingIndicatorPlayground({super.key});

  @override
  PlaygroundState<LoadingIndicatorPlayground> createState() =>
      _LoadingIndicatorPlaygroundState();
}

class _LoadingIndicatorPlaygroundState
    extends PlaygroundState<LoadingIndicatorPlayground> {
  M3ELoadingIndicatorVariant _variant = M3ELoadingIndicatorVariant.defaultStyle;
  bool _customParts = false;
  double _size = 48;
  double _indicatorSize = 38;
  double _containerSize = 48;
  _IndicatorColor _color = _IndicatorColor.theme;
  bool _tertiaryContainer = false;
  bool _manual = false;
  double _turns = 0.25;
  bool _customMotion = false;
  double _rotationMs = 4666;
  double _morphMs = 650;
  double _morphDegrees = 90;

  static const List<Color> _multi = <Color>[
    Color(0xff6750a4),
    Color(0xff006a6a),
  ];

  bool get _contained => _variant == M3ELoadingIndicatorVariant.contained;

  @override
  Widget buildPreview(BuildContext context) {
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    return M3ELoadingIndicator(
      variant: _variant,
      size: _customParts ? null : _size,
      indicatorSize: _customParts ? _indicatorSize : null,
      containerWidth: _customParts && _contained ? _containerSize : null,
      containerHeight: _customParts && _contained ? _containerSize : null,
      color: _color == _IndicatorColor.tertiary ? scheme.tertiary : null,
      indicatorColors: _color == _IndicatorColor.multicolor ? _multi : null,
      containerColor: _contained && _tertiaryContainer
          ? scheme.tertiaryContainer
          : null,
      rotationTurns: _manual ? _turns : null,
      globalRotationDuration: !_manual && _customMotion
          ? Duration(milliseconds: _rotationMs.round())
          : null,
      morphInterval: !_manual && _customMotion
          ? Duration(milliseconds: _morphMs.round())
          : null,
      morphRotationDegrees: !_manual && _customMotion ? _morphDegrees : null,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln('  variant: M3ELoadingIndicatorVariant.${_variant.name},');
    if (_customParts) {
      args.writeln('  indicatorSize: ${_indicatorSize.round()},');
      if (_contained) {
        args
          ..writeln('  containerWidth: ${_containerSize.round()},')
          ..writeln('  containerHeight: ${_containerSize.round()},');
      }
    } else {
      args.writeln('  size: ${_size.round()},');
    }
    switch (_color) {
      case _IndicatorColor.theme:
        break;
      case _IndicatorColor.tertiary:
        args.writeln('  color: scheme.tertiary,');
      case _IndicatorColor.multicolor:
        args.writeln(
          '  indicatorColors: const [Color(0xff6750a4), Color(0xff006a6a)],',
        );
    }
    if (_contained && _tertiaryContainer) {
      args.writeln('  containerColor: scheme.tertiaryContainer,');
    }
    if (_manual) {
      args.writeln('  rotationTurns: ${_turns.toStringAsFixed(2)},');
    } else if (_customMotion) {
      args
        ..writeln(
          '  globalRotationDuration: '
          'Duration(milliseconds: ${_rotationMs.round()}),',
        )
        ..writeln(
          '  morphInterval: Duration(milliseconds: ${_morphMs.round()}),',
        )
        ..writeln('  morphRotationDegrees: ${_morphDegrees.round()},');
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Loading indicator',
        code: '$kPlaySnippetImport\n\nM3ELoadingIndicator(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3ELoadingIndicatorVariant>(
            label: 'Variant',
            value: _variant,
            values: M3ELoadingIndicatorVariant.values,
            labelOf: (M3ELoadingIndicatorVariant v) => switch (v) {
              M3ELoadingIndicatorVariant.defaultStyle => 'default',
              M3ELoadingIndicatorVariant.contained => 'contained',
            },
            onChanged: (M3ELoadingIndicatorVariant v) {
              setState(() => _variant = v);
            },
          ),
          PlayEnumChoice<_IndicatorColor>(
            label: 'Indicator color',
            value: _color,
            values: _IndicatorColor.values,
            labelOf: (_IndicatorColor v) => switch (v) {
              _IndicatorColor.theme => 'theme',
              _IndicatorColor.tertiary => 'tertiary',
              _IndicatorColor.multicolor => 'multicolor (cycles)',
            },
            onChanged: (_IndicatorColor v) => setState(() => _color = v),
          ),
          if (_contained)
            PlaySwitchItem(
              label: 'Tertiary container',
              value: _tertiaryContainer,
              onChanged: (bool v) => setState(() => _tertiaryContainer = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Size',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Size parts separately',
            description: _contained
                ? 'Indicator and container instead of one outer size'
                : 'Indicator size instead of one outer size',
            value: _customParts,
            onChanged: (bool v) => setState(() => _customParts = v),
          ),
          if (!_customParts)
            PlaySlider(
              label: 'Outer size',
              value: _size,
              min: M3ELoadingIndicatorTheme.minSize,
              max: M3ELoadingIndicatorTheme.maxSize,
              divisions: 54,
              onChanged: (double v) => setState(() => _size = v),
            ),
          if (_customParts) ...<Widget>[
            PlaySlider(
              label: 'Indicator size',
              value: _indicatorSize,
              min: 16,
              max: 200,
              divisions: 46,
              onChanged: (double v) => setState(() => _indicatorSize = v),
            ),
            if (_contained)
              PlaySlider(
                label: 'Container size',
                value: _containerSize,
                min: 24,
                max: 240,
                divisions: 54,
                onChanged: (double v) => setState(() => _containerSize = v),
              ),
          ],
        ],
      ),
      PlayControlGroup(
        title: 'Motion',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Manual rotation',
            description: 'Stops the auto spin and pulse',
            value: _manual,
            onChanged: (bool v) => setState(() => _manual = v),
          ),
          if (_manual)
            PlaySlider(
              label: 'Rotation (turns)',
              value: _turns,
              onChanged: (double v) => setState(() => _turns = v),
            ),
          if (!_manual) ...<Widget>[
            PlaySwitchItem(
              label: 'Custom timing',
              value: _customMotion,
              onChanged: (bool v) => setState(() => _customMotion = v),
            ),
            if (_customMotion) ...<Widget>[
              PlaySlider(
                label: 'Spin period (ms)',
                value: _rotationMs,
                min: 1000,
                max: 10000,
                divisions: 90,
                onChanged: (double v) => setState(() => _rotationMs = v),
              ),
              PlaySlider(
                label: 'Morph interval (ms)',
                value: _morphMs,
                min: 200,
                max: 2000,
                divisions: 36,
                onChanged: (double v) => setState(() => _morphMs = v),
              ),
              PlaySlider(
                label: 'Morph rotation (°)',
                value: _morphDegrees,
                max: 360,
                divisions: 24,
                onChanged: (double v) => setState(() => _morphDegrees = v),
              ),
            ],
          ],
        ],
      ),
    ];
  }
}
