import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// What the badge shows.
enum _BadgeContent { dot, count, label }

/// Live playground for [M3EBadge].
class BadgesPlayground extends PlaygroundWidget {
  /// Creates the badges playground.
  const BadgesPlayground({super.key});

  @override
  PlaygroundState<BadgesPlayground> createState() => _BadgesPlaygroundState();
}

class _BadgesPlaygroundState extends PlaygroundState<BadgesPlayground> {
  _BadgeContent _content = _BadgeContent.count;
  String _label = 'New';
  double _count = 8;
  double _maxCount = 999;
  M3EBadgeAlignment _alignment = M3EBadgeAlignment.topRight;
  bool _customOffset = false;
  double _offsetX = 0;
  double _offsetY = 0;
  bool _tertiary = false;

  int get _countValue => _count.round();

  @override
  Widget buildPreview(BuildContext context) {
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    return M3EBadge(
      showDot: _content == _BadgeContent.dot,
      count: _content == _BadgeContent.count ? _countValue : null,
      label: _content == _BadgeContent.label ? _label : null,
      maxCount: _maxCount.round(),
      alignment: _alignment,
      offset: _customOffset ? Offset(_offsetX, _offsetY) : null,
      backgroundColor: _tertiary ? scheme.tertiary : null,
      foregroundColor: _tertiary ? scheme.onTertiary : null,
      child: Icon(
        M3EIcons.notifications,
        size: 32,
        color: scheme.onSurfaceVariant,
      ),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer();
    switch (_content) {
      case _BadgeContent.dot:
        args.writeln('  showDot: true,');
      case _BadgeContent.count:
        args
          ..writeln('  count: $_countValue,')
          ..writeln('  maxCount: ${_maxCount.round()},');
      case _BadgeContent.label:
        args.writeln('  label: ${playDartString(_label)},');
    }
    args.writeln('  alignment: M3EBadgeAlignment.${_alignment.name},');
    if (_customOffset) {
      args.writeln(
        '  offset: Offset(${_offsetX.round()}, ${_offsetY.round()}),',
      );
    }
    if (_tertiary) {
      args
        ..writeln('  backgroundColor: scheme.tertiary,')
        ..writeln('  foregroundColor: scheme.onTertiary,');
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Badge',
        code:
            '$kPlaySnippetImport\n\nM3EBadge(\n$args'
            '  child: const Icon(M3EIcons.notifications),\n);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlayEnumChoice<_BadgeContent>(
            label: 'Shows',
            value: _content,
            values: _BadgeContent.values,
            labelOf: (_BadgeContent v) => switch (v) {
              _BadgeContent.dot => 'dot (small)',
              _BadgeContent.count => 'count (large)',
              _BadgeContent.label => 'label (large)',
            },
            onChanged: (_BadgeContent v) => setState(() => _content = v),
          ),
          if (_content == _BadgeContent.count) ...<Widget>[
            PlaySlider(
              label: 'Count',
              value: _count,
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
          if (_content == _BadgeContent.label)
            PlayTextField(
              label: 'Label',
              value: _label,
              onChanged: (String v) => setState(() => _label = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Placement',
        children: <Widget>[
          PlayEnumChoice<M3EBadgeAlignment>(
            label: 'Alignment',
            value: _alignment,
            values: M3EBadgeAlignment.values,
            labelOf: (M3EBadgeAlignment v) => switch (v) {
              M3EBadgeAlignment.topLeft => 'top leading',
              M3EBadgeAlignment.topCenter => 'top center',
              M3EBadgeAlignment.topRight => 'top trailing',
            },
            onChanged: (M3EBadgeAlignment v) => setState(() => _alignment = v),
          ),
          PlaySwitchItem(
            label: 'Custom offset',
            description: 'Override the theme placement',
            value: _customOffset,
            onChanged: (bool v) => setState(() => _customOffset = v),
          ),
          if (_customOffset) ...<Widget>[
            PlaySlider(
              label: 'Offset x',
              value: _offsetX,
              min: -16,
              max: 16,
              divisions: 32,
              onChanged: (double v) => setState(() => _offsetX = v),
            ),
            PlaySlider(
              label: 'Offset y',
              value: _offsetY,
              min: -16,
              max: 16,
              divisions: 32,
              onChanged: (double v) => setState(() => _offsetY = v),
            ),
          ],
        ],
      ),
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Tertiary colors',
            description: 'Instead of the error colors',
            value: _tertiary,
            onChanged: (bool v) => setState(() => _tertiary = v),
          ),
        ],
      ),
    ];
  }
}
