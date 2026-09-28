import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  setUp(M3EFocusInteraction.resetForTest);

  testWidgets('sizes set track, corner, and handle', _sizes);
  testWidgets('colors follow slider roles', _colors);
  testWidgets('arrows, space, home, and end step the value', _keyboard);
  testWidgets('stops snap to one division', _stops);
  testWidgets('vertical stops snap and honor dot size', _verticalStops);
  testWidgets('pointer interaction clears focus chrome', _focus);
  testWidgets('range shows one value indicator', _rangeIndicator);
  testWidgets('inset icon springs beside the thumb', _icon);
  testWidgets('wavy wavelength updates', _wavelength);
}

Widget _app(Widget child) {
  return MaterialApp(
    home: Scaffold(
      body: Center(child: SizedBox(width: 320, height: 160, child: child)),
    ),
  );
}

Future<void> _sizes(WidgetTester tester) async {
  await tester.pumpWidget(_app(M3ESlider(value: 0.4, onChanged: (_) {})));
  await tester.pump();
  var track = tester.widget<M3ESliderTrack>(find.byType(M3ESliderTrack));
  expect(track.trackHeight, 16);
  expect(track.cornerRadius, 8);
  expect(_hasHandle(tester, width: 4, height: 44), isTrue);

  await tester.pumpWidget(
    _app(M3ESlider(value: 0.4, size: M3ESliderSize.m, onChanged: (_) {})),
  );
  await tester.pump();
  track = tester.widget<M3ESliderTrack>(find.byType(M3ESliderTrack));
  expect(track.trackHeight, 40);
  expect(track.cornerRadius, 12);
  expect(_hasHandle(tester, width: 4, height: 52), isTrue);

  await tester.pumpWidget(
    _app(M3ESlider(value: 0.4, size: M3ESliderSize.xl, onChanged: (_) {})),
  );
  await tester.pump();
  track = tester.widget<M3ESliderTrack>(find.byType(M3ESliderTrack));
  expect(track.trackHeight, 96);
  expect(track.cornerRadius, 28);
  expect(_hasHandle(tester, width: 4, height: 108), isTrue);
}

Future<void> _colors(WidgetTester tester) async {
  await tester.pumpWidget(_app(M3ESlider(value: 0.4, onChanged: (_) {})));
  await tester.pump();
  final scheme = M3ETheme.of(tester.element(find.byType(M3ESlider)))
      .colorScheme;
  final track = tester.widget<M3ESliderTrack>(find.byType(M3ESliderTrack));
  expect(track.colors.activeTrack, scheme.primary);
  expect(track.colors.inactiveTrack, scheme.secondaryContainer);
  expect(track.colors.stopIndicator, scheme.onSecondaryContainer);
  expect(track.colors.valueIndicator, scheme.inverseSurface);
}

Future<void> _keyboard(WidgetTester tester) async {
  var value = 50.0;
  await tester.pumpWidget(
    _app(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return M3ESlider(
            value: value,
            max: 100,
            onChanged: (double next) => setState(() => value = next),
          );
        },
      ),
    ),
  );
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowRight);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowRight);
  expect(value, closeTo(51, 0.001));

  await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowRight);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowRight);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
  expect(value, closeTo(61, 0.001));

  await tester.sendKeyDownEvent(LogicalKeyboardKey.home);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.home);
  expect(value, 0);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.end);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.end);
  expect(value, 100);
}

Future<void> _stops(WidgetTester tester) async {
  var value = 0.0;
  await tester.pumpWidget(
    _app(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return M3ESlider(
            value: value,
            max: 5,
            divisions: 5,
            onChanged: (double next) => setState(() => value = next),
          );
        },
      ),
    ),
  );
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowRight);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowRight);
  expect(value, 1);
}

Future<void> _verticalStops(WidgetTester tester) async {
  var value = 0.0;
  await tester.pumpWidget(
    _app(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return M3ESlider.vertical(
            value: value,
            max: 5,
            divisions: 5,
            dotSize: 8,
            dotSpacing: 10,
            onChanged: (double next) => setState(() => value = next),
          );
        },
      ),
    ),
  );
  await tester.pump();
  final track = tester.widget<M3ESliderTrack>(find.byType(M3ESliderTrack));
  expect(track.tickFractions, hasLength(6));
  expect(track.tickFractions.first, 0);
  expect(track.tickFractions.last, 1);
  expect(track.stopIndicatorSize, 8);
  expect(track.edgeInset, 10);
  expect(track.axis, Axis.vertical);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowUp);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowUp);
  expect(value, 1);
}

