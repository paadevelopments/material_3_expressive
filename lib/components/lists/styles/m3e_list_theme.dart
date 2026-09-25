import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../cards/enums/m3e_card_variant.dart';
import '../enums/m3e_list_enums.dart';
import 'm3e_list_reorder_state.dart';
import 'm3e_list_selection_state.dart';

/// Theme values for `M3EListItem`.
@immutable
class M3EListItemTheme {
  /// M3EListItemTheme.
  const M3EListItemTheme({
    this.appearance = M3EListAppearance.expressive,
    this.style = M3EListStyle.segmented,
    this.horizontalPadding = 16,
    this.verticalPadding = 10,
    this.baselineVerticalPadding = 8,
    this.threeLineVerticalPadding = 12,
    this.minHeight = 56,
    this.twoLineHeight = 72,
    this.threeLineHeight = 88,
    this.iconSize = 20,
    this.baselineIconSize = 24,
    this.gap = 12,
    this.baselineGap = 16,
    this.avatarSize = 40,
    this.leadingImageSize = 56,
    this.leadingImageRadius = 8,
    this.leadingVideoWidth = 100,
    this.leadingVideoHeight = 56,
    this.smallLeadingVideoWidth = 100,
    this.smallLeadingVideoHeight = 56,
    this.largeLeadingVideoWidth = 114,
    this.largeLeadingVideoHeight = 64,
    this.focusIndicatorThickness = 3,
    this.focusIndicatorInset = 3,
    this.dividerThickness = 1,
    this.dividerLeadingInset = 16,
    this.dividerTrailingInset = 16,
    this.leadingIconTopPadding = 8,
    this.leadingIconTopPaddingTall = 12,
    this.minTarget = 48,
    this.selectedRadius = 16,
    this.hoverOpacity = M3EStateOpacity.hover,
    this.focusOpacity = M3EStateOpacity.focus,
    this.pressedOpacity = M3EStateOpacity.pressed,
    this.disabledStateOpacity = 0.1,
    this.draggedStateOpacity = M3EStateOpacity.dragged,
    this.disabledContentOpacity = M3EStateOpacity.disabledContent,
    this.draggedElevation = M3EElevation.level2,
    this.variant = M3ECardVariant.filled,
    this.border,
    this.containerColor,
    this.selectedContainerColor,
    this.labelColor,
    this.supportingColor,
    this.iconColorOverride,
    this.selectedContentColor,
    this.selectedStateIconColor,
    this.avatarColor,
    this.avatarLabelColor,
    this.dividerColor,
    this.focusIndicatorColor,
    this.stateLayerColor,
  });

  /// defaults.

  static const M3EListItemTheme defaults = M3EListItemTheme();

  /// Expressive or baseline token set.
  final M3EListAppearance appearance;

  /// Segmented resting container, or a standard list with no rest fill.
  final M3EListStyle style;

  /// Leading and trailing inset.
  final double horizontalPadding;

  /// Expressive top and bottom inset.
  final double verticalPadding;

  /// Baseline top and bottom inset for short items.
  final double baselineVerticalPadding;

  /// Baseline top and bottom inset for three-line or large-leading items.
  final double threeLineVerticalPadding;

  /// One-line container height.
  final double minHeight;

  /// Two-line container height.
  final double twoLineHeight;

  /// Three-line container height.
  final double threeLineHeight;

  /// Expressive leading and trailing icon size.
  final double iconSize;

  /// Baseline leading and trailing icon size.
  final double baselineIconSize;

  /// Expressive gap between slots.
  final double gap;

  /// Baseline gap between slots.
  final double baselineGap;

  /// Leading avatar diameter.
  final double avatarSize;

  /// Leading image width and height.
  final double leadingImageSize;

  /// Expressive leading image corner radius.
  final double leadingImageRadius;

  /// Generic leading video width.
  final double leadingVideoWidth;

  /// Generic leading video height.
  final double leadingVideoHeight;

  /// Small leading video width.
  final double smallLeadingVideoWidth;

  /// Small leading video height.
  final double smallLeadingVideoHeight;

  /// Large leading video width.
  final double largeLeadingVideoWidth;

  /// Large leading video height.
  final double largeLeadingVideoHeight;

  /// Keyboard focus ring thickness.
  final double focusIndicatorThickness;

  /// Keyboard focus ring inset (spec offset is negative).
  final double focusIndicatorInset;

  /// Divider thickness.
  final double dividerThickness;

  /// Divider leading inset.
  final double dividerLeadingInset;

  /// Divider trailing inset.
  final double dividerTrailingInset;

  /// Baseline leading-icon top inset.
  final double leadingIconTopPadding;

  /// Baseline leading-icon top inset when the item is 88 or taller.
  final double leadingIconTopPaddingTall;

