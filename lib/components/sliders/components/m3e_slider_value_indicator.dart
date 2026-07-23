// Compose reference: androidx.compose.material3:material3:1.4.0-alpha01
// Value indicator (Label + PlainTooltip pattern)

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../styles/m3e_slider_theme.dart';

/// Floating value label shown while the slider handle is interacting.
class M3ESliderValueIndicator extends StatelessWidget {
  const M3ESliderValueIndicator({
    required this.label,
    required this.colors,
    super.key,
  });

  final String label;
  final M3ESliderColors colors;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = M3ETheme.of(context).typeScale.labelLarge.copyWith(
          color: colors.valueIndicatorLabel,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.valueIndicator,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(label, style: style),
      ),
    );
  }
}
