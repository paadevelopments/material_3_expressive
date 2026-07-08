// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint

/// A single selectable entry in an [M3ESplitButton] menu.
class M3ESplitButtonItem<T> {
  const M3ESplitButtonItem({
    required this.value,
    required this.child,
    this.enabled = true,
  });

  final T value;
  final Object child;
  final bool enabled;
}
