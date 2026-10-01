import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart' show MaterialPageRoute, Scaffold;

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Bottom sheet variants shown in the playground.
enum _SheetKind {
  modal(
    'Modal',
    'Opens over a scrim at no more than half the screen. Drag, tap or press '
        'Space / Enter on the handle to change height; tap the scrim, swipe '
        'down or press Escape to close.',
  ),
  standard(
    'Standard',
    'Sits next to the main content without a scrim, so both stay usable. '
        'Tap a row behind it to cycle its height without dragging.',
  ),
  adaptive(
    'Adaptive',
    'A modal bottom sheet below 840dp and a side sheet at 840dp and wider.',
  );

  const _SheetKind(this.label, this.description);

  final String label;
  final String description;
}

/// Sheet options picked in the playground.
class _SheetOptions {
  const _SheetOptions({
    required this.kind,
    required this.showDragHandle,
    required this.openExpanded,
    required this.fullScreen,
    required this.cyclesToClose,
    required this.longContent,
    required this.title,
    required this.body,
  });

  final _SheetKind kind;
  final bool showDragHandle;
  final bool openExpanded;
  final bool fullScreen;
  final bool cyclesToClose;
  final bool longContent;
  final String title;
  final String body;

  M3EBottomSheetValue get initialValue => openExpanded
      ? M3EBottomSheetValue.expanded
      : M3EBottomSheetValue.collapsed;
}

/// Live playground for [M3EBottomSheet].
class BottomSheetPlayground extends StatefulWidget {
  /// Creates the bottom sheet playground.
  const BottomSheetPlayground({super.key});

  @override
  State<BottomSheetPlayground> createState() => _BottomSheetPlaygroundState();
}

class _BottomSheetPlaygroundState extends State<BottomSheetPlayground> {
  _SheetKind _kind = _SheetKind.modal;
  bool _showDragHandle = true;
  bool _openExpanded = false;
  bool _fullScreen = false;
  bool _cyclesToClose = false;
  bool _longContent = true;
  String _title = 'Share';
  String _body = 'Secondary content anchored to the bottom of the screen.';

  _SheetOptions get _options => _SheetOptions(
    kind: _kind,
    showDragHandle: _showDragHandle,
    openExpanded: _openExpanded,
    fullScreen: _fullScreen,
    cyclesToClose: _cyclesToClose,
    longContent: _longContent,
    title: _title,
    body: _body,
  );

  String get _snippetTap => _kind == _SheetKind.standard
      ? '(int i) {}'
      : '(int i) => Navigator.pop(context)';

