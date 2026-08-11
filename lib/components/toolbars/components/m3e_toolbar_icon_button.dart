import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart'
    show M3ETheme, M3EToolbar;
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../../icon_buttons/m3e_icon_buttons.dart';
import '../models/m3e_toolbar_item.dart';

/// Inline icon action for [M3EToolbar] — thin adapter over [M3EIconButton].
///
/// When [M3EToolbarAction.label] is set, the label lives **inside** the button
/// pill. Width springs between the icon-button visual size (inactive, icon
/// only) and the natural icon+label width (active). Layout width follows the
/// spring so the parent toolbar pill grows/shrinks in sync.
class M3EToolbarIconButton extends StatefulWidget {
  /// M3EToolbarIconButton.
  const M3EToolbarIconButton({
    required this.action,
    required this.size,
    this.onPressed,
    this.variant,
    this.pillActiveSpring = true,
    super.key,
  });

  /// action.
  final M3EToolbarAction action;

  /// size.
  final M3EIconButtonSize size;

  /// Overrides [M3EToolbarAction.onPressed] when set (e.g. expand trigger).
  final VoidCallback? onPressed;

  /// Defaults to filled when [M3EToolbarAction.isExpandTrigger] or
  /// [M3EToolbarAction.active], else standard.
  final M3EIconButtonVariant? variant;

  /// When false, layout width snaps while label morph animation still runs.
  final bool pillActiveSpring;

  @override
  State<M3EToolbarIconButton> createState() => _M3EToolbarIconButtonState();
}

class _M3EToolbarIconButtonState extends State<M3EToolbarIconButton>
    with SingleTickerProviderStateMixin {
  late final SingleMotionController _labelCtrl;

  static SpringMotion get _labelMotion =>
      const MaterialSpringMotion.expressiveSpatialFast().copyWith(damping: 0.4);

  bool get _hasLabel {
    final String? label = widget.action.label;
    return label != null && label.isNotEmpty;
  }

  bool get _showLabeled => _hasLabel && widget.action.active;

  @override
  void initState() {
    super.initState();
    _labelCtrl = SingleMotionController(
      motion: _labelMotion,
      vsync: this,
      initialValue: _showLabeled ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant M3EToolbarIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final bool wasLabeled =
        oldWidget.action.active &&
        oldWidget.action.label != null &&
        oldWidget.action.label!.isNotEmpty;
    if (wasLabeled != _showLabeled) {
      _labelCtrl
        ..motion = _labelMotion
        ..animateTo(_showLabeled ? 1 : 0);
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasLabel) {
      return _buildIconButton(icon: Icon(widget.action.icon));
    }
    return AnimatedBuilder(
      animation: _labelCtrl,
      builder: (BuildContext context, Widget? child) {
        return _buildLabeled(context, progress: _labelCtrl.value);
      },
    );
  }

  M3EIconButtonVariant get _resolvedVariant =>
      widget.variant ??
      (widget.action.isExpandTrigger || widget.action.active
          ? M3EIconButtonVariant.filled
          : M3EIconButtonVariant.standard);

  VoidCallback? get _resolvedOnPressed => widget.action.enabled
      ? (widget.onPressed ?? widget.action.onPressed)
      : null;

  Widget _buildIconButton({required Widget icon, Size? visualSize}) {
    return M3EIconButton(
      icon: icon,
      onPressed: _resolvedOnPressed,
      tooltip: widget.action.tooltip ?? widget.action.label,
      semanticLabel: widget.action.semanticLabel,
      size: widget.size,
      variant: _resolvedVariant,
      visualSize: visualSize,
    );
  }

  Widget _buildLabeled(BuildContext context, {required double progress}) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EIconButtonTheme iconTheme = theme.iconButtonTheme;
    final Size visual = iconTheme.visual(
      widget.size,
      M3EIconButtonWidth.defaultWidth,
    );
    final double iconPx = iconTheme.iconSize(widget.size);
    final double t = progress.clamp(0.0, 1.0);
    final TextStyle labelStyle = theme.typeScale.labelLarge.copyWith(
      fontWeight: FontWeight.w600,
    );
    final double labelWidth = _measureLabelWidth(
      widget.action.label!,
      labelStyle,
    );
    // Icon-only visual → icon + gap + label; layout follows this spring.
    const double labelGap = 6;
    final double expandedWidth = visual.width + labelGap + labelWidth;
    final double sprungWidth =
        visual.width + (expandedWidth - visual.width) * t;
    final layoutWidth = _showLabeled ? expandedWidth : visual.width;
    final widthForLayout = widget.pillActiveSpring ? sprungWidth : layoutWidth;

    final Widget icon = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(widget.action.icon, size: iconPx),
        if (t > 0.01)
          ClipRect(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: t,
              child: Opacity(
                opacity: t,
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: labelGap),
                  child: Builder(
                    builder: (BuildContext context) {
                      return Text(
                        widget.action.label!,
                        style: labelStyle.copyWith(
                          color: IconTheme.of(context).color,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        softWrap: false,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    return _buildIconButton(
      icon: icon,
      visualSize: Size(widthForLayout, visual.height),
    );
  }

  double _measureLabelWidth(String label, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: label, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }
}
