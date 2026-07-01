// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:material_3_expressive/components/buttons/internal/_button_motion.dart';
import 'package:material_3_expressive/components/split_buttons/internal/_split_button_popup.dart';
import 'package:material_3_expressive/components/split_buttons/internal/_split_button_bottom_sheet.dart';
import 'package:material_3_expressive/components/buttons/internal/button_constants.dart';
import 'package:material_3_expressive/components/buttons/internal/m3e_base_button_state.dart';
import 'package:material_3_expressive/components/buttons/style/button_tokens_adapter.dart';
import 'package:material_3_expressive/components/buttons/style/m3e_button_enums.dart';
import 'package:material_3_expressive/components/split_buttons/style/m3e_split_button_decoration.dart';
import 'package:material_3_expressive/components/buttons/style/m3e_button_motion.dart';
import 'package:material_3_expressive/foundations/foundations.dart';

const double _kSplitMinTapTarget = 48.0;
const bool _kDefaultEnableFeedback = true;

/// Controls how the trailing (dropdown) button aligns with the leading button.
///
/// Used by [M3ESplitButton] to control visual alignment of split segments.
enum M3ESplitButtonTrailingAlignment {
  /// Align using optical center to compensate for the dropdown arrow icon.
  ///
  /// The trailing button appears visually centered with the leading button.
  opticalCenter,

  /// Align using geometric center regardless of content differences.
  ///
  /// Both segments are exactly the same width.
  geometricCenter,
}

/// Material 3 Expressive Split Button.
///
/// A split button consists of a primary action button and a trailing dropdown
/// button that reveals additional options. Supports popup menus, bottom sheets,
/// or custom menus via [menuBuilder].
///
/// ## Basic usage
/// ```dart
/// M3ESplitButton<int>(
///   items: const [
///     M3ESplitButtonItem(value: 1, child: Text('Option 1')),
///     M3ESplitButtonItem(value: 2, child: Text('Option 2')),
///   ],
///   onSelected: (value) {},
///   onPressed: () {},
/// )
/// ```
///
/// ## Menu styles
/// Use [M3ESplitButtonDecoration.menuStyle] to choose between:
/// - [SplitButtonMenuStyle.popup]: Spring-animated popup (default)
/// - [SplitButtonMenuStyle.bottomSheet]: Modal bottom sheet
/// - [SplitButtonMenuStyle.native]: System popup menu
class M3ESplitButton<T> extends StatefulWidget {
  const M3ESplitButton({
    super.key,
    required this.items,
    this.onSelected,
    this.onPressed,
    this.label,
    this.leadingIcon,
    this.size = M3EButtonSize.sm,
    this.shape = M3EButtonShape.round,
    this.style = M3EButtonStyle.filled,
    this.trailingAlignment = M3ESplitButtonTrailingAlignment.opticalCenter,
    this.leadingTooltip,
    this.trailingTooltip,
    this.enabled = true,
    this.menuBuilder,
    this.decoration,
    this.mouseCursor,
    this.statesController,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.selectedValue,
    this.onMultiSelected,
    this.onLongPress,
    this.onHover,
    this.enableFeedback = _kDefaultEnableFeedback,
    this.splashFactory,
  }) : assert(
         items != null || menuBuilder != null,
         'Provide either `items` or `menuBuilder`.',
       ),
       assert(
         style != M3EButtonStyle.text,
         'M3ESplitButton does not support M3EButtonStyle.text.',
       ),
       assert(
         !enabled ||
             onPressed != null ||
             onSelected != null ||
             menuBuilder != null,
         'Provide either onPressed, onSelected, or a custom menuBuilder when the split button is enabled.',
       );

  /// Menu items displayed when the trailing button is pressed.
  ///
  /// Use [M3ESplitButtonItem] to create items with a value and display widget.
  final List<M3ESplitButtonItem<T>>? items;

  /// Callback fired when an item is selected from the menu.
  final ValueChanged<T>? onSelected;

  /// Callback fired when the leading button is pressed.
  final VoidCallback? onPressed;

  /// Text label displayed on the leading button.
  final String? label;

  /// Leading icon displayed on the leading button.
  final IconData? leadingIcon;

  /// Size variant of the split button.
  ///
  /// See [M3EButtonSize] for available sizes.
  final M3EButtonSize size;

  /// Corner radius strategy for the button.
  ///
  /// See [M3EButtonShape] for available shapes.
  final M3EButtonShape shape;

  /// Visual style of the split button.
  ///
  /// Supported styles: [M3EButtonStyle.filled], [M3EButtonStyle.tonal],
  /// [M3EButtonStyle.elevated], and [M3EButtonStyle.outlined].
  final M3EButtonStyle style;

  /// How the trailing button aligns with the leading button.
  ///
  /// See [M3ESplitButtonTrailingAlignment] for alignment options.
  final M3ESplitButtonTrailingAlignment trailingAlignment;

  /// Tooltip for the leading button.
  final String? leadingTooltip;

  /// Tooltip for the trailing button.
  final String? trailingTooltip;

  /// Whether the split button is enabled.
  final bool enabled;

  /// Custom menu builder function.
  ///
  /// When provided, this takes precedence over [items]. Use to create
  /// custom menu content with [PopupMenuEntry] widgets.
  final List<PopupMenuEntry<T>> Function(BuildContext)? menuBuilder;

