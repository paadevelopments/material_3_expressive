import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/segmented_buttons/components/m3e_segment_divider.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

const LinearGradient _g = LinearGradient(
  colors: <Color>[Color(0xFF6750A4), Color(0xFF9A82DB)],
);

void main() {
  testWidgets('segmented divider paints with a real size', (
    WidgetTester tester,
  ) async {
    Set<int> selected = <int>{0};
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        home: Builder(
          builder: (BuildContext context) {
            final M3EThemeData theme = M3ETheme.of(context);
            return M3ETheme(
              data: theme.copyWith(
                segmentedButtonTheme: theme.segmentedButtonTheme.copyWith(
                  outlineGradient: _g,
                  dividerGradient: _g,
                  selectedBackgroundGradient: _g,
                  selectedForegroundGradient: _g,
                ),
              ),
              child: Scaffold(
                body: Center(
                  child: M3ESegmentedButton<int>(
                    selected: selected,
                    onSelectionChanged: (Set<int> v) => selected = v,
                    segments: const <M3ESegment<int>>[
                      M3ESegment<int>(value: 0, label: 'Day'),
                      M3ESegment<int>(value: 1, label: 'Week'),
                      M3ESegment<int>(value: 2, label: 'Month'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Finder dividers = find.byType(M3ESegmentDivider);
    expect(dividers, findsNWidgets(2));
    for (final Element e in dividers.evaluate()) {
      final Size size = (e.findRenderObject()! as RenderBox).size;
      expect(size.width, 1);
      expect(size.height, greaterThan(30));
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('dividers sample the gradient across the group', (
    WidgetTester tester,
  ) async {
    final GlobalKey boundaryKey = GlobalKey();
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        home: Builder(
          builder: (BuildContext context) {
            final M3EThemeData theme = M3ETheme.of(context);
            return M3ETheme(
              data: theme.copyWith(
                segmentedButtonTheme: theme.segmentedButtonTheme.copyWith(
                  dividerGradient: _g,
                ),
              ),
              child: Scaffold(
                body: Center(
                  child: RepaintBoundary(
                    key: boundaryKey,
                    child: M3ESegmentedButton<int>(
                      selected: const <int>{0},
                      onSelectionChanged: (Set<int> v) {},
                      segments: const <M3ESegment<int>>[
                        M3ESegment<int>(value: 0, label: 'Day'),
                        M3ESegment<int>(value: 1, label: 'Week'),
                        M3ESegment<int>(value: 2, label: 'Month'),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    final RenderRepaintBoundary boundary =
        tester.renderObject(find.byKey(boundaryKey)) as RenderRepaintBoundary;
    final Offset origin = boundary.localToGlobal(Offset.zero);
    final List<Offset> centers = find
        .byType(M3ESegmentDivider)
        .evaluate()
        .map((Element e) => tester.getCenter(find.byWidget(e.widget)) - origin)
        .toList();

    final ui.Image image = await boundary.toImage();
    final ByteData bytes = (await image.toByteData())!;
    int redAt(Offset p) {
      final int i = ((p.dy.floor() * image.width) + p.dx.floor()) * 4;
      return bytes.getUint8(i);
    }

    final int first = redAt(centers.first);
    final int second = redAt(centers.last);
    expect((first - second).abs(), greaterThan(10));
  });

  testWidgets('fab menu items render with gradients', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        home: Builder(
          builder: (BuildContext context) {
            final M3EThemeData theme = M3ETheme.of(context);
            return M3ETheme(
              data: theme.copyWith(
                fabMenuTheme: theme.fabMenuTheme.copyWith(
                  itemBackgroundGradient: _g,
                  itemForegroundGradient: _g,
                  itemOutlineGradient: _g,
                ),
              ),
              child: Scaffold(
                body: Align(
                  alignment: Alignment.bottomRight,
                  child: M3EFabMenu(
                    decoration: M3EFabDecoration(
                      backgroundGradient: WidgetStateProperty.all(_g),
                      foregroundGradient: WidgetStateProperty.all(_g),
                      outlineGradient: WidgetStateProperty.all(_g),
                    ),
                    items: <M3EFabMenuItem>[
                      M3EFabMenuItem(
                        icon: const Icon(M3EIcons.image),
                        label: 'Image',
                        onPressed: () {},
                      ),
                      M3EFabMenuItem(
                        icon: const Icon(M3EIcons.mic),
                        label: 'Audio',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(M3EFab));
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Image'), findsOneWidget);
    expect(find.text('Audio'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
