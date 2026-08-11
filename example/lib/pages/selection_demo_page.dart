import 'package:flutter/material.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Full-screen Gmail-style selection demo (opened from Containment).
class SelectionDemoPage extends StatefulWidget {
  /// Creates the selection demo page.
  const SelectionDemoPage({super.key});

  @override
  State<SelectionDemoPage> createState() => _SelectionDemoPageState();
}

class _SelectionDemoPageState extends State<SelectionDemoPage> {
  final M3ESelectionController _selection = M3ESelectionController();
  late final M3ESearchController _search;

  static const List<({String from, String subject, String preview})> _mail =
      <({String from, String subject, String preview})>[
        (
          from: 'Google Pay',
          subject: 'Your receipt from Google Pay',
          preview: 'You paid ¢1.00 to …',
        ),
        (
          from: 'Play Developer Console',
          subject: 'Action Required: Complete your account details',
          preview: 'To keep publishing on Google Play…',
        ),
        (
          from: 'Firebase',
          subject: '[Firebase] Your monthly insights',
          preview: 'See how your projects performed…',
        ),
        (
          from: 'Material Design',
          subject: 'New expressive shape tokens',
          preview: 'Explore the latest guidance…',
        ),
        (
          from: 'Flutter',
          subject: 'Stable release notes',
          preview: 'Highlights from the latest release…',
        ),
        (
          from: 'GitHub',
          subject: '[GitHub] Security alert',
          preview: 'A dependency in your repository…',
        ),
        (
          from: 'Figma',
          subject: 'Comments on your file',
          preview: 'Someone left feedback on…',
        ),
        (
          from: 'Notion',
          subject: 'Weekly digest',
          preview: 'Pages you may have missed…',
        ),
      ];

  @override
  void initState() {
    super.initState();
    _search = M3ESearchController();
    _selection.addListener(_onSelection);
  }

  void _onSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _selection.removeListener(_onSelection);
    _selection.dispose();
    _search.dispose();
    super.dispose();
  }

  Color _avatarColor(int index, M3EColorScheme scheme) {
    switch (index % 4) {
      case 0:
        return scheme.primary;
      case 1:
        return scheme.secondary;
      case 2:
        return scheme.tertiary;
      default:
        return scheme.error;
    }
  }

  Iterable<Widget> _suggestions(
    BuildContext context,
    M3ESearchController controller,
  ) {
    return const <Widget>[];
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EColorScheme scheme = theme.colorScheme;

    return PopScope(
      canPop: !_selection.isSelectionMode,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (!didPop) {
          _selection.clear();
        }
      },
      child: M3ESelection(
        controller: _selection,
        appBar: M3ESelectionAppBar(
          idle: M3EAppBar.search(
            searchController: _search,
            suggestionsBuilder: _suggestions,
            barHintText: 'Search in mail',
            leading: M3EIconButton(
              icon: const Icon(M3EIcons.arrow_back),
              onPressed: () => Navigator.of(context).maybePop(),
              tooltip: 'Back',
            ),
          ),
          actions: <Widget>[
            M3EIconButton(
              icon: const Icon(M3EIcons.archive),
              onPressed: () {},
              tooltip: 'Archive',
            ),
            M3EIconButton(
              icon: const Icon(M3EIcons.delete),
              onPressed: () {},
              tooltip: 'Delete',
            ),
            M3EIconButton(
              icon: const Icon(M3EIcons.mail),
              onPressed: () {},
              tooltip: 'Mark unread',
            ),
            M3EIconButton(
              icon: const Icon(M3EIcons.more_vert),
              onPressed: () {},
              tooltip: 'More',
            ),
          ],
        ),
        list: M3ESelectionList(
          itemCount: _mail.length,
          onTap: (int index) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Open ${_mail[index].subject}')),
            );
          },
          leadingBuilder: (BuildContext context, int index) {
            final String letter = _mail[index].from.substring(0, 1);
            return CircleAvatar(
              backgroundColor: _avatarColor(index, scheme),
              foregroundColor: scheme.onPrimary,
              child: Text(letter),
            );
          },
          selectedLeadingBuilder: (BuildContext context, int index) {
            return CircleAvatar(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              child: const Icon(M3EIcons.check, size: 20),
            );
          },
          itemBuilder: (BuildContext context, int index) {
            final item = _mail[index];
            return M3EListItem(
              headline: item.from,
              supportingText: '${item.subject}\n${item.preview}',
            );
          },
        ),
      ),
    );
  }
}
