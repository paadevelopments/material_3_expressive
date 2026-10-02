import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Components the focus ring is shown on.
enum _Target { button, iconButton, card, switchControl, checkbox, chip, slider }

/// Ring color presets; theme follows the default.
enum _RingColor { theme, primary, tertiary, error }

/// Live playground for [M3EFocusRingTheme].
class FocusRingPlayground extends PlaygroundWidget {
  /// Creates the focus ring playground.
  const FocusRingPlayground({super.key});

  @override
  PlaygroundState<FocusRingPlayground> createState() =>
      _FocusRingPlaygroundState();
}

class _FocusRingPlaygroundState extends PlaygroundState<FocusRingPlayground> {
  _Target _target = _Target.button;
  _RingColor _color = _RingColor.theme;
  double _width = 2;
  double _gap = 2;
  bool _checked = true;
  double _slider = 0.4;

  Color? _ringColor(M3EColorScheme scheme) => switch (_color) {
    _RingColor.theme => null,
    _RingColor.primary => scheme.primary,
    _RingColor.tertiary => scheme.tertiary,
    _RingColor.error => scheme.error,
  };

  Widget _targetWidget() {
    return switch (_target) {
      _Target.button => M3EButton.filled(
        onPressed: () {},
        child: const Text('Button'),
      ),
      _Target.iconButton => M3EIconButton(
        icon: const Icon(M3EIcons.favorite),
        tooltip: 'Favorite',
        onPressed: () {},
      ),
      _Target.card => SizedBox(
        width: 200,
        child: M3ECard(
          variant: M3ECardVariant.filled,
          onPressed: () {},
          headline: 'Card',
          supportingText: 'Focusable surface',
        ),
      ),
      _Target.switchControl => M3ESwitch(
        value: _checked,
        onChanged: (bool v) => setState(() => _checked = v),
      ),
      _Target.checkbox => M3ECheckbox(
        value: _checked,
        label: const Text('Checkbox'),
        onChanged: (bool? v) => setState(() => _checked = v ?? false),
      ),
      _Target.chip => M3EChip(
        label: 'Chip',
        type: M3EChipType.filter,
        selected: _checked,
        onPressed: () => setState(() => _checked = !_checked),
      ),
      _Target.slider => SizedBox(
        width: 240,
        child: M3ESlider(
          value: _slider,
          onChanged: (double v) => setState(() => _slider = v),
        ),
      ),
    };
  }

  @override
  Widget buildPreview(BuildContext context) {
    final M3EThemeData base = M3ETheme.of(context);
    final M3EThemeData themed = base.copyWith(
      focusRingTheme: base.focusRingTheme.copyWith(
        color: _ringColor(base.colorScheme),
        clearColor: _color == _RingColor.theme,
        width: _width,
        gap: _gap,
      ),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        M3ETheme(
          data: themed,
          child: KeyedSubtree(
            key: ValueKey<_Target>(_target),
            child: _targetWidget(),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Press Tab to move focus onto the component.',
          style: base.typeScale.bodyMedium.copyWith(
            color: base.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final String color = switch (_color) {
      _RingColor.theme => '',
      _ => '    color: scheme.${_color.name},\n',
    };
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Focus ring theme',
        code:
            '''
$kPlaySnippetImport

M3ETheme(
  data: theme.copyWith(
    focusRingTheme: M3EFocusRingTheme(
$color    width: ${_width.round()},
    gap: ${_gap.round()},
    ),
  ),
  child: child,
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Target',
        children: <Widget>[
          PlayEnumChoice<_Target>(
            label: 'Component',
            value: _target,
            values: _Target.values,
            labelOf: (_Target v) => switch (v) {
              _Target.button => 'button',
              _Target.iconButton => 'icon button',
              _Target.card => 'card',
              _Target.switchControl => 'switch',
              _Target.checkbox => 'checkbox',
              _Target.chip => 'chip',
              _Target.slider => 'slider',
            },
            onChanged: (_Target v) => setState(() => _target = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Ring',
        children: <Widget>[
          PlayEnumChoice<_RingColor>(
            label: 'Color',
            value: _color,
            values: _RingColor.values,
            labelOf: (_RingColor v) => switch (v) {
              _RingColor.theme => 'theme default',
              _ => v.name,
            },
            onChanged: (_RingColor v) => setState(() => _color = v),
          ),
          PlaySlider(
            label: 'Width',
            value: _width,
            min: 1,
            max: 6,
            divisions: 5,
            onChanged: (double v) => setState(() => _width = v),
          ),
          PlaySlider(
            label: 'Gap',
            value: _gap,
            max: 8,
            divisions: 8,
            onChanged: (double v) => setState(() => _gap = v),
          ),
        ],
      ),
    ];
  }
}
