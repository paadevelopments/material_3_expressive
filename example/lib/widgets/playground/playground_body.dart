import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Scrollable playground: previews then controls.
class PlaygroundBody extends StatelessWidget {
  /// Creates a playground body.
  const PlaygroundBody({
    required this.previews,
    required this.controls,
    super.key,
  });

  /// Live variation previews.
  final List<Widget> previews;

  /// Live control widgets.
  final List<Widget> controls;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: <Widget>[
        Text('Preview', style: theme.typeScale.titleMedium),
        const SizedBox(height: 12),
        ...previews,
        const SizedBox(height: 24),
        Text('Controls', style: theme.typeScale.titleMedium),
        const SizedBox(height: 12),
        ...controls,
      ],
    );
  }
}
