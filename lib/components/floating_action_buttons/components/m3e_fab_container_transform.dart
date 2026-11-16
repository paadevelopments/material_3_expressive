import 'dart:ui' as ui show Image;
import 'dart:ui' show lerpDouble;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';

SpringMotion _fabSpringMotion(M3ESpring spring) =>
    const MaterialSpringMotion.expressiveSpatialDefault().copyWith(
      stiffness: spring.stiffness,
      damping: spring.damping,
    );

/// Origin content fades out by this progress (and back in on close).
const double _originFadeEnd = 0.4;

/// Pixels of the origin content painted inside the morphing container.
class _M3EFabTransformSnapshot {
  const _M3EFabTransformSnapshot(this.image, this.rect);

  final ui.Image image;

  /// Snapshot bounds relative to the origin rect's top-left.
  final Rect rect;
}

/// Captures [key]'s [RenderRepaintBoundary] for the cross-fade, or null when
/// it has not painted yet.
_M3EFabTransformSnapshot? _captureOriginSnapshot(
  BuildContext context,
  GlobalKey? key,
  Rect origin,
) {
  final RenderObject? object = key?.currentContext?.findRenderObject();
  if (object is! RenderRepaintBoundary ||
      !object.attached ||
      !object.hasSize ||
      object.size.isEmpty) {
    return null;
  }
  // Last painted layer: no wait for a pending repaint (e.g. a tap pulse).
  final ContainerLayer? layer = object.layer;
  final Size size = object.size;
  final Rect painted = MatrixUtils.transformRect(
    object.getTransformTo(null),
    Offset.zero & size,
  );
  if (layer is! OffsetLayer || painted.width <= 0) {
    return null;
  }
  final ui.Image image = layer.toImageSync(
    Offset.zero & size,
    pixelRatio: MediaQuery.devicePixelRatioOf(context),
  );
  // Undo a press scale about the origin center so the snapshot lands where
  // the content rests once the press settles.
  final double scale = painted.width / size.width;
  final Offset center =
      origin.center + (painted.center - origin.center) / scale;
  return _M3EFabTransformSnapshot(
    image,
    Rect.fromCenter(
      center: center - origin.topLeft,
      width: size.width,
      height: size.height,
    ),
  );
}

/// Handle for an in-flight FAB container transform.
class M3EFabContainerTransformHandle<T extends Object?> {
  M3EFabContainerTransformHandle._(this.future, this._close);

  /// Completes when the transform finishes closing.
  final Future<T?> future;

  final void Function([T? result]) _close;

  /// Reverses the morph and dismisses the route.
  void close([T? result]) => _close(result);
}

/// Opens a Material container-transform style route from a FAB origin rect.
///
/// Pushes onto the same navigator as `context` so the back stack stays
/// coherent. Destinations can also call [M3EFabContainerTransformScope.closeOf].
class M3EFabContainerTransform {
  M3EFabContainerTransform._();

  /// Morphs from [origin] into a full-screen destination built by [builder].
  static M3EFabContainerTransformHandle<T> show<T extends Object?>({
    required BuildContext context,
    required Rect origin,
    required double originRadius,
    required Color originColor,
    required WidgetBuilder builder,
    Color? scrimColor,
    Color? openColor,
    M3ESpring motion = M3EMotion.expressiveSpatialDefault,
    GlobalKey? originBoundaryKey,
    List<BoxShadow> originShadows = const <BoxShadow>[],
  }) {
    final Color schemeScrim =
        scrimColor ??
        M3ETheme.of(context).colorScheme.scrim.withValues(alpha: 0.32);
    final Color destinationColor =
        openColor ?? M3ETheme.of(context).colorScheme.surface;

    late final _M3EFabContainerTransformPageRoute<T> route;
    void Function([T? result])? requestClose;

    route = _M3EFabContainerTransformPageRoute<T>(
      snapshot: _captureOriginSnapshot(context, originBoundaryKey, origin),
      originShadows: originShadows,
      origin: origin,
      originRadius: originRadius,
      originColor: originColor,
      openColor: destinationColor,
      scrimColor: schemeScrim,
      motion: motion,
      builder: builder,
      onCloseReady: (void Function([T? result]) close) {
        requestClose = close;
      },
    );

    // Same navigator as the FAB (not root) so back stack stays coherent.
    final Future<T?> future = Navigator.of(context).push<T>(route);

    return M3EFabContainerTransformHandle<T>._(future, ([T? result]) {
      requestClose?.call(result);
    });
  }
}

