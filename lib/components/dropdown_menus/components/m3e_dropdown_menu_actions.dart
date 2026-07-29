part of '../m3e_dropdown_menus.dart';

/// Open / close / selection helpers for [_M3EDropdownMenuState].
extension _M3EDropdownMenuActions<T> on _M3EDropdownMenuState<T> {
  void _open() {
    if (_controller.isOpen && _portalController.isShowing) {
      return;
    }
    if (!widget.enabled || _isLoading) {
      return;
    }

    if (!_controller.isOpen) {
      _controller.setOpen(open: true);
    }

    _resolveOpeningDirection();
    _expandCtrl.motion = widget.openMotion.toMotion();
    _arrowCtrl.motion = widget.openMotion.toMotion();
    _expandCtrl.animateTo(1);
    _arrowCtrl.animateTo(math.pi);
    _portalController.show();
  }

  void _resolveOpeningDirection() {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      return;
    }

    final renderBoxSize = renderBox.size;
    final renderBoxOffset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - renderBoxOffset.dy - renderBoxSize.height;
    final spaceAbove = renderBoxOffset.dy;

    switch (widget.dropdownStyle.expandDirection) {
      case M3EDropdownExpandDirection.down:
        _openingShowOnTop = false;
      case M3EDropdownExpandDirection.up:
        _openingShowOnTop = true;
      case M3EDropdownExpandDirection.auto:
        _openingShowOnTop =
            spaceBelow < widget.dropdownStyle.maxHeight &&
            spaceAbove > spaceBelow;
    }
  }

  void _close() {
    if (!_controller.isOpen && !_portalController.isShowing) {
      return;
    }

    if (_controller.isOpen) {
      _controller.setOpen(open: false);
    }
    _expandCtrl.motion = widget.closeMotion.toMotion();
    _arrowCtrl.motion = widget.closeMotion.toMotion();
    _expandCtrl.animateTo(0);
    _arrowCtrl.animateTo(0);
    _searchTextController.clear();
    _searchDebounce?.cancel();
  }

  void _toggle() {
    if (!widget.enabled || _isLoading) {
      return;
    }
    _applyHaptic();
    if (_controller.isOpen) {
      _close();
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      _open();
    }
  }

  void _applyHaptic() {
    M3EHaptics.trigger(widget.haptic);
  }

  void _onItemTap(M3EDropdownItem<T> item) {
    if (item.disabled) {
      return;
    }
    _applyHaptic();

    if (widget.singleSelect) {
      _selectSingleItem(item);
      return;
    }
    if (!_canSelectMultiItem(item)) {
      return;
    }
    if (_tryAnimateChipDeselect(item)) {
      return;
    }

    _controller.toggleWhere((e) => e == item);
    _formFieldKey.currentState?.didChange(_controller.selectedItems);
  }

  void _selectSingleItem(M3EDropdownItem<T> item) {
    _controller.toggleOnly(item);
    WidgetsBinding.instance.addPostFrameCallback((_) => _close());
  }

  bool _canSelectMultiItem(M3EDropdownItem<T> item) {
    if (item.selected) {
      return true;
    }
    if (widget.maxSelections <= 0) {
      return true;
    }
    return _controller.selectedItems.length < widget.maxSelections;
  }

  bool _tryAnimateChipDeselect(M3EDropdownItem<T> item) {
    if (!item.selected || !widget.showChipAnimation) {
      return false;
    }

    final optionKey = item.value as Object;
    final chipKey = _chipKeys[optionKey];
    if (chipKey?.currentState == null) {
      return false;
    }

    final selected = _controller.selectedItems;
    final maxCount = widget.chipStyle.maxDisplayCount;
    final displayOptions = maxCount != null && selected.length > maxCount
        ? selected.take(maxCount).toList()
        : selected;
    final idx = displayOptions.indexWhere((e) => e.value == item.value);
    if (idx < 0) {
      return false;
    }

    _handleChipRemove(item, optionKey, chipKey!, displayOptions, idx);
    return true;
  }
}
