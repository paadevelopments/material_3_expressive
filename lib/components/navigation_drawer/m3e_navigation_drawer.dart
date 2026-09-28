import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import 'components/m3e_drawer_destination_button.dart';
import 'controllers/m3e_navigation_drawer_controller.dart';
import 'enums/m3e_navigation_drawer_enums.dart';
import 'models/m3e_navigation_destination.dart';
import 'models/m3e_navigation_drawer_section.dart';

export 'controllers/m3e_navigation_drawer_controller.dart';
export 'enums/m3e_navigation_drawer_enums.dart';
export 'models/m3e_navigation_destination.dart';
export 'models/m3e_navigation_drawer_section.dart';
export 'styles/m3e_navigation_drawer_theme.dart';

/// A Material 3 Expressive navigation drawer.
///
/// A standard drawer stays in the layout. Set [dismissible] to slide it
/// closed from a menu control. A modal drawer covers the screen, starts
/// closed, and dismisses from a destination, the scrim, a drag toward the
/// start edge, or system back.
class M3ENavigationDrawer extends StatefulWidget {
  /// M3ENavigationDrawer.
  const M3ENavigationDrawer({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.headline,
    this.sections = const <M3ENavigationDrawerSection>[],
    this.type = M3ENavigationDrawerType.standard,
    this.dismissible = false,
    this.controller,
    this.onDismissed,
    super.key,
  }) : assert(destinations.length >= 1, 'A drawer needs 1+ destinations.');

  /// Primary destinations. Indices start at 0.
  final List<M3ENavigationDestination> destinations;

  /// Groups after [destinations]. Each group is separated by one divider.
  final List<M3ENavigationDrawerSection> sections;

  /// selectedIndex.
  final int selectedIndex;

  /// onDestinationSelected.
  final ValueChanged<int> onDestinationSelected;

  /// headline.
  final String? headline;

  /// Standard stays in the layout. Modal overlays the screen.
  final M3ENavigationDrawerType type;

  /// When true, a standard drawer opens and closes only from [controller].
  ///
  /// Selecting a destination does not close it. Ignored for a modal drawer.
  final bool dismissible;

  /// Optional control for selection and open or close.
  final M3ENavigationDrawerController? controller;

  /// Called when a dismissible or modal drawer finishes a close request.
  final VoidCallback? onDismissed;

  @override
  State<M3ENavigationDrawer> createState() => _M3ENavigationDrawerState();
}