  /// Optional decoration that bundles styling properties together.
  ///
  /// When provided, decoration values take precedence over individual parameters.
  final M3ESplitButtonDecoration? decoration;

  /// Optional mouse cursor to show when hovering over the button.
  final MouseCursor? mouseCursor;

  /// Optional controller for managing widget states externally.
  ///
  /// Allows programmatic control of pressed, hovered, focused states.
  final WidgetStatesController? statesController;

  /// External focus node for keyboard navigation.
  final FocusNode? focusNode;

  /// Whether this button should focus itself on mount.
  final bool autofocus;

  /// Callback fired when focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Currently selected value (for showing selection state in menu).
  final T? selectedValue;

  /// Callback fired when multiple items are selected (for multi-select mode).
  final void Function(Set<T>)? onMultiSelected;

  /// Callback invoked when the leading button is long-pressed.
  final VoidCallback? onLongPress;

  /// Callback invoked when the hover state changes.
  final ValueChanged<bool>? onHover;

  /// Whether to show a ripple/splash effect and haptic feedback on press.
  ///
  /// Defaults to true.
  final bool enableFeedback;

  /// The splash factory for the ink ripple effect.
  ///
  /// See [InteractiveInkFeatureFactory] for available options.
  final InteractiveInkFeatureFactory? splashFactory;

  WidgetStateProperty<Color?>? get decorationBackgroundColor =>
      decoration?.backgroundColor;
  WidgetStateProperty<Color?>? get decorationForegroundColor =>
      decoration?.foregroundColor;
  Color? get decorationTrailingBackgroundColor =>
      decoration?.trailingBackgroundColor;
  Color? get decorationTrailingForegroundColor =>
      decoration?.trailingForegroundColor;
  M3EButtonSize? get decorationLeadingCustomSize =>
      decoration?.leadingCustomSize;
  M3EButtonSize? get decorationTrailingCustomSize =>
      decoration?.trailingCustomSize;
  // Drives shape/padding animation.
  M3EButtonMotion? get decorationMotion => decoration?.motion;
  double? get decorationGap => decoration?.gap;
  Color? get decorationMenuBackgroundColor => decoration?.menuBackgroundColor;
  Color? get decorationMenuForegroundColor => decoration?.menuForegroundColor;
  WidgetStateProperty<BorderSide?>? get decorationBorderSide =>
      decoration?.side;
  M3EHapticFeedback get decorationHaptic =>
      decoration?.haptic ?? M3EHapticFeedback.none;
  double? get decorationBorderRadius => decoration?.borderRadius;
  WidgetStateProperty<Color?>? get decorationOverlayColor =>
      decoration?.overlayColor;
  WidgetStateProperty<Color?>? get decorationSurfaceTintColor =>
      decoration?.surfaceTintColor;

  @override
  State<M3ESplitButton<T>> createState() => _M3ESplitButtonState<T>();
}

