import 'dart:ui' show Tristate;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart'
    hide CornerRounding, RoundedPolygon;

Widget _app(Widget child) {
  return M3EMaterialApp(
    data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
    home: Scaffold(body: Center(child: child)),
  );
}

SemanticsNode _node(WidgetTester tester) {
  return tester.getSemantics(find.bySemanticsLabel('More'));
}

void main() {
  testWidgets('disabled icon button reports a disabled state', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        const M3EIconButton(icon: Icon(Icons.more_vert), semanticLabel: 'More'),
      ),
    );

    final SemanticsNode node = _node(tester);
    expect(node.flagsCollection.isEnabled, Tristate.isFalse);
    handle.dispose();
  });

  testWidgets('enabled icon button reports an enabled state', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        M3EIconButton(
          icon: const Icon(Icons.more_vert),
          semanticLabel: 'More',
          onPressed: () {},
        ),
      ),
    );

    final SemanticsNode node = _node(tester);
    expect(node.flagsCollection.isEnabled, Tristate.isTrue);
    handle.dispose();
  });

  testWidgets('a plain icon button is not a selectable control', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        M3EIconButton(
          icon: const Icon(Icons.more_vert),
          semanticLabel: 'More',
          onPressed: () {},
        ),
      ),
    );

    final SemanticsNode node = _node(tester);
    expect(node.flagsCollection.isSelected, Tristate.none);
    handle.dispose();
  });

  testWidgets('a toggle icon button keeps its selected state', (
    WidgetTester tester,
  ) async {
    final SemanticsHandle handle = tester.ensureSemantics();
    await tester.pumpWidget(
      _app(
        M3EIconButton(
          icon: const Icon(Icons.star_outline),
          selectedIcon: const Icon(Icons.star),
          isSelected: false,
          semanticLabel: 'More',
          onPressed: () {},
        ),
      ),
    );

    final SemanticsNode node = _node(tester);
    expect(node.flagsCollection.isSelected, Tristate.isFalse);
    handle.dispose();
  });
}
