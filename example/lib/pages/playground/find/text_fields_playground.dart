import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_segmented.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Input line modes shown in the playground.
enum _LineMode {
  single,
  multi,
  area;

  int get maxLines => switch (this) {
    _LineMode.single => 1,
    _LineMode.multi || _LineMode.area => 4,
  };

  int? get minLines => this == _LineMode.area ? 4 : null;
}

/// Live playground for [M3ETextField].
class TextFieldsPlayground extends StatefulWidget {
  /// Creates the text fields playground.
  const TextFieldsPlayground({super.key});

  @override
  State<TextFieldsPlayground> createState() => _TextFieldsPlaygroundState();
}

class _TextFieldsPlaygroundState extends State<TextFieldsPlayground> {
  M3ETextFieldVariant _variant = M3ETextFieldVariant.filled;
  _LineMode _lines = _LineMode.single;
  bool _enabled = true;
  bool _readOnly = false;
  bool _required = false;
  bool _obscure = false;
  bool _passwordToggle = false;
  bool _showLeading = true;
  bool _showTrailing = false;
  bool _clearButton = false;
  bool _showError = false;
  bool _errorIcon = true;
  bool _supportingOnFocus = false;
  bool _counter = false;
  double _density = 0;
  String _label = 'Full name';
  String _supporting = 'As it appears on your ID';
  String _error = 'Enter a valid value';
  String _prefix = '';
  String _suffix = '';
  String _placeholder = '';

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _nonEmpty(String value) => value.isEmpty ? null : value;

