import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3ECarousel].
class CarouselPlayground extends PlaygroundWidget {
  /// Creates the carousel playground.
  const CarouselPlayground({super.key});

  @override
  PlaygroundState<CarouselPlayground> createState() =>
      _CarouselPlaygroundState();
}

class _CarouselPlaygroundState extends PlaygroundState<CarouselPlayground> {
  final M3ECarouselController _controller = M3ECarouselController();

  M3ECarouselType _type = M3ECarouselType.hero;
  M3ECarouselHeroAlignment _alignment = M3ECarouselHeroAlignment.center;
  Axis _axis = Axis.horizontal;
  bool _isExtended = false;
  bool _freeScroll = false;
  bool _showAll = true;
  bool _header = false;
  bool _showTitles = true;
  bool _scrim = true;
  bool _transform = true;
  bool _customRadius = false;
  double _radius = 28;
  double _uncontainedExtent = M3ECarouselTheme.defaultUncontainedItemExtent;
  M3EHapticFeedback _haptic = M3EHapticFeedback.none;
  int _focalIndex = 1;

  static const List<({String image, String title})> _images =
      <({String image, String title})>[
        (image: 'assets/i1.png', title: 'Android'),
        (image: 'assets/i2.png', title: 'iOS'),
        (image: 'assets/i3.png', title: 'Windows'),
        (image: 'assets/i4.png', title: 'Mac'),
        (image: 'assets/i5.png', title: 'Linux'),
        (image: 'assets/i6.png', title: 'Others'),
      ];

  bool get _fullScreen => _type == M3ECarouselType.fullScreen;

  bool get _uncontained =>
      _type == M3ECarouselType.uncontained ||
      _type == M3ECarouselType.uncontainedMultiAspect;

  Axis get _effectiveAxis => _fullScreen ? Axis.vertical : _axis;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<M3ECarouselType> _types(BuildContext context) {
    final bool landscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;
    return <M3ECarouselType>[
      for (final M3ECarouselType type in M3ECarouselType.values)
        if (!landscape || type != M3ECarouselType.fullScreen) type,
    ];
  }

