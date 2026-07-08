import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_radio_tokens.dart';

export 'styles/m3e_radio_tokens.dart';

/// A Material 3 Expressive radio button.
///
/// Selecting one value from a set. The inner dot springs in when selected and
/// a 40dp state layer surrounds the 20dp ring.
class M3ERadio<T> extends StatelessWidget {
  const M3ERadio({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.error = false,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    super.key,
  });

  final T value;
  final T? groupValue;
  final ValueChanged<T>? onChanged;
  final bool error;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  bool get _enabled => onChanged != null;
  bool get _selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;

    return M3ETappable(
      onTap: _enabled ? () => onChanged!(value) : null,
      enabled: _enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      builder: (BuildContext context, M3EInteractionState state) {
        return SizedBox(
          width: M3ERadioTokens.hitSize,
          height: M3ERadioTokens.hitSize,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildStateLayer(scheme, state),
              _buildRing(scheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStateLayer(M3EColorScheme scheme, M3EInteractionState state) {
    final Color base =
        M3ERadioTokens.stateLayerColor(scheme, selected: _selected);
    return Container(
      width: M3ERadioTokens.hitSize,
      height: M3ERadioTokens.hitSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: base.withValues(alpha: state.opacity),
      ),
    );
  }

  Widget _buildRing(M3EColorScheme scheme) {
    final Color color = M3ERadioTokens.color(
      scheme,
      enabled: _enabled,
      error: error,
      selected: _selected,
    );
    return Container(
      width: M3ERadioTokens.ringSize,
      height: M3ERadioTokens.ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: M3ERadioTokens.borderWidth),
      ),
      child: Center(
        child: AnimatedScale(
          scale: _selected ? 1 : 0,
          duration: M3EMotion.short4,
          curve: M3EMotion.emphasizedDecelerate,
          child: Container(
            width: M3ERadioTokens.dotSize,
            height: M3ERadioTokens.dotSize,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ),
    );
  }
}
