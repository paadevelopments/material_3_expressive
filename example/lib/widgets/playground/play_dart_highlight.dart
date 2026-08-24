import 'dart:ui' show Brightness, Color, FontStyle, FontWeight;

import 'package:flutter/painting.dart' show TextSpan, TextStyle, InlineSpan;
import 'package:material_3_expressive/material_3_expressive.dart';

/// IDE-like colors for playground Dart snippets.
class PlayDartHighlightStyle {
  /// PlayDartHighlightStyle.
  const PlayDartHighlightStyle({
    required this.editorBackground,
    required this.base,
    required this.keyword,
    required this.typeName,
    required this.function,
    required this.property,
    required this.string,
    required this.comment,
    required this.number,
    required this.literal,
    required this.annotation,
    required this.operatorColor,
    required this.punctuation,
  });

  /// High-contrast light / dark palettes (VS Code–style Dart), not seed-tinted.
  factory PlayDartHighlightStyle.fromScheme(M3EColorScheme scheme) {
    return scheme.brightness == Brightness.dark ? dark : light;
  }

  /// Light theme — dark tokens on a light editor surface.
  static const PlayDartHighlightStyle light = PlayDartHighlightStyle(
    editorBackground: Color(0xFFF6F8FA),
    base: Color(0xFF1F2328),
    keyword: Color(0xFFCF222E),
    typeName: Color(0xFF953800),
    function: Color(0xFF6639BA),
    property: Color(0xFF0550AE),
    string: Color(0xFF0A3069),
    comment: Color(0xFF59636E),
    number: Color(0xFF0550AE),
    literal: Color(0xFF0550AE),
    annotation: Color(0xFF8250DF),
    operatorColor: Color(0xFFCF222E),
    punctuation: Color(0xFF1F2328),
  );

  /// Dark theme — bright tokens on a dark editor surface.
  static const PlayDartHighlightStyle dark = PlayDartHighlightStyle(
    editorBackground: Color(0xFF1E1E1E),
    base: Color(0xFFD4D4D4),
    keyword: Color(0xFF569CD6),
    typeName: Color(0xFF4EC9B0),
    function: Color(0xFFDCDCAA),
    property: Color(0xFF9CDCFE),
    string: Color(0xFFCE9178),
    comment: Color(0xFF6A9955),
    number: Color(0xFFB5CEA8),
    literal: Color(0xFF569CD6),
    annotation: Color(0xFFDCDCAA),
    operatorColor: Color(0xFFD4D4D4),
    punctuation: Color(0xFFD4D4D4),
  );

  /// Snippet card fill (editor chrome).
  final Color editorBackground;

  /// Default identifier / plain text.
  final Color base;

  /// Language keywords (`const`, `import`, …).
  final Color keyword;

  /// Type-like identifiers (PascalCase).
  final Color typeName;

  /// Call sites (`foo(`).
  final Color function;

  /// Member access after `.`.
  final Color property;

  /// String literals.
  final Color string;

  /// Line and block comments.
  final Color comment;

  /// Numeric literals.
  final Color number;

  /// `true` / `false` / `null`.
  final Color literal;

  /// Annotations (`@override`, …).
  final Color annotation;

  /// Operators (`=>`, `==`, `+`, …).
  final Color operatorColor;

  /// Brackets, commas, semicolons.
  final Color punctuation;
}

