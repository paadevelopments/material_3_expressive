import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

const String _save = 'Save';
const String _one = 'One';
const String _two = 'Two';

Widget _host(Widget child) =>
    MaterialApp(home: Scaffold(body: Center(child: child)));

void main() {
  testWidgets('M3EButton renders its child and fires onPressed', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        M3EButton(
          onPressed: () => taps++,
          child: const Text(_save),
        ),
      ),
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
