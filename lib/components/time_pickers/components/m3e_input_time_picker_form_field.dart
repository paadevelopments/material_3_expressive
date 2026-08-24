import 'package:material_ui/material_ui.dart';

import '../../../foundations/foundations.dart';
import '../../text_fields/m3e_text_fields.dart';
import '../models/m3e_time.dart';
import '../utils/m3e_time_picker_utils.dart';
import 'm3e_day_period_control.dart';

const String _timeSeparator = ':';

/// Text fields for entering a time in a picker dialog.
class M3EInputTimePickerFormField extends StatefulWidget {
  /// M3EInputTimePickerFormField.
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

  /// initialTime.
  final M3ETime? initialTime;

  /// onTimeSubmitted.
  final ValueChanged<M3ETime>? onTimeSubmitted;

  /// onTimeSaved.
  final ValueChanged<M3ETime>? onTimeSaved;

  /// errorInvalidText.
  final String? errorInvalidText;

  /// hourLabelText.
  final String? hourLabelText;

  /// minuteLabelText.
  final String? minuteLabelText;

  /// use24HourFormat.
  final bool? use24HourFormat;

  /// emptyInitialInput.
  final bool emptyInitialInput;

  /// autofocus.
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

  Widget _buildPeriodControl(FormFieldState<void> field) {
    return M3EDayPeriodControl(
      isPm: _isPm,
      forInput: true,
      onChanged: (bool pm) {
        setState(() => _isPm = pm);
        field.didChange(null);
      },
    );
  }

  Widget _buildHourMinuteFields(
    FormFieldState<void> field, {
    required M3EThemeData theme,
    required MaterialLocalizations localizations,
  }) {
    return Expanded(
      child: Row(
        textDirection: TextDirection.ltr,
        children: <Widget>[
          Expanded(
            child: M3ETextField(
              controller: _hourController,
              focusNode: _hourFocus,
              label: widget.hourLabelText ?? localizations.timePickerHourLabel,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              errorText: field.errorText,
              onSubmitted: (_) => _minuteFocus.requestFocus(),
              onChanged: (_) => field.didChange(null),
            ),
          ),
          Text(
            _timeSeparator,
            style: theme.typeScale.displayMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          Expanded(
            child: M3ETextField(
              controller: _minuteController,
              focusNode: _minuteFocus,
              label:
                  widget.minuteLabelText ?? localizations.timePickerMinuteLabel,
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
    );
  }

  Widget _buildInputRow(
    FormFieldState<void> field, {
    required M3EThemeData theme,
    required MaterialLocalizations localizations,
    required bool periodLeading,
  }) {
    final Widget period = _buildPeriodControl(field);
    final Widget fields = _buildHourMinuteFields(
      field,
      theme: theme,
      localizations: localizations,
    );
    final double periodGap = theme.timePickerTheme.fieldPeriodGap;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!_use24HourFormat && periodLeading) ...<Widget>[
          period,
          SizedBox(width: periodGap),
        ],
        fields,
        if (!_use24HourFormat && !periodLeading) ...<Widget>[
          SizedBox(width: periodGap),
          period,
        ],
      ],
    );
  }

  String? _validateForm(_) {
    final String? hourError = _validateHour(_hourController.text.trim());
    if (hourError != null) {
      return hourError;
    }
    return _validateMinute(_minuteController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(
      context,
    );
    final M3EThemeData theme = M3ETheme.of(context);
    final format = localizations.timeOfDayFormat(
      alwaysUse24HourFormat: _use24HourFormat,
    );
    final periodLeading = format == TimeOfDayFormat.a_space_h_colon_mm;

    return FormField<void>(
      builder: (FormFieldState<void> field) {
        return _buildInputRow(
          field,
          theme: theme,
          localizations: localizations,
          periodLeading: periodLeading,
        );
      },
      validator: _validateForm,
      onSaved: (_) => _handleSaved(),
    );
  }
}
