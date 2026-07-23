import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_radio_theme.dart';

export 'styles/m3e_radio_theme.dart';

/// A Material 3 Expressive radio button.
///
/// Selecting one value from a set. The inner dot springs in when selected and
/// a 40dp state layer surrounds the 20dp ring.
///
/// When [label] is set, tapping the label also selects this value.
class M3ERadio<T> extends StatelessWidget {
  const M3ERadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.error = false,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    super.key,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;

  /// Optional text or widget beside the control; included in the tap target.
  final Widget? label;

  final bool error;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  bool get _enabled => onChanged != null;
  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ERadioTheme radioTheme = theme.radioTheme;
    final M3EColorScheme scheme = theme.colorScheme;

    return M3EComponentTheme(
      builder: (BuildContext context) => M3ETappable(
        onTap: _enabled ? () => onChanged!(value) : null,
        enabled: _enabled,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticLabel: semanticLabel,
        builder: (BuildContext context, M3EInteractionState state) {
          final Widget control = SizedBox(
            width: radioTheme.hitSize,
            height: radioTheme.hitSize,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _buildStateLayer(radioTheme, scheme, state),
                _buildRing(radioTheme, scheme),
              ],
            ),
          );

          if (label == null) {
            return control;
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              control,
              SizedBox(width: radioTheme.labelGap),
              DefaultTextStyle.merge(
                style: theme.typeScale.bodyLarge.copyWith(
                  color: _enabled
                      ? scheme.onSurface
                      : scheme.onSurface.withValues(
                          alpha: radioTheme.disabledOpacity,
                        ),
                ),
                child: label!,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStateLayer(
    M3ERadioTheme radioTheme,
    M3EColorScheme scheme,
    M3EInteractionState state,
  ) {
    final Color base =
        radioTheme.stateLayerColor(scheme, selected: _selected);
    return Container(
      width: radioTheme.hitSize,
      height: radioTheme.hitSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: base.withValues(alpha: state.opacity),
      ),
    );
  }

  Widget _buildRing(M3ERadioTheme radioTheme, M3EColorScheme scheme) {
    final Color color = radioTheme.color(
      scheme,
      enabled: _enabled,
      error: error,
      selected: _selected,
    );
    return Container(
      width: radioTheme.ringSize,
      height: radioTheme.ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: radioTheme.borderWidth),
      ),
      child: Center(
        child: AnimatedScale(
          scale: _selected ? 1 : 0,
          duration: M3EMotion.short4,
          curve: M3EMotion.emphasizedDecelerate,
          child: Container(
            width: radioTheme.dotSize,
            height: radioTheme.dotSize,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ),
    );
  }
}
