import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:klin_dart/src/utils/constants.dart';
import 'package:klin_dart/src/utils/widget_utils.dart';

/// Widget-context checks for an [AstNode].
extension WidgetContextExtensions on AstNode {
  /// Whether this node sits in a widget constructor or widget argument.
  bool isInWidgetContext() {
    return isInWidgetConstructor() || isInWidgetProperty();
  }

  /// Whether this node is inside a widget instance creation.
  bool isInWidgetConstructor() {
    final creation = thisOrAncestorOfType<InstanceCreationExpression>();
    if (creation == null) {
      return false;
    }

    final constructorElement = creation.constructorName.element;
    if (constructorElement == null) {
      return false;
    }

    final classElement = constructorElement.enclosingElement;
    return classElement is ClassElement && classElement.isWidget();
  }

  /// Whether this node is a named argument of a widget.
  bool isInWidgetProperty() {
    final namedExpression = thisOrAncestorOfType<NamedExpression>();
    if (namedExpression == null) {
      return false;
    }

    final parent = namedExpression.parent;
    if (parent is ArgumentList && parent.parent is InstanceCreationExpression) {
      final creation = parent.parent! as InstanceCreationExpression;
      final classElement = creation.constructorName.element?.enclosingElement;
      return classElement is ClassElement && classElement.isWidget();
    }

    if (parent is ArgumentList && parent.parent is MethodInvocation) {
      final invocation = parent.parent! as MethodInvocation;
      final targetType = invocation.target?.staticType;
      return targetType != null && targetType.isWidget();
    }

    return false;
  }

  /// Whether this node is a widget `build` method.
  bool isWidgetBuildMethod() {
    final method = thisOrAncestorOfType<MethodDeclaration>();
    if (method == null) {
      return false;
    }

    final returnType = method.returnType;
    return method.name.toString() == Constants.build &&
        returnType?.toSource() == Constants.widget;
  }

  /// Whether this node is a state class whose name looks like a screen.
  bool isStatefulWidgetClass() {
    final classDeclaration = thisOrAncestorOfType<ClassDeclaration>();
    if (classDeclaration == null) {
      return false;
    }

    final className = classDeclaration.name.toString();
    final extendedClass = classDeclaration.extendsClause?.extendsKeyword.next
        ?.toString();

    return (extendedClass == Constants.consumerState ||
            extendedClass == Constants.state) &&
        (className.contains(Constants.screen) ||
            className.contains(Constants.state));
  }
}
