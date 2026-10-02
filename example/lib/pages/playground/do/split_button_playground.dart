import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/playground.dart';

/// Where the trailing menu entries come from.
enum _MenuSource { items, m3eMenu }

/// Live playground for [M3ESplitButton].
class SplitButtonPlayground extends PlaygroundWidget {
  /// Creates the split button playground.
  const SplitButtonPlayground({super.key});

  @override
  PlaygroundState<SplitButtonPlayground> createState() =>
      _SplitButtonPlaygroundState();
}

class _SplitButtonPlaygroundState
    extends PlaygroundState<SplitButtonPlayground> {
  M3EButtonStyle _style = M3EButtonStyle.filled;
  M3EButtonSize _size = M3EButtonSize.sm;
  M3EButtonShape _shape = M3EButtonShape.round;
  M3ESplitButtonTrailingAlignment _trailingAlignment =
      M3ESplitButtonTrailingAlignment.opticalCenter;
  _MenuSource _source = _MenuSource.items;
  M3ESplitButtonMenuStyle _menuStyle = M3ESplitButtonMenuStyle.popup;
  M3ESplitButtonSelectionMode _selectionMode =
      M3ESplitButtonSelectionMode.single;
  bool _enabled = true;
  bool _leadingIcon = true;
  bool _tooltips = false;
  bool _trackSelection = true;
  bool _gradient = false;
  String _label = 'Save';
  String? _selected;

  static const List<M3EButtonSize> _sizes = <M3EButtonSize>[
    M3EButtonSize.xs,
    M3EButtonSize.sm,
    M3EButtonSize.md,
    M3EButtonSize.lg,
    M3EButtonSize.xl,
  ];

  static const List<M3EButtonStyle> _styles = <M3EButtonStyle>[
    M3EButtonStyle.filled,
    M3EButtonStyle.tonal,
    M3EButtonStyle.elevated,
    M3EButtonStyle.outlined,
  ];

  static const List<M3ESplitButtonItem<String>> _items =
      <M3ESplitButtonItem<String>>[
        M3ESplitButtonItem<String>(value: 'draft', child: Text('Save draft')),
        M3ESplitButtonItem<String>(value: 'copy', child: Text('Save a copy')),
        M3ESplitButtonItem<String>(value: 'pdf', child: Text('Export PDF')),
      ];

  /// Menu styles the current source supports.
  List<M3ESplitButtonMenuStyle> get _menuStyles => _source == _MenuSource.items
      ? M3ESplitButtonMenuStyle.values
      : const <M3ESplitButtonMenuStyle>[
          M3ESplitButtonMenuStyle.popup,
          M3ESplitButtonMenuStyle.native,
        ];

  bool get _bottomSheet =>
      _source == _MenuSource.items &&
      _menuStyle == M3ESplitButtonMenuStyle.bottomSheet;

  bool get _multi =>
      _bottomSheet && _selectionMode == M3ESplitButtonSelectionMode.multiple;

  M3ESplitButtonDecoration get _decoration {
    return M3ESplitButtonDecoration(
      menuStyle: _menuStyle,
      bottomSheetDecoration: _bottomSheet
          ? M3ESplitButtonBottomSheetDecoration(selectionMode: _selectionMode)
          : null,
      backgroundGradient: _gradient
          ? WidgetStateProperty.all(
              const LinearGradient(
                colors: <Color>[Color(0xFF6750A4), Color(0xFF9A82DB)],
              ),
            )
          : null,
      foregroundGradient: _gradient
          ? WidgetStateProperty.all(
              const LinearGradient(
                colors: <Color>[Color(0xFFFFFFFF), Color(0xFFEADDFF)],
              ),
            )
          : null,
      outlineGradient: _gradient
          ? WidgetStateProperty.all(
              const LinearGradient(
                colors: <Color>[Color(0xFF4F378B), Color(0xFFD0BCFF)],
              ),
            )
          : null,
    );
  }

  List<M3EMenuNode> _m3eMenu(BuildContext context) {
    return <M3EMenuNode>[
      const M3EMenuEntry(
        label: 'Email',
        leading: Icon(M3EIcons.mail),
        value: 'email',
      ),
      M3EMenuSubmenu(
        label: 'More',
        children: const <M3EMenuNode>[
          M3EMenuEntry(label: 'Message', value: 'message'),
          M3EMenuEntry(label: 'QR code', value: 'qr'),
        ],
      ),
    ];
  }

  @override
  Widget buildPreview(BuildContext context) {
    final bool items = _source == _MenuSource.items;
    return M3ESplitButton<String>(
      label: _label,
      leadingIcon: _leadingIcon ? M3EIcons.save : null,
      style: _style,
      size: _size,
      shape: _shape,
      trailingAlignment: _trailingAlignment,
      leadingTooltip: _tooltips ? _label : null,
      trailingTooltip: _tooltips ? 'More options' : null,
      enabled: _enabled,
      selectedValue: items && _trackSelection && !_multi ? _selected : null,
      decoration: _decoration,
      onPressed: _enabled ? () {} : null,
      onSelected: _enabled
          ? (String value) => setState(() => _selected = value)
          : null,
      onMultiSelected: _multi ? (Set<String> values) {} : null,
      items: items ? _items : null,
      m3eMenuBuilder: items ? null : _m3eMenu,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final bool items = _source == _MenuSource.items;
    final StringBuffer args = StringBuffer()
      ..writeln('  label: ${playDartString(_label)},');
    if (_leadingIcon) {
      args.writeln('  leadingIcon: M3EIcons.save,');
    }
    args
      ..writeln('  style: M3EButtonStyle.${_style.name},')
      ..writeln('  size: M3EButtonSize.${_size.name},')
      ..writeln('  shape: M3EButtonShape.${_shape.name},')
      ..writeln(
        '  trailingAlignment: '
        'M3ESplitButtonTrailingAlignment.${_trailingAlignment.name},',
      )
      ..writeln('  enabled: $_enabled,');
    if (_tooltips) {
      args
        ..writeln('  leadingTooltip: ${playDartString(_label)},')
        ..writeln("  trailingTooltip: 'More options',");
    }
    args
      ..writeln('  decoration: M3ESplitButtonDecoration(')
      ..writeln('    menuStyle: M3ESplitButtonMenuStyle.${_menuStyle.name},');
    if (_bottomSheet) {
      args.writeln(
        '    bottomSheetDecoration: M3ESplitButtonBottomSheetDecoration(\n'
        '      selectionMode: '
        'M3ESplitButtonSelectionMode.${_selectionMode.name},\n'
        '    ),',
      );
    }
    if (_gradient) {
      args.writeln(
        '    backgroundGradient: WidgetStateProperty.all(gradient),',
      );
    }
    args
      ..writeln('  ),')
      ..writeln('  onPressed: () {},')
      ..writeln('  onSelected: (String value) {},');
    if (_multi) {
      args.writeln('  onMultiSelected: (Set<String> values) {},');
    }
    if (items) {
      if (_trackSelection && !_multi) {
        args.writeln(
          '  selectedValue: '
          '${_selected == null ? 'null' : playDartString(_selected!)},',
        );
      }
      args.writeln(
        '  items: const <M3ESplitButtonItem<String>>[\n'
        "    M3ESplitButtonItem<String>(value: 'draft', "
        "child: Text('Save draft')),\n"
        "    M3ESplitButtonItem<String>(value: 'copy', "
        "child: Text('Save a copy')),\n"
        "    M3ESplitButtonItem<String>(value: 'pdf', "
        "child: Text('Export PDF')),\n"
        '  ],',
      );
    } else {
      args.writeln(
        '  items: null,\n'
        '  m3eMenuBuilder: (BuildContext context) => <M3EMenuNode>[\n'
        "    const M3EMenuEntry(label: 'Email', value: 'email'),\n"
        '    M3EMenuSubmenu(\n'
        "      label: 'More',\n"
        '      children: const <M3EMenuNode>[\n'
        "        M3EMenuEntry(label: 'Message', value: 'message'),\n"
        '      ],\n'
        '    ),\n'
        '  ],',
      );
    }
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Split button',
        code: '$kPlaySnippetImport\n\nM3ESplitButton<String>(\n$args);',
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
            values: _styles,
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
          PlayEnumChoice<M3ESplitButtonTrailingAlignment>(
            label: 'Trailing icon alignment',
            value: _trailingAlignment,
            values: M3ESplitButtonTrailingAlignment.values,
            labelOf: (M3ESplitButtonTrailingAlignment v) => switch (v) {
              M3ESplitButtonTrailingAlignment.opticalCenter => 'optical',
              M3ESplitButtonTrailingAlignment.geometricCenter => 'geometric',
            },
            onChanged: (M3ESplitButtonTrailingAlignment v) {
              setState(() => _trailingAlignment = v);
            },
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
            label: 'Leading icon',
            value: _leadingIcon,
            onChanged: (bool v) => setState(() => _leadingIcon = v),
          ),
          PlaySwitchItem(
            label: 'Tooltips',
            description: 'On the leading and trailing segments',
            value: _tooltips,
            onChanged: (bool v) => setState(() => _tooltips = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Menu',
        children: <Widget>[
          PlayEnumChoice<_MenuSource>(
            label: 'Entries',
            value: _source,
            values: _MenuSource.values,
            labelOf: (_MenuSource v) => switch (v) {
              _MenuSource.items => 'items',
              _MenuSource.m3eMenu => 'M3E menu',
            },
            onChanged: (_MenuSource v) {
              setState(() {
                _source = v;
                if (!_menuStyles.contains(_menuStyle)) {
                  _menuStyle = M3ESplitButtonMenuStyle.popup;
                }
              });
            },
          ),
          PlayEnumChoice<M3ESplitButtonMenuStyle>(
            label: 'Menu style',
            value: _menuStyle,
            values: _menuStyles,
            labelOf: (M3ESplitButtonMenuStyle v) => v.name,
            onChanged: (M3ESplitButtonMenuStyle v) {
              setState(() => _menuStyle = v);
            },
          ),
          if (_bottomSheet)
            PlayEnumChoice<M3ESplitButtonSelectionMode>(
              label: 'Selection mode',
              value: _selectionMode,
              values: M3ESplitButtonSelectionMode.values,
              labelOf: (M3ESplitButtonSelectionMode v) => v.name,
              onChanged: (M3ESplitButtonSelectionMode v) {
                setState(() => _selectionMode = v);
              },
            ),
          if (_source == _MenuSource.items && !_multi)
            PlaySwitchItem(
              label: 'Track selection',
              description: 'Marks the last chosen entry',
              value: _trackSelection,
              onChanged: (bool v) => setState(() => _trackSelection = v),
            ),
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
        ],
      ),
    ];
  }
}
