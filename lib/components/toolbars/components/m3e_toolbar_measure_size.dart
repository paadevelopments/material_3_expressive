import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Reports child size changes for scroll-exit [offsetLimit] updates.
class M3EToolbarMeasureSize extends SingleChildRenderObjectWidget {
  /// M3EToolbarMeasureSize.
  const M3EToolbarMeasureSize({
    required this.onChange,
    required Widget super.child,
    super.key,
  });

  /// onChange.
  final ValueChanged<Size> onChange;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderM3EToolbarMeasureSize(onChange: onChange);
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderM3EToolbarMeasureSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class RenderM3EToolbarMeasureSize extends RenderProxyBox {
  RenderM3EToolbarMeasureSize({required this.onChange});

  ValueChanged<Size> onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    final Size? newSize = child?.size;
    if (newSize != null && _oldSize != newSize) {
      _oldSize = newSize;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onChange(newSize);
      });
    }
  }
}
