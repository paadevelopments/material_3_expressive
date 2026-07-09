import 'package:flutter/widgets.dart';

/// Marks descendants as content inside a card-backed list surface.
///
/// List items read this scope to skip their own card wrapper when the parent
/// list already owns the outermost card surface.
class M3EListItemScope extends InheritedWidget {
  const M3EListItemScope({required super.child, super.key});

  static bool isEmbedded(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<M3EListItemScope>() != null;

  @override
  bool updateShouldNotify(M3EListItemScope oldWidget) => false;
}
