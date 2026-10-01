import 'package:flutter/gestures.dart' show PointerDeviceKind;
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const String _save = 'Save';
const String _one = 'One';
const String _two = 'Two';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

/// One [M3EButton] constructor per variant, keyed by name for failure
/// messages.
Map<String, Widget Function(VoidCallback)> _buttonVariants() {
  return <String, Widget Function(VoidCallback)>{
    'filled': (onPressed) =>
        M3EButton.filled(onPressed: onPressed, child: const Text(_save)),
    'tonal': (onPressed) =>
        M3EButton.tonal(onPressed: onPressed, child: const Text(_save)),
    'elevated': (onPressed) =>
        M3EButton.elevated(onPressed: onPressed, child: const Text(_save)),
    'outlined': (onPressed) =>
        M3EButton.outlined(onPressed: onPressed, child: const Text(_save)),
    'text': (onPressed) =>
        M3EButton.text(onPressed: onPressed, child: const Text(_save)),
  };
}

/// InkResponse (material_ui) bakes a highlight's color in once, from the
/// full state set active at creation. Hover and focus resolve with the same
/// set, so any ink overlay color either sticks after a click or hides hover
/// while the button is focused. The ink overlay must stay transparent for
/// every state; the hover layer is painted from live states instead.
Future<void> _expectNoBakedFill(
  WidgetTester tester,
  String variantName,
  Widget button,
) async {
  await tester.pumpWidget(_host(button));
  await tester.pump();

  final ButtonStyleButton materialButton = tester.widget<ButtonStyleButton>(
    find.byWidgetPredicate((Widget w) => w is ButtonStyleButton),
  );
  final WidgetStateProperty<Color?>? overlay =
      materialButton.style?.overlayColor;
  expect(overlay, isNotNull, reason: '$variantName has no overlayColor');

  for (final states in <Set<WidgetState>>[
    <WidgetState>{WidgetState.hovered},
    <WidgetState>{WidgetState.focused},
    <WidgetState>{WidgetState.pressed},
    <WidgetState>{WidgetState.hovered, WidgetState.focused},
    <WidgetState>{WidgetState.hovered, WidgetState.pressed},
    <WidgetState>{
      WidgetState.hovered,
      WidgetState.pressed,
      WidgetState.focused,
    },
  ]) {
    expect(
      overlay!.resolve(states),
      Colors.transparent,
      reason: '$variantName baked a fill in for $states',
    );
  }
}

/// Opaque-ish fill painted by the button's live state layer, if any.
Color _stateLayer(WidgetTester tester) {
  final Iterable<ColoredBox> boxes = tester.widgetList<ColoredBox>(
    find.descendant(
      of: find.byType(TweenAnimationBuilder<Color?>),
      matching: find.byType(ColoredBox),
    ),
  );
  return boxes.isEmpty ? Colors.transparent : boxes.first.color;
}

/// Hover shows after a click focused the button, and clears on exit.
Future<void> _hoverAfterTap(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(M3EButton.text(onPressed: () {}, child: const Text(_save))),
  );
  final Offset center = tester.getCenter(find.text(_save));
  final TestGesture mouse = await tester.createGesture(
    kind: PointerDeviceKind.mouse,
  );
  addTearDown(mouse.removePointer);
  await mouse.addPointer(location: Offset.zero);
  await mouse.moveTo(center);
  await tester.pumpAndSettle();
  expect(_stateLayer(tester).a, greaterThan(0));

  await mouse.down(center);
  await mouse.up();
  await mouse.moveTo(Offset.zero);
  await tester.pumpAndSettle();
  expect(_stateLayer(tester).a, 0, reason: 'fill stuck after the click');

  await mouse.moveTo(center);
  await tester.pumpAndSettle();
  expect(
    _stateLayer(tester).a,
    greaterThan(0),
    reason: 'no hover when focused',
  );
}

/// Press shows while held and clears on release; keyboard focus shows a
/// layer, click focus does not.
Future<void> _pressAndFocus(WidgetTester tester) async {
  // Focus modality is process-wide; start clean of earlier pointer tests.
  M3EFocusInteraction.resetForTest();
  final node = FocusNode();
  addTearDown(node.dispose);
  await tester.pumpWidget(
    _host(
      M3EButton.text(
        focusNode: node,
        onPressed: () {},
        child: const Text(_save),
      ),
    ),
  );
  final TestGesture press = await tester.startGesture(
    tester.getCenter(find.text(_save)),
  );
  await tester.pumpAndSettle();
  expect(_stateLayer(tester).a, closeTo(0.1, 0.01), reason: 'no press layer');

  await press.up();
  await tester.pumpAndSettle();
  expect(node.hasFocus, isTrue);
  expect(_stateLayer(tester).a, 0, reason: 'press layer stuck after release');

  // A real Tab switches Flutter to keyboard highlight mode.
  node.unfocus();
  await tester.pump();
  await tester.sendKeyEvent(LogicalKeyboardKey.tab);
  await tester.pumpAndSettle();
  expect(node.hasPrimaryFocus, isTrue);
  expect(_stateLayer(tester).a, closeTo(0.1, 0.01), reason: 'no focus layer');

  M3EFocusInteraction.instance.notePointerInteraction(immediate: true);
  await tester.pumpAndSettle();
  expect(_stateLayer(tester).a, 0, reason: 'focus layer after pointer use');
}

void main() {
  testWidgets('M3EButton renders its child and fires onPressed', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(M3EButton(onPressed: () => taps++, child: const Text(_save))),
    );

    expect(find.text(_save), findsOneWidget);
    await tester.tap(find.text(_save));
    expect(taps, 1);
  });

  testWidgets('disabled M3EButton does not fire onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        M3EButton(
          onPressed: () => taps++,
          enabled: false,
          child: const Text(_save),
        ),
      ),
    );

    await tester.tap(find.text(_save), warnIfMissed: false);
    expect(taps, 0);
  });

  testWidgets(
    'overlay never bakes a hover color into the focus/pressed highlight',
    (tester) async {
      for (final MapEntry<String, Widget Function(VoidCallback)> entry
          in _buttonVariants().entries) {
        await _expectNoBakedFill(tester, entry.key, entry.value(() {}));
      }
    },
  );

  testWidgets('hover shows again after a click', _hoverAfterTap);
  testWidgets('press and keyboard focus layers never stick', _pressAndFocus);

  testWidgets('M3EButtonGroup renders each action label', (tester) async {
    await tester.pumpWidget(
      _host(
        const SizedBox(
          width: 400,
          child: M3EButtonGroup(
            actions: <M3EButtonGroupAction>[
              M3EButtonGroupAction(label: Text(_one)),
              M3EButtonGroupAction(label: Text(_two)),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // The connected/standard toggle group keeps offstage measurement copies of
    // each label (checked + unchecked states), so each label may appear more
    // than once in the tree.
    expect(find.text(_one), findsWidgets);
    expect(find.text(_two), findsWidgets);
  });
}
