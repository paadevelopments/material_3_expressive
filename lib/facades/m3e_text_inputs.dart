import 'package:flutter/widgets.dart';

import '../components/search/search.dart';
import '../components/text_fields/enums/m3e_text_field_variant.dart';
import '../components/text_fields/text_fields.dart';

/// Static factories for the Material 3 *Text input* components, such as
/// `M3ETextInputs.textField(...)` and `M3ETextInputs.searchBar(...)`.
class M3ETextInputs {
  const M3ETextInputs._();

  /// Creates a text field. See [M3ETextField].
  static Widget textField({
    TextEditingController? controller,
    FocusNode? focusNode,
    String? label,
    String? supportingText,
    String? errorText,
    Widget? leading,
    Widget? trailing,
    M3ETextFieldVariant variant = M3ETextFieldVariant.filled,
    bool obscureText = false,
    bool enabled = true,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    int maxLines = 1,
    Key? key,
  }) {
    return M3ETextField(
      key: key,
      controller: controller,
      focusNode: focusNode,
      label: label,
      supportingText: supportingText,
      errorText: errorText,
      leading: leading,
      trailing: trailing,
      variant: variant,
      obscureText: obscureText,
      enabled: enabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
    );
  }

  /// Creates a search bar. See [M3ESearchBar].
  static Widget searchBar({
    TextEditingController? controller,
    FocusNode? focusNode,
    String hintText = 'Search',
    Widget? leading,
    List<Widget> trailing = const <Widget>[],
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onTap,
    bool elevated = true,
    Key? key,
  }) {
    return M3ESearchBar(
      key: key,
      controller: controller,
      focusNode: focusNode,
      hintText: hintText,
      leading: leading,
      trailing: trailing,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      elevated: elevated,
    );
  }
}
