import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers/carousel_test_helpers.dart';

void main() {
  testWidgets('gradient scrim fades into the scheme scrim', _gradientScrim);
}

List<M3ECarouselItem> _scrimItems(M3ECarouselScrim scrim) {
  return <M3ECarouselItem>[
    for (int i = 0; i < 4; i++)
      M3ECarouselItem(
        onTap: enableCarouselItem,
        showScrim: scrim,
        image: const ColoredBox(color: Color(0xFF112233)),
      ),
  ];
}

Iterable<Gradient> _scrimGradients(WidgetTester tester) {
  return tester
      .widgetList<DecoratedBox>(find.byType(DecoratedBox))
      .map((DecoratedBox box) => box.decoration)
      .whereType<BoxDecoration>()
      .map((BoxDecoration d) => d.gradient)
      .whereType<Gradient>();
}

Future<void> _gradientScrim(WidgetTester tester) async {
  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(children: _scrimItems(const M3ECarouselScrim.gradient())),
    ),
  );
  await tester.pump();
  expect(tester.takeException(), isNull);

  final Color scrim = M3ETheme.of(tester.element(find.byType(M3ECarousel)))
      .colorScheme
      .scrim;
  final defaults = _scrimGradients(tester);
  expect(defaults, isNotEmpty);
  final fade = defaults.first as LinearGradient;
  expect(fade.begin, Alignment.topCenter);
  expect(fade.end, Alignment.bottomCenter);
  expect(fade.colors.first, scrim.withValues(alpha: 0));
  expect(
    fade.colors.last,
    scrim.withValues(alpha: M3ECarouselScrim.defaultGradientEndOpacity),
  );

  const custom = RadialGradient(
    colors: <Color>[Color(0x00000000), Color(0x80FF0000)],
  );
  await tester.pumpWidget(
    hostCarousel(
      M3ECarousel(
        children: _scrimItems(
          const M3ECarouselScrim.gradient(gradient: custom, opacity: 0.5),
        ),
      ),
    ),
  );
  await tester.pump();
  expect(_scrimGradients(tester), everyElement(custom));
  expect(find.byType(Opacity), findsWidgets);
}
