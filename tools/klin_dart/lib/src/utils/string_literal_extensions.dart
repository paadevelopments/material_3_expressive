import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';

/// Extensions for analyzing string literals in different contexts
extension StringLiteralContextExtensions on StringLiteral {
  /// Checks if this string literal is used in a logic context that would be better served by constants or enums
  bool isInLogicContext() {
    if (isInComparisonExpression() ||
        isInSwitchCase() ||
        isInDomainVariableAssignment() ||
        isInStateMethodArgument() ||
        isInNamedTypeOrStatusParameter()) {
      return true;
    }
    return false;
  }

  /// Checks if this string is part of a binary comparison expression
  bool isInComparisonExpression() {
    final parent = this.parent;
    if (parent is BinaryExpression && _isEqualityOperator(parent.operator)) {
      return _isInsideLogicContext(parent);
    }
    return false;
  }

  /// Checks if this string is part of a switch case
  bool isInSwitchCase() {
    final parent = this.parent;
    if (parent is ConstantPattern &&
        (parent.parent is GuardedPattern &&
                parent.parent?.parent is SwitchPatternCase ||
            parent.parent?.parent is SwitchExpressionCase)) {
      return _isInsideLogicContext(parent);
    }
    return false;
  }

  /// Checks if this string is being assigned to a domain variable
  bool isInDomainVariableAssignment() {
    final parent = this.parent;
    if (parent is AssignmentExpression) {
      final lhs = parent.leftHandSide;
      return _isDomainVariable(lhs);
    }
    return false;
  }

  /// Checks if this string is an argument to a method that should use an enum instead
  bool isInStateMethodArgument() {
    final parent = this.parent;
    if (parent is ArgumentList) {
      final method = parent.thisOrAncestorOfType<MethodInvocation>();
      return method != null && _shouldUseEnumInstead(method);
    }
    return false;
  }

  /// Checks if this string is a named parameter related to type or status
  bool isInNamedTypeOrStatusParameter() {
    final parent = this.parent;
    if (parent is NamedExpression) {
      final paramName = parent.name.label.name.toLowerCase();
      return paramName.contains('type') || paramName.contains('status');
    }
    return false;
  }

  bool _isEqualityOperator(Token token) =>
      token.type == TokenType.EQ_EQ || token.type == TokenType.BANG_EQ;

  bool _isInsideLogicContext(AstNode node) =>
      node.thisOrAncestorMatching((n) =>
          n is IfStatement ||
          n is ConditionalExpression ||
          n is WhileStatement ||
          n is SwitchExpression ||
          n is SwitchStatement) !=
      null;

  bool _isDomainVariable(Expression expression) {
    final name = expression.toString().toLowerCase();
    const domainKeywords = [
      'status',
      'type',
      'role',
      'level',
      'plan',
      'membership',
      'category',
    ];
    return domainKeywords.any((keyword) => name.contains(keyword));
  }

  bool _shouldUseEnumInstead(MethodInvocation method) {
    final name = method.methodName.name.toLowerCase();
    const riskyMethods = [
      'check',
      'update',
      'change',
      'set',
      'compare',
      'is',
    ];
    return riskyMethods.any((r) => name.contains(r));
  }
}
