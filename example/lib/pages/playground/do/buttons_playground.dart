import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Live playground for [M3EButton].
class ButtonsPlayground extends PlaygroundWidget {
  /// Creates the buttons playground.
  const ButtonsPlayground({super.key});

  @override
  PlaygroundState<ButtonsPlayground> createState() => _ButtonsPlaygroundState();
}

class _ButtonsPlaygroundState extends PlaygroundState<ButtonsPlayground> {
  M3EButtonStyle _style = M3EButtonStyle.filled;
  M3EButtonSize _size = M3EButtonSize.sm;
  M3EButtonShape _shape = M3EButtonShape.round;
  bool _enabled = true;
  bool _showIcon = true;
  IconAlignment _iconAlignment = IconAlignment.start;
  String _label = 'Label';
  bool _toggle = false;
  bool _selected = false;
  bool _selectedLabel = false;
  String _selectedText = 'Selected';
  bool _gradient = false;
  bool _tooltip = false;
  String _tooltipText = 'Button tooltip';

  static const List<M3EButtonSize> _sizes = <M3EButtonSize>[
    M3EButtonSize.xs,
    M3EButtonSize.sm,
    M3EButtonSize.md,
    M3EButtonSize.lg,
    M3EButtonSize.xl,
  ];

  static final M3EButtonDecoration _gradientDecoration = M3EButtonDecoration(
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

  /// Selection is ignored by the text style.
  bool get _canToggle => _style != M3EButtonStyle.text;

  bool get _toggleActive => _toggle && _canToggle;

  /// Icon alignment applies to the plain icon + label layout only.
  bool get _canAlignIcon => _showIcon && !_toggleActive;

  M3EButtonDecoration? get _decoration {
    final IconAlignment? alignment = _canAlignIcon ? _iconAlignment : null;
    if (_gradient) {
      return _gradientDecoration.copyWith(iconAlignment: alignment);
    }
    if (alignment != null && alignment != IconAlignment.start) {
      return M3EButtonDecoration(iconAlignment: alignment);
    }
    return null;
  }

  @override
  Widget buildPreview(BuildContext context) {
    final VoidCallback? onPressed = _enabled
        ? () {
            if (_toggleActive) {
              setState(() => _selected = !_selected);
            }
          }
        : null;
    final String? tooltip = _tooltip ? _tooltipText : null;
    if (!_showIcon && !_toggleActive) {
      return M3EButton(
        onPressed: onPressed,
        style: _style,
        size: _size,
        shape: _shape,
        decoration: _decoration,
        tooltip: tooltip,
        child: Text(_label),
      );
    }
    return M3EButton(
      onPressed: onPressed,
      style: _style,
      size: _size,
      shape: _shape,
      decoration: _decoration,
      tooltip: tooltip,
      icon: _showIcon ? const Icon(M3EIcons.add) : null,
      label: Text(_label),
      selectedIcon: _toggleActive && _showIcon
          ? const Icon(M3EIcons.check)
          : null,
      selectedLabel: _toggleActive && _selectedLabel
          ? Text(_selectedText)
          : null,
      isSelected: _toggleActive ? _selected : null,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final String pressed = _enabled ? '() {}' : 'null';
    final StringBuffer args = StringBuffer()
      ..writeln('  onPressed: $pressed,')
      ..writeln('  style: M3EButtonStyle.${_style.name},')
      ..writeln('  size: M3EButtonSize.${_size.name},')
      ..writeln('  shape: M3EButtonShape.${_shape.name},');
    if (!_showIcon && !_toggleActive) {
      args.writeln('  child: Text(${playDartString(_label)}),');
    } else {
      if (_showIcon) {
        args.writeln('  icon: const Icon(M3EIcons.add),');
      }
      args.writeln('  label: Text(${playDartString(_label)}),');
    }
    if (_toggleActive) {
      if (_showIcon) {
        args.writeln('  selectedIcon: const Icon(M3EIcons.check),');
      }
      if (_selectedLabel) {
        args.writeln(
          '  selectedLabel: Text(${playDartString(_selectedText)}),',
        );
      }
      args.writeln('  isSelected: $_selected,');
    }
    if (_tooltip) {
      args.writeln('  tooltip: ${playDartString(_tooltipText)},');
    }
    if (_gradient) {
      args.writeln(
        '  decoration: M3EButtonDecoration(\n'
        '    backgroundGradient: WidgetStateProperty.all(gradient),\n'
        '    foregroundGradient: WidgetStateProperty.all(onGradient),\n'
        '  ),',
      );
    } else if (_canAlignIcon && _iconAlignment != IconAlignment.start) {
      args.writeln(
        '  decoration: const M3EButtonDecoration(\n'
        '    iconAlignment: IconAlignment.${_iconAlignment.name},\n'
        '  ),',
      );
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Button',
        code: '$kPlaySnippetImport\n\nM3EButton(\n$args);',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Appearance',
        children: <Widget>[
          PlayEnumChoice<M3EButtonStyle>(
            label: 'Style',
            value: _style,
            values: M3EButtonStyle.values,
            labelOf: (M3EButtonStyle v) => v.name,
            onChanged: (M3EButtonStyle v) => setState(() => _style = v),
          ),
          PlayEnumChoice<M3EButtonSize>(
            label: 'Size',
            value: _size,
            values: _sizes,
            labelOf: (M3EButtonSize v) => v.name,
            onChanged: (M3EButtonSize v) => setState(() => _size = v),
          ),
          PlayEnumChoice<M3EButtonShape>(
            label: 'Shape',
            value: _shape,
            values: M3EButtonShape.values,
            labelOf: (M3EButtonShape v) => v.name,
            onChanged: (M3EButtonShape v) => setState(() => _shape = v),
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
        title: 'Content',
        children: <Widget>[
          PlayTextField(
            label: 'Label',
            value: _label,
            onChanged: (String v) => setState(() => _label = v),
          ),
          PlaySwitchItem(
            label: 'Show icon',
            value: _showIcon,
            onChanged: (bool v) => setState(() => _showIcon = v),
          ),
          if (_canAlignIcon)
            PlayEnumChoice<IconAlignment>(
              label: 'Icon alignment',
              value: _iconAlignment,
              values: IconAlignment.values,
              labelOf: (IconAlignment v) => v.name,
              onChanged: (IconAlignment v) {
                setState(() => _iconAlignment = v);
              },
            ),
        ],
      ),
      if (_canToggle)
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
                label: 'Selected label',
                value: _selectedLabel,
                onChanged: (bool v) => setState(() => _selectedLabel = v),
              ),
              if (_selectedLabel)
                PlayTextField(
                  label: 'Selected label text',
                  value: _selectedText,
                  onChanged: (String v) => setState(() => _selectedText = v),
                ),
            ],
          ],
        ),
      PlayControlGroup(
        title: 'State',
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
        ],
      ),
    ];
  }
}
