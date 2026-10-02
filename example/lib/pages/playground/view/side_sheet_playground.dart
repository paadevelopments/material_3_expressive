import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Side sheet presentations shown in the playground.
enum _SheetKind { modal, layout }

/// Live playground for [M3ESideSheet] and [M3ESideSheetLayout].
class SideSheetPlayground extends PlaygroundWidget {
  /// Creates the side sheet playground.
  const SideSheetPlayground({super.key});

  @override
  PlaygroundState<SideSheetPlayground> createState() =>
      _SideSheetPlaygroundState();
}

class _SideSheetPlaygroundState extends PlaygroundState<SideSheetPlayground> {
  static const List<String> _labels = <String>[
    'Events',
    'Personal',
    'Projects',
    'Reminders',
    'Family',
  ];

  final M3ESideSheetController _controller = M3ESideSheetController();
  final Set<String> _checked = <String>{'Events', 'Projects'};

  _SheetKind _kind = _SheetKind.modal;
  M3ESideSheetLayoutMode _mode = M3ESideSheetLayoutMode.adaptive;
  M3ESideSheetEdge _edge = M3ESideSheetEdge.end;
  String _title = 'Filters';
  bool _showBack = false;
  bool _showClose = true;
  bool _showActions = true;
  bool _showDivider = true;
  bool _showEdgeDivider = true;
  bool _detached = false;
  double _width = 256;
  bool _longContent = false;

  bool get _modal => _kind == _SheetKind.modal;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle(BuildContext context) {
    if (!_modal) {
      _controller.toggle();
      return;
    }
    M3ESideSheet.show<void>(
      context,
      title: _title,
      width: _width,
      detached: _detached,
      edge: _edge,
      showCloseButton: _showClose,
      showDivider: _showActions && _showDivider,
      scrollable: true,
      onBack: _showBack ? () => Navigator.of(context).pop() : null,
      body: _filters(),
      actions: _actions(() => Navigator.of(context).pop()),
    );
  }

