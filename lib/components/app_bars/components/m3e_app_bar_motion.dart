part of '../m3e_app_bars.dart';

/// Maps scroll offset and hide progress onto the content band.
class _M3EBarMotion {
  const _M3EBarMotion({
    required this.offset,
    required this.collapsed,
    required this.expanded,
    required this.shown,
    required this.mode,
    required this.manual,
  });

  final double offset;
  final double collapsed;
  final double expanded;
  final double shown;
  final M3EAppBarHideMode mode;
  final bool manual;

  double get range => math.max(0, expanded - collapsed);

  double get expand {
    if (range <= 0.5) {
      return 0;
    }
    return (1 - (offset / range).clamp(0.0, 1.0)).clamp(0.0, 1.0);
  }

  bool get entire {
    if (mode == M3EAppBarHideMode.entire) {
      return true;
    }
    return mode == M3EAppBarHideMode.none && manual;
  }

  bool get actions => mode == M3EAppBarHideMode.actions;

  double get painted => lerpDouble(collapsed, expanded, expand) ?? collapsed;

  double get slot {
    final double open = painted;
    if (entire) {
      return open * shown.clamp(0.0, 1.0);
    }
    if (actions) {
      return lerpDouble(collapsed, open, shown.clamp(0.0, 1.0)) ?? collapsed;
    }
    return open;
  }

  double get titleExpand => actions ? expand * shown.clamp(0.0, 1.0) : expand;

  double get titleHide => actions ? 1 - shown.clamp(0.0, 1.0) : 0;
}

Color _m3eBarColor({
  required M3EAppBar bar,
  required M3EAppBarTheme theme,
  required M3EColorScheme scheme,
  required bool under,
}) {
  final Color rest = bar.backgroundColor ?? theme.backgroundColor(scheme);
  final Color scrolled =
      bar.backgroundColor ?? theme.scrolledBackgroundColor(scheme);
  return under ? scrolled : rest;
}

/// Starts a hide once. Repeating [AnimationController.reverse] every pixel
/// stops and restarts the travel, which reads as a twitch.
void _m3eSlideAway(AnimationController visibility) {
  if (visibility.status == AnimationStatus.reverse ||
      visibility.value <= 0.001) {
    return;
  }
  visibility.reverse();
}

/// Starts a show once. See [_m3eSlideAway].
void _m3eSlideBack(AnimationController visibility) {
  if (visibility.status == AnimationStatus.forward ||
      visibility.value >= 0.999) {
    return;
  }
  visibility.forward();
}

/// Slides [child] up out of a shrinking window.
Widget _m3eClipSliding({
  required double push,
  required double visual,
  required Widget child,
}) {
  final double open = math.max(visual, push);
  return SizedBox(
    height: math.max(0, push),
    child: ClipRect(
      child: OverflowBox(
        alignment: Alignment.bottomCenter,
        minHeight: open,
        maxHeight: open,
        child: SizedBox(height: open, child: child),
      ),
    ),
  );
}
