import 'package:flutter/material.dart';
import '../../buttons/enums/m3e_button_enums.dart';
import 'm3e_list_theme.dart';

/// Immutable visual and interaction configuration for dismissible M3E lists.
class M3EDismissibleListStyle {
  /// Outer corner radius for first / last / single items.
  final double outerRadius;

  /// Border radius applied to the dragged card once it crosses the dismiss
  /// threshold. Defaults to [outerRadius].
  final double? selectedBorderRadius;

  /// Inner corner radius for middle items.
  final double innerRadius;

  /// Vertical gap between cards.
  final double gap;

  /// Card background colour.
  final Color? color;

  /// Inner padding of each card's content area.
  final EdgeInsetsGeometry? padding;

  /// Outer margin around each card.
  final EdgeInsetsGeometry? margin;

  /// Optional border drawn on every card.
  final BorderSide? border;

  /// Resting elevation.
  final double elevation;

  /// Background revealed when swiping start‑to‑end (left→right in LTR).
  final Widget? background;

  /// Background revealed when swiping end‑to‑start (right→left in LTR).
  final Widget? secondaryBackground;

  /// Background Border Radius
  final double backgroundBorderRadius;

  /// Secondary Background Border Radius
  final double? secondaryBackgroundBorderRadius;

  /// Collapse speed. Higher = faster.
  final double collapseSpeed;

  final Color? splashColor;
  final Color? highlightColor;
  final InteractiveInkFeatureFactory? splashFactory;

  /// Whether detected gestures provide feedback.
  final bool enableFeedback;

  /// Haptic intensity on tap.
  final M3EHapticFeedback hapticOnTap;

  /// Fraction of card width the user must drag before a dismiss triggers.
  final double dismissThreshold;

  /// Haptic intensity when the drag crosses / re‑crosses.
  final M3EHapticFeedback hapticOnThreshold;

  /// Fire continuous light haptics during the drag.
  final bool dismissHapticStream;

  /// Maximum pixel offset applied to neighbouring cards.
  final double neighbourPull;

  /// How many cards are affected.
  final int neighbourReach;

  const M3EDismissibleListStyle({
    this.outerRadius = M3EListDismissibleTheme.defaultOuterRadius,
    this.selectedBorderRadius,
    this.innerRadius = M3EListDismissibleTheme.defaultInnerRadius,
    this.gap = M3EListDismissibleTheme.defaultGap,
    this.color,
    this.padding = M3EListDismissibleTheme.defaultItemPadding,
    this.margin,
    this.border,
    this.elevation = 0.0,
    this.background,
    this.secondaryBackground,
    this.backgroundBorderRadius =
        M3EListDismissibleTheme.defaultBackgroundBorderRadius,
    this.secondaryBackgroundBorderRadius =
        M3EListDismissibleTheme.defaultBackgroundBorderRadius,
    this.collapseSpeed = M3EListDismissibleTheme.defaultCollapseSpeed,
    this.splashColor,
    this.highlightColor,
    this.splashFactory,
    this.enableFeedback = true,
    this.hapticOnTap = M3EHapticFeedback.none,
    this.dismissThreshold = M3EListDismissibleTheme.defaultDismissThreshold,
    this.hapticOnThreshold = M3EHapticFeedback.light,
    this.dismissHapticStream = false,
    this.neighbourPull = M3EListDismissibleTheme.defaultNeighbourPull,
    this.neighbourReach = M3EListDismissibleTheme.defaultNeighbourReach,
  });
}
