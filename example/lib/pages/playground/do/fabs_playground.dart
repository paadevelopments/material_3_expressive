import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3EFab].
class FabsPlayground extends PlaygroundWidget {
  /// Creates the FABs playground.
  const FabsPlayground({super.key});

  @override
  PlaygroundState<FabsPlayground> createState() => _FabsPlaygroundState();
}

/// Scaffold FAB locations offered by the playground.
enum FabDemoLocation {
  /// Bottom end.
  endFloat,

  /// Bottom center.
  centerFloat,

  /// Bottom start.
  startFloat,

  /// Top end.
  endTop,

  /// Top start.
  startTop;

  /// Scaffold location.
  FloatingActionButtonLocation get scaffoldLocation => switch (this) {
    endFloat => FloatingActionButtonLocation.endFloat,
    centerFloat => FloatingActionButtonLocation.centerFloat,
    startFloat => FloatingActionButtonLocation.startFloat,
    endTop => FloatingActionButtonLocation.endTop,
    startTop => FloatingActionButtonLocation.startTop,
  };

  /// Matching scale origin.
  AlignmentGeometry get scaleAlignment => switch (this) {
    endFloat => AlignmentDirectional.bottomEnd,
    centerFloat => Alignment.bottomCenter,
    startFloat => AlignmentDirectional.bottomStart,
    endTop => AlignmentDirectional.topEnd,
    startTop => AlignmentDirectional.topStart,
  };

  /// [scaleAlignment] as Dart source.
  String get scaleAlignmentSnippet => switch (this) {
    endFloat => 'AlignmentDirectional.bottomEnd',
    centerFloat => 'Alignment.bottomCenter',
    startFloat => 'AlignmentDirectional.bottomStart',
    endTop => 'AlignmentDirectional.topEnd',
    startTop => 'AlignmentDirectional.topStart',
  };
}

class _FabsPlaygroundState extends PlaygroundState<FabsPlayground> {
  final M3EFabController _controller = M3EFabController();

