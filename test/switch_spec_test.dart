import 'dart:ui' show Tristate;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  _registerSwitchThemeTests();
  _registerSwitchInteractionTests();
}

void _registerSwitchThemeTests() {
  test(
    'theme defaults match the switch spec',
    _themeDefaultsMatchTheSwitchSpec,
  );
  testWidgets(
    'control is a 48dp target around a 52dp track',
    _controlIsA48dpTargetAroundA52dpTrack,
  );
  testWidgets('off handle with an icon is 24dp', _offHandleWithAnIconIs24dp);
}

void _registerSwitchInteractionTests() {
  testWidgets(
    'drag past the midpoint toggles on',
    _dragPastTheMidpointTogglesOn,
  );
  testWidgets(
    'space toggles the focused switch',
    _spaceTogglesTheFocusedSwitch,
  );
  testWidgets(
    'semantics expose a toggled switch',
    _semanticsExposeAToggledSwitch,
  );
}

void _themeDefaultsMatchTheSwitchSpec() {
  const theme = M3ESwitchTheme.defaults;
  final scheme = M3EThemeData.light().colorScheme;

  expect(theme.trackWidth, 52);
  expect(theme.trackHeight, 32);
  expect(theme.thumbSizeUnselected, 16);
  expect(theme.thumbSizeSelected, 24);
  expect(theme.thumbSizeWithIcon, 24);
  expect(theme.thumbSizePressed, 28);
  expect(theme.stateLayerSize, 40);
  expect(theme.targetSize, 48);
  expect(theme.iconSize, 16);
  expect(theme.borderWidth, 2);
  expect(theme.focusIndicatorThickness, 3);
  expect(theme.focusIndicatorOffset, 2);
  expect(theme.hoverStateLayerOpacity, 0.08);
  expect(theme.focusStateLayerOpacity, 0.1);
  expect(theme.pressedStateLayerOpacity, 0.1);
  expect(theme.disabledTrackOpacity, 0.12);
  expect(theme.disabledThumbOpacity, 0.38);
  expect(theme.disabledSelectedHandleOpacity, 1);

  expect(
    theme.thumbColor(scheme, enabled: true, value: true, pressed: true),
    scheme.primaryContainer,
  );
  expect(
    theme.thumbColor(scheme, enabled: true, value: false, hovered: true),
    scheme.onSurfaceVariant,
  );
  expect(
    theme.thumbColor(scheme, enabled: true, value: true),
    scheme.onPrimary,
  );
  expect(theme.thumbColor(scheme, enabled: false, value: true), scheme.surface);
  expect(theme.iconColor(scheme, value: true), scheme.primary);
  expect(
    theme.iconColor(scheme, value: false, enabled: false),
    M3EColorUtils.withOpacity(scheme.surfaceContainerHighest, 0.38),
  );
  expect(theme.resolveFocusIndicatorColor(scheme), scheme.secondary);
}

Future<void> _controlIsA48dpTargetAroundA52dpTrack(WidgetTester tester) async {
  await tester.pumpWidget(_host(M3ESwitch(value: false, onChanged: (_) {})));

  expect(tester.getSize(find.byType(M3ESwitch)), const Size(52, 48));
}

Future<void> _offHandleWithAnIconIs24dp(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      M3ESwitch(
        value: false,
        selectedIcon: const Icon(M3EIcons.check),
        unselectedIcon: const Icon(M3EIcons.close),
        onChanged: (_) {},
      ),
    ),
  );

  final handle = find.byWidgetPredicate((Widget widget) {
    if (widget is! SizedBox) {
      return false;
    }
    return widget.width == 24 && widget.height == 24;
  });
  expect(handle, findsOneWidget);
  expect(tester.getSize(handle), const Size(24, 24));
}

Future<void> _dragPastTheMidpointTogglesOn(WidgetTester tester) async {
  var value = false;

  await tester.pumpWidget(
    _host(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return M3ESwitch(
            value: value,
            onChanged: (bool next) => setState(() => value = next),
          );
        },
      ),
    ),
  );

  await tester.drag(find.byType(M3ESwitch), const Offset(40, 0));
  await tester.pumpAndSettle();
  expect(value, isTrue);
}

Future<void> _spaceTogglesTheFocusedSwitch(WidgetTester tester) async {
  var value = false;

  await tester.pumpWidget(
    _host(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return M3ESwitch(
            value: value,
            onChanged: (bool next) => setState(() => value = next),
          );
        },
      ),
    ),
  );

  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.space);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.space);
  await tester.pump(const Duration(milliseconds: 150));
  expect(value, isTrue);
}

Future<void> _semanticsExposeAToggledSwitch(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(M3ESwitch(value: true, semanticLabel: 'Wi-Fi', onChanged: (_) {})),
  );

  final node = tester.getSemantics(find.byType(M3ETappable));
  expect(node.flagsCollection.isToggled, Tristate.isTrue);
  expect(node.flagsCollection.isButton, isFalse);
  expect(node.label, contains('Wi-Fi'));
}
