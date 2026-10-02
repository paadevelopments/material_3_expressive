import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Dialog variants shown in the playground.
enum _DialogKind {
  basic(
    'Basic',
    'A modal over a scrim for urgent info or a decision. The headline and '
        'actions stay pinned while long content scrolls.',
    'Reset settings?',
  ),
  selection(
    'Selection',
    'Pick from a list before committing. Tab lands on the list, arrows move, '
        'Space or Enter selects, and the next Tab reaches the actions.',
    'Phone ringtone',
  ),
  fullScreen(
    'Full screen',
    'Fills the view for multi-step tasks on compact screens. The header tints '
        'on scroll; closing with unsaved changes asks to discard them.',
    'New event',
  ),
  adaptive(
    'Adaptive',
    'Full screen below 600dp and a basic dialog above it. Resize the window '
        'to see it switch.',
    'Create a new album',
  ),
  fabTransform(
    'FAB transform',
    'Tap the FAB to morph it into a full-screen dialog with a container '
        'transform.',
    'New event',
  );

  const _DialogKind(this.label, this.description, this.defaultTitle);

  final String label;
  final String description;
  final String defaultTitle;
}

/// Live playground for [M3EDialog].
class DialogsPlayground extends PlaygroundWidget {
  /// Creates the dialogs playground.
  const DialogsPlayground({super.key});

  @override
  PlaygroundState<DialogsPlayground> createState() => _DialogsPlaygroundState();
}

class _DialogsPlaygroundState extends PlaygroundState<DialogsPlayground> {
  static const List<String> _options = <String>[
    'None',
    'Callisto',
    'Ganymede',
    'Luna',
    'Oberon',
  ];

  _DialogKind _kind = _DialogKind.basic;
  final Map<_DialogKind, String> _titles = <_DialogKind, String>{
    for (final _DialogKind k in _DialogKind.values) k: k.defaultTitle,
  };
  String _content = 'This will restore all settings to their default values.';
  bool _showIcon = true;
  bool _subhead = false;
  bool _topDivider = false;
  bool _bottomDivider = false;
  bool _barrierDismissible = true;
  bool _multiSelect = false;
  bool _longContent = false;
  bool _truncateTitle = false;
  bool _textField = false;
  bool _leadingAction = false;
  bool _contentHeadline = false;
  bool _bottomBar = false;
  bool _unsaved = true;
  M3EDialogPosition _position = M3EDialogPosition.center;

  String get _title => _titles[_kind]!;

  // ---- Snippets -----------------------------------------------------------

  PlaySnippet get _snippet {
    final String code = switch (_kind) {
      _DialogKind.basic => _basicSnippet,
      _DialogKind.selection => _selectionSnippet,
      _DialogKind.fullScreen => _fullScreenSnippet,
      _DialogKind.adaptive => _adaptiveSnippet,
      _DialogKind.fabTransform => _fabSnippet,
    };
    return PlaySnippet(
      label: _kind.label,
      code: '$kPlaySnippetImport\n\n$code',
    );
  }

  String get _positionArg => _position == M3EDialogPosition.center
      ? ''
      : '\n  position: M3EDialogPosition.${_position.name},';

  String get _barrierArg =>
      _barrierDismissible ? '' : '\n  barrierDismissible: false,';

  String get _basicSnippet {
    final String icon = _showIcon
        ? '\n    icon: const Icon(M3EIcons.error),'
        : '';
    final String lines = _truncateTitle ? '\n    titleMaxLines: 1,' : '';
    final String subhead = _subhead
        ? "\n    subhead: 'Applies to every device',"
        : '';
    final String top = _topDivider ? '\n    topDivider: true,' : '';
    final String bottom = _bottomDivider ? '\n    bottomDivider: true,' : '';
    final String leading = _leadingAction
        ? "\n    leadingAction: M3EButton.text(onPressed: () {}, child: const Text('Learn more')),"
        : '';
    return '''
M3EDialog.show<void>(
  context,$_barrierArg$_positionArg
  dialog: M3EDialog(
    title: ${playDartString(_title)},$icon$subhead$lines
    content: Text(${playDartString(_content)}),$top$bottom$leading
    actions: <Widget>[
      M3EButton.text(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      M3EButton.text(onPressed: () => Navigator.pop(context), child: const Text('Confirm')),
    ],
  ),
);''';
  }

  String get _selectionSnippet {
    final String multi = _multiSelect ? '\n  multiSelect: true,' : '';
    return '''
final List<String>? picked = await M3EDialog.showSelectionScreen(
  context,
  title: ${playDartString(_title)},$multi$_barrierArg
  options: const <String>['None', 'Callisto', 'Ganymede', 'Luna', 'Oberon'],
);''';
  }