  /// Minimum tap target.
  final double minTarget;

  /// Selected corner radius.
  final double selectedRadius;

  /// Hover state-layer opacity.
  final double hoverOpacity;

  /// Focus state-layer opacity.
  final double focusOpacity;

  /// Pressed state-layer opacity.
  final double pressedOpacity;

  /// Disabled state-layer opacity.
  final double disabledStateOpacity;

  /// Dragged state-layer opacity.
  final double draggedStateOpacity;

  /// Disabled content opacity.
  final double disabledContentOpacity;

  /// Dragged elevation.
  final double draggedElevation;

  /// Card variant for outlined list rows.
  final M3ECardVariant variant;

  /// Optional outline; null keeps the variant default.
  final BorderSide? border;

  /// Container override. Null uses [M3EColorScheme.surface].
  final Color? containerColor;

  /// Selected container override. Null uses secondary container.
  final Color? selectedContainerColor;

  /// Label override. Null uses on-surface.
  final Color? labelColor;

  /// Supporting, overline, and trailing text override.
  final Color? supportingColor;

  /// Unselected icon override. Null uses on-surface variant.
  final Color? iconColorOverride;

  /// Selected label and icon override. Null uses on-secondary container.
  final Color? selectedContentColor;

  /// Selected hover, focus, and press icon override. Null uses on-surface.
  final Color? selectedStateIconColor;

  /// Avatar container override. Null uses primary container.
  final Color? avatarColor;

  /// Avatar label override. Null uses on-primary container.
  final Color? avatarLabelColor;

  /// Divider override. Null uses outline variant.
  final Color? dividerColor;

  /// Focus ring override. Null uses secondary.
  final Color? focusIndicatorColor;

  /// State-layer override. Null uses on-surface.
  final Color? stateLayerColor;

  /// Whether this theme uses baseline tokens.
  bool get isBaseline => appearance == M3EListAppearance.baseline;

  /// Corner radius for [resting] after hover, focus, press, drag, and selection.
  ///
  /// Segmented rest keeps [resting] (4dp inner / 16dp outer). Active states
  /// and a selected row use [selectedRadius]. Standard rest is square.
  /// Baseline stays square until the row is selected.
  BorderRadius radiusFor({
    required BorderRadius resting,
    required bool selected,
    required bool hovered,
    required bool focused,
    required bool pressed,
    required bool dragged,
  }) {
    if (isBaseline) {
      if (selected) {
        return BorderRadius.circular(selectedRadius);
      }
      return BorderRadius.zero;
    }
    final bool active = selected || hovered || focused || pressed || dragged;
    if (active) {
      return BorderRadius.circular(selectedRadius);
    }
    if (style == M3EListStyle.standard) {
      return BorderRadius.zero;
    }
    return resting;
  }

  /// Whether a resting container is painted.
  bool restingContainer({
    required bool selected,
    required bool hovered,
    required bool focused,
    required bool pressed,
    required bool dragged,
  }) {
    if (selected || hovered || focused || pressed || dragged) {
      return true;
    }
    return isBaseline || style == M3EListStyle.segmented;
  }

  /// Top and bottom inset for the current appearance.
  double verticalPaddingFor({required bool tall, required bool largeLeading}) {
    if (isBaseline && (tall || largeLeading)) {
      return threeLineVerticalPadding;
    }
    if (isBaseline) {
      return baselineVerticalPadding;
    }
    return verticalPadding;
  }

  /// Icon size for the current appearance.
  double resolvedIconSize() => isBaseline ? baselineIconSize : iconSize;

  /// Slot gap for the current appearance.
  double resolvedGap() => isBaseline ? baselineGap : gap;

  /// Container height for [lines] of text (1, 2, or 3+).
  double heightForLines(int lines) {
    if (lines >= 3) {
      return threeLineHeight;
    }
    if (lines == 2) {
      return twoLineHeight;
    }
    return minHeight;
  }

  /// Baseline leading-icon top inset.
  double leadingIconTopFor({required bool tall}) =>
      tall ? leadingIconTopPaddingTall : leadingIconTopPadding;

  /// Resting container color.
  Color resolveContainer(M3EColorScheme scheme) =>
      containerColor ?? scheme.surface;

  /// selectedColor.
  Color selectedColor(M3EColorScheme scheme) =>
      selectedContainerColor ?? scheme.secondaryContainer;

  /// Disabled selected container.
  Color disabledSelectedColor(M3EColorScheme scheme) =>
      scheme.onSurface.withValues(alpha: disabledContentOpacity);

