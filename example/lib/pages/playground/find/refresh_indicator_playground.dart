import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ERefreshIndicator.contained].
class RefreshIndicatorPlayground extends StatefulWidget {
  /// Creates the refresh indicator playground.
  const RefreshIndicatorPlayground({super.key});

  @override
  State<RefreshIndicatorPlayground> createState() =>
      _RefreshIndicatorPlaygroundState();
}

class _RefreshIndicatorPlaygroundState
    extends State<RefreshIndicatorPlayground> {
  M3ERefreshTriggerMode _trigger = M3ERefreshTriggerMode.onEdge;
  bool _elevation = true;

  List<PlaySnippet> get _snippets {
    final String elevationLine = _elevation ? '' : '\n  elevation: 0,';
    final String sample =
        '''
final controller = M3ERefreshIndicatorController();

M3ERefreshIndicator.contained(
  controller: controller,
  onRefresh: () async {},
  triggerMode: M3ERefreshTriggerMode.${_trigger.name},$elevationLine
  child: ListView(),
);

// Manual trigger:
await controller.show();''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Pull to refresh',
        code: '$kPlaySnippetImport\n$sample',
      ),
    ];
  }

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _RefreshDemoHost(trigger: _trigger, elevation: _elevation);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Refresh indicator demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a full list you can pull to refresh. The app bar '
                'action starts a refresh without pulling.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open refresh demo'),
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
            PlaySwitch(
              label: 'Elevation',
              value: _elevation,
              onChanged: (bool v) => setState(() => _elevation = v),
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

class _RefreshDemoHost extends StatefulWidget {
  const _RefreshDemoHost({required this.trigger, required this.elevation});

  final M3ERefreshTriggerMode trigger;
  final bool elevation;

  @override
  State<_RefreshDemoHost> createState() => _RefreshDemoHostState();
}

class _RefreshDemoHostState extends State<_RefreshDemoHost> {
  final M3ERefreshIndicatorController _controller =
      M3ERefreshIndicatorController();
  int _refreshCount = 0;

  double get _resolvedElevation =>
      widget.elevation ? M3ERefreshIndicatorTheme.kDefaultElevation : 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _refreshCount++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: 'Refresh ($_refreshCount)',
        leading: M3EIconButton(
          variant: M3EIconButtonVariant.standard,
          icon: const Icon(M3EIcons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: <Widget>[
          M3EIconButton(
            variant: M3EIconButtonVariant.standard,
            icon: const Icon(M3EIcons.refresh),
            tooltip: 'Trigger refresh',
            onPressed: () => _controller.show(),
          ),
        ],
      ),
      body: M3ERefreshIndicator.contained(
        controller: _controller,
        onRefresh: _handleRefresh,
        triggerMode: widget.trigger,
        elevation: _resolvedElevation,
        child: M3ECardList.builder(
          itemCount: 16,
          physics: const AlwaysScrollableScrollPhysics(),
          listPadding: const EdgeInsets.all(16),
          itemBuilder: (BuildContext context, int index) {
            return M3EListItem(
              headline: 'Item ${index + 1}',
              supportingText: 'Pull down to refresh',
              leading: const Icon(M3EIcons.refresh),
            );
          },
        ),
      ),
    );
  }
}
