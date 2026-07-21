import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundations/foundations.dart';
import '../divider/m3e_divider.dart';
import 'components/m3e_date_picker_actions.dart';
import 'components/m3e_date_picker_header.dart';
import 'components/m3e_input_date_picker_form_field.dart';
import 'enums/m3e_date_picker_enums.dart';
import 'm3e_calendar_date_picker.dart';
import 'models/m3e_date_picker_models.dart';
import 'res/m3e_date_picker_constants.dart';
import 'utils/m3e_date_picker_utils.dart';

/// Dialog for picking a single date.
class M3EDatePickerDialog extends StatefulWidget {
  const M3EDatePickerDialog({
    required this.firstDate,
    required this.lastDate,
    this.initialDate,
    this.currentDate,
    this.initialEntryMode = M3EDatePickerEntryMode.calendar,
    this.initialCalendarMode = M3EDatePickerMode.day,
    this.selectableDayPredicate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.keyboardType,
    this.restorationId,
    this.onDatePickerModeChange,
    this.insetPadding = M3EDatePickerConstants.defaultInsetPadding,
    super.key,
  });

  final DateTime? initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime? currentDate;
  final M3EDatePickerEntryMode initialEntryMode;
  final M3EDatePickerMode initialCalendarMode;
  final M3ESelectableDayPredicate? selectableDayPredicate;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final TextInputType? keyboardType;
  final String? restorationId;
  final ValueChanged<M3EDatePickerEntryMode>? onDatePickerModeChange;
  final EdgeInsets insetPadding;

  @override
  State<M3EDatePickerDialog> createState() => _M3EDatePickerDialogState();
}

