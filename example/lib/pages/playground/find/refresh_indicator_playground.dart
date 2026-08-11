import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ERefreshIndicator].
class RefreshIndicatorPlayground extends StatefulWidget {
  /// Creates the refresh indicator playground.
  const RefreshIndicatorPlayground({super.key});

  @override
  State<RefreshIndicatorPlayground> createState() =>
      _RefreshIndicatorPlaygroundState();
}

enum _RefreshKind { expressive, contained }

class _RefreshIndicatorPlaygroundState
    extends State<RefreshIndicatorPlayground> {
  _RefreshKind _kind = _RefreshKind.expressive;
  M3ERefreshTriggerMode _trigger = M3ERefreshTriggerMode.onEdge;
  int _refreshCount = 0;

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _refreshCount++);
    }
  }

  Widget _listChild() {
    return ListView.builder(
      primary: false,
      physics: const AlwaysScrollableScrollPhysics(
        parent: NeverScrollableScrollPhysics(),
      ),
      itemCount: 12,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text('Item ${index + 1}'),
        );
      },
    );
  }

  Widget _buildIndicator() {
    final Widget child = _listChild();
    if (_kind == _RefreshKind.contained) {
      return M3ERefreshIndicator.contained(
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        child: child,
      );
    }
    return M3ERefreshIndicator(
      onRefresh: _handleRefresh,
      triggerMode: _trigger,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Pull to refresh (count: $_refreshCount)',
          child: SizedBox(
            height: 200,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: M3EShapes.radiusLarge,
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: ClipRRect(
                borderRadius: M3EShapes.radiusLarge,
                child: _buildIndicator(),
              ),
            ),
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumSegmented<_RefreshKind>(
              label: 'Kind',
              value: _kind,
              values: _RefreshKind.values,
              labelOf: (_RefreshKind v) => v.name,
              onChanged: (_RefreshKind v) => setState(() => _kind = v),
            ),
            PlayEnumSegmented<M3ERefreshTriggerMode>(
              label: 'Trigger',
              value: _trigger,
              values: M3ERefreshTriggerMode.values,
              labelOf: (M3ERefreshTriggerMode v) => v.name,
              onChanged: (M3ERefreshTriggerMode v) {
                setState(() => _trigger = v);
              },
            ),
          ],
        ),
      ],
    );
  }
}
