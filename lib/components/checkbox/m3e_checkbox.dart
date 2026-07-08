import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_checkbox_theme.dart';

export 'styles/m3e_checkbox_theme.dart';

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
    final theme = M3ETheme.of(context);
    final checkboxTheme = theme.checkboxTheme;
    final scheme = theme.colorScheme;
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
          width: checkboxTheme.hitSize,
          height: checkboxTheme.hitSize,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildStateLayer(checkboxTheme, scheme, state, active),
              _buildBox(checkboxTheme, scheme, active),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStateLayer(
    M3ECheckboxTheme checkboxTheme,
    M3EColorScheme scheme,
    M3EInteractionState state,
    bool active,
  ) {
    final Color base = checkboxTheme.stateLayerColor(
      scheme,
      active: active,
      error: error,
    );
    return Container(
      width: checkboxTheme.hitSize,
      height: checkboxTheme.hitSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: base.withValues(alpha: state.opacity),
      ),
    );
  }

  Widget _buildBox(
    M3ECheckboxTheme checkboxTheme,
    M3EColorScheme scheme,
    bool active,
  ) {
    final Color fill = checkboxTheme.fillColor(
      scheme,
      enabled: _enabled,
      active: active,
      error: error,
    );
    final Color border = checkboxTheme.borderColor(
      scheme,
      enabled: _enabled,
      active: active,
      error: error,
    );
    return AnimatedContainer(
      duration: M3EMotion.short3,
      curve: M3EMotion.standard,
      width: checkboxTheme.boxSize,
      height: checkboxTheme.boxSize,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: checkboxTheme.borderRadius,
        border: Border.all(
          color: border,
          width: checkboxTheme.borderWidth,
        ),
      ),
      child: _buildMark(checkboxTheme, scheme),
    );
  }

  Widget _buildMark(M3ECheckboxTheme checkboxTheme, M3EColorScheme scheme) {
    final Color color = checkboxTheme.markColor(scheme, error: error);
    if (value == null && tristate) {
      return Center(
        child: Container(
          width: checkboxTheme.indeterminateWidth,
          height: checkboxTheme.indeterminateHeight,
          color: color,
        ),
      );
    }
    if (value ?? false) {
      return Icon(
        M3EIcons.check,
        size: checkboxTheme.markSize,
        color: color,
      );
    }
    return const SizedBox.shrink();
  }
}
