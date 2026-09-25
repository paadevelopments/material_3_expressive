import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import '../divider/m3e_divider.dart';
import 'components/m3e_card_container_transform.dart';
import 'components/m3e_card_group_scope.dart';
import 'controllers/m3e_card_controller.dart';
import 'enums/m3e_card_divider_span.dart';
import 'enums/m3e_card_overflow_alignment.dart';
import 'enums/m3e_card_swipe_mode.dart';
import 'enums/m3e_card_variant.dart';
import 'styles/m3e_card_theme.dart';

export 'components/m3e_card_container_transform.dart'
    show M3ECardContainerTransform, M3ECardContainerTransformScope;
export 'components/m3e_card_group.dart';
export 'controllers/m3e_card_controller.dart';
export 'enums/m3e_card_divider_span.dart';
export 'enums/m3e_card_group_layout.dart';
export 'enums/m3e_card_overflow_alignment.dart';
export 'enums/m3e_card_swipe_mode.dart';
export 'enums/m3e_card_variant.dart';
export 'styles/m3e_card_theme.dart';

const double _kSwipeReveal = 80;

SpringMotion _swipeSpring(M3ESpring spring) {
  return const MaterialSpringMotion.expressiveSpatialDefault().copyWith(
    stiffness: spring.stiffness,
    damping: spring.damping,
  );
}

/// A Material 3 card surface for one subject.
///
/// The container is the only required piece. Pass [child] for custom content,
/// or the structured slots for media, text, actions, and overflow.
class M3ECard extends StatefulWidget {
  /// Creates a card.
  const M3ECard({
    this.child,
    this.variant = M3ECardVariant.elevated,
    this.onPressed,
    this.onLongPress,
    this.onSwipe,
    this.swipeMode = M3ECardSwipeMode.both,
    this.swipeAction,
    this.leadingSwipeAction,
    this.trailingSwipeAction,
    this.leadingSwipeColor,
    this.trailingSwipeColor,
    this.alternativeActions,
    this.openBuilder,
    this.controller,
    this.enabled = true,
    this.expanded = false,
    this.dragged = false,
    this.padding,
    this.clipBehavior = Clip.antiAlias,
    this.borderRadius,
    this.color,
    this.elevation,
    this.border,
    this.animationDuration,
    this.animationCurve,
    this.width,
    this.maxHeight,
    this.surfaceKey,
    this.mouseCursor,
    this.semanticLabel,
    this.semanticLink = false,
    this.haptic = M3EHapticFeedback.none,
    this.onStateChanged,
    this.media,
    this.vertical,
    this.mediaDecorative = false,
    this.headline,
    this.subhead,
    this.supportingText,
    this.actions,
    this.overflow,
    this.overflowAlignment = M3ECardOverflowAlignment.topEnd,
    this.dividerAfterMedia = false,
    this.dividerAfterText = false,
    this.mediaDividerSpan = M3ECardDividerSpan.edge,
    this.textDividerSpan = M3ECardDividerSpan.padding,
    this.contentOnMedia = false,
    this.contentOverlayPlate,
    super.key,
  });

  /// Custom content. Omitted from the structured column when null.
  final Widget? child;

  /// Elevated, filled, or outlined.
  final M3ECardVariant variant;

  /// Primary action. Also runs before a container transform opens.
  final VoidCallback? onPressed;

  /// Long-press action.
  final VoidCallback? onLongPress;

  /// Runs after a dismiss swipe. Ignored when [swipeMode] is
  /// [M3ECardSwipeMode.reveal].
  final VoidCallback? onSwipe;

  /// Dismiss only, reveal only, or reveal then dismiss. Defaults to both.
  final M3ECardSwipeMode swipeMode;

  /// Background shown on both sides when [leadingSwipeAction] and
  /// [trailingSwipeAction] are null.
  final Widget? swipeAction;

  /// Revealed on the leading side. In LTR that is a swipe to the right.
  final Widget? leadingSwipeAction;

  /// Revealed on the trailing side. In LTR that is a swipe to the left.
  final Widget? trailingSwipeAction;

  /// Fill behind [leadingSwipeAction]. Null uses the primary container.
  final Color? leadingSwipeColor;

