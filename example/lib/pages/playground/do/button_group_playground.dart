import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// How demo actions are composed in the button group playground.
enum _ActionContentMode { textOnly, textWithIcon, iconOnly }

/// Icon-only resting width preset applied to the *middle* action only.
enum _IconRestingWidth { narrow, defaultWidth, wide }

/// Live playground for [M3EButtonGroup].
class ButtonGroupPlayground extends StatefulWidget {
  /// Creates the button group playground.
  const ButtonGroupPlayground({super.key});

  @override
  State<ButtonGroupPlayground> createState() => _ButtonGroupPlaygroundState();
}

class _ButtonGroupPlaygroundState extends State<ButtonGroupPlayground> {
  M3EButtonGroupType _type = M3EButtonGroupType.standard;
  M3EButtonShape _shape = M3EButtonShape.round;
  M3EButtonSize _size = M3EButtonSize.sm;
  M3EButtonStyle _style = M3EButtonStyle.filled;
  M3EButtonGroupDensity _density = M3EButtonGroupDensity.regular;
  bool _neighborSquish = true;
  bool _multiSelect = false;
  bool _selectionRequired = true;
  int? _selectedIndex = 0;
  Set<int> _selectedIndices = <int>{0};
  _ActionContentMode _contentMode = _ActionContentMode.textWithIcon;
  _IconRestingWidth _middleIconWidth = _IconRestingWidth.defaultWidth;

  static const List<M3EButtonSize> _sizes = <M3EButtonSize>[
    M3EButtonSize.xs,
    M3EButtonSize.sm,
    M3EButtonSize.md,
    M3EButtonSize.lg,
    M3EButtonSize.xl,
  ];

  M3EIconButtonSize get _iconSizeForGroup => switch (_size) {
    M3EButtonSize.xs => M3EIconButtonSize.xs,
    M3EButtonSize.sm => M3EIconButtonSize.sm,
    M3EButtonSize.md => M3EIconButtonSize.md,
    M3EButtonSize.lg => M3EIconButtonSize.lg,
    M3EButtonSize.xl => M3EIconButtonSize.xl,
    _ => M3EIconButtonSize.md,
  };

  double _iconWidthFor(BuildContext context, M3EIconButtonWidth widthToken) {
    return M3ETheme.of(
      context,
    ).iconButtonTheme.visual(_iconSizeForGroup, widthToken).width;
  }

  /// Mixed resting widths: first=narrow, middle=control, last=wide.
  ({double first, double middle, double last}) _mixedIconMinWidths(
    BuildContext context,
  ) {
    final middleToken = switch (_middleIconWidth) {
      _IconRestingWidth.narrow => M3EIconButtonWidth.narrow,
      _IconRestingWidth.defaultWidth => M3EIconButtonWidth.defaultWidth,
      _IconRestingWidth.wide => M3EIconButtonWidth.wide,
    };
    return (
      first: _iconWidthFor(context, M3EIconButtonWidth.narrow),
      middle: _iconWidthFor(context, middleToken),
      last: _iconWidthFor(context, M3EIconButtonWidth.wide),
    );
  }

  double _betweenSpace(BuildContext context) {
    final theme = M3ETheme.of(context).buttonGroupTheme;
    return theme
        .metricsFor(
          _size,
          _density,
          isConnected: _type == M3EButtonGroupType.connected,
        )
        .spacing;
  }

  double _containerHeight(BuildContext context) {
    return M3ETheme.of(
      context,
    ).buttonGroupTheme.containerHeightFor(_size, density: _density);
  }

  List<M3EButtonGroupAction> _actions(BuildContext context) {
    switch (_contentMode) {
      case _ActionContentMode.textOnly:
        return const <M3EButtonGroupAction>[
          M3EButtonGroupAction(label: Text('Left')),
          M3EButtonGroupAction(label: Text('Center')),
          M3EButtonGroupAction(label: Text('Right')),
        ];
      case _ActionContentMode.textWithIcon:
        return const <M3EButtonGroupAction>[
          M3EButtonGroupAction(
            icon: Icon(M3EIcons.format_align_left),
            label: Text('Left'),
          ),
          M3EButtonGroupAction(
            icon: Icon(M3EIcons.format_align_center),
            label: Text('Center'),
          ),
          M3EButtonGroupAction(
            icon: Icon(M3EIcons.format_align_right),
            label: Text('Right'),
          ),
        ];
      case _ActionContentMode.iconOnly:
        final widths = _mixedIconMinWidths(context);
        return <M3EButtonGroupAction>[
          M3EButtonGroupAction(
            icon: const Icon(M3EIcons.format_align_left),
            semanticLabel: 'Align left',
            minWidth: widths.first,
          ),
          M3EButtonGroupAction(
            icon: const Icon(M3EIcons.format_align_center),
            semanticLabel: 'Align center',
            minWidth: widths.middle,
          ),
          M3EButtonGroupAction(
            icon: const Icon(M3EIcons.format_align_right),
            semanticLabel: 'Align right',
            minWidth: widths.last,
          ),
        ];
    }
  }

