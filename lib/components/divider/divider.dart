import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_divider_axis.dart';
import 'styles/m3e_divider_tokens.dart';

export 'enums/m3e_divider_axis.dart';
export 'styles/m3e_divider_tokens.dart';

/// A Material 3 Expressive divider.
///
/// A thin line that groups content in lists and containers. Supports both
/// orientations and leading/trailing insets.
class M3EDivider extends StatelessWidget {
  const M3EDivider({
    this.axis = M3EDividerAxis.horizontal,
    this.thickness = M3EDividerTokens.thickness,
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
    final Color line =
        color ?? M3EDividerTokens.color(M3ETheme.of(context).colorScheme);
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
