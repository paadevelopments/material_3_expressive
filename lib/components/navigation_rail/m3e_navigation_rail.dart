// Vendored from the `navigation_rail_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e/lib).
// The logic is kept identical to the reference `NavigationRailM3E`; only the
// public class name carries the `M3E` prefix and it uses this package's own
// `M3EIconButton`, `M3EFab` and `M3EExtendedFab` instead of the external
// `icon_button_m3e`/`fab_m3e` packages.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

import '../../../foundations/foundations.dart';
import '../extended_fabs/m3e_extended_fabs.dart';
import '../floating_action_buttons/m3e_floating_action_buttons.dart';
import '../icon_buttons/m3e_icon_buttons.dart';
import 'components/m3e_rail_item.dart';
import 'enums/m3e_navigation_rail_enums.dart';
import 'models/m3e_navigation_rail_destination.dart';
import 'models/m3e_navigation_rail_fab_slot.dart';
import 'models/m3e_navigation_rail_section.dart';
import 'res/m3e_navigation_rail_layout.dart';

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

  final M3ENavigationRailType type;
  final M3ENavigationRailModality modality;
  final List<M3ENavigationRailSection> sections;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final M3ENavigationRailFabSlot? fab;
  final bool hideWhenCollapsed;
  final double? expandedWidth;
  final VoidCallback? onDismissModal;
  final ValueChanged<M3ENavigationRailType>? onTypeChanged;
  final M3ENavigationRailLabelBehavior labelBehavior;
  final bool scrollable;
  final Widget? trailing;
  final bool trailingAtBottom;
  final Color? background;

  @override
  State<M3ENavigationRail> createState() => _M3ENavigationRailState();
}

