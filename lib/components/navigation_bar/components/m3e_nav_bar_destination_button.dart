import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../navigation_rail/components/m3e_nav_icon_scale.dart';
import '../../navigation_rail/components/m3e_nav_selection_indicator.dart';
import '../enums/m3e_nav_bar_enums.dart';
import '../models/m3e_navigation_bar_destination.dart';
import '../res/m3e_nav_bar_constants.dart';

/// Single destination cell inside the M3E navigation bar.
///
/// No ink splash — pill selection scales and fades on this destination.
/// Keyboard focus adds the shared [M3EFocusRing] around the destination chip;
/// Space/Enter selects.
class M3ENavBarDestinationButton extends StatefulWidget {
  /// M3ENavBarDestinationButton.
  const M3ENavBarDestinationButton({
    required this.destination,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.labelStyle,
    required this.iconSize,
    required this.labelBehavior,
    required this.iconBehavior,
    required this.layout,
    required this.indicatorStyle,
    required this.indicatorWidth,
    required this.indicatorHeight,
    required this.underlineThickness,
    required this.underlineColor,
    required this.indicatorColor,
    required this.onTap,
    this.wideDestinationWidth,
    this.haptic = M3EHapticFeedback.none,
    super.key,
  });

  /// destination.
  final M3ENavigationBarDestination destination;

  /// selected.
  final bool selected;

  /// selectedColor.
  final Color selectedColor;

  /// unselectedColor.
  final Color unselectedColor;

  /// labelStyle.
  final TextStyle labelStyle;

  /// iconSize.
  final double iconSize;

  /// labelBehavior.
  final M3ENavBarLabelBehavior labelBehavior;

  /// iconBehavior.
  final M3ENavBarIconBehavior iconBehavior;

  /// layout.
  final M3ENavBarLayout layout;

  /// indicatorStyle.
  final M3ENavBarIndicatorStyle indicatorStyle;

  /// indicatorWidth.
  final double indicatorWidth;

  /// indicatorHeight.
  final double indicatorHeight;

  /// Fixed chip width in wide layout (ignored in compact).
  final double? wideDestinationWidth;

  /// underlineThickness.
  final double underlineThickness;

  /// underlineColor.
  final Color underlineColor;

  /// indicatorColor.
  final Color indicatorColor;

  /// onTap.
  final VoidCallback onTap;

  /// Haptic intensity on tap. Defaults to [M3EHapticFeedback.none].
  final M3EHapticFeedback haptic;

  @override
  State<M3ENavBarDestinationButton> createState() =>
      _M3ENavBarDestinationButtonState();
}

