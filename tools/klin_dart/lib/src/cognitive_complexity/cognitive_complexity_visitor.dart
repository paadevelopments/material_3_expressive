import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:klin_dart/src/cognitive_complexity/config.dart';

/// AST visitor that collects method declarations and calculates complexity.
class MethodVisitor extends RecursiveAstVisitor<void> {
  final Map<String, MethodComplexityMetrics> methodMetrics = {};

  MethodDeclaration? currentMethod;
  FunctionDeclaration? currentFunction;
  int currentNestingLevel = 0;

  MethodVisitor();

  @override
  void visitMethodDeclaration(MethodDeclaration node) {
    final metrics = MethodComplexityMetrics(
      node.name.toString(),
      'method',
      node.name,
    )..numberOfParameters = node.parameters?.parameters.length ?? 0;

    methodMetrics[node.name.toString()] = metrics;
    currentMethod = node;
    currentFunction = null;
    super.visitMethodDeclaration(node);
    currentMethod = null;
    currentNestingLevel = 0;
  }

  @override
  void visitFunctionDeclaration(FunctionDeclaration node) {
    final metrics = MethodComplexityMetrics(
      node.name.toString(),
      'function',
      node.name,
    )..numberOfParameters = node.functionExpression.parameters?.parameters.length ?? 0;

    methodMetrics[node.name.toString()] = metrics;
    currentFunction = node;
    currentMethod = null;
    super.visitFunctionDeclaration(node);
    currentFunction = null;
    currentNestingLevel = 0;
  }

  // ------------------------
  // Control structures
  // ------------------------

  @override
  void visitIfStatement(IfStatement node) {
    _incrementComplexity(1 + currentNestingLevel);
    currentNestingLevel++;
    super.visitIfStatement(node);
    currentNestingLevel--;
  }

  @override
  void visitForStatement(ForStatement node) {
    _incrementComplexity(1 + currentNestingLevel);
    currentNestingLevel++;
    super.visitForStatement(node);
    currentNestingLevel--;
  }

  @override
  void visitWhileStatement(WhileStatement node) {
    _incrementComplexity(1 + currentNestingLevel);
    currentNestingLevel++;
    super.visitWhileStatement(node);
    currentNestingLevel--;
  }

  @override
  void visitSwitchStatement(SwitchStatement node) {
    _incrementComplexity(1 + currentNestingLevel);
    currentNestingLevel++;
    super.visitSwitchStatement(node);
    currentNestingLevel--;
  }

  @override
  void visitTryStatement(TryStatement node) {
    _incrementComplexity(1 + currentNestingLevel);
    currentNestingLevel++;
    super.visitTryStatement(node);
    currentNestingLevel--;
  }

  // ------------------------
  // Boolean Operators
  // ------------------------
  @override
  void visitBinaryExpression(BinaryExpression node) {
    final op = node.operator.type.lexeme;
    // count only once for the outermost logical expression
    if ((op == '&&' || op == '||') && node.parent is! BinaryExpression) {
      _incrementComplexity(1);
    }
    super.visitBinaryExpression(node);
  }

  // ------------------------
  // Nested functions and jumps
  // ------------------------
  @override
  void visitFunctionExpression(FunctionExpression node) {
    if (_isInMethodInvocation(node)) {
      super.visitFunctionExpression(node);
      return;
    }

    if (currentMethod != null || currentFunction != null) {
      _incrementComplexity(2);
      currentNestingLevel++;
      super.visitFunctionExpression(node);
      currentNestingLevel--;
    } else {
      super.visitFunctionExpression(node);
    }
  }

  @override
  void visitBreakStatement(BreakStatement node) {
    _incrementComplexity(1);
    super.visitBreakStatement(node);
  }

  @override
  void visitContinueStatement(ContinueStatement node) {
    _incrementComplexity(1);
    super.visitContinueStatement(node);
  }

  @override
  void visitThrowExpression(ThrowExpression node) {
    _incrementComplexity(1);
    super.visitThrowExpression(node);
  }

  /// Increment complexity for the current method/function
  void _incrementComplexity(int amount) {
    final key = currentMethod?.name.toString() ?? currentFunction?.name.toString();
    if (key != null) {
      final metrics = methodMetrics[key]!;
      metrics.cognitiveComplexity += amount;
      if (currentNestingLevel > metrics.nestingLevel) {
        metrics.nestingLevel = currentNestingLevel;
      }
    }
  }

  /// Determines if a function expression is used as an argument in a method call
  bool _isInMethodInvocation(FunctionExpression node) {
    final parent = node.parent;
    if (parent is ArgumentList && parent.parent is MethodInvocation) {
      return true;
    }
    if (parent is Expression &&
        parent.parent is ArgumentList &&
        parent.parent!.parent is MethodInvocation) {
      return true;
    }
    return parent is FunctionDeclaration;
  }

  /// Process collected methods: categorize and return metrics
  Map<String, MethodComplexityMetrics> analyzeCollectedMethods() {
    methodMetrics.values.forEach(_categorizeComplexity);
    return methodMetrics;
  }

  /// Assigns complexity category and risk message
  void _categorizeComplexity(MethodComplexityMetrics m) {
    if (m.cognitiveComplexity > ComplexityCategory.high.value) {
      m.complexityCategory = 'High';
      m.riskAssessment =
          '❌ High Complexity (Score: ${m.cognitiveComplexity}) - Refactor recommended!';
    } else if (m.cognitiveComplexity > ComplexityCategory.medium.value) {
      m.complexityCategory = 'Medium';
      m.riskAssessment =
          '⚠️ Medium Complexity (Score: ${m.cognitiveComplexity}) - Consider simplifying this ${m.type}';
    } else {
      m.complexityCategory = 'Low';
      m.riskAssessment =
          '✅ Low Complexity (Score: ${m.cognitiveComplexity}) - Everything looks good!';
    }
  }
}
