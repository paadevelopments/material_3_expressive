import 'dart:math' as math;
import 'package:flutter/material.dart' show InkWell, Material, Tooltip;
import 'package:flutter/widgets.dart';
import 'package:motor/motor.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_expandable_enums.dart';
import '../styles/m3e_expandable_style.dart';
import '../utils/m3e_measure_size.dart';

typedef M3EExpandableHeaderBuilder = Widget Function(
    BuildContext context, int index, double progress);
typedef M3EExpandableBodyBuilder = Widget Function(
    BuildContext context, int index, double progress);

class M3EExpandableItem extends StatefulWidget {
  final int index;
  final int totalCount;
  final bool isExpanded;
  final M3EExpandableHeaderBuilder headerBuilder;
  final M3EExpandableBodyBuilder bodyBuilder;
  final M3EExpandableStyle decoration;
  final M3ESpring expandMotion;
  final M3ESpring collapseMotion;
  final VoidCallback onToggle;

  const M3EExpandableItem({
    super.key,
    required this.index,
    required this.totalCount,
    required this.isExpanded,
    required this.headerBuilder,
    required this.bodyBuilder,
    required this.decoration,
    required this.expandMotion,
    required this.collapseMotion,
    required this.onToggle,
  });

  @override
  State<M3EExpandableItem> createState() => _M3EExpandableItemState();
}

