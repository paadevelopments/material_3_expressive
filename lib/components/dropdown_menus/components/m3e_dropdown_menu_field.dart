part of '../m3e_dropdown_menus.dart';

/// Field builders for [_M3EDropdownMenuState].
extension _M3EDropdownMenuField<T> on _M3EDropdownMenuState<T> {
  BorderRadius _buildEffectiveFieldRadius() {
    final fd = widget.fieldStyle;
    final baseRadius = _controller.isOpen && fd.selectedBorderRadius != null
        ? BorderRadius.circular(fd.selectedBorderRadius!)
        : (fd.borderRadius ??
              BorderRadius.circular(
                widget.dropdownStyle.containerRadius ?? widget.containerRadius,
              ));

    if (_isPressedField && fd.pressedRadius != null) {
      return BorderRadius.circular(fd.pressedRadius!);
    }
    if (_isHoveredField && fd.hoverRadius != null) {
      return BorderRadius.circular(fd.hoverRadius!);
    }
    return baseRadius;
  }

  Widget _buildField(
    BuildContext context,
    FormFieldState<List<M3EDropdownItem<T>>?> formState,
  ) {
    final m3eTheme = M3ETheme.of(context);
    final menuTheme = m3eTheme.dropdownMenuTheme;
    final scheme = m3eTheme.colorScheme;
    final type = m3eTheme.typeScale;
    final fd = widget.fieldStyle;

    final bgColor =
        fd.backgroundColor ?? menuTheme.fieldBackgroundColor(scheme);
    final fgColor =
        fd.foregroundColor ?? menuTheme.fieldForegroundColor(scheme);
    final borderSide =
        (formState.hasError
            ? fd.errorBorder
            : (_controller.isOpen ? fd.focusedBorder : fd.border)) ??
        BorderSide.none;

    final isOpenChanged = _lastIsOpen != _controller.isOpen;
    _lastIsOpen = _controller.isOpen;

    final trailing = _buildFieldTrailing(context, fgColor);
    final content = _buildFieldContent(
      context,
      fgColor,
      menuTheme,
      type,
      scheme,
    );

    return Padding(
      padding: fd.margin,
      child: _buildFieldBody(
        fd: fd,
        bgColor: bgColor,
        fgColor: fgColor,
        borderSide: borderSide,
        isOpenChanged: isOpenChanged,
        trailing: trailing,
        content: content,
      ),
    );
  }

  Widget? _buildFieldTrailing(BuildContext context, Color fgColor) {
    final fd = widget.fieldStyle;
    final m3eTheme = M3ETheme.of(context);

    if (_isLoading) {
      return fd.loadingWidget ??
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
    }
    if (fd.showClearIcon &&
        widget.enabled &&
        _controller.selectedItems.isNotEmpty) {
      return _buildClearTrailing(fgColor, m3eTheme, fd);
    }
    if (fd.suffixIcon != null) {
      return _buildSuffixTrailing(fd);
    }
    if (fd.showArrow) {
      return AnimatedBuilder(
        animation: _arrowCtrl,
        builder: (context, child) {
          return Transform.rotate(
            angle: _arrowCtrl.value,
            child: Icon(Icons.keyboard_arrow_down_rounded, color: fgColor),
          );
        },
      );
    }
    return null;
  }

