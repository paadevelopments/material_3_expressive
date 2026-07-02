import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'styles/m3e_tooltip_tokens.dart';

export 'styles/m3e_tooltip_tokens.dart';

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

  void _scheduleHide() {
    if (widget._isRich) {
      return;
    }
    _timer?.cancel();
    _timer = Timer(M3ETooltipTokens.plainDismissDelay, _hide);
  }

  @override
  Widget build(BuildContext context) {
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
              _scheduleHide();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = M3ETheme.of(context);
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
          offset: const Offset(0, M3ETooltipTokens.anchorOffset),
          child: widget._isRich ? _buildRich(theme) : _buildPlain(theme),
        ),
      ],
    );
  }

  Widget _buildPlain(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return _fade(
      Container(
        constraints: const BoxConstraints(
          maxWidth: M3ETooltipTokens.plainMaxWidth,
        ),
        padding: M3ETooltipTokens.plainPadding,
        decoration: BoxDecoration(
          color: M3ETooltipTokens.plainContainerColor(scheme),
          borderRadius: M3ETooltipTokens.plainBorderRadius,
        ),
        child: Text(
          widget.message!,
          style: M3ETooltipTokens.plainMessageStyle(theme.typeScale, scheme),
        ),
      ),
    );
  }

  Widget _buildRich(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return _fade(
      Container(
        constraints: const BoxConstraints(
          maxWidth: M3ETooltipTokens.richMaxWidth,
        ),
        padding: M3ETooltipTokens.richPadding,
        decoration: BoxDecoration(
          color: M3ETooltipTokens.richContainerColor(scheme),
          borderRadius: M3ETooltipTokens.richBorderRadius,
          boxShadow: M3EElevation.shadows(
            M3ETooltipTokens.richElevation,
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
                style: M3ETooltipTokens.richTitleStyle(
                  theme.typeScale,
                  scheme,
                ),
              ),
              const SizedBox(height: M3ETooltipTokens.richTitleGap),
            ],
            Text(
              widget.richMessage!,
              style: M3ETooltipTokens.richBodyStyle(theme.typeScale, scheme),
            ),
            if (widget.actions.isNotEmpty) ...<Widget>[
              const SizedBox(height: M3ETooltipTokens.richActionsGap),
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
