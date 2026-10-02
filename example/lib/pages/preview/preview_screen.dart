import 'package:flutter/widgets.dart';

import '../../catalog/m3e_demo_entry.dart';
import '../../widgets/playground/preview_scope.dart';

/// Full-screen preview of one catalog entry.
class PreviewScreen extends StatelessWidget {
  /// Creates a preview screen.
  const PreviewScreen({required this.entry, super.key});

  /// Entry to preview.
  final M3EDemoEntry entry;

  @override
  Widget build(BuildContext context) {
    return PreviewScope(
      title: entry.title,
      child: entry.playgroundBuilder(context),
    );
  }
}
