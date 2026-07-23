import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(),
    home: Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(size: Size(800, 600)),
        child: Center(child: child),
      ),
    ),
  );
}

void main() {
  testWidgets('M3EMenu opens and dismisses on scrim tap', (tester) async {
    await tester.pumpWidget(
      _host(
        M3EMenu(
          anchorBuilder: (BuildContext context, VoidCallback open) {
            return TextButton(onPressed: open, child: const Text('Open'));
          },
          children: const <M3EMenuNode>[
            M3EMenuEntry(label: 'One'),
            M3EMenuEntry(label: 'Two'),
          ],
        ),
      ),
    );

    expect(find.text('One'), findsNothing);

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('One'), findsNothing);
  });

  testWidgets('M3EMenu entry onPressed fires and closes', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      _host(
        M3EMenu(
          anchorBuilder: (BuildContext context, VoidCallback open) {
            return TextButton(onPressed: open, child: const Text('Open'));
          },
          children: <M3EMenuNode>[
            M3EMenuEntry(
              label: 'Action',
              onPressed: () => pressed = true,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Action'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(pressed, isTrue);
    expect(find.text('Action'), findsNothing);
  });

  testWidgets('showM3EMenu returns selectable value', (tester) async {
    Object? selected;

    await tester.pumpWidget(
      _host(
        Builder(
          builder: (BuildContext context) {
            return TextButton(
              onPressed: () async {
                final buttonBox = context.findRenderObject()! as RenderBox;
                selected = await showM3EMenu<String>(
                  context: context,
                  anchor:
                      buttonBox.localToGlobal(Offset.zero) & buttonBox.size,
                  children: const <M3EMenuNode>[
                    M3EMenuSelectable(label: 'Alpha', value: 'a'),
                    M3EMenuSelectable(label: 'Beta', value: 'b'),
                  ],
                );
              },
              child: const Text('Show'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Show'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Beta'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(selected, 'b');
  });

  testWidgets('disabled menu entry is not tappable', (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      _host(
        M3EMenu(
          anchorBuilder: (BuildContext context, VoidCallback open) {
            return TextButton(onPressed: open, child: const Text('Open'));
          },
          children: <M3EMenuNode>[
            M3EMenuEntry(
              label: 'Nope',
              enabled: false,
              onPressed: () => pressed = true,
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.text('Nope'));
    await tester.pump();

    expect(pressed, isFalse);
    expect(find.text('Nope'), findsOneWidget);
  });
}
