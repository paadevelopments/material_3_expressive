import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Bottom sheet variants shown in the playground.
enum _SheetKind {
  modal('modal'),
  standard('standard'),
  adaptive('adaptive (side sheet ≥ 840dp)');

  const _SheetKind(this.label);

  final String label;
}

/// Live playground for [M3EBottomSheet].
class BottomSheetPlayground extends PlaygroundWidget {
  /// Creates the bottom sheet playground.
  const BottomSheetPlayground({super.key});

  @override
  PlaygroundState<BottomSheetPlayground> createState() =>
      _BottomSheetPlaygroundState();
}

class _BottomSheetPlaygroundState
    extends PlaygroundState<BottomSheetPlayground> {
  final M3EBottomSheetController _controller = M3EBottomSheetController();

  _SheetKind _kind = _SheetKind.modal;
  M3EBottomSheetValue _initialValue = M3EBottomSheetValue.collapsed;
  bool _showDragHandle = true;
  bool _enableDrag = true;
  bool _dismissible = true;
  bool _fullScreen = false;
  bool _cyclesToClose = false;
  bool _usePreview = false;
  double _previewHeight = 64;
  bool _longContent = true;
  String _title = 'Share';
  String _body = 'Secondary content anchored to the bottom of the screen.';

  bool get _standard => _kind == _SheetKind.standard;

  bool get _hasTitle => _fullScreen || _kind == _SheetKind.adaptive;

  List<M3EBottomSheetValue> get _initialValues => <M3EBottomSheetValue>[
    if (_standard && _usePreview) M3EBottomSheetValue.preview,
    M3EBottomSheetValue.collapsed,
    M3EBottomSheetValue.expanded,
  ];

  M3EBottomSheetValue get _effectiveInitial =>
      _initialValues.contains(_initialValue)
      ? _initialValue
      : M3EBottomSheetValue.collapsed;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  M3EBottomSheetTheme _sheetTheme(BuildContext context) =>
      M3ETheme.of(context).bottomSheetTheme
          .copyWith(handleCyclesToClose: _cyclesToClose);

  void _showSheet(BuildContext context) {
    Widget builder(BuildContext context) =>
        _sheetContent(context, () => Navigator.of(context).pop());
    if (_kind == _SheetKind.adaptive) {
      M3EBottomSheet.showAdaptive<void>(
        context,
        title: _title,
        showDragHandle: _showDragHandle,
        enableDrag: _enableDrag,
        isDismissible: _dismissible,
        initialValue: _effectiveInitial,
        expandToFullScreen: _fullScreen,
        theme: _sheetTheme(context),
        builder: builder,
      );
      return;
    }
    M3EBottomSheet.show<void>(
      context,
      showDragHandle: _showDragHandle,
      enableDrag: _enableDrag,
      isDismissible: _dismissible,
      initialValue: _effectiveInitial,
      expandToFullScreen: _fullScreen,
      fullScreenTitle: _fullScreen ? _title : null,
      theme: _sheetTheme(context),
      builder: builder,
    );
  }

  /// Body text over a filled card list of actions.
  Widget _sheetContent(BuildContext context, VoidCallback onAction) {
    final M3EThemeData theme = M3ETheme.of(context);
    final Widget list = M3EList.scrollable(
      variant: M3ECardVariant.filled,
      shrinkWrap: !_longContent,
      listPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: _longContent ? 30 : 3,
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
          child: Text(_body, style: theme.typeScale.bodyLarge),
        ),
        Flexible(child: list),
      ],
    );
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    final Widget content = M3EList.scrollable(
      controller: PrimaryScrollController.of(context),
      variant: M3ECardVariant.filled,
      listPadding: padding.copyWith(bottom: padding.bottom + 160),
      itemCount: 20,
      onTap: (_) => _standard ? _controller.cycle() : _showSheet(context),
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Item ${index + 1}',
        supportingText: _standard
            ? 'Tap to cycle the sheet height'
            : 'Tap to open the sheet',
        leading: const Icon(M3EIcons.label),
      ),
    );
    if (!_standard) {
      return content;
    }
    return Stack(
      children: <Widget>[
        Positioned.fill(child: content),
        Positioned.fill(
          child: M3EBottomSheet.standard(
            // Structural options only apply when the sheet is created.
            key: ValueKey<String>(
              '$_effectiveInitial-$_fullScreen-$_usePreview-$_previewHeight-'
              '$_dismissible-$_longContent',
            ),
            controller: _controller,
            showDragHandle: _showDragHandle,
            enableDrag: _enableDrag,
            isDismissible: _dismissible,
            initialValue: _effectiveInitial,
            previewHeight: _usePreview ? _previewHeight : null,
            expandToFullScreen: _fullScreen,
            fullScreenTitle: _fullScreen ? _title : null,
            theme: _sheetTheme(context),
            child: _sheetContent(context, () {}),
          ),
        ),
      ],
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final String call = switch (_kind) {
      _SheetKind.modal => 'M3EBottomSheet.show<void>(\n  context,',
      _SheetKind.adaptive =>
        'M3EBottomSheet.showAdaptive<void>(\n'
            '  context,\n'
            '  title: ${playDartString(_title)},',
      _SheetKind.standard => 'M3EBottomSheet.standard(',
    };
    final StringBuffer args = StringBuffer()
      ..writeln('  showDragHandle: $_showDragHandle,')
      ..writeln('  enableDrag: $_enableDrag,')
      ..writeln('  isDismissible: $_dismissible,')
      ..writeln('  initialValue: $_effectiveInitial,')
      ..writeln('  expandToFullScreen: $_fullScreen,');
    if (_fullScreen && _kind != _SheetKind.adaptive) {
      args.writeln('  fullScreenTitle: ${playDartString(_title)},');
    }
    if (_standard && _usePreview) {
      args.writeln('  previewHeight: ${_previewHeight.round()},');
    }
    if (_cyclesToClose) {
      args.writeln(
        '  theme: M3ETheme.of(context).bottomSheetTheme.copyWith(\n'
        '    handleCyclesToClose: true,\n'
        '  ),',
      );
    }
    final String child = _standard
        ? '  child: content,'
        : '  builder: (BuildContext context) => content,';
    return <PlaySnippet>[
      PlaySnippet(
        label: '${_kind.name} bottom sheet',
        code: '$kPlaySnippetImport\n\n$call\n$args$child\n);',
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
            label: 'Sheet',
            value: _kind,
            values: _SheetKind.values,
            labelOf: (_SheetKind k) => k.label,
            onChanged: (_SheetKind v) => setState(() => _kind = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Height',
        children: <Widget>[
          if (_standard)
            PlaySwitchItem(
              label: 'Preview height',
              description: 'A peek below the collapsed height',
              value: _usePreview,
              onChanged: (bool v) => setState(() => _usePreview = v),
            ),
          if (_standard && _usePreview)
            PlaySlider(
              label: 'Preview height',
              value: _previewHeight,
              min: 48,
              max: 160,
              divisions: 14,
              onChanged: (double v) => setState(() => _previewHeight = v),
            ),
          PlayEnumChoice<M3EBottomSheetValue>(
            label: 'Initial height',
            value: _effectiveInitial,
            values: _initialValues,
            labelOf: (M3EBottomSheetValue v) => v.name,
            onChanged: (M3EBottomSheetValue v) {
              setState(() => _initialValue = v);
            },
          ),
          PlaySwitchItem(
            label: 'Full-screen height',
            description: 'Adds a full-screen step with a header',
            value: _fullScreen,
            onChanged: (bool v) => setState(() => _fullScreen = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Behavior',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Drag handle',
            value: _showDragHandle,
            onChanged: (bool v) => setState(() => _showDragHandle = v),
          ),
          if (_showDragHandle)
            PlaySwitchItem(
              label: 'Handle cycle closes',
              description: 'Tapping past the tallest height closes',
              value: _cyclesToClose,
              onChanged: (bool v) => setState(() => _cyclesToClose = v),
            ),
          PlaySwitchItem(
            label: 'Drag to resize',
            value: _enableDrag,
            onChanged: (bool v) => setState(() => _enableDrag = v),
          ),
          PlaySwitchItem(
            label: 'Dismissible',
            description: _standard
                ? 'Dragging down can hide the sheet'
                : 'Scrim tap, swipe down and Escape close it',
            value: _dismissible,
            onChanged: (bool v) => setState(() => _dismissible = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Content',
        children: <Widget>[
          if (_hasTitle)
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
          PlaySwitchItem(
            label: 'Long list',
            description: 'Scrolls inside the sheet',
            value: _longContent,
            onChanged: (bool v) => setState(() => _longContent = v),
          ),
        ],
      ),
    ];
  }
}
