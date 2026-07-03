import 'package:flutter/widgets.dart';

class MeasureSize extends StatefulWidget {
  final Widget child;
  final void Function(Size) onChange;

  const MeasureSize({super.key, required this.child, required this.onChange});

  @override
  State<MeasureSize> createState() => _MeasureSizeState();
}

class _MeasureSizeState extends State<MeasureSize> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
  }

  @override
  void didUpdateWidget(covariant MeasureSize oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _notifySize());
  }

  void _notifySize() {
    if (mounted) {
      final RenderBox? box = context.findRenderObject() as RenderBox?;
      if (box != null && box.hasSize) {
        widget.onChange(box.size);
      }
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
