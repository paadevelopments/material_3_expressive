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
  double _size = 48;
  bool _multicolor = false;

  List<PlaySnippet> get _snippets {
    final String colorsLine = _multicolor
        ? '\n  indicatorColors: const [Color(0xff6750a4), Color(0xff006a6a)],'
        : '';
    final String sample =
        '''
M3ELoadingIndicator(
  variant: M3ELoadingIndicatorVariant.${_variant.name},
  size: ${_size.toStringAsFixed(0)},$colorsLine
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
              size: _size,
              indicatorColors: _multicolor
                  ? const <Color>[Color(0xff6750a4), Color(0xff006a6a)]
                  : null,
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
              M3ELoadingIndicator(
                size: _size,
                indicatorColors: _multicolor
                    ? const <Color>[Color(0xff6750a4), Color(0xff006a6a)]
                    : null,
              ),
              M3ELoadingIndicator(
                variant: M3ELoadingIndicatorVariant.contained,
                size: _size,
                indicatorColors: _multicolor
                    ? const <Color>[Color(0xff6750a4), Color(0xff006a6a)]
                    : null,
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
              label: 'Size (outer, 24–240)',
              value: _size,
              min: M3ELoadingIndicatorTheme.minSize,
              max: M3ELoadingIndicatorTheme.maxSize,
              divisions: 54,
              onChanged: (double v) => setState(() => _size = v),
            ),
            PlayEnumSegmented<bool>(
              label: 'Multicolor',
              value: _multicolor,
              values: const <bool>[false, true],
              labelOf: (bool value) => value ? 'On' : 'Off',
              onChanged: (bool value) => setState(() => _multicolor = value),
            ),
          ],
        ),
      ],
    );
  }
}