  /// iconColor.
  Color iconColor(
    M3EColorScheme scheme, {
    bool selected = false,
    bool stateIcon = false,
    bool trailing = false,
  }) {
    if (selected && stateIcon) {
      return selectedStateIconColor ?? scheme.onSurface;
    }
    if (selected) {
      return selectedContentColor ?? scheme.onSecondaryContainer;
    }
    if (trailing) {
      return iconColorOverride ?? scheme.onSurface;
    }
    return iconColorOverride ?? scheme.onSurfaceVariant;
  }

  /// State-layer role color.
  Color resolveStateLayer(M3EColorScheme scheme) =>
      stateLayerColor ?? scheme.onSurface;

  /// Opacity for the active interaction, including disabled.
  double stateOpacity({
    required bool enabled,
    required bool hovered,
    required bool focused,
    required bool pressed,
    required bool dragged,
  }) {
    if (!enabled) {
      return disabledStateOpacity;
    }
    if (dragged) {
      return draggedStateOpacity;
    }
    if (pressed) {
      return pressedOpacity;
    }
    if (focused) {
      return focusOpacity;
    }
    if (hovered) {
      return hoverOpacity;
    }
    return 0;
  }

  /// Avatar container color.
  Color resolveAvatar(M3EColorScheme scheme) =>
      avatarColor ?? scheme.primaryContainer;

  /// Avatar label color.
  Color resolveAvatarLabel(M3EColorScheme scheme) =>
      avatarLabelColor ?? scheme.onPrimaryContainer;

  /// Divider color.
  Color resolveDivider(M3EColorScheme scheme) => dividerColor ?? scheme.outline;

  /// Focus ring color.
  Color resolveFocusIndicator(M3EColorScheme scheme) =>
      focusIndicatorColor ?? scheme.secondary;

