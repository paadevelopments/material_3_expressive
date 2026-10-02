import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';
import 'fabs_playground.dart' show FabDemoLocation;

/// Live playground for [M3EExtendedFab].
class ExtendedFabsPlayground extends PlaygroundWidget {
  /// Creates the extended FABs playground.
  const ExtendedFabsPlayground({super.key});

  @override
  PlaygroundState<ExtendedFabsPlayground> createState() =>
      _ExtendedFabsPlaygroundState();
}

class _ExtendedFabsPlaygroundState
    extends PlaygroundState<ExtendedFabsPlayground> {
  final M3EExtendedFabController _controller = M3EExtendedFabController();

  M3EExtendedFabSize _size = M3EExtendedFabSize.small;
  M3EFabColor _color = M3EFabColor.primary;
  FabDemoLocation _location = FabDemoLocation.endFloat;
  bool _extended = true;
  bool _collapseOnScroll = true;
  bool _showIcon = true;
  bool _appear = false;
  bool _useTransform = false;
  bool _enabled = true;
  bool _gradient = false;
  String _label = 'Compose';

  /// Collapsing needs an icon to collapse to.
  bool get _canCollapse => _showIcon;

  bool get _scrollDriven => _canCollapse && _collapseOnScroll;

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
          supportingText: _scrollDriven
              ? 'Scroll to collapse and expand the FAB'
              : 'Content under the FAB',
          leading: const Icon(M3EIcons.label),
        );
      },
    );
    if (!_scrollDriven) {
      return list;
    }
    return M3EExtendedFabScrollVisibility(controller: _controller, child: list);
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    return PlaygroundSlots(
      floatingActionButtonLocation: _location.scaffoldLocation,
      floatingActionButton: M3EExtendedFab(
        // Rebuilds replay the appear morph.
        key: ValueKey<String>('xfab-$_appear-${_location.name}-$_scrollDriven'),
        controller: _scrollDriven ? _controller : null,
        appear: _appear,
        scaleAlignment: _location.scaleAlignment,
        size: _size,
        color: _color,
        extended: !_canCollapse || _scrollDriven || _extended,
        icon: _showIcon ? const Icon(M3EIcons.edit) : null,
        label: _label,
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
    if (_scrollDriven) {
      fab.writeln('      controller: fabController,');
    }
    fab
      ..writeln('      appear: $_appear,')
      ..writeln('      scaleAlignment: ${_location.scaleAlignmentSnippet},')
      ..writeln('      onPressed: ${_enabled ? '() {}' : 'null'},');
    if (_showIcon) {
      fab.writeln('      icon: const Icon(M3EIcons.edit),');
    }
    fab
      ..writeln('      label: ${playDartString(_label)},')
      ..writeln('      size: M3EExtendedFabSize.${_size.name},')
      ..writeln('      color: M3EFabColor.${_color.name},');
    if (_canCollapse && !_scrollDriven) {
      fab.writeln('      extended: $_extended,');
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
    final String body = _scrollDriven
        ? 'M3EExtendedFabScrollVisibility(\n'
              '    controller: fabController,\n'
              '    child: ListView(...),\n'
              '  )'
        : 'ListView(...)';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Extended FAB',
        code:
            '''
$kPlaySnippetImport
${_scrollDriven ? '\nfinal fabController = M3EExtendedFabController();\n' : ''}
Scaffold(
  floatingActionButtonLocation:
      FloatingActionButtonLocation.${_location.name},
  body: $body,
  floatingActionButton: M3EExtendedFab(
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
          PlayEnumChoice<M3EExtendedFabSize>(
            label: 'Size',
            value: _size,
            values: M3EExtendedFabSize.values,
            labelOf: (M3EExtendedFabSize v) => v.name,
            onChanged: (M3EExtendedFabSize v) => setState(() => _size = v),
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
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlayTextField(
            label: 'Label',
            value: _label,
            onChanged: (String v) => setState(() => _label = v),
          ),
          PlaySwitchItem(
            label: 'Show icon',
            description: 'Needed to collapse to an icon',
            value: _showIcon,
            onChanged: (bool v) => setState(() => _showIcon = v),
          ),
          if (_canCollapse) ...<Widget>[
            PlaySwitchItem(
              label: 'Collapse on scroll',
              description: 'Scroll the list to collapse and expand',
              value: _collapseOnScroll,
              onChanged: (bool v) => setState(() => _collapseOnScroll = v),
            ),
            if (!_collapseOnScroll)
              PlaySwitchItem(
                label: 'Extended',
                description: 'Show the label next to the icon',
                value: _extended,
                onChanged: (bool v) => setState(() => _extended = v),
              ),
          ],
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
        ],
      ),
    ];
  }
}
