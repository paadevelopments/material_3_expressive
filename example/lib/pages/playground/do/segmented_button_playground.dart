import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
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
  Set<int> _selected = <int>{0};
  Set<int> _gradientSelected = <int>{0};

  static const List<M3ESegment<int>> _segments = <M3ESegment<int>>[
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
  ];

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
                selectedForegroundGradient: const LinearGradient(
                  colors: <Color>[Color(0xFFFFFFFF), Color(0xFFEADDFF)],
                ),
              ),
            ),
            child: M3ESegmentedButton<int>(
              multiSelect: false,
              showSelectedIcon: _showSelectedIcon,
              selected: _gradientSelected,
              onSelectionChanged: (Set<int> next) {
                setState(() => _gradientSelected = next);
              },
              segments: _segments,
            ),
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Behavior',
          children: <Widget>[
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
          ],
        ),
      ],
    );
  }
}