/// Provides [close] to container-transform destinations.
class M3EFabContainerTransformScope extends InheritedWidget {
  /// Creates a transform scope.
  const M3EFabContainerTransformScope({
    required this.close,
    required super.child,
    super.key,
  });

  /// Closes the active container transform.
  final void Function([Object? result]) close;

  /// Closes the nearest open container transform.
  static void closeOf(BuildContext context, [Object? result]) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<M3EFabContainerTransformScope>();
    assert(scope != null, 'No M3EFabContainerTransformScope found.');
    scope!.close(result);
  }

  /// Returns the nearest scope, or null.
  static M3EFabContainerTransformScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<M3EFabContainerTransformScope>();
  }

  @override
  bool updateShouldNotify(covariant M3EFabContainerTransformScope oldWidget) =>
      close != oldWidget.close;
}

class _M3EFabContainerTransformPageRoute<T> extends PageRoute<T> {
  _M3EFabContainerTransformPageRoute({
    required this.snapshot,
    required this.originShadows,
    required this.origin,
    required this.originRadius,
    required this.originColor,
    required this.openColor,
    required this.scrimColor,
    required this.motion,
    required this.builder,
    required this.onCloseReady,
  });

  final _M3EFabTransformSnapshot? snapshot;
  final List<BoxShadow> originShadows;
  final Rect origin;
  final double originRadius;
  final Color originColor;
  final Color openColor;
  final Color scrimColor;
  final M3ESpring motion;
  final WidgetBuilder builder;
  final void Function(void Function([T? result]) close) onCloseReady;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration.zero;

  @override
  Duration get reverseTransitionDuration => Duration.zero;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _M3EFabContainerTransformHost<T>(
      snapshot: snapshot,
      originShadows: originShadows,
      origin: origin,
      originRadius: originRadius,
      originColor: originColor,
      openColor: openColor,
      scrimColor: scrimColor,
      motion: motion,
      builder: builder,
      onCloseReady: onCloseReady,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return child;
  }
}

class _M3EFabContainerTransformHost<T> extends StatefulWidget {
  const _M3EFabContainerTransformHost({
    required this.snapshot,
    required this.originShadows,
    required this.origin,
    required this.originRadius,
    required this.originColor,
    required this.openColor,
    required this.scrimColor,
    required this.motion,
    required this.builder,
    required this.onCloseReady,
  });

  final _M3EFabTransformSnapshot? snapshot;
  final List<BoxShadow> originShadows;
  final Rect origin;
  final double originRadius;
  final Color originColor;
  final Color openColor;
  final Color scrimColor;
  final M3ESpring motion;
  final WidgetBuilder builder;
  final void Function(void Function([T? result]) close) onCloseReady;

  @override
  State<_M3EFabContainerTransformHost<T>> createState() =>
      _M3EFabContainerTransformHostState<T>();
}

