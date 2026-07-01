import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

/// The color emphasis of a floating toolbar.
enum M3EToolbarColor {
  /// Standard surface container background.
  standard,

  /// Vibrant primary-container background.
  vibrant,
}

/// A Material 3 Expressive floating toolbar.
///
/// A pill-shaped, elevated surface hosting frequently used actions. It can be
/// laid out horizontally or vertically and floats above content.
class M3EToolbar extends StatelessWidget {
  const M3EToolbar({
    required this.children,
    this.axis = Axis.horizontal,
    this.color = M3EToolbarColor.standard,
    super.key,
  });

  final List<Widget> children;
  final Axis axis;
  final M3EToolbarColor color;

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    final vibrant = color == M3EToolbarColor.vibrant;
    final Color background =
        vibrant ? scheme.primaryContainer : scheme.surfaceContainer;
    final Color foreground =
        vibrant ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: ShapeDecoration(
        shape: M3EShapes.stadium,
        color: background,
        shadows: M3EElevation.shadows(
          M3EElevation.level2,
          shadowColor: scheme.shadow,
        ),
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: foreground, size: 24),
        child: Flex(
          direction: axis,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}
