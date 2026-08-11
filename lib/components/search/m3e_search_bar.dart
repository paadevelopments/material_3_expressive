import 'package:flutter/material.dart'
    show
        AdaptiveTextSelectionToolbar,
        InkWell,
        Material,
        MaterialType,
        WidgetStateProperty,
        WidgetStatePropertyAll,
        WidgetStatesController;
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../icon_buttons/m3e_icon_buttons.dart';
import 'res/m3e_search_constants.dart';
import 'styles/m3e_search_bar_theme.dart';

part 'components/m3e_search_bar_input.dart';
part 'components/m3e_search_bar_build.dart';

/// M3ESearchBar.

class M3ESearchBar extends StatefulWidget {
  /// M3ESearchBar.
  const M3ESearchBar({
    this.controller,
    this.focusNode,
    this.hintText,
    this.leading,
    this.trailing,
    this.onTap,
    this.onTapOutside,
    this.onChanged,
    this.onSubmitted,
    this.constraints,
    this.elevation,
    this.backgroundColor,
    this.shadowColor,
    this.surfaceTintColor,
    this.overlayColor,
    this.side,
    this.shape,
    this.padding,
    this.textStyle,
    this.hintStyle,
    this.textCapitalization,
    this.enabled = true,
    this.autoFocus = false,
    this.textInputAction,
    this.keyboardType,
    this.scrollPadding = const EdgeInsets.all(20),
    this.contextMenuBuilder = m3eDefaultSearchContextMenuBuilder,
    this.readOnly = false,
    this.expandOnFocus = true,
    this.expandRestPadding,
    this.smartDashesType,
    this.smartQuotesType,
    this.alignment = AlignmentDirectional.centerStart,
    super.key,
  });

  /// controller.

  final TextEditingController? controller;

  /// focusNode.
  final FocusNode? focusNode;

  /// hintText.
  final String? hintText;

  /// leading.
  final Widget? leading;

  /// trailing.
  final Iterable<Widget>? trailing;

  /// onTap.
  final GestureTapCallback? onTap;

  /// onTapOutside.
  final TapRegionCallback? onTapOutside;

  /// onChanged.
  final ValueChanged<String>? onChanged;

  /// onSubmitted.
  final ValueChanged<String>? onSubmitted;

  /// constraints.
  final BoxConstraints? constraints;

  /// elevation.
  final WidgetStateProperty<double?>? elevation;

  /// backgroundColor.
  final WidgetStateProperty<Color?>? backgroundColor;

  /// shadowColor.
  final WidgetStateProperty<Color?>? shadowColor;

  /// surfaceTintColor.
  final WidgetStateProperty<Color?>? surfaceTintColor;

  /// overlayColor.
  final WidgetStateProperty<Color?>? overlayColor;

  /// side.
  final WidgetStateProperty<BorderSide?>? side;

  /// shape.
  final WidgetStateProperty<OutlinedBorder?>? shape;

  /// padding.
  final WidgetStateProperty<EdgeInsetsGeometry?>? padding;

  /// textStyle.
  final WidgetStateProperty<TextStyle?>? textStyle;

  /// hintStyle.
  final WidgetStateProperty<TextStyle?>? hintStyle;

  /// textCapitalization.
  final TextCapitalization? textCapitalization;

  /// enabled.
  final bool enabled;

  /// autoFocus.
  final bool autoFocus;

  /// textInputAction.
  final TextInputAction? textInputAction;

  /// keyboardType.
  final TextInputType? keyboardType;

  /// scrollPadding.
  final EdgeInsets scrollPadding;

  /// contextMenuBuilder.
  final EditableTextContextMenuBuilder contextMenuBuilder;

  /// readOnly.
  final bool readOnly;

  /// expandOnFocus.
  final bool expandOnFocus;

  /// expandRestPadding.
  final double? expandRestPadding;

  /// smartDashesType.
  final SmartDashesType? smartDashesType;

  /// smartQuotesType.
  final SmartQuotesType? smartQuotesType;

  /// Alignment of leading, hint, and trailing while the field is empty and
  /// unfocused. Switches to start layout when focused or when text is present.
  final AlignmentGeometry alignment;

  @override
  State<M3ESearchBar> createState() => _M3ESearchBarState();
}

