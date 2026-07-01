import 'package:flutter/widgets.dart';

import '../../foundations/foundations.dart';

export 'components/m3e_sliver_app_bar_view.dart';
export 'components/m3e_top_app_bar_view.dart';
export 'enums/m3e_app_bar_enums.dart';

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
