import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_checkbox_theme.dart';

export 'styles/m3e_checkbox_theme.dart';

/// A Material 3 Expressive checkbox.
///
/// Supports the binary and, when [tristate] is enabled, the indeterminate
/// state. A state layer surrounds the box, the container color and check mark
/// animate on change, and an [error] flavour is available.
///
/// When [label] is set, tapping the label also toggles this checkbox.
class M3ECheckbox extends StatefulWidget {
  /// M3ECheckbox.
  const M3ECheckbox({
    required this.value,
    required this.onChanged,
    this.tristate = false,
    this.error = false,
    this.label,
    this.boxSize,
    this.hitSize,
    this.checkedChild,
    this.uncheckedChild,
    this.checkIconPadding,
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

  /// tristate.
  final bool tristate;

  /// error.
  final bool error;

  /// Optional text or widget beside the control; included in the tap target.
  final Widget? label;

  /// Checkbox box size. Defaults to [M3ECheckboxTheme.boxSize].
  final double? boxSize;

  /// Circular state-layer / highlight size. Defaults to [M3ECheckboxTheme.hitSize].
  final double? hitSize;

  /// Custom widget for the checked state. Replaces the default filled box + check.
  final Widget? checkedChild;

  /// Custom widget for the unchecked state. Replaces the default empty box.
  final Widget? uncheckedChild;

  /// Extra padding around the default check icon only (checked state).
  ///
  /// Does not apply to [checkedChild], indeterminate, or unchecked. Defaults to
  /// a slight right inset for optical centering.
  final EdgeInsetsGeometry? checkIconPadding;

  /// focusNode.
  final FocusNode? focusNode;

  /// autofocus.
  final bool autofocus;

  /// semanticLabel.
  final String? semanticLabel;

  @override
  State<M3ECheckbox> createState() => _M3ECheckboxState();
}

class _M3ECheckboxState extends State<M3ECheckbox>
    with SingleTickerProviderStateMixin {
  static const double _pulseScale = 0.88;

  late final AnimationController _scaleController;

  bool get _enabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController.unbounded(vsync: this, value: 1);
  }

  @override
  void didUpdateWidget(M3ECheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _pulse();
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _pulse() {
    _scaleController.value = _pulseScale;
    _scaleController.animateWith(
      SpringSimulation(
        M3EMotion.expressiveSpatialDefault.toDescription(),
        _scaleController.value,
        1,
        _scaleController.velocity,
      ),
    );
  }

  void _handleTap() {
    switch (widget.value) {
      case false:
        widget.onChanged!(true);
      case true:
        widget.onChanged!(widget.tristate ? null : false);
      case null:
        widget.onChanged!(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ECheckboxTheme checkboxTheme = theme.checkboxTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    final double boxSize = widget.boxSize ?? checkboxTheme.boxSize;
    final double hitSize = widget.hitSize ?? checkboxTheme.hitSize;
    final double sizeScale = boxSize / checkboxTheme.boxSize;
    final bool checked = widget.value ?? false;
    final bool active = widget.value == null || checked;

    return M3EComponentTheme(
      builder: (BuildContext context) => M3ETappable(
        onTap: _enabled ? _handleTap : null,
        enabled: _enabled,
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        semanticLabel: widget.semanticLabel,
        builder: (BuildContext context, M3EInteractionState state) {
          final Widget control = SizedBox(
            width: hitSize,
            height: hitSize,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _buildStateLayer(checkboxTheme, scheme, state, active, hitSize),
                AnimatedBuilder(
                  animation: _scaleController,
                  builder: (BuildContext context, Widget? child) {
                    return Transform.scale(
                      scale: _scaleController.value,
                      child: child,
                    );
                  },
                  child: _buildBox(
                    checkboxTheme,
                    scheme,
                    active: active,
                    boxSize: boxSize,
                    sizeScale: sizeScale,
                  ),
                ),
              ],
            ),
          );

          if (widget.label == null) {
            return control;
          }

          return Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              control,
              SizedBox(width: checkboxTheme.labelGap),
              DefaultTextStyle.merge(
                style: theme.typeScale.bodyLarge.copyWith(
                  color: _enabled
                      ? scheme.onSurface
                      : scheme.onSurface.withValues(
                          alpha: checkboxTheme.disabledOpacity,
                        ),
                ),
                child: widget.label!,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStateLayer(
    M3ECheckboxTheme checkboxTheme,
    M3EColorScheme scheme,
    M3EInteractionState state,
    bool active,
    double hitSize,
  ) {
    final Color base = checkboxTheme.stateLayerColor(
      scheme,
      active: active,
      error: widget.error,
    );
    return Container(
      width: hitSize,
      height: hitSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: base.withValues(alpha: state.opacity),
      ),
    );
  }

  Widget _buildBox(
    M3ECheckboxTheme checkboxTheme,
    M3EColorScheme scheme, {
    required bool active,
    required double boxSize,
    required double sizeScale,
  }) {
    // Custom children fully replace the default box for checked/unchecked.
    if ((widget.value ?? false) && widget.checkedChild != null) {
      return SizedBox(
        width: boxSize,
        height: boxSize,
        child: widget.checkedChild,
      );
    }
    if (widget.value == false && widget.uncheckedChild != null) {
      return SizedBox(
        width: boxSize,
        height: boxSize,
        child: widget.uncheckedChild,
      );
    }

    final Color fill = checkboxTheme.fillColor(
      scheme,
      enabled: _enabled,
      active: active,
      error: widget.error,
    );
    final Color border = checkboxTheme.borderColor(
      scheme,
      enabled: _enabled,
      active: active,
      error: widget.error,
    );
    return AnimatedContainer(
      duration: M3EMotion.short3,
      curve: M3EMotion.standard,
      alignment: Alignment.center,
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: checkboxTheme.borderRadius,
        border: Border.all(
          color: border,
          width: checkboxTheme.borderWidth * sizeScale.clamp(0.5, 2),
        ),
      ),
      child: _buildMark(checkboxTheme, scheme, sizeScale),
    );
  }

  Widget _buildMark(
    M3ECheckboxTheme checkboxTheme,
    M3EColorScheme scheme,
    double sizeScale,
  ) {
    final Color color = checkboxTheme.markColor(scheme, error: widget.error);
    if (widget.value == null && widget.tristate) {
      return Center(
        child: Container(
          width: checkboxTheme.indeterminateWidth * sizeScale,
          height: checkboxTheme.indeterminateHeight * sizeScale,
          color: color,
        ),
      );
    }
    if (widget.value ?? false) {
      return Padding(
        padding: widget.checkIconPadding ?? checkboxTheme.checkIconPadding,
        child: Icon(
          M3EIcons.check,
          size: checkboxTheme.markSize * sizeScale,
          color: color,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
