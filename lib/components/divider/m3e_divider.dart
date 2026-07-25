import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_divider_axis.dart';

export 'enums/m3e_divider_axis.dart';
export 'styles/m3e_divider_theme.dart';

/// A Material 3 Expressive divider.
///
/// A thin line that groups content in lists and containers. Supports both
/// orientations and leading/trailing insets.
class M3EDivider extends StatelessWidget {
  /// M3EDivider.
  const M3EDivider({
    this.axis = M3EDividerAxis.horizontal,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    super.key,
  });

  /// axis.

  final M3EDividerAxis axis;

  /// thickness.
  final double thickness;

  /// indent.
  final double indent;

  /// endIndent.
  final double endIndent;

  /// color.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildDivider);
  }

  Widget _buildDivider(BuildContext context) {
    final dividerTheme = M3ETheme.of(context).dividerTheme;
    final Color line =
        color ?? dividerTheme.color(M3ETheme.of(context).colorScheme);
    final double lineThickness = thickness;
    if (axis == M3EDividerAxis.vertical) {
      return Padding(
        padding: EdgeInsets.only(top: indent, bottom: endIndent),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final double? height = constraints.hasBoundedHeight
                ? constraints.maxHeight
                : null;
            return SizedBox(
              width: lineThickness,
              height: height,
              child: ColoredBox(color: line),
            );
          },
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: indent, right: endIndent),
      child: SizedBox(
        height: lineThickness,
        width: double.infinity,
        child: ColoredBox(color: line),
      ),
    );
  }
}
