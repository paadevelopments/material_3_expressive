import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';

/// Complexity numbers collected for one method or function.
class MethodComplexityMetrics {
  /// Declaration name.
  final String name;

  /// `method` or `function`.
  final String type;

  /// Running cognitive-complexity score.
  int cognitiveComplexity = 0;

  /// Deepest nesting seen while scoring.
  int nestingLevel = 0;

  /// Parameter count of the declaration.
  int numberOfParameters = 0;

  /// Source length of the declaration.
  int lineCount = 0;

  /// `Low`, `Medium`, or `High`.
  String complexityCategory = '';

  /// Message reported when the score is above the medium threshold.
  String riskAssessment = '';

  /// Token the diagnostic is anchored to.
  Token token;

  /// Collects a score for [name].
  MethodComplexityMetrics(this.name, this.type, this.token);
}

/// Maps analysis-option strings to severities.
const Map<String, DiagnosticSeverity> errorSeverityMap = {
  'info': DiagnosticSeverity.INFO,
  'warning': DiagnosticSeverity.WARNING,
  'error': DiagnosticSeverity.ERROR,
};

/// Bands used to label a complexity score.
enum ComplexityCategory {
  /// Score at or below the medium threshold.
  low(0),

  /// Score above which a warning is reported.
  medium(10),

  /// Score above which an error is reported.
  high(15);

  const ComplexityCategory(this.value);

  /// Inclusive lower bound of this band.
  final int value;
}
