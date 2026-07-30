import 'package:flutter/widgets.dart';
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
  M3EDateRange? _dateRange;
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
                  onChanged: (bool? value) => setState(() => _tristate = value),
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
                child: M3ERadio<String>(
                  value: plan,
                  groupValue: _plan,
                  label: Text(plan),
                  onChanged: (String value) => setState(() => _plan = value),
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
                  stateLayerSize: 56,
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
                  style: theme.typeScale.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
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
                          ..addAll(
                            items.map((M3EDropdownItem<String> i) => i.value),
                          );
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
                        _asyncCountry = items.isEmpty
                            ? null
                            : items.first.value;
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
                  style: theme.typeScale.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
          ],
        ),
        GallerySection(
          title: 'Sliders',
          description:
              'Tab to a slider and use the arrow keys (or Page Up/Down, '
              'Home/End) to adjust its value with a visible focus ring.',
          children: const <Widget>[_SelectionSlidersSection()],
        ),
        GallerySection(
          title: 'Date & time pickers',
          children: <Widget>[
            M3ECalendarDatePicker(
              initialDate: _date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
              onDateChanged: (DateTime value) => setState(() => _date = value),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                M3EButton(
                  onPressed: () async {
                    final DateTime? picked = await M3EDatePicker.show(
                      context,
                      initialDate: _date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => _date = picked);
                    }
                  },
                  child: const Text('Pick date'),
                ),
                M3EButton(
                  onPressed: () async {
                    final M3EDateRange? picked = await M3EDatePicker.showRange(
                      context,
                      initialStartDate: _dateRange?.start ?? _date,
                      initialEndDate: _dateRange?.end,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      setState(() => _dateRange = picked);
                    }
                  },
                  child: const Text('Pick range'),
                ),
              ],
            ),
            if (_dateRange != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Range: ${_dateRange!.start.toIso8601String().split('T').first}'
                  '${_dateRange!.end != null ? ' – ${_dateRange!.end!.toIso8601String().split('T').first}' : ''}',
                  style: theme.typeScale.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            const SizedBox(height: 24),
            M3EDialTimePicker(
              value: _time,
              onChanged: (M3ETime value) => setState(() => _time = value),
            ),
            const SizedBox(height: 16),
            M3EButton(
              onPressed: () async {
                final M3ETime? picked = await M3ETimePicker.show(
                  context,
                  initialTime: _time,
                );
                if (picked != null) {
                  setState(() => _time = picked);
                }
              },
              child: const Text('Pick time'),
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
  double _disabled = 0.6;
  double _shapeDots = 2;
  double _balance = 0;
  double _wavy = 0.55;
  M3ESliderRange _range = const M3ESliderRange(0.2, 0.7);
  M3ESliderRange _wavyRange = const M3ESliderRange(0.25, 0.75);
  double _vertical = 0.4;

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
          label: 'Wavy',
          children: <Widget>[
            SizedBox(
              width: 260,
              child: M3ESlider.wavy(
                value: _wavy,
                onChanged: (double value) => setState(() => _wavy = value),
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Discrete (0-5) • haptic',
          children: <Widget>[
            SizedBox(
              width: 260,
              child: M3ESlider(
                value: _brightness,
                max: 5,
                divisions: 5,
                haptic: M3EHapticFeedback.light,
                onChanged: (double value) =>
                    setState(() => _brightness = value),
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Disabled',
          children: <Widget>[
            SizedBox(
              width: 260,
              child: M3ESlider(
                value: _disabled,
                enabled: false,
                onChanged: (double value) => setState(() => _disabled = value),
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Shape dots • thick track',
          children: <Widget>[
            SizedBox(
              width: 260,
              child: M3ESlider(
                value: _shapeDots,
                max: 4,
                divisions: 4,
                trackThickness: 30,
                cornerRadius: 8,
                thumbLength: 50,
                dotSize: 12,
                dotSpacing: 10,
                onChanged: (double value) => setState(() => _shapeDots = value),
                dotBuilder:
                    ({
                      required BuildContext context,
                      required Color color,
                      required double size,
                      required bool active,
                    }) {
                      return CustomPaint(
                        painter: _M3EShapeDotPainter(
                          polygon: active
                              ? M3EMaterialNewShapes.cookie4Sided
                              : M3EMaterialNewShapes.softBurst,
                          color: color,
                        ),
                      );
                    },
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Centered (−100…100)',
          children: <Widget>[
            SizedBox(
              width: 260,
              child: M3ESlider.centered(
                value: _balance,
                min: -100,
                max: 100,
                onChanged: (double value) => setState(() => _balance = value),
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Range',
          children: <Widget>[
            SizedBox(
              width: 260,
              child: M3ERangeSlider(
                values: _range,
                onChanged: (M3ESliderRange value) =>
                    setState(() => _range = value),
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Wavy range',
          children: <Widget>[
            SizedBox(
              width: 260,
              child: M3ERangeSlider.wavy(
                values: _wavyRange,
                onChanged: (M3ESliderRange value) =>
                    setState(() => _wavyRange = value),
              ),
            ),
          ],
        ),
        DemoRow(
          label: 'Vertical • relocating icon',
          children: <Widget>[
            SizedBox(
              height: 160,
              width: 80,
              child: M3ESlider.vertical(
                value: _vertical,
                trackThickness: 40,
                thumbLength: 80,
                icon: const Icon(M3EIcons.volume_up),
                iconPosition: M3ESliderIconPosition.end,
                onChanged: (double value) => setState(() => _vertical = value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Fills a [M3EMaterialNewShapes] polygon into the available paint size.
class _M3EShapeDotPainter extends CustomPainter {
  const _M3EShapeDotPainter({required this.polygon, required this.color});

  final RoundedPolygon polygon;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = polygon.toPath();
    final Matrix4 scale = Matrix4.diagonal3Values(size.width, size.height, 1);
    final Path scaled = path.transform(scale.storage);
    final Rect bounds = scaled.getBounds();
    final Path centered = scaled.shift(
      Offset(size.width / 2, size.height / 2) - bounds.center,
    );
    canvas.drawPath(
      centered,
      Paint()
        ..style = PaintingStyle.fill
        ..color = color
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant _M3EShapeDotPainter oldDelegate) {
    return oldDelegate.polygon != polygon || oldDelegate.color != color;
  }
}