  Widget _carousel(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final TextStyle titleStyle = theme.typeScale.titleMedium.copyWith(
      color: const Color(0xFFFFFFFF),
    );
    final TextStyle bodyStyle = theme.typeScale.bodyMedium.copyWith(
      color: const Color(0xFFFFFFFF),
    );
    return M3ECarousel(
      // Layout options only apply when the carousel is created.
      key: ValueKey<String>('$_type-$_axis-$_isExtended-$_uncontainedExtent'),
      controller: _controller,
      axis: _effectiveAxis,
      type: _type,
      isExtended: _type == M3ECarouselType.contained ? _isExtended : null,
      freeScroll: _freeScroll,
      showAll: !_fullScreen && _showAll,
      header: !_fullScreen && _header ? Text(_images[_focalIndex].title) : null,
      heroAlignment: _alignment,
      uncontainedItemExtent: _uncontainedExtent,
      childElementBorderRadius: _customRadius ? _radius : null,
      haptic: _haptic,
      onChange: (M3ECarouselChangeDetails details) {
        if (!mounted || _focalIndex == details.focalIndex) {
          return;
        }
        setState(() => _focalIndex = details.focalIndex);
      },
      children: <M3ECarouselItem>[
        for (int i = 0; i < _images.length; i++)
          M3ECarouselItem(
            semanticLabel: _images[i].title,
            title: _showTitles
                ? Text(_images[i].title, style: titleStyle)
                : null,
            subtitle: _showTitles ? Text('Photo', style: bodyStyle) : null,
            prefixText: _showTitles
                ? Text('P${i + 1}', style: bodyStyle)
                : null,
            aspectRatio: i.isEven ? 16 / 9 : 9 / 16,
            showScrim: _scrim
                ? const M3ECarouselScrim(
                    color: Color(0xFF000000),
                    opacity: 0.45,
                  )
                : null,
            onTap: () {},
            transform: _transform && i == 0
                ? _CarouselDestination(title: _images[i].title)
                : null,
            image: Image.asset(_images[i].image, fit: BoxFit.cover),
          ),
      ],
    );
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    if (_fullScreen) {
      return Padding(
        padding: EdgeInsets.only(top: padding.top),
        child: _carousel(context),
      );
    }
    final bool vertical = _axis == Axis.vertical;
    return SingleChildScrollView(
      primary: true,
      padding: _uncontained
          ? padding.copyWith(left: 0, right: 0)
          : padding.copyWith(left: 8, right: 8),
      child: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          height: vertical ? 420 : 220,
          width: vertical ? 220 : double.infinity,
          child: _carousel(context),
        ),
      ),
    );
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    return PlaygroundSlots(
      appBar: M3EAppBar.top(
        titleText: _images[_focalIndex].title,
        leading: chrome.leading,
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
          ...chrome.trailingActions,
        ],
      ),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln('  controller: controller,')
      ..writeln('  type: M3ECarouselType.${_type.name},')
      ..writeln('  axis: Axis.${_effectiveAxis.name},');
    if (_type == M3ECarouselType.hero) {
      args.writeln(
        '  heroAlignment: M3ECarouselHeroAlignment.${_alignment.name},',
      );
    }
    if (_type == M3ECarouselType.contained) {
      args.writeln('  isExtended: $_isExtended,');
    }
    if (_uncontained) {
      args.writeln('  uncontainedItemExtent: ${_uncontainedExtent.round()},');
    }
    if (_customRadius) {
      args.writeln('  childElementBorderRadius: ${_radius.round()},');
    }
    args.writeln('  freeScroll: $_freeScroll,');
    if (!_fullScreen) {
      args.writeln('  showAll: $_showAll,');
      if (_header) {
        args.writeln("  header: const Text('Android'),");
      }
    }
    if (_haptic != M3EHapticFeedback.none) {
      args.writeln('  haptic: M3EHapticFeedback.${_haptic.name},');
    }
    final String titles = _showTitles
        ? "      title: const Text('Android'),\n"
              "      subtitle: const Text('Photo'),\n"
        : '';
    final String scrim = _scrim
        ? '      showScrim: const M3ECarouselScrim(opacity: 0.45),\n'
        : '';
    final String transform = _transform
        ? '      transform: const DetailPage(),\n'
        : '';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Carousel',
        code:
            '''
$kPlaySnippetImport

final controller = M3ECarouselController();

M3ECarousel(
$args  children: <M3ECarouselItem>[
    M3ECarouselItem(
      image: Image.asset('assets/i1.png', fit: BoxFit.cover),
$titles$scrim$transform      onTap: () {},
    ),
  ],
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    final List<M3ECarouselType> types = _types(context);
    return <Widget>[
      PlayControlGroup(
        title: 'Layout',
        children: <Widget>[
          PlayEnumChoice<M3ECarouselType>(
            label: 'Type',
            value: types.contains(_type) ? _type : M3ECarouselType.hero,
            values: types,
            labelOf: (M3ECarouselType v) => v.name,
            onChanged: (M3ECarouselType v) => setState(() => _type = v),
          ),
          if (!_fullScreen)
            PlayEnumChoice<Axis>(
              label: 'Axis',
              value: _axis,
              values: Axis.values,
              labelOf: (Axis v) => v.name,
              onChanged: (Axis v) => setState(() => _axis = v),
            ),
          if (_type == M3ECarouselType.hero)
            PlayEnumChoice<M3ECarouselHeroAlignment>(
              label: 'Hero alignment',
              value: _alignment,
              values: M3ECarouselHeroAlignment.values,
              labelOf: (M3ECarouselHeroAlignment v) => v.name,
              onChanged: (M3ECarouselHeroAlignment v) {
                setState(() => _alignment = v);
              },
            ),
          if (_uncontained)
            PlaySlider(
              label: 'Item extent',
              value: _uncontainedExtent,
              min: 160,
              max: 400,
              divisions: 24,
              onChanged: (double v) => setState(() => _uncontainedExtent = v),
            ),
          if (_type == M3ECarouselType.contained)
            PlaySwitchItem(
              label: 'Extended',
              value: _isExtended,
              onChanged: (bool v) => setState(() => _isExtended = v),
            ),
          if (!_fullScreen) ...<Widget>[
            PlaySwitchItem(
              label: 'Header',
              description: 'Title row above the carousel',
              value: _header,
              onChanged: (bool v) => setState(() => _header = v),
            ),
            PlaySwitchItem(
              label: 'Show all',
              description: 'A show-all control beside the items',
              value: _showAll,
              onChanged: (bool v) => setState(() => _showAll = v),
            ),
          ],
          PlaySwitchItem(
            label: 'Custom corner radius',
            value: _customRadius,
            onChanged: (bool v) => setState(() => _customRadius = v),
          ),
          if (_customRadius)
            PlaySlider(
              label: 'Corner radius',
              value: _radius,
              max: 48,
              divisions: 48,
              onChanged: (double v) => setState(() => _radius = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Items',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Titles',
            description: 'Title, subtitle and prefix text',
            value: _showTitles,
            onChanged: (bool v) => setState(() => _showTitles = v),
          ),
          PlaySwitchItem(
            label: 'Scrim',
            description: 'Darkens images under the text',
            value: _scrim,
            onChanged: (bool v) => setState(() => _scrim = v),
          ),
          PlaySwitchItem(
            label: 'Container transform',
            description: 'The first item opens a page',
            value: _transform,
            onChanged: (bool v) => setState(() => _transform = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Behavior',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Free scroll',
            description: 'No snapping to items',
            value: _freeScroll,
            onChanged: (bool v) => setState(() => _freeScroll = v),
          ),
          PlayEnumChoice<M3EHapticFeedback>(
            label: 'Haptic',
            value: _haptic,
            values: M3EHapticFeedback.values,
            labelOf: (M3EHapticFeedback v) => v.name,
            onChanged: (M3EHapticFeedback v) => setState(() => _haptic = v),
          ),
        ],
      ),
    ];
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
