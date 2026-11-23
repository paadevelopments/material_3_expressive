// Generates the LLM-friendly docs served from GitHub Pages:
//
//   docs/llms.txt       short index: install, theme setup, one line per component
//   docs/llms-full.txt  install, quick start, theming, every component section,
//                       and the Flutter -> M3E migration table
//
// Both files are built from README.md and tools/llms/migration.md, so edit
// those and rerun this script instead of editing the outputs by hand:
//
//   .fvm/flutter_sdk/bin/dart run tools/llms/generate_llms.dart

import 'dart:io';

const String _repoUrl =
    'https://github.com/paadevelopments/material_3_expressive';
const String _blobUrl = '$_repoUrl/blob/main';
const String _siteUrl =
    'https://paadevelopments.github.io/material_3_expressive';
const String _generatedNote =
    'Generated from README.md by tools/llms/generate_llms.dart. '
    'Do not edit by hand.';

void main() {
  final root = Directory.fromUri(Platform.script.resolve('../../'));
  final String readme = File('${root.path}README.md').readAsStringSync();
  final String migration = File('${root.path}tools/llms/migration.md')
      .readAsStringSync()
      .trim();
  final String version = _readVersion(
    File('${root.path}pubspec.yaml').readAsStringSync(),
  );

  final List<_Section> h2 = _split(readme.split('\n'), '## ');
  final String intro = _paragraphs(h2.first.body).first;
  final String installation = _cleanBody(_find(h2, 'Installation').body);
  final String quickStart = _cleanBody(_find(h2, 'Quick start').body);
  final String theming = _cleanBody(_find(h2, 'Theming').body);
  final List<String> componentsBody = _find(h2, 'Components').body;
  final List<_Section> categories = _split(
    componentsBody,
    '### ',
  ).skip(1).toList();

  final summary =
      'Flutter UI library (v$version) implementing the Material 3 Expressive '
      'component set as direct `M3E*` widgets from one import: '
      '`package:material_3_expressive/material_3_expressive.dart`.';

  File('${root.path}docs/llms.txt')
      .writeAsStringSync(_buildIndex(summary, intro, categories));
  File('${root.path}docs/llms-full.txt').writeAsStringSync(
    _buildFull(
      summary: summary,
      intro: intro,
      installation: installation,
      quickStart: quickStart,
      theming: theming,
      categories: categories,
      migration: migration,
    ),
  );

  final int componentCount = categories.fold<int>(
    0,
    (int sum, _Section c) => sum + _split(c.body, '#### ').skip(1).length,
  );
  stdout.writeln(
    'Wrote docs/llms.txt and docs/llms-full.txt '
    '($componentCount component sections, v$version).',
  );
}

String _buildIndex(String summary, String intro, List<_Section> categories) {
  final out = StringBuffer()
    ..writeln('# Material 3 Expressive')
    ..writeln()
    ..writeln('> $summary')
    ..writeln()
    ..writeln(_unwrap(_cleanText(intro)))
    ..writeln()
    ..writeln('Install: `flutter pub add material_3_expressive`.')
    ..writeln()
    ..writeln(
      'Setup: wrap the app in `M3EMaterialApp(data: '
      'M3EThemeData.light(seedColor: ...), home: ...)`, or wrap a subtree in '
      '`M3ETheme(data: ..., child: ...)`. Read tokens with '
      '`M3ETheme.of(context)`. Each component is customized through its '
      '`M3E*Theme` field on `M3EThemeData`.',
    )
    ..writeln()
    ..writeln('## Docs')
    ..writeln()
    ..writeln(
      '- [Full reference]($_siteUrl/llms-full.txt): install, theming, every '
      'component with a snippet, and a Flutter to M3E migration table',
    )
    ..writeln('- [README]($_blobUrl/README.md): the same docs on GitHub')
    ..writeln('- [Live demo]($_siteUrl/): gallery app built from `example/`')
    ..writeln(
      '- [pub.dev](https://pub.dev/packages/material_3_expressive): package '
      'page and API reference',
    );

  for (final category in categories) {
    final List<_Section> components = _split(
      category.body,
      '#### ',
    ).skip(1).toList();
    if (components.isEmpty) {
      continue;
    }
    out
      ..writeln()
      ..writeln('## ${category.title}')
      ..writeln();
    for (final component in components) {
      final List<String> paragraphs = _paragraphs(component.body);
      final description = paragraphs.isEmpty
          ? ''
          : ': ${_firstSentence(_unwrap(_cleanText(paragraphs.first)))}';
      out.writeln(
        '- [${component.title}]($_blobUrl/README.md#${_slug(component.title)})'
        '$description',
      );
    }
  }

  out
    ..writeln()
    ..writeln('## Optional')
    ..writeln()
    ..writeln(
      '- [Changelog]($_blobUrl/CHANGELOG.md): recent changes and migrations',
    )
    ..writeln()
    ..writeln(_generatedNote);
  return out.toString();
}

