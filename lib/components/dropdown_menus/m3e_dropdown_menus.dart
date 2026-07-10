// Ported from https://github.com/Mudit200408/m3e_dropdown_menu
// Adapted for material_3_expressive: import paths, foundations wiring, M3E naming.

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:motor/motor.dart';

import '../../foundations/foundations.dart';
import '../buttons/enums/m3e_button_enums.dart';
import '../buttons/res/m3e_button_constants.dart';
import 'components/m3e_dropdown_chips.dart';
import 'components/m3e_dropdown_menu_item.dart';
import 'controllers/m3e_dropdown_controller.dart';
import 'enums/m3e_dropdown_expand_direction.dart';
import 'models/m3e_dropdown_item.dart';
import 'styles/m3e_dropdown_chip_style.dart';
import 'styles/m3e_dropdown_field_style.dart';
import 'styles/m3e_dropdown_item_style.dart';
import 'styles/m3e_dropdown_panel_style.dart';
import 'styles/m3e_dropdown_search_style.dart';
import 'utils/m3e_dropdown_spring_motion.dart';

export 'controllers/m3e_dropdown_controller.dart';
export 'enums/m3e_dropdown_expand_direction.dart';
export 'models/m3e_dropdown_item.dart';
export 'styles/m3e_dropdown_chip_style.dart';
export 'styles/m3e_dropdown_field_style.dart';
export 'styles/m3e_dropdown_item_style.dart';
export 'styles/m3e_dropdown_menu_theme.dart';
export 'styles/m3e_dropdown_panel_style.dart';
export 'styles/m3e_dropdown_search_style.dart';

/// Signature for a function that asynchronously returns dropdown items.
typedef M3EDropdownFutureRequest<T> =
    Future<List<M3EDropdownItem<T>>> Function();

/// Signature for a custom item builder inside the dropdown list.
typedef M3EDropdownItemBuilder<T> = Widget Function(
  M3EDropdownItem<T> item, {
  required bool selected,
  required VoidCallback onTap,
});

/// A Material 3 Expressive dropdown menu.
///
/// Features M3E‑style outer / inner radius, spring animation powered by the
/// `motor` package, optional multi‑select, search, chip display, async data
/// loading, and customisable trailing icon with animated rotation.
///
/// ## Basic usage
///
/// ```dart
/// M3EDropdownMenu<String>(
///   items: [
///     M3EDropdownItem(label: 'Apple', value: 'apple'),
///     M3EDropdownItem(label: 'Banana', value: 'banana'),
///   ],
///   onSelectionChanged: (items) => print(items),
/// )
/// ```
///
/// ## Async data loading
///
/// ```dart
/// M3EDropdownMenu<int>.future(
///   future: () async {
///     final data = await fetchItems();
///     return data.map((e) => M3EDropdownItem(label: e.name, value: e.id)).toList();
///   },
/// )
/// ```
class M3EDropdownMenu<T> extends StatefulWidget {
  // ── Data ──

  /// The list of items. Ignored when using the [M3EDropdownMenu.future]
  /// constructor (items will be loaded asynchronously).
  final List<M3EDropdownItem<T>> items;

  /// Async item provider. When non-null the dropdown starts in a loading
  /// state and populates items once the future completes.
  final M3EDropdownFutureRequest<T>? future;

  // ── Behaviour ──

  /// When `true`, only a single item can be selected at a time.
  ///
  /// Defaults to `false` (multi-select).
  final bool singleSelect;

  /// Whether to show a search field inside the dropdown.
  final bool searchEnabled;

  /// Whether to show selected items as chips inside the field.
  /// Defaults to `true` when using the default [selectedItemBuilder] to allow the builder to take advantage of chip animations, but can be set to `false` to disable animations while keeping custom rendering.
  final bool showChipAnimation;

  /// Maximum number of selectable items. `0` means unlimited.
  final int maxSelections;

  /// Called whenever the selection changes.
  final ValueChanged<List<M3EDropdownItem<T>>>? onSelectionChanged;

  /// Called when the search text changes.
  final ValueChanged<String>? onSearchChanged;

  /// Optional programmatic controller.
  final M3EDropdownController<T>? controller;

  /// Whether the dropdown is enabled.
  final bool enabled;

  // ── Shape ──

  /// Radius applied to the dropdown panel container and (when no
  /// [M3EDropdownFieldStyle.borderRadius] is set) the field.
  ///
  /// Defaults to `28.0`.
  final double containerRadius;

  // ── Styling ──

  /// Field style.
  final M3EDropdownFieldStyle fieldStyle;

  /// Dropdown panel style.
  final M3EDropdownPanelStyle dropdownStyle;

  /// Chip style (only used when [showChipAnimation] is true).
  final M3EDropdownChipStyle chipStyle;

  /// Search field style (only used when [searchEnabled] is true).
  final M3EDropdownSearchStyle searchStyle;

  /// Item style.
  final M3EDropdownItemStyle itemStyle;

  /// Optional builder for each dropdown item – overrides default rendering.
  final M3EDropdownItemBuilder<T>? itemBuilder;

  /// Optional builder for the empty state when no items match the filter.
  final WidgetBuilder? emptyBuilder;