  /// overlineStyle.
  TextStyle overlineStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    bool selected = false,
  }) => type.labelSmall.copyWith(
    color: selected
        ? (selectedContentColor ?? scheme.onSecondaryContainer)
        : (supportingColor ?? scheme.onSurfaceVariant),
  );

  /// headlineStyle.
  TextStyle headlineStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    bool selected = false,
  }) => type.bodyLarge.copyWith(
    color: selected
        ? (selectedContentColor ?? scheme.onSecondaryContainer)
        : (labelColor ?? scheme.onSurface),
  );

  /// supportingStyle.
  TextStyle supportingStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    bool selected = false,
  }) => type.bodyMedium.copyWith(
    color: selected
        ? (selectedContentColor ?? scheme.onSecondaryContainer)
        : (supportingColor ?? scheme.onSurfaceVariant),
  );

  /// Trailing meta text.
  TextStyle trailingStyle(
    M3ETypeScale type,
    M3EColorScheme scheme, {
    bool selected = false,
  }) => type.labelSmall.copyWith(
    color: selected
        ? (selectedContentColor ?? scheme.onSecondaryContainer)
        : (supportingColor ?? scheme.onSurfaceVariant),
  );

  /// Avatar initial.
  TextStyle avatarLabelStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.titleMedium.copyWith(color: resolveAvatarLabel(scheme));

  /// copyWith.
  M3EListItemTheme copyWith({
    M3EListAppearance? appearance,
    M3EListStyle? style,
    double? horizontalPadding,
    double? verticalPadding,
    double? baselineVerticalPadding,
    double? threeLineVerticalPadding,
    double? minHeight,
    double? twoLineHeight,
    double? threeLineHeight,
    double? iconSize,
    double? baselineIconSize,
    double? gap,
    double? baselineGap,
    double? avatarSize,
    double? leadingImageSize,
    double? leadingImageRadius,
    double? leadingVideoWidth,
    double? leadingVideoHeight,
    double? smallLeadingVideoWidth,
    double? smallLeadingVideoHeight,
    double? largeLeadingVideoWidth,
    double? largeLeadingVideoHeight,
    double? focusIndicatorThickness,
    double? focusIndicatorInset,
    double? dividerThickness,
    double? dividerLeadingInset,
    double? dividerTrailingInset,
    double? leadingIconTopPadding,
    double? leadingIconTopPaddingTall,
    double? minTarget,
    double? selectedRadius,
    double? hoverOpacity,
    double? focusOpacity,
    double? pressedOpacity,
    double? disabledStateOpacity,
    double? draggedStateOpacity,
    double? disabledContentOpacity,
    double? draggedElevation,
    M3ECardVariant? variant,
    BorderSide? border,
    Color? containerColor,
    Color? selectedContainerColor,
    Color? labelColor,
    Color? supportingColor,
    Color? iconColorOverride,
    Color? selectedContentColor,
    Color? selectedStateIconColor,
    Color? avatarColor,
    Color? avatarLabelColor,
    Color? dividerColor,
    Color? focusIndicatorColor,
    Color? stateLayerColor,
  }) {
    return M3EListItemTheme(
      appearance: appearance ?? this.appearance,
      style: style ?? this.style,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      baselineVerticalPadding:
          baselineVerticalPadding ?? this.baselineVerticalPadding,
      threeLineVerticalPadding:
          threeLineVerticalPadding ?? this.threeLineVerticalPadding,
      minHeight: minHeight ?? this.minHeight,
      twoLineHeight: twoLineHeight ?? this.twoLineHeight,
      threeLineHeight: threeLineHeight ?? this.threeLineHeight,
      iconSize: iconSize ?? this.iconSize,
      baselineIconSize: baselineIconSize ?? this.baselineIconSize,
      gap: gap ?? this.gap,
      baselineGap: baselineGap ?? this.baselineGap,
      avatarSize: avatarSize ?? this.avatarSize,
      leadingImageSize: leadingImageSize ?? this.leadingImageSize,
      leadingImageRadius: leadingImageRadius ?? this.leadingImageRadius,
      leadingVideoWidth: leadingVideoWidth ?? this.leadingVideoWidth,
      leadingVideoHeight: leadingVideoHeight ?? this.leadingVideoHeight,
      smallLeadingVideoWidth:
          smallLeadingVideoWidth ?? this.smallLeadingVideoWidth,
      smallLeadingVideoHeight:
          smallLeadingVideoHeight ?? this.smallLeadingVideoHeight,
      largeLeadingVideoWidth:
          largeLeadingVideoWidth ?? this.largeLeadingVideoWidth,
      largeLeadingVideoHeight:
          largeLeadingVideoHeight ?? this.largeLeadingVideoHeight,
      focusIndicatorThickness:
          focusIndicatorThickness ?? this.focusIndicatorThickness,
      focusIndicatorInset: focusIndicatorInset ?? this.focusIndicatorInset,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      dividerLeadingInset: dividerLeadingInset ?? this.dividerLeadingInset,
      dividerTrailingInset: dividerTrailingInset ?? this.dividerTrailingInset,
      leadingIconTopPadding:
          leadingIconTopPadding ?? this.leadingIconTopPadding,
      leadingIconTopPaddingTall:
          leadingIconTopPaddingTall ?? this.leadingIconTopPaddingTall,
      minTarget: minTarget ?? this.minTarget,
      selectedRadius: selectedRadius ?? this.selectedRadius,
      hoverOpacity: hoverOpacity ?? this.hoverOpacity,
      focusOpacity: focusOpacity ?? this.focusOpacity,
      pressedOpacity: pressedOpacity ?? this.pressedOpacity,
      disabledStateOpacity: disabledStateOpacity ?? this.disabledStateOpacity,
      draggedStateOpacity: draggedStateOpacity ?? this.draggedStateOpacity,
      disabledContentOpacity:
          disabledContentOpacity ?? this.disabledContentOpacity,
      draggedElevation: draggedElevation ?? this.draggedElevation,
      variant: variant ?? this.variant,
      border: border ?? this.border,
      containerColor: containerColor ?? this.containerColor,
      selectedContainerColor:
          selectedContainerColor ?? this.selectedContainerColor,
      labelColor: labelColor ?? this.labelColor,
      supportingColor: supportingColor ?? this.supportingColor,
      iconColorOverride: iconColorOverride ?? this.iconColorOverride,
      selectedContentColor: selectedContentColor ?? this.selectedContentColor,
      selectedStateIconColor:
          selectedStateIconColor ?? this.selectedStateIconColor,
      avatarColor: avatarColor ?? this.avatarColor,
      avatarLabelColor: avatarLabelColor ?? this.avatarLabelColor,
      dividerColor: dividerColor ?? this.dividerColor,
      focusIndicatorColor: focusIndicatorColor ?? this.focusIndicatorColor,
      stateLayerColor: stateLayerColor ?? this.stateLayerColor,
    );
  }
}

/// Theme values for `M3ECardList`.
@immutable
class M3EListCardListTheme {
  /// defaultOuterRadius.
  static const double defaultOuterRadius = 16;

  /// defaultInnerRadius.
  static const double defaultInnerRadius = 4;

  /// defaultGap.
  static const double defaultGap = 2;

  /// defaultItemPadding.
  ///
  /// Zero so list items own the spec padding and rows are not padded twice.
  static const EdgeInsets defaultItemPadding = EdgeInsets.zero;

  /// M3EListCardListTheme.

  const M3EListCardListTheme({
    this.outerRadius = defaultOuterRadius,
    this.innerRadius = defaultInnerRadius,
    this.gap = defaultGap,
    this.itemPadding = defaultItemPadding,
    this.variant = M3ECardVariant.filled,
    this.border,
    this.radiusSpring = M3EMotion.expressiveSpatialDefault,
  });

