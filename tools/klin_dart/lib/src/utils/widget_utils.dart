import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:klin_dart/src/utils/constants.dart';

/// Extensions for widget-related checks on ClassElement2
extension WidgetClassChecks on ClassElement2 {
  /// Checks if this class is a widget
  bool isWidget() {
    // Direct check for core Flutter widgets
    if (isFlutterWidgetByName()) {
      return true;
    }

    // Check if it has a build method that returns a widget type
    if (hasBuildMethod()) {
      return true;
    }

    // Check if it has a createState method (StatefulWidget)
    if (hasCreateStateMethod()) {
      return true;
    }

    // Check superclass
    final supertype = this.supertype;
    if (supertype != null && supertype.element3 is ClassElement2) {
      return (supertype.element3 as ClassElement2).isWidget();
    }

    return false;
  }

  /// Checks if this class is a Flutter widget by name
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

    if (widgetBaseClasses.contains(name3)) {
      final libraryPath = library2.uri.toString();
      return libraryPath.contains(Constants.flutter);
    }

    return false;
  }

  /// Checks if this class has a build method that takes a BuildContext
  bool hasBuildMethod() {
    return methods2.any((method) =>
        method.name3 == Constants.build &&
        method.formalParameters[0].type
            .getDisplayString()
            .contains(Constants.buildContext));
  }

  /// Checks if this class has a createState method that returns a State with a build method
  bool hasCreateStateMethod() {
    return methods2.any(
      (method) =>
          method.name3 == Constants.createState &&
          method.returnType.element3 is ClassElement2 &&
          (method.returnType.element3 as ClassElement2).hasBuildMethod(),
    );
  }
}

/// Extensions for widget-related checks on DartType
extension WidgetTypeChecks on DartType {
  /// Checks if this type is a widget type
  bool isWidget() {
    final element = element3;
    if (element is ClassElement2) {
      return element.isWidget();
    }
    return false;
  }
}
