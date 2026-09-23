import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EFab].
class FabsPlayground extends StatefulWidget {
  /// Creates the FABs playground.
  const FabsPlayground({super.key});

  @override
  State<FabsPlayground> createState() => _FabsPlaygroundState();
}

enum _FabDemoLocation { endFloat, centerFloat, startFloat, endTop, startTop }

extension on _FabDemoLocation {
  FloatingActionButtonLocation get scaffoldLocation => switch (this) {
    _FabDemoLocation.endFloat => FloatingActionButtonLocation.endFloat,
    _FabDemoLocation.centerFloat => FloatingActionButtonLocation.centerFloat,
    _FabDemoLocation.startFloat => FloatingActionButtonLocation.startFloat,
    _FabDemoLocation.endTop => FloatingActionButtonLocation.endTop,
    _FabDemoLocation.startTop => FloatingActionButtonLocation.startTop,
  };

  AlignmentGeometry get scaleAlignment => switch (this) {
    _FabDemoLocation.endFloat => AlignmentDirectional.bottomEnd,
    _FabDemoLocation.centerFloat => Alignment.bottomCenter,
    _FabDemoLocation.startFloat => AlignmentDirectional.bottomStart,
    _FabDemoLocation.endTop => AlignmentDirectional.topEnd,
    _FabDemoLocation.startTop => AlignmentDirectional.topStart,
  };

  String get scaleAlignmentSnippet => switch (this) {
    _FabDemoLocation.endFloat => 'AlignmentDirectional.bottomEnd',
    _FabDemoLocation.centerFloat => 'Alignment.bottomCenter',
    _FabDemoLocation.startFloat => 'AlignmentDirectional.bottomStart',
    _FabDemoLocation.endTop => 'AlignmentDirectional.topEnd',
    _FabDemoLocation.startTop => 'AlignmentDirectional.topStart',
  };

  String get label => switch (this) {
    _FabDemoLocation.endFloat => 'endFloat',
    _FabDemoLocation.centerFloat => 'centerFloat',
    _FabDemoLocation.startFloat => 'startFloat',
    _FabDemoLocation.endTop => 'endTop',
    _FabDemoLocation.startTop => 'startTop',
  };
}

class _FabsPlaygroundState extends State<FabsPlayground> {
  M3EFabSize _size = M3EFabSize.medium;
  M3EFabColor _color = M3EFabColor.primary;
  _FabDemoLocation _location = _FabDemoLocation.endFloat;
  bool _appear = false;
  bool _useTransform = false;
  bool _enabled = true;
  bool _gradient = false;

  List<PlaySnippet> get _snippets {
    return <PlaySnippet>[
      PlaySnippet(
        label: 'FAB',
        code:
            '''
$kPlaySnippetImport
final fabController = M3EFabController();

M3EFabScrollVisibility(
  controller: fabController,
  child: Scaffold(
    floatingActionButtonLocation: FloatingActionButtonLocation.${_location.label},
    body: ListView(...),
    floatingActionButton: M3EFab(
      controller: fabController,
      appear: $_appear,
      scaleAlignment: ${_location.scaleAlignmentSnippet},
      onPressed: ${_enabled ? '() {}' : 'null'},
      icon: const Icon(M3EIcons.add),
      size: M3EFabSize.${_size.name},
      color: M3EFabColor.${_color.name},
      tooltip: 'Add',${_useTransform ? '''
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
          return _FabDemoHost(
            size: _size,
            color: _color,
            location: _location,
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
    return M3EFab(
      key: key,
      onPressed: _enabled ? () {} : null,
      icon: const Icon(M3EIcons.add),
      size: _size,
      color: _color,
      tooltip: 'Add',
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
          label: 'FAB',
          child: _previewFab(
            key: ValueKey<String>('fab-$_appear-$_size-$_color-$_enabled'),
          ),
        ),
        PlayPreviewCard(
          label: 'Full-screen FAB demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a scaffold with FAB location, scroll hide/show, optional '
                'appear morph, and optional container transform. Back dismisses '
                'an open transform first.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open FAB demo'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'FAB',
          children: <Widget>[
            PlayEnumSegmented<M3EFabSize>(
              label: 'Size',
              value: _size,
              values: M3EFabSize.values,
              labelOf: (M3EFabSize v) => v.name,
              onChanged: (M3EFabSize v) => setState(() => _size = v),
            ),
            PlayEnumMenu<M3EFabColor>(
              label: 'Color',
              value: _color,
              values: M3EFabColor.values,
              labelOf: (M3EFabColor v) => v.name,
              onChanged: (M3EFabColor v) => setState(() => _color = v),
            ),
            PlayEnumMenu<_FabDemoLocation>(
              label: 'Location',
              value: _location,
              values: _FabDemoLocation.values,
              labelOf: (_FabDemoLocation v) => v.label,
              onChanged: (_FabDemoLocation v) => setState(() => _location = v),
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

class _FabDemoHost extends StatefulWidget {
  const _FabDemoHost({
    required this.size,
    required this.color,
    required this.location,
    required this.appear,
    required this.useTransform,
    required this.enabled,
    required this.gradient,
  });

  final M3EFabSize size;
  final M3EFabColor color;
  final _FabDemoLocation location;
  final bool appear;
  final bool useTransform;
  final bool enabled;
  final bool gradient;

  @override
  State<_FabDemoHost> createState() => _FabDemoHostState();
}

class _FabDemoHostState extends State<_FabDemoHost> {
  final M3EFabController _controller = M3EFabController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return M3EFabScrollVisibility(
      controller: _controller,
      child: Scaffold(
        backgroundColor: M3ETheme.of(context).colorScheme.surface,
        appBar: M3EAppBar.top(
          titleText: 'FAB demo',
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
              supportingText: 'Scroll to hide / show the FAB',
              leading: const Icon(M3EIcons.label),
            );
          },
        ),
        floatingActionButton: M3EFab(
          key: ValueKey<String>(
            'demo-${widget.appear}-${widget.size}-${widget.color}-${widget.location.name}',
          ),
          controller: _controller,
          appear: widget.appear,
          scaleAlignment: widget.location.scaleAlignment,
          size: widget.size,
          color: widget.color,
          icon: const Icon(M3EIcons.add),
          tooltip: 'Add',
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
