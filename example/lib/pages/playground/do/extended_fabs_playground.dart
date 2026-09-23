import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EExtendedFab].
class ExtendedFabsPlayground extends StatefulWidget {
  /// Creates the extended FABs playground.
  const ExtendedFabsPlayground({super.key});

  @override
  State<ExtendedFabsPlayground> createState() => _ExtendedFabsPlaygroundState();
}

enum _ExtendedFabDemoLocation {
  endFloat,
  centerFloat,
  startFloat,
  endTop,
  startTop,
}

extension on _ExtendedFabDemoLocation {
  FloatingActionButtonLocation get scaffoldLocation => switch (this) {
    _ExtendedFabDemoLocation.endFloat => FloatingActionButtonLocation.endFloat,
    _ExtendedFabDemoLocation.centerFloat =>
      FloatingActionButtonLocation.centerFloat,
    _ExtendedFabDemoLocation.startFloat =>
      FloatingActionButtonLocation.startFloat,
    _ExtendedFabDemoLocation.endTop => FloatingActionButtonLocation.endTop,
    _ExtendedFabDemoLocation.startTop => FloatingActionButtonLocation.startTop,
  };

  AlignmentGeometry get scaleAlignment => switch (this) {
    _ExtendedFabDemoLocation.endFloat => AlignmentDirectional.bottomEnd,
    _ExtendedFabDemoLocation.centerFloat => Alignment.bottomCenter,
    _ExtendedFabDemoLocation.startFloat => AlignmentDirectional.bottomStart,
    _ExtendedFabDemoLocation.endTop => AlignmentDirectional.topEnd,
    _ExtendedFabDemoLocation.startTop => AlignmentDirectional.topStart,
  };

  String get scaleAlignmentSnippet => switch (this) {
    _ExtendedFabDemoLocation.endFloat => 'AlignmentDirectional.bottomEnd',
    _ExtendedFabDemoLocation.centerFloat => 'Alignment.bottomCenter',
    _ExtendedFabDemoLocation.startFloat => 'AlignmentDirectional.bottomStart',
    _ExtendedFabDemoLocation.endTop => 'AlignmentDirectional.topEnd',
    _ExtendedFabDemoLocation.startTop => 'AlignmentDirectional.topStart',
  };

  String get label => switch (this) {
    _ExtendedFabDemoLocation.endFloat => 'endFloat',
    _ExtendedFabDemoLocation.centerFloat => 'centerFloat',
    _ExtendedFabDemoLocation.startFloat => 'startFloat',
    _ExtendedFabDemoLocation.endTop => 'endTop',
    _ExtendedFabDemoLocation.startTop => 'startTop',
  };
}

class _ExtendedFabsPlaygroundState extends State<ExtendedFabsPlayground> {
  M3EExtendedFabSize _size = M3EExtendedFabSize.small;
  M3EFabColor _color = M3EFabColor.primary;
  _ExtendedFabDemoLocation _location = _ExtendedFabDemoLocation.endFloat;
  bool _extended = true;
  bool _showIcon = true;
  bool _appear = false;
  bool _useTransform = false;
  bool _enabled = true;
  bool _gradient = false;
  String _label = 'Compose';

