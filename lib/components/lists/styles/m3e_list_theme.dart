import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../cards/enums/m3e_card_variant.dart';

/// Theme values for `M3EListItem`.
@immutable
class M3EListItemTheme {
  /// M3EListItemTheme.
  const M3EListItemTheme({
    this.horizontalPadding = 16,
    this.verticalPadding = 8,
    this.threeLineVerticalPadding = 12,
    this.minHeight = 40,
    this.iconSize = 24,
    this.gap = 16,
    this.variant = M3ECardVariant.filled,
    this.border,
  });

  /// defaults.

  static const M3EListItemTheme defaults = M3EListItemTheme();

  /// horizontalPadding.

  final double horizontalPadding;

  /// verticalPadding.
  final double verticalPadding;

  /// threeLineVerticalPadding.
  final double threeLineVerticalPadding;

  /// minHeight.
  final double minHeight;

  /// iconSize.
  final double iconSize;

  /// gap.
  final double gap;

  /// Card variant for standalone list items.
  final M3ECardVariant variant;

  /// Optional card outline; null keeps the variant default.
  final BorderSide? border;

  /// selectedColor.

  Color selectedColor(M3EColorScheme scheme) => scheme.secondaryContainer;

  /// iconColor.

  Color iconColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  /// overlineStyle.

  TextStyle overlineStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelSmall.copyWith(color: scheme.onSurfaceVariant);

  /// headlineStyle.

  TextStyle headlineStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  /// supportingStyle.

  TextStyle supportingStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyMedium.copyWith(color: scheme.onSurfaceVariant);

  /// copyWith.

  M3EListItemTheme copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    double? threeLineVerticalPadding,
    double? minHeight,
    double? iconSize,
    double? gap,
    M3ECardVariant? variant,
    BorderSide? border,
  }) {
    return M3EListItemTheme(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      threeLineVerticalPadding:
          threeLineVerticalPadding ?? this.threeLineVerticalPadding,
      minHeight: minHeight ?? this.minHeight,
      iconSize: iconSize ?? this.iconSize,
      gap: gap ?? this.gap,
      variant: variant ?? this.variant,
      border: border ?? this.border,
    );
  }
}

/// Theme values for `M3ECardList`.
@immutable
class M3EListCardListTheme {
  /// defaultOuterRadius.
  static const double defaultOuterRadius = 24;

  /// defaultInnerRadius.
  static const double defaultInnerRadius = 4;

  /// defaultGap.
  static const double defaultGap = 4;

  /// defaultItemPadding.
  static const EdgeInsets defaultItemPadding = EdgeInsets.all(12);

  /// M3EListCardListTheme.

  const M3EListCardListTheme({
    this.outerRadius = defaultOuterRadius,
    this.innerRadius = defaultInnerRadius,
    this.gap = defaultGap,
    this.itemPadding = defaultItemPadding,
    this.variant = M3ECardVariant.filled,
    this.border,
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

  /// backgroundColor.

  Color backgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

  /// copyWith.

  M3EListCardListTheme copyWith({
    double? outerRadius,
    double? innerRadius,
    double? gap,
    EdgeInsetsGeometry? itemPadding,
    M3ECardVariant? variant,
    BorderSide? border,
  }) {
    return M3EListCardListTheme(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      gap: gap ?? this.gap,
      itemPadding: itemPadding ?? this.itemPadding,
      variant: variant ?? this.variant,
      border: border ?? this.border,
    );
  }
}

/// Theme values for dismissible list widgets.
@immutable
class M3EListDismissibleTheme {
  /// defaultOuterRadius.
  static const double defaultOuterRadius = 18;

  /// defaultInnerRadius.
  static const double defaultInnerRadius = 4;

  /// defaultGap.
  static const double defaultGap = 3;

  /// defaultActionGap.
  static const double defaultActionGap = 8;

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
  static const EdgeInsets defaultItemPadding = EdgeInsets.all(16);

  /// M3EListDismissibleTheme.

  const M3EListDismissibleTheme({
    this.outerRadius = defaultOuterRadius,
    this.innerRadius = defaultInnerRadius,
    this.gap = defaultGap,
    this.actionGap = defaultActionGap,
    this.dismissThreshold = defaultDismissThreshold,
    this.neighbourPull = defaultNeighbourPull,
    this.neighbourReach = defaultNeighbourReach,
    this.backgroundBorderRadius = defaultBackgroundBorderRadius,
    this.collapseSpeed = defaultCollapseSpeed,
    this.itemPadding = defaultItemPadding,
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

  /// backgroundColor.

  Color backgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

  /// copyWith.

  M3EListDismissibleTheme copyWith({
    double? outerRadius,
    double? innerRadius,
    double? gap,
    double? actionGap,
    double? dismissThreshold,
    double? neighbourPull,
    int? neighbourReach,
    double? backgroundBorderRadius,
    double? collapseSpeed,
    EdgeInsetsGeometry? itemPadding,
  }) {
    return M3EListDismissibleTheme(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      gap: gap ?? this.gap,
      actionGap: actionGap ?? this.actionGap,
      dismissThreshold: dismissThreshold ?? this.dismissThreshold,
      neighbourPull: neighbourPull ?? this.neighbourPull,
      neighbourReach: neighbourReach ?? this.neighbourReach,
      backgroundBorderRadius:
          backgroundBorderRadius ?? this.backgroundBorderRadius,
      collapseSpeed: collapseSpeed ?? this.collapseSpeed,
      itemPadding: itemPadding ?? this.itemPadding,
    );
  }
}

/// Theme values for expandable list widgets.
@immutable
class M3EListExpandableTheme {
  /// defaultOuterRadius.
  static const double defaultOuterRadius = 24;

  /// defaultInnerRadius.
  static const double defaultInnerRadius = 6;

  /// defaultHoverRadius.
  static const double defaultHoverRadius = 10;

  /// defaultPressedRadius.
  static const double defaultPressedRadius = 4;

  /// defaultGap.
  static const double defaultGap = 3;

  /// defaultTitleSubtitleGap.
  static const double defaultTitleSubtitleGap = 4;

  /// defaultHeaderPadding.
  static const EdgeInsets defaultHeaderPadding = EdgeInsets.fromLTRB(
    16,
    14,
    16,
    2,
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

  Color backgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

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

  @override
  M3EListTheme copyWith({
    M3EListItemTheme? item,
    M3EListCardListTheme? cardList,
    M3EListDismissibleTheme? dismissible,
    M3EListExpandableTheme? expandable,
  }) {
    return M3EListTheme(
      item: item ?? this.item,
      cardList: cardList ?? this.cardList,
      dismissible: dismissible ?? this.dismissible,
      expandable: expandable ?? this.expandable,
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
