import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3EListItem`.
@immutable
class M3EListItemTheme {
  const M3EListItemTheme({
    this.horizontalPadding = 16,
    this.verticalPadding = 8,
    this.threeLineVerticalPadding = 12,
    this.minHeight = 40,
    this.iconSize = 24,
    this.gap = 16,
  });

  static const M3EListItemTheme defaults = M3EListItemTheme();

  final double horizontalPadding;
  final double verticalPadding;
  final double threeLineVerticalPadding;
  final double minHeight;
  final double iconSize;
  final double gap;

  Color selectedColor(M3EColorScheme scheme) => scheme.secondaryContainer;

  Color iconColor(M3EColorScheme scheme) => scheme.onSurfaceVariant;

  TextStyle overlineStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.labelSmall.copyWith(color: scheme.onSurfaceVariant);

  TextStyle headlineStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyLarge.copyWith(color: scheme.onSurface);

  TextStyle supportingStyle(M3ETypeScale type, M3EColorScheme scheme) =>
      type.bodyMedium.copyWith(color: scheme.onSurfaceVariant);

  M3EListItemTheme copyWith({
    double? horizontalPadding,
    double? verticalPadding,
    double? threeLineVerticalPadding,
    double? minHeight,
    double? iconSize,
    double? gap,
  }) {
    return M3EListItemTheme(
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      threeLineVerticalPadding:
          threeLineVerticalPadding ?? this.threeLineVerticalPadding,
      minHeight: minHeight ?? this.minHeight,
      iconSize: iconSize ?? this.iconSize,
      gap: gap ?? this.gap,
    );
  }
}

/// Theme values for `M3ECardList`.
@immutable
class M3EListCardListTheme {
  static const double defaultOuterRadius = 24;
  static const double defaultInnerRadius = 4;
  static const double defaultGap = 4;
  static const EdgeInsets defaultItemPadding = EdgeInsets.all(12);

  const M3EListCardListTheme({
    this.outerRadius = defaultOuterRadius,
    this.innerRadius = defaultInnerRadius,
    this.gap = defaultGap,
    this.itemPadding = defaultItemPadding,
  });

  static const M3EListCardListTheme defaults = M3EListCardListTheme();

  final double outerRadius;
  final double innerRadius;
  final double gap;
  final EdgeInsetsGeometry itemPadding;

  Color backgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

  M3EListCardListTheme copyWith({
    double? outerRadius,
    double? innerRadius,
    double? gap,
    EdgeInsetsGeometry? itemPadding,
  }) {
    return M3EListCardListTheme(
      outerRadius: outerRadius ?? this.outerRadius,
      innerRadius: innerRadius ?? this.innerRadius,
      gap: gap ?? this.gap,
      itemPadding: itemPadding ?? this.itemPadding,
    );
  }
}

/// Theme values for dismissible list widgets.
@immutable
class M3EListDismissibleTheme {
  static const double defaultOuterRadius = 18;
  static const double defaultInnerRadius = 4;
  static const double defaultGap = 3;
  static const double defaultActionGap = 8;
  static const double defaultDismissThreshold = 0.2;
  static const double defaultNeighbourPull = 8;
  static const int defaultNeighbourReach = 3;
  static const double defaultBackgroundBorderRadius = 100;
  static const double defaultCollapseSpeed = 50;
  static const EdgeInsets defaultItemPadding = EdgeInsets.all(16);

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

  static const M3EListDismissibleTheme defaults = M3EListDismissibleTheme();

  final double outerRadius;
  final double innerRadius;
  final double gap;

  /// Horizontal gap between a swiped card and its revealed action background.
  final double actionGap;
  final double dismissThreshold;
  final double neighbourPull;
  final int neighbourReach;
  final double backgroundBorderRadius;
  final double collapseSpeed;
  final EdgeInsetsGeometry itemPadding;

  Color backgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

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
  static const double defaultOuterRadius = 24;
  static const double defaultInnerRadius = 6;
  static const double defaultHoverRadius = 10;
  static const double defaultPressedRadius = 4;
  static const double defaultGap = 3;
  static const double defaultTitleSubtitleGap = 4;
  static const EdgeInsets defaultHeaderPadding =
      EdgeInsets.fromLTRB(16, 14, 16, 2);
  static const EdgeInsets defaultBodyPadding =
      EdgeInsets.fromLTRB(16, 0, 16, 20);
  static const EdgeInsets defaultIconPadding = EdgeInsets.all(8);
  static const double defaultIconRotationAngle = math.pi;
  static const String defaultExpandTooltip = 'Expand';
  static const String defaultCollapseTooltip = 'Collapse';

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

  static const M3EListExpandableTheme defaults = M3EListExpandableTheme();

  final double outerRadius;
  final double innerRadius;
  final double hoverRadius;
  final double pressedRadius;
  final double gap;
  final double titleSubtitleGap;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry bodyPadding;
  final EdgeInsetsGeometry iconPadding;
  final double iconRotationAngle;
  final String expandTooltip;
  final String collapseTooltip;
  final M3ESpring expandMotion;
  final M3ESpring collapseMotion;
  final bool allowMultipleExpanded;

  Color backgroundColor(M3EColorScheme scheme) =>
      scheme.surfaceContainerHighest;

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
  const M3EListTheme({
    this.item = M3EListItemTheme.defaults,
    this.cardList = M3EListCardListTheme.defaults,
    this.dismissible = M3EListDismissibleTheme.defaults,
    this.expandable = M3EListExpandableTheme.defaults,
  });

  static const M3EListTheme defaults = M3EListTheme();

  final M3EListItemTheme item;
  final M3EListCardListTheme cardList;
  final M3EListDismissibleTheme dismissible;
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
