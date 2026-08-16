import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3EDropdownMenu].
class DropdownMenuPlayground extends StatefulWidget {
  /// Creates the dropdown menu playground.
  const DropdownMenuPlayground({super.key});

  @override
  State<DropdownMenuPlayground> createState() => _DropdownMenuPlaygroundState();
}

class _DropdownMenuPlaygroundState extends State<DropdownMenuPlayground> {
  bool _singleSelect = true;
  bool _searchEnabled = false;
  bool _enabled = true;
  bool _showClear = true;
  M3EDropdownExpandDirection _expand = M3EDropdownExpandDirection.auto;
  String _hint = 'Choose an option';
  String? _selectionSummary;

  static const List<M3EDropdownItem<String>> _items = <M3EDropdownItem<String>>[
    M3EDropdownItem(label: 'Flutter', value: 'flutter'),
    M3EDropdownItem(label: 'Dart', value: 'dart'),
    M3EDropdownItem(label: 'Material 3', value: 'm3'),
    M3EDropdownItem(label: 'Theming', value: 'theming'),
    M3EDropdownItem(label: 'Animation', value: 'animation'),
  ];

  void _onSelectionChanged(List<M3EDropdownItem<String>> items) {
    setState(() {
      if (items.isEmpty) {
        _selectionSummary = null;
      } else {
        _selectionSummary = items
            .map((M3EDropdownItem<String> i) => i.label)
            .join(', ');
      }
    });
  }

  List<PlaySnippet> get _snippets {
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Dropdown menu',
        code:
            '''
$kPlaySnippetImport

M3EDropdownMenu<String>(
  singleSelect: $_singleSelect,
  searchEnabled: $_searchEnabled,
  enabled: $_enabled,
  items: const <M3EDropdownItem<String>>[
    M3EDropdownItem(label: 'Flutter', value: 'flutter'),
    M3EDropdownItem(label: 'Dart', value: 'dart'),
    M3EDropdownItem(label: 'Material 3', value: 'm3'),
  ],
  fieldStyle: M3EDropdownFieldStyle(
    hintText: ${playDartString(_hint)},
    showClearIcon: $_showClear,
  ),
  dropdownStyle: M3EDropdownPanelStyle(
    expandDirection: M3EDropdownExpandDirection.${_expand.name},
  ),
  onSelectionChanged: (List<M3EDropdownItem<String>> items) {},
);''',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Dropdown menu',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 320,
                child: M3EDropdownMenu<String>(
                  key: ValueKey<String>(
                    '$_singleSelect-$_searchEnabled-$_expand',
                  ),
                  singleSelect: _singleSelect,
                  searchEnabled: _searchEnabled,
                  enabled: _enabled,
                  items: _items,
                  fieldStyle: M3EDropdownFieldStyle(
                    hintText: _hint,
                    showClearIcon: _showClear,
                  ),
                  dropdownStyle: M3EDropdownPanelStyle(
                    expandDirection: _expand,
                  ),
                  onSelectionChanged: _onSelectionChanged,
                ),
              ),
              if (_selectionSummary != null) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  'Selected: $_selectionSummary',
                  style: theme.typeScale.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Behavior',
          children: <Widget>[
            PlaySwitch(
              label: 'Single select',
              value: _singleSelect,
              onChanged: (bool v) => setState(() => _singleSelect = v),
            ),
            PlaySwitch(
              label: 'Search',
              value: _searchEnabled,
              onChanged: (bool v) => setState(() => _searchEnabled = v),
            ),
            PlaySwitch(
              label: 'Show clear',
              value: _showClear,
              onChanged: (bool v) => setState(() => _showClear = v),
            ),
            PlaySwitch(
              label: 'Enabled',
              value: _enabled,
              onChanged: (bool v) => setState(() => _enabled = v),
            ),
            PlayEnumMenu<M3EDropdownExpandDirection>(
              label: 'Expand',
              value: _expand,
              values: M3EDropdownExpandDirection.values,
              labelOf: (M3EDropdownExpandDirection v) => v.name,
              onChanged: (M3EDropdownExpandDirection v) {
                setState(() => _expand = v);
              },
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
