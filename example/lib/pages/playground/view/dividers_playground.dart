import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
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
  double _thickness = 1;
  double _indent = 0;
  double _endIndent = 0;

  List<PlaySnippet> get _snippets {
    String n(double v) => v == v.roundToDouble() ? '${v.toInt()}' : '$v';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Divider',
        code:
            '''
$kPlaySnippetImport

M3EDivider(
  axis: M3EDividerAxis.${_axis.name},
  thickness: ${n(_thickness)},
  indent: ${n(_indent)},
  endIndent: ${n(_endIndent)},
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final bool vertical = _axis == M3EDividerAxis.vertical;
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
                      M3EDivider(
                        axis: _axis,
                        thickness: _thickness,
                        indent: _indent,
                        endIndent: _endIndent,
                      ),
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
                    M3EDivider(
                      axis: _axis,
                      thickness: _thickness,
                      indent: _indent,
                      endIndent: _endIndent,
                    ),
                    const SizedBox(height: 12),
                    Text('Below', style: theme.typeScale.bodyLarge),
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
              value: _indent,
              min: 0,
              max: 48,
              divisions: 12,
              onChanged: (double v) => setState(() => _indent = v),
            ),
            PlaySlider(
              label: 'End indent',
              value: _endIndent,
              min: 0,
              max: 48,
              divisions: 12,
              onChanged: (double v) => setState(() => _endIndent = v),
            ),
          ],
        ),
      ],
    );
  }
}
