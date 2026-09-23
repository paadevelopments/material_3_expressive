import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/error.dart';

class MethodComplexityMetrics {
  final String name;
  final String type; // 'method' or 'function'
  int cognitiveComplexity = 0;
  int nestingLevel = 0;
  int numberOfParameters = 0;
  int lineCount = 0;
  String complexityCategory = '';
  String riskAssessment = '';
  Token token;

  MethodComplexityMetrics(this.name, this.type, this.token);
}

const Map<String, ErrorSeverity> errorSeverityMap = {
  'info': ErrorSeverity.INFO,
  'warning': ErrorSeverity.WARNING,
  'error': ErrorSeverity.ERROR,
};

enum ComplexityCategory {
  low(0),
  medium(10),
  high(15);

  const ComplexityCategory(this.value);
  final int value;
}