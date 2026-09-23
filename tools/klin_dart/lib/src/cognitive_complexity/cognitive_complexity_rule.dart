import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:klin_dart/src/cognitive_complexity/cognitive_complexity_visitor.dart';

class CognitiveComplexityRule extends DartLintRule {
  static const _lintName = 'cognitive_complexity';

  static const _defaultMediumThreshold = 10;
  static const _defaultHighThreshold = 15;

  /// Complexity score above which a warning is reported.
  final int mediumThreshold;

  /// Complexity score at or above which an error is reported.
  final int highThreshold;

  CognitiveComplexityRule({Map<String, Object?>? config})
      : mediumThreshold = int.tryParse(config?['medium_threshold']?.toString() ?? '') ?? _defaultMediumThreshold,
        highThreshold = int.tryParse(config?['high_threshold']?.toString() ?? '') ?? _defaultHighThreshold,
        super(
          code: LintCode(
            name: _lintName,
            problemMessage: "",
          ),
        );

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.registry.addCompilationUnit((node) {
      final visitor = MethodVisitor();
      node.visitChildren(visitor);

      final methodMetrics = visitor.analyzeCollectedMethods();

      for (final entry in methodMetrics.entries) {
        final metrics = entry.value;
        final complexity = metrics.cognitiveComplexity;

        if (complexity > mediumThreshold) {
          reporter.atToken(
            metrics.token,
            LintCode(
              name: _lintName,
              problemMessage: metrics.riskAssessment,
              uniqueName: '${_lintName}_${metrics.name}',
              errorSeverity: complexity >= highThreshold
                  ? error.ErrorSeverity.ERROR
                  : error.ErrorSeverity.WARNING,
            ),
          );
        }
      }
    });
  }
}
