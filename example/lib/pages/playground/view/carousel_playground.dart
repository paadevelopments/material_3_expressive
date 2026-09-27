import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ECarousel].
class CarouselPlayground extends StatefulWidget {
  /// Creates the carousel playground.
  const CarouselPlayground({super.key});

  @override
  State<CarouselPlayground> createState() => _CarouselPlaygroundState();
}

class _CarouselPlaygroundState extends State<CarouselPlayground> {
  M3ECarouselType _type = M3ECarouselType.hero;
  M3ECarouselHeroAlignment _alignment = M3ECarouselHeroAlignment.center;
  Axis _axis = Axis.horizontal;
  bool _isExtended = false;
  bool _freeScroll = false;
  bool _showAll = true;
  bool _header = false;
  bool _showTitles = true;

  static const List<({String image, String title})> _images =
      <({String image, String title})>[
        (image: 'assets/i1.png', title: 'Android'),
        (image: 'assets/i2.png', title: 'iOS'),
        (image: 'assets/i3.png', title: 'Windows'),
        (image: 'assets/i4.png', title: 'Mac'),
        (image: 'assets/i5.png', title: 'Linux'),
        (image: 'assets/i6.png', title: 'Others'),
      ];

  List<PlaySnippet> get _snippets {
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Carousel',
        code:
            '''
$kPlaySnippetImport

final M3ECarouselController controller = M3ECarouselController();

M3ECarousel(
  controller: controller,
  axis: Axis.${_axis.name},
  type: M3ECarouselType.${_type.name},
  freeScroll: $_freeScroll,
  showAll: $_showAll,
  children: <M3ECarouselItem>[
    M3ECarouselItem(
      image: Image.asset('assets/i1.png', fit: BoxFit.cover),
      title: const Text('Android'),
      subtitle: const Text('Photo'),
      onTap: () {},
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
          return _CarouselDemoHost(
            type: _type,
            alignment: _alignment,
            axis: _axis,
            isExtended: _isExtended,
            freeScroll: _freeScroll,
            showTitles: _showTitles,
            showAll: _showAll,
            header: _header,
          );
        },
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.orientationOf(context) == Orientation.landscape &&
        _type == M3ECarouselType.fullScreen) {
      _type = M3ECarouselType.hero;
    }
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final bool landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    final List<M3ECarouselType> types = <M3ECarouselType>[
      for (final M3ECarouselType type in M3ECarouselType.values)
        if (!landscape || type != M3ECarouselType.fullScreen) type,
    ];
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Carousel demo',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Opens a full screen so the carousel can scroll at its real '
                'size. Titles follow the focused item.',
                style: theme.typeScale.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              M3EButton(
                onPressed: _openDemo,
                child: const Text('Open carousel demo'),
              ),
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Layout',
          children: <Widget>[
            PlayEnumMenu<M3ECarouselType>(
              label: 'Type',
              value: _type,
              values: types,
              labelOf: (M3ECarouselType v) => v.name,
              onChanged: (M3ECarouselType v) => setState(() => _type = v),
            ),
            if (_type != M3ECarouselType.fullScreen)
              PlayEnumSegmented<Axis>(
                label: 'Axis',
                value: _axis,
                values: Axis.values,
                labelOf: (Axis v) => v.name,
                onChanged: (Axis v) => setState(() => _axis = v),
              ),
            if (_type == M3ECarouselType.hero)
              PlayEnumMenu<M3ECarouselHeroAlignment>(
                label: 'Hero alignment',
                value: _alignment,
                values: M3ECarouselHeroAlignment.values,
                labelOf: (M3ECarouselHeroAlignment v) => v.name,
                onChanged: (M3ECarouselHeroAlignment v) {
                  setState(() => _alignment = v);
                },
              ),
            if (_type == M3ECarouselType.contained)
              PlaySwitch(
                label: 'Extended',
                value: _isExtended,
                onChanged: (bool v) => setState(() => _isExtended = v),
              ),
            PlaySwitch(
              label: 'Free scroll',
              value: _freeScroll,
              onChanged: (bool v) => setState(() => _freeScroll = v),
            ),
            if (_type != M3ECarouselType.fullScreen)
              PlaySwitch(
                label: 'Show all',
                value: _showAll,
                onChanged: (bool v) => setState(() => _showAll = v),
              ),
            if (_type != M3ECarouselType.fullScreen)
              PlaySwitch(
                label: 'Header',
                value: _header,
                onChanged: (bool v) => setState(() => _header = v),
              ),
            PlaySwitch(
              label: 'Show titles',
              value: _showTitles,
              onChanged: (bool v) => setState(() => _showTitles = v),
            ),
          ],
        ),
      ],
    );
  }
}

class _CarouselDemoHost extends StatefulWidget {
  const _CarouselDemoHost({
    required this.type,
    required this.alignment,
    required this.axis,
    required this.isExtended,
    required this.freeScroll,
    required this.showTitles,
    required this.showAll,
    required this.header,
  });

  final M3ECarouselType type;
  final M3ECarouselHeroAlignment alignment;
  final Axis axis;
  final bool isExtended;
  final bool freeScroll;
  final bool showTitles;
  final bool showAll;
  final bool header;

  @override
  State<_CarouselDemoHost> createState() => _CarouselDemoHostState();
}

class _CarouselDemoHostState extends State<_CarouselDemoHost> {
  int _focalIndex = 1;
  final M3ECarouselController _controller = M3ECarouselController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _carousel(String title) {
    final M3EThemeData theme = M3ETheme.of(context);
    final TextStyle titleStyle = theme.typeScale.titleMedium.copyWith(
      color: const Color(0xFFFFFFFF),
    );
    final TextStyle bodyStyle = theme.typeScale.bodyMedium.copyWith(
      color: const Color(0xFFFFFFFF),
    );
    return M3ECarousel(
      controller: _controller,
      axis: widget.type == M3ECarouselType.fullScreen
          ? Axis.vertical
          : widget.axis,
      type: widget.type,
      isExtended: widget.isExtended,
      freeScroll: widget.freeScroll,
      showAll: widget.showAll,
      header: widget.header ? Text(title) : null,
      heroAlignment: widget.alignment,
      onChange: (M3ECarouselChangeDetails details) {
        if (!mounted || _focalIndex == details.focalIndex) {
          return;
        }
        setState(() => _focalIndex = details.focalIndex);
      },
      children: <M3ECarouselItem>[
        for (int i = 0; i < _CarouselPlaygroundState._images.length; i++)
          M3ECarouselItem(
            semanticLabel: _CarouselPlaygroundState._images[i].title,
            title: widget.showTitles
                ? Text(
                    _CarouselPlaygroundState._images[i].title,
                    style: titleStyle,
                  )
                : null,
            subtitle: widget.showTitles
                ? Text('Photo', style: bodyStyle)
                : null,
            prefixText: widget.showTitles
                ? Text('P${i + 1}', style: bodyStyle)
                : null,
            aspectRatio: i.isEven ? 16 / 9 : 9 / 16,
            showScrim: const M3ECarouselScrim(
              color: Color(0xFF000000),
              opacity: 0.45,
            ),
            onTap: () {},
            transform: i == 0
                ? _CarouselDestination(
                    title: _CarouselPlaygroundState._images[i].title,
                  )
                : null,
            image: Image.asset(
              _CarouselPlaygroundState._images[i].image,
              fit: BoxFit.cover,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final String title = _CarouselPlaygroundState._images[_focalIndex].title;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: M3EAppBar.top(
        titleText: title,
        leading: M3EIconButton(
          variant: M3EIconButtonVariant.standard,
          icon: const Icon(M3EIcons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: <Widget>[
          M3EIconButton(
            variant: M3EIconButtonVariant.standard,
            icon: const Icon(M3EIcons.arrow_back),
            tooltip: 'Previous item',
            onPressed: _controller.previous,
          ),
          M3EIconButton(
            variant: M3EIconButtonVariant.standard,
            icon: const Icon(M3EIcons.arrow_forward),
            tooltip: 'Next item',
            onPressed: _controller.next,
          ),
        ],
      ),
      body: widget.type == M3ECarouselType.fullScreen
          ? _carousel(title)
          : Padding(
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal:
                    widget.type == M3ECarouselType.uncontained ||
                        widget.type == M3ECarouselType.uncontainedMultiAspect
                    ? 0
                    : 8,
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: widget.axis == Axis.vertical ? 320 : 200,
                  width: widget.axis == Axis.vertical ? 200 : double.infinity,
                  child: _carousel(title),
                ),
              ),
            ),
    );
  }
}

class _CarouselDestination extends StatelessWidget {
  const _CarouselDestination({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title, style: theme.typeScale.headlineMedium),
            const SizedBox(height: 16),
            M3EButton(
              style: M3EButtonStyle.text,
              onPressed: () => M3ECardContainerTransformScope.closeOf(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
