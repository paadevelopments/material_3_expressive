import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';

/// Animates a snackbar in from the bottom, holds it, then removes [entry].
class M3ESnackbarHost extends StatefulWidget {
  const M3ESnackbarHost({
    required this.child,
    required this.duration,
    required this.entry,
    super.key,
  });

  final Widget child;
  final Duration duration;
  final OverlayEntry entry;

  @override
  State<M3ESnackbarHost> createState() => M3ESnackbarHostState();
}

class M3ESnackbarHostState extends State<M3ESnackbarHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: M3EMotion.medium2,
      reverseDuration: M3EMotion.short4,
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, 1.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: M3EMotion.emphasized),
    );
    _controller.forward();
    _timer = Timer(widget.duration, _dismiss);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _dismiss() async {
    if (!mounted) {
      return;
    }
    await _controller.reverse();
    widget.entry.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
      child: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SlideTransition(position: _offset, child: widget.child),
        ),
      ),
    );
  }
}