  String get _fullScreenSnippet {
    final String headline = _contentHeadline
        ? '\n  contentHeadline: ${playDartString(_title)},'
        : '';
    final String bar = _bottomBar
        ? '''

  bottomActions: <Widget>[
    M3EButton.text(onPressed: controller.dismiss, child: const Text('Cancel')),
    M3EButton.text(onPressed: controller.close, child: const Text('Create')),
  ],'''
        : '';
    return '''
final controller = M3EDialogController(hasUnsavedChanges: $_unsaved);
M3EDialog.showFullScreen<void>(
  context,
  title: ${playDartString(_title)},
  confirmLabel: 'Save',
  onConfirm: controller.close,
  controller: controller,$headline$bar
  contentPadding: EdgeInsets.zero,
  body: M3EList.scrollable(
    variant: M3ECardVariant.filled,
    listPadding: const EdgeInsets.all(16),
    itemCount: 20,
    itemBuilder: (BuildContext context, int i) =>
        M3EListItem(headline: 'Field \${i + 1}', onTap: () {}),
  ),
);''';
  }

  String get _adaptiveSnippet =>
      '''
M3EDialog.showAdaptive<void>(
  context,$_barrierArg$_positionArg
  title: ${playDartString(_title)},
  content: Text(${playDartString(_content)}),
  confirmLabel: 'Save',
  onConfirm: () => Navigator.pop(context),
);''';

  String get _fabSnippet =>
      '''
M3EFab(
  icon: const Icon(M3EIcons.add),
  openBuilder: (BuildContext context) => M3EFullScreenDialog(
    title: ${playDartString(_title)},
    confirmLabel: 'Save',
    onConfirm: () => M3EFabContainerTransformScope.closeOf(context),
    contentPadding: EdgeInsets.zero,
    body: M3EList.scrollable(
      variant: M3ECardVariant.filled,
      listPadding: const EdgeInsets.all(16),
      itemCount: 20,
      itemBuilder: (BuildContext context, int i) =>
          M3EListItem(headline: 'Field \${i + 1}', onTap: () {}),
    ),
  ),
);''';

  // ---- Launchers ----------------------------------------------------------

  Widget _textAction(String label, VoidCallback? onPressed) =>
      M3EButton.text(onPressed: onPressed, child: Text(label));

