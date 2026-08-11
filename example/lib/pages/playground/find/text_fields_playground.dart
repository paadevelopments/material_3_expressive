import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/text_fields/enums/m3e_text_field_variant.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for [M3ETextField].
class TextFieldsPlayground extends StatefulWidget {
  /// Creates the text fields playground.
  const TextFieldsPlayground({super.key});

  @override
  State<TextFieldsPlayground> createState() => _TextFieldsPlaygroundState();
}

class _TextFieldsPlaygroundState extends State<TextFieldsPlayground> {
  M3ETextFieldVariant _variant = M3ETextFieldVariant.filled;
  bool _enabled = true;
  bool _obscure = false;
  bool _showLeading = true;
  bool _showError = false;
  String _label = 'Full name';
  String _supporting = 'As it appears on your ID';
  String _error = 'Enter a valid value';

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: 'Text field',
          child: M3ETextField(
            controller: _controller,
            label: _label,
            supportingText: _showError ? null : _supporting,
            errorText: _showError ? _error : null,
            variant: _variant,
            enabled: _enabled,
            obscureText: _obscure,
            leading: _showLeading ? const Icon(M3EIcons.edit) : null,
          ),
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Appearance',
          children: <Widget>[
            PlayEnumSegmented<M3ETextFieldVariant>(
              label: 'Variant',
              value: _variant,
              values: M3ETextFieldVariant.values,
              labelOf: (M3ETextFieldVariant v) => v.name,
              onChanged: (M3ETextFieldVariant v) {
                setState(() => _variant = v);
              },
            ),
            PlaySwitch(
              label: 'Enabled',
              value: _enabled,
              onChanged: (bool v) => setState(() => _enabled = v),
            ),
            PlaySwitch(
              label: 'Obscure text',
              value: _obscure,
              onChanged: (bool v) => setState(() => _obscure = v),
            ),
            PlaySwitch(
              label: 'Leading icon',
              value: _showLeading,
              onChanged: (bool v) => setState(() => _showLeading = v),
            ),
            PlaySwitch(
              label: 'Error',
              value: _showError,
              onChanged: (bool v) => setState(() => _showError = v),
            ),
          ],
        ),
        PlayControlPanel(
          title: 'Content',
          children: <Widget>[
            PlayTextField(
              label: 'Label',
              value: _label,
              onChanged: (String v) => setState(() => _label = v),
            ),
            PlayTextField(
              label: 'Supporting text',
              value: _supporting,
              onChanged: (String v) => setState(() => _supporting = v),
            ),
            PlayTextField(
              label: 'Error text',
              value: _error,
              onChanged: (String v) => setState(() => _error = v),
            ),
          ],
        ),
      ],
    );
  }
}
