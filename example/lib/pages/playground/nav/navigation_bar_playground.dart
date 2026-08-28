import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ENavigationBar].
class NavigationBarPlayground extends StatefulWidget {
  /// Creates the navigation bar playground.
  const NavigationBarPlayground({super.key});

  @override
  State<NavigationBarPlayground> createState() =>
      _NavigationBarPlaygroundState();
}

class _NavigationBarPlaygroundState extends State<NavigationBarPlayground> {
  int _index = 0;
  M3ENavBarLabelBehavior _labelBehavior = M3ENavBarLabelBehavior.alwaysShow;
  M3ENavBarIconBehavior _iconBehavior = M3ENavBarIconBehavior.alwaysShow;
  bool _autoLayout = false;
  M3ENavBarLayout _layout = M3ENavBarLayout.compact;
  M3ENavBarAlignment _alignment = M3ENavBarAlignment.center;
  double _wideDestinationWidth = M3ENavBarConstants.wideDestinationWidth;
  bool _customBreakpoint = false;
  double _wideBreakpoint = M3ENavBarConstants.wideBreakpoint;
  M3ENavBarSize _size = M3ENavBarSize.medium;
  M3ENavBarShapeFamily _shape = M3ENavBarShapeFamily.square;
  M3ENavBarDensity _density = M3ENavBarDensity.regular;
  M3ENavBarIndicatorStyle _indicator = M3ENavBarIndicatorStyle.pill;
  bool _badges = true;

  List<M3ENavigationBarDestination> get _destinations {
    return <M3ENavigationBarDestination>[
      const M3ENavigationBarDestination(
        icon: Icon(M3EIcons.home),
        label: 'Home',
      ),
      M3ENavigationBarDestination(
        icon: const Icon(M3EIcons.search),
        label: 'Browse',
        badgeDot: _badges,
      ),
      M3ENavigationBarDestination(
        icon: const Icon(M3EIcons.radio),
        label: 'Radio',
        badgeCount: _badges ? 3 : null,
      ),
      const M3ENavigationBarDestination(
        icon: Icon(M3EIcons.library_music),
        label: 'Library',
      ),
    ];
  }

