import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/progress_indicators/components/m3e_linear_progress_painter.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

Widget _host(Widget child, {TextDirection textDirection = TextDirection.ltr}) {
  return MaterialApp(
    home: Directionality(
      textDirection: textDirection,
      child: M3ETheme(
        data: M3EThemeData.light(),
        child: Scaffold(
          body: Center(child: SizedBox(width: 200, child: child)),
        ),
      ),
    ),
  );
}

M3ELinearProgressPainter _linearPainter(WidgetTester tester) {
  final CustomPaint paint = tester.widget(
    find.descendant(
      of: find.byType(M3EProgressIndicator),
      matching: find.byType(CustomPaint),
    ),
  );
  return paint.painter! as M3ELinearProgressPainter;
}

void main() {
  _registerProgressThemeTests();
  _registerProgressSemanticsTests();
  _registerProgressPainterTests();
}

void _registerProgressThemeTests() {
  test('circular gap defaults to 4', _circularGapDefaultsTo4);
  test('linear trailingMargin is 4 for both sizes', _linearTrailingMarginIs4);
  test(
    'linear trackColor is secondaryContainer',
    _linearTrackColorIsSecondaryContainer,
  );
  testWidgets(
    'linear uses secondaryContainer track by default',
    _linearUsesSecondaryContainerTrackByDefault,
  );
}

void _registerProgressSemanticsTests() {
  testWidgets('exposes progressBar semantics', _exposesProgressBarSemantics);
  testWidgets(
    'indeterminate semantics use 0% and optional hint',
    _indeterminateSemanticsUse0AndOptionalHint,
  );
}

void _registerProgressPainterTests() {
  testWidgets(
    'RTL passes textDirection to linear painter',
    _rtlPassesTextDirectionToLinearPainter,
  );
  testWidgets(
    'showTrack false is passed to linear painter',
    _showTrackFalseIsPassedToLinearPainter,
  );
  testWidgets(
    'determinate linear draws with a stop size',
    _determinateLinearDrawsWithAStopSize,
  );
  testWidgets(
    'indeterminate linear has null value (no stop path)',
    _indeterminateLinearHasNullValue,
  );
}

void _circularGapDefaultsTo4() {
  expect(M3ECircularProgressTheme.defaults.gapSize, 4);
  expect(M3ELinearProgressTheme.defaults.gapSize, 4);
}

void _linearTrailingMarginIs4() {
  const theme = M3ELinearProgressTheme.defaults;
  expect(theme.resolveFlat(M3EProgressIndicatorSize.s).trailingMargin, 4);
  expect(theme.resolveFlat(M3EProgressIndicatorSize.m).trailingMargin, 4);
}

void _linearTrackColorIsSecondaryContainer() {
  final scheme = M3EThemeData.light().colorScheme;
  expect(
    M3ELinearProgressTheme.defaults.trackColor(scheme),
    scheme.secondaryContainer,
  );
}

Future<void> _linearUsesSecondaryContainerTrackByDefault(
  WidgetTester tester,
) async {
  await tester.pumpWidget(_host(const M3EProgressIndicator.linear(value: 0.5)));
  final scheme = M3EThemeData.light().colorScheme;
  expect(_linearPainter(tester).track, scheme.secondaryContainer);
}

Future<void> _exposesProgressBarSemantics(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EProgressIndicator.circular(value: 0.6, semanticsLabel: 'Upload'),
    ),
  );

  final semantics = tester.getSemantics(find.byType(M3EProgressIndicator));
  expect(semantics.label, 'Upload');
  expect(semantics.role, SemanticsRole.progressBar);
  expect(semantics.value, '60%');
}

Future<void> _indeterminateSemanticsUse0AndOptionalHint(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    _host(
      const M3EProgressIndicator.linear(
        semanticsLabel: 'Loading',
        semanticsValue: 'In progress',
      ),
    ),
  );

  final semantics = tester.getSemantics(find.byType(M3EProgressIndicator));
  expect(semantics.role, SemanticsRole.progressBar);
  expect(semantics.value, '0%');
  expect(semantics.hint, 'In progress');
}

Future<void> _rtlPassesTextDirectionToLinearPainter(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(
      const M3EProgressIndicator.linear(value: 0.4),
      textDirection: TextDirection.rtl,
    ),
  );
  expect(_linearPainter(tester).textDirection, TextDirection.rtl);
}

Future<void> _showTrackFalseIsPassedToLinearPainter(WidgetTester tester) async {
  await tester.pumpWidget(
    _host(const M3EProgressIndicator.linear(value: 0.5, showTrack: false)),
  );
  expect(_linearPainter(tester).showTrack, isFalse);
}

Future<void> _determinateLinearDrawsWithAStopSize(WidgetTester tester) async {
  await tester.pumpWidget(_host(const M3EProgressIndicator.linear(value: 0.5)));
  final painter = _linearPainter(tester);
  expect(painter.value, 0.5);
  expect(painter.stopSize, greaterThan(0));
}

Future<void> _indeterminateLinearHasNullValue(WidgetTester tester) async {
  await tester.pumpWidget(_host(const M3EProgressIndicator.linear()));
  expect(_linearPainter(tester).value, isNull);
}