String _buildFull({
  required String summary,
  required String intro,
  required String installation,
  required String quickStart,
  required String theming,
  required List<_Section> categories,
  required String migration,
}) {
  final out = StringBuffer()
    ..writeln('# Material 3 Expressive')
    ..writeln()
    ..writeln('> $summary')
    ..writeln()
    ..writeln(_cleanText(intro))
    ..writeln()
    ..writeln('## Installation')
    ..writeln()
    ..writeln(installation)
    ..writeln()
    ..writeln('## Quick start')
    ..writeln()
    ..writeln(quickStart)
    ..writeln()
    ..writeln('## Theming')
    ..writeln()
    ..writeln(theming)
    ..writeln()
    ..writeln('## Components')
    ..writeln()
    ..writeln(
      'Every component is a widget you construct directly. Snippets use the '
      'single import above. Stateful controls show `// in State` where a '
      '`setState` wrapper is needed. Each component is customized through its '
      '`M3E*Theme`.',
    );

  for (final category in categories) {
    out
      ..writeln()
      ..writeln('### ${category.title}')
      ..writeln()
      ..writeln(_cleanBody(category.body));
  }

  out
    ..writeln()
    ..writeln(migration)
    ..writeln()
    ..writeln(_generatedNote);
  return out.toString();
}

class _Section {
  _Section(this.title, this.body);

  final String title;
  final List<String> body;
}

/// Splits [lines] on headings starting with [prefix], outside code fences.
/// The first section holds the lines before the first heading.
List<_Section> _split(List<String> lines, String prefix) {
  final sections = <_Section>[_Section('', <String>[])];
  var inFence = false;
  for (final line in lines) {
    if (line.startsWith('```')) {
      inFence = !inFence;
    }
    if (!inFence && line.startsWith(prefix)) {
      sections.add(_Section(line.substring(prefix.length).trim(), <String>[]));
    } else {
      sections.last.body.add(line);
    }
  }
  return sections;
}

_Section _find(List<_Section> sections, String title) => sections.firstWhere(
  (_Section s) => s.title == title,
  orElse: () => throw StateError('README.md has no "## $title" section.'),
);

/// Prose paragraphs of [lines], skipping code, tables, lists, quotes and
/// HTML comments.
List<String> _paragraphs(List<String> lines) {
  final paragraphs = <String>[];
  final current = <String>[];
  var inFence = false;
  void flush() {
    if (current.isNotEmpty) {
      paragraphs.add(current.join('\n'));
    }
    current.clear();
  }

  for (final line in lines) {
    if (line.startsWith('```')) {
      inFence = !inFence;
      flush();
      continue;
    }
    final String t = line.trim();
    final bool prose =
        !inFence &&
        t.isNotEmpty &&
        !t.startsWith('#') &&
        !t.startsWith('|') &&
        !t.startsWith('- ') &&
        !t.startsWith('>') &&
        !t.startsWith('<!--') &&
        t != '---';
    if (prose) {
      current.add(line);
    } else {
      flush();
    }
  }
  flush();
  return paragraphs;
}

/// Section body cleaned for the full reference: no rules, lint comments or
/// anchor-only lists, relative links made absolute, blank runs collapsed.
String _cleanBody(List<String> lines) {
  final kept = <String>[];
  var inFence = false;
  for (final line in lines) {
    if (line.startsWith('```')) {
      inFence = !inFence;
    }
    if (inFence) {
      kept.add(line);
    } else if (!_isDropped(line.trim())) {
      kept.add(_cleanText(line));
    }
  }
  return kept.join('\n').replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();
}

/// Horizontal rules, HTML comments and anchor-only list items (the README's
/// in-page table of contents) have no use outside the README.
bool _isDropped(String trimmed) =>
    trimmed == '---' ||
    trimmed.startsWith('<!--') ||
    RegExp(r'^- \[[^\]]+\]\(#[^)]*\)$').hasMatch(trimmed);

/// Makes relative links absolute and drops in-page anchor links.
String _cleanText(String text) => text
    .replaceAllMapped(RegExp(r'\[([^\]]+)\]\(#[^)]*\)'), (Match m) => m[1]!)
    .replaceAllMapped(
      RegExp(r'\]\((?!https?://|mailto:)([^)]+)\)'),
      (Match m) => ']($_blobUrl/${m[1]})',
    );

String _unwrap(String text) => text.replaceAll(RegExp(r'\s*\n\s*'), ' ').trim();

String _firstSentence(String text) {
  final String plain = text.replaceAll('**', '');
  final Match? end = RegExp(r'\.(\s|$)').firstMatch(plain);
  return end == null ? plain : plain.substring(0, end.start + 1);
}

/// GitHub's heading anchor: lowercase, punctuation dropped, spaces to dashes.
String _slug(String heading) => heading
    .toLowerCase()
    .replaceAll(RegExp('[^a-z0-9 _-]'), '')
    .replaceAll(' ', '-');

String _readVersion(String pubspec) {
  final Match? match = RegExp(
    r'^version:\s*(\S+)',
    multiLine: true,
  ).firstMatch(pubspec);
  if (match == null) {
    throw StateError('pubspec.yaml has no version.');
  }
  return match[1]!;
}
