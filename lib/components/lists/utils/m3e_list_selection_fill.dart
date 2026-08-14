import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import '../../selection/m3e_selection.dart';

/// Highlight fill for [index] when an enclosing scope has it selected.
///
/// Lets a list hosted by `M3ESelection` pick up the selection highlight,
/// including any `selectedColor` override, without the host resolving colors.
Color? m3eSelectionFill(BuildContext context, int index) {
  final M3ESelectionScope? scope = M3ESelectionScope.maybeOf(context);
  if (scope == null || !scope.controller.isSelected(index)) {
    return null;
  }
  final M3EThemeData theme = M3ETheme.of(context);
  return theme.selectionTheme.selectedColor(theme.colorScheme);
}
