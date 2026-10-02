import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3EDivider].
class DividersPlayground extends PlaygroundWidget {
  /// Creates the dividers playground.
  const DividersPlayground({super.key});

  @override
  PlaygroundState<DividersPlayground> createState() =>
      _DividersPlaygroundState();
}

class _DividersPlaygroundState extends PlaygroundState<DividersPlayground> {
  M3EDividerAxis _axis = M3EDividerAxis.horizontal;
  M3EDividerInset _inset = M3EDividerInset.full;
  double _thickness = 1;
  bool _customIndents = false;
  double _indent = 16;
  double _endIndent = 16;
  bool _outerMargin = false;
  bool _primaryColor = false;

  bool get _vertical => _axis == M3EDividerAxis.vertical;

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EDivider divider = M3EDivider(
      axis: _axis,
      inset: _inset,
      thickness: _thickness,
      indent: _customIndents ? _indent : null,
      endIndent: _customIndents ? _endIndent : null,
      outerMargin: _outerMargin,
      color: _primaryColor ? theme.colorScheme.primary : null,
    );
    final TextStyle style = theme.typeScale.bodyLarge;
    if (_vertical) {
      return SizedBox(
        height: 96,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: Text('Start', style: style)),
            const SizedBox(width: 12),
            divider,
            const SizedBox(width: 12),
            Center(child: Text('End', style: style)),
          ],
        ),
      );
    }
    return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Above', style: style),
          const SizedBox(height: 12),
          divider,
          const SizedBox(height: 12),
          Text('Below', style: style),
        ],
      ),
    );
  }

  String _n(double v) => v == v.roundToDouble() ? '${v.toInt()}' : '$v';

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln('  axis: M3EDividerAxis.${_axis.name},')
      ..writeln('  inset: M3EDividerInset.${_inset.name},')
      ..writeln('  thickness: ${_n(_thickness)},');
    if (_customIndents) {
      args
        ..writeln('  indent: ${_n(_indent)},')
        ..writeln('  endIndent: ${_n(_endIndent)},');
    }
    if (_outerMargin) {
      args.writeln('  outerMargin: true,');
    }
    if (_primaryColor) {
      args.writeln('  color: M3ETheme.of(context).colorScheme.primary,');
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Divider',
        code: '$kPlaySnippetImport\n\nM3EDivider(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Layout',
        children: <Widget>[
          PlayEnumChoice<M3EDividerAxis>(
            label: 'Axis',
            value: _axis,
            values: M3EDividerAxis.values,
            labelOf: (M3EDividerAxis v) => v.name,
            onChanged: (M3EDividerAxis v) => setState(() => _axis = v),
          ),
          PlaySwitchItem(
            label: 'Custom indents',
            description: 'Override the inset preset',
            value: _customIndents,
            onChanged: (bool v) => setState(() => _customIndents = v),
          ),
          if (!_customIndents)
            PlayEnumChoice<M3EDividerInset>(
              label: 'Inset',
              value: _inset,
              values: M3EDividerInset.values,
              labelOf: (M3EDividerInset v) => v.name,
              onChanged: (M3EDividerInset v) => setState(() => _inset = v),
            ),
          if (_customIndents) ...<Widget>[
            PlaySlider(
              label: _vertical ? 'Top indent' : 'Start indent',
              value: _indent,
              max: 48,
              divisions: 12,
              onChanged: (double v) => setState(() => _indent = v),
            ),
            PlaySlider(
              label: _vertical ? 'Bottom indent' : 'End indent',
              value: _endIndent,
              max: 48,
              divisions: 12,
              onChanged: (double v) => setState(() => _endIndent = v),
            ),
          ],
          PlaySwitchItem(
            label: 'Outer margin',
            description: 'Adds the theme end and bottom margins',
            value: _outerMargin,
            onChanged: (bool v) => setState(() => _outerMargin = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlaySlider(
            label: 'Thickness',
            value: _thickness,
            min: 1,
            max: 8,
            divisions: 7,
            onChanged: (double v) => setState(() => _thickness = v),
          ),
          PlaySwitchItem(
            label: 'Primary color',
            description: 'Instead of outline variant',
            value: _primaryColor,
            onChanged: (bool v) => setState(() => _primaryColor = v),
          ),
        ],
      ),
    ];
  }
}