  /// defaults.

  static const M3EListCardListTheme defaults = M3EListCardListTheme();

  /// outerRadius.

  final double outerRadius;

  /// innerRadius.
  final double innerRadius;

  /// gap.
  final double gap;

  /// itemPadding.
  final EdgeInsetsGeometry itemPadding;

  /// Card variant for each card-list item.
  final M3ECardVariant variant;

  /// Optional card outline; null keeps the variant default.
  final BorderSide? border;

  /// Corner-radius morph spring for card list items.
  final M3ESpring radiusSpring;

  /// Resting fill for [variant]. Outlined stays on surface.
  Color backgroundColor(M3EColorScheme scheme, {M3ECardVariant? variant}) {
    return switch (variant ?? this.variant) {
      M3ECardVariant.filled => scheme.surfaceContainerHighest,
      M3ECardVariant.elevated => scheme.surfaceContainerLow,
      M3ECardVariant.outlined => scheme.surface,
    };
  }

  /// copyWith.

  M3EListCardListTheme copyWith({
    double? outerRadius,
    double? innerRadius,
    double? gap,
    EdgeInsetsGeometry? itemPadding,
    M3ECardVariant? variant,
    BorderSide? border,
    M3ESpring? radiusSpring,
  }) {
    return M3EListCardListTheme(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      gap: gap ?? this.gap,
      itemPadding: itemPadding ?? this.itemPadding,
      variant: variant ?? this.variant,
      border: border ?? this.border,
      radiusSpring: radiusSpring ?? this.radiusSpring,
    );
  }
}

/// Theme values for dismissible list widgets.
///
/// Stack geometry ([defaultOuterRadius], [defaultInnerRadius], [defaultGap],
/// [defaultItemPadding]) matches [M3EListCardListTheme] so card and dismissible
/// lists share the same item layout defaults.
@immutable
class M3EListDismissibleTheme {
  /// defaultOuterRadius.
  static const double defaultOuterRadius =
      M3EListCardListTheme.defaultOuterRadius;

  /// defaultInnerRadius.
  static const double defaultInnerRadius =
      M3EListCardListTheme.defaultInnerRadius;

  /// defaultGap.
  static const double defaultGap = M3EListCardListTheme.defaultGap;

  /// defaultActionGap.
  ///
  /// Matches [defaultActionSpacing] / [defaultActionEdgePadding] so the gap
  /// between actions equals the gap between actions and the list item.
  static const double defaultActionGap = 2;

  /// defaultActionSpacing.
  static const double defaultActionSpacing = 2;

  /// defaultActionEdgePadding.
  static const double defaultActionEdgePadding = 2;

  /// Fraction of actions width at which the preview snaps open on release.
  static const double defaultActionPreviewThreshold = 0.35;

  /// Extra drag past the actions width before rubber-band overdrag.
  static const double defaultActionOverdragExtent = 24;

  /// Vertical inset subtracted from the row height for action pills.
  static const double defaultActionVerticalInset = 8;

  /// Minimum action / dismiss pill height.
  static const double defaultActionMinHeight = 28;

  /// Minimum visual width for action pills (keeps icons inside while revealing).
  static const double defaultActionMinWidth = 40;

  /// defaultDismissThreshold.
  static const double defaultDismissThreshold = 0.2;

  /// defaultNeighbourPull.
  static const double defaultNeighbourPull = 8;

  /// defaultNeighbourReach.
  static const int defaultNeighbourReach = 3;

  /// defaultBackgroundBorderRadius.
  static const double defaultBackgroundBorderRadius = 100;

  /// defaultCollapseSpeed.
  static const double defaultCollapseSpeed = 50;

  /// defaultItemPadding.
  static const EdgeInsets defaultItemPadding =
      M3EListCardListTheme.defaultItemPadding;

  /// M3EListDismissibleTheme.

  const M3EListDismissibleTheme({
    this.outerRadius = defaultOuterRadius,
    this.innerRadius = defaultInnerRadius,
    this.gap = defaultGap,
    this.actionGap = defaultActionGap,
    this.actionSpacing = defaultActionSpacing,
    this.actionEdgePadding = defaultActionEdgePadding,
    this.actionPreviewThreshold = defaultActionPreviewThreshold,
    this.actionOverdragExtent = defaultActionOverdragExtent,
    this.actionVerticalInset = defaultActionVerticalInset,
    this.actionMinHeight = defaultActionMinHeight,
    this.actionMinWidth = defaultActionMinWidth,
    this.dismissThreshold = defaultDismissThreshold,
    this.neighbourPull = defaultNeighbourPull,
    this.neighbourReach = defaultNeighbourReach,
    this.backgroundBorderRadius = defaultBackgroundBorderRadius,
    this.collapseSpeed = defaultCollapseSpeed,
    this.itemPadding = defaultItemPadding,
    this.neighbourSpring = const M3ESpring(stiffness: 800, damping: 0.7),
    this.reEngageSpring = const M3ESpring(stiffness: 800, damping: 0.9),
    this.detachPushSpring = const M3ESpring(stiffness: 800, damping: 0.95),
    this.roundnessSnapSpring = const M3ESpring(stiffness: 1000, damping: 0.4),
    this.springBackSpring = const M3ESpring(stiffness: 380, damping: 0.6),
    this.flySpring = const M3ESpring(stiffness: 400, damping: 0.8),
    this.collapseDamping = 0.8,
  });