class _M3EDatePickerDialogState extends State<M3EDatePickerDialog>
    with RestorationMixin {
  late final RestorableDateTimeN _selectedDate =
      RestorableDateTimeN(widget.initialDate);
  late final _RestorableM3EDatePickerEntryMode _entryMode =
      _RestorableM3EDatePickerEntryMode(widget.initialEntryMode);
  final _RestorableAutovalidateMode _autovalidateMode =
      _RestorableAutovalidateMode(AutovalidateMode.disabled);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(_autovalidateMode, 'autovalidateMode');
    registerForRestoration(_entryMode, 'calendar_entry_mode');
  }

  @override
  void dispose() {
    _selectedDate.dispose();
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
    Navigator.of(context).pop(_selectedDate.value);
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

  void _handleDateChanged(DateTime date) {
    setState(() => _selectedDate.value = M3EDatePickerUtils.dateOnly(date));
  }

  Size _dialogSize(BuildContext context) {
    final bool isCalendar = switch (_entryMode.value) {
      M3EDatePickerEntryMode.calendar ||
      M3EDatePickerEntryMode.calendarOnly =>
        true,
      M3EDatePickerEntryMode.input || M3EDatePickerEntryMode.inputOnly => false,
    };
    final Orientation orientation = MediaQuery.orientationOf(context);
    return switch ((isCalendar, orientation)) {
      (true, Orientation.portrait) =>
        M3EDatePickerConstants.calendarPortraitDialogSize,
      (false, Orientation.portrait) =>
        M3EDatePickerConstants.inputPortraitDialogSize,
      (true, Orientation.landscape) =>
        M3EDatePickerConstants.calendarLandscapeDialogSize,
      (false, Orientation.landscape) =>
        M3EDatePickerConstants.inputLandscapeDialogSize,
    };
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

    final String titleText = _selectedDate.value == null
        ? ''
        : localizations.formatMediumDate(_selectedDate.value!);

    Widget? entryModeButton;
    late Widget picker;
    switch (_entryMode.value) {
      case M3EDatePickerEntryMode.calendar:
        picker = M3ECalendarDatePicker(
          key: ValueKey<DateTime?>(_selectedDate.value),
          initialDate: _selectedDate.value,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          initialCalendarMode: widget.initialCalendarMode,
          selectableDayPredicate: widget.selectableDayPredicate,
          onDateChanged: _handleDateChanged,
          expandToFit: true,
        );
        entryModeButton = M3EDatePickerEntryModeButton(
          icon: M3EIcons.edit_outlined,
          tooltip: localizations.inputDateModeButtonLabel,
          onPressed: _handleEntryModeToggle,
        );
      case M3EDatePickerEntryMode.calendarOnly:
        picker = M3ECalendarDatePicker(
          key: ValueKey<DateTime?>(_selectedDate.value),
          initialDate: _selectedDate.value,
          firstDate: firstDate,
          lastDate: lastDate,
          currentDate: currentDate,
          initialCalendarMode: widget.initialCalendarMode,
          selectableDayPredicate: widget.selectableDayPredicate,
          onDateChanged: _handleDateChanged,
          expandToFit: true,
        );
      case M3EDatePickerEntryMode.input:
      case M3EDatePickerEntryMode.inputOnly:
        picker = Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode.value,
          child: SizedBox(
            height: orientation == Orientation.portrait
                ? M3EDatePickerConstants.inputFormPortraitHeight
                : M3EDatePickerConstants.inputFormLandscapeHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dateTheme.inputHorizontalPadding,
              ),
              child: Shortcuts(
                shortcuts: const <ShortcutActivator, Intent>{
                  SingleActivator(LogicalKeyboardKey.enter): NextFocusIntent(),
                },
                child: M3EInputDatePickerFormField(
                  initialDate: _selectedDate.value,
                  firstDate: firstDate,
                  lastDate: lastDate,
                  onDateSubmitted: _handleDateChanged,
                  onDateSaved: _handleDateChanged,
                  selectableDayPredicate: widget.selectableDayPredicate,
                  errorFormatText: widget.errorFormatText,
                  errorInvalidText: widget.errorInvalidText,
                  fieldHintText: widget.fieldHintText,
                  fieldLabelText: widget.fieldLabelText,
                  keyboardType: widget.keyboardType,
                  autofocus: true,
                ),
              ),
            ),
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

    final Widget header = M3EDatePickerHeader(
      helpText: widget.helpText ?? localizations.datePickerHelpText,
      titleText: titleText,
      orientation: orientation,
      isShort: orientation == Orientation.landscape &&
          (_entryMode.value == M3EDatePickerEntryMode.input ||
              _entryMode.value == M3EDatePickerEntryMode.inputOnly),
      entryModeButton: entryModeButton,
    );

    final Widget actions = M3EDatePickerActions(
      cancelText: widget.cancelText ?? localizations.cancelButtonLabel,
      confirmText: widget.confirmText ?? localizations.okButtonLabel,
      onCancel: _handleCancel,
      onConfirm: _handleOk,
    );

    final double textScaleFactor =
        MediaQuery.textScalerOf(context)
            .clamp(maxScaleFactor: M3EDatePickerConstants.maxTextScaleFactor)
            .scale(M3EDatePickerConstants.fontSizeToScale) /
        M3EDatePickerConstants.fontSizeToScale;
    final Size dialogSize = _dialogSize(context) * textScaleFactor;

    final bool isInputMode =
        _entryMode.value == M3EDatePickerEntryMode.input ||
        _entryMode.value == M3EDatePickerEntryMode.inputOnly;
    final double portraitPickerHeight = isInputMode
        ? M3EDatePickerConstants.inputFormPortraitHeight
        : M3EDatePickerConstants.dialogPickerBodyHeight;

    return Padding(
      padding: widget.insetPadding,
      child: Material(
        color: dateTheme.backgroundColor(theme.colorScheme),
        elevation: dateTheme.elevation,
        shape: RoundedRectangleBorder(borderRadius: dateTheme.dialogShape),
        clipBehavior: Clip.antiAlias,
        child: AnimatedContainer(
          width: dialogSize.width,
          duration: M3EDatePickerConstants.dialogSizeAnimationDuration,
          curve: Curves.easeIn,
          child: switch (orientation) {
            Orientation.portrait => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  header,
                  M3EDivider(
                    thickness: 1,
                    color: dateTheme.dividerColor(theme.colorScheme),
                  ),
                  AnimatedSize(
                    duration: M3EDatePickerConstants.dialogSizeAnimationDuration,
                    curve: Curves.easeIn,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: portraitPickerHeight,
                      child: picker,
                    ),
                  ),
                  actions,
                ],
              ),
            Orientation.landscape => SizedBox(
                height: dialogSize.height,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    header,
                    M3EDivider(
                      axis: M3EDividerAxis.vertical,
                      thickness: 1,
                      color: dateTheme.dividerColor(theme.colorScheme),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Expanded(child: picker),
                          actions,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          },
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
