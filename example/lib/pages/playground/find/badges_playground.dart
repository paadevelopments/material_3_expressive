import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EBadge].
class BadgesPlayground extends StatefulWidget {
  /// Creates the badges playground.
  const BadgesPlayground({super.key});

  @override
  State<BadgesPlayground> createState() => _BadgesPlaygroundState();
}

class _BadgesPlaygroundState extends State<BadgesPlayground> {
  bool _showDot = false;
  bool _showCount = true;
  double _count = 8;
  double _maxCount = 99;
  M3EBadgeAlignment _alignment = M3EBadgeAlignment.topRight;

  @override
  Widget build(BuildContext context) {
    final int count = _count.round();
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Badge',
          child: Wrap(
            spacing: 24,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              M3EBadge(
                showDot: _showDot,
                count: _showCount && !_showDot ? count : null,
                maxCount: _maxCount.round(),
                alignment: _alignment,
                child: const Icon(M3EIcons.notifications, size: 28),
              ),
              M3EBadge(
                showDot: true,
                child: const Icon(M3EIcons.menu, size: 28),
              ),
              M3EBadge(
                count: 120,
                maxCount: _maxCount.round(),
                child: const Icon(M3EIcons.edit, size: 28),
              ),
            ],
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Primary badge',
          children: <Widget>[
            PlaySwitch(
              label: 'Show dot',
              value: _showDot,
              onChanged: (bool v) => setState(() => _showDot = v),
            ),
            PlaySwitch(
              label: 'Show count',
              value: _showCount,
              onChanged: (bool v) => setState(() => _showCount = v),
            ),
            PlaySlider(
              label: 'Count',
              value: _count,
              min: 0,
              max: 150,
              divisions: 150,
              onChanged: (double v) => setState(() => _count = v),
            ),
            PlaySlider(
              label: 'Max count',
              value: _maxCount,
              min: 9,
              max: 99,
              divisions: 90,
              onChanged: (double v) => setState(() => _maxCount = v),
            ),
            PlayEnumSegmented<M3EBadgeAlignment>(
              label: 'Alignment',
              value: _alignment,
              values: M3EBadgeAlignment.values,
              labelOf: (M3EBadgeAlignment v) => switch (v) {
                M3EBadgeAlignment.topLeft => 'Left',
                M3EBadgeAlignment.topCenter => 'Center',
                M3EBadgeAlignment.topRight => 'Right',
              },
              onChanged: (M3EBadgeAlignment v) {
                setState(() => _alignment = v);
              },
            ),
          ],
        ),
      ],
    );
  }
}