  /// defaults.

  static const M3EListDismissibleTheme defaults = M3EListDismissibleTheme();

  /// outerRadius.

  final double outerRadius;

  /// innerRadius.
  final double innerRadius;

  /// gap.
  final double gap;

  /// Horizontal gap between a swiped card and its revealed action background.
  final double actionGap;

  /// Spacing between revealed swipe action buttons.
  final double actionSpacing;

  /// Horizontal padding at the leading / trailing edges of the action row.
  final double actionEdgePadding;

  /// Fraction of actions width required to snap the preview open on release.
  final double actionPreviewThreshold;

  /// Extra pixels past the actions width before rubber-band overdrag.
  final double actionOverdragExtent;

  /// Vertical inset subtracted from the list row height for action pills.
  final double actionVerticalInset;

  /// Minimum height for action / dismiss pills.
  final double actionMinHeight;

  /// Minimum visual width for action pills while revealing / hiding.
  final double actionMinWidth;

  /// dismissThreshold.
  final double dismissThreshold;

  /// neighbourPull.
  final double neighbourPull;

  /// neighbourReach.
  final int neighbourReach;

  /// backgroundBorderRadius.
  final double backgroundBorderRadius;

  /// collapseSpeed.
  final double collapseSpeed;

  /// itemPadding.
  final EdgeInsetsGeometry itemPadding;

  /// Neighbour fraction spring (base; stiffness scaled by multiplier).
  final M3ESpring neighbourSpring;

  /// Roundness re-engage spring (base; stiffness scaled by multiplier).
  final M3ESpring reEngageSpring;

  /// Detach push spring (base; stiffness scaled by multiplier).
  final M3ESpring detachPushSpring;

  /// Roundness snap spring (base; stiffness scaled by multiplier).
  final M3ESpring roundnessSnapSpring;

  /// Drag spring-back spring (base; stiffness scaled by speedMul).
  final M3ESpring springBackSpring;

  /// Fly-away spring (base; stiffness scaled by speedMul).
  final M3ESpring flySpring;

  /// Damping for collapse; stiffness still uses [collapseSpeed] × speedMul.
  final double collapseDamping;

  /// backgroundColor.

  Color backgroundColor(M3EColorScheme scheme) => scheme.surface;

  /// copyWith.

  M3EListDismissibleTheme copyWith({
    double? outerRadius,
    double? innerRadius,
    double? gap,
    double? actionGap,
    double? actionSpacing,
    double? actionEdgePadding,
    double? actionPreviewThreshold,
    double? actionOverdragExtent,
    double? actionVerticalInset,
    double? actionMinHeight,
    double? actionMinWidth,
    double? dismissThreshold,
    double? neighbourPull,
    int? neighbourReach,
    double? backgroundBorderRadius,
    double? collapseSpeed,
    EdgeInsetsGeometry? itemPadding,
    M3ESpring? neighbourSpring,
    M3ESpring? reEngageSpring,
    M3ESpring? detachPushSpring,
    M3ESpring? roundnessSnapSpring,
    M3ESpring? springBackSpring,
    M3ESpring? flySpring,
    double? collapseDamping,
  }) {
    return M3EListDismissibleTheme(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      gap: gap ?? this.gap,
      actionGap: actionGap ?? this.actionGap,
      actionSpacing: actionSpacing ?? this.actionSpacing,
      actionEdgePadding: actionEdgePadding ?? this.actionEdgePadding,
      actionPreviewThreshold:
          actionPreviewThreshold ?? this.actionPreviewThreshold,
      actionOverdragExtent: actionOverdragExtent ?? this.actionOverdragExtent,
      actionVerticalInset: actionVerticalInset ?? this.actionVerticalInset,
      actionMinHeight: actionMinHeight ?? this.actionMinHeight,
      actionMinWidth: actionMinWidth ?? this.actionMinWidth,
      dismissThreshold: dismissThreshold ?? this.dismissThreshold,
      neighbourPull: neighbourPull ?? this.neighbourPull,
      neighbourReach: neighbourReach ?? this.neighbourReach,
      backgroundBorderRadius:
          backgroundBorderRadius ?? this.backgroundBorderRadius,
      collapseSpeed: collapseSpeed ?? this.collapseSpeed,
      itemPadding: itemPadding ?? this.itemPadding,
      neighbourSpring: neighbourSpring ?? this.neighbourSpring,
      reEngageSpring: reEngageSpring ?? this.reEngageSpring,
      detachPushSpring: detachPushSpring ?? this.detachPushSpring,
      roundnessSnapSpring: roundnessSnapSpring ?? this.roundnessSnapSpring,
      springBackSpring: springBackSpring ?? this.springBackSpring,
      flySpring: flySpring ?? this.flySpring,
      collapseDamping: collapseDamping ?? this.collapseDamping,
    );
  }
}