  List<PlaySnippet> get _snippets {
    final String call = switch (_kind) {
      _SheetKind.modal => 'M3EBottomSheet.show<void>(\n  context,',
      _SheetKind.adaptive =>
        'M3EBottomSheet.showAdaptive<void>(\n'
            '  context,\n'
            '  title: ${playDartString(_title)},',
      _SheetKind.standard => 'M3EBottomSheet.standard(',
    };
    final String list = _kind == _SheetKind.standard
        ? '  child: M3EList.scrollable('
        : '  builder: (BuildContext context) => M3EList.scrollable(';
    return <PlaySnippet>[
      PlaySnippet(
        label: '${_kind.label} bottom sheet',
        code:
            '''
$kPlaySnippetImport

$call
  showDragHandle: $_showDragHandle,
  initialValue: ${_options.initialValue},
  expandToFullScreen: $_fullScreen,
  theme: M3ETheme.of(context).bottomSheetTheme.copyWith(
    handleCyclesToClose: $_cyclesToClose,
  ),
$list
    variant: M3ECardVariant.filled,
    listPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    itemCount: ${_longContent ? 30 : 3},
    onTap: $_snippetTap,
    itemBuilder: (BuildContext context, int i) =>
        M3EListItem(headline: 'Action \${i + 1}'),
  ),
);''',
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

  List<Widget> _controls() {
    return <Widget>[
      PlayControlPanel(
        title: 'Sheet',
        children: <Widget>[
          PlayEnumSegmented<_SheetKind>(
            label: 'Variant',
            value: _kind,
            values: _SheetKind.values,
            labelOf: (_SheetKind k) => k.label,
            onChanged: (_SheetKind v) => setState(() => _kind = v),
          ),
          _switch('Drag handle', _showDragHandle, (v) => _showDragHandle = v),
          _switch('Open fully raised', _openExpanded, (v) => _openExpanded = v),
          _switch('Full-screen height', _fullScreen, (v) => _fullScreen = v),
          _switch(
            'Handle cycle closes',
            _cyclesToClose,
            (v) => _cyclesToClose = v,
          ),
          _switch(
            'Long list (scrolls inside)',
            _longContent,
            (v) => _longContent = v,
          ),
          PlayTextField(
            label: 'Title',
            value: _title,
            onChanged: (String v) => setState(() => _title = v),
          ),
          PlayTextField(
            label: 'Body',
            value: _body,
            onChanged: (String v) => setState(() => _body = v),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: '${_kind.label} bottom sheet',
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
                child: Text('Open ${_kind.label.toLowerCase()} sheet demo'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: _controls(),
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
  final M3EBottomSheetController _controller = M3EBottomSheetController();

  _SheetOptions get _options => widget.options;

  bool get _standard => _options.kind == _SheetKind.standard;

  @override
  void initState() {
    super.initState();
    if (!_standard) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showSheet());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  M3EBottomSheetTheme _sheetTheme(BuildContext context) =>
      M3ETheme.of(context).bottomSheetTheme
          .copyWith(handleCyclesToClose: _options.cyclesToClose);

  void _showSheet() {
    if (!mounted) {
      return;
    }
    Widget builder(BuildContext context) =>
        _sheetContent(context, () => Navigator.of(context).pop());
    if (_options.kind == _SheetKind.adaptive) {
      M3EBottomSheet.showAdaptive<void>(
        context,
        title: _options.title,
        showDragHandle: _options.showDragHandle,
        initialValue: _options.initialValue,
        expandToFullScreen: _options.fullScreen,
        theme: _sheetTheme(context),
        builder: builder,
      );
      return;
    }
    M3EBottomSheet.show<void>(
      context,
      showDragHandle: _options.showDragHandle,
      initialValue: _options.initialValue,
      expandToFullScreen: _options.fullScreen,
      fullScreenTitle: _options.title,
      theme: _sheetTheme(context),
      builder: builder,
    );
  }

  /// Body text over a filled card list of actions.
  Widget _sheetContent(BuildContext context, VoidCallback onAction) {
    final M3EThemeData theme = M3ETheme.of(context);
    final int count = _options.longContent ? 30 : 3;
    final Widget list = M3EList.scrollable(
      variant: M3ECardVariant.filled,
      shrinkWrap: !_options.longContent,
      listPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: count,
      onTap: (_) => onAction(),
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Action ${index + 1}',
        supportingText: 'Supporting text',
        leading: const Icon(M3EIcons.share),
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Text(_options.body, style: theme.typeScale.bodyLarge),
        ),
        Flexible(child: list),
      ],
    );
  }

  /// Main content behind the sheet, as a filled card list.
  Widget _mainContent() {
    return M3EList.scrollable(
      variant: M3ECardVariant.filled,
      listPadding: const EdgeInsets.fromLTRB(16, 8, 16, 160),
      itemCount: 20,
      onTap: (_) => _standard ? _controller.cycle() : _showSheet(),
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Item ${index + 1}',
        supportingText: _standard ? 'Tap to cycle the sheet' : 'Tap to open',
        leading: const Icon(M3EIcons.label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: '${_options.kind.label} bottom sheet',
        automaticallyImplyLeading: true,
      ),
      body: Stack(
        children: <Widget>[
          Positioned.fill(child: _mainContent()),
          if (_standard)
            Positioned.fill(
              child: M3EBottomSheet.standard(
                controller: _controller,
                showDragHandle: _options.showDragHandle,
                initialValue: _options.initialValue,
                previewHeight: 64,
                isDismissible: true,
                expandToFullScreen: _options.fullScreen,
                fullScreenTitle: _options.title,
                theme: _sheetTheme(context),
                child: _sheetContent(context, () {}),
              ),
            ),
        ],
      ),
    );
  }
}
