import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  testWidgets('M3ETextField keeps a stable height when focus changes',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        home: Scaffold(
          body: Center(
            child: M3ETextField(label: 'Name'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Finder field = find.byType(M3ETextField);
    final double restingHeight = tester.getSize(field).height;

    await tester.tap(field);
    await tester.pumpAndSettle();
    expect(tester.getSize(field).height, restingHeight);

    await tester.tapAt(const Offset(20, 300));
    await tester.pumpAndSettle();
    expect(tester.getSize(field).height, restingHeight);
  });

  testWidgets('M3ETextField unfocuses on tap outside by default',
      (WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();

    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              M3ETextField(
                focusNode: focusNode,
                label: 'Name',
              ),
              const Expanded(
                child: ColoredBox(color: Color(0xFFE0E0E0)),
              ),
            ],
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.tapAt(const Offset(20, 300));
    await tester.pump();
    expect(focusNode.hasFocus, isFalse);
  });

  testWidgets('M3ESearchBar unfocuses on tap outside by default',
      (WidgetTester tester) async {
    final FocusNode focusNode = FocusNode();

    await tester.pumpWidget(
      M3EMaterialApp(
        data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
        home: Scaffold(
          body: Column(
            children: <Widget>[
              M3ESearchBar(
                focusNode: focusNode,
                hintText: 'Search',
              ),
              const Expanded(
                child: ColoredBox(color: Color(0xFFE0E0E0)),
              ),
            ],
          ),
        ),
      ),
    );

    focusNode.requestFocus();
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);

    await tester.tapAt(const Offset(20, 300));
    await tester.pump();
    expect(focusNode.hasFocus, isFalse);
  });
}
