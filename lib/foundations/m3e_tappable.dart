import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import 'm3e_motion.dart';
import 'm3e_state_layer.dart';
import 'm3e_tappable_ink_scope.dart';

/// Builds the visual for a tappable surface given its interaction [state].
typedef M3EStateWidgetBuilder = Widget Function(
  BuildContext context,
  M3EInteractionState state,
);

/// A reusable interaction primitive powering expressive components.
///
/// It tracks hover, focus and press states, exposes them to [builder], drives
/// an optional spring based press scale, and wires up keyboard activation and
/// semantics so components stay focused on their own visuals.
class M3ETappable extends StatefulWidget {
  const M3ETappable({
    required this.builder,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor,
    this.semanticLabel,
    this.semanticButton = true,
    this.excludeSemantics = false,
    this.pressedScale = 1,
    this.spring = M3EMotion.expressiveSpatialFast,
    this.onStateChanged,
    this.materialInk = false,
    super.key,
  });

  final M3EStateWidgetBuilder builder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final MouseCursor? mouseCursor;
  final String? semanticLabel;
  final bool semanticButton;
  final bool excludeSemantics;

  /// Scale applied while pressed. `1.0` disables the press scale animation.
  final double pressedScale;

  /// Spring used to animate the press scale in and out.
  final M3ESpring spring;

  /// Notified whenever the resolved interaction state changes.
  final ValueChanged<M3EInteractionState>? onStateChanged;

  /// When true, gestures are handled by the overlay ink well.
  final bool materialInk;

  bool get _isInteractive =>
      enabled && (onTap != null || onLongPress != null);

  @override
  State<M3ETappable> createState() => _M3ETappableState();
}

class _M3ETappableState extends State<M3ETappable>
    with SingleTickerProviderStateMixin {
  M3EInteractionState _state = const M3EInteractionState();
  late final AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController.unbounded(vsync: this, value: 1);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _update(M3EInteractionState next) {
    if (next == _state) {
      return;
    }
    setState(() => _state = next);
    widget.onStateChanged?.call(next);
  }

  void _snapScale(double target) {
    if (widget.pressedScale == 1) {
      return;
    }
    _scaleController
      ..stop()
      ..value = target;
  }

  void _animateScale(double target) {
    if (widget.pressedScale == 1) {
      return;
    }
    _scaleController.animateWith(
      SpringSimulation(
        widget.spring.toDescription(),
        _scaleController.value,
        target,
        _scaleController.velocity,
      ),
    );
  }

  void _handlePointerDown() {
    _update(_state.copyWith(pressed: true));
    _snapScale(widget.pressedScale);
  }

  void _handlePointerUp() {
    _update(_state.copyWith(pressed: false));
    _animateScale(1);
  }

  @override
  Widget build(BuildContext context) {
    final bool interactive = widget._isInteractive;
    Widget content = widget.builder(context, _state);
    if (widget.materialInk) {
      content = M3ETappableInkScope(
        onTap: interactive ? widget.onTap : null,
        onLongPress: interactive ? widget.onLongPress : null,
        mouseCursor: _resolveCursor(interactive),
        onTapDown: interactive && widget.pressedScale != 1
            ? (_) => _handlePointerDown()
            : null,
        onTapUp: interactive && widget.pressedScale != 1
            ? (_) => _handlePointerUp()
            : null,
        onTapCancel:
            interactive && widget.pressedScale != 1 ? _handlePointerUp : null,
        onHover: interactive
            ? (bool hovered) => _update(_state.copyWith(hovered: hovered))
            : null,
        child: content,
      );
    }
    content = _wrapScale(content);
    final Widget pointer = _wrapPointer(content, interactive);
    return _wrapSemantics(_wrapFocus(pointer, interactive));
  }

  Widget _wrapScale(Widget child) {
    if (widget.pressedScale == 1) {
      return child;
    }
    return AnimatedBuilder(
      animation: _scaleController,
      builder: (BuildContext context, Widget? built) {
        return Transform.scale(scale: _scaleController.value, child: built);
      },
      child: child,
    );
  }

  Widget _wrapPointer(Widget child, bool interactive) {
    if (widget.materialInk) {
      return child;
    }

    Widget wrapped = MouseRegion(
      cursor: _resolveCursor(interactive),
      onEnter: (_) => _update(_state.copyWith(hovered: true)),
      onExit: (_) => _update(_state.copyWith(hovered: false)),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: interactive ? widget.onTap : null,
        onLongPress: interactive ? widget.onLongPress : null,
        child: child,
      ),
    );

    if (!interactive) {
      return wrapped;
    }

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _handlePointerDown(),
      onPointerUp: (_) => _handlePointerUp(),
      onPointerCancel: (_) => _handlePointerUp(),
      child: wrapped,
    );
  }

  Widget _wrapFocus(Widget child, bool interactive) {
    return FocusableActionDetector(
      enabled: interactive,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      onShowFocusHighlight: (bool value) =>
          _update(_state.copyWith(focused: value)),
      actions: <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap?.call();
            return null;
          },
        ),
      },
      child: child,
    );
  }

  Widget _wrapSemantics(Widget child) {
    return Semantics(
      container: true,
      button: widget.semanticButton,
      enabled: widget.enabled,
      label: widget.semanticLabel,
      excludeSemantics: widget.excludeSemantics,
      child: child,
    );
  }

  MouseCursor _resolveCursor(bool interactive) {
    if (!interactive) {
      return SystemMouseCursors.basic;
    }
    return widget.mouseCursor ?? SystemMouseCursors.click;
  }
}
