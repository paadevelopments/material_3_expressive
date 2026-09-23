import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' hide LintCode;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:klin_dart/src/utils/ast_node_extensions.dart';

/// Warns when a string literal is used as visible widget text.
class AvoidHardcodedStringsInWidgetsRule extends DartLintRule {
  /// Creates the rule.
  const AvoidHardcodedStringsInWidgetsRule() : super(code: _code);

  static const _lintName = 'avoid_hardcoded_strings_in_ui';

  static const _code = LintCode(
    name: _lintName,
    problemMessage: 'Avoid using hardcoded string literals in UI widgets. This practice makes localization difficult and tightly couples UI to raw text.',
    correctionMessage: 'Move display text to localization files or constants. This improves maintainability and prepares the app for internationalization.',
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
      if (node.thisOrAncestorOfType<Directive>() != null) {
        return;
      }
      if (node.isInWidgetContext()) {
        reporter.atNode(node, code);
      }
    });
  }
}
