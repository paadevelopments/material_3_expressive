import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'models/m3e_menu_entry.dart';
import 'styles/m3e_menu_tokens.dart';

export 'models/m3e_menu_entry.dart';
export 'styles/m3e_menu_tokens.dart';

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
          offset: const Offset(0, M3EMenuTokens.anchorOffset),
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
          constraints: const BoxConstraints(
            minWidth: M3EMenuTokens.minWidth,
            maxWidth: M3EMenuTokens.maxWidth,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: M3EMenuTokens.verticalPadding,
          ),
          decoration: BoxDecoration(
            color: M3EMenuTokens.containerColor(scheme),
            borderRadius: M3EMenuTokens.borderRadius,
            boxShadow: M3EElevation.shadows(
              M3EMenuTokens.elevation,
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
    final Color foreground = M3EMenuTokens.entryForegroundColor(
      scheme,
      enabled: entry.enabled,
    );
    return M3ETappable(
      enabled: entry.enabled,
      onTap: () {
        entry.onPressed?.call();
        _close();
      },
      semanticLabel: entry.label,
      builder: (BuildContext context, M3EInteractionState state) {
        return Container(
          height: M3EMenuTokens.entryHeight,
          padding: const EdgeInsets.symmetric(
            horizontal: M3EMenuTokens.entryHorizontalPadding,
          ),
          color: scheme.onSurface.withValues(alpha: state.opacity),
          child: Row(
            children: <Widget>[
              if (entry.leading != null) ...<Widget>[
                IconTheme.merge(
                  data: IconThemeData(
                    color: foreground,
                    size: M3EMenuTokens.iconSize,
                  ),
                  child: entry.leading!,
                ),
                const SizedBox(width: M3EMenuTokens.iconGap),
              ],
              Expanded(
                child: Text(
                  entry.label,
                  style: M3EMenuTokens.entryLabelStyle(
                    theme.typeScale,
                    scheme,
                    enabled: entry.enabled,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (entry.trailing != null) ...<Widget>[
                const SizedBox(width: M3EMenuTokens.iconGap),
                IconTheme.merge(
                  data: IconThemeData(
                    color: foreground,
                    size: M3EMenuTokens.iconSize,
                  ),
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