class _M3ESearchBarState extends State<M3ESearchBar>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _controller =
      widget.controller ?? TextEditingController();
  late final WidgetStatesController _statesController =
      WidgetStatesController();
  late final AnimationController _expandPaddingController;
  FocusNode? _internalFocusNode;
  bool _expandPaddingSyncScheduled = false;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_internalFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _expandPaddingController = AnimationController.unbounded(vsync: this);
    _statesController.addListener(() => setState(() {}));
    _controller.addListener(_handleTextChange);
    _focusNode.addListener(_handleFocusChange);
    _syncFocusedState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _syncExpandPaddingController(M3ETheme.of(context).searchBarTheme);
    });
  }

  void _scheduleExpandPaddingSync(
    M3ESearchBarTheme barTheme, {
    bool animate = false,
  }) {
    if (_expandPaddingSyncScheduled) {
      return;
    }
    _expandPaddingSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _expandPaddingSyncScheduled = false;
      if (!mounted) {
        return;
      }
      _syncExpandPaddingController(barTheme, animate: animate);
    });
  }

  @override
  void didUpdateWidget(covariant M3ESearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _internalFocusNode)?.removeListener(
        _handleFocusChange,
      );
      _focusNode.addListener(_handleFocusChange);
      _syncFocusedState();
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _controller.removeListener(_handleTextChange);
    _expandPaddingController.dispose();
    _statesController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    _internalFocusNode?.dispose();
    super.dispose();
  }

  void _syncFocusedState() {
    _statesController.update(WidgetState.focused, _focusNode.hasFocus);
  }

  void _handleTextChange() => setState(() {});

  /// Empty and unfocused: may group leading + hint + trailing for alignment.
  bool get _alignIdleContent =>
      !_focusNode.hasFocus && _controller.text.isEmpty;

  /// Whether idle content should shrink-wrap and honor [M3ESearchBar.alignment]
  /// (horizontal center). Start-aligned idle keeps the expanded field layout so
  /// trailing stays at the end of the pill.
  bool _groupsIdleContent(TextDirection textDirection) {
    if (!_alignIdleContent) {
      return false;
    }
    final Alignment resolved = widget.alignment.resolve(textDirection);
    return resolved.x.abs() < 0.001;
  }

  double _restingExpandPadding(M3ESearchBarTheme barTheme) {
    return widget.expandRestPadding ?? barTheme.restingExpandPadding;
  }

  double _focusedExpandPadding(M3ESearchBarTheme barTheme) {
    return _restingExpandPadding(barTheme) / 2;
  }

  bool _shouldAnimateExpandPadding(M3ESearchBarTheme barTheme) {
    // Read-only bars can still use the resting (unexpanded) inset; they just
    // never animate to the focused width because they do not take focus.
    if (!widget.expandOnFocus || !barTheme.expandOnFocus || !widget.enabled) {
      return false;
    }
    return _restingExpandPadding(barTheme) > 0.5;
  }

  double _targetExpandPadding(M3ESearchBarTheme barTheme) {
    if (!_shouldAnimateExpandPadding(barTheme)) {
      return 0;
    }
    return _focusNode.hasFocus
        ? _focusedExpandPadding(barTheme)
        : _restingExpandPadding(barTheme);
  }

  void _syncExpandPaddingController(
    M3ESearchBarTheme barTheme, {
    bool animate = false,
  }) {
    final double target = _targetExpandPadding(barTheme);
    if (!_shouldAnimateExpandPadding(barTheme)) {
      _expandPaddingController.value = target;
      return;
    }
    if (animate &&
        (_expandPaddingController.isAnimating ||
            (target - _expandPaddingController.value).abs() > 0.5)) {
      _expandPaddingController
        ..stop()
        ..animateWith(
          SpringSimulation(
            barTheme.focusExpandSpring.toDescription(),
            _expandPaddingController.value,
            target,
            _expandPaddingController.velocity,
          ),
        );
      return;
    }
    if (!_expandPaddingController.isAnimating) {
      _expandPaddingController.value = target;
    }
  }

  void _handleFocusChange() {
    _syncFocusedState();
    _syncExpandPaddingController(
      M3ETheme.of(context).searchBarTheme,
      animate: true,
    );
  }

  void _handleTap() {
    widget.onTap?.call();
    // Read-only bars (e.g. SearchAnchor.bar) open a view and must not take
    // keyboard focus — the view's search field owns editing.
    if (widget.readOnly || !widget.enabled) {
      return;
    }
    if (!_focusNode.hasFocus) {
      _focusNode.requestFocus();
    } else {
      _syncExpandPaddingController(
        M3ETheme.of(context).searchBarTheme,
        animate: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(
      builder: (BuildContext context) {
        final theme = M3ETheme.of(context);
        final barTheme = theme.searchBarTheme;
        final scheme = theme.colorScheme;
        final states = _statesController.value;
        final textDirection = Directionality.of(context);

        if (_expandPaddingController.value == 0 &&
            !_expandPaddingController.isAnimating &&
            _shouldAnimateExpandPadding(barTheme)) {
          _scheduleExpandPaddingSync(barTheme);
        }

        final Widget bar = _buildBarContent(
          theme: theme,
          barTheme: barTheme,
          scheme: scheme,
          states: states,
          textDirection: textDirection,
        );

        final BoxConstraints barConstraints = barTheme.constraints(
          override: widget.constraints,
        );

        if (!_shouldAnimateExpandPadding(barTheme)) {
          return ConstrainedBox(constraints: barConstraints, child: bar);
        }

        return AnimatedBuilder(
          animation: _expandPaddingController,
          builder: (BuildContext context, Widget? child) {
            // Allow spring overshoot past the resting inset; never go negative.
            final pad = _expandPaddingController.value;
            final horizontal = pad.isFinite && pad > 0 ? pad : 0.0;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontal),
              child: ConstrainedBox(constraints: barConstraints, child: bar),
            );
          },
        );
      },
    );
  }
}
