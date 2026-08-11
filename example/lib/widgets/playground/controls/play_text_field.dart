import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/text_fields/enums/m3e_text_field_variant.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

/// Text control using [M3ETextField] with a stable controller.
class PlayTextField extends StatefulWidget {
  /// Creates a text field control.
  const PlayTextField({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// Field label.
  final String label;

  /// Current text.
  final String value;

  /// Change callback.
  final ValueChanged<String> onChanged;

  @override
  State<PlayTextField> createState() => _PlayTextFieldState();
}

class _PlayTextFieldState extends State<PlayTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value);
  }

  @override
  void didUpdateWidget(PlayTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != _controller.text) {
      _controller.value = TextEditingValue(
        text: widget.value,
        selection: TextSelection.collapsed(offset: widget.value.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: M3ETextField(
        label: widget.label,
        variant: M3ETextFieldVariant.outlined,
        controller: _controller,
        onChanged: widget.onChanged,
      ),
    );
  }
}
