import 'package:flutter/scheduler.dart';
import 'package:material_ui/material_ui.dart';

import '../../../foundations/foundations.dart';
import '../extended_fabs/m3e_extended_fabs.dart';
import '../floating_action_buttons/m3e_floating_action_buttons.dart';
import '../icon_buttons/m3e_icon_buttons.dart';
import 'components/m3e_nav_selection_indicator.dart';
import 'components/m3e_rail_item.dart';
import 'enums/m3e_navigation_rail_enums.dart';
import 'models/m3e_navigation_rail_destination.dart';
import 'models/m3e_navigation_rail_fab_slot.dart';
import 'models/m3e_navigation_rail_section.dart';
import 'res/m3e_navigation_rail_layout.dart';
import 'styles/m3e_navigation_rail_theme.dart';

export 'enums/m3e_navigation_rail_enums.dart';
export 'models/m3e_navigation_rail_destination.dart';
export 'models/m3e_navigation_rail_fab_slot.dart';
export 'models/m3e_navigation_rail_section.dart';
export 'res/m3e_navigation_rail_layout.dart';
export 'styles/m3e_navigation_rail_theme.dart';

part 'components/m3e_navigation_rail_children_mixin.dart';

/// Material 3 Expressive Navigation Rail — single widget that animates between states.
class M3ENavigationRail extends StatefulWidget {
  /// Creates a Material 3 Expressive navigation rail.
  const M3ENavigationRail({
    super.key,
    this.type = M3ENavigationRailType.expanded,
    this.modality = M3ENavigationRailModality.standard,
    required this.sections,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.fab,
    this.hideWhenCollapsed = false,
    this.expandedWidth,
    this.onDismissModal,
    this.onTypeChanged,
    this.labelBehavior = M3ENavigationRailLabelBehavior.alwaysShow,
    this.scrollable = true,
    this.trailing,
    this.trailingAtBottom = true,
    this.background,
  });

  /// type.

  final M3ENavigationRailType type;

  /// modality.
  final M3ENavigationRailModality modality;

  /// sections.
  final List<M3ENavigationRailSection> sections;

  /// selectedIndex.
  final int selectedIndex;

  /// onDestinationSelected.
  final ValueChanged<int> onDestinationSelected;

  /// fab.
  final M3ENavigationRailFabSlot? fab;

  /// hideWhenCollapsed.
  final bool hideWhenCollapsed;

  /// expandedWidth.
  final double? expandedWidth;

  /// onDismissModal.
  final VoidCallback? onDismissModal;

  /// onTypeChanged.
  final ValueChanged<M3ENavigationRailType>? onTypeChanged;

  /// labelBehavior.
  final M3ENavigationRailLabelBehavior labelBehavior;

  /// scrollable.
  final bool scrollable;

  /// trailing.
  final Widget? trailing;

  /// trailingAtBottom.
  final bool trailingAtBottom;

  /// background.
  final Color? background;

  @override
  State<M3ENavigationRail> createState() => _M3ENavigationRailState();
}

