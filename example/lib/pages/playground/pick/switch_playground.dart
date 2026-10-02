import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Which thumb icons the switch shows.
enum _SwitchIcons { none, selectedOnly, both }

/// Live playground for [M3ESwitch].
class SwitchPlayground extends PlaygroundWidget {
  /// Creates the switch playground.
  const SwitchPlayground({super.key});

  @override
  PlaygroundState<SwitchPlayground> createState() => _SwitchPlaygroundState();
}

class _SwitchPlaygroundState extends PlaygroundState<SwitchPlayground> {
  bool _value = true;
  bool _enabled = true;
  _SwitchIcons _icons = _SwitchIcons.both;
  double _stateLayerSize = 40;
  String _semanticLabel = 'Wi-Fi';

  @override
  Widget buildPreview(BuildContext context) {
    return M3ESwitch(
      value: _value,
      selectedIcon: _icons == _SwitchIcons.none
          ? null
          : const Icon(M3EIcons.check),
      unselectedIcon: _icons == _SwitchIcons.both
          ? const Icon(M3EIcons.close)
          : null,
      stateLayerSize: _stateLayerSize,
      semanticLabel: _semanticLabel.isEmpty ? null : _semanticLabel,
      onChanged: _enabled ? (bool next) => setState(() => _value = next) : null,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()..writeln('  value: $_value,');
    if (_icons != _SwitchIcons.none) {
      args.writeln('  selectedIcon: const Icon(M3EIcons.check),');
    }
    if (_icons == _SwitchIcons.both) {
      args.writeln('  unselectedIcon: const Icon(M3EIcons.close),');
    }
    args.writeln('  stateLayerSize: ${_stateLayerSize.round()},');
    if (_semanticLabel.isNotEmpty) {
      args.writeln('  semanticLabel: ${playDartString(_semanticLabel)},');
    }
    args.writeln('  onChanged: ${_enabled ? '(bool next) {}' : 'null'},');
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Switch',
        code: '$kPlaySnippetImport\n\nM3ESwitch(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<_SwitchIcons>(
            label: 'Thumb icons',
            value: _icons,
            values: _SwitchIcons.values,
            labelOf: (_SwitchIcons v) => switch (v) {
              _SwitchIcons.none => 'none',
              _SwitchIcons.selectedOnly => 'selected only',
              _SwitchIcons.both => 'selected and unselected',
            },
            onChanged: (_SwitchIcons v) => setState(() => _icons = v),
          ),
          PlaySlider(
            label: 'State layer size',
            value: _stateLayerSize,
            min: 32,
            max: 64,
            divisions: 8,
            onChanged: (double v) => setState(() => _stateLayerSize = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'State',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Value',
            value: _value,
            onChanged: (bool v) => setState(() => _value = v),
          ),
          PlaySwitchItem(
            label: 'Enabled',
            value: _enabled,
            onChanged: (bool v) => setState(() => _enabled = v),
          ),
          PlayTextField(
            label: 'Semantic label',
            value: _semanticLabel,
            onChanged: (String v) => setState(() => _semanticLabel = v),
          ),
        ],
      ),
    ];
  }
}
