import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';
import 'enums/m3e_top_app_bar_variant.dart';

export 'enums/m3e_top_app_bar_variant.dart';

/// A Material 3 Expressive top app bar.
///
/// Renders the small, centre-aligned, medium or large layouts. The medium and
/// large variants place the title on a second line beneath the action row.
class M3ETopAppBar extends StatelessWidget {
  const M3ETopAppBar({
    required this.title,
    this.leading,
    this.actions = const <Widget>[],
    this.variant = M3ETopAppBarVariant.small,
    super.key,
  });

  final String title;
  final Widget? leading;
  final List<Widget> actions;
  final M3ETopAppBarVariant variant;

  bool get _isTwoLine =>
      variant == M3ETopAppBarVariant.medium ||
      variant == M3ETopAppBarVariant.large;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    return ColoredBox(
      color: scheme.surface,
      child: SafeArea(
        bottom: false,
        child: _isTwoLine ? _buildTwoLine(theme) : _buildSingleLine(theme),
      ),
    );
  }

  Widget _buildSingleLine(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    final centered = variant == M3ETopAppBarVariant.center;
    return SizedBox(
      height: 64,
      child: Row(
        children: <Widget>[
          _buildLeading(scheme),
          Expanded(
            child: Text(
              title,
              textAlign: centered ? TextAlign.center : TextAlign.start,
              style:
                  theme.typeScale.titleLarge.copyWith(color: scheme.onSurface),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          _buildActions(scheme),
        ],
      ),
    );
  }

  Widget _buildTwoLine(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    final double height =
        variant == M3ETopAppBarVariant.large ? 152 : 112;
    final TextStyle titleStyle = variant == M3ETopAppBarVariant.large
        ? theme.typeScale.headlineMedium
        : theme.typeScale.headlineSmall;
    return SizedBox(
      height: height,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 64,
            child: Row(
              children: <Widget>[
                _buildLeading(scheme),
                const Spacer(),
                _buildActions(scheme),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  title,
                  style: titleStyle.copyWith(color: scheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeading(M3EColorScheme scheme) {
    if (leading == null) {
      return const SizedBox(width: 16);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconTheme.merge(
        data: IconThemeData(color: scheme.onSurface, size: 24),
        child: leading!,
      ),
    );
  }

  Widget _buildActions(M3EColorScheme scheme) {
    if (actions.isEmpty) {
      return const SizedBox(width: 16);
    }
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: IconTheme.merge(
        data: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
        child: Row(mainAxisSize: MainAxisSize.min, children: actions),
      ),
    );
  }
}

/// A Material 3 Expressive bottom app bar.
///
/// Hosts a row of primary actions with an optional trailing floating action
/// button, anchored to the bottom of the screen.
class M3EBottomAppBar extends StatelessWidget {
  const M3EBottomAppBar({
    this.actions = const <Widget>[],
    this.floatingActionButton,
    super.key,
  });

  final List<Widget> actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final scheme = M3ETheme.of(context).colorScheme;
    return Container(
      height: 80,
      color: scheme.surfaceContainer,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            IconTheme.merge(
              data: IconThemeData(color: scheme.onSurfaceVariant, size: 24),
              child: Row(mainAxisSize: MainAxisSize.min, children: actions),
            ),
            const Spacer(),
            ?floatingActionButton,
          ],
        ),
      ),
    );
  }
}
