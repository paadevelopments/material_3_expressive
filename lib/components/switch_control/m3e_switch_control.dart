import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_switch_theme.dart';

export 'styles/m3e_switch_theme.dart';

/// A Material 3 Expressive switch.
///
/// Toggles a single setting on or off. Thumb position/size use
/// [M3EMotion.expressiveSpatialDefault] (position with lower damping for a
/// visible overshoot snap). Track color crossfades linearly (~150ms).
class M3ESwitch extends StatefulWidget {
  const M3ESwitch({
    required this.value,
    required this.onChanged,
    this.selectedIcon,
    this.unselectedIcon,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    super.key,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget? selectedIcon;
  final Widget? unselectedIcon;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  @override
  State<M3ESwitch> createState() => _M3ESwitchState();
}

class _M3ESwitchState extends State<M3ESwitch> with TickerProviderStateMixin {
  late final SingleMotionController _positionCtrl;
  late final SingleMotionController _sizeCtrl;

  bool get _enabled => widget.onChanged != null;

  /// Position spring: expressiveSpatialDefault stiffness, lower damping so the
  /// thumb visibly overshoots the resting side (spec-like snap).
  SpringMotion get _positionMotion =>
      const MaterialSpringMotion.expressiveSpatialDefault()
          .copyWith(damping: 0.55);

  /// Size spring: same token, slightly more damped so size follows the slide.
  SpringMotion get _sizeMotion =>
      const MaterialSpringMotion.expressiveSpatialDefault()
          .copyWith(damping: 0.7);

  @override
  void initState() {
    super.initState();
    _positionCtrl = SingleMotionController(
      motion: _positionMotion,
      vsync: this,
      initialValue: widget.value ? 1.0 : 0.0,
    );
    _sizeCtrl = SingleMotionController(
      motion: _sizeMotion,
      vsync: this,
      // Small when off, large when on — icons must not force a large thumb.
      initialValue: widget.value ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant M3ESwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _positionCtrl.motion = _positionMotion;
      _sizeCtrl.motion = _sizeMotion;
      _positionCtrl.animateTo(widget.value ? 1.0 : 0.0);
      _sizeCtrl.animateTo(widget.value ? 1.0 : 0.0);
    }
  }

  @override
  void dispose() {
    _positionCtrl.dispose();
    _sizeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final switchTheme = theme.switchTheme;
    final scheme = theme.colorScheme;

    return M3EComponentTheme(
      builder: (BuildContext context) {
        return M3ETappable(
          onTap: _enabled ? () => widget.onChanged!(!widget.value) : null,
          enabled: _enabled,
          focusNode: widget.focusNode,
          autofocus: widget.autofocus,
          semanticLabel: widget.semanticLabel,
          builder: (BuildContext context, M3EInteractionState state) {
            // Track color: linear ~150ms crossfade (spec), not a spring.
            return AnimatedContainer(
              duration: M3EMotion.short3,
              curve: Curves.linear,
              width: switchTheme.trackWidth,
              height: switchTheme.trackHeight,
              padding: EdgeInsets.all(switchTheme.trackPadding),
              decoration: BoxDecoration(
                color: switchTheme.trackColor(
                  scheme,
                  enabled: _enabled,
                  value: widget.value,
                ),
                borderRadius: M3EShapes.resolve(switchTheme.trackHeight / 2),
                border: widget.value
                    ? null
                    : Border.all(
                        color: switchTheme.outlineColor(
                          scheme,
                          enabled: _enabled,
                        ),
                        width: switchTheme.borderWidth,
                      ),
              ),
              child: AnimatedBuilder(
                animation: Listenable.merge(
                  <Listenable>[_positionCtrl, _sizeCtrl],
                ),
                builder: (BuildContext context, Widget? child) {
                  return _buildThumb(switchTheme, scheme, state);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThumb(
    M3ESwitchTheme switchTheme,
    M3EColorScheme scheme,
    M3EInteractionState state,
  ) {
    final double size = state.pressed
        ? switchTheme.thumbSizePressed
        : (switchTheme.thumbSizeUnselected +
            (_sizeCtrl.value *
                (switchTheme.thumbSizeSelected -
                    switchTheme.thumbSizeUnselected)));

    // Layout by pixels so overshoot past 0/1 can leave the resting inset
    // (Align alone clips the snap against the padded track edge).
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final travel = (constraints.maxWidth - size).clamp(0.0, double.infinity);
        final left = travel * _positionCtrl.value;
        final top = (constraints.maxHeight - size) / 2;
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              left: left,
              top: top,
              width: size,
              height: size,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: switchTheme.thumbColor(
                    scheme,
                    enabled: _enabled,
                    value: widget.value,
                  ),
                ),
                child: _buildThumbIcon(switchTheme, scheme),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildThumbIcon(M3ESwitchTheme switchTheme, M3EColorScheme scheme) {
    final Widget? icon =
        widget.value ? widget.selectedIcon : widget.unselectedIcon;
    if (icon == null) {
      return const SizedBox.shrink();
    }
    // Fade/scale the glyph with thumb growth so it doesn't overflow the
    // small off thumb.
    final double t = _sizeCtrl.value.clamp(0.0, 1.0);
    return Opacity(
      opacity: t,
      child: Transform.scale(
        scale: 0.5 + (0.5 * t),
        child: Center(
          child: IconTheme.merge(
            data: IconThemeData(
              color: switchTheme.iconColor(scheme, value: widget.value),
              size: switchTheme.iconSize,
            ),
            child: icon,
          ),
        ),
      ),
    );
  }
}