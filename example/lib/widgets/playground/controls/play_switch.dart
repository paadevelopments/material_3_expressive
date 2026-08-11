import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Boolean control row using [M3ESwitch].
class PlaySwitch extends StatelessWidget {
  /// Creates a switch control.
  const PlaySwitch({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Row label.
  final String label;

  /// Switch value.
  final bool value;

  /// Change callback.
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: theme.typeScale.bodyLarge)),
          M3ESwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
