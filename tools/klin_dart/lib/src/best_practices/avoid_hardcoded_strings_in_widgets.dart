import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:klin_dart/src/utils/ast_node_extensions.dart';

class AvoidHardcodedStringsInWidgetsRule extends DartLintRule {
  AvoidHardcodedStringsInWidgetsRule() : super(code: _code);

  static const _lintName = 'avoid_hardcoded_strings_in_ui';

  static final _code = LintCode(
    name: _lintName,
    problemMessage:
        'Avoid using hardcoded string literals in UI widgets. This practice makes localization difficult and tightly couples UI to raw text.',
    correctionMessage:
        'Move display text to localization files or constants. This improves maintainability and prepares the app for internationalization.',
    uniqueName: _lintName,
    errorSeverity: error.ErrorSeverity.WARNING,
  );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addStringLiteral((node) {
      final value = node.stringValue;
      if (value == null || value.trim().isEmpty) return;

      // Skip imports and other directives
      if (node.thisOrAncestorOfType<Directive>() != null) return;

      if (node.isInWidgetContext()) {
        reporter.atNode(node, code);
      }
    });
  }
}
