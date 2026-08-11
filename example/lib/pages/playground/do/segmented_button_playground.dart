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

  @override
  Widget build(BuildContext context) {
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
