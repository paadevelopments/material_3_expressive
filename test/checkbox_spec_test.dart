import 'dart:ui' show CheckedState;

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
  test('theme defaults match the checkbox spec', () {
    const theme = M3ECheckboxTheme.defaults;
    final scheme = M3EThemeData.light().colorScheme;

    expect(theme.boxSize, 18);
    expect(theme.markSize, 18);
    expect(theme.hitSize, 40);
    expect(theme.targetSize, 48);
    expect(theme.borderWidth, 2);
    expect(theme.selectedOutlineWidth, 0);
    expect(theme.borderRadius, const BorderRadius.all(Radius.circular(2)));
    expect(theme.disabledOpacity, 0.38);
    expect(theme.hoverStateLayerOpacity, 0.08);
    expect(theme.focusStateLayerOpacity, 0.1);
    expect(theme.pressedStateLayerOpacity, 0.1);
    expect(theme.focusIndicatorThickness, 3);
    expect(theme.focusIndicatorOffset, 2);
    expect(theme.resolveFocusIndicatorColor(scheme), scheme.secondary);

    expect(
      theme.borderColor(scheme, enabled: true, active: false, error: false),
      scheme.onSurfaceVariant,
    );
    expect(
      theme.borderColor(
        scheme,
        enabled: true,
        active: false,
        error: false,
        hovered: true,
      ),
      scheme.onSurface,
    );
    expect(
      theme.stateLayerColor(scheme, active: false, error: false, pressed: true),
      scheme.primary,
    );
    expect(
      theme.stateLayerColor(scheme, active: true, error: false, pressed: true),
      scheme.onSurface,
    );
    expect(
      theme.stateLayerColor(scheme, active: true, error: false),
      scheme.primary,
    );
    expect(
      theme.fillColor(scheme, enabled: true, active: true, error: true),
      scheme.error,
    );
    expect(theme.markColor(scheme, error: false), scheme.onPrimary);
    expect(theme.markColor(scheme, error: true), scheme.onError);
    expect(
      theme.markColor(scheme, error: false, enabled: false),
      scheme.surface,
    );
    expect(theme.outlineWidth(active: true), 0);
    expect(theme.outlineWidth(active: false), 2);
    expect(theme.checkIconPadding, EdgeInsets.zero);
  });

  testWidgets('control is a 48dp target with an 18dp icon and 2dp corners', (
    tester,
  ) async {
    await tester.pumpWidget(_host(M3ECheckbox(value: true, onChanged: (_) {})));

    expect(tester.getSize(find.byType(M3ECheckbox)), const Size(48, 48));

    final Icon icon = tester.widget(find.byIcon(M3EIcons.check));
    expect(icon.size, 18);

    final box = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final decoration = box.decoration! as BoxDecoration;
    expect(decoration.borderRadius, const BorderRadius.all(Radius.circular(2)));
    final border = decoration.border! as Border;
    expect(border.top.width, 0);

    final M3EFocusRing ring = tester.widget(find.byType(M3EFocusRing));
    expect(ring.width, 3);
    expect(ring.gap, 2);

    final Container layer = tester.widget(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration! as BoxDecoration).shape == BoxShape.circle,
      ),
    );
    expect(tester.getSize(find.byWidget(layer)), const Size(40, 40));
  });

  testWidgets('unselected outline is 2dp', (tester) async {
    await tester.pumpWidget(
      _host(M3ECheckbox(value: false, onChanged: (_) {})),
    );

    final box = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final decoration = box.decoration! as BoxDecoration;
    final border = decoration.border! as Border;
    expect(border.top.width, 2);
  });

  testWidgets('disabled selected icon uses surface', (tester) async {
    final Color surface = M3EThemeData.light(seedColor: const Color(0xFF6750A4))
        .colorScheme
        .surface;

    await tester.pumpWidget(
      _host(const M3ECheckbox(value: true, onChanged: null)),
    );

    final Icon icon = tester.widget(find.byIcon(M3EIcons.check));
    expect(icon.color, surface);
  });

  testWidgets('tapping the control or the label toggles once', (tester) async {
    var value = false;
    var taps = 0;

    Widget checkbox() {
      return _host(
        M3ECheckbox(
          value: value,
          label: const Text('Pickles'),
          onChanged: (bool? next) {
            taps += 1;
            value = next ?? false;
          },
        ),
      );
    }

    await tester.pumpWidget(checkbox());
    await tester.tap(find.byType(M3ECheckbox));
    await tester.pumpWidget(checkbox());
    expect(taps, 1);
    expect(value, isTrue);

    await tester.tap(find.text('Pickles'));
    await tester.pumpWidget(checkbox());
    expect(taps, 2);
    expect(value, isFalse);
  });

  testWidgets('semantics expose checkbox checked, mixed, and the label', (
    tester,
  ) async {
    await tester.pumpWidget(
      _host(
        M3ECheckbox(
          value: true,
          label: const Text('Pickles'),
          onChanged: (_) {},
        ),
      ),
    );

    final checked = tester.getSemantics(find.byType(M3ETappable));
    expect(checked.flagsCollection.isChecked, CheckedState.isTrue);
    expect(checked.label, contains('Pickles'));
    expect(checked.flagsCollection.isButton, isFalse);

    await tester.pumpWidget(
      _host(M3ECheckbox(value: null, tristate: true, onChanged: (_) {})),
    );
    final mixed = tester.getSemantics(find.byType(M3ETappable));
    expect(mixed.flagsCollection.isChecked, CheckedState.mixed);
  });

  testWidgets('pointer tap clears the focus ring', (tester) async {
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        home: const Scaffold(
          body: Column(
            children: <Widget>[
              M3ECheckbox(value: false, onChanged: _noop),
              Expanded(child: SizedBox.expand()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    M3EFocusInteraction.resetForTest();
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() {
      M3EFocusInteraction.resetForTest();
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic;
    });

    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(_ringVisible(tester), isTrue);

    await tester.tap(find.byType(M3ECheckbox));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(_ringVisible(tester), isFalse);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(_ringVisible(tester), isTrue);

    await tester.tapAt(const Offset(24, 520));
    await tester.pump();
    await tester.pumpAndSettle();
    expect(_ringVisible(tester), isFalse);
  });
}

void _noop(bool? _) {}

bool _ringVisible(WidgetTester tester) {
  return tester
      .widgetList<M3EFocusRing>(find.byType(M3EFocusRing))
      .any((M3EFocusRing ring) => ring.focused);
}