Future<void> _focus(WidgetTester tester) async {
  final previous = FocusManager.instance.highlightStrategy;
  FocusManager.instance.highlightStrategy =
      FocusHighlightStrategy.alwaysTraditional;
  addTearDown(() => FocusManager.instance.highlightStrategy = previous);
  await tester.pumpWidget(_app(M3ESlider(value: 0.5, onChanged: (_) {})));
  await tester.pump();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.pump(const Duration(milliseconds: 400));
  expect(_hasHandle(tester, width: 2, height: 44), isTrue);
  expect(_hasFocusRing(tester), isFalse);
  expect(_hasStateLayer(tester), isFalse);

  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer();
  await gesture.moveTo(tester.getCenter(find.byType(M3ESlider)));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  expect(M3EFocusInteraction.instance.ringsAllowed, isFalse);
  expect(_hasHandle(tester, width: 4, height: 44), isTrue);
  expect(_hasFocusRing(tester), isFalse);
  expect(_hasStateLayer(tester), isFalse);
  await gesture.removePointer();
}

Future<void> _rangeIndicator(WidgetTester tester) async {
  await tester.pumpWidget(
    _app(
      M3ERangeSlider(values: const M3ESliderRange(0.2, 0.8), onChanged: (_) {}),
    ),
  );
  await tester.pump();
  expect(find.byType(M3ESliderValueIndicator), findsNothing);
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  expect(find.byType(M3ESliderValueIndicator), findsOneWidget);
}

Future<void> _icon(WidgetTester tester) async {
  await tester.pumpWidget(
    _app(
      M3ESlider(
        value: 0.2,
        size: M3ESliderSize.m,
        icon: const Icon(M3EIcons.volume_up),
        onChanged: (_) {},
      ),
    ),
  );
  await tester.pump();
  final slider = tester.getRect(find.byType(M3ESlider));
  final resting = tester.getCenter(find.byIcon(M3EIcons.volume_up));
  expect(resting.dx, greaterThan(slider.center.dx));

  await tester.pumpWidget(
    _app(
      M3ESlider(
        value: 1,
        size: M3ESliderSize.m,
        icon: const Icon(M3EIcons.volume_up),
        onChanged: (_) {},
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
  final moved = tester.getCenter(find.byIcon(M3EIcons.volume_up));
  expect(moved.dx, lessThan(resting.dx - 4));
  expect(moved.dx, greaterThan(slider.center.dx));
}

Future<void> _wavelength(WidgetTester tester) async {
  await tester.pumpWidget(
    _app(M3ESlider.wavy(value: 0.5, wavelength: 24, onChanged: (_) {})),
  );
  await tester.pump();
  expect(
    tester.widget<M3ESliderTrack>(find.byType(M3ESliderTrack)).wavelength,
    24,
  );

  await tester.pumpWidget(
    _app(M3ESlider.wavy(value: 0.5, wavelength: 80, onChanged: (_) {})),
  );
  await tester.pump();
  expect(
    tester.widget<M3ESliderTrack>(find.byType(M3ESliderTrack)).wavelength,
    80,
  );
}

bool _hasFocusRing(WidgetTester tester) {
  return tester.widgetList<Container>(find.byType(Container)).any((
    Container container,
  ) {
    final decoration = container.decoration;
    if (decoration is! BoxDecoration || decoration.border == null) {
      return false;
    }
    final constraints = container.constraints;
    if (constraints == null) {
      return false;
    }
    return constraints.maxWidth > 6 && constraints.maxHeight > 46;
  });
}

bool _hasStateLayer(WidgetTester tester) {
  return tester.widgetList<Container>(find.byType(Container)).any((
    Container container,
  ) {
    final constraints = container.constraints;
    final decoration = container.decoration;
    if (constraints == null || decoration is! BoxDecoration) {
      return false;
    }
    return (constraints.maxWidth - 40).abs() < 0.6 &&
        (constraints.maxHeight - 40).abs() < 0.6 &&
        decoration.shape == BoxShape.circle;
  });
}

bool _hasHandle(
  WidgetTester tester, {
  required double width,
  required double height,
}) {
  return tester.widgetList<Container>(find.byType(Container)).any((
    Container container,
  ) {
    final constraints = container.constraints;
    if (constraints == null) {
      return false;
    }
    return (constraints.maxWidth - width).abs() < 0.6 &&
        (constraints.maxHeight - height).abs() < 0.6;
  });
}
