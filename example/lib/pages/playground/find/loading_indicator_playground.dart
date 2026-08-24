import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ELoadingIndicator].
class LoadingIndicatorPlayground extends StatefulWidget {
  /// Creates the loading indicator playground.
  const LoadingIndicatorPlayground({super.key});

  @override
  State<LoadingIndicatorPlayground> createState() =>
      _LoadingIndicatorPlaygroundState();
}

class _LoadingIndicatorPlaygroundState
    extends State<LoadingIndicatorPlayground> {
  M3ELoadingIndicatorVariant _variant = M3ELoadingIndicatorVariant.defaultStyle;
  double _elevation = 0;

  List<PlaySnippet> get _snippets {
    final String sample =
        '''
M3ELoadingIndicator(
  variant: M3ELoadingIndicatorVariant.${_variant.name},
  elevation: ${_elevation.toStringAsFixed(0)},
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Loading indicator',
        code: '$kPlaySnippetImport\n$sample',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Loading indicator',
          child: Center(
            child: M3ELoadingIndicator(
              variant: _variant,
              elevation: _elevation,
            ),
          ),
        ),
        PlayPreviewCard(
          label: 'Both variants',
          child: Wrap(
            spacing: 24,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              M3ELoadingIndicator(elevation: _elevation),
              M3ELoadingIndicator(
                variant: M3ELoadingIndicatorVariant.contained,
                elevation: _elevation,
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumSegmented<M3ELoadingIndicatorVariant>(
              label: 'Variant',
              value: _variant,
              values: M3ELoadingIndicatorVariant.values,
              labelOf: (M3ELoadingIndicatorVariant v) => v.name,
              onChanged: (M3ELoadingIndicatorVariant v) {
                setState(() => _variant = v);
              },
            ),
            PlaySlider(
              label: 'Elevation',
              value: _elevation,
              min: 0,
              max: 12,
              divisions: 12,
              onChanged: (double v) => setState(() => _elevation = v),
            ),
          ],
        ),
      ],
    );
  }
}
