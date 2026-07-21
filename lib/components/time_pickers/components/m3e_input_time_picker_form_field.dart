import 'package:flutter/material.dart';

import '../../buttons/enums/m3e_button_enums.dart';
import '../../buttons/m3e_buttons.dart';
import '../../text_fields/m3e_text_fields.dart';
import '../models/m3e_time.dart';
import '../utils/m3e_time_picker_utils.dart';

/// Text fields for entering a time in a picker dialog.
class M3EInputTimePickerFormField extends StatefulWidget {
  const M3EInputTimePickerFormField({
    this.initialTime,
    this.onTimeSubmitted,
    this.onTimeSaved,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.use24HourFormat,
    this.emptyInitialInput = false,
    this.autofocus = false,
    super.key,
  });

  final M3ETime? initialTime;
  final ValueChanged<M3ETime>? onTimeSubmitted;
  final ValueChanged<M3ETime>? onTimeSaved;
  final String? errorInvalidText;
  final String? hourLabelText;
  final String? minuteLabelText;
  final bool? use24HourFormat;
  final bool emptyInitialInput;
  final bool autofocus;

  @override
  State<M3EInputTimePickerFormField> createState() =>
      _M3EInputTimePickerFormFieldState();
}

class _M3EInputTimePickerFormFieldState
    extends State<M3EInputTimePickerFormField> {
  final TextEditingController _hourController = TextEditingController();
  final TextEditingController _minuteController = TextEditingController();
  final FocusNode _hourFocus = FocusNode();
  final FocusNode _minuteFocus = FocusNode();
  bool _isPm = false;

  bool get _use24HourFormat => M3ETimePickerUtils.use24HourFormat(
        context,
        alwaysUse24HourFormat: widget.use24HourFormat,
      );

  @override
  void initState() {
    super.initState();
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _hourFocus.requestFocus();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyInitialTime();
  }

  @override
  void dispose() {
    _hourController.dispose();
    _minuteController.dispose();
    _hourFocus.dispose();
    _minuteFocus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant M3EInputTimePickerFormField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != oldWidget.initialTime ||
        widget.emptyInitialInput != oldWidget.emptyInitialInput) {
      _applyInitialTime();
    }
  }

  void _applyInitialTime() {
    final M3ETime? time = widget.initialTime;
    if (time == null || widget.emptyInitialInput) {
      _hourController.clear();
      _minuteController.clear();
      _isPm = false;
      return;
    }
    _isPm = time.isPm;
    if (_use24HourFormat) {
      _hourController.text = time.hour.toString().padLeft(2, '0');
    } else {
      _hourController.text = time.hourOf12.toString().padLeft(2, '0');
    }
    _minuteController.text = time.minute.toString().padLeft(2, '0');
  }

  M3ETime? _parseFields() {
    return M3ETimePickerUtils.parseInputTime(
      hourText: _hourController.text.trim(),
      minuteText: _minuteController.text.trim(),
      use24HourFormat: _use24HourFormat,
      isPm: _isPm,
    );
  }

  String? _validateHour(String? value) {
    if ((value == null || value.isEmpty) && widget.emptyInitialInput) {
      return null;
    }
    if (!M3ETimePickerUtils.isValidHourText(
      value ?? '',
      use24HourFormat: _use24HourFormat,
    )) {
      return widget.errorInvalidText ??
          MaterialLocalizations.of(context).invalidTimeLabel;
    }
    return null;
  }

  String? _validateMinute(String? value) {
    if ((value == null || value.isEmpty) && widget.emptyInitialInput) {
      return null;
    }
    if (!M3ETimePickerUtils.isValidMinuteText(value ?? '')) {
      return widget.errorInvalidText ??
          MaterialLocalizations.of(context).invalidTimeLabel;
    }
    return null;
  }

  void _handleSaved() {
    final M3ETime? parsed = _parseFields();
    if (parsed != null) {
      widget.onTimeSaved?.call(parsed);
    }
  }

  void _handleSubmitted() {
    final M3ETime? parsed = _parseFields();
    if (parsed != null) {
      widget.onTimeSubmitted?.call(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    return FormField<void>(
      builder: (FormFieldState<void> field) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: M3ETextField(
                    controller: _hourController,
                    focusNode: _hourFocus,
                    label: widget.hourLabelText ??
                        localizations.timePickerHourLabel,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    errorText: field.errorText,
                    onSubmitted: (_) => _minuteFocus.requestFocus(),
                    onChanged: (_) => field.didChange(null),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: M3ETextField(
                    controller: _minuteController,
                    focusNode: _minuteFocus,
                    label: widget.minuteLabelText ??
                        localizations.timePickerMinuteLabel,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (field.validate()) {
                        _handleSubmitted();
                      }
                    },
                    onChanged: (_) => field.didChange(null),
                  ),
                ),
              ],
            ),
            if (!_use24HourFormat) ...<Widget>[
              const SizedBox(height: 16),
              Row(
                children: <Widget>[
                  M3EButton(
                    style: _isPm
                        ? M3EButtonStyle.outlined
                        : M3EButtonStyle.filled,
                    onPressed: () => setState(() => _isPm = false),
                    child: Text(localizations.anteMeridiemAbbreviation),
                  ),
                  const SizedBox(width: 8),
                  M3EButton(
                    style: _isPm
                        ? M3EButtonStyle.filled
                        : M3EButtonStyle.outlined,
                    onPressed: () => setState(() => _isPm = true),
                    child: Text(localizations.postMeridiemAbbreviation),
                  ),
                ],
              ),
            ],
          ],
        );
      },
      validator: (_) {
        final String? hourError = _validateHour(_hourController.text.trim());
        if (hourError != null) {
          return hourError;
        }
        return _validateMinute(_minuteController.text.trim());
      },
      onSaved: (_) => _handleSaved(),
    );
  }
}
