import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundations/foundations.dart';
import '../divider/m3e_divider.dart';
import 'components/m3e_calendar_date_range_picker.dart';
import 'components/m3e_date_picker_actions.dart';
import 'components/m3e_date_picker_dialog_content.dart';
import 'components/m3e_date_picker_header.dart';
import 'components/m3e_input_date_range_picker_form_field.dart';
import 'enums/m3e_date_picker_enums.dart';
import 'models/m3e_date_picker_models.dart';
import 'res/m3e_date_picker_constants.dart';
import 'utils/m3e_date_picker_utils.dart';

/// Dialog for picking a date range.
class M3EDateRangePickerDialog extends StatefulWidget {
  const M3EDateRangePickerDialog({
    required this.firstDate,
    required this.lastDate,
    this.initialStartDate,
    this.initialEndDate,
    this.currentDate,
    this.initialEntryMode = M3EDatePickerEntryMode.calendar,
    this.selectableDayPredicate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldStartHintText,
    this.fieldEndHintText,
    this.fieldStartLabelText,
    this.fieldEndLabelText,
    this.restorationId,
    this.onDatePickerModeChange,
    this.insetPadding = M3EDatePickerConstants.defaultInsetPadding,
    super.key,
  });

  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final DateTime? currentDate;
  final M3EDatePickerEntryMode initialEntryMode;
  final M3ESelectableDayForRangePredicate? selectableDayPredicate;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldStartHintText;
  final String? fieldEndHintText;
  final String? fieldStartLabelText;
  final String? fieldEndLabelText;
  final String? restorationId;
  final ValueChanged<M3EDatePickerEntryMode>? onDatePickerModeChange;
  final EdgeInsets insetPadding;

  @override
  State<M3EDateRangePickerDialog> createState() =>
      _M3EDateRangePickerDialogState();
}

