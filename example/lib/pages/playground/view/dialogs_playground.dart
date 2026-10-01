import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EDialog].
class DialogsPlayground extends StatefulWidget {
  /// Creates the dialogs playground.
  const DialogsPlayground({super.key});

  @override
  State<DialogsPlayground> createState() => _DialogsPlaygroundState();
}

class _DialogsPlaygroundState extends State<DialogsPlayground> {
  String _title = 'Reset settings?';
  String _content = 'This will restore all settings to their default values.';
  bool _showIcon = true;
  bool _topDivider = false;
  bool _bottomDivider = false;
  bool _barrierDismissible = true;
  bool _multiSelect = false;
  bool _longContent = false;
  bool _truncateTitle = false;
  M3EDialogPosition _position = M3EDialogPosition.center;
  bool _textField = false;
  bool _leadingAction = false;
  bool _bottomBar = false;
  bool _unsaved = true;

  List<PlaySnippet> get _snippets {
    final String icon = _showIcon
        ? '\n    icon: const Icon(M3EIcons.error),'
        : '';
    final String maxLines = _truncateTitle ? '\n    titleMaxLines: 1,' : '';
    final String align = _position == M3EDialogPosition.center
        ? ''
        : '\n  position: M3EDialogPosition.${_position.name},';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Dialog',
        code:
            '''
$kPlaySnippetImport

M3EDialog.show<void>(
  context,
  barrierDismissible: $_barrierDismissible,$align
  dialog: M3EDialog(
    title: ${playDartString(_title)},$icon$maxLines
    content: Text(${playDartString(_content)}),
    topDivider: $_topDivider,
    bottomDivider: $_bottomDivider,
    actions: <Widget>[
      M3EButton(
        style: M3EButtonStyle.text,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      M3EButton(
        style: M3EButtonStyle.text,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Confirm'),
      ),
    ],
  ),
);''',
      ),
      PlaySnippet(
        label: 'Selection',
        code:
            '''
$kPlaySnippetImport

await M3EDialog.showSelectionScreen(
  context,
  title: ${playDartString(_title)},
  multiSelect: $_multiSelect,
  barrierDismissible: $_barrierDismissible,
  options: const <String>['Standard', 'Pro', 'Team', 'Enterprise'],
  confirmLabel: ${_multiSelect ? "'Done'" : "'OK'"},
);''',
      ),
      PlaySnippet(
        label: 'Full screen',
        code:
            '''
$kPlaySnippetImport

final controller = M3EDialogController(hasUnsavedChanges: $_unsaved);
M3EDialog.showFullScreen<void>(
  context,
  title: 'New event',
  confirmLabel: 'Save',
  onConfirm: () => controller.close(),
  controller: controller,
  contentPadding: EdgeInsets.zero,
  body: M3EList.scrollable(
    variant: M3ECardVariant.filled,
    listPadding: const EdgeInsets.all(16),
    itemCount: 20,
    itemBuilder: (BuildContext context, int index) => M3EListItem(
      headline: 'Field \${index + 1}',
      onTap: () {},
    ),
  ),
);''',
      ),
      PlaySnippet(
        label: 'Adaptive',
        code:
            '''
$kPlaySnippetImport

M3EDialog.showAdaptive<void>(
  context,
  title: 'Create a new album',
  content: Text(${playDartString(_content)}),
  confirmLabel: 'Save',
  onConfirm: () => Navigator.of(context).pop(),
);''',
      ),
      const PlaySnippet(
        label: 'FAB transform',
        code:
            '''
$kPlaySnippetImport

M3EFab(
  icon: const Icon(M3EIcons.add),
  openBuilder: (BuildContext context) => M3EFullScreenDialog(
    title: 'New event',
    confirmLabel: 'Save',
    onConfirm: () => M3EFabContainerTransformScope.closeOf(context),
    contentPadding: EdgeInsets.zero,
    body: M3EList.scrollable(
      variant: M3ECardVariant.filled,
      listPadding: const EdgeInsets.all(16),
      itemCount: 20,
      itemBuilder: (BuildContext context, int index) => M3EListItem(
        headline: 'Field \${index + 1}',
        onTap: () {},
      ),
    ),
  ),
);''',
      ),
    ];
  }

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
        titleMaxLines: _truncateTitle ? 1 : null,
        content: _buildContent(),
        topDivider: _topDivider,
        bottomDivider: _bottomDivider,
        leadingAction: _leadingAction
            ? M3EButton(
                style: M3EButtonStyle.text,
                onPressed: () {},
                child: const Text('Learn more'),
              )
            : null,
        actions: <Widget>[
          M3EButton(
            style: M3EButtonStyle.text,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          M3EButton(
            style: M3EButtonStyle.text,
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _showSelection() async {
    await M3EDialog.showSelectionScreen(
      context,
      title: _title,
      multiSelect: _multiSelect,
      barrierDismissible: _barrierDismissible,
      options: const <String>['Standard', 'Pro', 'Team', 'Enterprise'],
      confirmLabel: _multiSelect ? 'Done' : 'OK',
    );
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
      title: 'New event',
      confirmLabel: 'Save',
      onConfirm: controller.close,
      controller: controller,
      contentHeadline: _longContent ? _title : null,
      bottomActions: _bottomBar
          ? <Widget>[
              M3EButton(
                style: M3EButtonStyle.text,
                onPressed: controller.dismiss,
                child: const Text('Cancel'),
              ),
              M3EButton(
                style: M3EButtonStyle.text,
                onPressed: controller.close,
                child: const Text('Create'),
              ),
            ]
          : const <Widget>[],
      contentPadding: EdgeInsets.zero,
      body: _formList(),
    ).whenComplete(controller.dispose);
  }

  void _showAdaptive() {
    M3EDialog.showAdaptive<void>(
      context,
      title: 'Create a new album',
      content: _buildContent(),
      confirmLabel: 'Save',
      onConfirm: () => Navigator.of(context).pop(),
      position: _position,
    );
  }

  Widget _fullScreenDestination(BuildContext context) {
    return M3EFullScreenDialog(
      title: 'New event',
      confirmLabel: 'Save',
      onConfirm: () => M3EFabContainerTransformScope.closeOf(context),
      contentPadding: EdgeInsets.zero,
      body: _formList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Triggers',
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              M3EButton(
                style: M3EButtonStyle.tonal,
                onPressed: _showBasic,
                child: const Text('Dialog'),
              ),
              M3EButton(
                style: M3EButtonStyle.tonal,
                onPressed: _showSelection,
                child: const Text('Selection'),
              ),
              M3EButton(
                style: M3EButtonStyle.tonal,
                onPressed: _showFullScreen,
                child: const Text('Full screen'),
              ),
              M3EButton(
                style: M3EButtonStyle.tonal,
                onPressed: _showAdaptive,
                child: const Text('Adaptive'),
              ),
              M3EFab(
                size: M3EFabSize.small,
                icon: const Icon(M3EIcons.add),
                tooltip: 'Open full-screen dialog',
                openBuilder: _fullScreenDestination,
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlayTextField(
              label: 'Title',
              value: _title,
              onChanged: (String v) => setState(() => _title = v),
            ),
            PlayTextField(
              label: 'Content',
              value: _content,
              onChanged: (String v) => setState(() => _content = v),
            ),
            PlaySwitch(
              label: 'Show icon',
              value: _showIcon,
              onChanged: (bool v) => setState(() => _showIcon = v),
            ),
            PlaySwitch(
              label: 'Long content (scrolls)',
              value: _longContent,
              onChanged: (bool v) => setState(() => _longContent = v),
            ),
            PlaySwitch(
              label: 'Truncate headline (1 line)',
              value: _truncateTitle,
              onChanged: (bool v) => setState(() => _truncateTitle = v),
            ),
            PlaySwitch(
              label: 'Top divider',
              value: _topDivider,
              onChanged: (bool v) => setState(() => _topDivider = v),
            ),
            PlaySwitch(
              label: 'Bottom divider',
              value: _bottomDivider,
              onChanged: (bool v) => setState(() => _bottomDivider = v),
            ),
            PlaySwitch(
              label: 'Leading action (caution)',
              value: _leadingAction,
              onChanged: (bool v) => setState(() => _leadingAction = v),
            ),
          ],
        ),
        PlayControlPanel(
          title: 'Behavior',
          children: <Widget>[
            PlaySwitch(
              label: 'Barrier dismissible',
              value: _barrierDismissible,
              onChanged: (bool v) => setState(() => _barrierDismissible = v),
            ),
            PlayEnumSegmented<M3EDialogPosition>(
              label: 'Position',
              value: _position,
              values: M3EDialogPosition.values,
              labelOf: (M3EDialogPosition p) => p.name,
              onChanged: (M3EDialogPosition p) => setState(() => _position = p),
            ),
            PlaySwitch(
              label: 'Text field in content (keyboard)',
              value: _textField,
              onChanged: (bool v) => setState(() => _textField = v),
            ),
            PlaySwitch(
              label: 'Multi select (selection)',
              value: _multiSelect,
              onChanged: (bool v) => setState(() => _multiSelect = v),
            ),
            PlaySwitch(
              label: 'Unsaved changes (full screen)',
              value: _unsaved,
              onChanged: (bool v) => setState(() => _unsaved = v),
            ),
            PlaySwitch(
              label: 'Bottom action bar (full screen)',
              value: _bottomBar,
              onChanged: (bool v) => setState(() => _bottomBar = v),
            ),
          ],
        ),
      ],
    );
  }
}
