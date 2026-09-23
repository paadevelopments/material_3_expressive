import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EBadge].
class BadgesPlayground extends StatefulWidget {
  /// Creates the badges playground.
  const BadgesPlayground({super.key});

  @override
  State<BadgesPlayground> createState() => _BadgesPlaygroundState();
}

enum _BadgeSize { small, large }

class _BadgesPlaygroundState extends State<BadgesPlayground> {
  _BadgeSize _size = _BadgeSize.large;
  bool _showCount = true;
  String _label = '';
  double _count = 8;
  double _maxCount = 999;
  M3EBadgeAlignment _alignment = M3EBadgeAlignment.topRight;

  bool get _isSmall => _size == _BadgeSize.small;

  bool get _hasCustomLabel => _label.trim().isNotEmpty;

  List<PlaySnippet> get _snippets {
    final int count = _count.round();
    final String countArg = !_isSmall && _showCount && !_hasCustomLabel
        ? '$count'
        : 'null';
    final String labelArg = !_isSmall && _hasCustomLabel
        ? "\n  label: '${_label.trim()}',"
        : '';
    final String sample =
        '''
M3EBadge(
  showDot: $_isSmall,
  count: $countArg,$labelArg
  maxCount: ${_maxCount.round()},
  alignment: M3EBadgeAlignment.${_alignment.name},
  child: const Icon(M3EIcons.notifications, size: 28),
);''';
    return <PlaySnippet>[
      PlaySnippet(label: 'Badge', code: '$kPlaySnippetImport\n$sample'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final int count = _count.round();
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Badge (RTL mirrors trailing)',
          child: Wrap(
            spacing: 24,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              M3EBadge(
                showDot: _isSmall,
                count: !_isSmall && _showCount && !_hasCustomLabel
                    ? count
                    : null,
                label: !_isSmall && _hasCustomLabel ? _label.trim() : null,
                maxCount: _maxCount.round(),
                alignment: _alignment,
                child: const Icon(M3EIcons.notifications, size: 28),
              ),
              const M3EBadge(
                showDot: true,
                child: Icon(M3EIcons.menu, size: 28),
              ),
              M3EBadge(
                count: 1200,
                maxCount: _maxCount.round(),
                child: const Icon(M3EIcons.edit, size: 28),
              ),
              const M3EBadge(
                label: 'New',
                child: Icon(M3EIcons.mail, size: 28),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Primary badge',
          children: <Widget>[
            PlayEnumSegmented<_BadgeSize>(
              label: 'Size',
              value: _size,
              values: _BadgeSize.values,
              labelOf: (_BadgeSize v) => switch (v) {
                _BadgeSize.small => 'Small',
                _BadgeSize.large => 'Large',
              },
              onChanged: (_BadgeSize v) => setState(() => _size = v),
            ),
            if (!_isSmall) ...<Widget>[
              PlaySwitch(
                label: 'Show count',
                value: _showCount,
                onChanged: (bool v) => setState(() => _showCount = v),
              ),
              PlayTextField(
                label: 'Status label (preferred over count)',
                value: _label,
                onChanged: (String v) => setState(() => _label = v),
              ),
              PlaySlider(
                label: 'Count',
                value: _count,
                min: 0,
                max: 1200,
                divisions: 120,
                onChanged: (double v) => setState(() => _count = v),
              ),
              PlaySlider(
                label: 'Max count',
                value: _maxCount,
                min: 9,
                max: 999,
                divisions: 110,
                onChanged: (double v) => setState(() => _maxCount = v),
              ),
            ],
            PlayEnumSegmented<M3EBadgeAlignment>(
              label: 'Alignment',
              value: _alignment,
              values: M3EBadgeAlignment.values,
              labelOf: (M3EBadgeAlignment v) => switch (v) {
                M3EBadgeAlignment.topLeft => 'Leading',
                M3EBadgeAlignment.topCenter => 'Center',
                M3EBadgeAlignment.topRight => 'Trailing',
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
