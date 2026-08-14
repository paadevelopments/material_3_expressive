import 'package:flutter/material.dart' show ListTile;
import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ESearchBar] and [M3ESearchAnchor].
class SearchPlayground extends StatefulWidget {
  /// Creates the search playground.
  const SearchPlayground({super.key});

  @override
  State<SearchPlayground> createState() => _SearchPlaygroundState();
}

class _SearchPlaygroundState extends State<SearchPlayground> {
  bool _expandOnFocus = true;
  bool _enabled = true;
  bool _useAnchor = true;
  String _hint = 'Search components';

  final TextEditingController _barController = TextEditingController();
  final M3ESearchController _anchorController = M3ESearchController();

  static const List<String> _names = <String>[
    'Buttons',
    'Cards',
    'Carousel',
    'Navigation bar',
    'Progress',
    'Search bar',
    'Snackbar',
    'Tabs',
    'Text field',
    'Tooltip',
  ];

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  Iterable<Widget> _suggestions(
    BuildContext context,
    M3ESearchController controller,
  ) {
    final String query = controller.text.trim().toLowerCase();
    final Iterable<String> matches = query.isEmpty
        ? _names
        : _names.where((String name) => name.toLowerCase().contains(query));
    return matches.map(
      (String name) =>
          ListTile(title: Text(name), onTap: () => controller.closeView(name)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: _useAnchor ? 'Search anchor' : 'Search bar',
          child: _useAnchor
              ? M3ESearchAnchor.bar(
                  searchController: _anchorController,
                  barHintText: _hint,
                  shrinkWrap: true,
                  suggestionsBuilder: _suggestions,
                )
              : M3ESearchBar(
                  controller: _barController,
                  hintText: _hint,
                  enabled: _enabled,
                  expandOnFocus: _expandOnFocus,
                  trailing: <Widget>[
                    M3EIconButton(
                      icon: const Icon(M3EIcons.close),
                      onPressed: _barController.clear,
                    ),
                  ],
                ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Mode',
          children: <Widget>[
            PlaySwitch(
              label: 'Use search anchor',
              value: _useAnchor,
              onChanged: (bool v) => setState(() => _useAnchor = v),
            ),
            if (!_useAnchor)
              PlaySwitch(
                label: 'Expand on focus',
                value: _expandOnFocus,
                onChanged: (bool v) => setState(() => _expandOnFocus = v),
              ),
            if (!_useAnchor)
              PlaySwitch(
                label: 'Enabled',
                value: _enabled,
                onChanged: (bool v) => setState(() => _enabled = v),
              ),
            PlayTextField(
              label: 'Hint',
              value: _hint,
              onChanged: (String v) => setState(() => _hint = v),
            ),
          ],
        ),
      ],
    );
  }
}
