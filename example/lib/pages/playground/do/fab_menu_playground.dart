import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EFabMenu].
class FabMenuPlayground extends StatefulWidget {
  /// Creates the FAB menu playground.
  const FabMenuPlayground({super.key});

  @override
  State<FabMenuPlayground> createState() => _FabMenuPlaygroundState();
}

class _FabMenuPlaygroundState extends State<FabMenuPlayground> {
  M3EFabMenuPosition _position = M3EFabMenuPosition.right;
  M3EFabSize _size = M3EFabSize.medium;
  M3EFabColor _color = M3EFabColor.primary;
  bool _useTransform = false;
  bool _manyItems = false;
  bool _gradient = false;

  List<PlaySnippet> get _snippets {
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
  items: <M3EFabMenuItem>[
    M3EFabMenuItem(
      icon: const Icon(M3EIcons.image),
      label: 'Image',
      onPressed: () {},${_useTransform ? '''
      openBuilder: (context) => const DetailPage(),''' : ''}
    ),
    M3EFabMenuItem(
      icon: const Icon(M3EIcons.videocam),
      label: 'Video',
      onPressed: () {},
    ),
    M3EFabMenuItem(
      icon: const Icon(M3EIcons.mic),
      label: 'Audio',
      onPressed: () {},
    ),
  ],
);''',
      ),
    ];
  }

  void _openDemo() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return _FabMenuDemoHost(
            position: _position,
            size: _size,
            color: _color,
            useTransform: _useTransform,
            manyItems: _manyItems,
            gradient: _gradient,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'FAB menu demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a scaffold with the FAB menu. Scroll a short viewport '
                'to move items behind the close button; optional item '
                'container transform and gradient fill.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open FAB menu demo'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Demo options',
          children: <Widget>[
            PlayEnumSegmented<M3EFabMenuPosition>(
              label: 'Position',
              value: _position,
              values: M3EFabMenuPosition.values,
              labelOf: (M3EFabMenuPosition v) => v.name,
              onChanged: (M3EFabMenuPosition v) {
                setState(() => _position = v);
              },
            ),
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
            PlaySwitch(
              label: 'Six items (scroll)',
              value: _manyItems,
              onChanged: (bool v) => setState(() => _manyItems = v),
            ),
            PlaySwitch(
              label: 'Item container transform',
              value: _useTransform,
              onChanged: (bool v) => setState(() => _useTransform = v),
            ),
            PlaySwitch(
              label: 'Gradient fill',
              value: _gradient,
              onChanged: (bool v) => setState(() => _gradient = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _FabMenuDemoHost extends StatelessWidget {
  const _FabMenuDemoHost({
    required this.position,
    required this.size,
    required this.color,
    required this.useTransform,
    required this.manyItems,
    required this.gradient,
  });

  final M3EFabMenuPosition position;
  final M3EFabSize size;
  final M3EFabColor color;
  final bool useTransform;
  final bool manyItems;
  final bool gradient;

  static const LinearGradient _fill = LinearGradient(
    colors: <Color>[Color(0xFF6750A4), Color(0xFF9A82DB)],
  );

  static const LinearGradient _outline = LinearGradient(
    colors: <Color>[Color(0xFF4F378B), Color(0xFFD0BCFF)],
  );

  static const LinearGradient _foreground = LinearGradient(
    colors: <Color>[Color(0xFFFFFFFF), Color(0xFFEADDFF)],
  );

  List<M3EFabMenuItem> _items() {
    final labels = manyItems
        ? const <String>[
            'Document',
            'Message',
            'Folder',
            'Album',
            'Photo',
            'Video',
          ]
        : const <String>['Image', 'Video', 'Audio'];
    final icons = manyItems
        ? const <IconData>[
            M3EIcons.description,
            M3EIcons.message,
            M3EIcons.folder,
            M3EIcons.image,
            M3EIcons.photo,
            M3EIcons.videocam,
          ]
        : const <IconData>[M3EIcons.image, M3EIcons.videocam, M3EIcons.mic];

    return <M3EFabMenuItem>[
      for (int i = 0; i < labels.length; i++)
        M3EFabMenuItem(
          icon: Icon(icons[i]),
          label: labels[i],
          onPressed: () {},
          openBuilder: useTransform && i == 0
              ? (BuildContext context) {
                  return Scaffold(
                    backgroundColor: M3ETheme.of(context).colorScheme.surface,
                    appBar: M3EAppBar.top(
                      titleText: labels[i],
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final Widget menu = M3EFabMenu(
      position: position,
      size: size,
      color: color,
      decoration: gradient
          ? M3EFabDecoration(
              backgroundGradient: WidgetStateProperty.all(_fill),
              foregroundGradient: WidgetStateProperty.all(_foreground),
              outlineGradient: WidgetStateProperty.all(_outline),
            )
          : null,
      items: _items(),
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: 'FAB menu demo',
        leading: M3EIconButton(
          variant: M3EIconButtonVariant.standard,
          icon: const Icon(M3EIcons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
      ),
      // Short body so six items must scroll behind the close FAB.
      body: manyItems
          ? const SizedBox(height: 120)
          : M3ECardList.builder(
              itemCount: 12,
              listPadding: const EdgeInsets.fromLTRB(16, 8, 16, 88),
              itemBuilder: (BuildContext context, int index) {
                return M3EListItem(
                  headline: 'Item $index',
                  supportingText: 'Open the FAB menu from the corner',
                  leading: const Icon(M3EIcons.label),
                );
              },
            ),
      floatingActionButtonLocation: position == M3EFabMenuPosition.left
          ? FloatingActionButtonLocation.startFloat
          : FloatingActionButtonLocation.endFloat,
      floatingActionButton: gradient
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
}