class _M3ESplitButtonState<T> extends State<M3ESplitButton<T>>
    with M3EBaseButtonState<M3ESplitButton<T>> {
  bool _menuOpen = false;
  bool _trailingPressed = false;
  bool _isTrailingHovered = false;
  bool _isTrailingFocused = false;
  late FocusNode _trailingFocusNode;

  void _closeMenu() {
    if (mounted) {
      setState(() {
        _menuOpen = false;
        _trailingPressed = false;
      });
    }
  }

  Set<T>? _selectedValues;
  final GlobalKey _trailingKey = GlobalKey();

  @override
  M3EButtonSize get buttonSize => widget.size;

  @override
  WidgetStatesController? get externalStatesController =>
      widget.statesController;

  @override
  FocusNode? get externalFocusNode => widget.focusNode;

  @override
  M3EButtonMotion? get effectiveMotion => widget.decorationMotion;

  late M3EButtonTokensAdapter _tokens;

  @override
  void initState() {
    super.initState();
    initBaseButtonState();
    _trailingFocusNode = FocusNode(debugLabel: '$runtimeType.trailing');
    _trailingFocusNode.addListener(_onTrailingFocusChanged);
  }

  void _onTrailingFocusChanged() {
    final focused = _trailingFocusNode.hasFocus;
    if (_isTrailingFocused != focused) {
      setState(() => _isTrailingFocused = focused);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tokens = M3EButtonTokensAdapter(context);
    _tokens.didChangeDependencies();
    updateSpringMotion();
  }

  @override
  void didUpdateWidget(covariant M3ESplitButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleStatesControllerUpdate(
      oldWidget.statesController,
      widget.statesController,
    );
    handleFocusNodeUpdate(oldWidget.focusNode, widget.focusNode);

    if (widget.decoration?.motion != oldWidget.decoration?.motion) {
      updateSpringMotion();
    }
  }

  @override
  void dispose() {
    _trailingFocusNode.removeListener(_onTrailingFocusChanged);
    _trailingFocusNode.dispose();
    disposeBaseButtonState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildAnimatedContent(
      builder: (context, pressed, hovered, focused) {
        return _buildContent(context, pressed, hovered, focused);
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool pressed,
    bool hovered,
    bool focused,
  ) {
    final dir = Directionality.of(context);
    final size = widget.size;

    final (cont, onCont, outlineSide, _) = _resolveColorsAndShapes(context);

    final leadingCustomSize = widget.decorationLeadingCustomSize;
    final trailingCustomSize = widget.decorationTrailingCustomSize;

    final leadingHeight =
        leadingCustomSize?.height ?? _tokens.splitHeight(size);
    final trailingHeight =
        trailingCustomSize?.height ?? _tokens.splitHeight(size);
    final maxSegmentHeight = leadingHeight > trailingHeight
        ? leadingHeight
        : trailingHeight;
    final minTap = _kSplitMinTapTarget;
    final double? explicitBorderRadius = widget.decorationBorderRadius;
    final outerRadius =
        explicitBorderRadius ??
        (widget.shape == M3EButtonShape.round
            ? maxSegmentHeight / 2
            : _tokens.splitOuterRadiusSquare(size));
    final pressedRadius =
        widget.decoration?.pressedRadius ??
        explicitBorderRadius ??
        _tokens.splitPressedRadius(size);
    final innerRadius =
        explicitBorderRadius ?? _tokens.splitInnerCornerRadius(size);
    final hoveredInnerRadius =
        widget.decoration?.hoveredRadius ??
        explicitBorderRadius ??
        _tokens.splitHoveredInnerCornerRadius(size);
    final trailingSelectedRadius =
        widget.decoration?.trailingSelectedRadius ??
        explicitBorderRadius ??
        trailingHeight *
            (_tokens.splitTrailingInnerSelectedCornerPercent / 100);

    final baseGap =
        widget.decorationGap ??
        (widget.style == M3EButtonStyle.elevated
            ? _tokens.splitElevatedInnerGap
            : _tokens.splitInnerGap);

    // FocusRing paints a Positioned overlay at -(gap+width) on all sides;
    // must expand the inter-segment gap by the same outset so the ring
    // does not bleed over into the adjacent segment.
    const double focusRingOutset =
        ButtonConstants.kFocusRingGap + ButtonConstants.kFocusRingWidth;
    final eitherFocused = focused || _isTrailingFocused;
    final focusRingExtra = eitherFocused ? focusRingOutset : 0.0;
    final gap = baseGap + focusRingExtra;

    final leadingEnabled = widget.enabled && widget.onPressed != null;
    final trailingEnabled = widget.enabled;

    final leadingPressed = leadingEnabled && pressed;
    final trailingPressed = trailingEnabled && (_trailingPressed || _menuOpen);
    final leadingHovered = leadingEnabled && hovered && !leadingPressed;
    final trailingHovered =
        trailingEnabled &&
        _isTrailingHovered &&
        !_menuOpen &&
        !_trailingPressed;

    final leadingRadius = _leadingRadii(
      dir: dir,
      outer: outerRadius,
      inner: innerRadius,
      hovered: leadingHovered ? hoveredInnerRadius : null,
      pressed: leadingPressed ? pressedRadius : null,
    );

    final trailingWidthUnselected =
        (trailingCustomSize?.hPadding ??
            _tokens.splitTrailingButtonLeadingSpace(size)) +
        (trailingCustomSize?.iconSize ?? _tokens.splitTrailingIconSize(size)) +
        (trailingCustomSize?.hPadding ??
            _tokens.splitTrailingButtonTrailingSpace(size));
    final trailingWidthSelected =
        (trailingCustomSize?.hPadding ??
                _tokens.splitSidePaddingSelected(size)) *
            2 +
        (trailingCustomSize?.iconSize ?? _tokens.splitTrailingIconSize(size));

    final bool allowCircle =
        size == M3EButtonSize.md ||
        size == M3EButtonSize.lg ||
        size == M3EButtonSize.xl;
    final bool circleTrailing =
        explicitBorderRadius == null &&
        widget.shape == M3EButtonShape.round &&
        allowCircle &&
        _menuOpen;

    final trailingFixedWidth = circleTrailing
        ? trailingHeight
        : (trailingCustomSize?.width ??
              (_menuOpen ? trailingWidthSelected : trailingWidthUnselected));

    final trailingLeftPad = circleTrailing
        ? 0.0
        : (_menuOpen
              ? (trailingCustomSize?.hPadding ??
                    _tokens.splitSidePaddingSelected(size))
              : (trailingCustomSize?.hPadding ??
                    _tokens.splitTrailingButtonLeadingSpace(size)));
    final trailingRightPad = circleTrailing
        ? 0.0
        : (_menuOpen
              ? (trailingCustomSize?.hPadding ??
                    _tokens.splitSidePaddingSelected(size))
              : (trailingCustomSize?.hPadding ??
                    _tokens.splitTrailingButtonTrailingSpace(size)));

    final trailingRadius = circleTrailing
        ? _CornerRadii(
            topStart: trailingSelectedRadius,
            bottomStart: trailingSelectedRadius,
            topEnd: trailingSelectedRadius,
            bottomEnd: trailingSelectedRadius,
          )
        : _trailingRadii(
            dir: dir,
            outer: outerRadius,
            inner: innerRadius,
            hovered: trailingHovered ? hoveredInnerRadius : null,
            pressed: trailingPressed ? pressedRadius : null,
            selected: _menuOpen ? trailingSelectedRadius : null,
          );

    final trailingIconOffsetBase =
        (widget.trailingAlignment ==
                M3ESplitButtonTrailingAlignment.opticalCenter &&
            !_menuOpen)
        ? _tokens.splitMenuIconOffset(size)
        : 0.0;

    final chevronTargetTurns = _menuOpen ? _tokens.splitChevronOpenTurns : 0.0;

    final leading = _buildLeadingSegment(
      context: context,
      height: leadingHeight,
      minTap: minTap,
      color: cont,
      onColor: onCont,
      elevation: _segmentElevation(
        hovered: leadingHovered,
        pressed: leadingPressed,
      ),
      outlineSide: outlineSide,
      radius: leadingRadius,
      customSize: leadingCustomSize,
      focused: focused,
      hovered: leadingHovered,
      pressed: leadingPressed,
    );

    final trailing = _buildTrailingSegment(
      context: context,
      height: trailingHeight,
      minTap: minTap,
      fixedWidth: trailingFixedWidth,
      color: cont,
      onColor: onCont,
      elevation: _segmentElevation(
        hovered: trailingHovered,
        pressed: trailingPressed,
      ),
      outlineSide: outlineSide,
      radius: trailingRadius,
      trailingLeftPad: trailingLeftPad,
      trailingRightPad: trailingRightPad,
      chevronTargetTurns: chevronTargetTurns,
      chevronDxOffset: circleTrailing ? 0.0 : trailingIconOffsetBase,
      customSize: trailingCustomSize,
      focused: _isTrailingFocused,
      hovered: trailingHovered,
      pressed: trailingPressed,
    );

    final theme = Theme.of(context);
    final m3e = m3eMaterialTheme(context);
    final bool contIsTransparent = cont.a == 0.0;
    final Color menuColor =
        widget.decorationMenuBackgroundColor ??
        (contIsTransparent ? m3e.colorScheme.surfaceContainerHigh : cont);
    final Color menuTextColor =
        widget.decorationMenuForegroundColor ??
        (contIsTransparent ? m3e.colorScheme.onSurface : onCont);

    return PopupMenuTheme(
      data: theme.popupMenuTheme.copyWith(
        color: menuColor,
        textStyle: m3e.textTheme.labelLarge?.copyWith(color: menuTextColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(pressedRadius),
        ),
      ),
      child: FocusTraversalGroup(
        policy: ReadingOrderTraversalPolicy(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minTap),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: dir,
            children: [
              leading,
              SizedBox(width: gap),
              trailing,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingSegment({
    required BuildContext context,
    required double height,
    required double minTap,
    required Color color,
    required Color onColor,
    required double? elevation,
    required BorderSide? outlineSide,
    required _CornerRadii radius,
    required M3EButtonSize? customSize,
    required bool focused,
    required bool hovered,
    required bool pressed,
  }) {
    final size = widget.size;
    final targetRadius = radius.toBorderRadius(Directionality.of(context));
    final segmentStates = _segmentStates(
      focused: focused,
      hovered: hovered,
      pressed: pressed,
    );
    final hasBackgroundBuilder = widget.decoration?.backgroundBuilder != null;

    // FocusRing must wrap only the AnimatedContainer (exact visual height),
    // NOT Center(AnimatedContainer). Inside FocusRing's Stack the ring is
    // Positioned relative to the Stack's natural size. If Center is inside
    // the Stack, the Stack gets constrained to minTap (48dp) by the outer
    // ConstrainedBox, placing Center at the TOP of a 48dp box — so the ring
    // has 4dp gap at top but (4 + (48-height)) gap at bottom on XS/SM.
    // With Center outside the ring, Center gives FocusRing loose constraints
    // so the Stack sizes to the AnimatedContainer (32dp on XS) and the ring
    // is exactly `gap` dp away on all four sides.
    final animatedButton = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      height: height,
      decoration: BoxDecoration(
        color: hasBackgroundBuilder ? Colors.transparent : color,
        borderRadius: targetRadius,
        border: outlineSide != null ? Border.fromBorderSide(outlineSide) : null,
        boxShadow: (elevation != null && elevation > 0)
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: targetRadius,
        child: Focus(
          focusNode: effectiveFocusNode,
          autofocus: widget.autofocus,
          onFocusChange: widget.onFocusChange,
          onKeyEvent: (node, event) {
            if (widget.enabled &&
                event is KeyDownEvent &&
                (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space ||
                    event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
              widget.onPressed?.call();
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: InkWell(
            onTap: widget.enabled
                ? () {
                    widget.onPressed?.call();
                    _triggerHaptic();
                  }
                : null,
            onLongPress: widget.enabled ? widget.onLongPress : null,
            onHover: widget.onHover,
            statesController: statesController,
            canRequestFocus: false,
            mouseCursor:
                widget.decoration?.mouseCursor?.resolve({...segmentStates}) ??
                widget.mouseCursor ??
                SystemMouseCursors.click,
            enableFeedback: widget.enableFeedback,
            splashFactory: widget.splashFactory ?? InkRipple.splashFactory,
            child: _applyDecorationLayers(
              context: context,
              states: segmentStates,
              radius: targetRadius,
              child: SizedBox(
                height: height,
                child: Center(
                  child: _LeadingContent(
                    size: size,
                    icon: widget.leadingIcon,
                    label: widget.label,
                    color: onColor,
                    tokens: _tokens,
                    customSize: customSize,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Widget wrapped = ConstrainedBox(
      constraints: BoxConstraints(minWidth: 0, minHeight: minTap),
      child: Center(
        child: FocusRing(
          focused: focused,
          radius: targetRadius,
          child: animatedButton,
        ),
      ),
    );

    final fixedWidth = customSize?.width;
    if (fixedWidth != null) {
      wrapped = SizedBox(width: fixedWidth, child: wrapped);
    }

    if (widget.leadingTooltip == null) return wrapped;
    return Tooltip(message: widget.leadingTooltip!, child: wrapped);
  }

  Widget _buildTrailingSegment({
    required BuildContext context,
    required double height,
    required double minTap,
    required double fixedWidth,
    required Color color,
    required Color onColor,
    required double? elevation,
    required BorderSide? outlineSide,
    required _CornerRadii radius,
    required double trailingLeftPad,
    required double trailingRightPad,
    required double chevronTargetTurns,
    required double chevronDxOffset,
    required M3EButtonSize? customSize,
    required bool focused,
    required bool hovered,
    required bool pressed,
  }) {
    final targetRadius = radius.toBorderRadius(Directionality.of(context));
    final effectiveWidth = fixedWidth < minTap ? minTap : fixedWidth;
    final segmentStates = _segmentStates(
      focused: focused,
      hovered: hovered,
      pressed: pressed,
      selected: _menuOpen,
    );
    final hasBackgroundBuilder = widget.decoration?.backgroundBuilder != null;

    // AnimatedRotation + AnimatedContainer both use the same Duration/Curve
    // so they start and finish in the same frame — structurally impossible
    // to desync, matching Compose's single MotionSpec per component.
    final chevron = AnimatedRotation(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      turns: chevronTargetTurns,
      child: Transform.translate(
        offset: Offset(chevronDxOffset, 0.0),
        child: Icon(
          Icons.keyboard_arrow_down,
          size:
              customSize?.iconSize ??
              _tokens.splitTrailingIconSize(widget.size),
          color: onColor,
        ),
      ),
    );

    // Same principle as leading: FocusRing wraps only the AnimatedContainer
    // so the ring's Positioned bounds equal the visual button size, not the
    // 48dp min-tap-target that would create an asymmetric bottom gap.
    final animatedButton = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      width: effectiveWidth,
      height: height,
      decoration: BoxDecoration(
        color: hasBackgroundBuilder ? Colors.transparent : color,
        borderRadius: targetRadius,
        border: outlineSide != null ? Border.fromBorderSide(outlineSide) : null,
        boxShadow: (elevation != null && elevation > 0)
            ? [
                BoxShadow(
                  color: m3eMaterialTheme(
                    context,
                  ).colorScheme.shadow.withValues(alpha: 0.15),
                  blurRadius: elevation * 2,
                  offset: Offset(0, elevation),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: targetRadius,
        child: Focus(
          focusNode: _trailingFocusNode,
          onKeyEvent: (node, event) {
            if (widget.enabled &&
                event is KeyDownEvent &&
                (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space ||
                    event.logicalKey == LogicalKeyboardKey.numpadEnter)) {
              _openMenu(_trailingKey.currentContext ?? context);
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: InkWell(
            onTap: widget.enabled
                ? () {
                    _openMenu(_trailingKey.currentContext ?? context);
                    _triggerHaptic();
                  }
                : null,
            mouseCursor:
                widget.decoration?.mouseCursor?.resolve({...segmentStates}) ??
                widget.mouseCursor ??
                SystemMouseCursors.click,
            onHover: widget.enabled
                ? (value) {
                    if (_isTrailingHovered != value) {
                      setState(() => _isTrailingHovered = value);
                    }
                    widget.onHover?.call(value);
                  }
                : null,
            onTapDown: widget.enabled
                ? (_) => setState(() => _trailingPressed = true)
                : null,
            onTapUp: widget.enabled
                ? (_) => setState(() => _trailingPressed = false)
                : null,
            onTapCancel: widget.enabled
                ? () => setState(() => _trailingPressed = false)
                : null,
            canRequestFocus: false,
            enableFeedback: widget.enableFeedback,
            splashFactory: widget.splashFactory ?? InkRipple.splashFactory,
            child: _applyDecorationLayers(
              context: context,
              states: segmentStates,
              radius: targetRadius,
              child: Padding(
                padding: EdgeInsets.only(
                  left: trailingLeftPad,
                  right: trailingRightPad,
                ),
                child: Center(child: chevron),
              ),
            ),
          ),
        ),
      ),
    );

    Widget wrapped = KeyedSubtree(
      key: _trailingKey,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: 0, minHeight: minTap),
        child: Center(
          child: FocusRing(
            focused: focused,
            radius: targetRadius,
            child: animatedButton,
          ),
        ),
      ),
    );

    final fixedWidthOverride = customSize?.width;
    if (fixedWidthOverride != null) {
      wrapped = SizedBox(width: fixedWidthOverride, child: wrapped);
    }

    if (widget.trailingTooltip == null) return wrapped;
    return Tooltip(message: widget.trailingTooltip!, child: wrapped);
  }

  Set<WidgetState> _segmentStates({
    required bool focused,
    required bool hovered,
    required bool pressed,
    bool selected = false,
  }) {
    return {
      if (!widget.enabled) WidgetState.disabled,
      if (focused) WidgetState.focused,
      if (hovered) WidgetState.hovered,
      if (pressed) WidgetState.pressed,
      if (selected) WidgetState.selected,
    };
  }

  Widget _applyDecorationLayers({
    required BuildContext context,
    required Set<WidgetState> states,
    required BorderRadius radius,
    required Widget child,
  }) {
    Widget result = child;

    if (widget.decoration?.backgroundBuilder != null) {
      result = ClipRRect(
        borderRadius: radius,
        child: widget.decoration!.backgroundBuilder!(context, states, result),
      );
    }

    if (widget.decoration?.foregroundBuilder != null) {
      result = ClipRRect(
        borderRadius: radius,
        child: widget.decoration!.foregroundBuilder!(context, states, result),
      );
    }

    return result;
  }

  (Color, Color, BorderSide?, double?) _resolveColorsAndShapes(
    BuildContext context,
  ) {
    Color fgColor =
        widget.decorationForegroundColor?.resolve({}) ??
        _tokens.foreground(widget.style);
    Color bgColor =
        widget.decorationBackgroundColor?.resolve({}) ??
        (widget.style == M3EButtonStyle.outlined
            ? Colors.transparent
            : _tokens.container(widget.style));

    BorderSide? outlineSide;
    if (widget.style == M3EButtonStyle.outlined) {
      outlineSide =
          widget.decorationBorderSide?.resolve({}) ??
          BorderSide(color: _tokens.outline());
    }

    if (!widget.enabled || widget.onPressed == null) {
      final cs = _tokens.c;
      fgColor =
          widget.decoration?.foregroundColor?.resolve({WidgetState.disabled}) ??
          cs.onSurface.withValues(
            alpha: ButtonConstants.kDisabledForegroundAlpha,
          );

      if (widget.decoration?.backgroundColor?.resolve({WidgetState.disabled}) !=
          null) {
        bgColor = widget.decoration!.backgroundColor!.resolve({
          WidgetState.disabled,
        })!;
      } else {
        bgColor = (widget.style == M3EButtonStyle.outlined)
            ? Colors.transparent
            : cs.onSurface.withValues(
                alpha: ButtonConstants.kDisabledBackgroundAlpha,
              );
      }

      if (outlineSide != null) {
        outlineSide = BorderSide(
          color: cs.onSurface.withValues(
            alpha: ButtonConstants.kDisabledOutlineAlpha,
          ),
          width: outlineSide.width,
          style: outlineSide.style,
        );
      }
    }

    return (bgColor, fgColor, outlineSide, null);
  }

  // Leading segment corner radii.
  //
  // The start edge (outer side) is always `outer` — it is frozen in the motion
  // widget and never participates in the press animation.
  // The end edge (inner side, facing the gap) animates to `pressed` when the
  // leading button is pressed, otherwise stays at `inner`.
  _CornerRadii _leadingRadii({
    required TextDirection dir,
    required double outer,
    required double inner,
    double? hovered,
    double? pressed,
  }) {
    final i = pressed ?? hovered ?? inner;
    return _CornerRadii(
      topStart: outer,
      bottomStart: outer,
      topEnd: i,
      bottomEnd: i,
    );
  }

  // Trailing segment corner radii.
  //
  // The end edge (outer side) is always `outer` — frozen, never animates on press.
  // The start edge (inner side, facing the gap) animates to `pressed` when the
  // trailing button is pressed; `selected` overrides both sides when the menu
  // is open (circle/pill transition).
  _CornerRadii _trailingRadii({
    required TextDirection dir,
    required double outer,
    required double inner,
    double? hovered,
    double? pressed,
    double? selected,
  }) {
    final o = selected ?? outer;
    final i = selected ?? pressed ?? hovered ?? inner;
    return _CornerRadii(topStart: i, bottomStart: i, topEnd: o, bottomEnd: o);
  }

  double? _segmentElevation({required bool hovered, required bool pressed}) {
    final states = <WidgetState>{
      if (!widget.enabled) WidgetState.disabled,
      if (hovered) WidgetState.hovered,
      if (pressed) WidgetState.pressed,
    };
    final value = _tokens.elevation(widget.style, states);
    return value == 0 ? null : value;
  }

  void _triggerHaptic() {
    final haptic = widget.decorationHaptic;
    if (haptic == M3EHapticFeedback.none) return;
    ButtonConstants.triggerHapticFeedback(haptic);
  }

  Future<void> _openMenu(BuildContext context) async {
    if (widget.menuBuilder != null) {
      await _showNativeMenu(context);
      return;
    }

    final items = widget.items!;
    final menuStyle =
        widget.decoration?.menuStyle ?? SplitButtonMenuStyle.popup;

    switch (menuStyle) {
      case SplitButtonMenuStyle.popup:
        await _showSpringPopup(context, items);
      case SplitButtonMenuStyle.bottomSheet:
        await _showBottomSheet(context, items);
      case SplitButtonMenuStyle.native:
        await _showNativeMenu(context, items: items);
    }
  }

  Future<void> _showSpringPopup(
    BuildContext context,
    List<M3ESplitButtonItem<T>> items,
  ) async {
    setState(() => _menuOpen = true);

    final (_, onCont, _, _) = _resolveColorsAndShapes(context);

    final tCtx = _trailingKey.currentContext;
    if (tCtx == null) {
      _closeMenu();
      return;
    }
    final tb = tCtx.findRenderObject() as RenderBox?;
    if (tb == null) {
      _closeMenu();
      return;
    }

    final popupDec =
        widget.decoration?.popupDecoration ??
        const M3ESplitButtonPopupDecoration();

    final res = await showSplitButtonPopup<T>(
      context: context,
      items: items,
      decoration: popupDec,
      foregroundColor: widget.decorationMenuForegroundColor ?? onCont,
      iconSize: _tokens.splitIcon(widget.size),
      triggerRenderBox: tb,
      selectedValue: widget.selectedValue,
      callerFocusNode: _trailingFocusNode,
    );

    if (!mounted) return;
    _closeMenu();
    if (res != null && widget.onSelected != null) widget.onSelected!(res);
  }

  Future<void> _showBottomSheet(
    BuildContext context,
    List<M3ESplitButtonItem<T>> items,
  ) async {
    setState(() => _menuOpen = true);

    final (_, onCont, _, _) = _resolveColorsAndShapes(context);

    final bottomSheetDec =
        widget.decoration?.bottomSheetDecoration ??
        const M3ESplitButtonBottomSheetDecoration();

    final isMultiSelect =
        bottomSheetDec.selectionMode == SplitButtonSelectionMode.multiple;

    if (isMultiSelect) {
      final result = await showSplitButtonBottomSheet<T>(
        context: context,
        items: items,
        decoration: bottomSheetDec,
        foregroundColor: widget.decorationMenuForegroundColor ?? onCont,
        iconSize: _tokens.splitIcon(widget.size),
        callerFocusNode: _trailingFocusNode,
        selectedValues: _selectedValues?.cast<T>(),
      );

      if (!mounted) return;
      if (result is List) {
        final Set<T> selectedSet = (result.cast<T>()).toSet();
        _selectedValues = selectedSet;
        widget.onMultiSelected?.call(selectedSet);
      }
      _closeMenu();
    } else {
      final res = await showSplitButtonBottomSheet<T>(
        context: context,
        items: items,
        decoration: bottomSheetDec,
        foregroundColor: widget.decorationMenuForegroundColor ?? onCont,
        iconSize: _tokens.splitIcon(widget.size),
        callerFocusNode: _trailingFocusNode,
      );

      if (!mounted) return;
      _closeMenu();
      if (res != null && widget.onSelected != null) {
        widget.onSelected!(res as T);
      }
    }
  }

  Future<void> _showNativeMenu(
    BuildContext context, {
    List<M3ESplitButtonItem<T>>? items,
  }) async {
    setState(() => _menuOpen = true);

    Size tSize = Size.zero;
    final tCtx = _trailingKey.currentContext;
    if (tCtx != null) {
      final tb = tCtx.findRenderObject() as RenderBox?;
      if (tb != null) tSize = tb.size;
    }
    final double minMenuWidth = tSize.width > 0
        ? tSize.width
        : _tokens.splitTrailingWidth(widget.size);

    final (_, onCont, _, _) = _resolveColorsAndShapes(context);

    List<PopupMenuEntry<T>> menuItems;
    if (items != null) {
      menuItems = items.map((e) {
        final Color effective = e.enabled
            ? onCont
            : onCont.withValues(
                alpha: ButtonConstants.kDisabledForegroundAlpha,
              );
        final Widget baseChild = e.child is Widget
            ? e.child as Widget
            : Text('${e.child}');
        final Widget styledChild = IconTheme.merge(
          data: IconThemeData(
            color: effective,
            size: _tokens.splitIcon(widget.size),
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: effective),
            child: baseChild,
          ),
        );
        return PopupMenuItem<T>(
          value: e.value,
          enabled: e.enabled,
          child: styledChild,
        );
      }).toList();
    } else {
      menuItems = widget.menuBuilder!(context);
    }

    final res = await showMenu<T>(
      context: context,
      position: _menuPosition(context),
      constraints: BoxConstraints(minWidth: minMenuWidth),
      items: menuItems,
    );

    if (!mounted) return;
    _closeMenu();
    if (res != null && widget.onSelected != null) widget.onSelected!(res);
  }

  RelativeRect _menuPosition(BuildContext context) {
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final BuildContext tCtx = _trailingKey.currentContext ?? context;
    final RenderBox targetBox = tCtx.findRenderObject() as RenderBox;

    final Offset targetTopLeft = targetBox.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Rect targetRect = Rect.fromLTWH(
      targetTopLeft.dx,
      targetTopLeft.dy,
      targetBox.size.width,
      targetBox.size.height,
    );

    const double kMenuVerticalOffset = 4.0;
    final double top = targetRect.bottom + kMenuVerticalOffset;

    final TextDirection textDir = Directionality.of(context);
    late double left;
    late double right;

    if (textDir == TextDirection.ltr) {
      left = targetRect.left;
      right = overlay.size.width - targetRect.right;
    } else {
      left = targetRect.left;
      right = overlay.size.width - targetRect.right;
    }

    return RelativeRect.fromLTRB(left, top, right, overlay.size.height - top);
  }
}

/// A selectable option used by [M3ESplitButton] menus.
class M3ESplitButtonItem<T> {
  /// Creates a menu item model for [M3ESplitButton].
  const M3ESplitButtonItem({
    required this.value,
    required this.child,
    this.enabled = true,
  });

  /// Value returned through [M3ESplitButton.onSelected] when this item is chosen.
  final T value;

  /// Content shown in the menu item.
  ///
  /// Supports [Widget], [IconData], or any value with a meaningful `toString`.
  final Object child;

  /// Whether this item is interactive in the menu.
  final bool enabled;
}

class _LeadingContent extends StatelessWidget {
  const _LeadingContent({
    required this.size,
    required this.icon,
    required this.label,
    required this.color,
    required this.tokens,
    required this.customSize,
  });

  final M3EButtonSize size;
  final IconData? icon;
  final String? label;
  final Color color;
  final M3EButtonTokensAdapter tokens;
  final M3EButtonSize? customSize;

  @override
  Widget build(BuildContext context) {
    final iconSize = customSize?.iconSize ?? tokens.splitIcon(size);
    final lp =
        customSize?.hPadding ?? tokens.splitLeadingButtonLeadingSpace(size);
    final rp =
        customSize?.hPadding ?? tokens.splitLeadingButtonTrailingSpace(size);
    final iconBlock = iconSize;
    final gap = customSize?.iconGap ?? tokens.splitGapIconToLabel(size);

    final bfs = _getButtonFontSize(size);
    final double? labelFontSize = switch (size.name) {
      'xs' => bfs,
      'sm' => bfs,
      'md' => bfs,
      'lg' => bfs,
      'xl' => bfs,
      _ => bfs,
    };

    Widget content;
    if (icon != null && (label?.isNotEmpty ?? false)) {
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: iconBlock,
            child: Center(
              child: Icon(icon, size: iconSize, color: color),
            ),
          ),
          SizedBox(width: gap),
          Flexible(
            child: Text(
              label!,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: color, fontSize: labelFontSize),
            ),
          ),
        ],
      );
    } else if (icon != null) {
      content = SizedBox(
        width: iconBlock,
        child: Center(
          child: Icon(icon, size: iconSize, color: color),
        ),
      );
    } else {
      content = Text(
        label ?? '',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: color, fontSize: labelFontSize),
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(start: lp, end: rp),
      child: content,
    );
  }

  double? _getButtonFontSize(M3EButtonSize size) {
    switch (size.name) {
      case 'xs':
        return 11;
      case 'sm':
        return 12;
      case 'md':
        return 14;
      case 'lg':
        return 16;
      case 'xl':
        return 22;
      default:
        return 14;
    }
  }
}

class _CornerRadii {
  const _CornerRadii({
    required this.topStart,
    required this.bottomStart,
    required this.topEnd,
    required this.bottomEnd,
  });

  final double topStart, bottomStart, topEnd, bottomEnd;

  BorderRadius toBorderRadius(TextDirection direction) {
    return BorderRadiusDirectional.only(
      topStart: Radius.circular(topStart),
      bottomStart: Radius.circular(bottomStart),
      topEnd: Radius.circular(topEnd),
      bottomEnd: Radius.circular(bottomEnd),
    ).resolve(direction);
  }
}

// ── Specialized subclasses ────────────────────────────────────────────────────

/// A filled-style [M3ESplitButton].
///
/// Equivalent to `M3ESplitButton(style: M3EButtonStyle.filled, ...)`.
class M3EFilledSplitButton<T> extends M3ESplitButton<T> {
  const M3EFilledSplitButton({
    super.key,
    required super.items,
    super.onSelected,
    super.onPressed,
    super.label,
    super.leadingIcon,
    super.size,
    super.shape,
    super.trailingAlignment,
    super.leadingTooltip,
    super.trailingTooltip,
    super.enabled,
    super.menuBuilder,
    super.decoration,
    super.mouseCursor,
    super.statesController,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.selectedValue,
    super.onMultiSelected,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(style: M3EButtonStyle.filled);

  /// A tonal-style [M3ESplitButton].
  ///
  /// Equivalent to `M3ESplitButton(style: M3EButtonStyle.tonal, ...)`.
  const M3EFilledSplitButton.tonal({
    super.key,
    required super.items,
    super.onSelected,
    super.onPressed,
    super.label,
    super.leadingIcon,
    super.size,
    super.shape,
    super.trailingAlignment,
    super.leadingTooltip,
    super.trailingTooltip,
    super.enabled,
    super.menuBuilder,
    super.decoration,
    super.mouseCursor,
    super.statesController,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.selectedValue,
    super.onMultiSelected,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(style: M3EButtonStyle.tonal);
}

/// An elevated-style [M3ESplitButton].
///
/// Equivalent to `M3ESplitButton(style: M3EButtonStyle.elevated, ...)`.
class M3EElevatedSplitButton<T> extends M3ESplitButton<T> {
  const M3EElevatedSplitButton({
    super.key,
    required super.items,
    super.onSelected,
    super.onPressed,
    super.label,
    super.leadingIcon,
    super.size,
    super.shape,
    super.trailingAlignment,
    super.leadingTooltip,
    super.trailingTooltip,
    super.enabled,
    super.menuBuilder,
    super.decoration,
    super.mouseCursor,
    super.statesController,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.selectedValue,
    super.onMultiSelected,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(style: M3EButtonStyle.elevated);
}

/// An outlined-style [M3ESplitButton].
///
/// Equivalent to `M3ESplitButton(style: M3EButtonStyle.outlined, ...)`.
class M3EOutlinedSplitButton<T> extends M3ESplitButton<T> {
  const M3EOutlinedSplitButton({
    super.key,
    required super.items,
    super.onSelected,
    super.onPressed,
    super.label,
    super.leadingIcon,
    super.size,
    super.shape,
    super.trailingAlignment,
    super.leadingTooltip,
    super.trailingTooltip,
    super.enabled,
    super.menuBuilder,
    super.decoration,
    super.mouseCursor,
    super.statesController,
    super.focusNode,
    super.autofocus,
    super.onFocusChange,
    super.selectedValue,
    super.onMultiSelected,
    super.onLongPress,
    super.onHover,
    super.enableFeedback,
    super.splashFactory,
  }) : super(style: M3EButtonStyle.outlined);
}
