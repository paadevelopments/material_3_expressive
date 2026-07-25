part of 'm3e_dismissible_card_controller.dart';

/// M3EDismissibleCardBuildMixin.

mixin M3EDismissibleCardBuildMixin<T extends StatefulWidget>
    on M3EDismissibleCardMixin<T> {
  @override
  Widget buildSlot(BuildContext context, int slotIndex, [List<int>? visible]) {
    final slot = _slots[slotIndex];
    if (slot.isCollapsing) {
      return _buildCollapsingCard(context, slotIndex);
    }
    return _buildActiveCard(
      context,
      slotIndex,
      visible ?? computeVisibleIndices(),
    );
  }

  Widget _buildCollapsingCard(BuildContext context, int slotIndex) {
    final slot = _slots[slotIndex];
    final ctrl = slot.collapseCtrl!;
    final totalH = slot.capturedHeight + style.gap;
    final s = style;

    final swipingRight = slot.dismissedDirection == DismissDirection.startToEnd;
    final bgRadius = swipingRight
        ? s.backgroundBorderRadius
        : (s.secondaryBackgroundBorderRadius ?? s.backgroundBorderRadius);
    final cardRadius = s.selectedBorderRadius ?? s.outerRadius;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: ctrl,
        child: slot.frozenChild == null
            ? null
            : Stack(
                children: [
                  if (slot.dismissedDirection != null)
                    ValueListenableBuilder<double>(
                      valueListenable: slot.flyNotifier,
                      builder: (_, flyOff, child) {
                        final progress = flyOff.abs();
                        final actionWidth = (progress - s.actionGap).clamp(
                          0.0,
                          progress,
                        );
                        final swipingRight =
                            slot.dismissedDirection ==
                            DismissDirection.startToEnd;
                        if (actionWidth <= 0) {
                          return const SizedBox.shrink();
                        }
                        return Positioned.fill(
                          bottom: s.gap,
                          child: Align(
                            alignment: swipingRight
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: SizedBox(
                              width: actionWidth,
                              height: double.infinity,
                              child: Padding(
                                padding: s.margin ?? EdgeInsets.zero,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(bgRadius),
                                  child: swipingRight
                                      ? s.background
                                      : (s.secondaryBackground ?? s.background),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  Padding(
                    padding: EdgeInsets.only(bottom: s.gap),
                    child: OverflowBox(
                      alignment: Alignment.topLeft,
                      minWidth: slot.capturedWidth > 0 ? slot.capturedWidth : 0,
                      maxWidth: slot.capturedWidth > 0
                          ? slot.capturedWidth
                          : MediaQuery.sizeOf(context).width,
                      minHeight: 0,
                      maxHeight: slot.capturedHeight,
                      child: IgnorePointer(
                        child: ValueListenableBuilder<double>(
                          valueListenable: slot.flyNotifier,
                          builder: (_, flyOff, child) => Transform.translate(
                            offset: Offset(flyOff, 0),
                            child: child,
                          ),
                          child: Padding(
                            padding: EdgeInsets.zero,
                            child: M3ECard(
                              variant: M3ECardVariant.filled,
                              borderRadius: BorderRadius.circular(cardRadius),
                              color:
                                  s.color ??
                                  M3ETheme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                              border: s.border,
                              padding: s.padding ?? const EdgeInsets.all(16),
                              width: double.infinity,
                              child: M3EListItemScope(child: slot.frozenChild!),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        builder: (ctx, child) {
          final h = (totalH * (1.0 - ctrl.value)).clamp(0.0, totalH);
          return SizedBox(height: h, width: double.infinity, child: child);
        },
      ),
    );
  }

  Widget _buildActiveCard(
    BuildContext context,
    int slotIndex,
    List<int> visible,
  ) {
    final slot = _slots[slotIndex];
    final s = style;
    final slotPos = visible.indexOf(slotIndex);
    if (slotPos < 0 || slotPos >= swipeItemCount) {
      return const SizedBox.shrink();
    }

    final total = visible.length;
    final isLast = slotPos == total - 1;
    final isDragged = slotIndex == _dragSlotIndex;
    final dragPos = _dragSlotIndex >= 0 ? visible.indexOf(_dragSlotIndex) : -1;
    final br = computeRadius(slotIndex, slotPos, dragPos, visible);
    final nOff = computeNeighbourOffset(slotPos, dragPos);

    final bool swipingRight = _dragOffset > 0;
    final Widget? activeBg = swipingRight
        ? s.background
        : (s.secondaryBackground ?? s.background);
    final bgRadius = swipingRight
        ? s.backgroundBorderRadius
        : (s.secondaryBackgroundBorderRadius ?? s.backgroundBorderRadius);
    final double revealed = _dragOffset.abs();
    final double actionWidth = (revealed - s.actionGap).clamp(0.0, revealed);

    return RepaintBoundary(
      child: Padding(
        padding: s.margin ?? EdgeInsets.zero,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (isDragged && actionWidth > 0 && activeBg != null)
              Positioned.fill(
                bottom: isLast ? 0 : s.gap,
                child: RepaintBoundary(
                  child: Align(
                    alignment: swipingRight
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(bgRadius),
                      child: SizedBox(
                        width: actionWidth,
                        height: double.infinity,
                        child: Opacity(
                          opacity: (_dragProgress * 3.0).clamp(0.0, 1.0),
                          child: _buildActiveBackground(
                            activeBg,
                            _dragProgress,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : s.gap),
              child: Transform.translate(
                offset: Offset(isDragged ? _dragOffset + _detachPush : nOff, 0),
                child: GestureDetector(
                  onHorizontalDragStart: (_) => handleDragStart(slot),
                  onHorizontalDragUpdate: handleDragUpdate,
                  onHorizontalDragEnd: handleDragEnd,
                  child: M3ECard(
                    variant: M3ECardVariant.filled,
                    surfaceKey: _measureKey(slot),
                    borderRadius: br,
                    color:
                        s.color ??
                        M3ETheme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                    border: s.border,
                    animationDuration: _dragSlotRef != null
                        ? Duration.zero
                        : const Duration(milliseconds: 520),
                    animationCurve: _kCardSettleCurve,
                    width: double.infinity,
                    padding: EdgeInsets.zero,
                    onPressed: isInteractionLocked || onTapCallback == null
                        ? null
                        : () => onTapCallback!(slotPos),
                    haptic: s.hapticOnTap,
                    child: Padding(
                      padding: s.padding ?? const EdgeInsets.all(16),
                      child: M3EListItemScope(
                        child: swipeItemBuilder(context, slotPos),
                      ),
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

  Widget _buildActiveBackground(Widget? bg, double progress) {
    if (bg == null) {
      return const SizedBox.shrink();
    }
    final iconOpacity = progress < 0.3
        ? 0.0
        : ((progress - 0.3) / 0.7).clamp(0.0, 1.0);
    final iconScale = progress < 0.3
        ? 0.8
        : (0.8 + ((progress - 0.3) / 0.7) * 0.2).clamp(0.0, 1.0);

    Widget wrapChild(Widget? child) {
      if (child == null) {
        return const SizedBox.shrink();
      }
      return Transform.scale(
        scale: iconScale,
        child: Opacity(opacity: iconOpacity, child: child),
      );
    }

    if (bg is Container) {
      return Container(
        alignment: bg.alignment,
        padding: bg.padding,
        color: bg.color,
        decoration: bg.decoration,
        foregroundDecoration: bg.foregroundDecoration,
        constraints: bg.constraints,
        margin: bg.margin,
        transform: bg.transform,
        transformAlignment: bg.transformAlignment,
        clipBehavior: bg.clipBehavior,
        child: bg.child != null ? wrapChild(bg.child) : null,
      );
    }
    if (bg is ColoredBox) {
      return ColoredBox(color: bg.color, child: wrapChild(bg.child));
    }
    if (bg is DecoratedBox) {
      return DecoratedBox(
        decoration: bg.decoration,
        position: bg.position,
        child: wrapChild(bg.child),
      );
    }
    return wrapChild(bg);
  }
}