class _M3ENavigationRailState extends State<M3ENavigationRail>
    with TickerProviderStateMixin, _M3ENavigationRailChildrenMixin {
  OverlayEntry? _modalEntry;
  OverlayEntry? _collapsedPeekEntry;
  final LayerLink _anchor = LayerLink();
  @override
  bool _suppressInk = false;
  @override
  bool _traveling = false;

  bool _expanded = false;
  @override
  List<GlobalKey> _destinationKeys = <GlobalKey>[];

  @override
  bool get _isExpanded => _expanded;
  bool get _isModal => widget.modality == M3ENavigationRailModality.modal;
  bool get _needsOverlay => _isModal && _isExpanded;
  bool get _needsCollapsedPeek =>
      !_isExpanded && !_isModal && widget.hideWhenCollapsed && _canToggle;

  bool get _canToggle =>
      widget.type == M3ENavigationRailType.collapsed ||
      widget.type == M3ENavigationRailType.expanded;

  int get _destinationCount =>
      widget.sections.fold<int>(0, (int n, s) => n + s.destinations.length);

  void _ensureDestinationKeys() {
    final int count = _destinationCount;
    if (_destinationKeys.length == count) {
      return;
    }
    _destinationKeys = List<GlobalKey>.generate(count, (_) => GlobalKey());
  }

  void _onTravelingChanged(bool traveling) {
    if (_traveling == traveling || !mounted) {
      return;
    }
    final SchedulerPhase phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.idle ||
        phase == SchedulerPhase.postFrameCallbacks) {
      setState(() => _traveling = traveling);
      return;
    }
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _traveling == traveling) {
        return;
      }
      setState(() => _traveling = traveling);
    });
  }

  M3ENavigationRailType get _notifiedType => _expanded
      ? M3ENavigationRailType.expanded
      : M3ENavigationRailType.collapsed;

  @override
  void initState() {
    super.initState();
    _ensureDestinationKeys();
    if (_canToggle) {
      _expanded = widget.type == M3ENavigationRailType.expanded;
    } else {
      final name = widget.type.toString();
      final isAlwaysCollapse = name.contains('alwaysCollapse');
      _expanded = !isAlwaysCollapse;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
  }

  @override
  void didUpdateWidget(covariant M3ENavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);
    _ensureDestinationKeys();
    _syncTypeInkSuppression(oldWidget);
    _syncExpandedFromType(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
  }

  void _syncTypeInkSuppression(M3ENavigationRail oldWidget) {
    if (oldWidget.type == widget.type) {
      return;
    }
    setState(() => _suppressInk = true);
    Future.delayed(M3ENavigationRailLayout.selectionDelay, () {
      if (mounted) {
        setState(() => _suppressInk = false);
      }
    });
  }

  void _syncExpandedFromType(M3ENavigationRail oldWidget) {
    final bool oldCanToggle =
        oldWidget.type == M3ENavigationRailType.collapsed ||
        oldWidget.type == M3ENavigationRailType.expanded;
    final bool newCanToggle = _canToggle;
    if (!newCanToggle) {
      final name = widget.type.toString();
      final bool lockExpanded = !name.contains('alwaysCollapse');
      if (_expanded != lockExpanded) {
        setState(() => _expanded = lockExpanded);
      }
      return;
    }
    if (!oldCanToggle && newCanToggle) {
      final startExpanded = widget.type == M3ENavigationRailType.expanded;
      if (_expanded != startExpanded) {
        setState(() => _expanded = startExpanded);
      }
    }
  }

  @override
  void dispose() {
    _removeOverlay();
    _removeCollapsedPeekOverlay();
    super.dispose();
  }

  void _syncOverlay() {
    if (!mounted) {
      return;
    }

    if (_needsOverlay) {
      if (_modalEntry == null) {
        _insertOverlay();
      } else {
        _modalEntry!.markNeedsBuild();
      }
    } else {
      _removeOverlay();
    }

    if (_needsCollapsedPeek) {
      if (_collapsedPeekEntry == null) {
        _insertCollapsedPeekOverlay();
      } else {
        _collapsedPeekEntry!.markNeedsBuild();
      }
    } else {
      _removeCollapsedPeekOverlay();
    }
  }

  void _insertOverlay() {
    final overlay = Overlay.of(context, rootOverlay: true);
    _modalEntry = OverlayEntry(builder: (ctx) => _buildModalOverlay(ctx));
    overlay.insert(_modalEntry!);
  }

  void _removeOverlay() {
    _modalEntry?.remove();
    _modalEntry = null;
  }

  void _insertCollapsedPeekOverlay() {
    final overlay = Overlay.of(context, rootOverlay: true);
    _collapsedPeekEntry = OverlayEntry(
      builder: (ctx) => _buildCollapsedPeekOverlay(ctx),
    );
    overlay.insert(_collapsedPeekEntry!);
  }

  void _removeCollapsedPeekOverlay() {
    _collapsedPeekEntry?.remove();
    _collapsedPeekEntry = null;
  }

  void _setExpanded(bool value) {
    if (_expanded == value) {
      return;
    }
    setState(() {
      _expanded = value;
      _suppressInk = true;
    });
    Future.delayed(M3ENavigationRailLayout.selectionDelay, () {
      if (mounted) {
        setState(() => _suppressInk = false);
      }
    });
    widget.onTypeChanged?.call(_notifiedType);
  }

  Widget _buildModalOverlay(BuildContext context) {
    return M3EScrimSystemUi.wrap(
      Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !_isExpanded,
              child: GestureDetector(
                onTap: widget.onDismissModal,
                child: AnimatedContainer(
                  duration: M3ENavigationRailLayout.expandDuration,
                  curve: Curves.easeOutCubic,
                  color: M3ETheme.of(context).colorScheme.scrim.withValues(
                    alpha: _isExpanded ? 0.32 : 0.0,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Material(
              type: MaterialType.transparency,
              child: _buildRailCore(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsedPeekOverlay(BuildContext context) {
    final Widget btn = M3EIconButton(
      icon: const Icon(M3EIcons.menu),
      tooltip: 'Expand',
      onPressed: _canToggle ? () => _setExpanded(true) : null,
      suppressInk: _suppressInk,
    );

    return CompositedTransformFollower(
      link: _anchor,
      showWhenUnlinked: false,
      offset: const Offset(8, 36),
      child: Material(type: MaterialType.transparency, child: btn),
    );
  }

  double _targetWidth(BuildContext context) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final isExpanded = _isExpanded;
    return isExpanded
        ? (widget.expandedWidth ?? theme.expandedMinWidth).clamp(
            theme.expandedMinWidth,
            theme.expandedMaxWidth,
          )
        : (widget.hideWhenCollapsed ? 0.0 : theme.collapsedWidth);
  }

  @override
  Widget _buildMenuButton(
    BuildContext context, {
    required Alignment alignment,
  }) {
    if (!_canToggle) {
      return const SizedBox.shrink();
    }

    final isExpanded = _isExpanded;
    final Widget button = M3EIconButton(
      icon: Icon(isExpanded ? M3EIcons.menu_open : M3EIcons.menu),
      tooltip: isExpanded ? 'Collapse' : 'Expand',
      onPressed: () => _setExpanded(!isExpanded),
      suppressInk: _suppressInk,
    );

    return Padding(
      padding: M3ENavigationRailLayout.sectionPadding,
      child: Align(alignment: alignment, child: button),
    );
  }

  @override
  Widget? _buildFab(BuildContext context) {
    final fab = widget.fab;
    if (fab == null) {
      return null;
    }
    final isExpanded = _isExpanded;
    return Padding(
      padding: M3ENavigationRailLayout.sectionPadding,
      child: isExpanded
          ? M3EExtendedFab(
              label: fab.label,
              icon: fab.icon,
              onPressed: fab.onPressed,
              color: fab.color,
            )
          : M3EFab(
              icon: fab.icon,
              onPressed: fab.onPressed,
              tooltip: fab.tooltip,
              color: fab.color,
              size: fab.size,
            ),
    );
  }

  Widget _buildRailCore(BuildContext context) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final m3e = M3ETheme.of(context);
    final width = _targetWidth(context);
    final Color containerColor =
        widget.background ?? theme.containerColorResolved(m3e.colorScheme);
    final Color indicatorColor = theme.activeIndicatorColorResolved(
      m3e.colorScheme,
    );
    _ensureDestinationKeys();

    return AnimatedContainer(
      duration: M3ENavigationRailLayout.expandDuration,
      curve: Curves.easeOutCubic,
      width: width,
      decoration: BoxDecoration(color: containerColor),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final showLabels = _isExpanded && constraints.maxWidth >= 180;
          final children = _buildChildren(ctx, showLabels: showLabels);
          final bottomTrailing =
              (widget.trailing != null && widget.trailingAtBottom)
              ? _buildTrailing(ctx)
              : null;
          return M3ENavSelectionIndicator(
            selectedIndex: widget.selectedIndex,
            targetKeys: _destinationKeys,
            axis: Axis.vertical,
            color: indicatorColor,
            // Expand flip remasures during width morph; height covers window
            // resize when destination slots reflow (scroll / trailingAtBottom).
            layoutToken: (_isExpanded, constraints.maxHeight),
            layoutSettleDuration: M3ENavigationRailLayout.expandDuration,
            onTravelingChanged: _onTravelingChanged,
            child: _buildDestinationsColumn(
              children: children,
              bottomTrailing: bottomTrailing,
            ),
          );
        },
      ),
    );
  }

  Widget _buildDestinationsColumn({
    required List<Widget> children,
    required Widget? bottomTrailing,
  }) {
    if (widget.scrollable) {
      if (bottomTrailing != null) {
        return Column(
          children: [
            Expanded(
              child: ListView(padding: EdgeInsets.zero, children: children),
            ),
            bottomTrailing,
          ],
        );
      }
      return ListView(padding: EdgeInsets.zero, children: children);
    }
    if (bottomTrailing != null) {
      return Column(
        children: [
          Expanded(
            child: Column(mainAxisSize: MainAxisSize.min, children: children),
          ),
          bottomTrailing,
        ],
      );
    }
    return Column(mainAxisSize: MainAxisSize.min, children: children);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());

    return M3EComponentTheme(
      builder: (BuildContext context) {
        final Widget child = _needsOverlay
            ? const SizedBox.shrink()
            : _buildRailCore(context);
        return CompositedTransformTarget(link: _anchor, child: child);
      },
    );
  }

  static int _destinationIndex(
    List<M3ENavigationRailSection> sections,
    M3ENavigationRailDestination dest,
  ) {
    var i = 0;
    for (final s in sections) {
      for (final d in s.destinations) {
        if (identical(d, dest)) {
          return i;
        }
        i++;
      }
    }
    return 0;
  }
}
