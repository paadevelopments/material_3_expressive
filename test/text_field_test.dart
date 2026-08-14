import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

void main() {
  testWidgets(
    'M3ETextField keeps a stable size when focus changes',
    _m3etextfieldKeepsAStableSizeWhenFocusChanges,
  );
  testWidgets(
    'M3ETextField grows for multi-line values',
    _m3etextfieldGrowsForMultiLineValues,
  );
  testWidgets(
    'M3ETextField centers the label until it floats',
    _m3etextfieldCentersTheLabelUntilItFloats,
  );
  testWidgets(
    'M3ETextField centers the input when there is no label',
    _m3etextfieldCentersTheInputWhenThereIsNoLabel,
  );
  testWidgets(
    'M3ETextField unfocuses on tap outside by default',
    _m3etextfieldUnfocusesOnTapOutsideByDefault,
  );
  testWidgets(
    'M3ESearchBar unfocuses on tap outside by default',
    _m3esearchbarUnfocusesOnTapOutsideByDefault,
  );
}

Future<void> _m3etextfieldKeepsAStableSizeWhenFocusChanges(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: const Scaffold(
        body: Center(
          child: M3ETextField(
            label: 'Name',
            variant: M3ETextFieldVariant.outlined,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Finder field = find.byType(M3ETextField);
  final Size restingSize = tester.getSize(field);

  await tester.tap(field);
  await tester.pumpAndSettle();
  expect(tester.getSize(field), restingSize);

  await tester.tapAt(const Offset(20, 300));
  await tester.pumpAndSettle();
  expect(tester.getSize(field), restingSize);
}

Future<void> _m3etextfieldGrowsForMultiLineValues(WidgetTester tester) async {
  final controller = TextEditingController(
    text: 'A rather long value that has to wrap onto several separate lines.',
  );

  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            const SizedBox(width: 200, child: M3ETextField(label: 'Single')),
            SizedBox(
              width: 200,
              child: M3ETextField(
                label: 'Multi',
                maxLines: 3,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final double singleLine = tester
      .getSize(find.byType(M3ETextField).first)
      .height;
  final double multiLine = tester
      .getSize(find.byType(M3ETextField).last)
      .height;
  expect(multiLine, greaterThan(singleLine));
}

Future<void> _m3etextfieldCentersTheLabelUntilItFloats(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: const Scaffold(
        body: Center(child: M3ETextField(label: 'Name')),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Rect field = tester.getRect(find.byType(M3ETextField));
  expect(
    tester.getRect(find.text('Name')).center.dy,
    closeTo(field.center.dy, 1),
  );

  await tester.tap(find.byType(M3ETextField));
  await tester.pumpAndSettle();
  expect(
    tester.getRect(find.text('Name')).center.dy,
    lessThan(field.center.dy - 4),
  );
}

Future<void> _m3etextfieldCentersTheInputWhenThereIsNoLabel(
  WidgetTester tester,
) async {
  final controller = TextEditingController(text: 'Value');
  addTearDown(controller.dispose);

  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: Center(child: M3ETextField(controller: controller)),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final Rect field = tester.getRect(find.byType(M3ETextField));
  final Rect input = tester.getRect(find.byType(EditableText));
  expect(input.center.dy, closeTo(field.center.dy, 1));
}

Future<void> _m3etextfieldUnfocusesOnTapOutsideByDefault(
  WidgetTester tester,
) async {
  final focusNode = FocusNode();

  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            M3ETextField(focusNode: focusNode, label: 'Name'),
            const Expanded(child: ColoredBox(color: Color(0xFFE0E0E0))),
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
}

Future<void> _m3esearchbarUnfocusesOnTapOutsideByDefault(
  WidgetTester tester,
) async {
  final focusNode = FocusNode();

  await tester.pumpWidget(
    M3EMaterialApp(
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      home: Scaffold(
        body: Column(
          children: <Widget>[
            M3ESearchBar(focusNode: focusNode, hintText: 'Search'),
            const Expanded(child: ColoredBox(color: Color(0xFFE0E0E0))),
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
}