  /// Optional builder for each selected item in the field.
  ///
  /// If provided, replaces the default chip rendering. When using this,
  /// [showChipAnimation] should be `true` for the builder to take animations from chips.
  /// Defaut is `true` to allow the builder to take advantage of chip animations, but can be set to `false` to disable animations while keeping custom rendering.
  final Widget Function(M3EDropdownItem<T> item)? selectedItemBuilder;

  /// An optional widget placed between dropdown items.
  ///
  /// When non-null, overrides `itemGap` inside [M3EDropdownItemStyle.itemGap] and is used as the separator in
  /// the dropdown item list.
  final Widget? itemSeparator;

  // ── Form ──

  /// Optional validator for form integration.
  ///
  /// Return a non-null string to indicate a validation error.
  final String? Function(List<M3EDropdownItem<T>>? selectedOptions)? validator;

  /// The autovalidate mode for the dropdown when used inside a [Form].
  final AutovalidateMode autovalidateMode;

  // ── Focus ──

  /// An optional [FocusNode] for the dropdown field.
  final FocusNode? focusNode;

  /// Whether to close the dropdown when the system back button is pressed.
  ///
  /// Note: This requires the app to use a [Router] (e.g. `MaterialApp.router`).
  final bool closeOnBackButton;

  // ── Animation ──

  /// The spring motion for the expand animation.
  ///
  /// Defaults to [M3EMotion.expressiveSpatialDefault].
  final M3ESpring openMotion;

  /// The spring motion for the collapse animation.
  ///
  /// Defaults to [M3EMotion.expressiveSpatialDefault].
  final M3ESpring closeMotion;

  // ── Splash ──

  /// The [InteractiveInkFeatureFactory] used for tap feedback on the field
  /// and dropdown items.
  ///
  /// Defaults to [NoSplash.splashFactory] (no ripple). Pass
  /// [InkSplash.splashFactory] or [InkRipple.splashFactory] to restore
  /// material splash feedback.
  final InteractiveInkFeatureFactory? splashFactory;

  // ── Haptics ──

  /// Haptic feedback level on tap.
  final M3EHapticFeedback haptic;

  /// Creates an [M3EDropdownMenu] with a static list of items.
  const M3EDropdownMenu({
    super.key,
    required this.items,
    this.singleSelect = false,
    this.searchEnabled = false,
    this.showChipAnimation = true,
    this.maxSelections = 0,
    this.onSelectionChanged,
    this.onSearchChanged,
    this.controller,
    this.enabled = true,
    this.containerRadius = 28.0,
    this.fieldStyle = const M3EDropdownFieldStyle(),
    this.dropdownStyle = const M3EDropdownPanelStyle(),
    this.chipStyle = const M3EDropdownChipStyle(),
    this.searchStyle = const M3EDropdownSearchStyle(),
    this.itemStyle = const M3EDropdownItemStyle(),
    this.itemBuilder,
    this.emptyBuilder,
    this.selectedItemBuilder,
    this.itemSeparator,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.focusNode,
    this.closeOnBackButton = false,
    this.openMotion = M3EMotion.expressiveSpatialDefault,
    this.closeMotion = M3EMotion.expressiveSpatialDefault,
    this.splashFactory = NoSplash.splashFactory,
    this.haptic = M3EHapticFeedback.none,
  }) : future = null;

  /// Creates an [M3EDropdownMenu] that loads items asynchronously.
  const M3EDropdownMenu.future({
    super.key,
    required this.future,
    this.singleSelect = false,
    this.searchEnabled = false,
    this.showChipAnimation = false,
    this.maxSelections = 0,
    this.onSelectionChanged,
    this.onSearchChanged,
    this.controller,
    this.enabled = true,
    this.containerRadius = 28.0,
    this.fieldStyle = const M3EDropdownFieldStyle(),
    this.dropdownStyle = const M3EDropdownPanelStyle(),
    this.chipStyle = const M3EDropdownChipStyle(),
    this.searchStyle = const M3EDropdownSearchStyle(),
    this.itemStyle = const M3EDropdownItemStyle(),
    this.itemBuilder,
    this.emptyBuilder,
    this.selectedItemBuilder,
    this.itemSeparator,
    this.validator,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.focusNode,
    this.closeOnBackButton = false,
    this.openMotion = M3EMotion.expressiveSpatialDefault,
    this.closeMotion = M3EMotion.expressiveSpatialDefault,
    this.splashFactory = NoSplash.splashFactory,
    this.haptic = M3EHapticFeedback.none,
  }) : items = const [];

  @override
  State<M3EDropdownMenu<T>> createState() => _M3EDropdownMenuState<T>();
}