  Widget _buildClearTrailing(
    Color fgColor,
    M3EThemeData m3eTheme,
    M3EDropdownFieldStyle fd,
  ) {
    return Tooltip(
      message: 'Clear selection',
      child: Semantics(
        label: 'Clear all selections',
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _controller.clearAll();
            _formFieldKey.currentState?.didChange(_controller.selectedItems);
          },
          child:
              fd.clearIcon ??
              Icon(
                Icons.clear,
                color: fgColor,
                size: m3eTheme.resolvedIconTheme.size,
              ),
        ),
      ),
    );
  }

  Widget _buildSuffixTrailing(M3EDropdownFieldStyle fd) {
    if (fd.animateSuffixIcon) {
      return AnimatedRotation(
        turns: _controller.isOpen ? 0.5 : 0,
        duration: const Duration(milliseconds: 200),
        child: fd.suffixIcon,
      );
    }
    return fd.suffixIcon!;
  }

  Widget _buildFieldContent(
    BuildContext context,
    Color fgColor,
    M3EDropdownMenuTheme menuTheme,
    M3ETypeScale type,
    M3EColorScheme scheme,
  ) {
    final fd = widget.fieldStyle;
    final selected = _controller.selectedItems;

    if (widget.selectedItemBuilder != null && selected.isNotEmpty) {
      return _buildCustomSelectedContent(context, selected, fgColor);
    }
    if (widget.showChipAnimation && selected.isNotEmpty) {
      return _buildChips(context, selected, fgColor);
    }
    if (widget.singleSelect && selected.isNotEmpty) {
      return Text(
        selected.first.label,
        style:
            fd.selectedTextStyle ?? menuTheme.selectedTextStyle(type, scheme),
        overflow: TextOverflow.ellipsis,
      );
    }
    return Text(
      fd.hintText ?? 'Select',
      style: fd.hintStyle ?? menuTheme.hintTextStyle(type, scheme),
    );
  }

  Widget _buildCustomSelectedContent(
    BuildContext context,
    List<M3EDropdownItem<T>> selected,
    Color fgColor,
  ) {
    if (widget.showChipAnimation) {
      return _buildChips(context, selected, fgColor);
    }

    final children = selected
        .map((o) => widget.selectedItemBuilder!(o))
        .toList();
    if (widget.chipStyle.wrap) {
      return Wrap(
        spacing: widget.chipStyle.spacing,
        runSpacing: widget.chipStyle.runSpacing,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: children,
      );
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1)
              SizedBox(width: widget.chipStyle.spacing),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldBody({
    required M3EDropdownFieldStyle fd,
    required Color bgColor,
    required Color fgColor,
    required BorderSide borderSide,
    required bool isOpenChanged,
    required Widget? trailing,
    required Widget content,
  }) {
    final contentRow = Row(
      children: [
        if (fd.prefixIcon != null) ...[
          fd.prefixIcon!,
          const SizedBox(width: 8),
        ],
        Expanded(child: content),
        if (trailing != null) ...[const SizedBox(width: 8), trailing],
      ],
    );

    final duration = isOpenChanged
        ? const Duration(milliseconds: 20)
        : const Duration(milliseconds: 40);

    return TweenAnimationBuilder<BorderRadius?>(
      duration: duration,
      curve: Curves.easeOut,
      tween: BorderRadiusTween(
        begin: _buildEffectiveFieldRadius(),
        end: _buildEffectiveFieldRadius(),
      ),
      builder: (context, animatedRadius, child) {
        return _buildFieldMaterial(
          fd: fd,
          bgColor: bgColor,
          fgColor: fgColor,
          borderSide: borderSide,
          radius: animatedRadius ?? _buildEffectiveFieldRadius(),
          child: child!,
        );
      },
      child: contentRow,
    );
  }

  Widget _buildFieldMaterial({
    required M3EDropdownFieldStyle fd,
    required Color bgColor,
    required Color fgColor,
    required BorderSide borderSide,
    required BorderRadius radius,
    required Widget child,
  }) {
    return Material(
      color: bgColor,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: radius, side: borderSide),
      child: InkWell(
        splashFactory: fd.splashFactory ?? widget.splashFactory,
        splashColor: fd.splashColor,
        highlightColor: fd.highlightColor,
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return fgColor.withValues(alpha: 0.10);
          }
          if (states.contains(WidgetState.hovered)) {
            return fgColor.withValues(alpha: 0.05);
          }
          return Colors.transparent;
        }),
        mouseCursor: widget.enabled
            ? (fd.mouseCursor ?? SystemMouseCursors.click)
            : SystemMouseCursors.forbidden,
        onTap: widget.enabled ? _toggle : null,
        onHover: (hover) => setState(() => _isHoveredField = hover),
        onTapDown: (_) => setState(() => _isPressedField = true),
        onTapUp: (_) => setState(() => _isPressedField = false),
        onTapCancel: () => setState(() => _isPressedField = false),
        child: Padding(padding: fd.padding, child: child),
      ),
    );
  }
}