  List<Widget> _actions(VoidCallback done) {
    if (!_showActions) {
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

  /// "Labels" checkbox list, plus filler rows when long content is on.
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
              if (_longContent)
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

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    final Widget content = M3EList.scrollable(
      controller: PrimaryScrollController.of(context),
      variant: M3ECardVariant.filled,
      listPadding: padding,
      itemCount: 30,
      onTap: (_) => _toggle(context),
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Message ${index + 1}',
        supportingText: 'Tap to toggle the side sheet',
        leading: const Icon(M3EIcons.mail),
      ),
    );
    if (_modal) {
      return content;
    }
    return M3ESideSheetLayout(
      controller: _controller,
      mode: _mode,
      body: content,
      sheet: M3ESideSheet.standard(
        title: _title,
        width: _width,
        detached: _detached,
        edge: _edge,
        showCloseButton: _showClose,
        showDivider: _showActions && _showDivider,
        showEdgeDivider: _showEdgeDivider,
        scrollable: true,
        onBack: _showBack ? _controller.close : null,
        body: _filters(),
        actions: _actions(_controller.close),
      ),
    );
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    return PlaygroundSlots(
      appBar: M3EAppBar.top(
        titleText: 'Inbox',
        leading: chrome.leading,
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) => M3EIconButton(
              variant: M3EIconButtonVariant.standard,
              icon: const Icon(M3EIcons.filter_list),
              tooltip: 'Filters',
              onPressed: () => _toggle(context),
            ),
          ),
          ...chrome.trailingActions,
        ],
      ),
    );
  }

  String get _sheetArgs {
    final StringBuffer args = StringBuffer()
      ..writeln('  title: ${playDartString(_title)},')
      ..writeln('  width: ${_width.round()},')
      ..writeln('  detached: $_detached,')
      ..writeln('  edge: M3ESideSheetEdge.${_edge.name},')
      ..writeln('  showCloseButton: $_showClose,');
    if (_showActions) {
      args.writeln('  showDivider: $_showDivider,');
    }
    if (!_modal) {
      args.writeln('  showEdgeDivider: $_showEdgeDivider,');
    }
    args.writeln('  scrollable: true,');
    if (_showBack) {
      args.writeln('  onBack: () {},');
    }
    args.writeln('  body: filters,');
    if (_showActions) {
      args.writeln(
        '  actions: <Widget>[\n'
        "    M3EButton(onPressed: save, child: const Text('Save')),\n"
        '    M3EButton(\n'
        '      style: M3EButtonStyle.outlined,\n'
        '      onPressed: cancel,\n'
        "      child: const Text('Cancel'),\n"
        '    ),\n'
        '  ],',
      );
    }
    return args.toString();
  }

  @override
  List<PlaySnippet> get snippets {
    if (_modal) {
      return <PlaySnippet>[
        PlaySnippet(
          label: 'Modal side sheet',
          code:
              '$kPlaySnippetImport\n\n'
              'M3ESideSheet.show<void>(\n  context,\n$_sheetArgs);',
        ),
      ];
    }
    final String sheet = _sheetArgs
        .split('\n')
        .map((String line) => line.isEmpty ? line : '  $line')
        .join('\n');
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Side sheet layout',
        code:
            '''
$kPlaySnippetImport

final controller = M3ESideSheetController();

M3ESideSheetLayout(
  controller: controller,
  mode: M3ESideSheetLayoutMode.${_mode.name},
  body: mainContent,
  sheet: M3ESideSheet.standard(
$sheet  ),
);

controller.toggle();''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_SheetKind>(
            label: 'Presentation',
            value: _kind,
            values: _SheetKind.values,
            labelOf: (_SheetKind k) => switch (k) {
              _SheetKind.modal => 'modal',
              _SheetKind.layout => 'layout (standard)',
            },
            onChanged: (_SheetKind v) => setState(() => _kind = v),
          ),
          if (!_modal)
            PlayEnumChoice<M3ESideSheetLayoutMode>(
              label: 'Layout mode',
              value: _mode,
              values: M3ESideSheetLayoutMode.values,
              labelOf: (M3ESideSheetLayoutMode m) => m.name,
              onChanged: (M3ESideSheetLayoutMode v) {
                setState(() => _mode = v);
              },
            ),
          PlayEnumChoice<M3ESideSheetEdge>(
            label: 'Edge',
            value: _edge,
            values: M3ESideSheetEdge.values,
            labelOf: (M3ESideSheetEdge e) => e.name,
            onChanged: (M3ESideSheetEdge v) => setState(() => _edge = v),
          ),
          PlaySlider(
            label: 'Width',
            value: _width,
            min: 256,
            max: 400,
            divisions: 18,
            onChanged: (double v) => setState(() => _width = v),
          ),
          PlaySwitchItem(
            label: 'Detached',
            description: '16dp inset with all corners rounded',
            value: _detached,
            onChanged: (bool v) => setState(() => _detached = v),
          ),
          if (!_modal)
            PlaySwitchItem(
              label: 'Edge divider',
              description: 'Line between the sheet and the content',
              value: _showEdgeDivider,
              onChanged: (bool v) => setState(() => _showEdgeDivider = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Header',
        children: <Widget>[
          PlayTextField(
            label: 'Headline',
            value: _title,
            onChanged: (String v) => setState(() => _title = v),
          ),
          PlaySwitchItem(
            label: 'Back icon',
            value: _showBack,
            onChanged: (bool v) => setState(() => _showBack = v),
          ),
          PlaySwitchItem(
            label: 'Close icon',
            value: _showClose,
            onChanged: (bool v) => setState(() => _showClose = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Action buttons',
            value: _showActions,
            onChanged: (bool v) => setState(() => _showActions = v),
          ),
          if (_showActions)
            PlaySwitchItem(
              label: 'Divider above actions',
              value: _showDivider,
              onChanged: (bool v) => setState(() => _showDivider = v),
            ),
          PlaySwitchItem(
            label: 'Long content',
            description: 'Scrolls inside the sheet',
            value: _longContent,
            onChanged: (bool v) => setState(() => _longContent = v),
          ),
        ],
      ),
    ];
  }
}
