import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

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

  static const double _ringSize = 20;
  static const double _hitSize = 40;

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
          width: _hitSize,
          height: _hitSize,
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
    final Color base = _selected ? scheme.primary : scheme.onSurface;
    return Container(
      width: _hitSize,
      height: _hitSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: base.withValues(alpha: state.opacity),
      ),
    );
  }

  Widget _buildRing(M3EColorScheme scheme) {
    final Color color = _resolveColor(scheme);
    return Container(
      width: _ringSize,
      height: _ringSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: AnimatedScale(
          scale: _selected ? 1 : 0,
          duration: M3EMotion.short4,
          curve: M3EMotion.emphasizedDecelerate,
          child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
        ),
      ),
    );
  }

  Color _resolveColor(M3EColorScheme scheme) {
    if (!_enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    if (error) {
      return scheme.error;
    }
    return _selected ? scheme.primary : scheme.onSurfaceVariant;
  }
}