  List<PlaySnippet> get _snippets {
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Extended FAB',
        code:
            '''
$kPlaySnippetImport
final fabController = M3EExtendedFabController();

M3EExtendedFabScrollVisibility(
  controller: fabController,
  child: Scaffold(
    floatingActionButtonLocation: FloatingActionButtonLocation.${_location.label},
    body: ListView(...),
    floatingActionButton: M3EExtendedFab(
      controller: fabController,
      appear: $_appear,
      scaleAlignment: ${_location.scaleAlignmentSnippet},
      onPressed: ${_enabled ? '() {}' : 'null'},
      ${_showIcon ? 'icon: const Icon(M3EIcons.edit),' : '// icon omitted'}
      label: ${playDartString(_label)},
      size: M3EExtendedFabSize.${_size.name},
      color: M3EFabColor.${_color.name},
      extended: $_extended,${_useTransform ? '''
      openBuilder: (context) => const ComposePage(),''' : ''}
    ),
  ),
);''',
      ),
    ];
  }

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _ExtendedFabDemoHost(
            size: _size,
            color: _color,
            location: _location,
            label: _label,
            showIcon: _showIcon,
            appear: _appear,
            useTransform: _useTransform,
            enabled: _enabled,
            gradient: _gradient,
          );
        },
      ),
    );
  }

  Widget _previewFab({Key? key}) {
    return M3EExtendedFab(
      key: key,
      onPressed: _enabled ? () {} : null,
      icon: _showIcon ? const Icon(M3EIcons.edit) : null,
      label: _label,
      size: _size,
      color: _color,
      extended: _extended,
      appear: _appear,
      scaleAlignment: _location.scaleAlignment,
      decoration: _gradient
          ? M3EFabDecoration(
              backgroundGradient: WidgetStateProperty.all(
                const LinearGradient(
                  colors: <Color>[Color(0xFF006A6A), Color(0xFF4ECDC4)],
                ),
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Extended FAB',
          child: _previewFab(
            key: ValueKey<String>(
              'efab-$_appear-$_size-$_color-$_extended-$_showIcon-$_enabled',
            ),
          ),
        ),
        PlayPreviewCard(
          label: 'Full-screen extended FAB demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a scaffold with scroll collapse/expand, optional appear '
                'morph, and optional container transform. Back dismisses an '
                'open transform first.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open extended FAB demo'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Extended FAB',
          children: <Widget>[
            PlayEnumSegmented<M3EExtendedFabSize>(
              label: 'Size',
              value: _size,
              values: M3EExtendedFabSize.values,
              labelOf: (M3EExtendedFabSize v) => v.name,
              onChanged: (M3EExtendedFabSize v) => setState(() => _size = v),
            ),
            PlayEnumMenu<M3EFabColor>(
              label: 'Color',
              value: _color,
              values: M3EFabColor.values,
              labelOf: (M3EFabColor v) => v.name,
              onChanged: (M3EFabColor v) => setState(() => _color = v),
            ),
            PlayEnumMenu<_ExtendedFabDemoLocation>(
              label: 'Location',
              value: _location,
              values: _ExtendedFabDemoLocation.values,
              labelOf: (_ExtendedFabDemoLocation v) => v.label,
              onChanged: (_ExtendedFabDemoLocation v) =>
                  setState(() => _location = v),
            ),
            PlayTextField(
              label: 'Label',
              value: _label,
              onChanged: (String v) => setState(() => _label = v),
            ),
            PlaySwitch(
              label: 'Show icon',
              value: _showIcon,
              onChanged: (bool v) => setState(() => _showIcon = v),
            ),
            PlaySwitch(
              label: 'Extended',
              value: _extended,
              onChanged: (bool v) => setState(() => _extended = v),
            ),
            PlaySwitch(
              label: 'Enabled',
              value: _enabled,
              onChanged: (bool v) => setState(() => _enabled = v),
            ),
            PlaySwitch(
              label: 'Gradient fill',
              value: _gradient,
              onChanged: (bool v) => setState(() => _gradient = v),
            ),
            PlaySwitch(
              label: 'Appear morph',
              value: _appear,
              onChanged: (bool v) => setState(() => _appear = v),
            ),
            PlaySwitch(
              label: 'Container transform',
              value: _useTransform,
              onChanged: (bool v) => setState(() => _useTransform = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExtendedFabDemoHost extends StatefulWidget {
  const _ExtendedFabDemoHost({
    required this.size,
    required this.color,
    required this.location,
    required this.label,
    required this.showIcon,
    required this.appear,
    required this.useTransform,
    required this.enabled,
    required this.gradient,
  });

  final M3EExtendedFabSize size;
  final M3EFabColor color;
  final _ExtendedFabDemoLocation location;
  final String label;
  final bool showIcon;
  final bool appear;
  final bool useTransform;
  final bool enabled;
  final bool gradient;

  @override
  State<_ExtendedFabDemoHost> createState() => _ExtendedFabDemoHostState();
}

class _ExtendedFabDemoHostState extends State<_ExtendedFabDemoHost> {
  final M3EExtendedFabController _controller = M3EExtendedFabController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3EExtendedFabScrollVisibility(
      controller: _controller,
      child: Scaffold(
        backgroundColor: M3ETheme.of(context).colorScheme.surface,
        appBar: M3EAppBar.top(
          titleText: 'Extended FAB demo',
          leading: M3EIconButton(
            variant: M3EIconButtonVariant.standard,
            icon: const Icon(M3EIcons.arrow_back),
            onPressed: () => Navigator.of(context).maybePop(),
            tooltip: 'Back',
          ),
        ),
        floatingActionButtonLocation: widget.location.scaffoldLocation,
        body: M3ECardList.builder(
          itemCount: 40,
          listPadding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
          itemBuilder: (BuildContext context, int index) {
            return M3EListItem(
              headline: 'Item $index',
              supportingText: 'Scroll to collapse / expand the extended FAB',
              leading: const Icon(M3EIcons.label),
            );
          },
        ),
        floatingActionButton: M3EExtendedFab(
          key: ValueKey<String>(
            'demo-${widget.appear}-${widget.size}-${widget.color}-${widget.location.name}',
          ),
          controller: _controller,
          appear: widget.appear,
          scaleAlignment: widget.location.scaleAlignment,
          size: widget.size,
          color: widget.color,
          icon: widget.showIcon ? const Icon(M3EIcons.edit) : null,
          label: widget.label,
          onPressed: widget.enabled ? () {} : null,
          decoration: widget.gradient
              ? M3EFabDecoration(
                  backgroundGradient: WidgetStateProperty.all(
                    const LinearGradient(
                      colors: <Color>[Color(0xFF006A6A), Color(0xFF4ECDC4)],
                    ),
                  ),
                )
              : null,
          openBuilder: widget.useTransform && widget.enabled
              ? (BuildContext context) {
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
              : null,
        ),
      ),
    );
  }
}
