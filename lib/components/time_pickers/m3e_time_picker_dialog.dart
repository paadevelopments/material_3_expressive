import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../foundations/foundations.dart';
import '../divider/m3e_divider.dart';
import 'components/m3e_dial_time_picker.dart';
import 'components/m3e_input_time_picker_form_field.dart';
import 'components/m3e_time_picker_actions.dart';
import 'components/m3e_time_picker_dialog_content.dart';
import 'components/m3e_time_picker_header.dart';
import 'enums/m3e_time_picker_enums.dart';
import 'models/m3e_time.dart';
import 'res/m3e_time_picker_constants.dart';
import 'utils/m3e_time_picker_utils.dart';

/// Dialog for picking a single time.
class M3ETimePickerDialog extends StatefulWidget {
  /// M3ETimePickerDialog.
  const M3ETimePickerDialog({
    required this.initialTime,
    this.initialEntryMode = M3ETimePickerEntryMode.dial,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.errorInvalidText,
    this.hourLabelText,
    this.minuteLabelText,
    this.orientation,
    this.alwaysUse24HourFormat,
    this.emptyInitialInput = false,
    this.restorationId,
    this.onTimePickerModeChange,
    this.insetPadding = M3ETimePickerConstants.defaultInsetPadding,
    super.key,
  });

  /// initialTime.

  final M3ETime initialTime;

  /// initialEntryMode.
  final M3ETimePickerEntryMode initialEntryMode;

  /// helpText.
  final String? helpText;

  /// cancelText.
  final String? cancelText;

  /// confirmText.
  final String? confirmText;

  /// errorInvalidText.
  final String? errorInvalidText;

  /// hourLabelText.
  final String? hourLabelText;

  /// minuteLabelText.
  final String? minuteLabelText;

  /// orientation.
  final Orientation? orientation;

  /// alwaysUse24HourFormat.
  final bool? alwaysUse24HourFormat;

  /// emptyInitialInput.
  final bool emptyInitialInput;

  /// restorationId.
  final String? restorationId;

  /// onTimePickerModeChange.
  final ValueChanged<M3ETimePickerEntryMode>? onTimePickerModeChange;

  /// insetPadding.
  final EdgeInsets insetPadding;

  @override
  State<M3ETimePickerDialog> createState() => _M3ETimePickerDialogState();
}