  List<PlaySnippet> get _snippets {
    final String destinations = _badges
        ? '''
  destinations: const <M3ENavigationBarDestination>[
    M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
    M3ENavigationBarDestination(
      icon: Icon(M3EIcons.search),
      label: 'Browse',
      badgeDot: true,
    ),
    M3ENavigationBarDestination(
      icon: Icon(M3EIcons.radio),
      label: 'Radio',
      badgeCount: 3,
    ),
    M3ENavigationBarDestination(
      icon: Icon(M3EIcons.library_music),
      label: 'Library',
    ),
  ],'''
        : '''
  destinations: const <M3ENavigationBarDestination>[
    M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.search), label: 'Browse'),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.radio), label: 'Radio'),
    M3ENavigationBarDestination(
      icon: Icon(M3EIcons.library_music),
      label: 'Library',
    ),
  ],''';
    final String breakpointLine = _customBreakpoint
        ? '\n  wideBreakpoint: ${_wideBreakpoint.round()},'
        : '';
    final String sample =
        '''
M3ENavigationBar(
$destinations
  selectedIndex: $_index,
  onDestinationSelected: (int i) {},
  autoLayout: $_autoLayout,
  layout: M3ENavBarLayout.${_layout.name},
  alignment: M3ENavBarAlignment.${_alignment.name},
  wideDestinationWidth: ${_wideDestinationWidth.round()},$breakpointLine
  labelBehavior: M3ENavBarLabelBehavior.${_labelBehavior.name},
  iconBehavior: M3ENavBarIconBehavior.${_iconBehavior.name},
  size: M3ENavBarSize.${_size.name},
  shapeFamily: M3ENavBarShapeFamily.${_shape.name},
  density: M3ENavBarDensity.${_density.name},
  indicatorStyle: M3ENavBarIndicatorStyle.${_indicator.name},
  safeArea: false,
);''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Navigation bar',
        code: '$kPlaySnippetImport\n$sample',
      ),
    ];
  }

  Widget _framed(M3EThemeData theme, Widget child) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: M3EShapes.radiusLarge,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: ClipRRect(borderRadius: M3EShapes.radiusLarge, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Navigation bar',
          child: _framed(
            theme,
            M3ENavigationBar(
              destinations: _destinations,
              selectedIndex: _index,
              onDestinationSelected: (int i) => setState(() => _index = i),
              autoLayout: _autoLayout,
              layout: _layout,
              alignment: _alignment,
              wideDestinationWidth: _wideDestinationWidth,
              wideBreakpoint: _customBreakpoint ? _wideBreakpoint : null,
              labelBehavior: _labelBehavior,
              iconBehavior: _iconBehavior,
              size: _size,
              shapeFamily: _shape,
              density: _density,
              indicatorStyle: _indicator,
              safeArea: false,
            ),
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Layout',
          children: <Widget>[
            PlaySwitch(
              label: 'Auto layout',
              value: _autoLayout,
              onChanged: (bool v) => setState(() => _autoLayout = v),
            ),
            PlayEnumSegmented<M3ENavBarLayout>(
              label: 'Layout',
              value: _layout,
              values: M3ENavBarLayout.values,
              labelOf: (M3ENavBarLayout v) => v.name,
              onChanged: (M3ENavBarLayout v) {
                setState(() {
                  _layout = v;
                  // layout is ignored while autoLayout is on
                  _autoLayout = false;
                });
              },
            ),
            PlayEnumSegmented<M3ENavBarAlignment>(
              label: 'Alignment',
              value: _alignment,
              values: M3ENavBarAlignment.values,
              labelOf: (M3ENavBarAlignment v) => v.name,
              onChanged: (M3ENavBarAlignment v) {
                setState(() => _alignment = v);
              },
            ),
            PlaySlider(
              label: 'Wide item width',
              value: _wideDestinationWidth,
              min: 80,
              max: 200,
              divisions: 24,
              onChanged: (double v) {
                setState(() => _wideDestinationWidth = v);
              },
            ),
            PlaySwitch(
              label: 'Custom breakpoint',
              value: _customBreakpoint,
              onChanged: (bool v) => setState(() => _customBreakpoint = v),
            ),
            if (_customBreakpoint)
              PlaySlider(
                label: 'Wide breakpoint',
                value: _wideBreakpoint,
                min: 200,
                max: 1000,
                divisions: 40,
                onChanged: (double v) {
                  setState(() => _wideBreakpoint = v);
                },
              ),
          ],
        ),
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumMenu<M3ENavBarLabelBehavior>(
              label: 'Labels',
              value: _labelBehavior,
              values: M3ENavBarLabelBehavior.values,
              labelOf: (M3ENavBarLabelBehavior v) => v.name,
              onChanged: (M3ENavBarLabelBehavior v) {
                setState(() => _labelBehavior = v);
              },
            ),
            PlayEnumMenu<M3ENavBarIconBehavior>(
              label: 'Icons',
              value: _iconBehavior,
              values: M3ENavBarIconBehavior.values,
              labelOf: (M3ENavBarIconBehavior v) => v.name,
              onChanged: (M3ENavBarIconBehavior v) {
                setState(() => _iconBehavior = v);
              },
            ),
            PlayEnumSegmented<M3ENavBarSize>(
              label: 'Size',
              value: _size,
              values: M3ENavBarSize.values,
              labelOf: (M3ENavBarSize v) => v.name,
              onChanged: (M3ENavBarSize v) => setState(() => _size = v),
            ),
            PlayEnumSegmented<M3ENavBarShapeFamily>(
              label: 'Shape',
              value: _shape,
              values: M3ENavBarShapeFamily.values,
              labelOf: (M3ENavBarShapeFamily v) => v.name,
              onChanged: (M3ENavBarShapeFamily v) {
                setState(() => _shape = v);
              },
            ),
            PlayEnumSegmented<M3ENavBarDensity>(
              label: 'Density',
              value: _density,
              values: M3ENavBarDensity.values,
              labelOf: (M3ENavBarDensity v) => v.name,
              onChanged: (M3ENavBarDensity v) {
                setState(() => _density = v);
              },
            ),
            PlayEnumMenu<M3ENavBarIndicatorStyle>(
              label: 'Indicator',
              value: _indicator,
              values: M3ENavBarIndicatorStyle.values,
              labelOf: (M3ENavBarIndicatorStyle v) => v.name,
              onChanged: (M3ENavBarIndicatorStyle v) {
                setState(() => _indicator = v);
              },
            ),
            PlaySwitch(
              label: 'Badges',
              value: _badges,
              onChanged: (bool v) => setState(() => _badges = v),
            ),
          ],
        ),
      ],
    );
  }
}
