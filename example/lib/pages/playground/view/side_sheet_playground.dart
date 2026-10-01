import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart' show MaterialPageRoute, Scaffold;

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Side sheet presentations shown in the playground.
enum _SheetKind {
  modal(
    'Modal',
    'Springs in over a scrim. Close it with the close button, the scrim, '
        'Escape, back or a predictive back swipe.',
  ),
  layout(
    'Layout',
    'Sits next to the content, which shrinks to make room (standard). '
        'Adaptive mode turns it modal below 600dp and morphs on resize.',
  );

  const _SheetKind(this.label, this.description);

  final String label;
  final String description;
}

/// Sheet options picked in the playground.
class _SheetOptions {
  const _SheetOptions({
    required this.kind,
    required this.mode,
    required this.title,
    required this.showBack,
    required this.showClose,
    required this.showActions,
    required this.showDivider,
    required this.showEdgeDivider,
    required this.detached,
    required this.startEdge,
    required this.width,
    required this.longContent,
  });

  final _SheetKind kind;
  final M3ESideSheetLayoutMode mode;
  final String title;
  final bool showBack;
  final bool showClose;
  final bool showActions;
  final bool showDivider;
  final bool showEdgeDivider;
  final bool detached;
  final bool startEdge;
  final double width;
  final bool longContent;

  M3ESideSheetEdge get edge =>
      startEdge ? M3ESideSheetEdge.start : M3ESideSheetEdge.end;
}

/// Live playground for [M3ESideSheet] and [M3ESideSheetLayout].
class SideSheetPlayground extends StatefulWidget {
  /// Creates the side sheet playground.
  const SideSheetPlayground({super.key});

  @override
  State<SideSheetPlayground> createState() => _SideSheetPlaygroundState();
}

class _SideSheetPlaygroundState extends State<SideSheetPlayground> {
  _SheetKind _kind = _SheetKind.modal;
  M3ESideSheetLayoutMode _mode = M3ESideSheetLayoutMode.adaptive;
  String _title = 'Filters';
  bool _showBack = false;
  bool _showClose = true;
  bool _showActions = true;
  bool _showDivider = true;
  bool _showEdgeDivider = true;
  bool _detached = false;
  bool _startEdge = false;
  double _width = 256;
  bool _longContent = false;

  _SheetOptions get _options => _SheetOptions(
    kind: _kind,
    mode: _mode,
    title: _title,
    showBack: _showBack,
    showClose: _showClose,
    showActions: _showActions,
    showDivider: _showDivider,
    showEdgeDivider: _showEdgeDivider,
    detached: _detached,
    startEdge: _startEdge,
    width: _width,
    longContent: _longContent,
  );

  String get _sheetArgs =>
      '''
  title: ${playDartString(_title)},
  width: ${_width.round()},
  detached: $_detached,
  edge: ${_options.edge},
  showCloseButton: $_showClose,
  showDivider: $_showDivider,
  scrollable: true,${_showBack ? '\n  onBack: () {},' : ''}
  body: const Text('Content'),
  actions: <Widget>[
    M3EButton(onPressed: save, child: const Text('Save')),
    M3EButton(
      style: M3EButtonStyle.outlined,
      onPressed: cancel,
      child: const Text('Cancel'),
    ),
  ],''';

