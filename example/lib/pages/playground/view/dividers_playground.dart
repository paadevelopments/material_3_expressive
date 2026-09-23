import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EDivider].
class DividersPlayground extends StatefulWidget {
  /// Creates the dividers playground.
  const DividersPlayground({super.key});

  @override
  State<DividersPlayground> createState() => _DividersPlaygroundState();
}

class _DividersPlaygroundState extends State<DividersPlayground> {
  M3EDividerAxis _axis = M3EDividerAxis.horizontal;
  M3EDividerInset _inset = M3EDividerInset.full;
  double _thickness = 1;
  double? _indent;
  double? _endIndent;
  bool _outerMargin = false;

  List<PlaySnippet> get _snippets {
    String n(double v) => v == v.roundToDouble() ? '${v.toInt()}' : '$v';
    final String indent = _indent == null ? '' : '\n  indent: ${n(_indent!)},';
    final String endIndent = _endIndent == null
        ? ''
        : '\n  endIndent: ${n(_endIndent!)},';
    final String margin = _outerMargin ? '\n  outerMargin: true,' : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Divider',
        code:
            '''
$kPlaySnippetImport

M3EDivider(
  axis: M3EDividerAxis.${_axis.name},
  inset: M3EDividerInset.${_inset.name},
  thickness: ${n(_thickness)},$indent$endIndent$margin
);''',
      ),
      const PlaySnippet(
        label: 'Supporting text',
        code:
            '''
$kPlaySnippetImport

Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    Text('Supporting text'),
    SizedBox(height: M3EDividerTheme.defaults.textGap),
    M3EDivider(inset: M3EDividerInset.middle),
  ],
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EDividerTheme dividerTheme = theme.dividerTheme;
    final bool vertical = _axis == M3EDividerAxis.vertical;
    final M3EDivider divider = M3EDivider(
      axis: _axis,
      inset: _inset,
      thickness: _thickness,
      indent: _indent,
      endIndent: _endIndent,
      outerMargin: _outerMargin,
    );
    final double shownIndent = _indent ?? dividerTheme.startFor(_inset);
    final double shownEnd = _endIndent ?? dividerTheme.endFor(_inset);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Divider',
          child: vertical
              ? SizedBox(
                  height: 64,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Left', style: theme.typeScale.bodyLarge),
                      ),
                      const SizedBox(width: 12),
                      divider,
                      const SizedBox(width: 12),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Right', style: theme.typeScale.bodyLarge),
                      ),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text('Above', style: theme.typeScale.bodyLarge),
                    const SizedBox(height: 12),
                    divider,
                    const SizedBox(height: 12),
                    Text('Below', style: theme.typeScale.bodyLarge),
                  ],
                ),
        ),
        PlayPreviewCard(
          label: 'Supporting text',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Supporting text', style: theme.typeScale.bodyMedium),
              SizedBox(height: dividerTheme.textGap),
              const M3EDivider(inset: M3EDividerInset.middle),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumSegmented<M3EDividerAxis>(
              label: 'Axis',
              value: _axis,
              values: M3EDividerAxis.values,
              labelOf: (M3EDividerAxis v) => v.name,
              onChanged: (M3EDividerAxis v) => setState(() => _axis = v),
            ),
            PlayEnumSegmented<M3EDividerInset>(
              label: 'Inset',
              value: _inset,
              values: M3EDividerInset.values,
              labelOf: (M3EDividerInset v) => v.name,
              onChanged: (M3EDividerInset v) => setState(() {
                _inset = v;
                _indent = null;
                _endIndent = null;
              }),
            ),
            PlaySlider(
              label: 'Thickness',
              value: _thickness,
              min: 1,
              max: 8,
              divisions: 7,
              onChanged: (double v) => setState(() => _thickness = v),
            ),
            PlaySlider(
              label: 'Indent',
              value: shownIndent,
              min: 0,
              max: 48,
              divisions: 12,
              onChanged: (double v) => setState(() => _indent = v),
            ),
            PlaySlider(
              label: 'End indent',
              value: shownEnd,
              min: 0,
              max: 48,
              divisions: 12,
              onChanged: (double v) => setState(() => _endIndent = v),
            ),
            PlaySwitch(
              label: 'Outer margin',
              value: _outerMargin,
              onChanged: (bool v) => setState(() => _outerMargin = v),
            ),
          ],
        ),
      ],
    );
  }
}
