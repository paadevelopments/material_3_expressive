import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/time_pickers/models/m3e_time.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../widgets/gallery_section.dart';

/// Demonstrates every component in the Material 3 *Selection* group.
class SelectionPage extends StatefulWidget {
  const SelectionPage({super.key});

  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool? _checked = true;
  bool? _tristate;
  String _plan = 'standard';
  bool _wifi = true;
  bool _bluetooth = false;
  final Set<String> _chips = <String>{'flutter'};
  DateTime? _date;
  M3ETime _time = const M3ETime(hour: 9, minute: 30);
  String? _framework;
  final List<String> _skills = <String>[];
  String? _asyncCountry;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = M3ETheme.of(context);
    return GalleryPageScrollView(
      sections: <Widget>[
        GallerySection(
          title: 'Checkbox',
          children: <Widget>[
            DemoRow(
              label: 'Binary & tristate',
              children: <Widget>[
                M3ECheckbox(
                  value: _checked,
                  onChanged: (bool? value) => setState(() => _checked = value),
                ),
                M3ECheckbox(
                  value: _tristate,
                  tristate: true,
                  onChanged: (bool? value) =>
                      setState(() => _tristate = value),
                ),
                M3ECheckbox(
                  value: true,
                  error: true,
                  onChanged: (bool? value) {},
                ),
              ],
            ),
          ],
        ),
        GallerySection(
          title: 'Radio buttons',
          children: <Widget>[
            for (final String plan in <String>['standard', 'pro', 'team'])
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: <Widget>[
                    M3ERadio<String>(
                      value: plan,
                      groupValue: _plan,
                      onChanged: (String value) =>
                          setState(() => _plan = value),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      plan,
                      style: theme.typeScale.bodyLarge
                          .copyWith(color: theme.colorScheme.onSurface),
                    ),
                  ],
                ),
              ),
          ],
        ),
        GallerySection(
          title: 'Switch',
          children: <Widget>[
            DemoRow(
              label: 'With and without icons',
              children: <Widget>[
                M3ESwitch(
                  value: _wifi,
                  selectedIcon: const Icon(M3EIcons.check),
                  onChanged: (bool value) => setState(() => _wifi = value),
                ),
                M3ESwitch(
                  value: _bluetooth,
                  onChanged: (bool value) => setState(() => _bluetooth = value),
                ),
              ],
            ),
          ],
        ),
        GallerySection(
          title: 'Chips',
          children: <Widget>[
            DemoRow(
              label: 'Types',
              children: <Widget>[
                M3EChip(
                  label: 'Assist',
                  leading: const Icon(M3EIcons.edit),
                  onPressed: () {},
                ),
                M3EChip(
                  label: 'Flutter',
                  type: M3EChipType.filter,
                  selected: _chips.contains('flutter'),
                  onPressed: () => _toggleChip('flutter'),
                ),
                M3EChip(
                  label: 'Dart',
                  type: M3EChipType.filter,
                  selected: _chips.contains('dart'),
                  onPressed: () => _toggleChip('dart'),
                ),
                M3EChip(
                  label: 'Input',
                  type: M3EChipType.input,
                  onDeleted: () {},
                ),
                M3EChip(
                  label: 'Suggestion',
                  type: M3EChipType.suggestion,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
        GallerySection(
          title: 'Dropdown menu',
          children: <Widget>[
            DemoRow(
              label: 'Single select',
              children: <Widget>[
                SizedBox(
                  width: 280,
                  child: M3EDropdownMenu<String>(
                    singleSelect: true,
                    items: const <M3EDropdownItem<String>>[
                      M3EDropdownItem(label: 'Flutter', value: 'flutter'),
                      M3EDropdownItem(label: 'Dart', value: 'dart'),
                      M3EDropdownItem(label: 'Material 3', value: 'm3'),
                    ],
                    fieldStyle: const M3EDropdownFieldStyle(
                      hintText: 'Choose a framework',
                    ),
                    onSelectionChanged: (List<M3EDropdownItem<String>> items) {
                      setState(() {
                        _framework = items.isEmpty ? null : items.first.value;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_framework != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Selected: $_framework',
                  style: theme.typeScale.bodyMedium
                      .copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            const SizedBox(height: 16),
            DemoRow(
              label: 'Multi select with search',
              children: <Widget>[
                SizedBox(
                  width: 320,
                  child: M3EDropdownMenu<String>(
                    searchEnabled: true,
                    items: const <M3EDropdownItem<String>>[
                      M3EDropdownItem(label: 'Layout', value: 'layout'),
                      M3EDropdownItem(label: 'Animation', value: 'animation'),
                      M3EDropdownItem(label: 'Theming', value: 'theming'),
                      M3EDropdownItem(label: 'Accessibility', value: 'a11y'),
                      M3EDropdownItem(label: 'Navigation', value: 'navigation'),
                    ],
                    fieldStyle: const M3EDropdownFieldStyle(
                      hintText: 'Select skills',
                      showClearIcon: true,
                    ),
                    onSelectionChanged: (List<M3EDropdownItem<String>> items) {
                      setState(() {
                        _skills
                          ..clear()
                          ..addAll(items.map((M3EDropdownItem<String> i) => i.value));
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DemoRow(
              label: 'Async load',
              children: <Widget>[
                SizedBox(
                  width: 280,
                  child: M3EDropdownMenu<String>.future(
                    singleSelect: true,
                    future: _loadCountries,
                    fieldStyle: const M3EDropdownFieldStyle(
                      hintText: 'Load countries',
                    ),
                    onSelectionChanged: (List<M3EDropdownItem<String>> items) {
                      setState(() {
                        _asyncCountry =
                            items.isEmpty ? null : items.first.value;
                      });
                    },
                  ),
                ),
              ],
            ),
            if (_asyncCountry != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Country: $_asyncCountry',
                  style: theme.typeScale.bodyMedium
                      .copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
          ],
        ),
        GallerySection(
          title: 'Sliders',
          children: const <Widget>[_SelectionSlidersSection()],
        ),
        GallerySection(
          title: 'Date & time pickers',
          children: <Widget>[
            M3EDatePicker(
              selectedDate: _date,
              onDateSelected: (DateTime value) =>
                  setState(() => _date = value),
            ),
            const SizedBox(height: 24),
            M3ETimePicker(
              value: _time,
              onChanged: (M3ETime value) => setState(() => _time = value),
            ),
          ],
        ),
      ],
    );
  }

  void _toggleChip(String value) {
    setState(() {
      if (!_chips.add(value)) {
        _chips.remove(value);
      }
    });
  }

  Future<List<M3EDropdownItem<String>>> _loadCountries() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const <M3EDropdownItem<String>>[
      M3EDropdownItem(label: 'Ghana', value: 'gh'),
      M3EDropdownItem(label: 'Kenya', value: 'ke'),
      M3EDropdownItem(label: 'Nigeria', value: 'ng'),
    ];
  }
}

class _SelectionSlidersSection extends StatefulWidget {
  const _SelectionSlidersSection();

  @override
  State<_SelectionSlidersSection> createState() =>
      _SelectionSlidersSectionState();
}

class _SelectionSlidersSectionState extends State<_SelectionSlidersSection> {
  double _volume = 0.5;
  double _brightness = 3;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DemoRow(
          label: 'Continuous',
          children: <Widget>[
            SizedBox(
              width: 260,
              child: M3ESlider(
                value: _volume,
                onChanged: (double value) => setState(() => _volume = value),
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Discrete (0-5)',
          children: <Widget>[
            SizedBox(
              width: 260,
              child: M3ESlider(
                value: _brightness,
                max: 5,
                divisions: 5,
                onChanged: (double value) =>
                    setState(() => _brightness = value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
