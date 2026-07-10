import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundations/foundations.dart';
import 'components/m3e_time_dial_painter.dart';
import 'enums/m3e_time_picker_enums.dart';
import 'models/m3e_time.dart';
import 'styles/m3e_time_picker_theme.dart';

const String _amLabel = 'AM';
const String _pmLabel = 'PM';
const String _timeSeparator = ':';
const String _zeroPad = '0';

/// A Material 3 Expressive time picker.
///
/// A clock dial for choosing an hour and minute with an AM/PM toggle. Tapping
/// the hour or minute field switches which unit the dial edits.
class M3ETimePicker extends StatefulWidget {
  const M3ETimePicker({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final M3ETime value;
  final ValueChanged<M3ETime> onChanged;

  @override
  State<M3ETimePicker> createState() => _M3ETimePickerState();
}

class _M3ETimePickerState extends State<M3ETimePicker> {
  M3ETimePickerMode _mode = M3ETimePickerMode.hour;

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final timeTheme = theme.timePickerTheme;
    return M3EComponentTheme(builder: (context) => Container(
        padding: timeTheme.padding,
        decoration: BoxDecoration(
          color: timeTheme.containerColor(scheme),
          borderRadius: timeTheme.borderRadius,
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildHeader(theme),
              SizedBox(height: timeTheme.headerDialGap),
              _buildDial(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(M3EThemeData theme) {
    final timeTheme = theme.timePickerTheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildField(theme, widget.value.hourOf12.toString().padLeft(2, _zeroPad),
            M3ETimePickerMode.hour),
        Text(
          _timeSeparator,
          style: theme.typeScale.displayMedium
              .copyWith(color: theme.colorScheme.onSurface),
        ),
        _buildField(theme, widget.value.minuteLabel, M3ETimePickerMode.minute),
        SizedBox(width: timeTheme.fieldPeriodGap),
        _buildPeriodToggle(theme),
      ],
    );
  }

  Widget _buildField(M3EThemeData theme, String text, M3ETimePickerMode mode) {
    final scheme = theme.colorScheme;
    final timeTheme = theme.timePickerTheme;
    final active = _mode == mode;
    return M3ETappable(
      onTap: () => setState(() => _mode = mode),
      builder: (BuildContext context, M3EInteractionState state) {
        return Container(
          width: timeTheme.fieldSize.width,
          height: timeTheme.fieldSize.height,
          alignment: Alignment.center,
          margin: timeTheme.fieldMargin,
          decoration: BoxDecoration(
            color: timeTheme.fieldBackgroundColor(scheme, active: active),
            borderRadius: M3EShapes.radiusSmall,
          ),
          child: Text(
            text,
            style: theme.typeScale.displayMedium.copyWith(
              color: timeTheme.fieldForegroundColor(scheme, active: active),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodToggle(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: M3EShapes.radiusSmall,
        border: Border.all(color: scheme.outline),
      ),
      child: ClipRRect(
        borderRadius: M3EShapes.radiusSmall,
        child: Column(
          children: <Widget>[
            _buildPeriodOption(theme, _amLabel, !widget.value.isPm),
            _buildPeriodOption(theme, _pmLabel, widget.value.isPm),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodOption(M3EThemeData theme, String label, bool selected) {
    final scheme = theme.colorScheme;
    final timeTheme = theme.timePickerTheme;
    return M3ETappable(
      onTap: () => _setPeriod(label == _pmLabel),
      builder: (BuildContext context, M3EInteractionState state) {
        return Container(
          width: timeTheme.periodOptionSize.width,
          height: timeTheme.periodOptionSize.height,
          alignment: Alignment.center,
          color: timeTheme.periodOptionBackgroundColor(scheme, selected: selected),
          child: Text(
            label,
            style: theme.typeScale.titleMedium.copyWith(
              color: timeTheme.periodOptionForegroundColor(
                scheme,
                selected: selected,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDial(M3EThemeData theme) {
    final scheme = theme.colorScheme;
    final timeTheme = theme.timePickerTheme;
    return SizedBox(
      width: timeTheme.dialSize,
      height: timeTheme.dialSize,
      child: GestureDetector(
        onTapDown: (TapDownDetails d) => _handleDial(d.localPosition, timeTheme),
        onPanUpdate: (DragUpdateDetails d) =>
            _handleDial(d.localPosition, timeTheme),
        child: CustomPaint(
          painter: M3ETimeDialPainter(
            labels: _dialLabels(),
            selectedIndex: _selectedIndex(),
            dialColor: scheme.surfaceContainerHighest,
            accentColor: scheme.primary,
            onAccentColor: scheme.onPrimary,
            labelColor: scheme.onSurface,
            textDirection: Directionality.of(context),
            timeTheme: timeTheme,
          ),
        ),
      ),
    );
  }

  List<String> _dialLabels() {
    if (_mode == M3ETimePickerMode.hour) {
      return <String>[
        '12',
        for (int i = 1; i <= 11; i++) '$i',
      ];
    }
    return <String>[
      for (int i = 0; i < 12; i++) (i * 5).toString().padLeft(2, '0'),
    ];
  }

  int _selectedIndex() {
    if (_mode == M3ETimePickerMode.hour) {
      return widget.value.hourOf12 % 12;
    }
    return (widget.value.minute / 5).round() % 12;
  }

  void _handleDial(Offset position, M3ETimePickerTheme timeTheme) {
    final double dimension = timeTheme.dialSize;
    final center = Offset(dimension / 2, dimension / 2);
    final Offset delta = position - center;
    final double fraction =
        ((math.atan2(delta.dy, delta.dx) + math.pi / 2) / (2 * math.pi)) % 1;
    if (_mode == M3ETimePickerMode.hour) {
      _setHour((fraction * 12).round() % 12);
    } else {
      _setMinute((fraction * 60).round() % 60);
    }
  }

  void _setHour(int slot) {
    final hour12 = slot == 0 ? 12 : slot;
    final hour24 = _to24Hour(hour12, widget.value.isPm);
    widget.onChanged(widget.value.copyWith(hour: hour24));
  }

  void _setMinute(int minute) {
    widget.onChanged(widget.value.copyWith(minute: minute));
  }

  void _setPeriod(bool pm) {
    final hour24 = _to24Hour(widget.value.hourOf12, pm);
    widget.onChanged(widget.value.copyWith(hour: hour24));
  }

  int _to24Hour(int hour12, bool pm) {
    final int base = hour12 % 12;
    return pm ? base + 12 : base;
  }
}
