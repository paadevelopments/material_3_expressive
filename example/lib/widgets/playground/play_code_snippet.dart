import 'package:flutter/services.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_3_expressive_example/theme/example_theme_settings.dart';
import 'package:material_3_expressive_example/widgets/playground/play_dart_highlight.dart';
import 'package:material_ui/material_ui.dart';

/// Paste-ready Dart sample shown under a playground preview.
class PlaySnippet {
  /// Creates a labeled code sample.
  const PlaySnippet({required this.label, required this.code});

  /// Title above the block.
  final String label;

  /// Dart source, including the package import.
  final String code;
}

/// Shared import line for gallery snippets.
const String kPlaySnippetImport =
    "import 'package:material_3_expressive/material_3_expressive.dart';";

/// Quotes [value] as a Dart single-quoted string literal.
String playDartString(String value) {
  return "'${value.replaceAll(r'\', r'\\').replaceAll("'", r"\'")}'";
}

/// Syntax-highlighted Dart snippet with a copy action (Roboto Mono).
class PlayCodeSnippet extends StatelessWidget {
  /// Creates a code snippet card.
  const PlayCodeSnippet({required this.snippet, super.key});

  /// Sample to show.
  final PlaySnippet snippet;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: snippet.code));
    if (!context.mounted) {
      return;
    }
    M3ESnackbar.show(context, message: 'Copied to clipboard');
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final M3EColorScheme scheme = theme.colorScheme;
    final PlayDartHighlightStyle highlight = PlayDartHighlightStyle.fromScheme(
      scheme,
    );
    final TextStyle codeStyle = theme.typeScale.bodySmall.copyWith(
      fontFamily: ExampleThemeSettings.robotoMono,
      height: 1.45,
      color: highlight.base,
    );
    final TextSpan highlighted = playHighlightDart(
      snippet.code,
      baseStyle: codeStyle,
      colors: highlight,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: highlight.editorBackground,
          borderRadius: BorderRadius.circular(M3EDimensions.radiusLarge),
          border: Border.all(
            color: M3EColorUtils.withOpacity(scheme.outlineVariant, 0.6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(M3EDimensions.space16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      snippet.label,
                      style: theme.typeScale.labelLarge.copyWith(
                        color: highlight.comment,
                      ),
                    ),
                  ),
                  M3EIconButton(
                    icon: const Icon(M3EIcons.content_copy),
                    tooltip: 'Copy',
                    semanticLabel: 'Copy snippet',
                    size: M3EIconButtonSize.sm,
                    onPressed: () => _copy(context),
                  ),
                ],
              ),
              const SizedBox(height: M3EDimensions.space12),
              SelectableText.rich(highlighted),
            ],
          ),
        ),
      ),
    );
  }
}
