import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

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
    _timer = Timer(M3EMotion.extraLong4, _hide);
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
          offset: const Offset(0, 4),
          child: widget._isRich ? _buildRich(theme) : _buildPlain(theme),
        ),
      ],
    );
  }

  Widget _buildPlain(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return _fade(
      Container(
        constraints: const BoxConstraints(maxWidth: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: scheme.inverseSurface,
          borderRadius: M3EShapes.radiusExtraSmall,
        ),
        child: Text(
          widget.message!,
          style: theme.typeScale.bodySmall
              .copyWith(color: scheme.onInverseSurface),
        ),
      ),
    );
  }

  Widget _buildRich(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return _fade(
      Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surfaceContainer,
          borderRadius: M3EShapes.radiusMedium,
          boxShadow: M3EElevation.shadows(
            M3EElevation.level2,
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
                style: theme.typeScale.titleSmall
                    .copyWith(color: scheme.onSurface),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              widget.richMessage!,
              style: theme.typeScale.bodyMedium
                  .copyWith(color: scheme.onSurfaceVariant),
            ),
            if (widget.actions.isNotEmpty) ...<Widget>[
              const SizedBox(height: 12),
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
