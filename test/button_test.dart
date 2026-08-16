import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/toggle_button_group/models/m3e_button_group_action.dart';
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

  testWidgets(
    'fitting scroll overflow keeps offset at 0 when selectedIndex changes',
    (tester) async {
      var selectedIndex = 0;

      Widget buildGroup() {
        return _themeHost(
          SizedBox(
            width: 400,
            child: M3EButtonGroup(
              selectedIndex: selectedIndex,
              onSelectedIndexChanged: (int? index) {
                selectedIndex = index ?? selectedIndex;
              },
              actions: const <M3EButtonGroupAction>[
                M3EButtonGroupAction(label: Text(_one)),
                M3EButtonGroupAction(label: Text(_two)),
              ],
            ),
          ),
        );
      }

      await tester.pumpWidget(buildGroup());
      await tester.pumpAndSettle();

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      final fittedView = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(fittedView.physics, isA<NeverScrollableScrollPhysics>());
      expect(fittedView.clipBehavior, Clip.none);

      final ScrollableState scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable),
      );
      expect(scrollable.position.pixels, 0);
      expect(scrollable.position.maxScrollExtent, 0);

      selectedIndex = 1;
      await tester.pumpWidget(buildGroup());
      await tester.pumpAndSettle();

      expect(find.text(_one), findsWidgets);
      expect(find.text(_two), findsWidgets);
      expect(
        tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels,
        0,
      );
      expect(
        tester
            .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
            .physics,
        isA<NeverScrollableScrollPhysics>(),
      );
    },
  );

  testWidgets(
    'overflowing scroll overflow keeps offset when selectedIndex changes',
    (tester) async {
      const longA = 'AAAAAAAAAAAAAAAA';
      const longB = 'BBBBBBBBBBBBBBBB';
      var selectedIndex = 0;

      Widget buildGroup() {
        return _themeHost(
          SizedBox(
            width: 120,
            child: M3EButtonGroup(
              selectedIndex: selectedIndex,
              onSelectedIndexChanged: (int? index) {
                selectedIndex = index ?? selectedIndex;
              },
              actions: const <M3EButtonGroupAction>[
                M3EButtonGroupAction(label: Text(longA)),
                M3EButtonGroupAction(label: Text(longB)),
              ],
            ),
          ),
        );
      }

      await tester.pumpWidget(buildGroup());
      await tester.pumpAndSettle();

      final ScrollableState scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable),
      );
      expect(scrollable.position.maxScrollExtent, greaterThan(0));
      expect(
        tester
            .widget<SingleChildScrollView>(find.byType(SingleChildScrollView))
            .physics,
        isNot(isA<NeverScrollableScrollPhysics>()),
      );

      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(-48, 0),
      );
      await tester.pumpAndSettle();
      final offset = scrollable.position.pixels;
      expect(offset, greaterThan(0));

      selectedIndex = 1;
      await tester.pumpWidget(buildGroup());
      await tester.pumpAndSettle();

      expect(
        tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels,
        offset,
      );
    },
  );
}

Widget _themeHost(Widget child) => MaterialApp(
  home: M3ETheme(
    data: M3EThemeData.light(),
    child: Scaffold(body: Center(child: child)),
  ),
);