class _M3EFabContainerTransformHostState<T>
    extends State<_M3EFabContainerTransformHost<T>>
    with TickerProviderStateMixin {
  late final SingleMotionController _progress;
  bool _closing = false;
  bool _contentVisible = false;
  bool _allowPop = false;
  T? _pendingResult;

  /// Built once so spring ticks do not rebuild the destination every frame.
  late final Widget _destination = Builder(builder: widget.builder);

  @override
  void initState() {
    super.initState();
    _progress =
        SingleMotionController(
          motion: _fabSpringMotion(widget.motion),
          vsync: this,
        )..addListener(() {
          if (mounted) {
            setState(() {});
          }
          if (!_closing && !_contentVisible && _progress.value >= 0.55) {
            setState(() => _contentVisible = true);
          }
        });
    widget.onCloseReady(_requestClose);
    _progress.animateTo(1);
  }

  @override
  void dispose() {
    _progress.dispose();
    widget.snapshot?.image.dispose();
    super.dispose();
  }

  Future<void> _requestClose([T? result]) async {
    if (_allowPop) {
      // Pop already armed; let Navigator finish.
      return;
    }
    if (_closing) {
      return;
    }
    _closing = true;
    _pendingResult = result;
    if (mounted) {
      setState(() => _contentVisible = false);
    }
    await _progress.animateTo(0);
    if (!mounted) {
      return;
    }
    // Enable canPop then pop so system-back / maybePop cannot leave a stuck
    // route with canPop:false on the stack.
    setState(() => _allowPop = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final NavigatorState navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop(_pendingResult);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.sizeOf(context);
    final Rect openRect = Offset.zero & screen;
    final double t = _progress.value.clamp(0.0, 1.0);
    final Rect rect = Rect.lerp(widget.origin, openRect, t)!;
    final double radius = lerpDouble(
      widget.originRadius,
      0,
      Curves.easeOut.transform(t),
    )!;
    final Color fill =
        Color.lerp(widget.originColor, widget.openColor, t) ?? widget.openColor;
    final double scrimOpacity = Curves.easeOut.transform(t);

    return PopScope(
      canPop: _allowPop,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
        _requestClose(result is T ? result : null);
      },
      child: M3EFabContainerTransformScope(
        close: ([Object? result]) => _requestClose(result is T ? result : null),
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _requestClose(),
              child: ColoredBox(
                color: widget.scrimColor.withValues(
                  alpha: widget.scrimColor.a * scrimOpacity,
                ),
              ),
            ),
            Positioned(
              left: rect.left,
              top: rect.top,
              width: rect.width,
              height: rect.height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius),
                  boxShadow: _originShadows(t),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: ColoredBox(
                    color: fill,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        if (!_contentVisible)
                          const SizedBox.expand()
                        else
                          Opacity(
                            opacity: Curves.easeOut.transform(
                              ((t - 0.4) / 0.6).clamp(0.0, 1.0),
                            ),
                            child: _destination,
                          ),
                        ?_originContent(t),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Origin resting shadow, fading with the origin content so the landing
  /// container matches the button it hands back to.
  List<BoxShadow>? _originShadows(double t) {
    final double k = _originOpacity(t);
    if (k <= 0 || widget.originShadows.isEmpty) {
      return null;
    }
    return <BoxShadow>[
      for (final BoxShadow shadow in widget.originShadows)
        shadow.copyWith(
          color: shadow.color.withValues(alpha: shadow.color.a * k),
        ),
    ];
  }

  double _originOpacity(double t) =>
      1 - Curves.easeOut.transform((t / _originFadeEnd).clamp(0.0, 1.0));

  /// Origin content cross-fading out as the container grows (in on close).
  Widget? _originContent(double t) {
    final _M3EFabTransformSnapshot? snapshot = widget.snapshot;
    if (snapshot == null || t >= _originFadeEnd) {
      return null;
    }
    final double opacity = _originOpacity(t);
    return Positioned(
      left: snapshot.rect.left,
      top: snapshot.rect.top,
      width: snapshot.rect.width,
      height: snapshot.rect.height,
      child: IgnorePointer(
        child: RawImage(
          image: snapshot.image,
          width: snapshot.rect.width,
          height: snapshot.rect.height,
          fit: BoxFit.fill,
          opacity: AlwaysStoppedAnimation<double>(opacity),
        ),
      ),
    );
  }
}
