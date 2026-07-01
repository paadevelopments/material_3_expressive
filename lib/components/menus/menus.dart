import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'models/m3e_menu_entry.dart';

export 'models/m3e_menu_entry.dart';

/// Builds the anchor for an [M3EMenu], given a callback to open the menu.
typedef M3EMenuAnchorBuilder = Widget Function(
  BuildContext context,
  VoidCallback open,
);

/// A Material 3 Expressive menu.
///
/// Displays a temporary surface of [entries] anchored to a widget built by
/// [anchorBuilder]. The menu scales open from the anchor and closes when an
/// entry is chosen or the scrim is tapped.
class M3EMenu extends StatefulWidget {
  const M3EMenu({
    required this.anchorBuilder,
    required this.entries,
    super.key,
  });

  final M3EMenuAnchorBuilder anchorBuilder;
  final List<M3EMenuEntry> entries;

  @override
  State<M3EMenu> createState() => _M3EMenuState();
}

class _M3EMenuState extends State<M3EMenu>
    with SingleTickerProviderStateMixin {
  final LayerLink _link = LayerLink();
  final OverlayPortalController _portal = OverlayPortalController();
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: M3EMotion.medium1,
      reverseDuration: M3EMotion.short3,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open() {
    _portal.show();
    _controller.forward();
  }

  Future<void> _close() async {
    await _controller.reverse();
    if (mounted) {
      _portal.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _buildOverlay,
      child: CompositedTransformTarget(
        link: _link,
        child: widget.anchorBuilder(context, _open),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _close,
          ),
        ),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.bottomLeft,
          offset: const Offset(0, 4),
          child: _buildMenu(theme),
        ),
      ],
    );
  }

  Widget _buildMenu(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _controller,
        curve: M3EMotion.emphasizedDecelerate,
      ),
      alignment: Alignment.topLeft,
      child: FadeTransition(
        opacity: _controller,
        child: Container(
          constraints: const BoxConstraints(minWidth: 112, maxWidth: 280),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: M3EShapes.radiusExtraSmall,
            boxShadow: M3EElevation.shadows(
              M3EElevation.level2,
              shadowColor: scheme.shadow,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (final M3EMenuEntry entry in widget.entries)
                _buildEntry(theme, entry),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntry(M3EThemeData theme, M3EMenuEntry entry) {
    final scheme = theme.colorScheme;
    final Color foreground = entry.enabled
        ? scheme.onSurface
        : M3EColorUtils.withOpacity(scheme.onSurface, 0.38);
    return M3ETappable(
      enabled: entry.enabled,
      onTap: () {
        entry.onPressed?.call();
        _close();
      },
      semanticLabel: entry.label,
      builder: (BuildContext context, M3EInteractionState state) {
        return Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          color: scheme.onSurface.withValues(alpha: state.opacity),
          child: Row(
            children: <Widget>[
              if (entry.leading != null) ...<Widget>[
                IconTheme.merge(
                  data: IconThemeData(color: foreground, size: 24),
                  child: entry.leading!,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  entry.label,
                  style: theme.typeScale.labelLarge.copyWith(color: foreground),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (entry.trailing != null) ...<Widget>[
                const SizedBox(width: 12),
                IconTheme.merge(
                  data: IconThemeData(color: foreground, size: 24),
                  child: entry.trailing!,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
