import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Theme values for `M3EDialog`.
@immutable
class M3EDialogTheme extends M3EThemeExtension<M3EDialogTheme> {
  const M3EDialogTheme({
    this.minWidth = 280,
    this.maxWidth = 560,
    this.padding = const EdgeInsets.all(24),
    this.screenMargin = const EdgeInsets.all(24),
    this.entranceScale = 0.9,
    this.iconSize = 24,
    this.gapAfterIcon = 16,
    this.gapAfterTitle = 16,
    this.gapBeforeActions = 24,
    this.actionGap = 8,
    this.selectionItemHeight = 56,
    this.fullScreenHeaderHeight = 64,
    this.headerEdgeGap = 4,
    this.closeButtonPadding = const EdgeInsets.all(12),
    this.headerActionGap = 16,
    this.scrimOpacity = 0.32,
  });

  static const M3EDialogTheme defaults = M3EDialogTheme();

  final double minWidth;
  final double maxWidth;
  final EdgeInsets padding;
  final EdgeInsets screenMargin;
  final double entranceScale;
  final double iconSize;
  final double gapAfterIcon;
  final double gapAfterTitle;
  final double gapBeforeActions;
  final double actionGap;

  /// Height of each selectable row in selection dialogs.
  final double selectionItemHeight;
  final double fullScreenHeaderHeight;
  final double headerEdgeGap;
  final EdgeInsets closeButtonPadding;
  final double headerActionGap;
  final double scrimOpacity;

  BorderRadius get borderRadius => M3EShapes.radiusExtraLarge;

  Color containerColor(M3EColorScheme scheme) => scheme.surfaceContainerHigh;

  Color fullScreenBackground(M3EColorScheme scheme) => scheme.surface;

  Color scrimColor(M3EColorScheme scheme) =>
      scheme.scrim.withValues(alpha: scrimOpacity);

  @override
  M3EDialogTheme copyWith({
    double? minWidth,
    double? maxWidth,
    EdgeInsets? padding,
    EdgeInsets? screenMargin,
    double? entranceScale,
    double? iconSize,
    double? gapAfterIcon,
    double? gapAfterTitle,
    double? gapBeforeActions,
    double? actionGap,
    double? selectionItemHeight,
    double? fullScreenHeaderHeight,
    double? headerEdgeGap,
    EdgeInsets? closeButtonPadding,
    double? headerActionGap,
    double? scrimOpacity,
  }) {
    return M3EDialogTheme(
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      padding: padding ?? this.padding,
      screenMargin: screenMargin ?? this.screenMargin,
      entranceScale: entranceScale ?? this.entranceScale,
      iconSize: iconSize ?? this.iconSize,
      gapAfterIcon: gapAfterIcon ?? this.gapAfterIcon,
      gapAfterTitle: gapAfterTitle ?? this.gapAfterTitle,
      gapBeforeActions: gapBeforeActions ?? this.gapBeforeActions,
      actionGap: actionGap ?? this.actionGap,
      selectionItemHeight: selectionItemHeight ?? this.selectionItemHeight,
      fullScreenHeaderHeight:
          fullScreenHeaderHeight ?? this.fullScreenHeaderHeight,
      headerEdgeGap: headerEdgeGap ?? this.headerEdgeGap,
      closeButtonPadding: closeButtonPadding ?? this.closeButtonPadding,
      headerActionGap: headerActionGap ?? this.headerActionGap,
      scrimOpacity: scrimOpacity ?? this.scrimOpacity,
    );
  }

  @override
  M3EDialogTheme lerp(M3EDialogTheme? other, double t) {
    if (other is! M3EDialogTheme) {
      return this;
    }
    return M3EDialogTheme(
      minWidth: _lerpDouble(minWidth, other.minWidth, t)!,
      maxWidth: _lerpDouble(maxWidth, other.maxWidth, t)!,
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      screenMargin: EdgeInsets.lerp(screenMargin, other.screenMargin, t)!,
      entranceScale: _lerpDouble(entranceScale, other.entranceScale, t)!,
      iconSize: _lerpDouble(iconSize, other.iconSize, t)!,
      gapAfterIcon: _lerpDouble(gapAfterIcon, other.gapAfterIcon, t)!,
      gapAfterTitle: _lerpDouble(gapAfterTitle, other.gapAfterTitle, t)!,
      gapBeforeActions: _lerpDouble(gapBeforeActions, other.gapBeforeActions, t)!,
      actionGap: _lerpDouble(actionGap, other.actionGap, t)!,
      selectionItemHeight:
          _lerpDouble(selectionItemHeight, other.selectionItemHeight, t)!,
      fullScreenHeaderHeight:
          _lerpDouble(fullScreenHeaderHeight, other.fullScreenHeaderHeight, t)!,
      headerEdgeGap: _lerpDouble(headerEdgeGap, other.headerEdgeGap, t)!,
      closeButtonPadding:
          EdgeInsets.lerp(closeButtonPadding, other.closeButtonPadding, t)!,
      headerActionGap: _lerpDouble(headerActionGap, other.headerActionGap, t)!,
      scrimOpacity: _lerpDouble(scrimOpacity, other.scrimOpacity, t)!,
    );
  }

  double? _lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
