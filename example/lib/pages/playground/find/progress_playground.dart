import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EProgressIndicator].
class ProgressPlayground extends StatefulWidget {
  /// Creates the progress playground.
  const ProgressPlayground({super.key});

  @override
  State<ProgressPlayground> createState() => _ProgressPlaygroundState();
}

enum _ProgressKind { circular, circularWavy, linear, linearWavy }

class _ProgressPlaygroundState extends State<ProgressPlayground> {
  _ProgressKind _kind = _ProgressKind.linear;
  bool _determinate = true;
  double _value = 0.6;
  M3EProgressIndicatorSize _linearSize = M3EProgressIndicatorSize.m;

  double? get _progress => _determinate ? _value : null;

  Widget _buildIndicator() {
    return switch (_kind) {
      _ProgressKind.circular => M3EProgressIndicator.circular(value: _progress),
      _ProgressKind.circularWavy => M3EProgressIndicator.circularWavy(
        value: _progress,
      ),
      _ProgressKind.linear => SizedBox(
        width: 220,
        child: M3EProgressIndicator.linear(
          value: _progress,
          linearSize: _linearSize,
        ),
      ),
      _ProgressKind.linearWavy => SizedBox(
        width: 220,
        child: M3EProgressIndicator.linearWavy(
          value: _progress,
          linearSize: _linearSize,
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final bool isLinear =
        _kind == _ProgressKind.linear || _kind == _ProgressKind.linearWavy;
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: _kind.name,
          child: Center(child: _buildIndicator()),
        ),
        PlayPreviewCard(
          label: 'All styles',
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              M3EProgressIndicator.circular(value: _progress),
              M3EProgressIndicator.circularWavy(value: _progress),
              SizedBox(
                width: 160,
                child: M3EProgressIndicator.linear(value: _progress),
              ),
              SizedBox(
                width: 160,
                child: M3EProgressIndicator.linearWavy(value: _progress),
              ),
            ],
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumMenu<_ProgressKind>(
              label: 'Kind',
              value: _kind,
              values: _ProgressKind.values,
              labelOf: (_ProgressKind v) => v.name,
              onChanged: (_ProgressKind v) => setState(() => _kind = v),
            ),
            if (isLinear)
              PlayEnumSegmented<M3EProgressIndicatorSize>(
                label: 'Linear size',
                value: _linearSize,
                values: M3EProgressIndicatorSize.values,
                labelOf: (M3EProgressIndicatorSize v) => v.name,
                onChanged: (M3EProgressIndicatorSize v) {
                  setState(() => _linearSize = v);
                },
              ),
            PlaySwitch(
              label: 'Determinate',
              value: _determinate,
              onChanged: (bool v) => setState(() => _determinate = v),
            ),
            if (_determinate)
              PlaySlider(
                label: 'Value',
                value: _value,
                onChanged: (double v) => setState(() => _value = v),
              ),
          ],
        ),
      ],
    );
  }
}
