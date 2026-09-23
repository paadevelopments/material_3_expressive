import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:klin_dart/src/utils/ast_node_extensions.dart';

/// Warns when a function or method body exceeds the configured line count.
class FunctionLengthRule extends DartLintRule {
  /// The default maximum number of lines allowed in a function.
  static const _defaultMaxLines = 75;
  static const _defaultBuildMethodMaxLines = 150;

  /// The configurable maximum number of lines allowed.
  final int maxLines;

  /// The configurable maximum number of lines allowed for widget build() methods.
  final int buildMethodMaxLines;

  /// Reads `max_lines` and `build_method_max_lines` from [config].
  FunctionLengthRule({Map<String, Object?>? config})
    : maxLines =
          int.tryParse(config?['max_lines']?.toString() ?? '') ??
          _defaultMaxLines,
      buildMethodMaxLines =
          int.tryParse(config?['build_method_max_lines']?.toString() ?? '') ??
          _defaultBuildMethodMaxLines,
      super(
        code: const LintCode(
          name: 'function_length',
          problemMessage:
              'Function is too long ({0} lines). Maximum allowed is {1} lines.',
          correctionMessage: 'Consider refactoring this function into smaller, more focused functions.',
          errorSeverity: DiagnosticSeverity.WARNING,
        ),
      );

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addFunctionDeclaration((node) {
      _checkFunctionLength(
        node,
        node.functionExpression.body,
        reporter: reporter,
        lineInfo: resolver.lineInfo,
      );
    });

    context.registry.addMethodDeclaration((node) {
      _checkFunctionLength(
        node,
        node.body,
        reporter: reporter,
        lineInfo: resolver.lineInfo,
      );
    });

    context.registry.addFunctionExpression((node) {
      _checkFunctionLength(
        node,
        node.body,
        reporter: reporter,
        lineInfo: resolver.lineInfo,
      );
    });
  }

  void _checkFunctionLength(
    AstNode node,
    AstNode body, {
    required DiagnosticReporter reporter,
    required LineInfo lineInfo,
  }) {
    final startLine = lineInfo.getLocation(body.offset).lineNumber;
    final endLine = lineInfo.getLocation(body.end).lineNumber;
    final length = endLine - startLine + 1;

    if (node.isWidgetBuildMethod()) {
      if (length > buildMethodMaxLines) {
        reporter.atNode(
          node,
          code,
          arguments: [length.toString(), buildMethodMaxLines.toString()],
        );
      }
      return;
    }

    if (length > maxLines) {
      reporter.atNode(
        node,
        code,
        arguments: [length.toString(), maxLines.toString()],
      );
    }
  }
}
