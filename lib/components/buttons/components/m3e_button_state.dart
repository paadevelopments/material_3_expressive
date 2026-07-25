// Button state + icon layout extracted for file_length.
part of '../m3e_buttons.dart';

class _M3EButtonIconLayout extends StatelessWidget {
  const _M3EButtonIconLayout({
    required this.icon,
    required this.label,
    required this.size,
    required this.iconAlignment,
  });

  final Widget icon;
  final Widget label;
  final M3EButtonSize size;
  final IconAlignment iconAlignment;

  @override
  Widget build(BuildContext context) {
    final m = M3ETheme.of(context).buttonTheme.measurements(size);
    final children = <Widget>[
      RepaintBoundary(
        child: IconTheme.merge(
          data: IconThemeData(size: m.iconSize),
          child: icon,
        ),
      ),
      SizedBox(width: m.iconGap),
      Flexible(
        child: DefaultTextStyle.merge(
          maxLines: 2,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          child: label,
        ),
      ),
    ];

    if (iconAlignment == IconAlignment.end) {
      children.setAll(0, [children[2], children[1], children[0]]);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}

class _M3EButtonState extends State<M3EButton>
    with M3EBaseButtonState<M3EButton> {
  late M3EButtonMeasurements _measurements;

  M3EButtonTheme get _buttonTheme => M3ETheme.of(context).buttonTheme;

  M3EColorScheme get _scheme => M3ETheme.of(context).colorScheme;

  @override
  M3EButtonSize get buttonSize => widget.size;

  @override
  WidgetStatesController? get externalStatesController =>
      widget.statesController;

  @override
  FocusNode? get externalFocusNode => widget.focusNode;

  @override
  M3EButtonMotion? get effectiveMotion => widget.decorationMotion;

  @override
  void initState() {
    super.initState();
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
  void didUpdateWidget(covariant M3EButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    handleStatesControllerUpdate(
      oldWidget.statesController,
      widget.statesController,
    );
    handleFocusNodeUpdate(oldWidget.focusNode, widget.focusNode);

    if (oldWidget.size != widget.size) {
      _updateMeasurements();
    }

    if (oldWidget.size != widget.size ||
        oldWidget.decoration?.foregroundColor !=
            widget.decoration?.foregroundColor ||
        oldWidget.style != widget.style) {
      updateLabelStyle(context);
    }

    if (widget.decoration?.motion != oldWidget.decoration?.motion) {
      updateSpringMotion();
    }
  }

  @override
  void dispose() {
    disposeBaseButtonState();
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(EnumProperty<M3EButtonStyle>('style', widget.style))
      ..add(DiagnosticsProperty<M3EButtonSize>('size', widget.size))
      ..add(EnumProperty<M3EButtonShape>('shape', widget.shape))
      ..add(
        FlagProperty('enabled', value: widget.enabled, ifFalse: 'disabled'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return M3EComponentTheme(builder: _buildContent);
  }
}