  List<M3EButtonGroupAction> _scrollOverflowActions(BuildContext context) {
    switch (_contentMode) {
      case _ActionContentMode.textOnly:
        return const <M3EButtonGroupAction>[
          M3EButtonGroupAction(label: Text('Every day')),
          M3EButtonGroupAction(label: Text('Days per week')),
          M3EButtonGroupAction(label: Text('Selected days')),
          M3EButtonGroupAction(label: Text('Custom')),
          M3EButtonGroupAction(label: Text('Interval')),
        ];
      case _ActionContentMode.textWithIcon:
        return const <M3EButtonGroupAction>[
          M3EButtonGroupAction(
            icon: Icon(M3EIcons.calendar_today),
            label: Text('Every day'),
          ),
          M3EButtonGroupAction(
            icon: Icon(M3EIcons.date_range),
            label: Text('Days per week'),
          ),
          M3EButtonGroupAction(
            icon: Icon(M3EIcons.event),
            label: Text('Selected days'),
          ),
          M3EButtonGroupAction(
            icon: Icon(M3EIcons.tune),
            label: Text('Custom'),
          ),
          M3EButtonGroupAction(
            icon: Icon(M3EIcons.schedule),
            label: Text('Interval'),
          ),
        ];
      case _ActionContentMode.iconOnly:
        final widths = _mixedIconMinWidths(context);
        // Vary minWidth on a subset: first narrow, third = control, fifth wide.
        return <M3EButtonGroupAction>[
          M3EButtonGroupAction(
            icon: const Icon(M3EIcons.calendar_today),
            semanticLabel: 'Every day',
            minWidth: widths.first,
          ),
          M3EButtonGroupAction(
            icon: const Icon(M3EIcons.date_range),
            semanticLabel: 'Days per week',
          ),
          M3EButtonGroupAction(
            icon: const Icon(M3EIcons.event),
            semanticLabel: 'Selected days',
            minWidth: widths.middle,
          ),
          M3EButtonGroupAction(
            icon: const Icon(M3EIcons.tune),
            semanticLabel: 'Custom',
          ),
          M3EButtonGroupAction(
            icon: const Icon(M3EIcons.schedule),
            semanticLabel: 'Interval',
            minWidth: widths.last,
          ),
        ];
    }
  }

  String get _contentModeLabel => switch (_contentMode) {
    _ActionContentMode.textOnly => 'text only',
    _ActionContentMode.textWithIcon => 'text + icon',
    _ActionContentMode.iconOnly => 'icon only',
  };

  String get _densityLabel => switch (_density) {
    M3EButtonGroupDensity.regular => '0',
    M3EButtonGroupDensity.comfortable => '−1',
    M3EButtonGroupDensity.compact => '−2',
    M3EButtonGroupDensity.dense => '−3',
  };

