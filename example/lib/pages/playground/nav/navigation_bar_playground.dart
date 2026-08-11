import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/navigation_bar/enums/m3e_nav_bar_enums.dart';
import 'package:material_3_expressive/components/navigation_bar/models/m3e_navigation_bar_destination.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
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
        label: 'Search',
        badgeDot: _badges,
      ),
      M3ENavigationBarDestination(
        icon: const Icon(M3EIcons.calendar_today),
        label: 'Agenda',
        badgeCount: _badges ? 3 : null,
      ),
      const M3ENavigationBarDestination(
        icon: Icon(M3EIcons.edit),
        label: 'Drafts',
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
              labelBehavior: _labelBehavior,
              size: _size,
              shapeFamily: _shape,
              density: _density,
              indicatorStyle: _indicator,
              safeArea: false,
            ),
          ),
        ),
      ],
      controls: <Widget>[
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
