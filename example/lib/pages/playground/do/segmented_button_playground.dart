import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/playground.dart';

enum _SegmentContent { text, textWithIcon, icon }

/// Live playground for [M3ESegmentedButton].
class SegmentedButtonPlayground extends PlaygroundWidget {
  /// Creates the segmented button playground.
  const SegmentedButtonPlayground({super.key});

  @override
  PlaygroundState<SegmentedButtonPlayground> createState() =>
      _SegmentedButtonPlaygroundState();
}

class _SegmentedButtonPlaygroundState
    extends PlaygroundState<SegmentedButtonPlayground> {
  bool _multiSelect = false;
  bool _showSelectedIcon = true;
  bool _groupEnabled = true;
  bool _disableSecond = false;
  bool _gradient = false;
  double _segmentCount = 3;
  _SegmentContent _content = _SegmentContent.textWithIcon;
  M3ESegmentedButtonDensity _density = M3ESegmentedButtonDensity.regular;
  Set<int> _selected = <int>{0};

  static const List<(IconData, String, String)> _items =
      <(IconData, String, String)>[
        (M3EIcons.calendar_today, 'calendar_today', 'Day'),
        (M3EIcons.calendar_view_week, 'calendar_view_week', 'Week'),
        (M3EIcons.calendar_month, 'calendar_month', 'Month'),
        (M3EIcons.event, 'event', 'Year'),
        (M3EIcons.schedule, 'schedule', 'All'),
      ];

  int get _count => _segmentCount.round();

  List<M3ESegment<int>> get _segments => <M3ESegment<int>>[
    for (int i = 0; i < _count; i++)
      M3ESegment<int>(
        value: i,
        label: _content == _SegmentContent.icon ? null : _items[i].$3,
        icon: _content == _SegmentContent.text ? null : Icon(_items[i].$1),
        semanticLabel: _content == _SegmentContent.icon ? _items[i].$3 : null,
        enabled: !(i == 1 && _disableSecond),
      ),
  ];

  @override
  Widget buildPreview(BuildContext context) {
    final Widget button = M3ESegmentedButton<int>(
      multiSelect: _multiSelect,
      showSelectedIcon: _showSelectedIcon,
      density: _density,
      enabled: _groupEnabled,
      selected: _selected.where((int i) => i < _count).toSet(),
      onSelectionChanged: (Set<int> next) => setState(() => _selected = next),
      segments: _segments,
    );
    if (!_gradient) {
      return button;
    }
    final M3EThemeData theme = M3ETheme.of(context);
    return M3ETheme(
      data: theme.copyWith(
        segmentedButtonTheme: theme.segmentedButtonTheme.copyWith(
          selectedBackgroundGradient: const LinearGradient(
            colors: <Color>[Color(0xFF6750A4), Color(0xFF9A82DB)],
          ),
          outlineGradient: const LinearGradient(
            colors: <Color>[Color(0xFF4F378B), Color(0xFFD0BCFF)],
          ),
          dividerGradient: const LinearGradient(
            colors: <Color>[Color(0xFF4F378B), Color(0xFFD0BCFF)],
          ),
          selectedForegroundGradient: const LinearGradient(
            colors: <Color>[Color(0xFFFFFFFF), Color(0xFFEADDFF)],
          ),
        ),
      ),
      child: button,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer segments = StringBuffer();
    for (int i = 0; i < _count; i++) {
      final StringBuffer args = StringBuffer('value: $i');
      if (_content != _SegmentContent.icon) {
        args.write(", label: '${_items[i].$3}'");
      }
      if (_content != _SegmentContent.text) {
        args.write(', icon: Icon(M3EIcons.${_items[i].$2})');
      }
      if (_content == _SegmentContent.icon) {
        args.write(", semanticLabel: '${_items[i].$3}'");
      }
      if (i == 1 && _disableSecond) {
        args.write(', enabled: false');
      }
      segments.writeln('    M3ESegment<int>($args),');
    }
    final String theme = _gradient
        ? '\n// Gradients come from M3ESegmentedButtonTheme:\n'
              '// selectedBackgroundGradient, outlineGradient,\n'
              '// dividerGradient, selectedForegroundGradient.\n'
        : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Segmented button',
        code:
            '''
$kPlaySnippetImport
$theme
M3ESegmentedButton<int>(
  multiSelect: $_multiSelect,
  showSelectedIcon: $_showSelectedIcon,
  density: M3ESegmentedButtonDensity.${_density.name},
  enabled: $_groupEnabled,
  selected: <int>{${_selected.join(', ')}},
  onSelectionChanged: (Set<int> next) {},
  segments: const <M3ESegment<int>>[
$segments  ],
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3ESegmentedButtonDensity>(
            label: 'Density',
            value: _density,
            values: M3ESegmentedButtonDensity.values,
            labelOf: (M3ESegmentedButtonDensity v) => switch (v) {
              M3ESegmentedButtonDensity.regular => '0',
              M3ESegmentedButtonDensity.comfortable => '−1',
              M3ESegmentedButtonDensity.compact => '−2',
              M3ESegmentedButtonDensity.dense => '−3',
            },
            onChanged: (M3ESegmentedButtonDensity v) =>
                setState(() => _density = v),
          ),
          PlaySwitchItem(
            label: 'Gradient fill',
            description: 'Theme gradients for fill, outline and divider',
            value: _gradient,
            onChanged: (bool v) => setState(() => _gradient = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Segments',
        children: <Widget>[
          PlaySlider(
            label: 'Count',
            value: _segmentCount,
            min: 2,
            max: _items.length.toDouble(),
            divisions: _items.length - 2,
            onChanged: (double v) => setState(() => _segmentCount = v),
          ),
          PlayEnumChoice<_SegmentContent>(
            label: 'Content',
            value: _content,
            values: _SegmentContent.values,
            labelOf: (_SegmentContent v) => switch (v) {
              _SegmentContent.text => 'text',
              _SegmentContent.textWithIcon => 'text+icon',
              _SegmentContent.icon => 'icon',
            },
            onChanged: (_SegmentContent v) => setState(() => _content = v),
          ),
          PlaySwitchItem(
            label: 'Disable second segment',
            value: _disableSecond,
            onChanged: (bool v) => setState(() => _disableSecond = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Selection',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Multi-select',
            value: _multiSelect,
            onChanged: (bool v) {
              setState(() {
                _multiSelect = v;
                if (!v && _selected.length > 1) {
                  _selected = <int>{_selected.first};
                }
              });
            },
          ),
          PlaySwitchItem(
            label: 'Show selected icon',
            description: 'Check mark on selected segments',
            value: _showSelectedIcon,
            onChanged: (bool v) => setState(() => _showSelectedIcon = v),
          ),
          PlaySwitchItem(
            label: 'Enabled',
            value: _groupEnabled,
            onChanged: (bool v) => setState(() => _groupEnabled = v),
          ),
        ],
      ),
    ];
  }
}
