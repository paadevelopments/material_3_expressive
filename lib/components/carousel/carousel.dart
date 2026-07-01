import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

/// A Material 3 Expressive carousel.
///
/// A horizontally scrollable strip of items. The focused item is shown at full
/// size while neighbours shrink toward the edges, producing the expressive
/// hero layout. Items are clipped to the large corner shape.
class M3ECarousel extends StatefulWidget {
  const M3ECarousel({
    required this.items,
    this.height = 200,
    this.viewportFraction = 0.8,
    this.onItemSelected,
    super.key,
  }) : assert(items.length > 0, 'A carousel needs at least one item.');

  final List<Widget> items;
  final double height;
  final double viewportFraction;
  final ValueChanged<int>? onItemSelected;

  @override
  State<M3ECarousel> createState() => _M3ECarouselState();
}

class _M3ECarouselState extends State<M3ECarousel> {
  late final PageController _controller = PageController(
    viewportFraction: widget.viewportFraction,
  );
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    setState(() => _page = _controller.page ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.items.length,
        onPageChanged: widget.onItemSelected,
        itemBuilder: (BuildContext context, int index) {
          return _buildItem(index);
        },
      ),
    );
  }

  Widget _buildItem(int index) {
    final double delta = (index - _page).abs().clamp(0, 1).toDouble();
    final double scale = 1 - delta * 0.15;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Transform.scale(
        scale: scale,
        child: ClipRRect(
          borderRadius: M3EShapes.radiusExtraLarge,
          child: SizedBox.expand(child: widget.items[index]),
        ),
      ),
    );
  }
}
