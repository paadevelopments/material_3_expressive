import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:klin_dart/src/utils/string_literal_extensions.dart';

/// Warns when a string literal is used in a condition or status check.
class AvoidStringLiteralsInLogicRule extends DartLintRule {
  /// Creates the rule.
  const AvoidStringLiteralsInLogicRule() : super(code: _code);

  static const _lintName = 'avoid_string_literals_in_logic';

  static const _code = LintCode(
    name: _lintName,
    problemMessage: 'Avoid using raw string literals in logic or conditions. This can lead to fragile code and primitive obsession.',
    correctionMessage: 'Define constants or use enums instead of hardcoded strings in logic checks or assignments.',
    uniqueName: _lintName,
    errorSeverity: DiagnosticSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    DiagnosticReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addStringLiteral((node) {
      final value = node.stringValue;
      if (value == null || value.trim().isEmpty) {
        return;
      }
      if (node.isInLogicContext()) {
        reporter.atNode(node, code);
      }
    });
  }
}