/// Theme values for expandable list widgets.
///
/// Stack geometry ([defaultOuterRadius], [defaultInnerRadius], [defaultGap])
/// matches [M3EListCardListTheme].
@immutable
class M3EListExpandableTheme {
  /// defaultOuterRadius.
  static const double defaultOuterRadius =
      M3EListCardListTheme.defaultOuterRadius;

  /// defaultInnerRadius.
  static const double defaultInnerRadius =
      M3EListCardListTheme.defaultInnerRadius;

  /// defaultHoverRadius.
  static const double defaultHoverRadius = defaultOuterRadius;

  /// defaultPressedRadius.
  ///
  /// Press uses the 16dp outer radius on every corner.
  static const double defaultPressedRadius = defaultOuterRadius;

  /// defaultGap.
  static const double defaultGap = M3EListCardListTheme.defaultGap;

  /// defaultTitleSubtitleGap.
  static const double defaultTitleSubtitleGap = 4;

  /// defaultHeaderPadding.
  ///
  /// Matches [M3EListCardListTheme.defaultItemPadding] so expandable headers
  /// align with card / dismissible list rows.
  static const EdgeInsets defaultHeaderPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 10,
  );

  /// defaultBodyPadding.
  static const EdgeInsets defaultBodyPadding = EdgeInsets.fromLTRB(
    16,
    0,
    16,
    20,
  );

  /// defaultIconPadding.
  static const EdgeInsets defaultIconPadding = EdgeInsets.all(8);

  /// Width of the vertical pill behind the trailing expand icon.
  ///
  /// Height fills the header content area. The box size is the same when
  /// collapsed or expanded; only the fill is shown while expanded. Set to `0`
  /// to disable the chrome entirely.
  static const double defaultExpandedIconBackgroundSize = 32;

  /// defaultIconRotationAngle.
  static const double defaultIconRotationAngle = math.pi;

  /// defaultExpandTooltip.
  static const String defaultExpandTooltip = 'Expand';

  /// defaultCollapseTooltip.
  static const String defaultCollapseTooltip = 'Collapse';

  /// M3EListExpandableTheme.

  const M3EListExpandableTheme({
    this.outerRadius = defaultOuterRadius,
    this.innerRadius = defaultInnerRadius,
    this.hoverRadius = defaultHoverRadius,
    this.pressedRadius = defaultPressedRadius,
    this.gap = defaultGap,
    this.titleSubtitleGap = defaultTitleSubtitleGap,
    this.headerPadding = defaultHeaderPadding,
    this.bodyPadding = defaultBodyPadding,
    this.iconPadding = defaultIconPadding,
    this.expandedIconBackgroundSize = defaultExpandedIconBackgroundSize,
    this.expandedIconBackground,
    this.iconRotationAngle = defaultIconRotationAngle,
    this.expandTooltip = defaultExpandTooltip,
    this.collapseTooltip = defaultCollapseTooltip,
    this.expandMotion = M3EMotion.expressiveSpatialDefault,
    this.collapseMotion = M3EMotion.expressiveSpatialDefault,
    this.allowMultipleExpanded = false,
  });

  /// defaults.

  static const M3EListExpandableTheme defaults = M3EListExpandableTheme();

  /// outerRadius.

  final double outerRadius;

  /// innerRadius.
  final double innerRadius;

  /// hoverRadius.
  final double hoverRadius;

  /// pressedRadius.
  final double pressedRadius;

  /// gap.
  final double gap;

  /// titleSubtitleGap.
  final double titleSubtitleGap;

  /// headerPadding.
  final EdgeInsetsGeometry headerPadding;

  /// bodyPadding.
  final EdgeInsetsGeometry bodyPadding;

  /// iconPadding.
  final EdgeInsetsGeometry iconPadding;

  /// Width of the vertical pill behind the trailing expand icon.
  ///
  /// Height fills the header content area. Size is stable across expand /
  /// collapse; only the fill toggles. Set to `0` to disable.
  final double expandedIconBackgroundSize;

  /// Fill for the expanded trailing-icon chrome.
  ///
  /// When null, resolves to [M3EColorScheme.surfaceContainer].
  final Color? expandedIconBackground;

  /// iconRotationAngle.
  final double iconRotationAngle;

  /// expandTooltip.
  final String expandTooltip;

  /// collapseTooltip.
  final String collapseTooltip;

  /// expandMotion.
  final M3ESpring expandMotion;

  /// collapseMotion.
  final M3ESpring collapseMotion;

  /// allowMultipleExpanded.
  final bool allowMultipleExpanded;

  /// backgroundColor.

  Color backgroundColor(M3EColorScheme scheme) => scheme.surface;

  /// Expanded trailing-icon chrome color.
  Color resolvedExpandedIconBackground(M3EColorScheme scheme) =>
      expandedIconBackground ?? scheme.surfaceContainer;

  /// copyWith.

  M3EListExpandableTheme copyWith({
    double? outerRadius,
    double? innerRadius,
    double? hoverRadius,
    double? pressedRadius,
    double? gap,
    double? titleSubtitleGap,
    EdgeInsetsGeometry? headerPadding,
    EdgeInsetsGeometry? bodyPadding,
    EdgeInsetsGeometry? iconPadding,
    double? expandedIconBackgroundSize,
    Color? expandedIconBackground,
    double? iconRotationAngle,
    String? expandTooltip,
    String? collapseTooltip,
    M3ESpring? expandMotion,
    M3ESpring? collapseMotion,
    bool? allowMultipleExpanded,
  }) {
    return M3EListExpandableTheme(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      hoverRadius: hoverRadius ?? this.hoverRadius,
      pressedRadius: pressedRadius ?? this.pressedRadius,
      gap: gap ?? this.gap,
      titleSubtitleGap: titleSubtitleGap ?? this.titleSubtitleGap,
      headerPadding: headerPadding ?? this.headerPadding,
      bodyPadding: bodyPadding ?? this.bodyPadding,
      iconPadding: iconPadding ?? this.iconPadding,
      expandedIconBackgroundSize:
          expandedIconBackgroundSize ?? this.expandedIconBackgroundSize,
      expandedIconBackground:
          expandedIconBackground ?? this.expandedIconBackground,
      iconRotationAngle: iconRotationAngle ?? this.iconRotationAngle,
      expandTooltip: expandTooltip ?? this.expandTooltip,
      collapseTooltip: collapseTooltip ?? this.collapseTooltip,
      expandMotion: expandMotion ?? this.expandMotion,
      collapseMotion: collapseMotion ?? this.collapseMotion,
      allowMultipleExpanded:
          allowMultipleExpanded ?? this.allowMultipleExpanded,
    );
  }
}

