part of '../m3e_toggle_button.dart';

class _M3EToggleButtonState extends State<M3EToggleButton>
    with M3EBaseButtonState<M3EToggleButton> {
  late bool _localChecked;
  late M3EButtonMeasurements _measurements;

  M3EButtonTheme get _buttonTheme => M3ETheme.of(context).buttonTheme;

  M3EToggleButtonTheme get _toggleTheme =>
      M3ETheme.of(context).toggleButtonTheme;

  M3EToggleButtonGroupTheme get _groupTheme =>
      M3ETheme.of(context).toggleButtonGroupTheme;

  M3EColorScheme get _scheme => M3ETheme.of(context).colorScheme;

  Widget? _cachedIcon;
  Widget? _cachedLabel;
  bool _cachedIconChecked = false;
  bool _cachedLabelChecked = false;

  bool get _isChecked => widget.checked ?? _localChecked;
  bool get _hasLabel => _isChecked
      ? (widget.checkedLabel != null || widget.label != null)
      : widget.label != null;

  Widget? get _effectiveIcon {
    final checked = _isChecked;
    if (_cachedIconChecked == checked && _cachedIcon != null) {
      return _cachedIcon;
    }
    return _cachedIcon = () {
      _cachedIconChecked = checked;
      return checked ? (widget.checkedIcon ?? widget.icon) : widget.icon;
    }();
  }

  Widget? get _effectiveLabel {
    final checked = _isChecked;
    if (_cachedLabelChecked == checked && _cachedLabel != null) {
      return _cachedLabel;
    }
    return _cachedLabel = () {
      _cachedLabelChecked = checked;
      return checked ? (widget.checkedLabel ?? widget.label) : widget.label;
    }();
  }

  @override
  M3EButtonSize get buttonSize => widget.size;

  @override
  WidgetStatesController? get externalStatesController =>
      widget.statesController;

  @override
  FocusNode? get externalFocusNode => widget.focusNode;

  @override
  M3EButtonMotion? get effectiveMotion =>
      widget.decorationMotion ?? M3EButtonMotion.expressiveSpatialPress;

  @override
  void initState() {
    super.initState();
    _localChecked = widget.checked ?? false;
    initBaseButtonState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateMeasurements();
    updateLabelStyle(context);
    updateSpringMotion();
  }

  void _updateMeasurements() {
    _measurements = _buttonTheme.measurements(widget.size);
  }

  @override
  void didUpdateWidget(covariant M3EToggleButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleStatesControllerUpdate(
      oldWidget.statesController,
      widget.statesController,
    );
    handleFocusNodeUpdate(oldWidget.focusNode, widget.focusNode);
    if (widget.checked != null && oldWidget.checked != widget.checked) {
      _localChecked = widget.checked!;
    }
    if (oldWidget.size != widget.size) {
      _updateMeasurements();
    }
    if (oldWidget.size != widget.size ||
        oldWidget.checked != widget.checked ||
        oldWidget.decoration?.foregroundColor !=
            widget.decoration?.foregroundColor ||
        oldWidget.style != widget.style) {
      updateLabelStyle(context);
    }
    if (widget.decoration?.motion != oldWidget.decoration?.motion) {
      updateSpringMotion();
    }
    if (widget.icon != oldWidget.icon ||
        widget.checkedIcon != oldWidget.checkedIcon ||
        widget.label != oldWidget.label ||
        widget.checkedLabel != oldWidget.checkedLabel) {
      _cachedIcon = null;
      _cachedLabel = null;
    }
  }

  void _handleTap() {
    if (!widget.enabled) {
      return;
    }
    M3EHaptics.trigger(widget.decorationHaptic);
    final newChecked = !_isChecked;
    if (widget.checked == null) {
      setState(() => _localChecked = newChecked);
    }
    widget.onCheckedChange?.call(newChecked);
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildWidget);
  }
}
