import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ESegmentedButton].
class SegmentedButtonPlayground extends StatefulWidget {
  /// Creates the segmented button playground.
  const SegmentedButtonPlayground({super.key});

  @override
  State<SegmentedButtonPlayground> createState() =>
      _SegmentedButtonPlaygroundState();
}

class _SegmentedButtonPlaygroundState extends State<SegmentedButtonPlayground> {
  bool _multiSelect = false;
  bool _showSelectedIcon = true;
  bool _groupEnabled = true;
  bool _disableMiddle = false;
  M3ESegmentedButtonDensity _density = M3ESegmentedButtonDensity.regular;
  Set<int> _selected = <int>{0};
  Set<int> _gradientSelected = <int>{0};

  List<M3ESegment<int>> get _segments => <M3ESegment<int>>[
    const M3ESegment<int>(
      value: 0,
      label: 'Day',
      icon: Icon(M3EIcons.calendar_today),
    ),
    M3ESegment<int>(
      value: 1,
      label: 'Week',
      icon: const Icon(M3EIcons.calendar_view_week),
      enabled: !_disableMiddle,
    ),
    const M3ESegment<int>(
      value: 2,
      label: 'Month',
      icon: Icon(M3EIcons.calendar_month),
    ),
  ];

  List<PlaySnippet> get _snippets {
    final String selected = '<int>{${_selected.join(', ')}}';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Segmented button',
        code:
            '''
$kPlaySnippetImport
M3ESegmentedButton<int>(
  multiSelect: $_multiSelect,
  showSelectedIcon: $_showSelectedIcon,
  density: M3ESegmentedButtonDensity.${_density.name},
  enabled: $_groupEnabled,
  selected: $selected,
  onSelectionChanged: (Set<int> next) {},
  segments: const <M3ESegment<int>>[
    M3ESegment<int>(
      value: 0,
      label: 'Day',
      icon: Icon(M3EIcons.calendar_today),
    ),
    M3ESegment<int>(
      value: 1,
      label: 'Week',
      icon: Icon(M3EIcons.calendar_view_week),
    ),
    M3ESegment<int>(
      value: 2,
      label: 'Month',
      icon: Icon(M3EIcons.calendar_month),
    ),
  ],
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Segmented button',
          child: M3ESegmentedButton<int>(
            multiSelect: _multiSelect,
            showSelectedIcon: _showSelectedIcon,
            density: _density,
            enabled: _groupEnabled,
            selected: _selected,
            onSelectionChanged: (Set<int> next) {
              setState(() => _selected = next);
            },
            segments: _segments,
          ),
        ),
        PlayPreviewCard(
          label: 'Gradient fill',
          child: M3ETheme(
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
            child: M3ESegmentedButton<int>(
              multiSelect: false,
              showSelectedIcon: _showSelectedIcon,
              density: _density,
              enabled: _groupEnabled,
              selected: _gradientSelected,
              onSelectionChanged: (Set<int> next) {
                setState(() => _gradientSelected = next);
              },
              segments: _segments,
            ),
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Behavior',
          children: <Widget>[
            PlayEnumSegmented<M3ESegmentedButtonDensity>(
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
            PlaySwitch(
              label: 'Multi select',
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
            PlaySwitch(
              label: 'Show selected icon',
              value: _showSelectedIcon,
              onChanged: (bool v) => setState(() => _showSelectedIcon = v),
            ),
            PlaySwitch(
              label: 'Group enabled',
              value: _groupEnabled,
              onChanged: (bool v) => setState(() => _groupEnabled = v),
            ),
            PlaySwitch(
              label: 'Disable Week segment',
              value: _disableMiddle,
              onChanged: (bool v) => setState(() => _disableMiddle = v),
            ),
          ],
        ),
      ],
    );
  }
}