class _M3ENavigationDrawerState extends State<M3ENavigationDrawer>
    with SingleTickerProviderStateMixin {
  final List<FocusNode> _nodes = <FocusNode>[];
  late final SingleMotionController _reveal;
  M3ENavigationDrawerController? _bound;
  OverlayEntry? _modalEntry;
  bool _revealSeeded = false;
  bool _open = true;
  bool _shown = false;

  bool get _isModal => widget.type == M3ENavigationDrawerType.modal;

  bool get _canDismiss => _isModal || widget.dismissible;

  int get _destinationCount {
    var count = widget.destinations.length;
    for (final section in widget.sections) {
      count += section.destinations.length;
    }
    return count;
  }

  @override
  void initState() {
    super.initState();
    _open = !_canDismiss || (widget.controller?.isOpen ?? false);
    _shown = _isModal && _open;
    _reveal = SingleMotionController(
      motion: const MaterialSpringMotion.expressiveSpatialDefault(),
      vsync: this,
    );
    _reveal.value = _open ? 1 : 0;
    _revealSeeded = true;
    _reveal.addListener(_onReveal);
    _syncNodes();
    _bindController();
    if (_shown) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
    }
  }

  @override
  void didUpdateWidget(M3ENavigationDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncNodes();
    _bindController();
    if (oldWidget.type != widget.type ||
        oldWidget.dismissible != widget.dismissible) {
      if (!_canDismiss) {
        _open = true;
        _shown = false;
        _removeOverlay();
      } else if (_isModal && _open) {
        _shown = true;
      }
      _animateReveal();
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncOverlay());
    }
  }

  @override
  void dispose() {
    _bound?.removeListener(_onController);
    _bound?.detach(_controllerSelect);
    _reveal
      ..removeListener(_onReveal)
      ..dispose();
    for (final node in _nodes) {
      node.dispose();
    }
    _removeOverlay();
    super.dispose();
  }

  void _syncNodes() {
    final count = _destinationCount;
    while (_nodes.length < count) {
      _nodes.add(FocusNode());
    }
    while (_nodes.length > count) {
      _nodes.removeLast().dispose();
    }
  }

  void _bindController() {
    final next = widget.controller;
    if (identical(_bound, next)) {
      _bound?.updateIndex(widget.selectedIndex);
      _bound?.updateIsOpen(isOpen: _open);
      return;
    }
    _bound?.removeListener(_onController);
    _bound?.detach(_controllerSelect);
    _bound = next;
    next?.attach(
      select: _controllerSelect,
      setOpen: _setOpen,
      index: widget.selectedIndex,
      isOpen: _open,
    );
    next?.addListener(_onController);
  }

  void _controllerSelect(int index) {
    widget.onDestinationSelected(index);
    if (_isModal) {
      _setOpen(false);
    }
  }

  void _onController() {
    if (!mounted || _bound == null) {
      return;
    }
    if (_bound!.index != widget.selectedIndex) {
      widget.onDestinationSelected(_bound!.index);
    }
    if (_bound!.isOpen != _open) {
      _setOpen(_bound!.isOpen);
    }
  }

  void _handleSelect(int index) {
    widget.onDestinationSelected(index);
    if (_isModal) {
      _setOpen(false);
    }
  }

  void _setOpen(bool value) {
    if (!_canDismiss) {
      _bound?.updateIsOpen(isOpen: true);
      return;
    }
    final changed = _open != value;
    final target = value ? 1.0 : 0.0;
    if (!changed && (_reveal.value - target).abs() < 0.01) {
      return;
    }
    if (changed && !value) {
      widget.onDismissed?.call();
    }
    setState(() {
      _open = value;
      if (_isModal && value && !_shown) {
        _shown = true;
        _jumpReveal(0);
      }
    });
    _bound?.updateIsOpen(isOpen: _open);
    _animateReveal();
    _syncOverlay();
    if (changed && value && _isModal && _nodes.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _nodes.first.requestFocus();
        }
      });
    }
  }

  void _jumpReveal(double value) {
    _reveal.removeListener(_onReveal);
    _reveal.value = value;
    _reveal.addListener(_onReveal);
  }

  void _onReveal() {
    if (!mounted) {
      return;
    }
    _modalEntry?.markNeedsBuild();
    if (_isModal && _shown && !_open && _reveal.value <= 0.01) {
      _shown = false;
      _removeOverlay();
    }
    setState(() {});
  }

  void _animateReveal() {
    if (!mounted) {
      return;
    }
    final spring = M3ETheme.of(context).navigationDrawerTheme.revealSpring;
    _reveal.motion = const MaterialSpringMotion.expressiveSpatialDefault()
        .copyWith(stiffness: spring.stiffness, damping: spring.damping);
    final target = _open ? 1.0 : 0.0;
    if (!_revealSeeded) {
      _jumpReveal(target);
      _revealSeeded = true;
      return;
    }
    if ((_reveal.value - target).abs() < 0.01) {
      return;
    }
    _reveal.animateTo(target);
  }

  void _syncOverlay() {
    if (!mounted) {
      return;
    }
    if (_isModal && _shown) {
      if (_modalEntry == null) {
        _modalEntry = OverlayEntry(builder: _buildOverlay);
        Overlay.of(context, rootOverlay: true).insert(_modalEntry!);
      } else {
        _modalEntry!.markNeedsBuild();
      }
    } else {
      _removeOverlay();
    }
  }

  void _removeOverlay() {
    _modalEntry?.remove();
    _modalEntry = null;
  }

  void _move(int delta) {
    final current = _nodes.indexWhere((FocusNode node) => node.hasFocus);
    if (current < 0) {
      return;
    }
    final next = current + delta;
    if (next < 0 || next >= _nodes.length) {
      return;
    }
    _nodes[next].requestFocus();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (!_isModal || !_shown) {
      return;
    }
    final width = M3ETheme.of(context).navigationDrawerTheme.width;
    if (width <= 0) {
      return;
    }
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final delta = details.primaryDelta ?? 0;
    final towardEnd = rtl ? -delta : delta;
    _reveal.value = (_reveal.value + towardEnd / width).clamp(0.0, 1.0);
  }

  void _onDragEnd(DragEndDetails details) {
    final theme = M3ETheme.of(context).navigationDrawerTheme;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final velocity = details.primaryVelocity ?? 0;
    final towardEnd = rtl ? -velocity : velocity;
    final close =
        towardEnd < -700 ||
        (towardEnd <= 700 && _reveal.value < theme.dismissDragThreshold);
    _setOpen(!close);
  }

  void _assertIcons() {
    final all = <M3ENavigationDestination>[
      ...widget.destinations,
      for (final section in widget.sections) ...section.destinations,
    ];
    final anyIcon = all.any(
      (M3ENavigationDestination item) => item.icon != null,
    );
    final missing = all.any(
      (M3ENavigationDestination item) => item.icon == null,
    );
    assert(
      !(anyIcon && missing),
      'Use icons on every drawer destination, or on none.',
    );
    assert(
      widget.sections.every(
        (M3ENavigationDrawerSection section) => section.destinations.isNotEmpty,
      ),
      'A section needs 1+ destinations.',
    );
  }

  @override
  Widget build(BuildContext context) {
    _assertIcons();
    return M3EComponentTheme(
      builder: (BuildContext context) {
        if (_isModal) {
          return PopScope(
            canPop: !_shown,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              if (!didPop) {
                _setOpen(false);
              }
            },
            child: const SizedBox.shrink(),
          );
        }
        return _buildStandard(context);
      },
    );
  }

  Widget _buildStandard(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final height = constraints.maxHeight.isFinite
            ? constraints.maxHeight
            : null;
        final panel = _sheet(context, height: height);
        if (!_canDismiss) {
          return _shortcuts(panel);
        }
        if (height == null) {
          return _reveal.value <= 0
              ? const SizedBox.shrink()
              : _shortcuts(panel);
        }
        final theme = M3ETheme.of(context).navigationDrawerTheme;
        final reveal = _reveal.value.clamp(0.0, 1.0);
        return _shortcuts(
          SizedBox(
            width: theme.width * reveal,
            height: height,
            child: ClipRect(
              child: OverflowBox(
                alignment: AlignmentDirectional.centerStart,
                minWidth: theme.width,
                maxWidth: theme.width,
                minHeight: height,
                maxHeight: height,
                child: panel,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOverlay(BuildContext context) {
    final data = M3ETheme.of(context);
    final theme = data.navigationDrawerTheme;
    final reveal = _reveal.value.clamp(0.0, 1.0);
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return M3EScrimSystemUi.wrap(
      _shortcuts(
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final height = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : null;
            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Semantics(
                    button: true,
                    label: 'Close navigation drawer',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _setOpen(false),
                      child: ColoredBox(
                        color: theme
                            .resolveScrim(data.colorScheme)
                            .withValues(alpha: theme.scrimOpacity * reveal),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: GestureDetector(
                    onHorizontalDragUpdate: _onDragUpdate,
                    onHorizontalDragEnd: _onDragEnd,
                    child: FractionalTranslation(
                      translation: Offset(rtl ? 1 - reveal : reveal - 1, 0),
                      child: _sheet(context, height: height),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _shortcuts(Widget child) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
        const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
      },
      child: child,
    );
  }

  Widget _sheet(BuildContext context, {required double? height}) {
    final data = M3ETheme.of(context);
    final theme = data.navigationDrawerTheme;
    final scheme = data.colorScheme;
    final color = _isModal
        ? theme.resolveModalContainer(scheme)
        : theme.containerColor(scheme);
    final radius = BorderRadiusDirectional.only(
      topEnd: Radius.circular(theme.endCornerRadius),
      bottomEnd: Radius.circular(theme.endCornerRadius),
    ).resolve(Directionality.of(context));
    final rows = _rows(data);
    final body = height == null
        ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: rows)
        : ListView(padding: EdgeInsets.zero, children: rows);
    final material = Material(
      type: MaterialType.transparency,
      child: SafeArea(child: body),
    );
    return SizedBox(
      width: theme.width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: theme.endCornerRadius > 0 ? radius : null,
          boxShadow: M3EElevation.shadows(
            theme.elevation,
            shadowColor: scheme.shadow,
          ),
        ),
        child: theme.endCornerRadius > 0
            ? ClipRRect(borderRadius: radius, child: material)
            : material,
      ),
    );
  }

  List<Widget> _rows(M3EThemeData data) {
    final theme = data.navigationDrawerTheme;
    final rows = <Widget>[];
    final headline = widget.headline;
    if (headline != null) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.headlineHorizontalPadding,
            vertical: theme.headlineVerticalPadding,
          ),
          child: Text(
            headline,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: data.typeScale.titleSmall.copyWith(
              color: theme.resolveHeadline(data.colorScheme),
            ),
          ),
        ),
      );
    }
    var index = _appendGroup(
      rows: rows,
      data: data,
      destinations: widget.destinations,
      start: 0,
      indent: 0,
      divided: false,
      header: null,
    );
    for (final section in widget.sections) {
      index = _appendGroup(
        rows: rows,
        data: data,
        destinations: section.destinations,
        start: index,
        indent: theme.sectionIndent,
        divided: true,
        header: section.header,
      );
    }
    return rows;
  }

  int _appendGroup({
    required List<Widget> rows,
    required M3EThemeData data,
    required List<M3ENavigationDestination> destinations,
    required int start,
    required double indent,
    required bool divided,
    required String? header,
  }) {
    final theme = data.navigationDrawerTheme;
    if (divided) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: theme.dividerInset,
            vertical: theme.dividerSpacing,
          ),
          child: SizedBox(
            height: theme.dividerThickness,
            child: ColoredBox(color: theme.resolveDivider(data.colorScheme)),
          ),
        ),
      );
    }
    if (header != null && header.isNotEmpty) {
      rows.add(
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: theme.contentPadding,
            end: theme.contentPadding,
            bottom: theme.headlineVerticalPadding,
          ),
          child: Text(
            header,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: data.typeScale.titleSmall.copyWith(
              color: theme.resolveHeadline(data.colorScheme),
            ),
          ),
        ),
      );
    }
    for (var i = 0; i < destinations.length; i++) {
      final index = start + i;
      rows.add(
        CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.arrowDown): () => _move(1),
            const SingleActivator(LogicalKeyboardKey.arrowUp): () => _move(-1),
          },
          child: M3EDrawerDestinationButton(
            destination: destinations[i],
            selected: index == widget.selectedIndex,
            focusNode: _nodes[index],
            indent: indent,
            onTap: () => _handleSelect(index),
          ),
        ),
      );
    }
    return start + destinations.length;
  }
}
