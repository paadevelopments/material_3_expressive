import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'components/m3e_slider_track_painter.dart';

/// A Material 3 Expressive slider.
///
/// Selects a single value from a continuous or, when [divisions] is set,
/// discrete range. Renders the expressive thick track with a gap around the
/// vertical handle and updates as the handle is dragged.
class M3ESlider extends StatelessWidget {
  const M3ESlider({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 1,
    this.divisions,
    super.key,
  }) : assert(max > min, 'max must be greater than min.');

  final double value;
  final ValueChanged<double>? onChanged;
  final double min;
  final double max;
  final int? divisions;

  bool get _enabled => onChanged != null;
  double get _fraction => ((value - min) / (max - min)).clamp(0, 1);

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: _enabled
              ? (DragUpdateDetails d) => _update(d.localPosition.dx, width)
              : null,
          onTapDown: _enabled
              ? (TapDownDetails d) => _update(d.localPosition.dx, width)
              : null,
          child: SizedBox(
            height: 44,
            width: width,
            child: CustomPaint(
              painter: M3ESliderTrackPainter(
                fraction: _fraction,
                activeColor: _color(scheme, scheme.primary),
                inactiveColor: _color(scheme, scheme.secondaryContainer),
                handleColor: _color(scheme, scheme.primary),
              ),
            ),
          ),
        );
      },
    );
  }

  void _update(double dx, double width) {
    if (width <= 0) {
      return;
    }
    final double fraction = (dx / width).clamp(0, 1);
    double next = min + fraction * (max - min);
    if (divisions != null && divisions! > 0) {
      final double step = (max - min) / divisions!;
      next = min + (((next - min) / step).round()) * step;
    }
    onChanged!(next);
  }

  Color _color(M3EColorScheme scheme, Color enabledColor) {
    if (!_enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    return enabledColor;
  }
}
