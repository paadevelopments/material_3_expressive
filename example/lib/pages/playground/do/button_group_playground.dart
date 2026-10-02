import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// How demo actions are composed in the button group playground.
enum _ActionContentMode { text, textWithIcon, icon }

/// Icon-only resting width preset applied to the middle action.
enum _IconRestingWidth { narrow, defaultWidth, wide }

/// Live playground for [M3EButtonGroup].
class ButtonGroupPlayground extends PlaygroundWidget {
  /// Creates the button group playground.
  const ButtonGroupPlayground({super.key});

  @override
  PlaygroundState<ButtonGroupPlayground> createState() =>
      _ButtonGroupPlaygroundState();
}

class _ButtonGroupPlaygroundState
    extends PlaygroundState<ButtonGroupPlayground> {
  M3EButtonGroupType _type = M3EButtonGroupType.standard;
  Axis _direction = Axis.horizontal;
  M3EButtonShape _shape = M3EButtonShape.round;
  M3EButtonSize _size = M3EButtonSize.sm;
  M3EButtonStyle _style = M3EButtonStyle.filled;
  M3EButtonGroupDensity _density = M3EButtonGroupDensity.regular;
  _ActionContentMode _contentMode = _ActionContentMode.textWithIcon;
  _IconRestingWidth _middleIconWidth = _IconRestingWidth.defaultWidth;
  double _actionCount = 3;
  bool _selectable = true;
  bool _multiSelect = false;
  bool _selectionRequired = true;
  int? _selectedIndex = 0;
  Set<int> _selectedIndices = <int>{0};
  bool _neighborSquish = true;
  double _expandedRatio = 0.15;
  M3EButtonGroupOverflow _overflow = M3EButtonGroupOverflow.scroll;
  M3EButtonGroupOverflowMenuStyle _menuStyle =
      M3EButtonGroupOverflowMenuStyle.popup;
  bool _constrain = false;
  double _maxExtent = 240;
  M3EHapticFeedback _haptic = M3EHapticFeedback.none;

  static const List<M3EButtonSize> _sizes = <M3EButtonSize>[
    M3EButtonSize.xs,
    M3EButtonSize.sm,
    M3EButtonSize.md,
    M3EButtonSize.lg,
    M3EButtonSize.xl,
  ];

  static const List<(IconData, String)> _items = <(IconData, String)>[
    (M3EIcons.format_align_left, 'Left'),
    (M3EIcons.format_align_center, 'Center'),
    (M3EIcons.format_align_right, 'Right'),
    (M3EIcons.format_align_justify, 'Justify'),
    (M3EIcons.calendar_today, 'Today'),
    (M3EIcons.date_range, 'Week'),
    (M3EIcons.event, 'Event'),
    (M3EIcons.schedule, 'Later'),
  ];

  int get _count => _actionCount.round();

  M3EIconButtonSize get _iconSizeForGroup => switch (_size) {
    M3EButtonSize.xs => M3EIconButtonSize.xs,
    M3EButtonSize.sm => M3EIconButtonSize.sm,
    M3EButtonSize.md => M3EIconButtonSize.md,
    M3EButtonSize.lg => M3EIconButtonSize.lg,
    M3EButtonSize.xl => M3EIconButtonSize.xl,
    _ => M3EIconButtonSize.md,
  };

  double? _middleMinWidth(BuildContext context) {
    final M3EIconButtonWidth token = switch (_middleIconWidth) {
      _IconRestingWidth.narrow => M3EIconButtonWidth.narrow,
      _IconRestingWidth.defaultWidth => M3EIconButtonWidth.defaultWidth,
      _IconRestingWidth.wide => M3EIconButtonWidth.wide,
    };
    return M3ETheme.of(context).iconButtonTheme
        .visual(_iconSizeForGroup, token)
        .width;
  }

  List<M3EButtonGroupAction> _actions(BuildContext context) {
    final int middle = _count ~/ 2;
    return <M3EButtonGroupAction>[
      for (int i = 0; i < _count; i++)
        switch (_contentMode) {
          _ActionContentMode.text => M3EButtonGroupAction(
            label: Text(_items[i].$2),
          ),
          _ActionContentMode.textWithIcon => M3EButtonGroupAction(
            icon: Icon(_items[i].$1),
            label: Text(_items[i].$2),
          ),
          _ActionContentMode.icon => M3EButtonGroupAction(
            icon: Icon(_items[i].$1),
            semanticLabel: _items[i].$2,
            minWidth: i == middle ? _middleMinWidth(context) : null,
          ),
        },
    ];
  }

  void _setMultiSelect(bool value) {
    setState(() {
      _multiSelect = value;
      if (value) {
        _selectedIndices = _selectedIndex != null
            ? <int>{_selectedIndex!}
            : <int>{};
      } else {
        _selectedIndex = _selectedIndices.isEmpty
            ? null
            : _selectedIndices.first;
      }
    });
  }

  @override
  Widget buildPreview(BuildContext context) {
    final bool single = _selectable && !_multiSelect;
    final bool multi = _selectable && _multiSelect;
    final Widget group = M3EButtonGroup(
      type: _type,
      direction: _direction,
      shape: _shape,
      size: _size,
      style: _style,
      density: _density,
      neighborSquish: _neighborSquish,
      expandedRatio: _expandedRatio,
      haptic: _haptic,
      multiSelect: multi,
      selectionRequired: _selectable && _selectionRequired,
      overflow: _overflow,
      overflowMenuStyle: _menuStyle,
      selectedIndex: single ? _selectedIndex?.clamp(0, _count - 1) : null,
      onSelectedIndexChanged: single
          ? (int? index) => setState(() => _selectedIndex = index)
          : null,
      selectedIndices: multi
          ? _selectedIndices.where((int i) => i < _count).toSet()
          : null,
      onSelectedIndicesChanged: multi
          ? (Set<int> indices) => setState(() => _selectedIndices = indices)
          : null,
      actions: _actions(context),
    );
    if (!_constrain) {
      return group;
    }
    return _direction == Axis.horizontal
        ? SizedBox(width: _maxExtent, child: group)
        : SizedBox(height: _maxExtent, child: group);
  }

  @override
  List<PlaySnippet> get snippets {
    final StringBuffer args = StringBuffer()
      ..writeln('  type: M3EButtonGroupType.${_type.name},')
      ..writeln('  direction: Axis.${_direction.name},')
      ..writeln('  shape: M3EButtonShape.${_shape.name},')
      ..writeln('  size: M3EButtonSize.${_size.name},')
      ..writeln('  style: M3EButtonStyle.${_style.name},')
      ..writeln('  density: M3EButtonGroupDensity.${_density.name},')
      ..writeln('  neighborSquish: $_neighborSquish,');
    if (_neighborSquish) {
      args.writeln('  expandedRatio: ${_expandedRatio.toStringAsFixed(2)},');
    }
    args.writeln('  overflow: M3EButtonGroupOverflow.${_overflow.name},');
    if (_overflow == M3EButtonGroupOverflow.menu) {
      args.writeln(
        '  overflowMenuStyle: '
        'M3EButtonGroupOverflowMenuStyle.${_menuStyle.name},',
      );
    }
    if (_haptic != M3EHapticFeedback.none) {
      args.writeln('  haptic: M3EHapticFeedback.${_haptic.name},');
    }
    if (_selectable) {
      args.writeln('  selectionRequired: $_selectionRequired,');
      if (_multiSelect) {
        args
          ..writeln('  multiSelect: true,')
          ..writeln('  selectedIndices: <int>{${_selectedIndices.join(', ')}},')
          ..writeln('  onSelectedIndicesChanged: (Set<int> indices) {},');
      } else {
        args
          ..writeln('  selectedIndex: $_selectedIndex,')
          ..writeln('  onSelectedIndexChanged: (int? index) {},');
      }
    }
    args.writeln('  actions: const <M3EButtonGroupAction>[');
    for (int i = 0; i < _count; i++) {
      final String icon = 'Icon(M3EIcons.${_iconName(i)})';
      final String label = "Text('${_items[i].$2}')";
      args.writeln(switch (_contentMode) {
        _ActionContentMode.text => '    M3EButtonGroupAction(label: $label),',
        _ActionContentMode.textWithIcon =>
          '    M3EButtonGroupAction(icon: $icon, label: $label),',
        _ActionContentMode.icon =>
          "    M3EButtonGroupAction(icon: $icon, semanticLabel: "
              "'${_items[i].$2}'),",
      });
    }
    args.writeln('  ],');
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Button group',
        code: '$kPlaySnippetImport\n\nM3EButtonGroup(\n$args);',
      ),
    ];
  }

  static String _iconName(int index) => const <String>[
    'format_align_left',
    'format_align_center',
    'format_align_right',
    'format_align_justify',
    'calendar_today',
    'date_range',
    'event',
    'schedule',
  ][index];

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Group',
        children: <Widget>[
          PlayEnumChoice<M3EButtonGroupType>(
            label: 'Type',
            value: _type,
            values: M3EButtonGroupType.values,
            labelOf: (M3EButtonGroupType v) => v.name,
            onChanged: (M3EButtonGroupType v) => setState(() => _type = v),
          ),
          PlayEnumChoice<Axis>(
            label: 'Direction',
            value: _direction,
            values: Axis.values,
            labelOf: (Axis v) => v.name,
            onChanged: (Axis v) => setState(() => _direction = v),
          ),
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
          PlayEnumChoice<M3EButtonGroupDensity>(
            label: 'Density',
            value: _density,
            values: M3EButtonGroupDensity.values,
            labelOf: (M3EButtonGroupDensity v) => '${v.level}',
            onChanged: (M3EButtonGroupDensity v) =>
                setState(() => _density = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Actions',
        children: <Widget>[
          PlaySlider(
            label: 'Count',
            value: _actionCount,
            min: 2,
            max: _items.length.toDouble(),
            divisions: _items.length - 2,
            onChanged: (double v) => setState(() => _actionCount = v),
          ),
          PlayEnumChoice<_ActionContentMode>(
            label: 'Content',
            value: _contentMode,
            values: _ActionContentMode.values,
            labelOf: (_ActionContentMode v) => switch (v) {
              _ActionContentMode.text => 'text',
              _ActionContentMode.textWithIcon => 'text+icon',
              _ActionContentMode.icon => 'icon',
            },
            onChanged: (_ActionContentMode v) =>
                setState(() => _contentMode = v),
          ),
          if (_contentMode == _ActionContentMode.icon)
            PlayEnumChoice<_IconRestingWidth>(
              label: 'Middle icon width',
              value: _middleIconWidth,
              values: _IconRestingWidth.values,
              labelOf: (_IconRestingWidth v) => switch (v) {
                _IconRestingWidth.narrow => 'narrow',
                _IconRestingWidth.defaultWidth => 'default',
                _IconRestingWidth.wide => 'wide',
              },
              onChanged: (_IconRestingWidth v) =>
                  setState(() => _middleIconWidth = v),
            ),
        ],
      ),
      PlayControlGroup(
        title: 'Selection',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Selectable',
            description: 'Actions toggle a selection',
            value: _selectable,
            onChanged: (bool v) => setState(() => _selectable = v),
          ),
          if (_selectable) ...<Widget>[
            PlaySwitchItem(
              label: 'Multi-select',
              value: _multiSelect,
              onChanged: _setMultiSelect,
            ),
            PlaySwitchItem(
              label: 'Selection required',
              description: 'The last selected action cannot be cleared',
              value: _selectionRequired,
              onChanged: (bool v) => setState(() => _selectionRequired = v),
            ),
          ],
        ],
      ),
      PlayControlGroup(
        title: 'Motion',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Neighbor squish',
            description: 'Pressed action grows, neighbors shrink',
            value: _neighborSquish,
            onChanged: (bool v) => setState(() => _neighborSquish = v),
          ),
          if (_neighborSquish)
            PlaySlider(
              label: 'Expanded ratio',
              value: _expandedRatio,
              max: 0.5,
              onChanged: (double v) => setState(() => _expandedRatio = v),
            ),
          PlayEnumChoice<M3EHapticFeedback>(
            label: 'Haptic',
            value: _haptic,
            values: M3EHapticFeedback.values,
            labelOf: (M3EHapticFeedback v) => v.name,
            onChanged: (M3EHapticFeedback v) => setState(() => _haptic = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Overflow',
        children: <Widget>[
          PlayEnumChoice<M3EButtonGroupOverflow>(
            label: 'Overflow',
            value: _overflow,
            values: M3EButtonGroupOverflow.values,
            labelOf: (M3EButtonGroupOverflow v) => v.name,
            onChanged: (M3EButtonGroupOverflow v) =>
                setState(() => _overflow = v),
          ),
          if (_overflow == M3EButtonGroupOverflow.menu)
            PlayEnumChoice<M3EButtonGroupOverflowMenuStyle>(
              label: 'Menu style',
              value: _menuStyle,
              values: M3EButtonGroupOverflowMenuStyle.values,
              labelOf: (M3EButtonGroupOverflowMenuStyle v) => v.name,
              onChanged: (M3EButtonGroupOverflowMenuStyle v) =>
                  setState(() => _menuStyle = v),
            ),
          PlaySwitchItem(
            label: 'Constrain extent',
            description: 'Limit the space along the direction',
            value: _constrain,
            onChanged: (bool v) => setState(() => _constrain = v),
          ),
          if (_constrain)
            PlaySlider(
              label: 'Max extent',
              value: _maxExtent,
              min: 120,
              max: 600,
              divisions: 48,
              onChanged: (double v) => setState(() => _maxExtent = v),
            ),
        ],
      ),
    ];
  }
}
