import 'package:flutter/widgets.dart';

/// Shared focus helpers for M3E input components.
abstract final class M3EFocus {
  const M3EFocus._();

  /// Default [EditableText.onTapOutside] handler that unfocuses [focusNode].
  static void unfocusOnTapOutside(FocusNode focusNode, PointerDownEvent event) {
    focusNode.unfocus();
  }

  /// Builds a [TapRegionCallback] that unfocuses [focusNode].
  static TapRegionCallback tapOutsideHandler(FocusNode focusNode) {
    return (PointerDownEvent event) => unfocusOnTapOutside(focusNode, event);
  }
}
