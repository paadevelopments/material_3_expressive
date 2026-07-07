import "package:flutter/material.dart";
import "package:flutter/rendering.dart";

class M3ESliverSemantic extends SingleChildRenderObjectWidget {
  const M3ESliverSemantic({super.key, required this.label, required Widget child})
      : super(child: child);
  final String label;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _M3ESliverSemanticRender(label);
  @override
  void updateRenderObject(
      BuildContext context, covariant _M3ESliverSemanticRender renderObject) {
    renderObject.label = label;
  }
}

class _M3ESliverSemanticRender extends RenderProxySliver {
  _M3ESliverSemanticRender(this._label);
  String _label;
  set label(String v) {
    if (v == _label) return;
    _label = v;
    markNeedsSemanticsUpdate();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    super.describeSemanticsConfiguration(config);
    config.label = _label;
    config.isSemanticBoundary = true;
  }
}
