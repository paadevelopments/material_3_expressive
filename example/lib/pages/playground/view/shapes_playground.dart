import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/controls/play_enum_choice.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/playground.dart';

/// Container color roles offered by the playground.
enum _ShapeColor { primary, secondary, tertiary, gradient }

/// Live playground for [M3EShapeContainer] and [M3EShapeKind].
class ShapesPlayground extends PlaygroundWidget {
  /// Creates the shapes playground.
  const ShapesPlayground({super.key});

  @override
  PlaygroundState<ShapesPlayground> createState() => _ShapesPlaygroundState();
}

class _ShapesPlaygroundState extends PlaygroundState<ShapesPlayground> {
  M3EShapeKind _kind = M3EShapeKind.cookie4Sided;
  _ShapeColor _color = _ShapeColor.primary;
  double _width = 160;
  double _height = 160;
  bool _lockAspect = true;
  bool _child = true;

  static const LinearGradient _gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFF6750A4), Color(0xFF4ECDC4)],
  );

  (Color?, Color) _colors(M3EColorScheme scheme) => switch (_color) {
    _ShapeColor.primary => (scheme.primaryContainer, scheme.onPrimaryContainer),
    _ShapeColor.secondary => (
      scheme.secondaryContainer,
      scheme.onSecondaryContainer,
    ),
    _ShapeColor.tertiary => (
      scheme.tertiaryContainer,
      scheme.onTertiaryContainer,
    ),
    _ShapeColor.gradient => (null, const Color(0xFFFFFFFF)),
  };

  @override
  Widget buildPreview(BuildContext context) {
    final (Color? fill, Color onFill) = _colors(
      M3ETheme.of(context).colorScheme,
    );
    return M3EShapeContainer(
      kind: _kind,
      width: _width,
      height: _lockAspect ? _width : _height,
      color: fill,
      gradient: _color == _ShapeColor.gradient ? _gradient : null,
      child: _child
          ? Center(
              child: Icon(M3EIcons.favorite, color: onFill, size: _width / 4),
            )
          : null,
    );
  }

  @override
  List<PlaySnippet> get snippets {
    final String fill = switch (_color) {
      _ShapeColor.gradient => '  gradient: const LinearGradient(...),',
      _ => '  color: scheme.${_color.name}Container,',
    };
    final String child = _child
        ? '\n  child: Center(\n'
              '    child: Icon(M3EIcons.favorite, '
              'color: scheme.on${_color.name[0].toUpperCase()}'
              '${_color.name.substring(1)}Container),\n'
              '  ),'
        : '';
    final double height = _lockAspect ? _width : _height;
    return <PlaySnippet>[
      PlaySnippet(
        label: 'Shape container',
        code:
            '''
$kPlaySnippetImport

M3EShapeContainer(
  kind: M3EShapeKind.${_kind.name},
  width: ${_width.round()},
  height: ${height.round()},
$fill$child
);''',
      ),
    ];
  }

  @override
  List<Widget> buildControls(BuildContext context) {
    return <Widget>[
      PlayControlGroup(
        title: 'Shape',
        children: <Widget>[
          PlayEnumChoice<M3EShapeKind>(
            label: 'Kind',
            value: _kind,
            values: M3EShapeKind.all,
            labelOf: (M3EShapeKind v) => v.name,
            onChanged: (M3EShapeKind v) => setState(() => _kind = v),
          ),
          PlayEnumChoice<_ShapeColor>(
            label: 'Fill',
            value: _color,
            values: _ShapeColor.values,
            labelOf: (_ShapeColor v) => switch (v) {
              _ShapeColor.gradient => 'gradient',
              _ => '${v.name} container',
            },
            onChanged: (_ShapeColor v) => setState(() => _color = v),
          ),
          PlaySwitchItem(
            label: 'Clipped child',
            description: 'An icon clipped to the shape',
            value: _child,
            onChanged: (bool v) => setState(() => _child = v),
          ),
        ],
      ),
      PlayControlGroup(
        title: 'Size',
        children: <Widget>[
          PlaySwitchItem(
            label: 'Square aspect',
            description: 'Height follows width',
            value: _lockAspect,
            onChanged: (bool v) => setState(() => _lockAspect = v),
          ),
          PlaySlider(
            label: 'Width',
            value: _width,
            min: 48,
            max: 280,
            divisions: 29,
            onChanged: (double v) => setState(() => _width = v),
          ),
          if (!_lockAspect)
            PlaySlider(
              label: 'Height',
              value: _height,
              min: 48,
              max: 280,
              divisions: 29,
              onChanged: (double v) => setState(() => _height = v),
            ),
        ],
      ),
    ];
  }
}