class _M3ETimePickerDialogState extends State<M3ETimePickerDialog>
    with RestorationMixin {
  late final _RestorableM3ETime _selectedTime = _RestorableM3ETime(
    widget.initialTime,
  );
  late final _RestorableM3ETimePickerEntryMode _entryMode =
      _RestorableM3ETimePickerEntryMode(widget.initialEntryMode);
  final _RestorableAutovalidateMode _autovalidateMode =
      _RestorableAutovalidateMode(AutovalidateMode.disabled);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedTime, 'selected_time');
    registerForRestoration(_autovalidateMode, 'autovalidateMode');
    registerForRestoration(_entryMode, 'time_entry_mode');
  }

  @override
  void dispose() {
    _selectedTime.dispose();
    _entryMode.dispose();
    _autovalidateMode.dispose();
    super.dispose();
  }

  void _handleOk() {
    if (_entryMode.value == M3ETimePickerEntryMode.input ||
        _entryMode.value == M3ETimePickerEntryMode.inputOnly) {
      final FormState? form = _formKey.currentState;
      if (form == null || !form.validate()) {
        setState(() => _autovalidateMode.value = AutovalidateMode.always);
        return;
      }
      form.save();
    }
    Navigator.of(context).pop(_selectedTime.value);
  }

  void _handleCancel() {
    Navigator.of(context).pop();
  }

  void _handleEntryModeToggle() {
    setState(() {
      switch (_entryMode.value) {
        case M3ETimePickerEntryMode.dial:
          _autovalidateMode.value = AutovalidateMode.disabled;
          _entryMode.value = M3ETimePickerEntryMode.input;
        case M3ETimePickerEntryMode.input:
          _formKey.currentState?.save();
          _entryMode.value = M3ETimePickerEntryMode.dial;
        case M3ETimePickerEntryMode.dialOnly:
        case M3ETimePickerEntryMode.inputOnly:
          break;
      }
      widget.onTimePickerModeChange?.call(_entryMode.value);
    });
  }

  void _handleTimeChanged(M3ETime time) {
    setState(() => _selectedTime.value = M3ETimePickerUtils.clampTime(time));
  }

  Widget _buildPickerBody({
    required Widget picker,
    required bool isInputMode,
    required double? dialHeight,
  }) {
    final Widget content = M3ETimePickerDialogContent(
      isInputMode: isInputMode,
      child: picker,
    );
    return AnimatedSize(
      duration: M3ETimePickerConstants.dialogSizeAnimationDuration,
      curve: Curves.easeIn,
      alignment: Alignment.topCenter,
      child: isInputMode
          ? content
          : SizedBox(height: dialHeight, child: content),
    );
  }

  Size _dialogSize(BuildContext context, Orientation orientation) {
    final bool isDial = switch (_entryMode.value) {
      M3ETimePickerEntryMode.dial || M3ETimePickerEntryMode.dialOnly => true,
      M3ETimePickerEntryMode.input || M3ETimePickerEntryMode.inputOnly => false,
    };
    return switch ((isDial, orientation)) {
      (true, Orientation.portrait) =>
        M3ETimePickerConstants.dialPortraitDialogSize,
      (false, Orientation.portrait) =>
        M3ETimePickerConstants.inputPortraitDialogSize,
      (true, Orientation.landscape) =>
        M3ETimePickerConstants.dialLandscapeDialogSize,
      (false, Orientation.landscape) =>
        M3ETimePickerConstants.inputLandscapeDialogSize,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final timeTheme = theme.timePickerTheme;
    final localizations = MaterialLocalizations.of(context);
    final Orientation orientation =
        widget.orientation ?? MediaQuery.orientationOf(context);
    final String titleText = M3ETimePickerUtils.formatTime(
      context,
      _selectedTime.value,
      alwaysUse24HourFormat: widget.alwaysUse24HourFormat,
    );
    final ({Widget picker, Widget? entryModeButton}) resolved =
        _resolvePickerAndEntryButton(localizations);
    final String helpText = switch (_entryMode.value) {
      M3ETimePickerEntryMode.input || M3ETimePickerEntryMode.inputOnly =>
        widget.helpText ?? localizations.timePickerInputHelpText,
      M3ETimePickerEntryMode.dial || M3ETimePickerEntryMode.dialOnly =>
        widget.helpText ?? localizations.timePickerDialHelpText,
    };
    final Widget header = M3ETimePickerHeader(
      helpText: helpText,
      titleText: titleText,
      showTitle: true,
      orientation: orientation,
      isShort:
          orientation == Orientation.landscape &&
          (_entryMode.value == M3ETimePickerEntryMode.input ||
              _entryMode.value == M3ETimePickerEntryMode.inputOnly),
      entryModeButton: resolved.entryModeButton,
    );
    final Widget actions = M3ETimePickerActions(
      cancelText: widget.cancelText ?? localizations.cancelButtonLabel,
      confirmText: widget.confirmText ?? localizations.okButtonLabel,
      onCancel: _handleCancel,
      onConfirm: _handleOk,
    );
    final double textScaleFactor =
        MediaQuery.textScalerOf(context)
            .clamp(maxScaleFactor: M3ETimePickerConstants.maxTextScaleFactor)
            .scale(M3ETimePickerConstants.fontSizeToScale) /
        M3ETimePickerConstants.fontSizeToScale;
    final Size dialogSize = _dialogSize(context, orientation) * textScaleFactor;
    final bool isInputMode =
        _entryMode.value == M3ETimePickerEntryMode.input ||
        _entryMode.value == M3ETimePickerEntryMode.inputOnly;
    final EdgeInsets dialogPadding = theme.dialogTheme.padding;
    final Widget pickerBody = _buildPickerBody(
      picker: resolved.picker,
      isInputMode: isInputMode,
      dialHeight: isInputMode || orientation == Orientation.landscape
          ? null
          : M3ETimePickerConstants.dialDialogBodyHeight +
                dialogPadding.vertical,
    );
    return Padding(
      padding: widget.insetPadding,
      child: Material(
        color: timeTheme.backgroundColor(theme.colorScheme),
        elevation: timeTheme.elevation,
        shape: RoundedRectangleBorder(borderRadius: timeTheme.dialogShape),
        clipBehavior: Clip.antiAlias,
        child: AnimatedContainer(
          width: dialogSize.width,
          height: orientation == Orientation.landscape
              ? dialogSize.height
              : null,
          duration: M3ETimePickerConstants.dialogSizeAnimationDuration,
          curve: Curves.easeIn,
          child: switch (orientation) {
            Orientation.portrait => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                header,
                M3EDivider(color: timeTheme.dividerColor(theme.colorScheme)),
                pickerBody,
                actions,
              ],
            ),
            Orientation.landscape => Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                header,
                M3EDivider(
                  axis: M3EDividerAxis.vertical,
                  color: timeTheme.dividerColor(theme.colorScheme),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: isInputMode
                            ? SingleChildScrollView(child: pickerBody)
                            : pickerBody,
                      ),
                      actions,
                    ],
                  ),
                ),
              ],
            ),
          },
        ),
      ),
    );
  }

  ({Widget picker, Widget? entryModeButton}) _resolvePickerAndEntryButton(
    MaterialLocalizations localizations,
  ) {
    switch (_entryMode.value) {
      case M3ETimePickerEntryMode.dial:
        return (
          picker: _buildDialPicker(),
          entryModeButton: M3ETimePickerEntryModeButton(
            icon: M3EIcons.edit_outlined,
            tooltip: localizations.inputTimeModeButtonLabel,
            onPressed: _handleEntryModeToggle,
          ),
        );
      case M3ETimePickerEntryMode.dialOnly:
        return (picker: _buildDialPicker(), entryModeButton: null);
      case M3ETimePickerEntryMode.input:
      case M3ETimePickerEntryMode.inputOnly:
        return (
          picker: Form(
            key: _formKey,
            autovalidateMode: _autovalidateMode.value,
            child: Shortcuts(
              shortcuts: const <ShortcutActivator, Intent>{
                SingleActivator(LogicalKeyboardKey.enter): NextFocusIntent(),
              },
              child: M3EInputTimePickerFormField(
                initialTime: _selectedTime.value,
                onTimeSubmitted: _handleTimeChanged,
                onTimeSaved: _handleTimeChanged,
                errorInvalidText: widget.errorInvalidText,
                hourLabelText: widget.hourLabelText,
                minuteLabelText: widget.minuteLabelText,
                use24HourFormat: widget.alwaysUse24HourFormat,
                emptyInitialInput: widget.emptyInitialInput,
                autofocus: true,
              ),
            ),
          ),
          entryModeButton: _entryMode.value == M3ETimePickerEntryMode.input
              ? M3ETimePickerEntryModeButton(
                  icon: M3EIcons.schedule,
                  tooltip: localizations.dialModeButtonLabel,
                  onPressed: _handleEntryModeToggle,
                )
              : null,
        );
    }
  }

  Widget _buildDialPicker() {
    return M3EDialTimePicker(
      value: _selectedTime.value,
      onChanged: _handleTimeChanged,
      use24HourFormat: widget.alwaysUse24HourFormat,
      expandToFit: true,
    );
  }
}

class _RestorableM3ETime extends RestorableValue<M3ETime> {
  _RestorableM3ETime(this.defaultValue);

  final M3ETime defaultValue;

  @override
  M3ETime createDefaultValue() => defaultValue;

  @override
  void didUpdateValue(M3ETime? oldValue) {
    notifyListeners();
  }

  @override
  M3ETime fromPrimitives(Object? data) {
    final values = data! as List<Object?>;
    return M3ETime(hour: values[0]! as int, minute: values[1]! as int);
  }

  @override
  Object toPrimitives() => <Object?>[value.hour, value.minute];
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

class _RestorableM3ETimePickerEntryMode
    extends RestorableValue<M3ETimePickerEntryMode> {
  _RestorableM3ETimePickerEntryMode(this.defaultValue);

  final M3ETimePickerEntryMode defaultValue;

  @override
  M3ETimePickerEntryMode createDefaultValue() => defaultValue;

  @override
  void didUpdateValue(M3ETimePickerEntryMode? oldValue) {
    notifyListeners();
  }

  @override
  M3ETimePickerEntryMode fromPrimitives(Object? data) {
    return M3ETimePickerEntryMode.values[data! as int];
  }

  @override
  Object? toPrimitives() => value.index;
}
