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
    // Spec (buttons + button groups): hover keeps resting shape; press morphs.
    final restingShape = _isSelected ? selected : unselected;
    final hovered = widget.decoration?.hoveredRadius != null
        ? BorderRadius.circular(widget.decoration!.hoveredRadius!)
        : restingShape;

    if (!widget.isGroupConnected) {
      return (
        defaultShape: restingShape,
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
            : groupTheme.connectedOuterSquareRadiusFor(widget.size));
    final innerRadius =
        explicit ??
        widget.decorationConnectedInnerRadius ??
        groupTheme.connectedInnerRadiusFor(widget.size);
    final pressedInnerRadius =
        widget.decorationPressedRadius ??
        explicit ??
        groupTheme.connectedPressedInnerRadiusFor(widget.size);
    final selectedInnerRadius =
        widget.decorationSelectedRadius ??
        explicit ??
        groupTheme.connectedSelectedInnerRadiusFor(measurements.height);
    final resting = BorderRadiusDirectional.horizontal(
      start: Radius.circular(widget.isFirstInGroup ? outerRadius : innerRadius),
      end: Radius.circular(widget.isLastInGroup ? outerRadius : innerRadius),
    ).resolve(Directionality.of(context));
    final connectedSelected = BorderRadius.circular(selectedInnerRadius);
    final connectedPressed = BorderRadiusDirectional.horizontal(
      start: Radius.circular(
        widget.isFirstInGroup ? outerRadius : pressedInnerRadius,
      ),
      end: Radius.circular(
        widget.isLastInGroup ? outerRadius : pressedInnerRadius,
      ),
    ).resolve(Directionality.of(context));
    final connectedResting = _isSelected ? connectedSelected : resting;
    final connectedHovered = widget.decoration?.hoveredRadius != null
        ? BorderRadiusDirectional.horizontal(
            start: Radius.circular(
              widget.isFirstInGroup
                  ? outerRadius
                  : widget.decoration!.hoveredRadius!,
            ),
            end: Radius.circular(
              widget.isLastInGroup
                  ? outerRadius
                  : widget.decoration!.hoveredRadius!,
            ),
          ).resolve(Directionality.of(context))
        : connectedResting;
    return (
      defaultShape: connectedResting,
      pressedShape: connectedPressed,
      hoveredShape: connectedHovered,
      freezeLeft: false,
      freezeRight: false,
    );
  }
}
