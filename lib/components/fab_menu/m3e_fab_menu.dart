import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import '../floating_action_buttons/enums/m3e_fab.dart';
import '../floating_action_buttons/m3e_floating_action_buttons.dart';
import 'models/m3e_fab_menu_item.dart';

export 'models/m3e_fab_menu_item.dart';

/// A Material 3 Expressive FAB menu.
///
/// A FAB that opens into a vertical list of labelled actions above a scrim.
/// The trigger icon morphs between the open and close glyphs and the items
/// animate in with a staggered spring.
class M3EFabMenu extends StatefulWidget {
  const M3EFabMenu({
    required this.items,
    this.icon = const Icon(M3EIcons.add),
    this.closeIcon = const Icon(M3EIcons.close),
    this.color = M3EFabColor.primary,
    super.key,
  }) : assert(items.length > 0, 'A FAB menu needs at least one item.');

  final List<M3EFabMenuItem> items;
  final Widget icon;
  final Widget closeIcon;
  final M3EFabColor color;

  @override
  State<M3EFabMenu> createState() => _M3EFabMenuState();
}

class _M3EFabMenuState extends State<M3EFabMenu>
    with SingleTickerProviderStateMixin {
  final LayerLink _link = LayerLink();
  final OverlayPortalController _portal = OverlayPortalController();
  late final AnimationController _controller;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: M3EMotion.medium2,
      reverseDuration: M3EMotion.short4,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_open) {
      _close();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    setState(() => _open = true);
    _portal.show();
    _controller.forward();
  }

  Future<void> _close() async {
    await _controller.reverse();
    if (!mounted) {
      return;
    }
    _portal.hide();
    setState(() => _open = false);
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _buildOverlay,
      child: CompositedTransformTarget(
        link: _link,
        child: M3EFab(
          icon: _open ? widget.closeIcon : widget.icon,
          color: widget.color,
          onPressed: _toggle,
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildScrim(context),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.topRight,
          followerAnchor: Alignment.bottomRight,
          offset: Offset(0, -M3ETheme.of(context).fabMenuTheme.menuOffset),
          child: _buildMenu(context),
        ),
      ],
    );
  }

  Widget _buildScrim(BuildContext context) {
    final theme = M3ETheme.of(context);
    final fabMenuTheme = theme.fabMenuTheme;
    return Positioned.fill(
      child: GestureDetector(
        onTap: _close,
        child: FadeTransition(
          opacity: _controller,
          child: ColoredBox(
            color: fabMenuTheme.scrimColor(theme.colorScheme),
          ),
        ),
      ),
    );
  }

  Widget _buildMenu(BuildContext context) {
    final theme = M3ETheme.of(context);
    final fabMenuTheme = theme.fabMenuTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        for (int i = 0; i < widget.items.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: fabMenuTheme.itemGap),
            child: _buildItem(theme, widget.items[i], i),
          ),
      ],
    );
  }

  Widget _buildItem(M3EThemeData theme, M3EFabMenuItem item, int index) {
    final scheme = theme.colorScheme;
    final int count = widget.items.length;
    final double start = (count - 1 - index) / (count * 1.5);
    final Animation<double> animation = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, 1, curve: M3EMotion.emphasizedDecelerate),
    );

    return ScaleTransition(
      scale: animation,
      alignment: Alignment.bottomRight,
      child: FadeTransition(
        opacity: animation,
        child: M3ETappable(
          onTap: () {
            item.onPressed?.call();
            _close();
          },
          semanticLabel: item.label,
          builder: (BuildContext context, M3EInteractionState state) {
            return _itemSurface(theme, item, scheme, state);
          },
        ),
      ),
    );
  }

  Widget _itemSurface(
    M3EThemeData theme,
    M3EFabMenuItem item,
    M3EColorScheme scheme,
    M3EInteractionState state,
  ) {
    final fabMenuTheme = theme.fabMenuTheme;
    final border = M3EShapes.stadium;
    return Container(
      height: fabMenuTheme.itemHeight,
      decoration: ShapeDecoration(
        shape: border,
        color: fabMenuTheme.itemContainerColor(scheme),
        shadows: M3EElevation.shadows(
          fabMenuTheme.itemElevation,
          shadowColor: scheme.shadow,
        ),
      ),
      child: M3EStateLayerOverlay(
        state: state,
        color: fabMenuTheme.itemForegroundColor(scheme),
        shape: border,
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: fabMenuTheme.itemHorizontalPadding,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconTheme.merge(
                data: IconThemeData(
                  color: fabMenuTheme.itemForegroundColor(scheme),
                  size: fabMenuTheme.iconSize,
                ),
                child: item.icon,
              ),
              SizedBox(width: fabMenuTheme.iconLabelGap),
              Text(
                item.label,
                style: fabMenuTheme.itemLabelStyle(theme.typeScale, scheme),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
