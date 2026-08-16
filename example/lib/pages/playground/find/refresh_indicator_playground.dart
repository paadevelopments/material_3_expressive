import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
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

enum _RefreshKind { expressive, contained, material, adaptive, noSpinner }

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
    return M3ECardList.builder(
      itemCount: 12,
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      listPadding: const EdgeInsets.all(8),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Item ${index + 1}',
          supportingText: 'Pull down to refresh',
          leading: const Icon(M3EIcons.refresh),
        );
      },
    );
  }

  Widget _buildIndicator() {
    final Key key = ValueKey<_RefreshKind>(_kind);
    final Widget child = _listChild();
    return switch (_kind) {
      _RefreshKind.expressive => M3ERefreshIndicator(
        key: key,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        child: child,
      ),
      _RefreshKind.contained => M3ERefreshIndicator.contained(
        key: key,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        child: child,
      ),
      _RefreshKind.material => M3ERefreshIndicator.material(
        key: key,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        child: child,
      ),
      _RefreshKind.adaptive => M3ERefreshIndicator.adaptive(
        key: key,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        child: child,
      ),
      _RefreshKind.noSpinner => M3ERefreshIndicator.noSpinner(
        key: key,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        child: child,
      ),
    };
  }

  List<PlaySnippet> get _snippets {
    final String ctor = switch (_kind) {
      _RefreshKind.expressive => 'M3ERefreshIndicator',
      _RefreshKind.contained => 'M3ERefreshIndicator.contained',
      _RefreshKind.material => 'M3ERefreshIndicator.material',
      _RefreshKind.adaptive => 'M3ERefreshIndicator.adaptive',
      _RefreshKind.noSpinner => 'M3ERefreshIndicator.noSpinner',
    };
    final String sample =
        '''
$ctor(
  onRefresh: () async {},
  triggerMode: M3ERefreshTriggerMode.${_trigger.name},
  child: ListView(),
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Pull to refresh',
        code: '$kPlaySnippetImport\n$sample',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Pull to refresh (count: $_refreshCount)',
          child: SizedBox(
            height: 280,
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
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumMenu<_RefreshKind>(
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
