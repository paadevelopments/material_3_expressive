import 'package:flutter/widgets.dart';

/// Rectangle for [context]'s render box in the root overlay's coordinate
/// space, including ancestor transforms.
///
/// Popups are inserted into the root overlay, so anchors must be measured
/// against it; a nested [Navigator]'s overlay has a different origin.
///
/// Prefer this over `localToGlobal(Offset.zero) & size` when ancestors use
/// [Transform] (e.g. menu open scale), which otherwise mis-anchors submenus.
Rect? m3eOverlayRectFor(BuildContext context) {
  final RenderObject? object = context.findRenderObject();
  if (object is! RenderBox || !object.hasSize || !object.attached) {
    return null;
  }
  final OverlayState? overlay = Overlay.maybeOf(context, rootOverlay: true);
  final RenderObject? ancestor = overlay?.context.findRenderObject();
  return MatrixUtils.transformRect(
    object.getTransformTo(ancestor),
    Offset.zero & object.size,
  );
}
