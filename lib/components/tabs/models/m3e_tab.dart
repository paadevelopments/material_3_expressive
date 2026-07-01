import 'package:flutter/widgets.dart';

/// A single tab within an `M3ETabs` bar.
@immutable
class M3ETab {
  const M3ETab({this.label, this.icon})
      : assert(label != null || icon != null, 'A tab needs a label or icon.');

  final String? label;
  final Widget? icon;
}