  /// Fill behind [trailingSwipeAction]. Null uses the primary container.
  final Color? trailingSwipeColor;

  /// Long-press menu anchor. Receives the card's global rect so the menu
  /// can open beside the card instead of on top of it.
  final void Function(Rect cardRect)? alternativeActions;

  /// Full-screen destination for the container transform.
  final WidgetBuilder? openBuilder;

  /// Opens and closes [openBuilder].
  final M3ECardController? controller;

  /// When false, the card uses the disabled tokens and ignores input.
  final bool enabled;

  /// Removes the max-height cap so the card can grow with the page.
  final bool expanded;

  /// Paints the dragged elevation and state layer.
  final bool dragged;

  /// Inner padding. Null uses the theme padding.
  final EdgeInsetsGeometry? padding;

  /// How the container clips its child.
  final Clip clipBehavior;

  /// Corner radius. Null uses the theme radius.
  final BorderRadius? borderRadius;

  /// Container color override.
  final Color? color;

  /// Elevation override for every state.
  final double? elevation;

  /// Outline override.
  final BorderSide? border;

  /// Duration of color and elevation changes.
  final Duration? animationDuration;

  /// Curve of color and elevation changes.
  final Curve? animationCurve;

  /// Width of the container.
  final double? width;

  /// Unexpanded content cap. Null uses the theme cap, which is also null.
  final double? maxHeight;

  /// Key for the decorated container.
  final Key? surfaceKey;

  /// Cursor used while the card is actionable.
  final MouseCursor? mouseCursor;

  /// Screen-reader label. Defaults to the headline and supporting text.
  final String? semanticLabel;

  /// Uses a link role instead of a button role when the card is actionable.
  final bool semanticLink;

  /// Tap haptic.
  final M3EHapticFeedback haptic;

  /// Reports hover, focus, press, and drag.
  final ValueChanged<M3EInteractionState>? onStateChanged;

  /// Thumbnail, image, or video.
  final Widget? media;

  /// Stacks [media] above the text.
  ///
  /// Null follows the card group. Outside a group, media sits beside the text.
  final bool? vertical;

  /// Hides [media] from screen readers.
  final bool mediaDecorative;

  /// Primary subject.
  final String? headline;

  /// Secondary context under the headline.
  final String? subhead;

  /// Body copy.
  final String? supportingText;

  /// Buttons and other controls. They keep their own taps and tab stops.
  final Widget? actions;

  /// Overflow control, typically a menu. Placed at [overflowAlignment].
  final Widget? overflow;

  /// Corner used by [overflow].
  final M3ECardOverflowAlignment overflowAlignment;

  /// Divider after [media].
  final bool dividerAfterMedia;

  /// Whether [dividerAfterMedia] reaches the card edges or the padding.
  final M3ECardDividerSpan mediaDividerSpan;

  /// Divider after the text block.
  final bool dividerAfterText;

  /// Whether [dividerAfterText] reaches the card edges or the padding.
  final M3ECardDividerSpan textDividerSpan;

  /// Paints the text on top of [media] with a scrim or plate.
  final bool contentOnMedia;

  /// Plate instead of a scrim when [contentOnMedia] is true. Null uses the theme.
  final bool? contentOverlayPlate;

  @override
  State<M3ECard> createState() => _M3ECardState();
}