class _M3EExpandableItemState extends State<M3EExpandableItem>
    with TickerProviderStateMixin {
  late final SingleMotionController _expandCtrl;
  bool _isHovered = false;
  bool _isPressed = false;
  double? _collapsedHeight;
  double? _expandedHeight;

  @override
  void initState() {
    super.initState();
    final spring = widget.isExpanded ? widget.expandMotion : widget.collapseMotion;
    _expandCtrl = SingleMotionController(
      motion: MaterialSpringMotion.expressiveEffectsFast().copyWith(
        stiffness: spring.stiffness,
        damping: spring.damping,
      ),
      vsync: this,
    )..value = widget.isExpanded ? 1.0 : 0.0;
  }

  @override
  void didUpdateWidget(covariant M3EExpandableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isExpanded != widget.isExpanded) {
      final spring = widget.isExpanded ? widget.expandMotion : widget.collapseMotion;
      _expandCtrl.motion = MaterialSpringMotion.expressiveEffectsFast().copyWith(
        stiffness: spring.stiffness,
        damping: spring.damping,
      );
      _expandCtrl.animateTo(widget.isExpanded ? 1.0 : 0.0);
    }
  }

  void _handleHoverChanged(bool hovering) => setState(() => _isHovered = hovering);
  void _handleTapDown() => setState(() => _isPressed = true);
  void _handleTapUp() => setState(() => _isPressed = false);
  void _handleTapCancel() => setState(() => _isPressed = false);

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  BorderRadius _buildEffectiveRadius() {
    final d = widget.decoration;
    final isFirst = widget.index == 0;
    final isLast = widget.index == widget.totalCount - 1;
    final isSingle = widget.totalCount == 1;

    if (widget.isExpanded && d.expandedRadius != null) {
      return BorderRadius.circular(d.expandedRadius!);
    }
    if (isSingle) return BorderRadius.circular(d.outerRadius);

    final effectiveInnerRadius = _isPressed
        ? d.pressedRadius
        : (_isHovered ? d.hoverRadius : d.innerRadius);

    if (isFirst) {
      return BorderRadius.vertical(
        top: Radius.circular(d.outerRadius),
        bottom: Radius.circular(effectiveInnerRadius),
      );
    }
    if (isLast) {
      return BorderRadius.vertical(
        top: Radius.circular(effectiveInnerRadius),
        bottom: Radius.circular(d.outerRadius),
      );
    }
    return BorderRadius.circular(effectiveInnerRadius);
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final cs = theme.colorScheme;
    final d = widget.decoration;
    final isLast = widget.index == widget.totalCount - 1;

    final canTapHeader = d.tapHeaderToToggle;
    final canTapBody = (widget.isExpanded && d.tapBodyToCollapse) ||
        (!widget.isExpanded && d.tapBodyToExpand);
    final entireCardTappable = !d.tapIconToToggle && canTapHeader && canTapBody;

    final outerTap = entireCardTappable ? widget.onToggle : null;
    final headerTap = (!entireCardTappable && canTapHeader && !d.tapIconToToggle)
        ? widget.onToggle
        : null;
    final String? outerTooltip = entireCardTappable
        ? (widget.isExpanded ? d.collapseTooltip : d.expandTooltip)
        : null;

    return RepaintBoundary(
      child: Padding(
        padding: d.margin ?? EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : d.gap),
          child: _buildAnimatedContainer(
            cs,
            d,
            outerTap,
            headerTap,
            outerTooltip,
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(
    M3EColorScheme cs,
    M3EExpandableStyle d,
    VoidCallback? outerTap,
    VoidCallback? headerTap,
    String? outerTooltip,
  ) {
    Widget content = AnimatedBuilder(
      animation: _expandCtrl,
      builder: (context, child) {
        final progress = _expandCtrl.value;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(
              d,
              progress,
              headerTap,
              isEntirelyTappable: outerTap != null,
            ),
            _buildExpandableBody(
              d,
              progress,
              isEntirelyTappable: outerTap != null,
            ),
          ],
        );
      },
    );

    content = _buildInteractionWrapper(
      d,
      onTap: outerTap,
      tooltip: outerTooltip,
      child: content,
    );

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 40),
      curve: Curves.easeOut,
      tween: BorderRadiusTween(
        begin: _buildEffectiveRadius(),
        end: _buildEffectiveRadius(),
      ),
      builder: (context, animatedRadius, child) {
        return Material(
          elevation: d.elevation,
          color: d.color ?? cs.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: animatedRadius ?? _buildEffectiveRadius(),
            side: d.border ?? BorderSide.none,
          ),
          clipBehavior: Clip.antiAlias,
          child: child,
        );
      },
      child: content,
    );
  }

  Widget _buildHeader(
    M3EExpandableStyle d,
    double progress,
    VoidCallback? onTap, {
    required bool isEntirelyTappable,
  }) {
    final headerContent = Padding(
      padding: d.headerPadding ??
          M3ETheme.of(context).listTheme.expandable.headerPadding,
      child: Row(
        crossAxisAlignment: d.headerAlignment == CrossAxisAlignment.stretch
            ? CrossAxisAlignment.center
            : d.headerAlignment,
        textBaseline: d.headerAlignment == CrossAxisAlignment.baseline
            ? TextBaseline.alphabetic
            : null,
        children: [
          if (d.iconPlacement == M3EExpandableIconPlacement.left) ...[
            _buildIcon(d, progress, widget.onToggle),
            Expanded(
              child: widget.headerBuilder(context, widget.index, progress),
            ),
          ] else ...[
            Expanded(
              child: widget.headerBuilder(context, widget.index, progress),
            ),
            _buildIcon(d, progress, widget.onToggle),
          ],
        ],
      ),
    );

    final String? headerTooltip = (d.tapHeaderToToggle && !isEntirelyTappable)
        ? (widget.isExpanded ? d.collapseTooltip : d.expandTooltip)
        : null;

    return _buildInteractionWrapper(
      d,
      onTap: onTap,
      isHeader: true,
      semanticLabel: 'Item ${widget.index + 1} of ${widget.totalCount}',
      semanticHint: widget.isExpanded ? 'Collapse' : 'Expand',
      isExpanded: widget.isExpanded,
      tooltip: headerTooltip,
      child: headerContent,
    );
  }

  Widget _buildIcon(
    M3EExpandableStyle d,
    double progress,
    VoidCallback onToggle,
  ) {
    if (d.expandIcon == null && d.collapseIcon == null) {
      return const SizedBox.shrink();
    }
    final bool isExpanded = progress >= 0.5;
    final Widget? icon = isExpanded ? d.collapseIcon : d.expandIcon;
    if (icon == null) return const SizedBox.shrink();

    final double angle = d.iconRotationAngle * progress;
    final String? tooltip = d.tapIconToToggle
        ? (isExpanded ? d.collapseTooltip : d.expandTooltip)
        : null;

    Widget iconWidget = Padding(
      padding: d.iconPadding,
      child: Transform.rotate(angle: angle, child: icon),
    );

    if (d.tapIconToToggle) {
      iconWidget = _buildInteractionWrapper(
        d,
        onTap: onToggle,
        isHeader: true,
        isIcon: true,
        semanticLabel: isExpanded ? 'Collapse button' : 'Expand button',
        isExpanded: isExpanded,
        tooltip: tooltip,
        child: iconWidget,
      );
    } else {
      iconWidget = ExcludeSemantics(child: iconWidget);
    }
    return iconWidget;
  }

  Widget _buildExpandableBody(
    M3EExpandableStyle d,
    double progress, {
    required bool isEntirelyTappable,
  }) {
    final effectivePadding = d.bodyPadding ??
        M3ETheme.of(context).listTheme.expandable.bodyPadding;
    final resolvedPadding = effectivePadding.resolve(Directionality.of(context));
    final contentShift = math.min(12.0, resolvedPadding.bottom * 0.6 + 4.0);
    final needsMeasurement = _collapsedHeight == null || _expandedHeight == null;

    final clampedProgress = progress.clamp(0.0, 1.0);
    final contentCollapsed = _collapsedHeight ?? 0.0;
    final contentExpanded = _expandedHeight ?? 200.0;
    final paddingVertical = effectivePadding.vertical;

    final totalCollapsed =
        contentCollapsed > 0 ? contentCollapsed + paddingVertical : 0.0;
    final totalExpanded =
        contentExpanded > 0 ? contentExpanded + paddingVertical : 0.0;

    final bodyHeight =
        math.max(0.0, totalCollapsed + (totalExpanded - totalCollapsed) * progress);
    final translationY = -(1.0 - clampedProgress) * contentShift;

    return Stack(
      children: [
        if (needsMeasurement)
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Offstage(
              offstage: true,
              child: Padding(
                padding: effectivePadding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_collapsedHeight == null)
                      M3EMeasureSize(
                        onChange: (size) =>
                            setState(() => _collapsedHeight = size.height),
                        child: widget.bodyBuilder(context, widget.index, 0.0),
                      ),
                    if (_expandedHeight == null)
                      M3EMeasureSize(
                        onChange: (size) =>
                            setState(() => _expandedHeight = size.height),
                        child: widget.bodyBuilder(context, widget.index, 1.0),
                      ),
                  ],
                ),
              ),
            ),
          ),
        if (bodyHeight > 0)
          SizedBox(
            height: bodyHeight,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              padding: effectivePadding,
              child: SizedBox(
                width: double.infinity,
                child: Builder(
                  builder: (context) {
                    final isExpanded = progress > 0.5;
                    final canTapBody = (isExpanded && d.tapBodyToCollapse) ||
                        (!isExpanded && d.tapBodyToExpand);
                    final tapCallback =
                        (!isEntirelyTappable && canTapBody && !d.tapIconToToggle)
                            ? widget.onToggle
                            : null;
                    final String? bodyTooltip = (tapCallback != null)
                        ? (isExpanded ? d.collapseTooltip : d.expandTooltip)
                        : null;

                    return _buildInteractionWrapper(
                      d,
                      onTap: tapCallback,
                      tooltip: bodyTooltip,
                      child: Align(
                        alignment: d.bodyAlignment,
                        child: Transform.translate(
                          offset: Offset(0, translationY),
                          child: widget.bodyBuilder(context, widget.index, progress),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildInteractionWrapper(
    M3EExpandableStyle d, {
    required Widget child,
    required VoidCallback? onTap,
    bool isHeader = false,
    bool isIcon = false,
    String? semanticLabel,
    String? semanticHint,
    bool? isExpanded,
    String? tooltip,
  }) {
    Widget result = child;
    if (tooltip != null) {
      result = Tooltip(message: tooltip, child: result);
    }
    if (onTap == null) {
      return Semantics(
        label: semanticLabel,
        expanded: isExpanded,
        child: result,
      );
    }
    if (!d.useInkWell) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        onTapDown: isHeader ? (_) => _handleTapDown() : null,
        onTapUp: isHeader ? (_) => _handleTapUp() : null,
        onTapCancel: isHeader ? () => _handleTapCancel() : null,
        child: Semantics(
          label: semanticLabel,
          hint: semanticHint,
          expanded: isExpanded,
          button: true,
          onTap: onTap,
          child: result,
        ),
      );
    }
    return InkWell(
      customBorder: isIcon ? const CircleBorder() : null,
      splashColor: d.splashColor,
      highlightColor: d.highlightColor,
      splashFactory: d.splashFactory,
      enableFeedback: d.enableFeedback,
      onTap: onTap,
      onHover: isHeader ? (h) => _handleHoverChanged(h) : null,
      onTapDown: isHeader ? (_) => _handleTapDown() : null,
      onTapUp: isHeader ? (_) => _handleTapUp() : null,
      onTapCancel: isHeader ? () => _handleTapCancel() : null,
      child: Semantics(
        label: semanticLabel,
        hint: semanticHint,
        expanded: isExpanded,
        button: true,
        onTap: onTap,
        child: result,
      ),
    );
  }
}
