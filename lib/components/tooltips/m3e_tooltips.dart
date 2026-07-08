import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_tooltip_theme.dart';

export 'styles/m3e_tooltip_theme.dart';

/// A Material 3 Expressive tooltip.
///
/// Wraps [child] and reveals a floating label. A plain tooltip (just [message])
/// appears on hover or long-press and auto-dismisses; a rich tooltip (with
/// [richTitle]/[actions]) stays until dismissed by tapping elsewhere.
class M3ETooltip extends StatefulWidget {
  const M3ETooltip({
    required this.child,
    this.message,
    this.richTitle,
    this.richMessage,
    this.actions = const <Widget>[],
    super.key,
  }) : assert(
          message != null || richMessage != null,
          'Provide a plain message or a rich message.',
        );

  final Widget child;
  final String? message;
  final String? richTitle;
  final String? richMessage;
  final List<Widget> actions;

  bool get _isRich => richMessage != null;

  @override
  State<M3ETooltip> createState() => _M3ETooltipState();
}

class _M3ETooltipState extends State<M3ETooltip> {
  final LayerLink _link = LayerLink();
  final OverlayPortalController _portal = OverlayPortalController();
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _show() {
    _timer?.cancel();
    _portal.show();
  }

  void _hide() {
    _timer?.cancel();
    _portal.hide();
  }

  void _scheduleHide(M3ETooltipTheme tooltipTheme) {
    if (widget._isRich) {
      return;
    }
    _timer?.cancel();
    _timer = Timer(tooltipTheme.plainDismissDelay, _hide);
  }

  @override
  Widget build(BuildContext context) {
    final tooltipTheme = M3ETheme.of(context).tooltipTheme;
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _buildOverlay,
      child: CompositedTransformTarget(
        link: _link,
        child: MouseRegion(
          onEnter: (_) => _show(),
          onExit: (_) => _hide(),
          child: GestureDetector(
            onLongPress: () {
              _show();
              _scheduleHide(tooltipTheme);
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = M3ETheme.of(context);
    final tooltipTheme = theme.tooltipTheme;
    return Stack(
      children: <Widget>[
        if (widget._isRich)
          Positioned.fill(
            child: GestureDetector(
              onTap: _hide,
              behavior: HitTestBehavior.translucent,
            ),
          ),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.bottomCenter,
          followerAnchor: Alignment.topCenter,
          offset: Offset(0, tooltipTheme.anchorOffset),
          child: widget._isRich
              ? _buildRich(theme, tooltipTheme)
              : _buildPlain(theme, tooltipTheme),
        ),
      ],
    );
  }

  Widget _buildPlain(M3EThemeData theme, M3ETooltipTheme tooltipTheme) {
    final scheme = theme.colorScheme;
    return _fade(
      Container(
        constraints: BoxConstraints(maxWidth: tooltipTheme.plainMaxWidth),
        padding: tooltipTheme.plainPadding,
        decoration: BoxDecoration(
          color: tooltipTheme.plainContainerColor(scheme),
          borderRadius: tooltipTheme.plainBorderRadius,
        ),
        child: Text(
          widget.message!,
          style: tooltipTheme.plainMessageStyle(theme.typeScale, scheme),
        ),
      ),
    );
  }

  Widget _buildRich(M3EThemeData theme, M3ETooltipTheme tooltipTheme) {
    final scheme = theme.colorScheme;
    return _fade(
      Container(
        constraints: BoxConstraints(maxWidth: tooltipTheme.richMaxWidth),
        padding: tooltipTheme.richPadding,
        decoration: BoxDecoration(
          color: tooltipTheme.richContainerColor(scheme),
          borderRadius: tooltipTheme.richBorderRadius,
          boxShadow: M3EElevation.shadows(
            tooltipTheme.richElevation,
            shadowColor: scheme.shadow,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (widget.richTitle != null) ...<Widget>[
              Text(
                widget.richTitle!,
                style: tooltipTheme.richTitleStyle(theme.typeScale, scheme),
              ),
              SizedBox(height: tooltipTheme.richTitleGap),
            ],
            Text(
              widget.richMessage!,
              style: tooltipTheme.richBodyStyle(theme.typeScale, scheme),
            ),
            if (widget.actions.isNotEmpty) ...<Widget>[
              SizedBox(height: tooltipTheme.richActionsGap),
              Row(children: widget.actions),
            ],
          ],
        ),
      ),
    );
  }

  Widget _fade(Widget child) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: M3EMotion.short3,
      curve: M3EMotion.standard,
      builder: (BuildContext context, double value, Widget? built) {
        return Opacity(opacity: value, child: built);
      },
      child: child,
    );
  }
}
