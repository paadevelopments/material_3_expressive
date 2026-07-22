import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/carousel/components/m3e_carousel_view.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

List<Widget> _items(int count) {
  return <Widget>[
    for (int i = 0; i < count; i++)
      ColoredBox(
        color: Colors.blue,
        child: Center(child: Text('item$i')),
      ),
  ];
}

void main() {
  testWidgets(
    'hero center keeps leading item onstage after light/dark toggle',
    (tester) async {
      final light = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
      final dark = light.deriveDarkTemplate();
      var data = light;
      late void Function(void Function()) setHostState;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setHostState = setState;
            return MaterialApp(
              home: M3ETheme(
                data: data,
                child: Center(
                  child: SizedBox(
                    width: 400,
                    height: 200,
                    child: M3ECarousel(children: _items(6)),
                  ),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('item0'), findsOneWidget);
      expect(find.text('item1'), findsOneWidget);
      final Offset before = tester.getTopLeft(find.text('item0'));

      setHostState(() => data = dark);
      await tester.pumpAndSettle();

      expect(find.text('item0'), findsOneWidget);
      expect(find.text('item1'), findsOneWidget);
      expect(tester.getTopLeft(find.text('item0')), before);
    },
  );

  testWidgets(
    'weighted view with consumeMaxWeight false keeps item0 after theme toggle',
    (tester) async {
      final light = M3EThemeData.light(seedColor: const Color(0xFF6750A4));
      final dark = light.deriveDarkTemplate();
      var data = light;
      late void Function(void Function()) setHostState;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            setHostState = setState;
            return MaterialApp(
              home: M3ETheme(
                data: data,
                child: Center(
                  child: SizedBox(
                    width: 400,
                    height: 200,
                    child: M3ECarouselView.weighted(
                      consumeMaxWeight: false,
                      flexWeights: const [2, 6, 2],
                      children: _items(6),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('item0'), findsOneWidget);

      setHostState(() => data = dark);
      await tester.pumpAndSettle();
      expect(find.text('item0'), findsOneWidget);
    },
  );
}