  Widget _buildContent() {
    final Widget text = _longContent
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              for (int i = 1; i <= 30; i++) Text('$i. $_content'),
            ],
          )
        : Text(_content);
    if (!_textField) {
      return text;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        text,
        const SizedBox(height: 16),
        const M3ETextField(label: 'Name'),
      ],
    );
  }

  void _showBasic() {
    M3EDialog.show<void>(
      context,
      barrierDismissible: _barrierDismissible,
      position: _position,
      dialog: M3EDialog(
        title: _title,
        icon: _showIcon ? const Icon(M3EIcons.error) : null,
        subhead: _subhead ? 'Applies to every device' : null,
        titleMaxLines: _truncateTitle ? 1 : null,
        content: _buildContent(),
        topDivider: _topDivider,
        bottomDivider: _bottomDivider,
        leadingAction: _leadingAction ? _textAction('Learn more', () {}) : null,
        actions: <Widget>[
          _textAction('Cancel', () => Navigator.of(context).pop()),
          _textAction('Confirm', () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Future<void> _showSelection() async {
    final List<String>? picked = await M3EDialog.showSelectionScreen(
      context,
      title: _title,
      multiSelect: _multiSelect,
      barrierDismissible: _barrierDismissible,
      options: _options,
    );
    if (picked != null && mounted) {
      M3ESnackbar.show(context, message: 'Picked ${picked.join(', ')}');
    }
  }

  /// Filled card list, inset 16 from the sides. It scrolls under the header,
  /// so the dialog drops its own content padding.
  Widget _formList() {
    return M3EList.scrollable(
      variant: M3ECardVariant.filled,
      listPadding: const EdgeInsets.all(16),
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Field ${index + 1}',
          supportingText: 'Supporting text',
          leading: const Icon(M3EIcons.event),
          onTap: () {},
        );
      },
    );
  }

  void _showFullScreen() {
    final controller = M3EDialogController(hasUnsavedChanges: _unsaved);
    M3EDialog.showFullScreen<void>(
      context,
      title: _title,
      confirmLabel: 'Save',
      onConfirm: controller.close,
      controller: controller,
      contentHeadline: _contentHeadline ? _title : null,
      bottomActions: _bottomBar
          ? <Widget>[
              _textAction('Cancel', controller.dismiss),
              _textAction('Create', controller.close),
            ]
          : const <Widget>[],
      contentPadding: EdgeInsets.zero,
      body: _formList(),
    ).whenComplete(controller.dispose);
  }

  void _showAdaptive() {
    M3EDialog.showAdaptive<void>(
      context,
      title: _title,
      content: _buildContent(),
      confirmLabel: 'Save',
      onConfirm: () => Navigator.of(context).pop(),
      barrierDismissible: _barrierDismissible,
      position: _position,
    );
  }

  Widget _fullScreenDestination(BuildContext context) {
    return M3EFullScreenDialog(
      title: _title,
      confirmLabel: 'Save',
      onConfirm: () => M3EFabContainerTransformScope.closeOf(context),
      contentPadding: EdgeInsets.zero,
      body: _formList(),
    );
  }

  // ---- Preview ------------------------------------------------------------

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final bool fab = _kind == _DialogKind.fabTransform;
    final VoidCallback open = switch (_kind) {
      _DialogKind.basic => _showBasic,
      _DialogKind.selection => _showSelection,
      _DialogKind.fullScreen => _showFullScreen,
      _DialogKind.adaptive || _DialogKind.fabTransform => _showAdaptive,
    };
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            _kind.description,
            textAlign: TextAlign.center,
            style: theme.typeScale.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (!fab) ...<Widget>[
            const SizedBox(height: 16),
            M3EButton(
              onPressed: open,
              child: Text('Open ${_kind.label.toLowerCase()} dialog'),
            ),
          ],
        ],
      ),
    );
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    if (_kind != _DialogKind.fabTransform) {
      return const PlaygroundSlots();
    }
    return PlaygroundSlots(
      floatingActionButton: M3EFab(
        icon: const Icon(M3EIcons.add),
        tooltip: 'Open full-screen dialog',
        openBuilder: _fullScreenDestination,
      ),
    );
  }

  @override
  List<PlaySnippet> get snippets => <PlaySnippet>[_snippet];

  // ---- Controls -----------------------------------------------------------

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return PlaySwitchItem(
      label: label,
      value: value,
      onChanged: (bool v) => setState(() => onChanged(v)),
    );
  }

  Widget get _titleField => PlayTextField(
    key: ValueKey<_DialogKind>(_kind),
    label: 'Title',
    value: _title,
    onChanged: (String v) => setState(() => _titles[_kind] = v),
  );

  Widget get _contentField => PlayTextField(
    label: 'Content',
    value: _content,
    onChanged: (String v) => setState(() => _content = v),
  );

  Widget get _barrierSwitch => _switch(
    'Barrier dismissible',
    _barrierDismissible,
    (bool v) => _barrierDismissible = v,
  );

  Widget get _positionControl => PlayEnumChoice<M3EDialogPosition>(
    label: 'Position',
    value: _position,
    values: M3EDialogPosition.values,
    labelOf: (M3EDialogPosition p) => p.name,
    onChanged: (M3EDialogPosition p) => setState(() => _position = p),
  );

  List<Widget> get _kindControls => switch (_kind) {
    _DialogKind.basic => <Widget>[
      _titleField,
      _contentField,
      _switch('Show icon', _showIcon, (bool v) => _showIcon = v),
      _switch('Subhead', _subhead, (bool v) => _subhead = v),
      _switch('Long content (scrolls)', _longContent, (bool v) {
        _longContent = v;
      }),
      _switch('Truncate headline (1 line)', _truncateTitle, (bool v) {
        _truncateTitle = v;
      }),
      _switch('Top divider', _topDivider, (bool v) => _topDivider = v),
      _switch('Bottom divider', _bottomDivider, (bool v) {
        _bottomDivider = v;
      }),
      _switch('Leading action (caution)', _leadingAction, (bool v) {
        _leadingAction = v;
      }),
      _switch('Text field (keyboard)', _textField, (bool v) {
        _textField = v;
      }),
      _barrierSwitch,
      _positionControl,
    ],
    _DialogKind.selection => <Widget>[
      _titleField,
      _switch('Multi select', _multiSelect, (bool v) => _multiSelect = v),
      _barrierSwitch,
    ],
    _DialogKind.fullScreen => <Widget>[
      _titleField,
      _switch('Unsaved changes', _unsaved, (bool v) => _unsaved = v),
      _switch('Bottom action bar', _bottomBar, (bool v) => _bottomBar = v),
      _switch('Headline in content', _contentHeadline, (bool v) {
        _contentHeadline = v;
      }),
    ],
    _DialogKind.adaptive => <Widget>[
      _titleField,
      _contentField,
      _switch('Text field (keyboard)', _textField, (bool v) {
        _textField = v;
      }),
      _barrierSwitch,
      _positionControl,
    ],
    _DialogKind.fabTransform => <Widget>[_titleField],
  };

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Variant',
        children: <Widget>[
          PlayEnumChoice<_DialogKind>(
            label: 'Dialog',
            value: _kind,
            values: _DialogKind.values,
            labelOf: (_DialogKind k) => k.label,
            onChanged: (_DialogKind k) => setState(() => _kind = k),
          ),
        ],
      ),
      PlayControlGroup(title: 'Options', children: _kindControls),
    ];
  }
}
