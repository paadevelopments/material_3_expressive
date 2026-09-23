import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/navigation_drawer/m3e_navigation_drawer.dart'
    show M3ENavigationDrawer;
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ENavigationDrawer;

import '../../../foundations/foundations.dart';
import '../../navigation_rail/components/m3e_nav_icon_scale.dart';
import '../../navigation_rail/components/m3e_nav_selection_indicator.dart';
import '../models/m3e_navigation_destination.dart';
import '../styles/m3e_navigation_drawer_theme.dart';

/// Single destination row in [M3ENavigationDrawer].
///
/// The selection fill scales and fades in place. Keyboard focus adds the
/// shared [M3EFocusRing] around the destination row; Space/Enter selects.
class M3EDrawerDestinationButton extends StatefulWidget {
  /// M3EDrawerDestinationButton.
  const M3EDrawerDestinationButton({
    required this.destination,
    required this.selected,
    required this.onTap,
    this.haptic = M3EHapticFeedback.none,
    super.key,
  });

  /// destination.

  final M3ENavigationDestination destination;

  /// selected.
  final bool selected;

  /// onTap.
  final VoidCallback onTap;

  /// Haptic intensity on tap. Defaults to [M3EHapticFeedback.none].
  final M3EHapticFeedback haptic;

  @override
  State<M3EDrawerDestinationButton> createState() =>
      _M3EDrawerDestinationButtonState();
}

class _M3EDrawerDestinationButtonState
    extends State<M3EDrawerDestinationButton> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    M3EFocusInteraction.instance.addListener(_onFocusInteractionChanged);
  }

  @override
  void dispose() {
    M3EFocusInteraction.instance.removeListener(_onFocusInteractionChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusInteractionChanged() {
    _handleFocusHighlight(_focusNode.hasPrimaryFocus);
  }

  void _handleFocusHighlight(bool value) {
    if (!mounted) {
      return;
    }
    final bool show =
        value &&
        M3EFocusInteraction.instance.ringsAllowed &&
        M3EFocusRing.shouldShow(_focusNode, context);
    if (_focused == show) {
      return;
    }
    setState(() => _focused = show);
    if (show) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        M3EFocusInteraction.ensureVisibleIfKeyboard(context);
      });
    }
  }

  void _select({bool fromPointer = false}) {
    if (fromPointer) {
      M3EFocusInteraction.instance.notePointerInteraction();
      _focusNode.requestFocus();
    }
    M3EHaptics.trigger(widget.haptic);
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ENavigationDrawerTheme drawerTheme = theme.navigationDrawerTheme;
    final M3EColorScheme scheme = theme.colorScheme;
    final M3ENavigationDestination destination = widget.destination;
    final bool selected = widget.selected;
    final Color foreground = drawerTheme.destinationForegroundColor(
      scheme,
      selected: selected,
    );
    final ShapeBorder border = drawerTheme.destinationShape();
    final Color fill = drawerTheme.destinationBackgroundColor(
      scheme,
      selected: true,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: drawerTheme.destinationHorizontalPadding,
        vertical: drawerTheme.destinationVerticalPadding,
      ),
      child: Semantics(
        button: true,
        selected: selected,
        label: destination.label,
        child: FocusableActionDetector(
          focusNode: _focusNode,
          mouseCursor: SystemMouseCursors.click,
          onShowFocusHighlight: _handleFocusHighlight,
          actions: <Type, Action<Intent>>{
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (ActivateIntent intent) {
                _select();
                return null;
              },
            ),
            ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
              onInvoke: (ButtonActivateIntent intent) {
                _select();
                return null;
              },
            ),
          },
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              M3EFocusInteraction.instance.notePointerInteraction();
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _select(fromPointer: true),
              child: M3EFocusRing(
                focused: _focused,
                radius: _ringRadius(border, drawerTheme),
                child: SizedBox(
                  height: drawerTheme.destinationHeight,
                  width: double.infinity,
                  child: Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      Positioned.fill(
                        child: M3ESelectionIndicator(
                          selected: selected,
                          scaleSpring: drawerTheme.indicatorScaleSpring,
                          fadeSpring: drawerTheme.indicatorFadeSpring,
                          child: DecoratedBox(
                            decoration: ShapeDecoration(
                              shape: border,
                              color: fill,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal:
                              drawerTheme.destinationInnerHorizontalPadding,
                        ),
                        child: Row(
                          children: <Widget>[
                            M3ENavIconScale(
                              selected: selected,
                              child: IconTheme.merge(
                                data: IconThemeData(
                                  color: foreground,
                                  size: drawerTheme.iconSize,
                                ),
                                child: selected
                                    ? (destination.selectedIcon ??
                                          destination.icon)
                                    : destination.icon,
                              ),
                            ),
                            SizedBox(width: drawerTheme.iconLabelGap),
                            Expanded(
                              child: Text(
                                destination.label,
                                style: theme.typeScale.labelLarge.copyWith(
                                  color: foreground,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (destination.badgeLabel != null)
                              Text(
                                destination.badgeLabel!,
                                style: theme.typeScale.labelLarge.copyWith(
                                  color: foreground,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BorderRadius _ringRadius(
    ShapeBorder border,
    M3ENavigationDrawerTheme drawerTheme,
  ) {
    if (border is RoundedRectangleBorder) {
      return border.borderRadius.resolve(Directionality.of(context));
    }
    return BorderRadius.circular(drawerTheme.destinationHeight / 2);
  }
}
