import 'package:flutter/material.dart' show Colors;
import 'package:flutter/widgets.dart';

import 'm3e_state_layer.dart';
import 'm3e_theme.dart';

/// Supplies expressive splash color for Material buttons that only expose
/// overlay color to their ink layer.
///
/// Pressed feedback is splash-only; hover/focus use hover/focus overlays.
class M3EInkSplashTheme extends StatelessWidget {
  const M3EInkSplashTheme({
    required this.color,
    required this.child,
    super.key,
  });

  /// Role color used to derive the pressed ripple.
  final Color color;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return M3ETheme(
      data: M3ETheme.of(context).copyWith(
        splashColor: M3EStateLayer.splashColor(color),
        highlightColor: Colors.transparent,
      ),
      child: child,
    );
  }
}
