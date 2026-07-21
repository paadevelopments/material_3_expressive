import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../foundations/foundations.dart';
import '../enums/m3e_time_picker_enums.dart';
import '../models/m3e_time.dart';
import '../styles/m3e_time_picker_theme.dart';
import '../utils/m3e_time_picker_utils.dart';
import 'm3e_time_dial_painter.dart';

const String _timeSeparator = ':';
const String _zeroPad = '0';

/// Embeddable clock dial for choosing an hour and minute.
class M3EDialTimePicker extends StatefulWidget {
  const M3EDialTimePicker({
    required this.value,
    required this.onChanged,
    this.use24HourFormat,
    this.expandToFit = false,
    super.key,
  });

  final M3ETime value;
  final ValueChanged<M3ETime> onChanged;
  final bool? use24HourFormat;
  final bool expandToFit;

  @override
  State<M3EDialTimePicker> createState() => _M3EDialTimePickerState();
}

class _M3EDialTimePickerState extends State<M3EDialTimePicker> {
  M3ETimePickerMode _mode = M3ETimePickerMode.hour;

  bool _use24HourFormat(BuildContext context) {
    return M3ETimePickerUtils.use24HourFormat(
      context,
      alwaysUse24HourFormat: widget.use24HourFormat,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = M3ETheme.of(context);
    final scheme = theme.colorScheme;
    final timeTheme = theme.timePickerTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final bool use24Hour = _use24HourFormat(context);

    final Widget content = FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _buildHeader(theme, localizations, use24Hour),
          SizedBox(height: timeTheme.headerDialGap),
          _buildDial(theme, use24Hour),
        ],
      ),
    );

    if (widget.expandToFit) {
      return content;
    }

    return M3EComponentTheme(
      builder: (BuildContext context) => Container(
        padding: timeTheme.padding,
        decoration: BoxDecoration(
          color: timeTheme.containerColor(scheme),
          borderRadius: timeTheme.borderRadius,
        ),
        child: content,
      ),
    );
  }

  Widget _buildHeader(
    M3EThemeData theme,
    MaterialLocalizations localizations,
    bool use24Hour,
  ) {
    final timeTheme = theme.timePickerTheme;
    final String hourText = use24Hour
        ? widget.value.hour.toString().padLeft(2, _zeroPad)
        : widget.value.hourOf12.toString().padLeft(2, _zeroPad);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildField(theme, hourText, M3ETimePickerMode.hour),
        Semantics(
          label: localizations.timePickerHourModeAnnouncement,
          excludeSemantics: true,
          child: Text(
            _timeSeparator,
            style: theme.typeScale.displayMedium
                .copyWith(color: theme.colorScheme.onSurface),
          ),
        ),
        _buildField(
          theme,
          widget.value.minuteLabel,
          M3ETimePickerMode.minute,
        ),
        if (!use24Hour) ...<Widget>[
          SizedBox(width: timeTheme.fieldPeriodGap),
          _buildPeriodToggle(theme, localizations),
        ],
      ],
    );
  }

  Widget _buildField(M3EThemeData theme, String text, M3ETimePickerMode mode) {
    final scheme = theme.colorScheme;
    final timeTheme = theme.timePickerTheme;
    final active = _mode == mode;
    return Semantics(
      selected: active,
      button: true,
      child: M3ETappable(
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
      ),
    );
  }

  Widget _buildPeriodToggle(
    M3EThemeData theme,
    MaterialLocalizations localizations,
  ) {
    final scheme = theme.colorScheme;
    final String amLabel = localizations.anteMeridiemAbbreviation;
    final String pmLabel = localizations.postMeridiemAbbreviation;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: M3EShapes.radiusSmall,
        border: Border.all(color: scheme.outline),
      ),
      child: ClipRRect(
        borderRadius: M3EShapes.radiusSmall,
        child: Column(
          children: <Widget>[
            _buildPeriodOption(theme, amLabel, !widget.value.isPm),
            _buildPeriodOption(theme, pmLabel, widget.value.isPm),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodOption(M3EThemeData theme, String label, bool selected) {
    final scheme = theme.colorScheme;
    final timeTheme = theme.timePickerTheme;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final bool isPm = label == localizations.postMeridiemAbbreviation;
    return Semantics(
      selected: selected,
      button: true,
      child: M3ETappable(
        onTap: () => _setPeriod(isPm),
        builder: (BuildContext context, M3EInteractionState state) {
          return Container(
            width: timeTheme.periodOptionSize.width,
            height: timeTheme.periodOptionSize.height,
            alignment: Alignment.center,
            color: timeTheme.periodOptionBackgroundColor(
              scheme,
              selected: selected,
            ),
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
      ),
    );
  }

  Widget _buildDial(M3EThemeData theme, bool use24Hour) {
    final scheme = theme.colorScheme;
    final timeTheme = theme.timePickerTheme;
    return RepaintBoundary(
      child: SizedBox(
        width: timeTheme.dialSize,
        height: timeTheme.dialSize,
        child: GestureDetector(
          onTapDown: (TapDownDetails d) {
            HapticFeedback.selectionClick();
            _handleDial(d.localPosition, timeTheme, use24Hour);
          },
          onPanUpdate: (DragUpdateDetails d) =>
              _handleDial(d.localPosition, timeTheme, use24Hour),
          child: CustomPaint(
            painter: M3ETimeDialPainter(
              labels: _dialLabels(use24Hour),
              selectedIndex: _selectedIndex(use24Hour),
              dialColor: scheme.surfaceContainerHighest,
              accentColor: scheme.primary,
              onAccentColor: scheme.onPrimary,
              labelColor: scheme.onSurface,
              textDirection: Directionality.of(context),
              timeTheme: timeTheme,
            ),
          ),
        ),
      ),
    );
  }

  List<String> _dialLabels(bool use24Hour) {
    if (_mode == M3ETimePickerMode.hour) {
      if (use24Hour) {
        return <String>[
          for (int i = 0; i < 12; i++) '${(i * 2).toString().padLeft(2, '0')}',
        ];
      }
      return <String>[
        '12',
        for (int i = 1; i <= 11; i++) '$i',
      ];
    }
    return <String>[
      for (int i = 0; i < 12; i++) (i * 5).toString().padLeft(2, '0'),
    ];
  }

  int _selectedIndex(bool use24Hour) {
    if (_mode == M3ETimePickerMode.hour) {
      if (use24Hour) {
        return (widget.value.hour / 2).round() % 12;
      }
      return widget.value.hourOf12 % 12;
    }
    return (widget.value.minute / 5).round() % 12;
  }

  void _handleDial(
    Offset position,
    M3ETimePickerTheme timeTheme,
    bool use24Hour,
  ) {
    final double dimension = timeTheme.dialSize;
    final center = Offset(dimension / 2, dimension / 2);
    final Offset delta = position - center;
    final double fraction =
        ((math.atan2(delta.dy, delta.dx) + math.pi / 2) / (2 * math.pi)) % 1;
    if (_mode == M3ETimePickerMode.hour) {
      if (use24Hour) {
        final int hour = (fraction * 24).round() % 24;
        widget.onChanged(widget.value.copyWith(hour: hour));
      } else {
        _setHour((fraction * 12).round() % 12);
      }
    } else {
      final int snapped = ((fraction * 60).round() ~/ 5) * 5 % 60;
      _setMinute(snapped);
    }
  }

  void _setHour(int slot) {
    final hour12 = slot == 0 ? 12 : slot;
    final hour24 = M3ETimePickerUtils.to24Hour(hour12, widget.value.isPm);
    widget.onChanged(widget.value.copyWith(hour: hour24));
  }

  void _setMinute(int minute) {
    widget.onChanged(widget.value.copyWith(minute: minute));
  }

  void _setPeriod(bool pm) {
    final hour24 =
        M3ETimePickerUtils.to24Hour(widget.value.hourOf12, pm);
    widget.onChanged(widget.value.copyWith(hour: hour24));
  }
}
