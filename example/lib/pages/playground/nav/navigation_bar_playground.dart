import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3ENavigationBar].
class NavigationBarPlayground extends PlaygroundWidget {
  /// Creates the navigation bar playground.
  const NavigationBarPlayground({super.key});

  @override
  PlaygroundState<NavigationBarPlayground> createState() =>
      _NavigationBarPlaygroundState();
}

class _NavigationBarPlaygroundState
    extends PlaygroundState<NavigationBarPlayground> {
  M3ENavBarLabelBehavior _labelBehavior = M3ENavBarLabelBehavior.alwaysShow;
  M3ENavBarIconBehavior _iconBehavior = M3ENavBarIconBehavior.alwaysShow;
  bool _autoLayout = false;
  M3ENavBarLayout _layout = M3ENavBarLayout.compact;
  M3ENavBarAlignment _alignment = M3ENavBarAlignment.center;
  double _wideDestinationWidth = M3ENavBarConstants.wideDestinationWidth;
  bool _customBreakpoint = false;
  double _wideBreakpoint = M3ENavBarConstants.mediumWindowBreakpoint;
  M3ENavBarSize _size = M3ENavBarSize.medium;
  M3ENavBarShapeFamily _shape = M3ENavBarShapeFamily.square;
  M3ENavBarDensity _density = M3ENavBarDensity.regular;
  M3ENavBarIndicatorStyle _indicator = M3ENavBarIndicatorStyle.pill;
  double _count = 4;
  bool _badges = true;
  bool _hideOnScroll = false;
  int _index = 0;

  static const List<(IconData, String, String)> _entries =
      <(IconData, String, String)>[
        (M3EIcons.home, 'home', 'Home'),
        (M3EIcons.search, 'search', 'Browse'),
        (M3EIcons.radio, 'radio', 'Radio'),
        (M3EIcons.library_music, 'library_music', 'Library'),
        (M3EIcons.person, 'person', 'Profile'),
      ];

  int get _destinationCount => _count.round();

  /// Wide-layout options apply when the bar can lay out wide.
  bool get _canBeWide => _autoLayout || _layout == M3ENavBarLayout.wide;

  /// Hiding both labels and icons leaves nothing to show.
  List<M3ENavBarIconBehavior> get _iconBehaviors => <M3ENavBarIconBehavior>[
    for (final M3ENavBarIconBehavior v in M3ENavBarIconBehavior.values)
      if (_labelBehavior != M3ENavBarLabelBehavior.alwaysHide ||
          v != M3ENavBarIconBehavior.alwaysHide)
        v,
  ];

  List<M3ENavigationBarDestination> get _destinations {
    return <M3ENavigationBarDestination>[
      for (int i = 0; i < _destinationCount; i++)
        M3ENavigationBarDestination(
          icon: Icon(_entries[i].$1),
          label: _entries[i].$3,
          badgeDot: _badges && i == 1,
          badgeCount: _badges && i == 2 ? 3 : null,
        ),
    ];
  }

  @override
  Widget buildPreview(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildPreviewScroll(BuildContext context, EdgeInsets padding) {
    final String title = _entries[_index.clamp(0, _destinationCount - 1)].$3;
    return M3EList.scrollable(
      controller: PrimaryScrollController.of(context),
      variant: M3ECardVariant.filled,
      listPadding: padding,
      itemCount: 24,
      itemBuilder: (BuildContext context, int index) {
        return M3EListItem(
          headline: '$title ${index + 1}',
          supportingText: _hideOnScroll
              ? 'Scroll to hide and show the bar'
              : 'Tap the active destination to return to the top',
        );
      },
    );
  }

  @override
  PlaygroundSlots buildSlots(BuildContext context, PlaygroundChrome chrome) {
    final ScrollController scroll = PrimaryScrollController.of(context);
    final M3ENavBarIconBehavior iconBehavior =
        _iconBehaviors.contains(_iconBehavior)
        ? _iconBehavior
        : M3ENavBarIconBehavior.alwaysShow;
    return PlaygroundSlots(
      bottomNavigationBar: M3ENavigationBar(
        destinations: _destinations,
        selectedIndex: _index.clamp(0, _destinationCount - 1),
        onDestinationSelected: (int i) {
          if (i == _index && scroll.hasClients) {
            scroll.animateTo(
              0,
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOut,
            );
          }
          setState(() => _index = i);
        },
        autoLayout: _autoLayout,
        layout: _layout,
        alignment: _alignment,
        wideDestinationWidth: _wideDestinationWidth,
        wideBreakpoint: _autoLayout && _customBreakpoint
            ? _wideBreakpoint
            : null,
        labelBehavior: _labelBehavior,
        iconBehavior: iconBehavior,
        size: _size,
        shapeFamily: _shape,
        density: _density,
        indicatorStyle: _indicator,
        hideOnScroll: _hideOnScroll,
        scrollController: _hideOnScroll ? scroll : null,
      ),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer destinations = StringBuffer();
    for (int i = 0; i < _destinationCount; i++) {
      final String badge = !_badges
          ? ''
          : i == 1
          ? ', badgeDot: true'
          : i == 2
          ? ', badgeCount: 3'
          : '';
      destinations.writeln(
        '    M3ENavigationBarDestination(icon: Icon(M3EIcons.'
        "${_entries[i].$2}), label: '${_entries[i].$3}'$badge),",
      );
    }
    final StringBuffer args = StringBuffer()
      ..writeln('  autoLayout: $_autoLayout,');
    if (_autoLayout) {
      if (_customBreakpoint) {
        args.writeln('  wideBreakpoint: ${_wideBreakpoint.round()},');
      }
    } else {
      args.writeln('  layout: M3ENavBarLayout.${_layout.name},');
    }
    if (_canBeWide) {
      args
        ..writeln('  alignment: M3ENavBarAlignment.${_alignment.name},')
        ..writeln('  wideDestinationWidth: ${_wideDestinationWidth.round()},');
    }
    args
      ..writeln(
        '  labelBehavior: M3ENavBarLabelBehavior.${_labelBehavior.name},',
      )
      ..writeln('  iconBehavior: M3ENavBarIconBehavior.${_iconBehavior.name},')
      ..writeln('  size: M3ENavBarSize.${_size.name},')
      ..writeln('  shapeFamily: M3ENavBarShapeFamily.${_shape.name},')
      ..writeln('  density: M3ENavBarDensity.${_density.name},')
      ..writeln(
        '  indicatorStyle: M3ENavBarIndicatorStyle.${_indicator.name},',
      );
    if (_hideOnScroll) {
      args
        ..writeln('  hideOnScroll: true,')
        ..writeln('  scrollController: scrollController,');
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Navigation bar',
        code:
            '''
$kPlaySnippetImport

Scaffold(
  body: content,
  bottomNavigationBar: M3ENavigationBar(
  destinations: const <M3ENavigationBarDestination>[
$destinations  ],
  selectedIndex: $_index,
  onDestinationSelected: (int index) {},
$args  ),
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Layout',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Auto layout',
            description: 'Wide at or above the breakpoint',
            value: _autoLayout,
            onChanged: (bool v) => setState(() => _autoLayout = v),
          ),
          if (_autoLayout)
            PlaySwitchItem(
              label: 'Custom breakpoint',
              value: _customBreakpoint,
              onChanged: (bool v) => setState(() => _customBreakpoint = v),
            ),
          if (_autoLayout && _customBreakpoint)
            PlaySlider(
              label: 'Wide breakpoint',
              value: _wideBreakpoint,
              min: 200,
              max: 1000,
              divisions: 40,
              onChanged: (double v) => setState(() => _wideBreakpoint = v),
            ),
          if (!_autoLayout)
            PlayEnumChoice<M3ENavBarLayout>(
              label: 'Layout',
              value: _layout,
              values: M3ENavBarLayout.values,
              labelOf: (M3ENavBarLayout v) => v.name,
              onChanged: (M3ENavBarLayout v) => setState(() => _layout = v),
            ),
          if (_canBeWide) ...<Widget>[
            PlayEnumChoice<M3ENavBarAlignment>(
              label: 'Wide alignment',
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
          ],
        ],
      ),
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3ENavBarSize>(
            label: 'Size',
            value: _size,
            values: M3ENavBarSize.values,
            labelOf: (M3ENavBarSize v) => v.name,
            onChanged: (M3ENavBarSize v) => setState(() => _size = v),
          ),
          PlayEnumChoice<M3ENavBarShapeFamily>(
            label: 'Shape',
            value: _shape,
            values: M3ENavBarShapeFamily.values,
            labelOf: (M3ENavBarShapeFamily v) => v.name,
            onChanged: (M3ENavBarShapeFamily v) => setState(() => _shape = v),
          ),
          PlayEnumChoice<M3ENavBarDensity>(
            label: 'Density',
            value: _density,
            values: M3ENavBarDensity.values,
            labelOf: (M3ENavBarDensity v) => v.name,
            onChanged: (M3ENavBarDensity v) => setState(() => _density = v),
          ),
          PlayEnumChoice<M3ENavBarIndicatorStyle>(
            label: 'Indicator',
            value: _indicator,
            values: M3ENavBarIndicatorStyle.values,
            labelOf: (M3ENavBarIndicatorStyle v) => v.name,
            onChanged: (M3ENavBarIndicatorStyle v) {
              setState(() => _indicator = v);
            },
          ),
          PlayEnumChoice<M3ENavBarLabelBehavior>(
            label: 'Labels',
            value: _labelBehavior,
            values: M3ENavBarLabelBehavior.values,
            labelOf: (M3ENavBarLabelBehavior v) => v.name,
            onChanged: (M3ENavBarLabelBehavior v) {
              setState(() => _labelBehavior = v);
            },
          ),
          PlayEnumChoice<M3ENavBarIconBehavior>(
            label: 'Icons',
            value: _iconBehaviors.contains(_iconBehavior)
                ? _iconBehavior
                : M3ENavBarIconBehavior.alwaysShow,
            values: _iconBehaviors,
            labelOf: (M3ENavBarIconBehavior v) => v.name,
            onChanged: (M3ENavBarIconBehavior v) {
              setState(() => _iconBehavior = v);
            },
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Destinations',
        children: <Widget>[
          PlaySlider(
            label: 'Count',
            value: _count,
            min: 3,
            max: _entries.length.toDouble(),
            divisions: _entries.length - 3,
            onChanged: (double v) => setState(() => _count = v),
          ),
          PlaySwitchItem(
            label: 'Badges',
            description: 'A dot on Browse and a count on Radio',
            value: _badges,
            onChanged: (bool v) => setState(() => _badges = v),
          ),
          PlaySwitchItem(
            label: 'Hide on scroll',
            value: _hideOnScroll,
            onChanged: (bool v) => setState(() => _hideOnScroll = v),
          ),
        ],
      ),
    ];
  }
}
