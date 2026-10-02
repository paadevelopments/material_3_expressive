import 'package:material_ui/material_ui.dart';

import '../catalog/m3e_demo_catalog.dart';
import '../catalog/m3e_demo_entry.dart';
import '../catalog/m3e_demo_section.dart';
import 'preview/preview_screen.dart';
import 'section_list_pane.dart';

/// Section catalog; each entry opens its own preview screen.
class SectionHostPage extends StatelessWidget {
  /// Creates a section host.
  const SectionHostPage({required this.section, super.key});

  /// Gallery section for this tab.
  final M3EDemoSection section;

  void _open(BuildContext context, M3EDemoEntry entry) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => PreviewScreen(entry: entry),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionListPane(
      entries: M3EDemoCatalog.forSection(section),
      onSelect: (M3EDemoEntry entry) => _open(context, entry),
    );
  }
}