class _M3ENavBarDestinationButtonState
    extends State<M3ENavBarDestinationButton> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  bool get _showLabel {
    if (!widget.destination.hasLabel) {
      return false;
    }
    return switch (widget.labelBehavior) {
      M3ENavBarLabelBehavior.alwaysShow => true,
      M3ENavBarLabelBehavior.onlySelected => widget.selected,
      M3ENavBarLabelBehavior.alwaysHide => false,
    };
  }

  bool get _showIcon {
    if (!widget.destination.hasIcon) {
      return false;
    }
    return switch (widget.iconBehavior) {
      M3ENavBarIconBehavior.alwaysShow => true,
      M3ENavBarIconBehavior.onlySelected => widget.selected,
      M3ENavBarIconBehavior.alwaysHide => false,
    };
  }

  bool get _pill => widget.indicatorStyle == M3ENavBarIndicatorStyle.pill;

  bool get _underlined =>
      widget.indicatorStyle == M3ENavBarIndicatorStyle.underline &&
      widget.selected;

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

  @override
  Widget build(BuildContext context) {
    final Color fg = widget.selected
        ? widget.selectedColor
        : widget.unselectedColor;
    final Widget content = widget.layout == M3ENavBarLayout.wide
        ? _buildWideContent(fg)
        : _buildCompactContent(fg);

    return Semantics(
      button: true,
      selected: widget.selected,
      label: widget.destination.resolvedSemanticLabel,
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
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactContent(Color fg) {
    Widget? icon;
    if (_showIcon) {
      icon = M3ENavIconScale(
        selected: widget.selected,
        child: IconTheme.merge(
          data: IconThemeData(color: fg, size: widget.iconSize),
          child: widget.destination.buildIcon(selected: widget.selected),
        ),
      );
      final double pillRadius =
          math.min(widget.indicatorWidth, widget.indicatorHeight) / 2;
      icon = SizedBox(
        width: widget.indicatorWidth,
        height: widget.indicatorHeight,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            if (_pill)
              Positioned.fill(child: _selectionIndicator(radius: pillRadius)),
            icon,
          ],
        ),
      );
      if (_underlined) {
        icon = DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.underlineColor,
                width: widget.underlineThickness,
              ),
            ),
          ),
          child: icon,
        );
      }
      icon = M3EFocusRing(
        focused: _focused,
        radius: BorderRadius.circular(pillRadius),
        child: icon,
      );
    }

    final Widget column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ?icon,
        if (_showLabel) ...<Widget>[
          if (icon != null) const SizedBox(height: 4),
          Text(
            widget.destination.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: widget.labelStyle.copyWith(color: fg),
          ),
        ],
      ],
    );

    if (icon != null) {
      return column;
    }
    // Label-only destination: the label block is the outer shape.
    return M3EFocusRing(
      focused: _focused,
      radius: BorderRadius.circular(widget.indicatorHeight / 2),
      child: column,
    );
  }

  Widget _buildWideContent(Color fg) {
    final List<Widget> children = _wideChipChildren(fg);
    Widget chip = _buildWideChip(children);
    if (_underlined) {
      chip = _wrapWideUnderline(chip);
    }
    return Center(
      child: M3EFocusRing(
        focused: _focused,
        radius: BorderRadius.circular(widget.indicatorHeight / 2),
        child: chip,
      ),
    );
  }

  List<Widget> _wideChipChildren(Color fg) {
    final children = <Widget>[];
    if (_showIcon) {
      children.add(
        M3ENavIconScale(
          selected: widget.selected,
          child: IconTheme.merge(
            data: IconThemeData(color: fg, size: widget.iconSize),
            child: widget.destination.buildIcon(selected: widget.selected),
          ),
        ),
      );
    }
    if (_showLabel) {
      if (children.isNotEmpty) {
        children.add(
          const SizedBox(width: M3ENavBarConstants.wideIconLabelGap),
        );
      }
      children.add(
        Flexible(
          child: Text(
            widget.destination.label!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: widget.labelStyle.copyWith(color: fg),
          ),
        ),
      );
    }
    return children;
  }

  double get _wideChipHorizontalPadding {
    // Stadium radius is height/2; horizontal padding must clear the curved
    // caps or the icon sits in the cutout and looks clipped by the pill.
    return math.max(
      M3ENavBarConstants.widePillHorizontalPadding,
      widget.indicatorHeight / 2 + M3ENavBarConstants.widePillCapClearance,
    );
  }

  Widget _buildWideChip(List<Widget> children) {
    final double chipWidth =
        widget.wideDestinationWidth ?? M3ENavBarConstants.wideDestinationWidth;
    final double radius = widget.indicatorHeight / 2;
    return SizedBox(
      width: chipWidth,
      height: widget.indicatorHeight,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (_pill)
            Positioned.fill(child: _selectionIndicator(radius: radius)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _wideChipHorizontalPadding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectionIndicator({required double radius}) {
    final navTheme = M3ETheme.of(context).navigationBarTheme;
    return M3ESelectionIndicator(
      selected: widget.selected,
      scaleSpring: navTheme.indicatorScaleSpring,
      fadeSpring: navTheme.indicatorFadeSpring,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: widget.indicatorColor,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  Widget _wrapWideUnderline(Widget chip) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: widget.underlineColor,
            width: widget.underlineThickness,
          ),
        ),
      ),
      child: chip,
    );
  }
}