class _M3EDropdownMenuState<T> extends State<M3EDropdownMenu<T>>
    with TickerProviderStateMixin {
  late M3EDropdownController<T> _controller;
  bool _ownController = false;

  // Interaction states for field
  bool _isHoveredField = false;
  bool _isPressedField = false;

  // Track selection state for field duration logic
  bool _lastIsOpen = false;

  // Chip slide controllers — keyed by item value
  final Map<Object, SingleMotionController> _chipSlideControllers = {};
  final Map<Object, GlobalKey<M3ESpringChipState>> _chipKeys = {};

  // ── Overlay (OverlayPortal — no manual OverlayEntry management) ──
  final LayerLink _layerLink = LayerLink();
  final OverlayPortalController _portalController = OverlayPortalController();

  // Form field
  final GlobalKey<FormFieldState<List<M3EDropdownItem<T>>?>> _formFieldKey =
      GlobalKey();

  final GlobalKey<M3EMoreChipsIndicatorState> _moreKey = GlobalKey();
  // Focus
  late FocusNode _focusNode;

  // Animation direction tracking
  bool? _openingShowOnTop;

  // Search
  final TextEditingController _searchTextController = TextEditingController();
  Timer? _searchDebounce;

  // Async loading state
  bool _isLoading = false;
  String? _errorMessage;

  // Animation
  late final SingleMotionController _expandCtrl;
  late final SingleMotionController _arrowCtrl;

  /// Merged listenable so the field rebuilds on both controller and loading
  /// state changes without requiring `setState`.
  late final ValueNotifier<bool> _loadingNotifier;
  late final Listenable _listenable;

  @override
  void initState() {
    super.initState();

    _expandCtrl = SingleMotionController(
      motion: widget.openMotion.toMotion(),
      vsync: this,
    );

    _arrowCtrl = SingleMotionController(
      motion: widget.openMotion.toMotion(),
      vsync: this,
    );

    // Listen to expand animation to hide portal when close animation completes.
    _expandCtrl.addListener(_onExpandAnimationTick);

    // Controller setup
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = M3EDropdownController<T>();
      _ownController = true;
    }

    if (widget.items.isNotEmpty) {
      _controller.setItems(widget.items);
    }

    if (!_controller.initialized) {
      _controller.initialize();
    }

    _lastIsOpen = _controller.isOpen;
    _controller.addListener(_onControllerChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller
        ..onSelectionChange = widget.onSelectionChanged
        ..onSearchChange = widget.onSearchChanged;
      _listenBackButton();
    });

    // Focus
    _focusNode = widget.focusNode ?? FocusNode();

    // Loading notifier
    _loadingNotifier = ValueNotifier<bool>(false);
    _listenable = Listenable.merge([_controller, _loadingNotifier]);

    // Async loading
    if (widget.future != null) {
      unawaited(_loadAsync());
    }
  }

  void _listenBackButton() {
    if (!widget.closeOnBackButton) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        _registerBackButtonDispatcherCallback();
      } on Exception catch (e) {
        debugPrint('M3EDropdownMenu back-button error: $e');
      }
    });
  }

  void _registerBackButtonDispatcherCallback() {
    final rootBackDispatcher = Router.of(context).backButtonDispatcher;
    if (rootBackDispatcher != null) {
      rootBackDispatcher.createChildBackButtonDispatcher()
        ..addCallback(() {
          if (_controller.isOpen) {
            _close();
          }
          return Future.value(true);
        })
        ..takePriority();
    }
  }

  @override
  void didUpdateWidget(covariant M3EDropdownMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Items changed
    if (widget.items != oldWidget.items && widget.future == null) {
      _controller.setItems(widget.items);
    }

    // Controller changed
    if (oldWidget.controller != widget.controller) {
      _controller.removeListener(_onControllerChanged);
      if (_ownController) {
        _controller.dispose();
      }

      if (widget.controller != null) {
        _controller = widget.controller!;
        _ownController = false;
      } else {
        _controller = M3EDropdownController<T>();
        _ownController = true;
      }
      if (!_controller.initialized) {
        _controller.initialize();
      }
      if (widget.items.isNotEmpty) {
        _controller.setItems(widget.items);
      }
      _controller.addListener(_onControllerChanged);
      _controller
        ..onSelectionChange = widget.onSelectionChanged
        ..onSearchChange = widget.onSearchChanged;
    }

    // FocusNode changed
    if (oldWidget.focusNode != widget.focusNode) {
      if (oldWidget.focusNode == null) {
        _focusNode.dispose();
      }
      _focusNode = widget.focusNode ?? FocusNode();
    }

    // Spring params changed
    if (widget.openMotion != oldWidget.openMotion ||
        widget.closeMotion != oldWidget.closeMotion) {
      _expandCtrl.motion = widget.openMotion.toMotion();
      _arrowCtrl.motion = widget.openMotion.toMotion();
    }
  }

  @override
  void dispose() {
    _expandCtrl
      ..removeListener(_onExpandAnimationTick)
      ..dispose();
    _arrowCtrl.dispose();
    _searchDebounce?.cancel();
    _searchTextController.dispose();
    _loadingNotifier.dispose();
    _controller.removeListener(_onControllerChanged);
    if (_ownController) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  // ── Async loader ──

  Future<void> _loadAsync() async {
    _isLoading = true;
    _errorMessage = null;
    _loadingNotifier.value = true;
    try {
      final items = await widget.future!();
      if (mounted) {
        _controller.setItems(items);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      if (mounted) {
        _isLoading = false;
        _loadingNotifier.value = false;
      }
    }
  }

  // ── Controller listener ──

  void _onControllerChanged() {
    // Update form field state
    _formFieldKey.currentState?.didChange(_controller.selectedItems);

    // Sync open state bi-directionally
    if (_controller.isOpen && !_portalController.isShowing) {
      _open();
    } else if (!_controller.isOpen && _portalController.isShowing) {
      _close();
    }
  }

  // ── Expand animation listener — hides portal when close settles ──

  void _onExpandAnimationTick() {
    if (!_controller.isOpen && _expandCtrl.value <= 0.01 && mounted) {
      if (_portalController.isShowing) {
        _portalController.hide();
      }
      _openingShowOnTop = null;
    }
  }

  // ── Open / close logic ──

  void _open() {
    if (_controller.isOpen && _portalController.isShowing) {
      return;
    }
    if (!widget.enabled || _isLoading) {
      return;
    }

    if (!_controller.isOpen) {
      _controller.setOpen(open: true);
    }

    // Determine direction before opening
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.attached) {
      final renderBoxSize = renderBox.size;
      final renderBoxOffset = renderBox.localToGlobal(Offset.zero);
      final screenHeight = MediaQuery.of(context).size.height;
      final spaceBelow =
          screenHeight - renderBoxOffset.dy - renderBoxSize.height;
      final spaceAbove = renderBoxOffset.dy;

      switch (widget.dropdownStyle.expandDirection) {
        case M3EDropdownExpandDirection.down:
          _openingShowOnTop = false;
        case M3EDropdownExpandDirection.up:
          _openingShowOnTop = true;
        case M3EDropdownExpandDirection.auto:
          _openingShowOnTop =
              spaceBelow < widget.dropdownStyle.maxHeight &&
              spaceAbove > spaceBelow;
      }
    }

    _expandCtrl.motion = widget.openMotion.toMotion();
    _arrowCtrl.motion = widget.openMotion.toMotion();
    _expandCtrl.animateTo(1);
    _arrowCtrl.animateTo(math.pi);
    _portalController.show();
  }

  void _close() {
    if (!_controller.isOpen && !_portalController.isShowing) {
      return;
    }

    if (_controller.isOpen) {
      _controller.setOpen(open: false);
    }
    _expandCtrl.motion = widget.closeMotion.toMotion();
    _arrowCtrl.motion = widget.closeMotion.toMotion();
    _expandCtrl.animateTo(0);
    _arrowCtrl.animateTo(0);
    _searchTextController.clear();
    _searchDebounce?.cancel();

    // Portal will be hidden by _onExpandAnimationTick when animation settles.
  }

  void _toggle() {
    if (!widget.enabled || _isLoading) {
      return;
    }
    _applyHaptic();
    if (_controller.isOpen) {
      _close();
    } else {
      FocusManager.instance.primaryFocus?.unfocus();
      _open();
    }
  }

  BorderRadius _buildEffectiveFieldRadius() {
    final fd = widget.fieldStyle;

    // Determine the "base" for the current state (Open vs Closed)
    final baseRadius = _controller.isOpen && fd.selectedBorderRadius != null
        ? BorderRadius.circular(fd.selectedBorderRadius!)
        : (fd.borderRadius ??
              BorderRadius.circular(
                widget.dropdownStyle.containerRadius ?? widget.containerRadius,
              ));

    if (_isPressedField && fd.pressedRadius != null) {
      return BorderRadius.circular(fd.pressedRadius!);
    }
    if (_isHoveredField && fd.hoverRadius != null) {
      return BorderRadius.circular(fd.hoverRadius!);
    }
    return baseRadius;
  }

  void _applyHaptic() {
    M3EButtonConstants.triggerHapticFeedback(widget.haptic);
  }

  // ── Item selection ──

  void _onItemTap(M3EDropdownItem<T> item) {
    if (item.disabled) {
      return;
    }
    _applyHaptic();

    if (widget.singleSelect) {
      _controller.toggleOnly(item);
      WidgetsBinding.instance.addPostFrameCallback((_) => _close());
    } else {
      // Check max selections
      if (!item.selected &&
          widget.maxSelections > 0 &&
          _controller.selectedItems.length >= widget.maxSelections) {
        return;
      }

      // If deselecting and chips are shown, animate the chip out first
      if (item.selected && widget.showChipAnimation) {
        final optionKey = item.value as Object;
        final chipKey = _chipKeys[optionKey];
        if (chipKey?.currentState != null) {
          // Build the current displayOptions to find the index
          final selected = _controller.selectedItems;
          final maxCount = widget.chipStyle.maxDisplayCount;
          final displayOptions = maxCount != null && selected.length > maxCount
              ? selected.take(maxCount).toList()
              : selected;
          final idx = displayOptions.indexWhere((e) => e.value == item.value);
          if (idx >= 0) {
            _handleChipRemove(item, optionKey, chipKey!, displayOptions, idx);
            return;
          }
        }
      }

      _controller.toggleWhere((e) => e == item);
    }

    _formFieldKey.currentState?.didChange(_controller.selectedItems);
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (context) => FormField<List<M3EDropdownItem<T>>?>(
      key: _formFieldKey,
      validator: widget.validator ?? (_) => null,
      autovalidateMode: widget.autovalidateMode,
      initialValue: _controller.selectedItems,
      enabled: widget.enabled,
      builder: (formState) {
        return OverlayPortal(
          controller: _portalController,
          overlayChildBuilder: (_) => _buildOverlay(formState),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: CompositedTransformTarget(
                  link: _layerLink,
                  child: ListenableBuilder(
                    listenable: _listenable,
                    builder: (_, _) {
                      return Semantics(
                        label: widget.fieldStyle.hintText ?? 'Dropdown field',
                        button: true,
                        enabled: widget.enabled,
                        child: Focus(
                          focusNode: _focusNode,
                          canRequestFocus: widget.enabled,
                          child: _buildField(context, formState),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (formState.hasError) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Builder(
                    builder: (context) {
                      final m3eTheme = M3ETheme.of(context);
                      return Text(
                        formState.errorText!,
                        style:
                            (widget.fieldStyle.errorStyle ??
                                    m3eTheme.typeScale.bodySmall)
                                .copyWith(
                                  color:
                                      widget.fieldStyle.errorStyle?.color ??
                                      m3eTheme.colorScheme.error,
                                ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        );
      },
    ),
    );
  }

  // ── Overlay (dropdown panel) ──

  Widget _buildOverlay(FormFieldState<List<M3EDropdownItem<T>>?> formState) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.attached) {
      return const SizedBox.shrink();
    }

    final renderBoxSize = renderBox.size;
    final renderBoxOffset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final spaceBelow = screenHeight - renderBoxOffset.dy - renderBoxSize.height;
    final spaceAbove = renderBoxOffset.dy;

    final bool showOnTop;
    if (_openingShowOnTop != null) {
      showOnTop = _openingShowOnTop!;
    } else {
      switch (widget.dropdownStyle.expandDirection) {
        case M3EDropdownExpandDirection.down:
          showOnTop = false;
        case M3EDropdownExpandDirection.up:
          showOnTop = true;
        case M3EDropdownExpandDirection.auto:
          showOnTop =
              spaceBelow < widget.dropdownStyle.maxHeight &&
              spaceAbove > spaceBelow;
      }
    }

    final marginOffset = widget.dropdownStyle.marginTop == 0
        ? Offset.zero
        : Offset(
            0,
            showOnTop
                ? -widget.dropdownStyle.marginTop
                : widget.dropdownStyle.marginTop,
          );

    return Stack(
      children: [
        // Outside-tap detection layer
        Positioned.fill(
          child: Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: _handleOutsideTap,
          ),
        ),
        CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          targetAnchor: showOnTop ? Alignment.topLeft : Alignment.bottomLeft,
          followerAnchor: showOnTop ? Alignment.bottomLeft : Alignment.topLeft,
          offset: marginOffset,
          child: SizedBox(
            width: renderBoxSize.width,
            child: RepaintBoundary(child: _buildDropdownPanel(showOnTop)),
          ),
        ),
      ],
    );
  }

  /// Detects taps outside the field and dropdown, and closes the dropdown.
  void _handleOutsideTap(PointerDownEvent event) {
    if (!_controller.isOpen) {
      return;
    }

    // If the tap landed on the field itself, let the field handle it.
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.attached) {
      final localPosition = renderBox.globalToLocal(event.position);
      if (renderBox.paintBounds.contains(localPosition)) {
        return;
      }
    }

    _close();
  }

  // ── Field ──

  Widget _buildField(
    BuildContext context,
    FormFieldState<List<M3EDropdownItem<T>>?> formState,
  ) {
    final m3eTheme = M3ETheme.of(context);
    final menuTheme = m3eTheme.dropdownMenuTheme;
    final scheme = m3eTheme.colorScheme;
    final type = m3eTheme.typeScale;
    final fd = widget.fieldStyle;

    final bgColor =
        fd.backgroundColor ?? menuTheme.fieldBackgroundColor(scheme);
    final fgColor =
        fd.foregroundColor ?? menuTheme.fieldForegroundColor(scheme);
    final borderSide =
        (formState.hasError
            ? fd.errorBorder
            : (_controller.isOpen ? fd.focusedBorder : fd.border)) ??
        BorderSide.none;

    Widget? trailing;
    if (_isLoading) {
      trailing =
          fd.loadingWidget ??
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          );
    } else if (fd.showClearIcon &&
        widget.enabled &&
        _controller.selectedItems.isNotEmpty) {
      trailing = Tooltip(
        message: 'Clear selection',
        child: Semantics(
          label: 'Clear all selections',
          button: true,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _controller.clearAll();
              _formFieldKey.currentState?.didChange(_controller.selectedItems);
            },
            child: fd.clearIcon ?? Icon(Icons.clear, color: fgColor, size: 20),
          ),
        ),
      );
    } else if (fd.suffixIcon != null) {
      if (fd.animateSuffixIcon) {
        trailing = AnimatedRotation(
          turns: _controller.isOpen ? 0.5 : 0,
          duration: const Duration(milliseconds: 200),
          child: fd.suffixIcon,
        );
      } else {
        trailing = fd.suffixIcon;
      }
    } else if (fd.showArrow) {
      trailing = AnimatedBuilder(
        animation: _arrowCtrl,
        builder: (context, child) {
          return Transform.rotate(
            angle: _arrowCtrl.value,
            child: Icon(Icons.keyboard_arrow_down_rounded, color: fgColor),
          );
        },
      );
    }

    // Build content
    Widget content;
    final selected = _controller.selectedItems;

    final isOpenChanged = _lastIsOpen != _controller.isOpen;
    _lastIsOpen = _controller.isOpen;

    if (widget.selectedItemBuilder != null && selected.isNotEmpty) {
      if (widget.showChipAnimation) {
        // Route through _buildChips so we get all spring animations
        content = _buildChips(context, selected, fgColor);
      } else {
        final children = selected
            .map((o) => widget.selectedItemBuilder!(o))
            .toList();
        if (widget.chipStyle.wrap) {
          content = Wrap(
            spacing: widget.chipStyle.spacing,
            runSpacing: widget.chipStyle.runSpacing,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          );
        } else {
          content = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    SizedBox(width: widget.chipStyle.spacing),
                ],
              ],
            ),
          );
        }
      }
    } else if (widget.showChipAnimation && selected.isNotEmpty) {
      content = _buildChips(context, selected, fgColor);
    } else if (widget.singleSelect && selected.isNotEmpty) {
      content = Text(
        selected.first.label,
        style:
            fd.selectedTextStyle ??
            menuTheme.selectedTextStyle(type, scheme),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      content = Text(
        fd.hintText ?? 'Select',
        style: fd.hintStyle ?? menuTheme.hintTextStyle(type, scheme),
      );
    }

    Widget buildFieldBody() {
      final contentRow = Row(
        children: [
          if (fd.prefixIcon != null) ...[
            fd.prefixIcon!,
            const SizedBox(width: 8),
          ],
          Expanded(child: content),
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      );

      final duration = isOpenChanged
          ? const Duration(milliseconds: 20)
          : const Duration(milliseconds: 40);

      return TweenAnimationBuilder<BorderRadius?>(
        duration: duration,
        curve: Curves.easeOut,
        tween: BorderRadiusTween(
          begin: _buildEffectiveFieldRadius(),
          end: _buildEffectiveFieldRadius(),
        ),
        builder: (context, animatedRadius, child) {
          final effectiveRadius =
              animatedRadius ?? _buildEffectiveFieldRadius();
          return Material(
            color: bgColor,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: effectiveRadius,
              side: borderSide,
            ),
            child: InkWell(
              splashFactory: fd.splashFactory ?? widget.splashFactory,
              splashColor: fd.splashColor,
              highlightColor: fd.highlightColor,
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return fgColor.withValues(alpha: 0.10);
                }
                if (states.contains(WidgetState.hovered)) {
                  return fgColor.withValues(alpha: 0.05);
                }
                return Colors.transparent;
              }),
              mouseCursor: widget.enabled
                  ? (fd.mouseCursor ?? SystemMouseCursors.click)
                  : SystemMouseCursors.forbidden,
              onTap: widget.enabled ? _toggle : null,
              onHover: (hover) => setState(() => _isHoveredField = hover),
              onTapDown: (_) => setState(() => _isPressedField = true),
              onTapUp: (_) => setState(() => _isPressedField = false),
              onTapCancel: () => setState(() => _isPressedField = false),
              child: Padding(padding: fd.padding, child: child),
            ),
          );
        },
        child: contentRow,
      );
    }

    return Padding(padding: fd.margin, child: buildFieldBody());
  }

  // ── Chips ──

  // Track removal state
  final Set<Object> _removingChips = {};

  // Track previous chip display order for insertion squish
  List<Object> _previousChipOrder = [];

  bool _isMoreChipsRemoving = false;
  int _moreChipsLastCount = 0;

  Widget _buildChips(
    BuildContext context,
    List<M3EDropdownItem<T>> selected,
    Color fgColor,
  ) {
    final cd = widget.chipStyle;
    final m3eTheme = M3ETheme.of(context);
    final menuTheme = m3eTheme.dropdownMenuTheme;
    final scheme = m3eTheme.colorScheme;

    final labelStyle =
        cd.labelStyle ??
        menuTheme.chipLabelStyle(m3eTheme.typeScale, scheme);
    final chipColor =
        cd.backgroundColor ?? menuTheme.chipBackgroundColor(scheme);

    final maxCount = cd.maxDisplayCount;
    final displayOptions = maxCount != null && selected.length > maxCount
        ? selected.take(maxCount).toList()
        : selected;

    final remainingCount = selected.length - displayOptions.length;

    if (remainingCount == 0 &&
        _moreChipsLastCount > 0 &&
        !_isMoreChipsRemoving) {
      _isMoreChipsRemoving = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _moreKey.currentState?.animateOut(() {
          if (!mounted) {
            return;
          }
          setState(() {
            _isMoreChipsRemoving = false;
            _moreChipsLastCount = 0;
          });
        });
      });
    }

    if (remainingCount > 0) {
      _moreChipsLastCount = remainingCount;
      if (_isMoreChipsRemoving) {
        _isMoreChipsRemoving = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          _moreKey.currentState?.animateIn();
        });
      }
    }

    final bool showMoreChips = remainingCount > 0 || _isMoreChipsRemoving;

    // Prune controllers for chips no longer present and not removing
    final currentKeys = displayOptions.map((e) => e.value as Object).toSet();
    _chipSlideControllers.removeWhere((k, ctrl) {
      if (!currentKeys.contains(k)) {
        ctrl.dispose();
        return true;
      }
      return false;
    });
    _chipKeys.removeWhere(
      (k, _) => !currentKeys.contains(k) && !_removingChips.contains(k),
    );

    // Ensure a slide controller exists for every chip
    for (final option in displayOptions) {
      final key = option.value as Object;
      _chipSlideControllers.putIfAbsent(
        key,
        () => SingleMotionController(
          motion: M3EMotion.effectsFast.toMotion(),
          vsync: this, // _M3EDropdownMenuState uses TickerProviderStateMixin
        ),
      );
    }

    final List<Widget> chipWidgets = [];
    final List<Animation<double>> slideAnims = [];

    for (var i = 0; i < displayOptions.length; i++) {
      final option = displayOptions[i];
      final optionKey = option.value as Object;

      final chipKey = _chipKeys.putIfAbsent(
        optionKey,
        () => GlobalKey<M3ESpringChipState>(),
      );

      slideAnims.add(_chipSlideControllers[optionKey]!);

      chipWidgets.add(
        M3ESpringChip<T>(
          key: chipKey,
          item: option,
          cd: cd,
          chipColor: chipColor,
          labelStyle: labelStyle,
          scheme: scheme,
          enabled: widget.enabled,
          onRemove: () =>
              _handleChipRemove(option, optionKey, chipKey, displayOptions, i),
          customChild: widget.selectedItemBuilder?.call(option),
        ),
      );
    }

    // ── Detect pushed chips and trigger squish on insertion ──
    final newOrder = displayOptions.map((e) => e.value as Object).toList();
    final newKeys = newOrder.toSet().difference(_previousChipOrder.toSet());

    if (newKeys.isNotEmpty && _previousChipOrder.isNotEmpty) {
      // Find the earliest insertion index
      int earliestInsertIdx = newOrder.length;
      for (final nk in newKeys) {
        final idx = newOrder.indexOf(nk);
        if (idx < earliestInsertIdx) {
          earliestInsertIdx = idx;
        }
      }

      // All old chips at or after the insertion point were pushed right
      final chipsToPush = <Object>[];
      for (var i = earliestInsertIdx; i < newOrder.length; i++) {
        final k = newOrder[i];
        if (!newKeys.contains(k)) {
          chipsToPush.add(k);
        }
      }

      if (chipsToPush.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) {
            return;
          }
          for (var i = 0; i < chipsToPush.length; i++) {
            final stateKey = _chipKeys[chipsToPush[i]];
            Future.delayed(Duration(milliseconds: i * 25), () {
              if (stateKey?.currentState != null) {
                final intensity = (0.88 + (i * 0.02)).clamp(0.85, 0.98);
                stateKey!.currentState!.triggerSquish(intensity);
              }
            });
          }
        });
      }
    }
    _previousChipOrder = newOrder;

    if (showMoreChips) {
      chipWidgets.add(
        M3EMoreChipsIndicator(
          key: _moreKey,
          count: remainingCount > 0 ? remainingCount : _moreChipsLastCount,
          cd: cd,
          chipColor: chipColor,
          labelStyle: labelStyle,
        ),
      );

      // Ensure the Flow delegate has an animation to track for this child
      slideAnims.add(const AlwaysStoppedAnimation(0));
    }

    if (cd.wrap) {
      return Wrap(
        spacing: cd.spacing,
        runSpacing: cd.runSpacing,
        children: chipWidgets,
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints.loose(const Size(double.infinity, 40)),
      child: Flow(
        delegate: M3EChipFlowDelegate(
          slideAnimations: slideAnims,
          spacing: cd.spacing,
        ),
        children: chipWidgets,
      ),
    );
  }

  void _handleChipRemove(
    M3EDropdownItem<T> option,
    Object optionKey,
    GlobalKey<M3ESpringChipState> chipKey,
    List<M3EDropdownItem<T>> displayOptions,
    int removedIndex,
  ) {
    // 1. Capture the width of the gap being created
    final removedBox = chipKey.currentContext?.findRenderObject() as RenderBox?;
    final removedWidth =
        (removedBox?.size.width ?? 0) + widget.chipStyle.spacing;

    // 2. Identify WHICH chips are moving BEFORE we change the list
    // We want to animate any chip that was to the right of the deleted one.
    final chipsToAnimate = displayOptions.sublist(removedIndex + 1);

    // 3. Start the Scale-Out animation for the deleted chip
    _removingChips.add(optionKey);
    chipKey.currentState?.animateOut(() {
      if (!mounted) {
        return;
      }

      // 4. Update State: The list physically shifts now
      _controller.unselectWhere((e) => e.value == option.value);
      _formFieldKey.currentState?.didChange(_controller.selectedItems);
      _removingChips.remove(optionKey);

      final selectedItems = _controller.selectedItems;
      final maxDisplay =
          widget.chipStyle.maxDisplayCount ?? selectedItems.length;
      final remainingCount = selectedItems.length - maxDisplay;

      // 5. Loop through the chips we captured in Step 2
      for (var i = 0; i < chipsToAnimate.length; i++) {
        final item = chipsToAnimate[i];
        final key = item.value as Object;
        final stateKey = _chipKeys[key];
        final slideCtrl = _chipSlideControllers[key];

        if (slideCtrl != null) {
          // --- A. THE SLIDE ---
          // Always slide from the old position to the new 0 position
          slideCtrl
            ..motion = M3EMotion.effectsFast.toMotion()
            ..animateTo(0, from: removedWidth);

          // --- B. THE SQUISH ---
          // We calculate the stagger based on its position in the "moving group"
          Future.delayed(Duration(milliseconds: i * 25), () {
            if (stateKey?.currentState != null) {
              // Intensity: The first moving chip squishes most (0.88)
              // even if it is moving into the Index 0 slot.
              double intensity = (0.88 + (i * 0.02)).clamp(0.85, 0.98);
              stateKey!.currentState!.triggerSquish(intensity);
            }
          });
        }
      }

      // 6. Handle the +N Indicator
      if (remainingCount > 0) {
        Future.delayed(
          Duration(milliseconds: (chipsToAnimate.length + 1) * 20),
          () {
            _moreKey.currentState?.triggerSquish(0.95);
          },
        );
      }
    });
  }

  // ── Dropdown panel ──

  Widget _buildDropdownPanel(bool showOnTop) {
    final m3eTheme = M3ETheme.of(context);
    final menuTheme = m3eTheme.dropdownMenuTheme;
    final scheme = m3eTheme.colorScheme;
    final type = m3eTheme.typeScale;
    final dd = widget.dropdownStyle;
    final filtered = _controller.items;

    return AnimatedBuilder(
      animation: _expandCtrl,
      builder: (context, child) {
        final progress = _expandCtrl.value.clamp(0.0, 1.5);
        final clampedScale = progress.clamp(0.0, 1.2);

        if (progress <= 0.01) {

          return const SizedBox.shrink();

        }

        return Opacity(
          opacity: progress.clamp(0.0, 1.0),
          child: Transform.scale(
            alignment: showOnTop ? Alignment.bottomCenter : Alignment.topCenter,
            scaleY: clampedScale,
            child: child,
          ),
        );
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: dd.maxHeight),
        child: Material(
          elevation: dd.elevation,
          color: dd.backgroundColor ?? menuTheme.panelBackgroundColor(scheme),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              widget.dropdownStyle.containerRadius ?? widget.containerRadius,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dd.header != null) dd.header!,
              if (widget.searchEnabled) _buildSearch(context),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _errorMessage!,
                    style: type.bodyMedium.copyWith(
                      color: scheme.error,
                    ),
                  ),
                )
              else if (filtered.isEmpty)
                widget.emptyBuilder?.call(context) ??
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        dd.noItemsFoundText,
                        style: type.bodyMedium.copyWith(
                          color: scheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    )
              else
                Flexible(
                  child: ListView.separated(
                    padding: dd.contentPadding,
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) =>
                        widget.itemSeparator ??
                        SizedBox(height: widget.itemStyle.itemGap ?? 3.0),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      if (widget.itemBuilder != null) {
                        return widget.itemBuilder!(
                          item,
                          selected: item.selected,
                          onTap: () => _onItemTap(item),
                        );
                      }

                      return M3EDropdownMenuItemWidget<T>(
                        key: ValueKey(item.value),
                        item: item,
                        index: index,
                        total: filtered.length,
                        style: widget.itemStyle,
                        onTap: () => _onItemTap(item),
                      );
                    },
                  ),
                ),
              if (dd.footer != null) dd.footer!,
            ],
          ),
        ),
      ),
    );
  }

  // ── Search ──

  Widget _buildSearch(BuildContext context) {
    final sd = widget.searchStyle;
    final m3eTheme = M3ETheme.of(context);
    final scheme = m3eTheme.colorScheme;
    final type = m3eTheme.typeScale;

    final searchRadius =
        sd.borderRadius ??
        BorderRadius.circular(widget.itemStyle.outerRadius ?? 12.0);

    return Padding(
      padding: sd.margin,
      child: TextField(
        controller: _searchTextController,
        autofocus: sd.autofocus,
        style: sd.textStyle ?? type.bodyMedium,
        mouseCursor: sd.mouseCursor,
        decoration: InputDecoration(
          hintText: sd.hintText,
          hintStyle: sd.hintStyle,
          filled: sd.filled,
          fillColor: sd.fillColor,
          prefixIcon: Icon(
            Icons.search,
            color: scheme.onSurface.withValues(alpha: 0.5),
          ),
          suffixIcon: sd.showClearIcon && _searchTextController.text.isNotEmpty
              ? IconButton(
                  icon: sd.clearIcon ?? const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchTextController.clear();
                    _searchDebounce?.cancel();
                    _controller.setSearchQuery('');
                  },
                )
              : null,
          contentPadding: sd.contentPadding,
          border: OutlineInputBorder(
            borderRadius: searchRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: searchRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: searchRadius,
            borderSide: BorderSide(color: scheme.primary, width: 1.5),
          ),
        ),
        onChanged: _handleSearchChanged,
      ),
    );
  }

  void _handleSearchChanged(String value) {
    final debounceMs = widget.searchStyle.searchDebounceMs;
    if (debounceMs <= 0) {
      _controller.setSearchQuery(value);
      return;
    }

    _searchDebounce?.cancel();
    _searchDebounce = Timer(Duration(milliseconds: debounceMs), () {
      _controller.setSearchQuery(value);
    });
  }
}
