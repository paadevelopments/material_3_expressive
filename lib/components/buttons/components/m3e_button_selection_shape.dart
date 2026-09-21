part of '../m3e_buttons.dart';

extension _M3EButtonSelectionShape on _M3EButtonState {
  ({
    BorderRadius defaultShape,
    BorderRadius pressedShape,
    BorderRadius hoveredShape,
    bool freezeLeft,
    bool freezeRight,
  })
  _resolveSelectionShapes(M3EButtonMeasurements measurements) {
    final explicit = widget.decorationBorderRadius;
    final fullyRound = BorderRadius.circular(measurements.height / 2);
    final square = BorderRadius.circular(
      _buttonTheme.squareRadius(widget.size),
    );
    final unselected = widget.decorationUnselectedRadius != null
        ? BorderRadius.circular(widget.decorationUnselectedRadius!)
        : explicit != null
        ? BorderRadius.circular(explicit)
        : widget.shape == M3EButtonShape.round
        ? fullyRound
        : square;
    final selected = widget.decorationSelectedRadius != null
        ? BorderRadius.circular(widget.decorationSelectedRadius!)
        : explicit != null
        ? BorderRadius.circular(explicit)
        : widget.shape == M3EButtonShape.round
        ? square
        : fullyRound;
    final pressed = BorderRadius.circular(
      widget.decorationPressedRadius ??
          explicit ??
          _buttonTheme.pressedRadius(widget.size),
    );
    final hovered = widget.decoration?.hoveredRadius != null
        ? BorderRadius.circular(widget.decoration!.hoveredRadius!)
        : explicit != null
        ? BorderRadius.circular(explicit)
        : BorderRadius.circular(_buttonTheme.hoveredRadius(widget.size));

    if (!widget.isGroupConnected) {
      return (
        defaultShape: _isSelected ? selected : unselected,
        pressedShape: pressed,
        hoveredShape: hovered,
        freezeLeft: false,
        freezeRight: false,
      );
    }

    final groupTheme = M3ETheme.of(context).buttonGroupTheme;
    final outerRadius =
        explicit ??
        (widget.shape == M3EButtonShape.round
            ? measurements.height / 2
            : _buttonTheme.squareRadius(widget.size));
    final innerRadius =
        explicit ??
        widget.decorationConnectedInnerRadius ??
        groupTheme.connectedInnerRadius;
    final pressedInnerRadius =
        widget.decorationPressedRadius ??
        explicit ??
        groupTheme.connectedPressedInnerRadius;
    final resting = BorderRadiusDirectional.horizontal(
      start: Radius.circular(widget.isFirstInGroup ? outerRadius : innerRadius),
      end: Radius.circular(widget.isLastInGroup ? outerRadius : innerRadius),
    ).resolve(Directionality.of(context));
    final connectedPressed = BorderRadiusDirectional.horizontal(
      start: Radius.circular(
        widget.isFirstInGroup ? outerRadius : pressedInnerRadius,
      ),
      end: Radius.circular(
        widget.isLastInGroup ? outerRadius : pressedInnerRadius,
      ),
    ).resolve(Directionality.of(context));
    final hoverInnerRadius =
        widget.decoration?.hoveredRadius ??
        explicit ??
        _buttonTheme.hoveredRadius(widget.size);
    final connectedHovered = BorderRadiusDirectional.horizontal(
      start: Radius.circular(
        widget.isFirstInGroup ? outerRadius : hoverInnerRadius,
      ),
      end: Radius.circular(
        widget.isLastInGroup ? outerRadius : hoverInnerRadius,
      ),
    ).resolve(Directionality.of(context));
    return (
      defaultShape: _isSelected ? selected : resting,
      pressedShape: connectedPressed,
      hoveredShape: connectedHovered,
      freezeLeft: false,
      freezeRight: false,
    );
  }
}
