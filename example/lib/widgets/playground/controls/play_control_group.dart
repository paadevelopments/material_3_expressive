import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import 'play_switch_list.dart';

/// Titled group of playground controls.
///
/// Consecutive [PlaySwitchItem]s collapse into one [PlaySwitchList]; any
/// other control between them starts a new list.
class PlayControlGroup extends StatelessWidget {
  /// Creates a control group.
  const PlayControlGroup({
    required this.title,
    required this.children,
    super.key,
  });

  /// Group title.
  final String title;

  /// Controls, top to bottom.
  final List<Widget> children;

  /// Collapses runs of [PlaySwitchItem] in [controls] into [PlaySwitchList]s.
  static List<Widget> group(List<Widget> controls) {
    final List<Widget> out = <Widget>[];
    List<PlaySwitchItem> run = <PlaySwitchItem>[];
    void flush() {
      if (run.isNotEmpty) {
        out.add(PlaySwitchList(items: run));
        run = <PlaySwitchItem>[];
      }
    }

    for (final Widget control in controls) {
      if (control is PlaySwitchItem) {
        run.add(control);
        continue;
      }
      flush();
      out.add(control);
    }
    flush();
    return out;
  }

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox.shrink();
    }
    final M3EThemeData theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              title,
              style: theme.typeScale.titleSmall.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          ...group(children),
        ],
      ),
    );
  }
}
