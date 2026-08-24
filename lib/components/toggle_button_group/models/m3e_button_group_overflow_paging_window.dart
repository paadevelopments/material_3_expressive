/// Describes the visible window of items in a paged overflow layout.
class M3EButtonGroupOverflowPagingWindow {
  /// M3EButtonGroupOverflowPagingWindow.
  const M3EButtonGroupOverflowPagingWindow({
    required this.start,
    required this.end,
    required this.needsBack,
    required this.needsForward,
  });

  /// start.

  final int start;

  /// end.
  final int end;

  /// needsBack.
  final bool needsBack;

  /// needsForward.
  final bool needsForward;
}