  List<PlaySnippet> get _snippets {
    final selectionSnippet = _multiSelect
        ? '''
  multiSelect: true,
  selectionRequired: $_selectionRequired,
  selectedIndices: <int>{${_selectedIndices.join(', ')}},
  onSelectedIndicesChanged: (Set<int> indices) {},'''
        : '''
  multiSelect: false,
  selectionRequired: $_selectionRequired,
  selectedIndex: $_selectedIndex,
  onSelectedIndexChanged: (int? index) {},''';
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Button group',
        code:
            '''
$kPlaySnippetImport
M3EButtonGroup(
  type: M3EButtonGroupType.${_type.name},
  shape: M3EButtonShape.${_shape.name},
  size: M3EButtonSize.${_size.name},
  style: M3EButtonStyle.${_style.name},
  density: M3EButtonGroupDensity.${_density.name},
  neighborSquish: $_neighborSquish,$selectionSnippet
  // $_contentModeLabel
  actions: const <M3EButtonGroupAction>[
    ...
  ],
);''',
      ),
    ];
  }

  Widget _groupPreview({
    required List<M3EButtonGroupAction> actions,
    M3EButtonGroupOverflow overflow = M3EButtonGroupOverflow.none,
  }) {
    return M3EButtonGroup(
      type: _type,
      shape: _shape,
      size: _size,
      style: _style,
      density: _density,
      neighborSquish: _neighborSquish,
      multiSelect: _multiSelect,
      selectionRequired: _selectionRequired,
      overflow: overflow,
      selectedIndex: _multiSelect ? null : _selectedIndex,
      onSelectedIndexChanged: _multiSelect
          ? null
          : (int? index) {
              setState(() => _selectedIndex = index);
            },
      selectedIndices: _multiSelect ? _selectedIndices : null,
      onSelectedIndicesChanged: _multiSelect
          ? (Set<int> indices) {
              setState(() => _selectedIndices = indices);
            }
          : null,
      actions: actions,
    );
  }

  @override
  Widget build(BuildContext context) {
    final between = _betweenSpace(context);
    final height = _containerHeight(context);
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Scroll overflow',
          child: SizedBox(
            width: 220,
            child: _groupPreview(
              actions: _scrollOverflowActions(context),
              overflow: M3EButtonGroupOverflow.scroll,
            ),
          ),
        ),
        PlayPreviewCard(
          label:
              'Button group · height ${height.toStringAsFixed(0)}dp · '
              'gap ${between.toStringAsFixed(0)}dp',
          child: _groupPreview(actions: _actions(context)),
        ),
      ],
      snippets: _snippets,
      controls: <Widget>[
        PlayControlPanel(
          title: 'Group',
          children: <Widget>[
            PlayEnumSegmented<M3EButtonGroupType>(
              label: 'Type',
              value: _type,
              values: M3EButtonGroupType.values,
              labelOf: (M3EButtonGroupType v) => v.name,
              onChanged: (M3EButtonGroupType v) => setState(() => _type = v),
            ),
            PlayEnumSegmented<M3EButtonShape>(
              label: 'Shape',
              value: _shape,
              values: M3EButtonShape.values,
              labelOf: (M3EButtonShape v) => v.name,
              onChanged: (M3EButtonShape v) => setState(() => _shape = v),
            ),
            PlayEnumMenu<M3EButtonSize>(
              label: 'Size',
              value: _size,
              values: _sizes,
              labelOf: (M3EButtonSize v) => v.name,
              onChanged: (M3EButtonSize v) => setState(() => _size = v),
            ),
            PlayEnumSegmented<M3EButtonGroupDensity>(
              label: 'Density ($_densityLabel)',
              value: _density,
              values: M3EButtonGroupDensity.values,
              labelOf: (M3EButtonGroupDensity v) => switch (v) {
                M3EButtonGroupDensity.regular => '0',
                M3EButtonGroupDensity.comfortable => '−1',
                M3EButtonGroupDensity.compact => '−2',
                M3EButtonGroupDensity.dense => '−3',
              },
              onChanged: (M3EButtonGroupDensity v) =>
                  setState(() => _density = v),
            ),
            PlayEnumMenu<M3EButtonStyle>(
              label: 'Style',
              value: _style,
              values: M3EButtonStyle.values,
              labelOf: (M3EButtonStyle v) => v.name,
              onChanged: (M3EButtonStyle v) => setState(() => _style = v),
            ),
            PlayEnumSegmented<_ActionContentMode>(
              label: 'Actions',
              value: _contentMode,
              values: _ActionContentMode.values,
              labelOf: (mode) => switch (mode) {
                _ActionContentMode.textOnly => 'text',
                _ActionContentMode.textWithIcon => 'text+icon',
                _ActionContentMode.iconOnly => 'icon',
              },
              onChanged: (mode) => setState(() => _contentMode = mode),
            ),
            if (_contentMode == _ActionContentMode.iconOnly)
              PlayEnumSegmented<_IconRestingWidth>(
                label: 'Middle icon width',
                value: _middleIconWidth,
                values: _IconRestingWidth.values,
                labelOf: (mode) => switch (mode) {
                  _IconRestingWidth.narrow => 'narrow',
                  _IconRestingWidth.defaultWidth => 'default',
                  _IconRestingWidth.wide => 'wide',
                },
                onChanged: (mode) => setState(() => _middleIconWidth = mode),
              ),
            PlaySwitch(
              label: 'Neighbor squish',
              value: _neighborSquish,
              onChanged: (bool v) => setState(() => _neighborSquish = v),
            ),
            PlaySwitch(
              label: 'Multi-select',
              value: _multiSelect,
              onChanged: (bool v) => setState(() {
                _multiSelect = v;
                if (v) {
                  _selectedIndices = _selectedIndex != null
                      ? <int>{_selectedIndex!}
                      : <int>{};
                } else {
                  _selectedIndex = _selectedIndices.isEmpty
                      ? null
                      : _selectedIndices.first;
                }
              }),
            ),
            PlaySwitch(
              label: 'Selection required',
              value: _selectionRequired,
              onChanged: (bool v) => setState(() => _selectionRequired = v),
            ),
          ],
        ),
      ],
    );
  }
}
