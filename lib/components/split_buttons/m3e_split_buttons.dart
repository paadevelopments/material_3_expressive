// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../foundations/foundations.dart';
import '../buttons/components/m3e_base_button_state.dart';
import '../buttons/components/m3e_focus_ring.dart';
import '../buttons/enums/m3e_button_enums.dart';
import '../buttons/res/m3e_button_constants.dart';
import '../buttons/styles/m3e_button_motion.dart';
import '../buttons/styles/m3e_button_theme.dart';
import 'components/m3e_split_button_bottom_sheet.dart';
import '../menus/m3e_menus.dart';
import 'enums/m3e_split_button_menu_style.dart';
import 'enums/m3e_split_button_selection_mode.dart';
import 'enums/m3e_split_button_trailing_alignment.dart';
import 'models/m3e_split_button_item.dart';
import 'styles/m3e_split_button_bottom_sheet_decoration.dart';
import 'styles/m3e_split_button_decoration.dart';
import 'styles/m3e_split_button_popup_decoration.dart';
import 'styles/m3e_split_button_theme.dart';

export 'styles/m3e_split_button_theme.dart';

const bool _kDefaultEnableFeedback = true;

/// Material 3 Expressive Split Button.
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

  /// A filled split button (highest emphasis).
  const M3ESplitButton.filled({
    super.key,
    required this.items,
    this.onSelected,
    this.onPressed,
    this.label,
    this.leadingIcon,
    this.size = M3EButtonSize.sm,
    this.shape = M3EButtonShape.round,
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
  })  : style = M3EButtonStyle.filled,
        assert(
          items != null || menuBuilder != null,
          'Provide either `items` or `menuBuilder`.',
        );

  /// A tonal split button (medium emphasis).
  const M3ESplitButton.tonal({
    super.key,
    required this.items,
    this.onSelected,
    this.onPressed,
    this.label,
    this.leadingIcon,
    this.size = M3EButtonSize.sm,
    this.shape = M3EButtonShape.round,
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
  })  : style = M3EButtonStyle.tonal,
        assert(
          items != null || menuBuilder != null,
          'Provide either `items` or `menuBuilder`.',
        );

  /// An elevated split button (medium emphasis with a shadow).
  const M3ESplitButton.elevated({
    super.key,
    required this.items,
    this.onSelected,
    this.onPressed,
    this.label,
    this.leadingIcon,
    this.size = M3EButtonSize.sm,
    this.shape = M3EButtonShape.round,
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
  })  : style = M3EButtonStyle.elevated,
        assert(
          items != null || menuBuilder != null,
          'Provide either `items` or `menuBuilder`.',
        );

  /// An outlined split button (medium emphasis with a border).
  const M3ESplitButton.outlined({
    super.key,
    required this.items,
    this.onSelected,
    this.onPressed,
    this.label,
    this.leadingIcon,
    this.size = M3EButtonSize.sm,
    this.shape = M3EButtonShape.round,
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
  })  : style = M3EButtonStyle.outlined,
        assert(
          items != null || menuBuilder != null,
          'Provide either `items` or `menuBuilder`.',
        );

  final List<M3ESplitButtonItem<T>>? items;
  final ValueChanged<T>? onSelected;
  final VoidCallback? onPressed;
  final String? label;
  final IconData? leadingIcon;
  final M3EButtonSize size;
  final M3EButtonShape shape;
  final M3EButtonStyle style;
  final M3ESplitButtonTrailingAlignment trailingAlignment;
  final String? leadingTooltip;
  final String? trailingTooltip;
  final bool enabled;
  final List<PopupMenuEntry<T>> Function(BuildContext)? menuBuilder;
  final M3ESplitButtonDecoration? decoration;
  final MouseCursor? mouseCursor;
  final WidgetStatesController? statesController;
  final FocusNode? focusNode;
  final bool autofocus;
  final ValueChanged<bool>? onFocusChange;
  final T? selectedValue;
  final void Function(Set<T>)? onMultiSelected;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final bool enableFeedback;
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
  bool _leadingPressed = false;
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

  M3EButtonTheme get _buttonTheme => M3ETheme.of(context).buttonTheme;

  M3ESplitButtonTheme get _splitTheme => M3ETheme.of(context).splitButtonTheme;

  M3EColorScheme get _scheme => M3ETheme.of(context).colorScheme;

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
    return M3EComponentTheme(builder: (context) => buildAnimatedContent(
      builder: (context, pressed, hovered, focused) {
        return _buildContent(context, pressed, hovered, focused);
      },
    ),
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
        leadingCustomSize?.height ?? _splitTheme.splitHeight(size);
    final trailingHeight =
        trailingCustomSize?.height ?? _splitTheme.splitHeight(size);
    final maxSegmentHeight = leadingHeight > trailingHeight
        ? leadingHeight
        : trailingHeight;
    final minTap = _splitTheme.minTapTarget;
    final double? explicitBorderRadius = widget.decorationBorderRadius;
    final outerRadius =
        explicitBorderRadius ??
            (widget.shape == M3EButtonShape.round
                ? maxSegmentHeight / 2
                : _splitTheme.splitOuterRadiusSquare(size));
    final pressedRadius =
        widget.decoration?.pressedRadius ??
            explicitBorderRadius ??
            _splitTheme.splitPressedRadius(size);
    final innerRadius =
        explicitBorderRadius ?? _splitTheme.splitInnerCornerRadius(size);
    final hoveredInnerRadius =
        widget.decoration?.hoveredRadius ??
            explicitBorderRadius ??
            _splitTheme.splitHoveredInnerCornerRadius(size);
    final trailingSelectedRadius =
        widget.decoration?.trailingSelectedRadius ??
            explicitBorderRadius ??
            trailingHeight *
                (_splitTheme.trailingInnerSelectedCornerPercent / 100);

    final baseGap =
        widget.decorationGap ??
            (widget.style == M3EButtonStyle.elevated
                ? _splitTheme.elevatedInnerGap
                : _splitTheme.innerGap);

    const double focusRingOutset =
        M3EButtonConstants.kFocusRingGap + M3EButtonConstants.kFocusRingWidth;
    final eitherFocused = focused || _isTrailingFocused;
    final focusRingExtra = eitherFocused ? focusRingOutset : 0.0;
    final gap = baseGap + focusRingExtra;

    final leadingEnabled = widget.enabled && widget.onPressed != null;
    final trailingEnabled = widget.enabled;

    final leadingPressed = leadingEnabled && (pressed || _leadingPressed);
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
            _splitTheme.splitTrailingButtonLeadingSpace(size)) +
            (trailingCustomSize?.iconSize ?? _splitTheme.splitTrailingIconSize(size)) +
            (trailingCustomSize?.hPadding ??
                _splitTheme.splitTrailingButtonTrailingSpace(size));
    final trailingWidthSelected =
        (trailingCustomSize?.hPadding ??
            _splitTheme.splitSidePaddingSelected(size)) *
            2 +
            (trailingCustomSize?.iconSize ?? _splitTheme.splitTrailingIconSize(size));

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
        _splitTheme.splitSidePaddingSelected(size))
        : (trailingCustomSize?.hPadding ??
        _splitTheme.splitTrailingButtonLeadingSpace(size)));
    final trailingRightPad = circleTrailing
        ? 0.0
        : (_menuOpen
        ? (trailingCustomSize?.hPadding ??
        _splitTheme.splitSidePaddingSelected(size))
        : (trailingCustomSize?.hPadding ??
        _splitTheme.splitTrailingButtonTrailingSpace(size)));

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
        ? _splitTheme.splitMenuIconOffset(size)
        : 0.0;

    final chevronTargetTurns = _menuOpen ? _splitTheme.chevronOpenTurns : 0.0;

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

    final m3eTheme = M3ETheme.of(context);
    final scheme = _scheme;
    final splitTheme = _splitTheme;
    final bool contIsTransparent = cont.a == 0.0;
    final Color menuColor =
        widget.decorationMenuBackgroundColor ??
            splitTheme.menuBackgroundColor(
              scheme,
              containerIsTransparent: contIsTransparent,
              containerColor: cont,
            );
    final Color menuTextColor =
        widget.decorationMenuForegroundColor ??
            splitTheme.menuForegroundColor(
              scheme,
              containerIsTransparent: contIsTransparent,
              onContainerColor: onCont,
            );

    return PopupMenuTheme(
      data: PopupMenuThemeData(
        color: menuColor,
        textStyle: m3eTheme.typeScale.labelLarge.copyWith(color: menuTextColor),
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

    final animatedButton = AnimatedContainer(
      duration: pressed
          ? Duration.zero
          : const Duration(milliseconds: 120),
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
            onTapDown: widget.enabled && widget.onPressed != null
                ? (_) => setState(() => _leadingPressed = true)
                : null,
            onTapUp: widget.enabled && widget.onPressed != null
                ? (_) => setState(() => _leadingPressed = false)
                : null,
            onTapCancel: widget.enabled && widget.onPressed != null
                ? () => setState(() => _leadingPressed = false)
                : null,
            statesController: statesController,
            canRequestFocus: false,
            mouseCursor:
            widget.decoration?.mouseCursor?.resolve({...segmentStates}) ??
                widget.mouseCursor ??
                SystemMouseCursors.click,
            enableFeedback: widget.enableFeedback,
            splashFactory: widget.splashFactory ?? InkSparkle.splashFactory,
            splashColor: M3EStateLayer.splashColor(onColor),
            highlightColor: Colors.transparent,
            overlayColor: widget.decorationOverlayColor ??
                M3EStateLayer.overlayColorHoverFocus(onColor),
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
        child: M3EFocusRing(
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

    final chevron = AnimatedRotation(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      turns: chevronTargetTurns,
      child: Transform.translate(
        offset: Offset(chevronDxOffset, 0.0),
        child: Icon(
          M3EIcons.keyboard_arrow_down,
          size:
          customSize?.iconSize ??
              _splitTheme.splitTrailingIconSize(widget.size),
          color: onColor,
        ),
      ),
    );

    final animatedButton = AnimatedContainer(
      duration: pressed
          ? Duration.zero
          : const Duration(milliseconds: 120),
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
            color: M3ETheme.of(context)
                .colorScheme
                .shadow
                .withValues(alpha: 0.15),
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
            splashFactory: widget.splashFactory ?? InkSparkle.splashFactory,
            splashColor: M3EStateLayer.splashColor(onColor),
            highlightColor: Colors.transparent,
            overlayColor: widget.decorationOverlayColor ??
                M3EStateLayer.overlayColorHoverFocus(onColor),
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
          child: M3EFocusRing(
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
            _buttonTheme.foreground(_scheme, widget.style);
    Color bgColor =
        widget.decorationBackgroundColor?.resolve({}) ??
            (widget.style == M3EButtonStyle.outlined
                ? Colors.transparent
                : _buttonTheme.container(_scheme, widget.style));

    BorderSide? outlineSide;
    if (widget.style == M3EButtonStyle.outlined) {
      outlineSide =
          widget.decorationBorderSide?.resolve({}) ??
              BorderSide(color: _buttonTheme.outline(_scheme));
    }

    if (!widget.enabled || widget.onPressed == null) {
      final cs = _scheme;
      fgColor =
          widget.decoration?.foregroundColor?.resolve({WidgetState.disabled}) ??
              cs.onSurface.withValues(
                alpha: M3EButtonConstants.kDisabledForegroundAlpha,
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
          alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
        );
      }

      if (outlineSide != null) {
        outlineSide = BorderSide(
          color: cs.onSurface.withValues(
            alpha: M3EButtonConstants.kDisabledOutlineAlpha,
          ),
          width: outlineSide.width,
          style: outlineSide.style,
        );
      }
    }

    return (bgColor, fgColor, outlineSide, null);
  }

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
    final value = _buttonTheme.elevation(widget.style, states);
    return value == 0 ? null : value;
  }

  void _triggerHaptic() {
    final haptic = widget.decorationHaptic;
    if (haptic == M3EHapticFeedback.none) return;
    M3EButtonConstants.triggerHapticFeedback(haptic);
  }

  Future<void> _openMenu(BuildContext context) async {
    if (widget.menuBuilder != null) {
      await _showNativeMenu(context);
      return;
    }

    final items = widget.items!;
    final menuStyle =
        widget.decoration?.menuStyle ?? M3ESplitButtonMenuStyle.popup;

    switch (menuStyle) {
      case M3ESplitButtonMenuStyle.popup:
        await _showSpringPopup(context, items);
      case M3ESplitButtonMenuStyle.bottomSheet:
        await _showBottomSheet(context, items);
      case M3ESplitButtonMenuStyle.native:
        await _showNativeMenu(context, items: items);
    }
  }

  Future<void> _showSpringPopup(
      BuildContext context,
      List<M3ESplitButtonItem<T>> items,
      ) async {
    setState(() => _menuOpen = true);

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

    final popupDec = widget.decoration?.popupDecoration ??
        M3ESplitButtonPopupDecoration(
          backgroundColor: _splitTheme.popupBackgroundColor(_scheme),
          elevation: _splitTheme.popupElevation,
          borderRadius:
              BorderRadius.circular(_splitTheme.popupBorderRadius),
          offset: _splitTheme.popupOffset,
          minWidth: _splitTheme.popupMinWidth,
          maxWidth: _splitTheme.popupMaxWidth,
          maxHeight: _splitTheme.popupMaxHeight,
          padding: _splitTheme.popupPadding,
          motion: _splitTheme.popupMotion,
        );

    final iconSize = _splitTheme.splitIcon(widget.size);
    final menuTheme = M3ETheme.of(context).menuTheme.copyWith(
          minWidth: popupDec.minWidth,
          maxWidth: popupDec.maxWidth,
          maxHeight: popupDec.maxHeight,
          elevation: popupDec.elevation ?? _splitTheme.popupElevation,
          backgroundColor: popupDec.backgroundColor,
          anchorOffset: popupDec.offset.dy != 0
              ? popupDec.offset.dy
              : M3ETheme.of(context).menuTheme.anchorOffset,
        );

    final nodes = <M3EMenuNode>[
      for (final item in items)
        _splitItemToMenuNode(item, iconSize: iconSize),
    ];

    final anchor = tb.localToGlobal(Offset.zero) & tb.size;
    final res = await showM3EMenu<T>(
      context: context,
      anchor: anchor,
      children: nodes,
      position: M3EMenuAnchorPosition.bottomEnd,
      selectedValue: widget.selectedValue,
      preferredWidth: (tb.size.width + 176.0).clamp(
        popupDec.minWidth,
        popupDec.maxWidth,
      ),
      callerFocusNode: _trailingFocusNode,
      themeOverride: menuTheme,
    );

    if (!mounted) return;
    _closeMenu();
    if (res != null && widget.onSelected != null) widget.onSelected!(res);
  }

  /// Maps a split-button item to a menu node using [M3EMenuTheme] colors
  /// (not the split button's on-container color).
  M3EMenuNode _splitItemToMenuNode(
    M3ESplitButtonItem<T> item, {
    required double iconSize,
  }) {
    final selected =
        widget.selectedValue != null && widget.selectedValue == item.value;
    final theme = M3ETheme.of(context);
    final menuTheme = theme.menuTheme;
    final scheme = theme.colorScheme;
    final foreground = menuTheme.entryForegroundColor(
      scheme,
      enabled: item.enabled,
    );
    final labelStyle = menuTheme.entryLabelStyle(
      theme.typeScale,
      scheme,
      enabled: item.enabled,
    );

    if (item.child is IconData) {
      return M3EMenuSelectable(
        label: item.child.toString(),
        value: item.value as Object,
        enabled: item.enabled,
        selected: selected,
        leading: Icon(
          item.child as IconData,
          size: iconSize,
        ),
      );
    }

    if (item.child is Widget) {
      return M3EMenuWidget(
        value: item.value,
        enabled: item.enabled,
        selected: selected,
        child: IconTheme.merge(
          data: IconThemeData(color: foreground, size: iconSize),
          child: DefaultTextStyle.merge(
            style: labelStyle,
            child: item.child as Widget,
          ),
        ),
      );
    }

    return M3EMenuSelectable(
      label: item.child.toString(),
      value: item.value as Object,
      enabled: item.enabled,
      selected: selected,
    );
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
        bottomSheetDec.selectionMode == M3ESplitButtonSelectionMode.multiple;

    if (isMultiSelect) {
      final result = await showSplitButtonBottomSheet<T>(
        context: context,
        items: items,
        decoration: bottomSheetDec,
        foregroundColor: widget.decorationMenuForegroundColor ?? onCont,
        iconSize: _splitTheme.splitIcon(widget.size),
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
        iconSize: _splitTheme.splitIcon(widget.size),
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
    RenderBox? tb;
    if (tCtx != null) {
      tb = tCtx.findRenderObject() as RenderBox?;
      if (tb != null) tSize = tb.size;
    }
    final double minMenuWidth = tSize.width > 0
        ? tSize.width
        : _splitTheme.splitTrailingWidth(widget.size);

    // Custom PopupMenuEntry builder — keep Material showMenu.
    if (items == null) {
      final res = await showMenu<T>(
        context: context,
        position: _menuPosition(context),
        constraints: BoxConstraints(minWidth: minMenuWidth),
        items: widget.menuBuilder!(context),
      );
      if (!mounted) return;
      _closeMenu();
      if (res != null && widget.onSelected != null) widget.onSelected!(res);
      return;
    }

    if (tb == null) {
      _closeMenu();
      return;
    }

    final iconSize = _splitTheme.splitIcon(widget.size);
    final nodes = <M3EMenuNode>[
      for (final item in items)
        _splitItemToMenuNode(item, iconSize: iconSize),
    ];

    final anchor = tb.localToGlobal(Offset.zero) & tb.size;
    final res = await showM3EMenu<T>(
      context: context,
      anchor: anchor,
      children: nodes,
      position: M3EMenuAnchorPosition.bottomEnd,
      selectedValue: widget.selectedValue,
      preferredWidth: minMenuWidth,
      callerFocusNode: _trailingFocusNode,
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

class _LeadingContent extends StatelessWidget {
  const _LeadingContent({
    required this.size,
    required this.icon,
    required this.label,
    required this.color,
    required this.customSize,
  });

  final M3EButtonSize size;
  final IconData? icon;
  final String? label;
  final Color color;
  final M3EButtonSize? customSize;

  @override
  Widget build(BuildContext context) {
    final splitTheme = M3ETheme.of(context).splitButtonTheme;
    final iconSize = customSize?.iconSize ?? splitTheme.splitIcon(size);
    final lp =
        customSize?.hPadding ?? splitTheme.splitLeadingButtonLeadingSpace(size);
    final rp =
        customSize?.hPadding ?? splitTheme.splitLeadingButtonTrailingSpace(size);
    final iconBlock = iconSize;
    final gap = customSize?.iconGap ?? splitTheme.splitGapIconToLabel(size);

    final type = M3ETheme.of(context).typeScale;
    final base = switch (size.name) {
      'xs' => type.labelSmall,
      'sm' => type.labelMedium,
      'md' => type.labelLarge,
      'lg' => type.titleMedium,
      'xl' => type.titleLarge,
      _ => type.labelLarge,
    };
    final labelStyle = base.copyWith(
      color: color,
      overflow: TextOverflow.ellipsis,
    );

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
              style: labelStyle,
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
        style: labelStyle,
      );
    }

    return Padding(
      padding: EdgeInsetsDirectional.only(start: lp, end: rp),
      child: content,
    );
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