const Set<String> _dartKeywords = <String>{
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'final',
  'finally',
  'for',
  'Function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'try',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};

const Set<String> _dartLiterals = <String>{'true', 'false', 'null'};

enum _TokenKind {
  keyword,
  typeName,
  function,
  property,
  string,
  comment,
  number,
  literal,
  annotation,
  operatorKind,
  punctuation,
  plain,
}

/// Highlights [source] as Dart-like spans for playground snippets.
TextSpan playHighlightDart(
  String source, {
  required TextStyle baseStyle,
  required PlayDartHighlightStyle colors,
}) {
  if (source.isEmpty) {
    return TextSpan(text: '', style: baseStyle);
  }
  final List<InlineSpan> children = <InlineSpan>[];
  var i = 0;
  while (i < source.length) {
    final int start = i;
    final _TokenKind kind = _consume(source, i, (int next) => i = next);
    final FontWeight? weight = switch (kind) {
      _TokenKind.keyword || _TokenKind.literal => FontWeight.w600,
      _TokenKind.typeName || _TokenKind.function => FontWeight.w500,
      _ => null,
    };
    children.add(
      TextSpan(
        text: source.substring(start, i),
        style: baseStyle.copyWith(
          color: _colorFor(kind, colors),
          fontWeight: weight,
          fontStyle: kind == _TokenKind.comment
              ? FontStyle.italic
              : FontStyle.normal,
        ),
      ),
    );
  }
  return TextSpan(style: baseStyle, children: children);
}

Color _colorFor(_TokenKind kind, PlayDartHighlightStyle colors) {
  return switch (kind) {
    _TokenKind.keyword => colors.keyword,
    _TokenKind.typeName => colors.typeName,
    _TokenKind.function => colors.function,
    _TokenKind.property => colors.property,
    _TokenKind.string => colors.string,
    _TokenKind.comment => colors.comment,
    _TokenKind.number => colors.number,
    _TokenKind.literal => colors.literal,
    _TokenKind.annotation => colors.annotation,
    _TokenKind.operatorKind => colors.operatorColor,
    _TokenKind.punctuation => colors.punctuation,
    _TokenKind.plain => colors.base,
  };
}

_TokenKind _consume(String source, int i, void Function(int next) advance) {
  final int n = source.length;
  final int c = source.codeUnitAt(i);

  // Line comment
  if (c == 0x2F /* / */ && i + 1 < n && source.codeUnitAt(i + 1) == 0x2F) {
    var j = i + 2;
    while (j < n && source.codeUnitAt(j) != 0x0A) {
      j++;
    }
    advance(j);
    return _TokenKind.comment;
  }

  // Block comment
  if (c == 0x2F && i + 1 < n && source.codeUnitAt(i + 1) == 0x2A /* * */) {
    var j = i + 2;
    while (j + 1 < n &&
        !(source.codeUnitAt(j) == 0x2A && source.codeUnitAt(j + 1) == 0x2F)) {
      j++;
    }
    advance(j + 1 < n ? j + 2 : n);
    return _TokenKind.comment;
  }

  // String (raw / normal, single or double; simple escapes)
  if (c == 0x72 /* r */ &&
      i + 1 < n &&
      (source.codeUnitAt(i + 1) == 0x27 || source.codeUnitAt(i + 1) == 0x22)) {
    advance(_scanString(source, i + 1, raw: true));
    return _TokenKind.string;
  }
  if (c == 0x27 /* ' */ || c == 0x22 /* " */) {
    advance(_scanString(source, i, raw: false));
    return _TokenKind.string;
  }

  // Annotation
  if (c == 0x40 /* @ */) {
    var j = i + 1;
    while (j < n && _isIdentPart(source.codeUnitAt(j))) {
      j++;
    }
    advance(j > i + 1 ? j : i + 1);
    return _TokenKind.annotation;
  }

  // Identifier / keyword / type / call / property
  if (_isIdentStart(c)) {
    var j = i + 1;
    while (j < n && _isIdentPart(source.codeUnitAt(j))) {
      j++;
    }
    final String word = source.substring(i, j);
    advance(j);
    if (_dartLiterals.contains(word)) {
      return _TokenKind.literal;
    }
    if (_dartKeywords.contains(word)) {
      return _TokenKind.keyword;
    }
    if (_isTypeName(word)) {
      return _TokenKind.typeName;
    }
    if (_peekNonWs(source, j) == 0x28 /* ( */) {
      return _TokenKind.function;
    }
    if (_precededByDot(source, i)) {
      return _TokenKind.property;
    }
    return _TokenKind.plain;
  }

  // Number
  if (_isDigit(c) ||
      (c == 0x2E /* . */ && i + 1 < n && _isDigit(source.codeUnitAt(i + 1)))) {
    var j = i;
    if (source.codeUnitAt(j) == 0x2E) {
      j++;
    }
    while (j < n &&
        (_isDigit(source.codeUnitAt(j)) || source.codeUnitAt(j) == 0x5F)) {
      j++;
    }
    if (j < n &&
        (source.codeUnitAt(j) == 0x2E ||
            source.codeUnitAt(j) == 0x65 ||
            source.codeUnitAt(j) == 0x45)) {
      j++;
      while (j < n &&
          (_isDigit(source.codeUnitAt(j)) ||
              source.codeUnitAt(j) == 0x5F ||
              source.codeUnitAt(j) == 0x2B ||
              source.codeUnitAt(j) == 0x2D)) {
        j++;
      }
    }
    advance(j);
    return _TokenKind.number;
  }

  // Operators vs punctuation
  if (!_isWhitespace(c)) {
    if (_isOperatorStart(c)) {
      var j = i + 1;
      while (j < n && _isOperatorPart(source.codeUnitAt(j))) {
        j++;
      }
      advance(j);
      return _TokenKind.operatorKind;
    }
    advance(i + 1);
    return _TokenKind.punctuation;
  }

  // Whitespace
  var j = i + 1;
  while (j < n && _isWhitespace(source.codeUnitAt(j))) {
    j++;
  }
  advance(j);
  return _TokenKind.plain;
}

int _scanString(String source, int quoteIndex, {required bool raw}) {
  final int quote = source.codeUnitAt(quoteIndex);
  final int n = source.length;
  if (quoteIndex + 2 < n &&
      source.codeUnitAt(quoteIndex + 1) == quote &&
      source.codeUnitAt(quoteIndex + 2) == quote) {
    var j = quoteIndex + 3;
    while (j + 2 < n) {
      if (source.codeUnitAt(j) == quote &&
          source.codeUnitAt(j + 1) == quote &&
          source.codeUnitAt(j + 2) == quote) {
        return j + 3;
      }
      j++;
    }
    return n;
  }
  var j = quoteIndex + 1;
  while (j < n) {
    final int u = source.codeUnitAt(j);
    if (!raw && u == 0x5C /* \ */ && j + 1 < n) {
      j += 2;
      continue;
    }
    if (u == quote) {
      return j + 1;
    }
    if (u == 0x0A) {
      return j;
    }
    j++;
  }
  return n;
}

bool _precededByDot(String source, int identStart) {
  var k = identStart - 1;
  while (k >= 0 && _isWhitespace(source.codeUnitAt(k))) {
    k--;
  }
  return k >= 0 && source.codeUnitAt(k) == 0x2E /* . */;
}

int? _peekNonWs(String source, int from) {
  var j = from;
  while (j < source.length && _isWhitespace(source.codeUnitAt(j))) {
    j++;
  }
  if (j >= source.length) {
    return null;
  }
  return source.codeUnitAt(j);
}

bool _isTypeName(String word) {
  if (word.isEmpty) {
    return false;
  }
  final int first = word.codeUnitAt(0);
  return first >= 0x41 && first <= 0x5A;
}

bool _isOperatorStart(int c) =>
    c == 0x2B ||
    c == 0x2D ||
    c == 0x2A ||
    c == 0x2F ||
    c == 0x25 ||
    c == 0x3D ||
    c == 0x21 ||
    c == 0x3C ||
    c == 0x3E ||
    c == 0x26 ||
    c == 0x7C ||
    c == 0x5E ||
    c == 0x7E ||
    c == 0x3F;

bool _isOperatorPart(int c) =>
    _isOperatorStart(c) || c == 0x3A /* : for => / :: */;

bool _isIdentStart(int c) =>
    (c >= 0x41 && c <= 0x5A) ||
    (c >= 0x61 && c <= 0x7A) ||
    c == 0x5F ||
    c == 0x24;

bool _isIdentPart(int c) => _isIdentStart(c) || _isDigit(c);

bool _isDigit(int c) => c >= 0x30 && c <= 0x39;

bool _isWhitespace(int c) => c == 0x20 || c == 0x09 || c == 0x0A || c == 0x0D;
