import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

/// A Material 3 Expressive checkbox.
///
/// Supports the binary and, when [tristate] is enabled, the indeterminate
/// state. A 40dp state layer surrounds the 18dp box, the container color and
/// check mark animate on change, and an [error] flavour is available.
class M3ECheckbox extends StatelessWidget {
  const M3ECheckbox({
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.error = false,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    super.key,
  }) : assert(
          tristate || value != null,
          'value may only be null when tristate is true.',
        );

  static const double _boxSize = 18;
  static const double _hitSize = 40;

  /// The current value. Null represents the indeterminate state.
  final bool? value;

  /// Called with the next value, or null to disable the checkbox.
  final ValueChanged<bool?>? onChanged;

  final bool tristate;
  final bool error;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  bool get _enabled => onChanged != null;

  void _handleTap() {
    switch (value) {
      case false:
        onChanged!(true);
      case true:
        onChanged!(tristate ? null : false);
      case null:
        onChanged!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    final bool checked = value ?? false;
    final bool active = value == null || checked;

    return M3ETappable(
      onTap: _enabled ? _handleTap : null,
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
              _buildStateLayer(scheme, state, active),
              _buildBox(scheme, active),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStateLayer(
    M3EColorScheme scheme,
    M3EInteractionState state,
    bool active,
  ) {
    final Color base = error
        ? scheme.error
        : active
            ? scheme.primary
            : scheme.onSurface;
    return Container(
      width: _hitSize,
      height: _hitSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: base.withValues(alpha: state.opacity),
      ),
    );
  }

  Widget _buildBox(M3EColorScheme scheme, bool active) {
    final Color fill = _resolveFill(scheme, active);
    final Color border = _resolveBorder(scheme, active);
    return AnimatedContainer(
      duration: M3EMotion.short3,
      curve: M3EMotion.standard,
      width: _boxSize,
      height: _boxSize,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: M3EShapes.radiusExtraSmall,
        border: Border.all(color: border, width: 2),
      ),
      child: _buildMark(scheme),
    );
  }

  Widget _buildMark(M3EColorScheme scheme) {
    if (value == null && tristate) {
      return Center(
        child: Container(
          width: 10,
          height: 2,
          color: error ? scheme.onError : scheme.onPrimary,
        ),
      );
    }
    if (value ?? false) {
      return Icon(
        M3EIcons.check,
        size: 16,
        color: error ? scheme.onError : scheme.onPrimary,
      );
    }
    return const SizedBox.shrink();
  }

  Color _resolveFill(M3EColorScheme scheme, bool active) {
    if (!_enabled) {
      return active
          ? M3EColorUtils.withOpacity(scheme.onSurface, 0.38)
          : const Color(0x00000000);
    }
    if (!active) {
      return const Color(0x00000000);
    }
    return error ? scheme.error : scheme.primary;
  }

  Color _resolveBorder(M3EColorScheme scheme, bool active) {
    if (!_enabled) {
      return M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    }
    if (active) {
      return error ? scheme.error : scheme.primary;
    }
    return error ? scheme.error : scheme.onSurfaceVariant;
  }
}
