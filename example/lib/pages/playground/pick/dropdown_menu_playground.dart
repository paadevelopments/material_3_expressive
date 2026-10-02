import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Where the dropdown items come from.
enum _ItemSource { items, future }

/// Live playground for [M3EDropdownMenu].
class DropdownMenuPlayground extends PlaygroundWidget {
  /// Creates the dropdown menu playground.
  const DropdownMenuPlayground({super.key});

  @override
  PlaygroundState<DropdownMenuPlayground> createState() =>
      _DropdownMenuPlaygroundState();
}

class _DropdownMenuPlaygroundState
    extends PlaygroundState<DropdownMenuPlayground> {
  _ItemSource _source = _ItemSource.items;
  bool _singleSelect = true;
  bool _limitSelections = false;
  double _limit = 2;
  bool _chipAnimation = true;
  bool _searchEnabled = false;
  String _searchHint = 'Search…';
  bool _enabled = true;
  bool _showClear = true;
  bool _showArrow = true;
  bool _prefixIcon = false;
  bool _disableItem = false;
  bool _validate = false;
  double _containerRadius = 28;
  double _maxHeight = 350;
  M3EDropdownExpandDirection _expand = M3EDropdownExpandDirection.auto;
  M3EHapticFeedback _haptic = M3EHapticFeedback.none;
  String _hint = 'Choose an option';
  String? _selectionSummary;

  static const List<(String, String)> _entries = <(String, String)>[
    ('Flutter', 'flutter'),
    ('Dart', 'dart'),
    ('Material 3', 'm3'),
    ('Theming', 'theming'),
    ('Animation', 'animation'),
  ];

  List<M3EDropdownItem<String>> get _items => <M3EDropdownItem<String>>[
    for (int i = 0; i < _entries.length; i++)
      M3EDropdownItem<String>(
        label: _entries[i].$1,
        value: _entries[i].$2,
        disabled: _disableItem && i == 1,
      ),
  ];

  Future<List<M3EDropdownItem<String>>> _load() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return _items;
  }

  void _onSelectionChanged(List<M3EDropdownItem<String>> items) {
    final String? summary = items.isEmpty
        ? null
        : items.map((M3EDropdownItem<String> i) => i.label).join(', ');
    if (summary != _selectionSummary) {
      setState(() => _selectionSummary = summary);
    }
  }

  String? _validator(List<M3EDropdownItem<String>>? selected) {
    return (selected == null || selected.isEmpty)
        ? 'Pick at least one option'
        : null;
  }

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EDropdownFieldStyle fieldStyle = M3EDropdownFieldStyle(
      hintText: _hint,
      showClearIcon: _showClear,
      showArrow: _showArrow,
      prefixIcon: _prefixIcon ? const Icon(M3EIcons.search) : null,
    );
    final M3EDropdownPanelStyle panelStyle = M3EDropdownPanelStyle(
      expandDirection: _expand,
      maxHeight: _maxHeight,
    );
    final M3EDropdownSearchStyle searchStyle = M3EDropdownSearchStyle(
      hintText: _searchHint,
    );
    final int? limit = !_singleSelect && _limitSelections
        ? _limit.round()
        : null;
    // Structural options only apply on creation.
    final Key key = ValueKey<String>(
      '$_source-$_singleSelect-$_searchEnabled-$_disableItem-$_validate',
    );
    final Widget menu = _source == _ItemSource.items
        ? M3EDropdownMenu<String>(
            key: key,
            items: _items,
            singleSelect: _singleSelect,
            searchEnabled: _searchEnabled,
            showChipAnimation: _chipAnimation,
            limit: limit,
            enabled: _enabled,
            containerRadius: _containerRadius,
            haptic: _haptic,
            fieldStyle: fieldStyle,
            dropdownStyle: panelStyle,
            searchStyle: searchStyle,
            validator: _validate ? _validator : null,
            autovalidateMode: _validate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            onSelectionChanged: _onSelectionChanged,
          )
        : M3EDropdownMenu<String>.future(
            key: key,
            future: _load,
            singleSelect: _singleSelect,
            searchEnabled: _searchEnabled,
            showChipAnimation: _chipAnimation,
            limit: limit,
            enabled: _enabled,
            containerRadius: _containerRadius,
            haptic: _haptic,
            fieldStyle: fieldStyle,
            dropdownStyle: panelStyle,
            searchStyle: searchStyle,
            validator: _validate ? _validator : null,
            autovalidateMode: _validate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            onSelectionChanged: _onSelectionChanged,
          );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          menu,
          const SizedBox(height: 12),
          Text(
            'Selected: ${_selectionSummary ?? 'none'}',
            style: theme.typeScale.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final bool future = _source == _ItemSource.future;
    final StringBuffer args = StringBuffer();
    if (future) {
      args.writeln('  future: () async => await fetchItems(),');
    } else {
      args.writeln(
        '  items: const <M3EDropdownItem<String>>[\n'
        "    M3EDropdownItem(label: 'Flutter', value: 'flutter'),\n"
        "    M3EDropdownItem(label: 'Dart', value: 'dart'"
        "${_disableItem ? ', disabled: true' : ''}),\n"
        "    M3EDropdownItem(label: 'Material 3', value: 'm3'),\n"
        '  ],',
      );
    }
    args
      ..writeln('  singleSelect: $_singleSelect,')
      ..writeln('  searchEnabled: $_searchEnabled,');
    if (!_singleSelect) {
      args.writeln('  showChipAnimation: $_chipAnimation,');
      if (_limitSelections) {
        args.writeln('  limit: ${_limit.round()},');
      }
    }
    args
      ..writeln('  enabled: $_enabled,')
      ..writeln('  containerRadius: ${_containerRadius.round()},');
    if (_haptic != M3EHapticFeedback.none) {
      args.writeln('  haptic: M3EHapticFeedback.${_haptic.name},');
    }
    args
      ..writeln('  fieldStyle: M3EDropdownFieldStyle(')
      ..writeln('    hintText: ${playDartString(_hint)},')
      ..writeln('    showClearIcon: $_showClear,')
      ..writeln('    showArrow: $_showArrow,');
    if (_prefixIcon) {
      args.writeln('    prefixIcon: const Icon(M3EIcons.search),');
    }
    args
      ..writeln('  ),')
      ..writeln('  dropdownStyle: M3EDropdownPanelStyle(')
      ..writeln(
        '    expandDirection: M3EDropdownExpandDirection.${_expand.name},',
      )
      ..writeln('    maxHeight: ${_maxHeight.round()},')
      ..writeln('  ),');
    if (_searchEnabled) {
      args.writeln(
        '  searchStyle: M3EDropdownSearchStyle('
        'hintText: ${playDartString(_searchHint)}),',
      );
    }
    if (_validate) {
      args
        ..writeln(
          "  validator: (items) => items == null || items.isEmpty "
          "? 'Pick at least one option' : null,",
        )
        ..writeln('  autovalidateMode: AutovalidateMode.always,');
    }
    args.writeln(
      '  onSelectionChanged: (List<M3EDropdownItem<String>> items) {},',
    );
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Dropdown menu',
        code:
            '$kPlaySnippetImport\n\nM3EDropdownMenu<String>'
            '${future ? '.future' : ''}(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Items',
        children: <Widget>[
          PlayEnumChoice<_ItemSource>(
            label: 'Source',
            value: _source,
            values: _ItemSource.values,
            labelOf: (_ItemSource v) => switch (v) {
              _ItemSource.items => 'items',
              _ItemSource.future => 'future (1s)',
            },
            onChanged: (_ItemSource v) => setState(() => _source = v),
          ),
          PlaySwitchItem(
            label: 'Disable an item',
            description: 'Dart cannot be picked',
            value: _disableItem,
            onChanged: (bool v) => setState(() => _disableItem = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Selection',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Single select',
            value: _singleSelect,
            onChanged: (bool v) => setState(() => _singleSelect = v),
          ),
          if (!_singleSelect) ...<Widget>[
            PlaySwitchItem(
              label: 'Chip animation',
              description: 'Selected items show as animated chips',
              value: _chipAnimation,
              onChanged: (bool v) => setState(() => _chipAnimation = v),
            ),
            PlaySwitchItem(
              label: 'Limit selections',
              value: _limitSelections,
              onChanged: (bool v) => setState(() => _limitSelections = v),
            ),
            if (_limitSelections)
              PlaySlider(
                label: 'Limit',
                value: _limit,
                min: 1,
                max: _entries.length.toDouble(),
                divisions: _entries.length - 1,
                onChanged: (double v) => setState(() => _limit = v),
              ),
          ],
          PlaySwitchItem(
            label: 'Validation',
            description: 'Shows an error while nothing is selected',
            value: _validate,
            onChanged: (bool v) => setState(() => _validate = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Field',
        children: <Widget>[
          PlayTextField(
            label: 'Hint',
            value: _hint,
            onChanged: (String v) => setState(() => _hint = v),
          ),
          PlaySwitchItem(
            label: 'Clear icon',
            value: _showClear,
            onChanged: (bool v) => setState(() => _showClear = v),
          ),
          PlaySwitchItem(
            label: 'Arrow',
            value: _showArrow,
            onChanged: (bool v) => setState(() => _showArrow = v),
          ),
          PlaySwitchItem(
            label: 'Prefix icon',
            value: _prefixIcon,
            onChanged: (bool v) => setState(() => _prefixIcon = v),
          ),
          PlaySlider(
            label: 'Container radius',
            value: _containerRadius,
            max: 28,
            divisions: 28,
            onChanged: (double v) => setState(() => _containerRadius = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Panel',
        children: <Widget>[
          PlayEnumChoice<M3EDropdownExpandDirection>(
            label: 'Expand direction',
            value: _expand,
            values: M3EDropdownExpandDirection.values,
            labelOf: (M3EDropdownExpandDirection v) => v.name,
            onChanged: (M3EDropdownExpandDirection v) {
              setState(() => _expand = v);
            },
          ),
          PlaySlider(
            label: 'Max height',
            value: _maxHeight,
            min: 120,
            max: 480,
            divisions: 36,
            onChanged: (double v) => setState(() => _maxHeight = v),
          ),
          PlaySwitchItem(
            label: 'Search',
            description: 'Search field inside the panel',
            value: _searchEnabled,
            onChanged: (bool v) => setState(() => _searchEnabled = v),
          ),
          if (_searchEnabled)
            PlayTextField(
              label: 'Search hint',
              value: _searchHint,
              onChanged: (String v) => setState(() => _searchHint = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Behavior',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Enabled',
            value: _enabled,
            onChanged: (bool v) => setState(() => _enabled = v),
          ),
          if (_enabled)
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
