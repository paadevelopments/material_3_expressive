import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3EIconButton].
class IconButtonsPlayground extends PlaygroundWidget {
  /// Creates the icon buttons playground.
  const IconButtonsPlayground({super.key});

  @override
  PlaygroundState<IconButtonsPlayground> createState() =>
      _IconButtonsPlaygroundState();
}

class _IconButtonsPlaygroundState
    extends PlaygroundState<IconButtonsPlayground> {
  M3EIconButtonVariant _variant = M3EIconButtonVariant.filled;
  M3EIconButtonSize _size = M3EIconButtonSize.sm;
  M3EIconButtonShapeVariant _shape = M3EIconButtonShapeVariant.round;
  M3EIconButtonWidth _width = M3EIconButtonWidth.defaultWidth;
  M3EHapticFeedback _haptic = M3EHapticFeedback.none;
  bool _enabled = true;
  bool _toggle = false;
  bool _selected = false;
  bool _selectedIcon = true;
  bool _badge = false;
  double _badgeCount = 3;
  bool _gradient = false;
  bool _tooltip = true;
  String _tooltipText = 'Favorite';

  static final M3EIconButtonDecoration _gradientDecoration =
      M3EIconButtonDecoration(
        backgroundGradient: WidgetStateProperty.all(
          const LinearGradient(
            colors: <Color>[Color(0xFF6750A4), Color(0xFF9A82DB)],
          ),
        ),
        foregroundGradient: WidgetStateProperty.all(
          const LinearGradient(
            colors: <Color>[Color(0xFFFFFFFF), Color(0xFFEADDFF)],
          ),
        ),
        outlineGradient: WidgetStateProperty.all(
          const LinearGradient(
            colors: <Color>[Color(0xFF4F378B), Color(0xFFD0BCFF)],
          ),
        ),
      );

  /// Badge count; zero shows a dot.
  int get _badgeValue => _badgeCount.round();

  @override
  Widget buildPreview(BuildContext context) {
    return M3EIconButton(
      icon: Icon(_toggle ? M3EIcons.favorite_border : M3EIcons.favorite),
      selectedIcon: _toggle && _selectedIcon
          ? const Icon(M3EIcons.favorite)
          : null,
      onPressed: _enabled
          ? () {
              if (_toggle) {
                setState(() => _selected = !_selected);
              }
            }
          : null,
      variant: _variant,
      size: _size,
      shape: _shape,
      width: _width,
      haptic: _haptic,
      isSelected: _toggle ? _selected : null,
      badgeValue: _badge ? _badgeValue : null,
      decoration: _gradient ? _gradientDecoration : null,
      tooltip: _tooltip ? _tooltipText : null,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln(
        '  icon: const Icon(M3EIcons.'
        '${_toggle ? 'favorite_border' : 'favorite'}),',
      )
      ..writeln('  onPressed: ${_enabled ? '() {}' : 'null'},')
      ..writeln('  variant: M3EIconButtonVariant.${_variant.name},')
      ..writeln('  size: M3EIconButtonSize.${_size.name},')
      ..writeln('  shape: M3EIconButtonShapeVariant.${_shape.name},')
      ..writeln('  width: M3EIconButtonWidth.${_width.name},');
    if (_haptic != M3EHapticFeedback.none) {
      args.writeln('  haptic: M3EHapticFeedback.${_haptic.name},');
    }
    if (_toggle) {
      if (_selectedIcon) {
        args.writeln('  selectedIcon: const Icon(M3EIcons.favorite),');
      }
      args.writeln('  isSelected: $_selected,');
    }
    if (_badge) {
      args.writeln('  badgeValue: $_badgeValue,');
    }
    if (_gradient) {
      args.writeln(
        '  decoration: M3EIconButtonDecoration(\n'
        '    backgroundGradient: WidgetStateProperty.all(gradient),\n'
        '  ),',
      );
    }
    if (_tooltip) {
      args.writeln('  tooltip: ${playDartString(_tooltipText)},');
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Icon button',
        code: '$kPlaySnippetImport\n\nM3EIconButton(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3EIconButtonVariant>(
            label: 'Variant',
            value: _variant,
            values: M3EIconButtonVariant.values,
            labelOf: (M3EIconButtonVariant v) => v.name,
            onChanged: (M3EIconButtonVariant v) => setState(() => _variant = v),
          ),
          PlayEnumChoice<M3EIconButtonSize>(
            label: 'Size',
            value: _size,
            values: M3EIconButtonSize.values,
            labelOf: (M3EIconButtonSize v) => v.name,
            onChanged: (M3EIconButtonSize v) => setState(() => _size = v),
          ),
          PlayEnumChoice<M3EIconButtonShapeVariant>(
            label: 'Shape',
            value: _shape,
            values: M3EIconButtonShapeVariant.values,
            labelOf: (M3EIconButtonShapeVariant v) => v.name,
            onChanged: (M3EIconButtonShapeVariant v) {
              setState(() => _shape = v);
            },
          ),
          PlayEnumChoice<M3EIconButtonWidth>(
            label: 'Width',
            value: _width,
            values: M3EIconButtonWidth.values,
            labelOf: (M3EIconButtonWidth v) =>
                v == M3EIconButtonWidth.defaultWidth ? 'default' : v.name,
            onChanged: (M3EIconButtonWidth v) => setState(() => _width = v),
          ),
          PlaySwitchItem(
            label: 'Gradient fill',
            description: 'Background, foreground and outline gradients',
            value: _gradient,
            onChanged: (bool v) => setState(() => _gradient = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Toggle',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Toggle button',
            description: 'Pressing flips the selected state',
            value: _toggle,
            onChanged: (bool v) => setState(() => _toggle = v),
          ),
          if (_toggle) ...<Widget>[
            PlaySwitchItem(
              label: 'Selected',
              value: _selected,
              onChanged: (bool v) => setState(() => _selected = v),
            ),
            PlaySwitchItem(
              label: 'Selected icon',
              description: 'Filled heart when selected',
              value: _selectedIcon,
              onChanged: (bool v) => setState(() => _selectedIcon = v),
            ),
          ],
        ],
      ),
      PlayControlGroup(
        title: 'Badge',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Show badge',
            value: _badge,
            onChanged: (bool v) => setState(() => _badge = v),
          ),
          if (_badge)
            PlaySlider(
              label: 'Badge count (0 = dot)',
              value: _badgeCount,
              max: 120,
              divisions: 120,
              onChanged: (double v) => setState(() => _badgeCount = v),
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
          PlaySwitchItem(
            label: 'Tooltip',
            value: _tooltip,
            onChanged: (bool v) => setState(() => _tooltip = v),
          ),
          if (_tooltip)
            PlayTextField(
              label: 'Tooltip text',
              value: _tooltipText,
              onChanged: (String v) => setState(() => _tooltipText = v),
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
