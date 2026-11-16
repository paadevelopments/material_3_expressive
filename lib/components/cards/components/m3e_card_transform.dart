part of '../m3e_cards.dart';

/// Container-transform launch for [_M3ECardState].
extension _M3ECardTransform on _M3ECardState {
  Future<T?> _openTransform<T extends Object?>({WidgetBuilder? builder}) async {
    final WidgetBuilder? openBuilder = builder ?? widget.openBuilder;
    if (openBuilder == null || _transformOpen) {
      return null;
    }
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return null;
    }
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ECardTheme cardTheme = theme.cardTheme;
    final BorderRadius radius = widget.borderRadius ?? cardTheme.borderRadius;
    final Rect origin =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final Color originColor =
        widget.color ??
        cardTheme.containerColorFor(
          theme.colorScheme,
          widget.variant,
          enabled: widget.enabled,
        );
    final M3ECardContainerTransformHandle<T> handle =
        M3ECardContainerTransform.show<T>(
          context: context,
          origin: origin,
          originRadius: radius.topLeft.x,
          originColor: originColor,
          builder: openBuilder,
          scrimColor: cardTheme.resolveTransformScrim(theme.colorScheme),
          openColor: widget.color == null
              ? cardTheme.resolveTransformOpenColor(theme.colorScheme)
              : null,
          endRadius: cardTheme.transformEndRadius,
          contentFadeStart: cardTheme.transformContentFadeStart,
          contentVisibleAt: cardTheme.transformContentVisibleAt,
          motion: cardTheme.transformSpring,
          originBoundary:
              _contentBoundaryKey.currentContext?.findRenderObject()
                  as RenderRepaintBoundary?,
        );
    _closeTransform = ([Object? result]) => handle.close(result as T?);
    setState(() => _transformOpen = true);
    widget.controller?.refresh();
    final T? result = await handle.future;
    _closeTransform = null;
    if (mounted) {
      setState(() => _transformOpen = false);
      widget.controller?.refresh();
    }
    return result;
  }
}
