import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const String _save = 'Save';
const String _one = 'One';
const String _two = 'Two';

Widget _host(Widget child) => MaterialApp(
  home: Scaffold(body: Center(child: child)),
);

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
      // InkResponse (material_ui) resolves and bakes a highlight's color
      // in once, at creation time, from the *full* combined state set
      // active at that instant — not just the state the highlight
      // represents. A tap always requests focus while hover/press are
      // still active (see _effectiveOnPressed), so the moment the focus
      // highlight is first created, the states set can legitimately be
      // {hovered, pressed, focused} all at once. If that combination ever
      // resolves to a real color, the focus highlight — which stays
      // active until focus is lost, not until hover/press clear — bakes
      // in a stray tint that outlives the click and the hover, only
      // clearing once something else takes focus.
      final variants = <String, Widget Function(VoidCallback)>{
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

      for (final MapEntry<String, Widget Function(VoidCallback)> entry
          in variants.entries) {
        await tester.pumpWidget(_host(entry.value(() {})));
        await tester.pump();

        final ButtonStyleButton materialButton = tester
            .widget<ButtonStyleButton>(
              find.byWidgetPredicate((Widget w) => w is ButtonStyleButton),
            );
        final WidgetStateProperty<Color?>? overlay =
            materialButton.style?.overlayColor;
        expect(overlay, isNotNull, reason: '${entry.key} has no overlayColor');

        for (final states in <Set<WidgetState>>[
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
            reason: '${entry.key} baked a fill in for $states',
          );
        }

        final Color? hoverOnly = overlay!.resolve(<WidgetState>{
          WidgetState.hovered,
        });
        expect(
          hoverOnly,
          isNotNull,
          reason: '${entry.key} lost its plain hover fill',
        );
        expect(
          hoverOnly,
          isNot(Colors.transparent),
          reason: '${entry.key} lost its plain hover fill',
        );
      }
    },
  );

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