  String get _sample {
    final buffer = StringBuffer()
      ..writeln('M3ETextField(')
      ..writeln('  label: ${playDartString(_label)},')
      ..writeln('  variant: M3ETextFieldVariant.${_variant.name},');
    void add(bool when, String line) {
      if (when) {
        buffer.writeln('  $line,');
      }
    }

    add(!_showError, 'supportingText: ${playDartString(_supporting)}');
    add(_showError, 'errorText: ${playDartString(_error)}');
    add(!_errorIcon, 'showErrorIcon: false');
    add(!_enabled, 'enabled: false');
    add(_readOnly, 'readOnly: true');
    add(_required, 'isRequired: true');
    add(_obscure, 'obscureText: true');
    add(_passwordToggle, 'showPasswordToggle: true');
    add(_showLeading, 'leading: const Icon(M3EIcons.search)');
    add(_showTrailing, 'trailing: const Icon(M3EIcons.mic)');
    add(_clearButton, 'showClearButton: true');
    add(_supportingOnFocus, 'supportingTextOnFocusOnly: true');
    add(_counter, 'maxLength: 20');
    add(_prefix.isNotEmpty, 'prefixText: ${playDartString(_prefix)}');
    add(_suffix.isNotEmpty, 'suffixText: ${playDartString(_suffix)}');
    add(
      _placeholder.isNotEmpty,
      'placeholder: ${playDartString(_placeholder)}',
    );
    add(_lines != _LineMode.single, 'maxLines: ${_lines.maxLines}');
    add(_lines == _LineMode.area, 'minLines: ${_lines.minLines}');
    add(_density != 0, 'density: ${_density.round()}');
    buffer.write(');');
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(label: 'Text field', child: _buildField()),
      ],
      snippets: <PlaySnippet>[
        PlaySnippet(label: 'Text field', code: '$kPlaySnippetImport\n$_sample'),
      ],
      controls: <Widget>[
        PlayControlPanel(title: 'Appearance', children: _appearanceControls()),
        PlayControlPanel(title: 'State', children: _stateControls()),
        PlayControlPanel(title: 'Icons', children: _iconControls()),
        PlayControlPanel(title: 'Content', children: _contentControls()),
      ],
    );
  }

  Widget _buildField() {
    final bool obscure = _obscure && _lines == _LineMode.single;
    return M3ETextField(
      controller: _controller,
      label: _label,
      supportingText: _showError ? null : _supporting,
      errorText: _showError ? _error : null,
      showErrorIcon: _errorIcon,
      variant: _variant,
      enabled: _enabled,
      readOnly: _readOnly,
      isRequired: _required,
      obscureText: obscure,
      showPasswordToggle: _passwordToggle && _lines == _LineMode.single,
      leading: _showLeading ? const Icon(M3EIcons.search) : null,
      trailing: _showTrailing ? const Icon(M3EIcons.mic) : null,
      showClearButton: _clearButton,
      supportingTextOnFocusOnly: _supportingOnFocus,
      maxLength: _counter ? 20 : null,
      prefixText: _nonEmpty(_prefix),
      suffixText: _nonEmpty(_suffix),
      placeholder: _nonEmpty(_placeholder),
      maxLines: obscure ? 1 : _lines.maxLines,
      minLines: obscure ? null : _lines.minLines,
      density: _density.round(),
    );
  }

  List<Widget> _appearanceControls() {
    return <Widget>[
      PlayEnumSegmented<M3ETextFieldVariant>(
        label: 'Variant',
        value: _variant,
        values: M3ETextFieldVariant.values,
        labelOf: (M3ETextFieldVariant v) => v.name,
        onChanged: (M3ETextFieldVariant v) => setState(() => _variant = v),
      ),
      PlayEnumSegmented<_LineMode>(
        label: 'Input lines',
        value: _lines,
        values: _LineMode.values,
        labelOf: (_LineMode v) => switch (v) {
          _LineMode.single => 'single',
          _LineMode.multi => 'multi-line',
          _LineMode.area => 'text area',
        },
        onChanged: (_LineMode v) => setState(() => _lines = v),
      ),
      PlaySlider(
        label: 'Density',
        value: _density,
        min: -3,
        max: 0,
        divisions: 3,
        onChanged: (double v) => setState(() => _density = v),
      ),
    ];
  }

  List<Widget> _stateControls() {
    return <Widget>[
      PlaySwitch(
        label: 'Enabled',
        value: _enabled,
        onChanged: (bool v) => setState(() => _enabled = v),
      ),
      PlaySwitch(
        label: 'Read only',
        value: _readOnly,
        onChanged: (bool v) => setState(() => _readOnly = v),
      ),
      PlaySwitch(
        label: 'Required',
        value: _required,
        onChanged: (bool v) => setState(() => _required = v),
      ),
      PlaySwitch(
        label: 'Error',
        value: _showError,
        onChanged: (bool v) => setState(() => _showError = v),
      ),
      PlaySwitch(
        label: 'Character counter (20)',
        value: _counter,
        onChanged: (bool v) => setState(() => _counter = v),
      ),
      PlaySwitch(
        label: 'Supporting text on focus only',
        value: _supportingOnFocus,
        onChanged: (bool v) => setState(() => _supportingOnFocus = v),
      ),
    ];
  }

  List<Widget> _iconControls() {
    return <Widget>[
      PlaySwitch(
        label: 'Leading icon',
        value: _showLeading,
        onChanged: (bool v) => setState(() => _showLeading = v),
      ),
      PlaySwitch(
        label: 'Trailing icon',
        value: _showTrailing,
        onChanged: (bool v) => setState(() => _showTrailing = v),
      ),
      PlaySwitch(
        label: 'Clear button',
        value: _clearButton,
        onChanged: (bool v) => setState(() => _clearButton = v),
      ),
      PlaySwitch(
        label: 'Error icon',
        value: _errorIcon,
        onChanged: (bool v) => setState(() => _errorIcon = v),
      ),
      PlaySwitch(
        label: 'Obscure text',
        value: _obscure,
        onChanged: (bool v) => setState(() => _obscure = v),
      ),
      PlaySwitch(
        label: 'Password toggle',
        value: _passwordToggle,
        onChanged: (bool v) => setState(() => _passwordToggle = v),
      ),
    ];
  }

  List<Widget> _contentControls() {
    return <Widget>[
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
      PlayTextField(
        label: 'Prefix',
        value: _prefix,
        onChanged: (String v) => setState(() => _prefix = v),
      ),
      PlayTextField(
        label: 'Suffix',
        value: _suffix,
        onChanged: (String v) => setState(() => _suffix = v),
      ),
      PlayTextField(
        label: 'Placeholder',
        value: _placeholder,
        onChanged: (String v) => setState(() => _placeholder = v),
      ),
    ];
  }
}
