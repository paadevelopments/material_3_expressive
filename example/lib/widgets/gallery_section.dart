import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// A titled block that groups related component demos on a gallery page.
class GallerySection extends StatelessWidget {
  const GallerySection({
    required this.title,
    required this.children,
    this.description,
    this.padding = const EdgeInsets.fromLTRB(24, 0, 24, 32),
    super.key,
  });

  final String title;
  final String? description;
  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: padding == EdgeInsets.zero
                ? EdgeInsets.symmetric(horizontal: 24)
                : EdgeInsets.zero,
            child: Text(
              title,
              style: theme.typeScale.titleLarge.copyWith(
                color: theme.colorScheme.onSurface,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          if (description != null) ...<Widget>[
            const SizedBox(height: 4),
            Text(
              description!,
              style: theme.typeScale.bodyMedium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                decoration: TextDecoration.none,
              ),
            ),
          ],
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// Lazy scroll surface for gallery demo pages.
///
/// Builds one section at a time so rapid scrolling does not layout every demo
/// block on every frame. Sections stay alive once built so interactive demos
/// (dropdowns, sliders, pickers) keep their state when scrolled off screen.
class GalleryPageScrollView extends StatelessWidget {
  const GalleryPageScrollView({required this.sections, super.key});

  final List<Widget> sections;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      addRepaintBoundaries: false,
      itemCount: sections.length,
      itemBuilder: (BuildContext context, int index) {
        return _KeepAliveGallerySection(
          child: RepaintBoundary(child: sections[index]),
        );
      },
    );
  }
}

class _KeepAliveGallerySection extends StatefulWidget {
  const _KeepAliveGallerySection({required this.child});

  final Widget child;

  @override
  State<_KeepAliveGallerySection> createState() =>
      _KeepAliveGallerySectionState();
}

class _KeepAliveGallerySectionState extends State<_KeepAliveGallerySection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

/// A labelled sub-group inside a [GallerySection], with a wrapping layout.
class DemoRow extends StatelessWidget {
  const DemoRow({required this.label, required this.children, super.key});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: theme.typeScale.labelLarge.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: children,
          ),
        ],
      ),
    );
  }
}
