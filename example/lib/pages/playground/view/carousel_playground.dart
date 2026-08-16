import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

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
  bool _showTitles = true;
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

  List<PlaySnippet> get _snippets {
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Carousel',
        code:
            '''
$kPlaySnippetImport

M3ECarousel(
  axis: Axis.${_axis.name},
  type: M3ECarouselType.${_type.name},
  isExtended: $_isExtended,
  freeScroll: $_freeScroll,
  heroAlignment: M3ECarouselHeroAlignment.${_alignment.name},
  children: <Widget>[
    Image.asset('assets/i1.png', fit: BoxFit.cover),
    Image.asset('assets/i2.png', fit: BoxFit.cover),
    Image.asset('assets/i3.png', fit: BoxFit.cover),
  ],
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool vertical = _axis == Axis.vertical;
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Carousel',
          child: SizedBox(
            height: vertical ? 320 : 200,
            width: vertical ? 200 : null,
            child: M3ECarousel(
              key: ValueKey<Object>('$_type-$_axis-$_alignment-$_isExtended'),
              axis: _axis,
              type: _type,
              isExtended: _isExtended,
              freeScroll: _freeScroll,
              heroAlignment: _alignment,
              onChange: (M3ECarouselChangeDetails details) {
                setState(() => _focalIndex = details.focalIndex);
              },
              children: <Widget>[
                for (int i = 0; i < _images.length; i++)
                  _CarouselImage(
                    asset: _images[i].image,
                    title: _images[i].title,
                    showTitle: _showTitles && i == _focalIndex,
                  ),
              ],
            ),
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
              values: M3ECarouselType.values,
              labelOf: (M3ECarouselType v) => v.name,
              onChanged: (M3ECarouselType v) => setState(() => _type = v),
            ),
            PlayEnumSegmented<Axis>(
              label: 'Axis',
              value: _axis,
              values: Axis.values,
              labelOf: (Axis v) => v.name,
              onChanged: (Axis v) => setState(() => _axis = v),
            ),
            PlayEnumMenu<M3ECarouselHeroAlignment>(
              label: 'Hero alignment',
              value: _alignment,
              values: M3ECarouselHeroAlignment.values,
              labelOf: (M3ECarouselHeroAlignment v) => v.name,
              onChanged: (M3ECarouselHeroAlignment v) {
                setState(() => _alignment = v);
              },
            ),
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

class _CarouselImage extends StatelessWidget {
  const _CarouselImage({
    required this.asset,
    required this.title,
    required this.showTitle,
  });

  final String asset;
  final String title;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(asset, fit: BoxFit.cover),
        if (showTitle)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Color(0x00000000), Color(0x80000000)],
              ),
            ),
          ),
        if (showTitle)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