class _M3ECardState extends State<M3ECard>
    with SingleTickerProviderStateMixin
    implements M3ECardControllerClient {
  double _swipeDx = 0;
  bool _dismissPending = false;
  int _swipeEpoch = 0;
  bool _transformOpen = false;
  void Function([Object? result])? _closeTransform;
  late final SingleMotionController _swipeMotion;
  final FocusNode _cardFocus = FocusNode(debugLabel: 'M3ECard');
  final ValueNotifier<bool> _keyboardFocused = ValueNotifier<bool>(false);

  bool get _hasPrimaryAction =>
      widget.onPressed != null ||
      widget.onLongPress != null ||
      widget.openBuilder != null ||
      widget.alternativeActions != null;

  bool get _actionable => widget.enabled && _hasPrimaryAction;

  @override
  void initState() {
    super.initState();
    _swipeMotion =
        SingleMotionController(
          motion: _swipeSpring(M3EMotion.expressiveSpatialDefault),
          vsync: this,
        )..addListener(() {
          if (!mounted) {
            return;
          }
          final double dx = _swipeMotion.value;
          setState(() => _swipeDx = dx);
          _commitDismissIfOffscreen(dx);
        });
    widget.controller?.attach(this);
  }

  @override
  void didUpdateWidget(M3ECard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.detach(this);
      widget.controller?.attach(this);
    }
  }

  @override
  void dispose() {
    _swipeMotion.dispose();
    _cardFocus.dispose();
    _keyboardFocused.dispose();
    widget.controller?.detach(this);
    super.dispose();
  }

  @override
  bool get isTransformOpen => _transformOpen;

  @override
  Future<T?> openTransform<T extends Object?>({WidgetBuilder? builder}) async {
    final WidgetBuilder? openBuilder = builder ?? widget.openBuilder;
    if (openBuilder == null || _transformOpen) {
      return null;
    }
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return null;
    }
    final M3EThemeData theme = M3ETheme.of(context);
    final M3ECardTheme cardTheme = theme.cardTheme;
    final BorderRadius radius = widget.borderRadius ?? cardTheme.borderRadius;
    final Rect origin =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    final Color originColor =
        widget.color ??
        cardTheme.containerColorFor(
          theme.colorScheme,
          widget.variant,
          enabled: widget.enabled,
        );
    final M3ECardContainerTransformHandle<T> handle =
        M3ECardContainerTransform.show<T>(
          context: context,
          origin: origin,
          originRadius: radius.topLeft.x,
          originColor: originColor,
          builder: openBuilder,
          scrimColor: cardTheme.resolveTransformScrim(theme.colorScheme),
          openColor: widget.color == null
              ? cardTheme.resolveTransformOpenColor(theme.colorScheme)
              : null,
          endRadius: cardTheme.transformEndRadius,
          contentFadeStart: cardTheme.transformContentFadeStart,
          contentVisibleAt: cardTheme.transformContentVisibleAt,
          motion: cardTheme.transformSpring,
        );
    _closeTransform = ([Object? result]) => handle.close(result as T?);
    setState(() => _transformOpen = true);
    widget.controller?.refresh();
    final T? result = await handle.future;
    _closeTransform = null;
    if (mounted) {
      setState(() => _transformOpen = false);
      widget.controller?.refresh();
    }
    return result;
  }

  @override
  void closeTransform() => _closeTransform?.call();

  void _handleTap() {
    widget.onPressed?.call();
    if (widget.openBuilder != null) {
      openTransform<Object?>();
      return;
    }
    _openAlternativeActions();
  }

  void _handleLongPress() {
    widget.onLongPress?.call();
    _openAlternativeActions();
  }

  void _openAlternativeActions() {
    final void Function(Rect cardRect)? actions = widget.alternativeActions;
    if (actions == null) {
      return;
    }
    final RenderObject? renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      return;
    }
    final Rect rect =
        renderObject.localToGlobal(Offset.zero) & renderObject.size;
    actions(rect);
  }

  bool get _canDismiss =>
      widget.onSwipe != null && widget.swipeMode != M3ECardSwipeMode.reveal;

  bool get _canReveal => widget.swipeMode != M3ECardSwipeMode.dismiss;

  bool get _canSwipe {
    if (!widget.enabled) {
      return false;
    }
    final bool reveal =
        _canReveal &&
        (widget.swipeMode == M3ECardSwipeMode.reveal ||
            widget.onSwipe != null ||
            widget.swipeAction != null ||
            widget.leadingSwipeAction != null ||
            widget.trailingSwipeAction != null);
    return _canDismiss || reveal;
  }

  bool _hasSide({required bool leading}) {
    final Widget? side = leading
        ? widget.leadingSwipeAction
        : widget.trailingSwipeAction;
    if (side != null) {
      return true;
    }
    final bool eitherSide =
        widget.leadingSwipeAction != null || widget.trailingSwipeAction != null;
    if (eitherSide) {
      return false;
    }
    return true;
  }

  void _handleSwipeUpdate(DragUpdateDetails details) {
    if (!_canSwipe) {
      return;
    }
    _swipeEpoch++;
    var next = _swipeMotion.value + details.delta.dx;
    if (widget.swipeMode == M3ECardSwipeMode.reveal) {
      final double min = _hasSide(leading: false) ? -_kSwipeReveal : 0;
      final double max = _hasSide(leading: true) ? _kSwipeReveal : 0;
      if (next < min) {
        next = min;
      } else if (next > max) {
        next = max;
      }
    }
    _swipeMotion
      ..stop()
      ..value = next;
  }

  void _handleSwipeEnd(DragEndDetails details) {
    if (!_canSwipe) {
      _settleSwipe(0, dismiss: false);
      return;
    }
    final double width = context.size?.width ?? 0;
    final double travel = _swipeDx.abs();
    final double velocity = details.primaryVelocity ?? 0;
    final double direction = _swipeDx == 0 ? velocity.sign : _swipeDx.sign;
    if (direction == 0 || width <= 0) {
      _settleSwipe(0, dismiss: false);
      return;
    }
    final bool flingClosed =
        velocity != 0 && velocity.sign != direction && velocity.abs() >= 800;
    if (flingClosed) {
      _settleSwipe(0, dismiss: false);
      return;
    }
    final bool leading = direction > 0;
    final double threshold = M3ETheme.of(context).cardTheme.swipeThreshold;
    final bool flingAway = velocity.sign == direction && velocity.abs() >= 800;
    final bool dismiss =
        _canDismiss &&
        (travel / width >= threshold || (flingAway && travel > 24));
    final bool reveal =
        !dismiss &&
        _canReveal &&
        _hasSide(leading: leading) &&
        travel >= _kSwipeReveal / 2;
    final double target = dismiss
        ? direction * (width + 32)
        : reveal
        ? direction * _kSwipeReveal
        : 0;
    _settleSwipe(target, dismiss: dismiss);
  }

  void _settleSwipe(double target, {required bool dismiss}) {
    final int epoch = ++_swipeEpoch;
    _dismissPending = dismiss;
    _swipeMotion.animateTo(target).whenComplete(() {
      if (!mounted || epoch != _swipeEpoch) {
        return;
      }
      _commitDismissIfOffscreen(_swipeDx);
    });
  }

  void _commitDismissIfOffscreen(double dx) {
    if (!_dismissPending) {
      return;
    }
    final double width = context.size?.width ?? 0;
    if (width <= 0 || dx.abs() < width) {
      return;
    }
    _dismissPending = false;
    _swipeMotion.stop();
    widget.onSwipe?.call();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _swipeMotion.animateTo(0);
    });
  }

  bool _scrollsInternally() {
    if (kIsWeb) {
      return WidgetsBinding.instance.mouseTracker.mouseIsConnected;
    }
    return switch (defaultTargetPlatform) {
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildCard);
  }

  Widget _buildCard(BuildContext context) {
    final theme = M3ETheme.of(context);
    final M3ECardTheme cardTheme = theme.cardTheme;
    final M3ECardGroupScope? group = M3ECardGroupScope.maybeOf(context);
    final BorderRadius radius = widget.borderRadius ?? cardTheme.borderRadius;
    final dragged = widget.dragged || (group?.dragged ?? false);
    final idle = M3EInteractionState(dragged: dragged);

    final body = _actionable
        ? _tappable(theme, cardTheme, group, radius, idle, dragged)
        : _buildSurface(context, theme, cardTheme, group, radius, idle);
    Widget framed = _swipeWrap(body, radius);
    if (_actionable) {
      framed = ValueListenableBuilder<bool>(
        valueListenable: _keyboardFocused,
        builder: (BuildContext context, bool focused, Widget? child) {
          return M3EFocusRing(
            focused: focused,
            radius: radius,
            color: cardTheme.resolveFocusColor(theme.colorScheme),
            width: cardTheme.focusThickness,
            gap: cardTheme.focusGap,
            child: child!,
          );
        },
        child: framed,
      );
    }
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: _onCardKey,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: framed,
      ),
    );
  }

  KeyEventResult _onCardKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || _editableFocused()) {
      return KeyEventResult.ignored;
    }
    final LogicalKeyboardKey key = event.logicalKey;
    if (key == LogicalKeyboardKey.escape) {
      if (_swipeDx.abs() < 1) {
        return KeyEventResult.ignored;
      }
      _settleSwipe(0, dismiss: false);
      if (_actionable) {
        _cardFocus.requestFocus();
      }
      return KeyEventResult.handled;
    }
    if (!_canReveal) {
      return KeyEventResult.ignored;
    }
    final right = key == LogicalKeyboardKey.arrowRight;
    final left = key == LogicalKeyboardKey.arrowLeft;
    if (!right && !left) {
      return KeyEventResult.ignored;
    }
    final ltr = Directionality.of(context) != TextDirection.rtl;
    final leading = ltr ? right : left;
    if (!_hasSide(leading: leading)) {
      return KeyEventResult.ignored;
    }
    final target = leading ? _kSwipeReveal : -_kSwipeReveal;
    if ((_swipeDx - target).abs() < 8) {
      _settleSwipe(0, dismiss: false);
    } else {
      _settleSwipe(target, dismiss: false);
    }
    return KeyEventResult.handled;
  }

  bool _editableFocused() {
    final BuildContext? focusContext =
        FocusManager.instance.primaryFocus?.context;
    if (focusContext == null) {
      return false;
    }
    return focusContext.widget is EditableText ||
        focusContext.findAncestorWidgetOfExactType<EditableText>() != null;
  }

  Widget _tappable(
    M3EThemeData theme,
    M3ECardTheme cardTheme,
    M3ECardGroupScope? group,
    BorderRadius radius,
    M3EInteractionState idle,
    bool dragged,
  ) {
    Widget tappable = M3ETappable(
      enabled: widget.enabled,
      onTap: _handleTap,
      onLongPress:
          widget.onLongPress != null || widget.alternativeActions != null
          ? _handleLongPress
          : null,
      focusNode: _cardFocus,
      mouseCursor: widget.mouseCursor,
      semanticLabel: _spokenLabel(),
      semanticButton: !widget.semanticLink,
      onStateChanged: (M3EInteractionState state) {
        widget.onStateChanged?.call(state);
        if (_keyboardFocused.value != state.focused) {
          _keyboardFocused.value = state.focused;
        }
      },
      materialInk: true,
      haptic: widget.haptic,
      builder: (BuildContext context, M3EInteractionState state) {
        final M3EInteractionState resolved = widget.enabled
            ? state.copyWith(dragged: state.dragged || dragged)
            : idle;
        return _buildSurface(
          context,
          theme,
          cardTheme,
          group,
          radius,
          resolved,
        );
      },
    );
    if (widget.semanticLink) {
      tappable = Semantics(link: true, child: tappable);
    }
    return FocusTraversalOrder(
      order: const NumericFocusOrder(1),
      child: tappable,
    );
  }

  Widget _swipeWrap(Widget child, BorderRadius radius) {
    if (!_canSwipe) {
      return child;
    }
    return ClipRRect(
      borderRadius: radius,
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: _swipeBackdrop()),
          Transform.translate(
            offset: Offset(_swipeDx, 0),
            child: GestureDetector(
              onHorizontalDragUpdate: _handleSwipeUpdate,
              onHorizontalDragEnd: _handleSwipeEnd,
              onHorizontalDragCancel: () => _settleSwipe(0, dismiss: false),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  Widget _swipeBackdrop() {
    final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
    final bool leading = _swipeDx >= 0;
    final Color fill = leading
        ? (widget.leadingSwipeColor ?? scheme.primaryContainer)
        : (widget.trailingSwipeColor ?? scheme.primaryContainer);
    final bool open = leading ? _swipeDx >= 40 : _swipeDx <= -40;
    return ColoredBox(
      color: fill,
      child: Align(
        alignment: leading ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ExcludeFocus(
            excluding: !open,
            child: FocusTraversalOrder(
              order: NumericFocusOrder(leading ? 6 : 7),
              child: _backdropAction(scheme, leading: leading),
            ),
          ),
        ),
      ),
    );
  }

  Widget _backdropAction(M3EColorScheme scheme, {required bool leading}) {
    final Widget? side = leading
        ? widget.leadingSwipeAction
        : widget.trailingSwipeAction;
    if (side != null) {
      return side;
    }
    if (widget.leadingSwipeAction == null &&
        widget.trailingSwipeAction == null &&
        widget.swipeAction != null) {
      return widget.swipeAction!;
    }
    if (widget.leadingSwipeAction == null &&
        widget.trailingSwipeAction == null) {
      return Icon(M3EIcons.favorite_border, color: scheme.onPrimaryContainer);
    }
    return const SizedBox.shrink();
  }

  String? _spokenLabel() {
    if (widget.semanticLabel != null) {
      return widget.semanticLabel;
    }
    final parts = <String>[
      if (widget.headline != null && widget.headline!.isNotEmpty)
        widget.headline!,
      if (widget.supportingText != null && widget.supportingText!.isNotEmpty)
        widget.supportingText!,
    ];
    if (parts.isEmpty) {
      return null;
    }
    return parts.join(', ');
  }

  Widget _buildSurface(
    BuildContext context,
    M3EThemeData theme,
    M3ECardTheme cardTheme,
    M3ECardGroupScope? group,
    BorderRadius radius,
    M3EInteractionState state,
  ) {
    final scheme = theme.colorScheme;
    final double resolvedElevation =
        widget.elevation ?? _elevation(cardTheme, group, state);
    final outlined = widget.variant == M3ECardVariant.outlined;
    final BoxBorder? resolvedBorder = widget.border != null
        ? Border.all(color: widget.border!.color, width: widget.border!.width)
        : (outlined
              ? Border.all(
                  color: cardTheme.outlineColorFor(
                    scheme,
                    enabled: widget.enabled,
                    focused: state.focused,
                  ),
                  width: cardTheme.outlineWidth,
                )
              : null);
    final Color fill =
        widget.color ??
        cardTheme.containerColorFor(
          scheme,
          widget.variant,
          enabled: widget.enabled,
        );
    final bool fadeContent =
        !widget.enabled && widget.variant != M3ECardVariant.outlined;

    Widget content = _buildContent(context, theme, cardTheme, group);
    if (!_hasStructuredContent) {
      content = Padding(
        padding: widget.padding ?? cardTheme.contentPadding,
        child: content,
      );
    }
    content = _limitHeight(content, cardTheme);
    content = _withInteractionFill(scheme, cardTheme, state, content);

    Widget surface = AnimatedContainer(
      key: widget.surfaceKey,
      width: widget.width,
      duration: widget.animationDuration ?? M3EMotion.short4,
      curve: widget.animationCurve ?? M3EMotion.standard,
      clipBehavior: widget.clipBehavior,
      decoration: BoxDecoration(
        color: fill,
        borderRadius: radius,
        border: resolvedBorder,
        boxShadow: M3EElevation.shadows(
          resolvedElevation,
          shadowColor: cardTheme.resolveShadowColor(scheme),
        ),
      ),
      child: _actionable
          ? M3EStateLayerOverlay(
              state: state,
              color: cardTheme.resolveStateLayerColor(scheme),
              shape: RoundedRectangleBorder(borderRadius: radius),
              child: SizedBox(
                width: widget.width ?? double.infinity,
                child: content,
              ),
            )
          : content,
    );

    if (fadeContent) {
      surface = Opacity(opacity: cardTheme.disabledOpacity, child: surface);
    }
    return surface;
  }

  Widget _withInteractionFill(
    M3EColorScheme scheme,
    M3ECardTheme cardTheme,
    M3EInteractionState state,
    Widget content,
  ) {
    final double alpha = state.dragged
        ? M3EStateOpacity.dragged
        : state.focused
        ? M3EStateOpacity.focus
        : 0;
    if (alpha == 0) {
      return content;
    }
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: IgnorePointer(
            child: ColoredBox(
              color: cardTheme
                  .resolveStateLayerColor(scheme)
                  .withValues(alpha: alpha),
            ),
          ),
        ),
        content,
      ],
    );
  }

  double _elevation(
    M3ECardTheme cardTheme,
    M3ECardGroupScope? group,
    M3EInteractionState state,
  ) {
    final double themed = cardTheme.elevation(
      widget.variant,
      hovered: state.hovered,
      focused: state.focused,
      pressed: state.pressed,
      dragged: state.dragged,
      enabled: widget.enabled,
    );
    final double? shared = group?.restingElevation;
    final bool resting =
        widget.enabled &&
        !state.dragged &&
        !state.pressed &&
        !state.focused &&
        !state.hovered;
    if (shared != null && resting) {
      return shared;
    }
    return themed;
  }

  Widget _limitHeight(Widget content, M3ECardTheme cardTheme) {
    if (widget.expanded) {
      return content;
    }
    final double? cap = widget.maxHeight ?? cardTheme.maxHeight;
    if (cap == null) {
      return content;
    }
    if (_scrollsInternally()) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: cap),
        child: SingleChildScrollView(child: content),
      );
    }
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: cap),
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.topCenter,
          minHeight: 0,
          maxHeight: double.infinity,
          child: content,
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    M3EThemeData theme,
    M3ECardTheme cardTheme,
    M3ECardGroupScope? group,
  ) {
    final bool structured = _hasStructuredContent;
    if (!structured) {
      return widget.child ?? const SizedBox.shrink();
    }

    final EdgeInsets pad = (widget.padding ?? cardTheme.contentPadding).resolve(
      Directionality.of(context),
    );
    final bool vertical =
        widget.vertical ?? group?.vertical ?? widget.media == null;
    return _arranged(theme, cardTheme, pad, vertical: vertical);
  }

  bool get _hasStructuredContent =>
      widget.media != null ||
      widget.headline != null ||
      widget.subhead != null ||
      widget.supportingText != null ||
      widget.actions != null ||
      widget.overflow != null ||
      widget.dividerAfterMedia ||
      widget.dividerAfterText;

  Widget _arranged(
    M3EThemeData theme,
    M3ECardTheme cardTheme,
    EdgeInsets pad, {
    required bool vertical,
  }) {
    if (widget.contentOnMedia && widget.media != null) {
      return _mediaOverlay(
        theme,
        cardTheme,
        pad,
        _contentColumn(theme, cardTheme),
      );
    }
    if (!vertical && widget.media != null) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (!constraints.hasBoundedWidth) {
            return _stacked(theme, cardTheme, pad);
          }
          return _besideMedia(theme, cardTheme, pad);
        },
      );
    }
    return _stacked(theme, cardTheme, pad);
  }

  Widget _stacked(M3EThemeData theme, M3ECardTheme cardTheme, EdgeInsets pad) {
    final bool edgeTextDivider =
        widget.dividerAfterText &&
        widget.textDividerSpan == M3ECardDividerSpan.edge;
    final double gap = cardTheme.resolveGap();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.media != null) _mediaSlot(2),
        if (widget.dividerAfterMedia && widget.media != null)
          _divider(widget.mediaDividerSpan, pad),
        if (!edgeTextDivider)
          Padding(padding: pad, child: _contentColumn(theme, cardTheme)),
        if (edgeTextDivider) ...<Widget>[
          Padding(padding: pad, child: _header(theme, cardTheme)),
          const M3EDivider(),
          if (widget.actions != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                pad.left,
                gap,
                pad.right,
                pad.bottom,
              ),
              child: _sorted(4, _blockInner(widget.actions!, 4)),
            ),
        ],
      ],
    );
  }

  Widget _contentColumn(M3EThemeData theme, M3ECardTheme cardTheme) {
    final double gap = cardTheme.resolveGap();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _header(theme, cardTheme),
        if (widget.dividerAfterText) ...<Widget>[
          SizedBox(height: gap),
          const M3EDivider(),
        ],
        if (widget.actions != null) ...<Widget>[
          SizedBox(height: gap),
          _sorted(4, _blockInner(widget.actions!, 4)),
        ],
        if (widget.overflow != null &&
            widget.overflowAlignment == M3ECardOverflowAlignment.bottomEnd)
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: _sorted(5, _blockInner(widget.overflow!, 5)),
          ),
      ],
    );
  }

  Widget _header(M3EThemeData theme, M3ECardTheme cardTheme) {
    final bool overflowAtEnd =
        widget.overflow != null &&
        widget.overflowAlignment == M3ECardOverflowAlignment.topEnd;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: _textLines(theme, cardTheme)),
        if (overflowAtEnd) _sorted(5, _blockInner(widget.overflow!, 5)),
      ],
    );
  }

  Widget _divider(M3ECardDividerSpan span, EdgeInsets pad) {
    if (span == M3ECardDividerSpan.edge) {
      return const M3EDivider();
    }
    return Padding(
      padding: EdgeInsets.only(left: pad.left, right: pad.right),
      child: const M3EDivider(),
    );
  }

  Widget _mediaSlot(double order) {
    final media = widget.media ?? const SizedBox.shrink();
    final Widget slot = widget.mediaDecorative
        ? ExcludeSemantics(child: media)
        : media;
    if (_actionable) {
      return slot;
    }
    return Semantics(sortKey: OrdinalSortKey(order), child: slot);
  }

  Widget _textLines(M3EThemeData theme, M3ECardTheme cardTheme) {
    final double gap = cardTheme.resolveGap();
    final lines = <Widget>[
      if (widget.headline != null)
        _sorted(
          1,
          Text(widget.headline!, style: cardTheme.headlineStyle(theme)),
        ),
      if (widget.subhead != null)
        _sorted(3, Text(widget.subhead!, style: cardTheme.subheadStyle(theme))),
      if (widget.supportingText != null)
        _sorted(
          3.1,
          Text(widget.supportingText!, style: cardTheme.supportingStyle(theme)),
        ),
      if (widget.child != null) _sorted(3.2, widget.child!),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var i = 0; i < lines.length; i++) ...<Widget>[
          if (i > 0) SizedBox(height: gap),
          lines[i],
        ],
      ],
    );
  }

  Widget _besideMedia(
    M3EThemeData theme,
    M3ECardTheme cardTheme,
    EdgeInsets pad,
  ) {
    final bool rule = widget.dividerAfterMedia && widget.media != null;
    final edge = widget.mediaDividerSpan == M3ECardDividerSpan.edge;
    final Widget media = _mediaSlot(2);
    final Widget content = _contentColumn(theme, cardTheme);
    final Widget divider = const M3EDivider(axis: M3EDividerAxis.vertical);
    if (!rule) {
      return Padding(
        padding: pad,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            media,
            Expanded(child: content),
          ],
        ),
      );
    }
    if (edge) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(padding: pad, child: media),
            divider,
            Expanded(
              child: Padding(padding: pad, child: content),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: pad,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            media,
            divider,
            Expanded(child: content),
          ],
        ),
      ),
    );
  }

  Widget _mediaOverlay(
    M3EThemeData theme,
    M3ECardTheme cardTheme,
    EdgeInsets pad,
    Widget text,
  ) {
    final bool plate =
        widget.contentOverlayPlate ?? cardTheme.contentOverlayPlate;
    final M3EColorScheme scheme = theme.colorScheme;
    final Widget backing = plate
        ? ColoredBox(color: cardTheme.resolveOverlayPlate(scheme), child: text)
        : text;
    final inset = widget.mediaDividerSpan == M3ECardDividerSpan.padding;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Widget media = constraints.hasBoundedWidth
            ? SizedBox(width: constraints.maxWidth, child: _mediaSlot(2))
            : _mediaSlot(2);
        return Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            media,
            if (!plate)
              Positioned.fill(
                child: ColoredBox(color: cardTheme.resolveScrimColor(scheme)),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(padding: pad, child: backing),
            ),
            if (widget.dividerAfterMedia && widget.media != null)
              Positioned(
                left: inset ? pad.left : 0,
                right: inset ? pad.right : 0,
                bottom: 0,
                child: const M3EDivider(),
              ),
          ],
        );
      },
    );
  }

  Widget _sorted(double order, Widget child) {
    if (_actionable) {
      return child;
    }
    return Semantics(sortKey: OrdinalSortKey(order), child: child);
  }

  Widget _blockInner(Widget child, double order) {
    return FocusTraversalOrder(order: NumericFocusOrder(order), child: child);
  }
}