  M3EFabSize _size = M3EFabSize.medium;
  M3EFabColor _color = M3EFabColor.primary;
  FabDemoLocation _location = FabDemoLocation.endFloat;
  bool _appear = false;
  bool _scrollVisibility = true;
  bool _useTransform = false;
  bool _enabled = true;
  bool _gradient = false;
  bool _customRadius = false;
  double _cornerRadius = 16;
  bool _tooltip = true;
  String _tooltipText = 'Add';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    final Widget list = M3EList.scrollable(
      controller: PrimaryScrollController.of(context),
      color: M3ETheme.of(context).colorScheme.surfaceContainerHighest,
      itemCount: 30,
      listPadding: padding.copyWith(bottom: padding.bottom + 88),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Item ${index + 1}',
          supportingText: _scrollVisibility
              ? 'Scroll to hide and show the FAB'
              : 'Content under the FAB',
          leading: const Icon(M3EIcons.label),
        );
      },
    );
    if (!_scrollVisibility) {
      return list;
    }
    return M3EFabScrollVisibility(controller: _controller, child: list);
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    return PlaygroundSlots(
      floatingActionButtonLocation: _location.scaffoldLocation,
      floatingActionButton: M3EFab(
        // Rebuilds replay the appear morph.
        key: ValueKey<String>('fab-$_appear-${_location.name}'),
        controller: _scrollVisibility ? _controller : null,
        appear: _appear,
        scaleAlignment: _location.scaleAlignment,
        size: _size,
        color: _color,
        cornerRadius: _customRadius ? _cornerRadius : null,
        icon: const Icon(M3EIcons.add),
        tooltip: _tooltip ? _tooltipText : null,
        onPressed: _enabled ? () {} : null,
        decoration: _gradient
            ? M3EFabDecoration(
                backgroundGradient: WidgetStateProperty.all(
                  const LinearGradient(
                    colors: <Color>[Color(0xFF006A6A), Color(0xFF4ECDC4)],
                  ),
                ),
              )
            : null,
        openBuilder: _useTransform && _enabled ? _composePage : null,
      ),
    );
  }

  Widget _composePage(BuildContext context) {
    return Scaffold(
      backgroundColor: M3ETheme.of(context).colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: 'Compose',
        leading: M3EIconButton(
          variant: M3EIconButtonVariant.standard,
          icon: const Icon(M3EIcons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
      ),
      body: const Center(child: Text('Container transform')),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer fab = StringBuffer();
    if (_scrollVisibility) {
      fab.writeln('      controller: fabController,');
    }
    fab
      ..writeln('      appear: $_appear,')
      ..writeln('      scaleAlignment: ${_location.scaleAlignmentSnippet},')
      ..writeln('      onPressed: ${_enabled ? '() {}' : 'null'},')
      ..writeln('      icon: const Icon(M3EIcons.add),')
      ..writeln('      size: M3EFabSize.${_size.name},')
      ..writeln('      color: M3EFabColor.${_color.name},');
    if (_customRadius) {
      fab.writeln('      cornerRadius: ${_cornerRadius.round()},');
    }
    if (_tooltip) {
      fab.writeln('      tooltip: ${playDartString(_tooltipText)},');
    }
    if (_gradient) {
      fab.writeln(
        '      decoration: M3EFabDecoration(\n'
        '        backgroundGradient: WidgetStateProperty.all(gradient),\n'
        '      ),',
      );
    }
    if (_useTransform && _enabled) {
      fab.writeln('      openBuilder: (context) => const ComposePage(),');
    }
    final String body = _scrollVisibility
        ? 'M3EFabScrollVisibility(\n'
              '    controller: fabController,\n'
              '    child: ListView(...),\n'
              '  )'
        : 'ListView(...)';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'FAB',
        code:
            '''
$kPlaySnippetImport
${_scrollVisibility ? '\nfinal fabController = M3EFabController();\n' : ''}
Scaffold(
  floatingActionButtonLocation:
      FloatingActionButtonLocation.${_location.name},
  body: $body,
  floatingActionButton: M3EFab(
$fab  ),
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3EFabSize>(
            label: 'Size',
            value: _size,
            values: M3EFabSize.values,
            labelOf: (M3EFabSize v) => v.name,
            onChanged: (M3EFabSize v) => setState(() => _size = v),
          ),
          PlayEnumChoice<M3EFabColor>(
            label: 'Color',
            value: _color,
            values: M3EFabColor.values,
            labelOf: (M3EFabColor v) => v.name,
            onChanged: (M3EFabColor v) => setState(() => _color = v),
          ),
          PlaySwitchItem(
            label: 'Gradient fill',
            value: _gradient,
            onChanged: (bool v) => setState(() => _gradient = v),
          ),
          PlaySwitchItem(
            label: 'Custom corner radius',
            value: _customRadius,
            onChanged: (bool v) => setState(() => _customRadius = v),
          ),
          if (_customRadius)
            PlaySlider(
              label: 'Corner radius',
              value: _cornerRadius,
              max: 48,
              divisions: 48,
              onChanged: (double v) => setState(() => _cornerRadius = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Placement',
        children: <Widget>[
          PlayEnumChoice<FabDemoLocation>(
            label: 'Location',
            value: _location,
            values: FabDemoLocation.values,
            labelOf: (FabDemoLocation v) => v.name,
            onChanged: (FabDemoLocation v) => setState(() => _location = v),
          ),
          PlaySwitchItem(
            label: 'Hide on scroll',
            description: 'Scroll the list to hide and show the FAB',
            value: _scrollVisibility,
            onChanged: (bool v) => setState(() => _scrollVisibility = v),
          ),
          PlaySwitchItem(
            label: 'Appear morph',
            description: 'Toggle to replay the entrance',
            value: _appear,
            onChanged: (bool v) => setState(() => _appear = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Behavior',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Enabled',
            value: _enabled,
            onChanged: (bool v) => setState(() => _enabled = v),
          ),
          if (_enabled)
            PlaySwitchItem(
              label: 'Container transform',
              description: 'Pressing opens a page from the FAB',
              value: _useTransform,
              onChanged: (bool v) => setState(() => _useTransform = v),
            ),
          PlaySwitchItem(
            label: 'Tooltip',
            value: _tooltip,
            onChanged: (bool v) => setState(() => _tooltip = v),
          ),
          if (_tooltip)
            PlayTextField(
              label: 'Tooltip text',
              value: _tooltipText,
              onChanged: (String v) => setState(() => _tooltipText = v),
            ),
        ],
      ),
    ];
  }
}