  List<PlaySnippet> get _snippets {
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Modal side sheet',
        code:
            '''
$kPlaySnippetImport

M3ESideSheet.show<void>(
  context,
$_sheetArgs
);''',
      ),
      PlaySnippet(
        label: 'Side sheet layout',
        code:
            '''
$kPlaySnippetImport

final controller = M3ESideSheetController();

M3ESideSheetLayout(
  controller: controller,
  mode: $_mode,
  body: mainContent,
  sheet: M3ESideSheet.standard(
    showEdgeDivider: $_showEdgeDivider,
  $_sheetArgs
  ),
);

controller.toggle();''',
      ),
    ];
  }

  void _openDemo() {
    final _SheetOptions options = _options;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => _SheetDemoScreen(options: options),
      ),
    );
  }

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return PlaySwitch(
      label: label,
      value: value,
      onChanged: (bool v) => setState(() => onChanged(v)),
    );
  }

  Widget _sheetPanel() {
    return PlayControlPanel(
      title: 'Sheet',
      children: <Widget>[
        PlayEnumSegmented<_SheetKind>(
          label: 'Presentation',
          value: _kind,
          values: _SheetKind.values,
          labelOf: (_SheetKind k) => k.label,
          onChanged: (_SheetKind v) => setState(() => _kind = v),
        ),
        PlayEnumSegmented<M3ESideSheetLayoutMode>(
          label: 'Layout mode',
          value: _mode,
          values: M3ESideSheetLayoutMode.values,
          labelOf: (M3ESideSheetLayoutMode m) => m.name,
          onChanged: (M3ESideSheetLayoutMode v) => setState(() => _mode = v),
        ),
        PlayTextField(
          label: 'Headline',
          value: _title,
          onChanged: (String v) => setState(() => _title = v),
        ),
        PlaySlider(
          label: 'Width (${_width.round()})',
          value: _width,
          min: 256,
          max: 400,
          divisions: 18,
          onChanged: (double v) => setState(() => _width = v),
        ),
      ],
    );
  }

  Widget _anatomyPanel() {
    return PlayControlPanel(
      title: 'Anatomy',
      children: <Widget>[
        _switch('Back icon', _showBack, (v) => _showBack = v),
        _switch('Close icon', _showClose, (v) => _showClose = v),
        _switch('Action buttons', _showActions, (v) => _showActions = v),
        _switch('Divider above actions', _showDivider, (v) => _showDivider = v),
        _switch(
          'Edge divider (standard)',
          _showEdgeDivider,
          (v) => _showEdgeDivider = v,
        ),
        _switch('Detached (16dp inset)', _detached, (v) => _detached = v),
        _switch('Start edge', _startEdge, (v) => _startEdge = v),
        _switch('Long content (scrolls)', _longContent, (v) {
          _longContent = v;
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: '${_kind.label} side sheet',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _kind.description,
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: Text('Open ${_kind.label.toLowerCase()} demo'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[_sheetPanel(), _anatomyPanel()],
    );
  }
}

/// Dedicated preview screen: app content with the selected sheet.
class _SheetDemoScreen extends StatefulWidget {
  const _SheetDemoScreen({required this.options});

  final _SheetOptions options;

  @override
  State<_SheetDemoScreen> createState() => _SheetDemoScreenState();
}

class _SheetDemoScreenState extends State<_SheetDemoScreen> {
  static const List<String> _labels = <String>[
    'Events',
    'Personal',
    'Projects',
    'Reminders',
    'Family',
  ];

  final M3ESideSheetController _controller = M3ESideSheetController();
  final Set<String> _checked = <String>{'Events', 'Projects'};

  _SheetOptions get _options => widget.options;

  bool get _modal => _options.kind == _SheetKind.modal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _toggle());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (!mounted) {
      return;
    }
    if (!_modal) {
      _controller.toggle();
      return;
    }
    M3ESideSheet.show<void>(
      context,
      title: _options.title,
      width: _options.width,
      detached: _options.detached,
      edge: _options.edge,
      showCloseButton: _options.showClose,
      showDivider: _options.showDivider,
      scrollable: true,
      onBack: _options.showBack ? () => Navigator.of(context).pop() : null,
      body: _filters(),
      actions: _actions(() => Navigator.of(context).pop()),
    );
  }

  List<Widget> _actions(VoidCallback done) {
    if (!_options.showActions) {
      return const <Widget>[];
    }
    return <Widget>[
      M3EButton(onPressed: done, child: const Text('Save')),
      M3EButton(
        style: M3EButtonStyle.outlined,
        onPressed: done,
        child: const Text('Cancel'),
      ),
    ];
  }

  /// "Filters" checkbox list (and filler rows when long content is on).
  Widget _filters() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setLocal) {
        final M3EThemeData theme = M3ETheme.of(context);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                child: Text('Labels', style: theme.typeScale.titleSmall),
              ),
              for (final String label in _labels)
                M3ECheckbox(
                  value: _checked.contains(label),
                  label: Text(label),
                  onChanged: (bool? v) => setLocal(() {
                    v ?? false ? _checked.add(label) : _checked.remove(label);
                  }),
                ),
              if (_options.longContent)
                for (var i = 1; i <= 30; i++)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Detail row $i'),
                  ),
            ],
          ),
        );
      },
    );
  }

  Widget _mainContent() {
    return M3EList.scrollable(
      variant: M3ECardVariant.filled,
      listPadding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: 30,
      onTap: (_) => _toggle(),
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Message ${index + 1}',
        supportingText: 'Tap to toggle the side sheet',
        leading: const Icon(M3EIcons.mail),
      ),
    );
  }

  /// A forced standard sheet on a compact window leaves no room for the
  /// list, so the preview shows the sheet alone.
  bool _sheetOnly(BuildContext context) =>
      _options.mode == M3ESideSheetLayoutMode.standard &&
      MediaQuery.sizeOf(context).width <
          M3ETheme.of(context).sideSheetTheme.compactBreakpoint;

  Widget _layout(BuildContext context) {
    return M3ESideSheetLayout(
      controller: _controller,
      mode: _options.mode,
      body: _sheetOnly(context) ? const SizedBox.shrink() : _mainContent(),
      sheet: M3ESideSheet.standard(
        title: _options.title,
        width: _options.width,
        detached: _options.detached,
        edge: _options.edge,
        showCloseButton: _options.showClose,
        showDivider: _options.showDivider,
        showEdgeDivider: _options.showEdgeDivider,
        scrollable: true,
        onBack: _options.showBack ? _controller.close : null,
        body: _filters(),
        actions: _actions(_controller.close),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: '${_options.kind.label} side sheet',
        automaticallyImplyLeading: true,
        actions: <Widget>[
          M3EIconButton(
            variant: M3EIconButtonVariant.standard,
            icon: const Icon(M3EIcons.filter_list),
            tooltip: 'Filters',
            onPressed: _toggle,
          ),
        ],
      ),
      body: _modal ? _mainContent() : _layout(context),
    );
  }
}