class _M3EDateRangePickerDialogState extends State<M3EDateRangePickerDialog>
    with RestorationMixin {
  late final RestorableDateTimeN _startDate =
      RestorableDateTimeN(widget.initialStartDate);
  late final RestorableDateTimeN _endDate =
      RestorableDateTimeN(widget.initialEndDate);
  late final _RestorableM3EDatePickerEntryMode _entryMode =
      _RestorableM3EDatePickerEntryMode(widget.initialEntryMode);
  final _RestorableAutovalidateMode _autovalidateMode =
      _RestorableAutovalidateMode(AutovalidateMode.disabled);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_startDate, 'start_date');
    registerForRestoration(_endDate, 'end_date');
    registerForRestoration(_autovalidateMode, 'autovalidateMode');
    registerForRestoration(_entryMode, 'calendar_entry_mode');
  }

  @override
  void dispose() {
    _startDate.dispose();
    _endDate.dispose();
    _entryMode.dispose();
    _autovalidateMode.dispose();
    super.dispose();
  }

  void _handleOk() {
    if (_entryMode.value == M3EDatePickerEntryMode.input ||
        _entryMode.value == M3EDatePickerEntryMode.inputOnly) {
      final FormState? form = _formKey.currentState;
      if (form == null || !form.validate()) {
        setState(() => _autovalidateMode.value = AutovalidateMode.always);
        return;
      }
      form.save();
    }
    if (_startDate.value == null) {
      return;
    }
    Navigator.of(context).pop(
      M3EDateRange(start: _startDate.value!, end: _endDate.value),
    );
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  void _handleEntryModeToggle() {
    setState(() {
      switch (_entryMode.value) {
        case M3EDatePickerEntryMode.calendar:
          _autovalidateMode.value = AutovalidateMode.disabled;
          _entryMode.value = M3EDatePickerEntryMode.input;
        case M3EDatePickerEntryMode.input:
          _formKey.currentState?.save();
          _entryMode.value = M3EDatePickerEntryMode.calendar;
        case M3EDatePickerEntryMode.calendarOnly:
        case M3EDatePickerEntryMode.inputOnly:
          break;
      }
      widget.onDatePickerModeChange?.call(_entryMode.value);
    });
  }

  String _headerTitle(MaterialLocalizations localizations) {
    if (_startDate.value == null) {
      return '';
    }
    if (_endDate.value == null) {
      return localizations.formatMediumDate(_startDate.value!);
    }
    return '${localizations.formatMediumDate(_startDate.value!)} – ${localizations.formatMediumDate(_endDate.value!)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final dateTheme = theme.datePickerTheme;
    final localizations = MaterialLocalizations.of(context);
    final Orientation orientation = MediaQuery.orientationOf(context);
    final DateTime firstDate = M3EDatePickerUtils.dateOnly(widget.firstDate);
    final DateTime lastDate = M3EDatePickerUtils.dateOnly(widget.lastDate);
    final DateTime currentDate = M3EDatePickerUtils.dateOnly(
      widget.currentDate ?? DateTime.now(),
    );

    Widget? entryModeButton;
    late Widget picker;
    switch (_entryMode.value) {
      case M3EDatePickerEntryMode.calendar:
        picker = M3ECalendarDateRangePicker(
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          initialStartDate: _startDate.value,
          initialEndDate: _endDate.value,
          selectableDayPredicate: widget.selectableDayPredicate,
          onStartDateChanged: (DateTime value) {
            setState(() => _startDate.value = value);
          },
          onEndDateChanged: (DateTime value) {
            setState(() => _endDate.value = value);
          },
        );
        entryModeButton = M3EDatePickerEntryModeButton(
          icon: M3EIcons.edit_outlined,
          tooltip: localizations.inputDateModeButtonLabel,
          onPressed: _handleEntryModeToggle,
        );
      case M3EDatePickerEntryMode.calendarOnly:
        picker = M3ECalendarDateRangePicker(
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          initialStartDate: _startDate.value,
          initialEndDate: _endDate.value,
          selectableDayPredicate: widget.selectableDayPredicate,
          onStartDateChanged: (DateTime value) {
            setState(() => _startDate.value = value);
          },
          onEndDateChanged: (DateTime value) {
            setState(() => _endDate.value = value);
          },
        );
      case M3EDatePickerEntryMode.input:
      case M3EDatePickerEntryMode.inputOnly:
        picker = Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode.value,
          child: M3EInputDateRangePickerFormField(
              firstDate: firstDate,
              lastDate: lastDate,
              initialStartDate: _startDate.value,
              initialEndDate: _endDate.value,
              onStartDateSaved: (DateTime value) {
                setState(() => _startDate.value = value);
              },
              onEndDateSaved: (DateTime value) {
                setState(() => _endDate.value = value);
              },
              selectableDayPredicate: widget.selectableDayPredicate,
              errorFormatText: widget.errorFormatText,
              errorInvalidText: widget.errorInvalidText,
              fieldStartHintText: widget.fieldStartHintText,
              fieldEndHintText: widget.fieldEndHintText,
              fieldStartLabelText: widget.fieldStartLabelText,
              fieldEndLabelText: widget.fieldEndLabelText,
            ),
        );
        if (_entryMode.value == M3EDatePickerEntryMode.input) {
          entryModeButton = M3EDatePickerEntryModeButton(
            icon: M3EIcons.calendar_today,
            tooltip: localizations.calendarModeButtonLabel,
            onPressed: _handleEntryModeToggle,
          );
        }
    }

    final Size dialogSize =
        M3EDatePickerConstants.calendarPortraitDialogSize *
        (MediaQuery.textScalerOf(context)
                .clamp(maxScaleFactor: M3EDatePickerConstants.maxRangeTextScaleFactor)
                .scale(M3EDatePickerConstants.fontSizeToScale) /
            M3EDatePickerConstants.fontSizeToScale);

    final bool isInputMode =
        _entryMode.value == M3EDatePickerEntryMode.input ||
        _entryMode.value == M3EDatePickerEntryMode.inputOnly;

    final Widget pickerBody = AnimatedSize(
      duration: M3EDatePickerConstants.dialogSizeAnimationDuration,
      curve: Curves.easeIn,
      alignment: Alignment.topCenter,
      child: isInputMode
          ? M3EDatePickerDialogContent(
              isInputMode: true,
              child: picker,
            )
          : SizedBox(
              height: M3EDatePickerConstants.dialogPickerBodyHeight,
              child: picker,
            ),
    );

    return Padding(
      padding: widget.insetPadding,
      child: Material(
        color: dateTheme.backgroundColor(theme.colorScheme),
        elevation: dateTheme.elevation,
        shape: RoundedRectangleBorder(borderRadius: dateTheme.dialogShape),
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: dialogSize.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              M3EDatePickerHeader(
                helpText:
                    widget.helpText ?? localizations.dateRangePickerHelpText,
                titleText: _headerTitle(localizations),
                showTitle: _startDate.value != null,
                orientation: orientation,
                entryModeButton: entryModeButton,
              ),
              M3EDivider(
                thickness: 1,
                color: dateTheme.dividerColor(theme.colorScheme),
              ),
              pickerBody,
              M3EDatePickerActions(
                cancelText: widget.cancelText ?? localizations.cancelButtonLabel,
                confirmText: widget.confirmText ?? localizations.okButtonLabel,
                onCancel: _handleCancel,
                onConfirm: _handleOk,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RestorableAutovalidateMode extends RestorableValue<AutovalidateMode> {
  _RestorableAutovalidateMode(this.defaultValue);

  final AutovalidateMode defaultValue;

  @override
  AutovalidateMode createDefaultValue() => defaultValue;

  @override
  void didUpdateValue(AutovalidateMode? oldValue) {
    notifyListeners();
  }

  @override
  AutovalidateMode fromPrimitives(Object? data) {
    return AutovalidateMode.values[data! as int];
  }

  @override
  Object? toPrimitives() => value.index;
}

class _RestorableM3EDatePickerEntryMode
    extends RestorableValue<M3EDatePickerEntryMode> {
  _RestorableM3EDatePickerEntryMode(this.defaultValue);

  final M3EDatePickerEntryMode defaultValue;

  @override
  M3EDatePickerEntryMode createDefaultValue() => defaultValue;

  @override
  void didUpdateValue(M3EDatePickerEntryMode? oldValue) {
    notifyListeners();
  }

  @override
  M3EDatePickerEntryMode fromPrimitives(Object? data) {
    return M3EDatePickerEntryMode.values[data! as int];
  }

  @override
  Object? toPrimitives() => value.index;
}
