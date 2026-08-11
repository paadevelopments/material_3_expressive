import 'package:flutter/material.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../catalog/m3e_demo_catalog.dart';
import '../catalog/m3e_demo_entry.dart';
import '../catalog/m3e_demo_section.dart';
import 'playground/playground_scaffold.dart';
import 'section_list_pane.dart';

/// Width at or above which list + playground sit side-by-side.
const double kM3EDemoSplitBreakpoint = 900;

/// Adaptive section host: push playgrounds when narrow, split when wide.
class SectionHostPage extends StatefulWidget {
  /// Creates a section host.
  const SectionHostPage({required this.section, super.key});

  /// Gallery section for this tab.
  final M3EDemoSection section;

  @override
  State<SectionHostPage> createState() => _SectionHostPageState();
}

class _SectionHostPageState extends State<SectionHostPage>
    with AutomaticKeepAliveClientMixin {
  String? _selectedId;

  @override
  bool get wantKeepAlive => true;

  List<M3EDemoEntry> get _entries {
    return M3EDemoCatalog.forSection(widget.section);
  }

  M3EDemoEntry? get _selected {
    final List<M3EDemoEntry> entries = _entries;
    if (entries.isEmpty) {
      return null;
    }
    final String? id = _selectedId;
    if (id == null) {
      return entries.first;
    }
    for (final M3EDemoEntry entry in entries) {
      if (entry.id == id) {
        return entry;
      }
    }
    return entries.first;
  }

  void _onSelect(M3EDemoEntry entry, {required bool wide}) {
    if (wide) {
      setState(() => _selectedId = entry.id);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return PlaygroundScaffold(
            title: entry.title,
            body: entry.playgroundBuilder(context),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool wide =
        MediaQuery.sizeOf(context).width >= kM3EDemoSplitBreakpoint;
    final List<M3EDemoEntry> entries = _entries;
    final M3EDemoEntry? selected = _selected;
    final String? selectedId = wide ? (selected?.id ?? _selectedId) : null;

    final Widget list = SectionListPane(
      section: widget.section,
      entries: entries,
      selectedId: selectedId,
      wide: wide,
      onSelect: (M3EDemoEntry entry) => _onSelect(entry, wide: wide),
    );

    if (!wide) {
      return list;
    }

    final M3EThemeData theme = M3ETheme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        SizedBox(width: 320, child: list),
        VerticalDivider(
          width: 1,
          thickness: 1,
          color: theme.colorScheme.outlineVariant,
        ),
        Expanded(
          child: selected == null
              ? const SizedBox.shrink()
              : _WideDetail(
                  key: ValueKey<String>(selected.id),
                  title: selected.title,
                  child: selected.playgroundBuilder(context),
                ),
        ),
      ],
    );
  }
}

class _WideDetail extends StatelessWidget {
  const _WideDetail({required this.title, required this.child, super.key});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Text(title, style: theme.typeScale.titleLarge),
        ),
        Expanded(child: child),
      ],
    );
  }
}
