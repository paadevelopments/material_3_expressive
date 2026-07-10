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

class _SelectionPageState extends State<SelectionPage> {
  bool? _checked = true;
  bool? _tristate;
  String _plan = 'standard';
  bool _wifi = true;
  bool _bluetooth = false;
  final Set<String> _chips = <String>{'flutter'};
  double _volume = 0.5;
  double _brightness = 3;
  DateTime? _date;
  M3ETime _time = const M3ETime(hour: 9, minute: 30);

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
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
          title: 'Sliders',
          children: <Widget>[
            DemoRow(
              label: 'Continuous',
              children: <Widget>[
                SizedBox(
                  width: 260,
                  child: M3ESlider(
                    value: _volume,
                    onChanged: (double value) =>
                        setState(() => _volume = value),
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
}
