import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:klin_dart/src/utils/constants.dart';

/// Widget checks for a [ClassElement].
extension WidgetClassChecks on ClassElement {
  /// Whether this class behaves as a Flutter widget.
  bool isWidget() {
    if (isFlutterWidgetByName()) {
      return true;
    }
    if (hasBuildMethod()) {
      return true;
    }
    if (hasCreateStateMethod()) {
      return true;
    }

    final superElement = supertype?.element;
    if (superElement is ClassElement) {
      return superElement.isWidget();
    }
    return false;
  }

  /// Whether the class name is a known Flutter widget base type.
  bool isFlutterWidgetByName() {
    final widgetBaseClasses = [
      'StatelessWidget',
      'StatefulWidget',
      'Widget',
      'PreferredSizeWidget',
      'RenderObjectWidget',
      'Text',
      'Container',
      'Row',
      'Column',
      'ListView',
      'GridView',
      'Stack',
      'ConsumerWidget',
      'ConsumerStatefulWidget',
    ];

    if (widgetBaseClasses.contains(name)) {
      final libraryPath = library.uri.toString();
      return libraryPath.contains(Constants.flutter);
    }
    return false;
  }

  /// Whether this class declares a `build` method that takes a `BuildContext`.
  bool hasBuildMethod() {
    return methods.any((method) {
      final parameters = method.formalParameters;
      if (parameters.isEmpty || method.name != Constants.build) {
        return false;
      }
      return parameters.first.type.getDisplayString().contains(
        Constants.buildContext,
      );
    });
  }

  /// Whether `createState` returns a state class that has a `build` method.
  bool hasCreateStateMethod() {
    return methods.any((method) {
      final returnElement = method.returnType.element;
      return method.name == Constants.createState &&
          returnElement is ClassElement &&
          returnElement.hasBuildMethod();
    });
  }
}

/// Widget checks for a [DartType].
extension WidgetTypeChecks on DartType {
  /// Whether this type is a widget class.
  bool isWidget() {
    final typeElement = element;
    if (typeElement is ClassElement) {
      return typeElement.isWidget();
    }
    return false;
  }
}
