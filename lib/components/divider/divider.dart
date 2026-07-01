import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

/// The orientation of an [M3EDivider].
enum M3EDividerAxis {
  horizontal,
  vertical,
}

/// A Material 3 Expressive divider.
///
/// A thin line that groups content in lists and containers. Supports both
/// orientations and leading/trailing insets.
class M3EDivider extends StatelessWidget {
  const M3EDivider({
    this.axis = M3EDividerAxis.horizontal,
    this.thickness = 1,
    this.indent = 0,
    this.endIndent = 0,
    this.color,
    super.key,
  });

  final M3EDividerAxis axis;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color line = color ?? M3ETheme.of(context).colorScheme.outlineVariant;
    if (axis == M3EDividerAxis.vertical) {
      return Padding(
        padding: EdgeInsets.only(top: indent, bottom: endIndent),
        child: SizedBox(
          width: thickness,
          child: ColoredBox(color: line),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: indent, right: endIndent),
      child: SizedBox(
        height: thickness,
        child: ColoredBox(color: line),
      ),
    );
  }
}
