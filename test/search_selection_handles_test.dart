import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

final TargetPlatformVariant _touch = TargetPlatformVariant.only(
  TargetPlatform.android,
)..values.add(TargetPlatform.iOS);

void main() {
  testWidgets(
    'M3ESearchBar selects a word and shows handles after a long press',
    _longPressSelects,
    variant: _touch,
  );
  testWidgets(
    'M3ESearchBar shows the caret handle after a tap on text',
    _tapShowsHandle,
    variant: _touch,
  );
  testWidgets(
    'M3ESearchBar hides handles for a mouse click',
    _mouseHidesHandles,
    variant: _touch,
  );
}

Widget _host(TextEditingController controller) {
  return M3EMaterialApp(
    data: M3EThemeData.light(),
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: M3ESearchBar(controller: controller, hintText: 'Search'),
        ),
      ),
    ),
  );
}

bool _handlesVisible(WidgetTester tester) {
  final EditableTextState state = tester.state<EditableTextState>(
    find.byType(EditableText),
  );
  return state.selectionOverlay?.handlesAreVisible ?? false;
}

Future<void> _longPressSelects(WidgetTester tester) async {
  final controller = TextEditingController(text: 'hello world');
  addTearDown(controller.dispose);
  await tester.pumpWidget(_host(controller));
  await tester.longPress(find.byType(EditableText));
  await tester.pumpAndSettle();
  expect(controller.selection.isCollapsed, isFalse);
  expect(_handlesVisible(tester), isTrue);
}

Future<void> _tapShowsHandle(WidgetTester tester) async {
  final controller = TextEditingController(text: 'hello world');
  addTearDown(controller.dispose);
  await tester.pumpWidget(_host(controller));
  await tester.tap(find.byType(EditableText));
  await tester.pumpAndSettle();
  expect(_handlesVisible(tester), isTrue);
}

Future<void> _mouseHidesHandles(WidgetTester tester) async {
  final controller = TextEditingController(text: 'hello world');
  addTearDown(controller.dispose);
  await tester.pumpWidget(_host(controller));
  await tester.tap(find.byType(EditableText), kind: PointerDeviceKind.mouse);
  await tester.pumpAndSettle();
  expect(_handlesVisible(tester), isFalse);
}
