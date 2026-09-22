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
  double _indicatorSize = 38;
  double _containerWidth = 48;
  double _containerHeight = 48;
  bool _multicolor = false;

  List<PlaySnippet> get _snippets {
    final String colorsLine = _multicolor
        ? '\n  indicatorColors: const [Color(0xff6750a4), Color(0xff006a6a)],'
        : '';
    final String sample =
        '''
M3ELoadingIndicator(
  variant: M3ELoadingIndicatorVariant.${_variant.name},
  indicatorSize: ${_indicatorSize.toStringAsFixed(0)},
  containerWidth: ${_containerWidth.toStringAsFixed(0)},
  containerHeight: ${_containerHeight.toStringAsFixed(0)},$colorsLine
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
              indicatorSize: _indicatorSize,
              containerWidth: _containerWidth,
              containerHeight: _containerHeight,
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
                indicatorSize: _indicatorSize,
                containerWidth: _containerWidth,
                containerHeight: _containerHeight,
                indicatorColors: _multicolor
                    ? const <Color>[Color(0xff6750a4), Color(0xff006a6a)]
                    : null,
              ),
              M3ELoadingIndicator(
                variant: M3ELoadingIndicatorVariant.contained,
                indicatorSize: _indicatorSize,
                containerWidth: _containerWidth,
                containerHeight: _containerHeight,
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
              label: 'Indicator size',
              value: _indicatorSize,
              min: 16,
              max: 48,
              divisions: 16,
              onChanged: (double v) => setState(() => _indicatorSize = v),
            ),
            PlaySlider(
              label: 'Container width',
              value: _containerWidth,
              min: 40,
              max: 96,
              divisions: 14,
              onChanged: (double v) => setState(() => _containerWidth = v),
            ),
            PlaySlider(
              label: 'Container height',
              value: _containerHeight,
              min: 40,
              max: 96,
              divisions: 14,
              onChanged: (double v) => setState(() => _containerHeight = v),
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
