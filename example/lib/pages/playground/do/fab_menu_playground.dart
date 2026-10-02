import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3EFabMenu].
class FabMenuPlayground extends PlaygroundWidget {
  /// Creates the FAB menu playground.
  const FabMenuPlayground({super.key});

  @override
  PlaygroundState<FabMenuPlayground> createState() => _FabMenuPlaygroundState();
}

class _FabMenuPlaygroundState extends PlaygroundState<FabMenuPlayground> {
  M3EFabMenuPosition _position = M3EFabMenuPosition.right;
  M3EFabSize _size = M3EFabSize.medium;
  M3EFabColor _color = M3EFabColor.primary;
  double _itemCount = 3;
  bool _customIcons = false;
  bool _useTransform = false;
  bool _gradient = false;

  static const List<(IconData, String, String)> _entries =
      <(IconData, String, String)>[
        (M3EIcons.image, 'image', 'Image'),
        (M3EIcons.videocam, 'videocam', 'Video'),
        (M3EIcons.mic, 'mic', 'Audio'),
        (M3EIcons.description, 'description', 'Document'),
        (M3EIcons.folder, 'folder', 'Folder'),
        (M3EIcons.message, 'message', 'Message'),
      ];

  static const LinearGradient _fill = LinearGradient(
    colors: <Color>[Color(0xFF6750A4), Color(0xFF9A82DB)],
  );

  static const LinearGradient _outline = LinearGradient(
    colors: <Color>[Color(0xFF4F378B), Color(0xFFD0BCFF)],
  );

  static const LinearGradient _foreground = LinearGradient(
    colors: <Color>[Color(0xFFFFFFFF), Color(0xFFEADDFF)],
  );

  int get _count => _itemCount.round();

  List<M3EFabMenuItem> get _items => <M3EFabMenuItem>[
    for (int i = 0; i < _count; i++)
      M3EFabMenuItem(
        icon: Icon(_entries[i].$1),
        label: _entries[i].$3,
        onPressed: () {},
        openBuilder: _useTransform && i == 0
            ? (BuildContext context) => _detailPage(context, _entries[i].$3)
            : null,
      ),
  ];

  Widget _detailPage(BuildContext context, String title) {
    return Scaffold(
      backgroundColor: M3ETheme.of(context).colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: title,
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
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    return M3EList.scrollable(
      controller: PrimaryScrollController.of(context),
      color: M3ETheme.of(context).colorScheme.surfaceContainerHighest,
      itemCount: 20,
      listPadding: padding.copyWith(bottom: padding.bottom + 88),
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: 'Item ${index + 1}',
          supportingText: 'Open the FAB menu from the corner',
          leading: const Icon(M3EIcons.label),
        );
      },
    );
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    final M3EThemeData theme = M3ETheme.of(context);
    final Widget menu = M3EFabMenu(
      position: _position,
      size: _size,
      color: _color,
      icon: _customIcons ? const Icon(M3EIcons.edit) : const Icon(M3EIcons.add),
      closeIcon: _customIcons
          ? const Icon(M3EIcons.expand_more)
          : const Icon(M3EIcons.close),
      decoration: _gradient
          ? M3EFabDecoration(
              backgroundGradient: WidgetStateProperty.all(_fill),
              foregroundGradient: WidgetStateProperty.all(_foreground),
              outlineGradient: WidgetStateProperty.all(_outline),
            )
          : null,
      items: _items,
    );
    return PlaygroundSlots(
      floatingActionButtonLocation: _position == M3EFabMenuPosition.left
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: _gradient
          ? M3ETheme(
              data: theme.copyWith(
                fabMenuTheme: theme.fabMenuTheme.copyWith(
                  itemBackgroundGradient: _fill,
                  itemForegroundGradient: _foreground,
                  itemOutlineGradient: _outline,
                ),
              ),
              child: menu,
            )
          : menu,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer items = StringBuffer();
    for (int i = 0; i < _count; i++) {
      final String transform = _useTransform && i == 0
          ? '\n      openBuilder: (context) => const DetailPage(),'
          : '';
      items.writeln(
        '    M3EFabMenuItem(\n'
        '      icon: const Icon(M3EIcons.${_entries[i].$2}),\n'
        "      label: '${_entries[i].$3}',\n"
        '      onPressed: () {},$transform\n'
        '    ),',
      );
    }
    final String icons = _customIcons
        ? '  icon: const Icon(M3EIcons.edit),\n'
              '  closeIcon: const Icon(M3EIcons.expand_more),\n'
        : '';
    final String decoration = _gradient
        ? '  decoration: M3EFabDecoration(\n'
              '    backgroundGradient: WidgetStateProperty.all(gradient),\n'
              '  ),\n'
        : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'FAB menu',
        code:
            '''
$kPlaySnippetImport

final menuController = M3EFabMenuController();

M3EFabMenu(
  controller: menuController,
  position: M3EFabMenuPosition.${_position.name},
  size: M3EFabSize.${_size.name},
  color: M3EFabColor.${_color.name},
$icons$decoration  items: <M3EFabMenuItem>[
$items  ],
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
            label: 'Closed size',
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
          PlayEnumChoice<M3EFabMenuPosition>(
            label: 'Position',
            value: _position,
            values: M3EFabMenuPosition.values,
            labelOf: (M3EFabMenuPosition v) => v.name,
            onChanged: (M3EFabMenuPosition v) => setState(() => _position = v),
          ),
          PlaySwitchItem(
            label: 'Custom icons',
            description: 'Edit when closed, expand more when open',
            value: _customIcons,
            onChanged: (bool v) => setState(() => _customIcons = v),
          ),
          PlaySwitchItem(
            label: 'Gradient fill',
            description: 'Trigger and menu items',
            value: _gradient,
            onChanged: (bool v) => setState(() => _gradient = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Items',
        children: <Widget>[
          PlaySlider(
            label: 'Count',
            value: _itemCount,
            min: 2,
            max: _entries.length.toDouble(),
            divisions: _entries.length - 2,
            onChanged: (double v) => setState(() => _itemCount = v),
          ),
          PlaySwitchItem(
            label: 'Container transform',
            description: 'The first item opens a page',
            value: _useTransform,
            onChanged: (bool v) => setState(() => _useTransform = v),
          ),
        ],
      ),
    ];
  }
}
