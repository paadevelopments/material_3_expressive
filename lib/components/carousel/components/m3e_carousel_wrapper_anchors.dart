part of 'm3e_carousel_wrapper.dart';

/// Registers the carousel viewport [RenderBox] without a [GlobalKey].
class _CarouselViewportAnchor extends SingleChildRenderObjectWidget {
  const _CarouselViewportAnchor({
    required this.onRegister,
    required this.onUnregister,
    required Widget child,
  }) : super(child: child);

  final void Function(RenderBox box) onRegister;
  final void Function(RenderBox box) onUnregister;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCarouselViewportAnchor(
      onRegister: onRegister,
      onUnregister: onUnregister,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderCarouselViewportAnchor renderObject,
  ) {
    renderObject
      ..onRegister = onRegister
      ..onUnregister = onUnregister;
  }
}

class _RenderCarouselViewportAnchor extends RenderProxyBox {
  _RenderCarouselViewportAnchor({
    required this.onRegister,
    required this.onUnregister,
  });

  void Function(RenderBox box) onRegister;
  void Function(RenderBox box) onUnregister;

  void _registerIfReady() {
    if (hasSize && attached) {
      onRegister(this);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _registerIfReady();
  }

  @override
  void detach() {
    onUnregister(this);
    super.detach();
  }

  @override
  void performLayout() {
    super.performLayout();
    _registerIfReady();
  }
}

/// Registers its [RenderBox] for pulse measuring without a [GlobalKey].
class _CarouselItemAnchor extends SingleChildRenderObjectWidget {
  const _CarouselItemAnchor({
    required this.index,
    required this.onRegister,
    required this.onUnregister,
    required Widget child,
  }) : super(child: child);

  final int index;
  final void Function(int index, RenderBox box) onRegister;
  final void Function(int index, RenderBox box) onUnregister;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCarouselItemAnchor(
      index: index,
      onRegister: onRegister,
      onUnregister: onUnregister,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderCarouselItemAnchor renderObject,
  ) {
    renderObject
      ..index = index
      ..onRegister = onRegister
      ..onUnregister = onUnregister;
  }
}

class _RenderCarouselItemAnchor extends RenderProxyBox {
  _RenderCarouselItemAnchor({
    required this._index,
    required this.onRegister,
    required this.onUnregister,
  });

  int _index;
  void Function(int index, RenderBox box) onRegister;
  void Function(int index, RenderBox box) onUnregister;

  int get index => _index;

  set index(int value) {
    if (_index == value) {
      return;
    }
    onUnregister(_index, this);
    _index = value;
    _registerIfReady();
  }

  void _registerIfReady() {
    if (hasSize && attached) {
      onRegister(_index, this);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _registerIfReady();
  }

  @override
  void detach() {
    onUnregister(_index, this);
    super.detach();
  }

  @override
  void performLayout() {
    super.performLayout();
    _registerIfReady();
  }
}

/// Registers an item's content boundary (picture, scrim, labels; no ink
/// layer) for container-transform snapshots without a [GlobalKey].
class _CarouselContentBoundary extends SingleChildRenderObjectWidget {
  const _CarouselContentBoundary({
    required this.index,
    required this.boundaries,
    required Widget child,
  }) : super(child: child);

  final int index;
  final Map<int, RenderRepaintBoundary> boundaries;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderCarouselContentBoundary(index, boundaries);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderCarouselContentBoundary renderObject,
  ) {
    renderObject.index = index;
  }
}

class _RenderCarouselContentBoundary extends RenderRepaintBoundary {
  _RenderCarouselContentBoundary(this._index, this._boundaries);

  int _index;
  final Map<int, RenderRepaintBoundary> _boundaries;

  int get index => _index;

  set index(int value) {
    if (_index == value) {
      return;
    }
    _unregister();
    _index = value;
    if (attached) {
      _boundaries[_index] = this;
    }
  }

  void _unregister() {
    if (identical(_boundaries[_index], this)) {
      _boundaries.remove(_index);
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _boundaries[_index] = this;
  }

  @override
  void detach() {
    _unregister();
    super.detach();
  }
}
