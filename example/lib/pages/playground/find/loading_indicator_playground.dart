import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
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

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Loading indicator',
          child: Center(child: M3ELoadingIndicator(variant: _variant)),
        ),
        PlayPreviewCard(
          label: 'Both variants',
          child: Wrap(
            spacing: 24,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: const <Widget>[
              M3ELoadingIndicator(),
              M3ELoadingIndicator(
                variant: M3ELoadingIndicatorVariant.contained,
              ),
            ],
          ),
        ),
      ],
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
          ],
        ),
      ],
    );
  }
}
