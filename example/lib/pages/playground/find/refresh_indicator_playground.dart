import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Refresh indicator constructors.
enum _RefreshKind { expressive, contained, material, adaptive, noSpinner }

/// Live playground for [M3ERefreshIndicator].
class RefreshIndicatorPlayground extends PlaygroundWidget {
  /// Creates the refresh indicator playground.
  const RefreshIndicatorPlayground({super.key});

  @override
  PlaygroundState<RefreshIndicatorPlayground> createState() =>
      _RefreshIndicatorPlaygroundState();
}

class _RefreshIndicatorPlaygroundState
    extends PlaygroundState<RefreshIndicatorPlayground> {
  final M3ERefreshIndicatorController _controller =
      M3ERefreshIndicatorController();

  _RefreshKind _kind = _RefreshKind.contained;
  M3ERefreshTriggerMode _trigger = M3ERefreshTriggerMode.onEdge;
  bool _elevation = true;
  double _displacement = M3ERefreshIndicatorTheme.kDefaultDisplacement;
  double _strokeWidth = 2.5;
  bool _tertiary = false;
  double _seconds = 2;
  int _refreshCount = 0;

  bool get _hasSpinner => _kind != _RefreshKind.noSpinner;

  bool get _hasStroke =>
      _kind == _RefreshKind.material || _kind == _RefreshKind.adaptive;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await Future<void>.delayed(
      Duration(milliseconds: (_seconds * 1000).round()),
    );
    if (mounted) {
      setState(() => _refreshCount++);
    }
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    final Widget list = M3EList.scrollable(
      controller: PrimaryScrollController.of(context),
      color: scheme.surfaceContainerHighest,
      itemCount: 16,
      physics: const AlwaysScrollableScrollPhysics(),
      listPadding: padding,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Item ${index + 1}',
          supportingText: 'Pull down to refresh',
          leading: const Icon(M3EIcons.refresh),
        );
      },
    );
    final double elevation = _elevation
        ? M3ERefreshIndicatorTheme.kDefaultElevation
        : 0;
    final Color? color = _tertiary ? scheme.onTertiaryContainer : null;
    final Color? background = _tertiary ? scheme.tertiaryContainer : null;
    // The indicator drops in below the floating controls banner.
    final double edgeOffset = padding.top - 16;
    return switch (_kind) {
      _RefreshKind.expressive => M3ERefreshIndicator(
        controller: _controller,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        elevation: elevation,
        displacement: _displacement,
        edgeOffset: edgeOffset,
        color: color,
        backgroundColor: background,
        child: list,
      ),
      _RefreshKind.contained => M3ERefreshIndicator.contained(
        controller: _controller,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        elevation: elevation,
        displacement: _displacement,
        edgeOffset: edgeOffset,
        color: color,
        backgroundColor: background,
        child: list,
      ),
      _RefreshKind.material => M3ERefreshIndicator.material(
        controller: _controller,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        elevation: elevation,
        displacement: _displacement,
        edgeOffset: edgeOffset,
        strokeWidth: _strokeWidth,
        color: color,
        backgroundColor: background,
        child: list,
      ),
      _RefreshKind.adaptive => M3ERefreshIndicator.adaptive(
        controller: _controller,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        elevation: elevation,
        displacement: _displacement,
        edgeOffset: edgeOffset,
        strokeWidth: _strokeWidth,
        color: color,
        backgroundColor: background,
        child: list,
      ),
      _RefreshKind.noSpinner => M3ERefreshIndicator.noSpinner(
        controller: _controller,
        onRefresh: _handleRefresh,
        triggerMode: _trigger,
        elevation: elevation,
        child: list,
      ),
    };
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    return PlaygroundSlots(
      appBar: M3EAppBar.top(
        titleText: 'Refreshed $_refreshCount×',
        leading: chrome.leading,
        actions: <Widget>[
          M3EIconButton(
            variant: M3EIconButtonVariant.standard,
            icon: const Icon(M3EIcons.refresh),
            tooltip: 'Refresh',
            onPressed: () => _controller.show(),
          ),
          ...chrome.trailingActions,
        ],
      ),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final String ctor = switch (_kind) {
      _RefreshKind.expressive => 'M3ERefreshIndicator',
      _ => 'M3ERefreshIndicator.${_kind.name}',
    };
    final StringBuffer args = StringBuffer()
      ..writeln('  controller: controller,')
      ..writeln('  onRefresh: () async {},')
      ..writeln('  triggerMode: M3ERefreshTriggerMode.${_trigger.name},');
    if (!_elevation) {
      args.writeln('  elevation: 0,');
    }
    if (_hasSpinner) {
      args.writeln('  displacement: ${_displacement.round()},');
      if (_tertiary) {
        args
          ..writeln('  color: scheme.onTertiaryContainer,')
          ..writeln('  backgroundColor: scheme.tertiaryContainer,');
      }
    }
    if (_hasStroke) {
      args.writeln('  strokeWidth: ${_strokeWidth.toStringAsFixed(1)},');
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Pull to refresh',
        code:
            '''
$kPlaySnippetImport

final controller = M3ERefreshIndicatorController();

$ctor(
$args  child: ListView(...),
);

// Refresh without pulling:
await controller.show();''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_RefreshKind>(
            label: 'Indicator',
            value: _kind,
            values: _RefreshKind.values,
            labelOf: (_RefreshKind v) => switch (v) {
              _RefreshKind.expressive => 'expressive',
              _RefreshKind.contained => 'contained',
              _RefreshKind.material => 'material',
              _RefreshKind.adaptive => 'adaptive (platform)',
              _RefreshKind.noSpinner => 'no spinner',
            },
            onChanged: (_RefreshKind v) => setState(() => _kind = v),
          ),
          PlayEnumChoice<M3ERefreshTriggerMode>(
            label: 'Trigger',
            value: _trigger,
            values: M3ERefreshTriggerMode.values,
            labelOf: (M3ERefreshTriggerMode v) => v.name,
            onChanged: (M3ERefreshTriggerMode v) =>
                setState(() => _trigger = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Elevation',
            value: _elevation,
            onChanged: (bool v) => setState(() => _elevation = v),
          ),
          if (_hasSpinner) ...<Widget>[
            PlaySwitchItem(
              label: 'Tertiary colors',
              value: _tertiary,
              onChanged: (bool v) => setState(() => _tertiary = v),
            ),
            PlaySlider(
              label: 'Displacement',
              value: _displacement,
              max: 80,
              divisions: 40,
              onChanged: (double v) => setState(() => _displacement = v),
            ),
          ],
          if (_hasStroke)
            PlaySlider(
              label: 'Stroke width',
              value: _strokeWidth,
              min: 1,
              max: 6,
              divisions: 10,
              onChanged: (double v) => setState(() => _strokeWidth = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Demo',
        children: <Widget>[
          PlaySlider(
            label: 'Refresh duration (s)',
            value: _seconds,
            min: 0.5,
            max: 5,
            divisions: 9,
            onChanged: (double v) => setState(() => _seconds = v),
          ),
        ],
      ),
    ];
  }
}