/// Theme values for list-family widgets.
@immutable
class M3EListTheme extends M3EThemeExtension<M3EListTheme> {
  /// M3EListTheme.
  const M3EListTheme({
    this.item = M3EListItemTheme.defaults,
    this.cardList = M3EListCardListTheme.defaults,
    this.dismissible = M3EListDismissibleTheme.defaults,
    this.expandable = M3EListExpandableTheme.defaults,
    this.selection = M3EListSelectionState.defaults,
    this.reorder = M3EListReorderState.defaults,
  });

  /// defaults.

  static const M3EListTheme defaults = M3EListTheme();

  /// item.

  final M3EListItemTheme item;

  /// cardList.
  final M3EListCardListTheme cardList;

  /// dismissible.
  final M3EListDismissibleTheme dismissible;

  /// expandable.
  final M3EListExpandableTheme expandable;

  /// Selection visuals and triggers for list variants.
  final M3EListSelectionState selection;

  /// Reorder visuals and motion for list variants.
  final M3EListReorderState reorder;

  @override
  M3EListTheme copyWith({
    M3EListItemTheme? item,
    M3EListCardListTheme? cardList,
    M3EListDismissibleTheme? dismissible,
    M3EListExpandableTheme? expandable,
    M3EListSelectionState? selection,
    M3EListReorderState? reorder,
  }) {
    return M3EListTheme(
      item: item ?? this.item,
      cardList: cardList ?? this.cardList,
      dismissible: dismissible ?? this.dismissible,
      expandable: expandable ?? this.expandable,
      selection: selection ?? this.selection,
      reorder: reorder ?? this.reorder,
    );
  }

  @override
  M3EListTheme lerp(M3EListTheme? other, double t) {
    if (other is! M3EListTheme) {
      return this;
    }
    if (t < 0.5) {
      return this;
    }
    return other;
  }
}