class _M3ENavigationRailState extends State<M3ENavigationRail>
    with TickerProviderStateMixin {
  OverlayEntry? _modalEntry;
  OverlayEntry? _collapsedPeekEntry;
  final LayerLink _anchor = LayerLink();
  bool _suppressInk = false;

  bool _expanded = false;

  bool get _isExpanded => _expanded;
  bool get _isModal => widget.modality == M3ENavigationRailModality.modal;
  bool get _needsOverlay => _isModal && _isExpanded;
  bool get _needsCollapsedPeek =>
      !_isExpanded && !_isModal && widget.hideWhenCollapsed && _canToggle;

  bool get _canToggle =>
      widget.type == M3ENavigationRailType.collapsed ||
          widget.type == M3ENavigationRailType.expanded;

  M3ENavigationRailType get _notifiedType => _expanded
      ? M3ENavigationRailType.expanded
      : M3ENavigationRailType.collapsed;

  @override
  void initState() {
    super.initState();
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
  void didUpdateWidget(covariant M3ENavigationRail oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.type != widget.type) {
      setState(() => _suppressInk = true);
      Future.delayed(M3ENavigationRailLayout.selectionDelay, () {
        if (mounted) setState(() => _suppressInk = false);
      });
    }

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
    } else if (!oldCanToggle && newCanToggle) {
      final bool startExpanded = widget.type == M3ENavigationRailType.expanded;
      if (_expanded != startExpanded) {
        setState(() => _expanded = startExpanded);
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
  }

  @override
  void dispose() {
    _removeOverlay();
    _removeCollapsedPeekOverlay();
    super.dispose();
  }

  void _syncOverlay() {
    if (!mounted) return;

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
    _collapsedPeekEntry =
        OverlayEntry(builder: (ctx) => _buildCollapsedPeekOverlay(ctx));
    overlay.insert(_collapsedPeekEntry!);
  }

  void _removeCollapsedPeekOverlay() {
    _collapsedPeekEntry?.remove();
    _collapsedPeekEntry = null;
  }

  void _setExpanded(bool value) {
    if (_expanded == value) return;
    setState(() {
      _expanded = value;
      _suppressInk = true;
    });
    Future.delayed(M3ENavigationRailLayout.selectionDelay, () {
      if (mounted) setState(() => _suppressInk = false);
    });
    widget.onTypeChanged?.call(_notifiedType);
  }

  Widget _buildModalOverlay(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            ignoring: !_isExpanded,
            child: GestureDetector(
              onTap: widget.onDismissModal,
              child: AnimatedContainer(
                duration: M3ENavigationRailLayout.expandDuration,
                curve: Curves.easeOutCubic,
                color: M3ETheme.of(context)
                    .colorScheme
                    .scrim
                    .withValues(alpha: _isExpanded ? 0.32 : 0.0),
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
    );
  }

  Widget _buildCollapsedPeekOverlay(BuildContext context) {
    final Widget btn = M3EIconButton(
      icon: const Icon(Icons.menu),
      tooltip: 'Expand',
      onPressed: _canToggle ? () => _setExpanded(true) : null,
      suppressInk: _suppressInk,
    );

    return CompositedTransformFollower(
      link: _anchor,
      showWhenUnlinked: false,
      offset: const Offset(8, 36),
      child: Material(
        type: MaterialType.transparency,
        child: btn,
      ),
    );
  }

  double _targetWidth(BuildContext context) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final isExpanded = _isExpanded;
    return isExpanded
        ? (widget.expandedWidth ?? theme.expandedMinWidth)
        .clamp(theme.expandedMinWidth, theme.expandedMaxWidth)
        .toDouble()
        : (widget.hideWhenCollapsed ? 0.0 : theme.collapsedWidth);
  }

  Widget _buildMenuButton(BuildContext context,
      {required Alignment alignment}) {
    if (!_canToggle) return const SizedBox.shrink();

    final isExpanded = _isExpanded;
    final Widget button = M3EIconButton(
      icon: Icon(isExpanded ? Icons.menu_open : Icons.menu),
      tooltip: isExpanded ? 'Collapse' : 'Expand',
      onPressed: () => _setExpanded(!isExpanded),
      suppressInk: _suppressInk,
    );

    return Padding(
      padding: M3ENavigationRailLayout.sectionPadding,
      child: Align(
        alignment: alignment,
        child: button,
      ),
    );
  }

  Widget? _buildFab(BuildContext context) {
    final fab = widget.fab;
    if (fab == null) return null;
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

  Widget? _buildTrailing(BuildContext context) {
    final tr = widget.trailing;
    if (tr == null) return null;
    final isExpanded = _isExpanded;
    return Padding(
      padding: M3ENavigationRailLayout.sectionPadding,
      child: Align(
        alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
        child: tr,
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context,
      {required bool showLabels}) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final isExpanded = _isExpanded;

    final children = <Widget>[];
    children.add(const SizedBox(height: M3ENavigationRailLayout.topGap));
    children.add(_buildMenuButton(context,
        alignment: isExpanded ? Alignment.centerLeft : Alignment.center));
    final fabWidget = _buildFab(context);
    if (fabWidget != null) children.add(fabWidget);

    if (isExpanded) {
      for (final section in widget.sections) {
        if (section.header != null) {
          children.add(Padding(
            padding: EdgeInsetsDirectional.only(
              start: 16,
              end: 16,
              top: theme.sectionHeaderSpacingTop,
              bottom: theme.sectionHeaderSpacingBottom,
            ),
            child: DefaultTextStyle(
              style: M3ETheme.of(context).typeScale.titleSmall.copyWith(
                  color: M3ETheme.of(context).colorScheme.onSurfaceVariant),
              child: section.header!,
            ),
          ));
        }
        for (final dest in section.destinations) {
          final index = _destinationIndex(widget.sections, dest);
          children.add(Padding(
            padding: EdgeInsetsDirectional.only(
              start: 16,
              end: 16,
              top: theme.itemVerticalGap,
              bottom: theme.itemVerticalGap,
            ),
            child: M3ERailItem(
              destination: dest,
              selected: index == widget.selectedIndex,
              onTap: () => widget.onDestinationSelected(index),
              expanded: true,
              labelBehavior: widget.labelBehavior,
              suppressInk: _suppressInk,
            ),
          ));
        }
      }
    } else {
      final all = widget.sections.expand((s) => s.destinations).toList();
      for (int i = 0; i < all.length; i++) {
        children.add(Padding(
          padding: EdgeInsetsDirectional.only(
              start: M3ENavigationRailLayout.horizontalInset,
              end: M3ENavigationRailLayout.horizontalInset,
              top: theme.itemVerticalGap,
              bottom: theme.itemVerticalGap),
          child: M3ERailItem(
            destination: all[i],
            selected: i == widget.selectedIndex,
            onTap: () => widget.onDestinationSelected(i),
            expanded: false,
            labelBehavior: widget.labelBehavior,
            suppressInk: _suppressInk,
          ),
        ));
      }
    }
    if (widget.trailing != null && !widget.trailingAtBottom) {
      final trailingWidget = _buildTrailing(context);
      if (trailingWidget != null) children.add(trailingWidget);
    }
    return children;
  }

  Widget _buildRailCore(BuildContext context) {
    final theme = M3ETheme.of(context).navigationRailTheme;
    final m3e = M3ETheme.of(context);
    final width = _targetWidth(context);
    final Color containerColor = widget.background ?? theme.containerColor ?? m3e.colorScheme.surface;

    return AnimatedContainer(
      duration: M3ENavigationRailLayout.expandDuration,
      curve: Curves.easeOutCubic,
      width: width,
      decoration:
      BoxDecoration(color: containerColor),
      child: LayoutBuilder(
        builder: (ctx, constraints) {
          final showLabels = _isExpanded && constraints.maxWidth >= 180;
          final children = _buildChildren(ctx, showLabels: showLabels);
          final bottomTrailing =
          (widget.trailing != null && widget.trailingAtBottom)
              ? _buildTrailing(ctx)
              : null;

          if (widget.scrollable) {
            if (bottomTrailing != null) {
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: children,
                    ),
                  ),
                  bottomTrailing,
                ],
              );
            }
            return ListView(
              padding: EdgeInsets.zero,
              children: children,
            );
          } else {
            if (bottomTrailing != null) {
              return Column(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    ),
                  ),
                  bottomTrailing,
                ],
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: children,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());

    final Widget child =
    _needsOverlay ? const SizedBox.shrink() : _buildRailCore(context);

    return CompositedTransformTarget(link: _anchor, child: child);
  }

  static int _destinationIndex(List<M3ENavigationRailSection> sections,
      M3ENavigationRailDestination dest) {
    var i = 0;
    for (final s in sections) {
      for (final d in s.destinations) {
        if (identical(d, dest)) return i;
        i++;
      }
    }
    return 0;
  }
}
