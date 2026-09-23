import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:klin_dart/src/best_practices/avoid_hardcoded_strings_in_widgets.dart';
import 'package:klin_dart/src/best_practices/avoid_string_literals_in_logic.dart';
import 'package:klin_dart/src/cognitive_complexity/cognitive_complexity_rule.dart';
import 'package:klin_dart/src/best_practices/function_length_rule.dart';
import 'package:klin_dart/src/best_practices/class_length_rule.dart';
import 'package:klin_dart/src/best_practices/file_length_rule.dart';

PluginBase createPlugin() => _KlinLinter();

class _KlinLinter extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) {
    final classConfig = configs.rules['class_length']?.json;
    final fileConfig = configs.rules['file_length']?.json;
    final functionConfig = configs.rules['function_length']?.json;
    final complexityConfig = configs.rules['cognitive_complexity']?.json;

    return [
      AvoidHardcodedStringsInWidgetsRule(),
      AvoidStringLiteralsInLogicRule(),
      CognitiveComplexityRule(config: complexityConfig),
      FunctionLengthRule(config: functionConfig),
      ClassLengthRule(config: classConfig),
      FileLengthRule(config: fileConfig),
    ];
  }
}
