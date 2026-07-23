// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
part of '../m3e_toggle_button_group.dart';

mixin _ToggleGroupOverflowPresenterMixin on State<M3EButtonGroup> {
  void _handleOverflowActionSelection(int index);
  bool _isToggleActionSelected(int index);

  Future<void> _openOverflowMenu(
    BuildContext context,
    int firstHiddenIndex,
  ) async {
    if (firstHiddenIndex >= widget.actions.length) return;
    final selectedIndex = switch (widget.overflowMenuStyle) {
      M3EButtonGroupOverflowMenuStyle.popup => _showOverflowPopup(
        context,
        firstHiddenIndex,
      ),
      M3EButtonGroupOverflowMenuStyle.bottomSheet => _showOverflowBottomSheet(
        context,
        firstHiddenIndex,
      ),
    };
    final result = await selectedIndex;
    if (!mounted || result == null) return;
    _handleOverflowActionSelection(result);
  }

  Future<int?> _showOverflowPopup(
    BuildContext context,
    int firstHiddenIndex,
  ) async {
    final triggerBox = context.findRenderObject() as RenderBox?;
    if (triggerBox == null) return null;

    final dec = widget.overflowPopupDecoration;
    final menuTheme = M3ETheme.of(context).menuTheme.copyWith(
          minWidth: dec.minWidth,
          maxWidth: dec.maxWidth,
          maxHeight: dec.maxHeight,
          elevation: dec.elevation,
          motion: dec.motion,
        );

    final itemNodes = <M3EMenuNode>[
      for (var i = firstHiddenIndex; i < widget.actions.length; i++)
        M3EMenuWidget(
          value: i,
          enabled: widget.actions[i].enabled,
          selected: _isToggleActionSelected(i),
          semanticLabel:
              widget.actions[i].semanticLabel ?? widget.actions[i].tooltip,
          child: Row(
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  size: M3ETheme.of(context).resolvedIconTheme.size,
                ),
                child: _overflowMenuLeading(i),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: M3ETheme.of(context).typeScale.bodyLarge,
                  child: _overflowMenuTitle(i),
                ),
              ),
            ],
          ),
        ),
    ];

    final nodes = dec.useCardList
        ? <M3EMenuNode>[M3EMenuGroup(children: itemNodes)]
        : itemNodes;

    return showM3EMenu<int>(
      context: context,
      anchor: triggerBox.localToGlobal(Offset.zero) & triggerBox.size,
      children: nodes,
      position: M3EMenuAnchorPosition.bottomEnd,
      preferredWidth: (triggerBox.size.width + 176.0).clamp(
        dec.minWidth,
        dec.maxWidth,
      ),
      themeOverride: menuTheme,
    );
  }

  Future<int?> _showOverflowBottomSheet(
    BuildContext context,
    int firstHiddenIndex,
  ) async {
    final dec = widget.overflowBottomSheetDecoration;
    final m3eTheme = M3ETheme.of(context);
    final cs = m3eTheme.colorScheme;
    final itemCount = widget.actions.length - firstHiddenIndex;

    return showModalBottomSheet<int>(
      context: context,
      showDragHandle: dec.showDragHandle,
      backgroundColor: dec.backgroundColor,
      elevation: dec.elevation,
      shape: dec.shape,
      builder: (sheetContext) {
        return M3EScrimSystemUi.wrapBottomSheet(
          _SpringMenuWrapper(
            motion: dec.motion,
            alignment: Alignment.bottomCenter,
            isBottomSheet: true,
            child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dec.title != null)
                    Padding(
                      padding: dec.titlePadding,
                      child: DefaultTextStyle.merge(
                        style: M3ETheme.of(sheetContext).textTheme.titleMedium!,
                        child: dec.title!,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: dec.useCardList
                        ? _buildBottomSheetCardList(
                            sheetContext,
                            firstHiddenIndex,
                            itemCount,
                            dec,
                            cs,
                          )
                        : _buildBottomSheetStandardList(
                            sheetContext,
                            firstHiddenIndex,
                            itemCount,
                            dec,
                            cs,
                          ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
        );
      },
    );
  }

  Widget _buildBottomSheetCardList(
    BuildContext sheetContext,
    int firstHiddenIndex,
    int itemCount,
    M3EOverflowBottomSheetDecoration dec,
    M3EColorScheme cs,
  ) {
    final outerR = dec.outerRadius;
    final innerR = dec.innerRadius;
    final selectedR = dec.selectedBorderRadius ?? outerR;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, _) => SizedBox(height: dec.itemGap),
      itemBuilder: (context, listIndex) {
        final actionIndex = firstHiddenIndex + listIndex;
        return _buildBottomSheetCardListItem(
          context,
          actionIndex,
          listIndex,
          itemCount,
          dec,
          cs,
          outerR,
          innerR,
          selectedR,
        );
      },
    );
  }

  Widget _buildBottomSheetCardListItem(
    BuildContext context,
    int actionIndex,
    int listIndex,
    int total,
    M3EOverflowBottomSheetDecoration dec,
    M3EColorScheme cs,
    double outerR,
    double innerR,
    double selectedR,
  ) {
    final action = widget.actions[actionIndex];
    final selected = _isToggleActionSelected(actionIndex);

    final isFirst = listIndex == 0;
    final isLast = listIndex == total - 1;
    final isSingle = total == 1;

    BorderRadius borderRadius;
    if (selected) {
      borderRadius = BorderRadius.circular(selectedR);
    } else if (isSingle) {
      borderRadius = BorderRadius.circular(outerR);
    } else if (isFirst) {
      borderRadius = BorderRadius.vertical(
        top: Radius.circular(outerR),
        bottom: Radius.circular(innerR),
      );
    } else if (isLast) {
      borderRadius = BorderRadius.vertical(
        top: Radius.circular(innerR),
        bottom: Radius.circular(outerR),
      );
    } else {
      borderRadius = BorderRadius.circular(innerR);
    }

    final bgColor = selected
        ? (dec.selectedBackgroundColor ?? cs.secondaryContainer)
        : (dec.itemBackgroundColor ?? cs.surfaceContainerHigh);

    return Material(
      color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: action.enabled
            ? () => Navigator.of(context).pop(actionIndex)
            : null,
        borderRadius: borderRadius,
        child: Padding(
          padding: dec.itemPadding,
          child: Row(
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  size: M3ETheme.of(context).resolvedIconTheme.size,
                  color: selected ? cs.onSecondaryContainer : cs.onSurface,
                ),
                child: _overflowMenuLeading(actionIndex),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: M3ETheme.of(context).typeScale.bodyLarge.copyWith(
                    color: selected ? cs.onSecondaryContainer : cs.onSurface,
                  ),
                  child: _overflowMenuTitle(actionIndex),
                ),
              ),
              if (selected)
                dec.trailing ??
                    Icon(
                      M3EIcons.check_rounded,
                      color: cs.onSecondaryContainer,
                      size: M3ETheme.of(context).resolvedIconTheme.size,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheetStandardList(
    BuildContext sheetContext,
    int firstHiddenIndex,
    int itemCount,
    M3EOverflowBottomSheetDecoration dec,
    M3EColorScheme cs,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, listIndex) {
        final actionIndex = firstHiddenIndex + listIndex;
        return _buildBottomSheetStandardItem(context, actionIndex, dec, cs);
      },
    );
  }

  Widget _buildBottomSheetStandardItem(
    BuildContext context,
    int actionIndex,
    M3EOverflowBottomSheetDecoration dec,
    M3EColorScheme cs,
  ) {
    final action = widget.actions[actionIndex];
    final selected = _isToggleActionSelected(actionIndex);

    final itemRadius = dec.selectedBorderRadius ?? dec.outerRadius;

    final fgColor = selected
        ? (widget.decoration?.foregroundColor?.resolve({
                WidgetState.selected,
              }) ??
              cs.onSecondaryContainer)
        : (widget.decoration?.foregroundColor?.resolve({}) ?? cs.onSurface);

    final bgColor = selected
        ? (dec.selectedBackgroundColor ?? cs.secondaryContainer)
        : Colors.transparent;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: action.enabled ? bgColor : Colors.transparent,
          borderRadius: BorderRadius.circular(itemRadius),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(itemRadius),
          onTap: action.enabled
              ? () => Navigator.of(context).pop(actionIndex)
              : null,
          child: Padding(
            padding: dec.itemPadding,
            child: Row(
              children: [
                IconTheme.merge(
                  data: IconThemeData(
                    size: M3ETheme.of(context).resolvedIconTheme.size,
                    color: action.enabled
                        ? fgColor
                        : fgColor.withValues(
                            alpha: M3EButtonConstants.kDisabledForegroundAlpha,
                          ),
                  ),
                  child: _overflowMenuLeading(actionIndex),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: M3ETheme.of(context).typeScale.labelLarge.copyWith(
                      color: action.enabled
                          ? fgColor
                          : fgColor.withValues(
                              alpha: M3EButtonConstants.kDisabledForegroundAlpha,
                            ),
                    ),
                    child: _overflowMenuTitle(actionIndex),
                  ),
                ),
                if (selected)
                  dec.trailing ??
                      Icon(M3EIcons.check_rounded, color: fgColor, size: M3ETheme.of(context).resolvedIconTheme.size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _overflowMenuLeading(int index) {
    final action = widget.actions[index];
    final Widget? icon = _isToggleActionSelected(index)
        ? (action.checkedIcon ?? action.icon)
        : action.icon;
    return icon ?? const SizedBox.shrink();
  }

  Widget _overflowMenuTitle(int index) {
    final action = widget.actions[index];
    if (_isToggleActionSelected(index)) {
      return action.checkedLabel ?? action.label ?? Text('Option ${index + 1}');
    }
    return action.label ?? action.checkedLabel ?? Text('Option ${index + 1}');
  }
}
