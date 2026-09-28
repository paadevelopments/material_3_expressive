import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/navigation_rail/components/m3e_nav_selection_indicator.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_ui/material_ui.dart';

const List<M3ENavigationBarDestination> _destinations =
    <M3ENavigationBarDestination>[
      M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
      M3ENavigationBarDestination(icon: Icon(M3EIcons.search), label: 'Search'),
      M3ENavigationBarDestination(
        icon: Icon(M3EIcons.radio),
        label: 'Radio',
        badgeCount: 3,
      ),
    ];

void main() {
  setUp(M3EFocusInteraction.resetForTest);

  testWidgets('flexible bar is 64 and baseline is 80', _heights);
  testWidgets('vertical pill is 56 by 32 behind the icon', _verticalPill);
  testWidgets(
    'horizontal pill is 40 tall and items share the widest slot',
    _horizontal,
  );
  testWidgets('colors follow the second role pass', _colors);
  testWidgets('arrow moves focus and enter selects again', _keyboard);
  testWidgets('pointer tap dismisses the focus ring', _pointerDismissesRing);
  testWidgets('controller select reports the index', _controller);
  testWidgets('scroll down hides and a screen reader stays', _hideOnScroll);
  testWidgets('system inset stays inside the colored bar', _safeArea);
  testWidgets('text scale grows the bar and ellipsizes above 2x', _textScale);
}

Widget _bar({
  double width = 400,
  M3ENavBarSize size = M3ENavBarSize.small,
  M3ENavBarLayout layout = M3ENavBarLayout.compact,
  bool autoLayout = false,
  int selectedIndex = 0,
  ValueChanged<int>? onDestinationSelected,
  bool safeArea = false,
  TextScaler textScaler = TextScaler.noScaling,
  double? bottomInset,
}) {
  return MaterialApp(
    builder: (BuildContext context, Widget? child) {
      final MediaQueryData data = MediaQuery.of(context);
      return MediaQuery(
        data: data.copyWith(
          textScaler: textScaler,
          padding: bottomInset == null
              ? data.padding
              : EdgeInsets.only(bottom: bottomInset),
        ),
        child: child!,
      );
    },
    home: Scaffold(
      body: Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: width,
          child: M3ENavigationBar(
            destinations: _destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            autoLayout: autoLayout,
            layout: layout,
            size: size,
            safeArea: safeArea,
          ),
        ),
      ),
    ),
  );
}

Future<void> _heights(WidgetTester tester) async {
  await tester.pumpWidget(_bar());
  await tester.pumpAndSettle();
  expect(tester.getSize(find.byType(M3ENavigationBar)).height, 64);

  await tester.pumpWidget(_bar(size: M3ENavBarSize.medium));
  await tester.pumpAndSettle();
  expect(tester.getSize(find.byType(M3ENavigationBar)).height, 80);
}

Future<void> _verticalPill(WidgetTester tester) async {
  await tester.pumpWidget(_bar());
  await tester.pumpAndSettle();
  final Size pill = tester.getSize(
    find.descendant(
      of: find.byType(M3ESelectionIndicator).first,
      matching: find.byType(DecoratedBox),
    ),
  );
  expect(pill.width, 56);
  expect(pill.height, 32);
  final Rect bar = tester.getRect(find.byType(M3ENavigationBar));
  final Rect icon = tester.getRect(find.byIcon(M3EIcons.home));
  expect(icon.top, closeTo(bar.top + 10, 1));
  final Rect label = tester.getRect(find.text('Home'));
  expect(label.top, closeTo(icon.bottom + 8, 1));
}

Future<void> _horizontal(WidgetTester tester) async {
  await tester.pumpWidget(_bar(width: 800, layout: M3ENavBarLayout.wide));
  await tester.pumpAndSettle();
  final Size pill = tester.getSize(
    find.descendant(
      of: find.byType(M3ESelectionIndicator).first,
      matching: find.byType(DecoratedBox),
    ),
  );
  expect(pill.height, 40);
  expect(pill.width, greaterThan(56));
  expect(find.byType(M3EBadge), findsOneWidget);
}

Future<void> _colors(WidgetTester tester) async {
  await tester.pumpWidget(_bar());
  await tester.pumpAndSettle();
  final BuildContext context = tester.element(find.byType(M3ENavigationBar));
  final M3EColorScheme scheme = M3ETheme.of(context).colorScheme;
  final Material material = tester.widget<Material>(
    find
        .descendant(
          of: find.byType(M3ENavigationBar),
          matching: find.byType(Material),
        )
        .first,
  );
  expect(material.color, scheme.surfaceContainerHigh);
  expect(material.elevation, 0);
  final Text active = tester.widget<Text>(find.text('Home'));
  expect(active.style?.color, scheme.onSurface);
  expect(active.style?.fontWeight, FontWeight.w700);
  final Text inactive = tester.widget<Text>(find.text('Search'));
  expect(inactive.style?.color, scheme.onSurfaceVariant);
  expect(inactive.style?.fontWeight, FontWeight.w500);
  expect(
    IconTheme.of(tester.element(find.byIcon(M3EIcons.home))).color,
    scheme.onSecondaryContainer,
  );
  final DecoratedBox pill = tester.widget<DecoratedBox>(
    find.descendant(
      of: find.byType(M3ESelectionIndicator).first,
      matching: find.byType(DecoratedBox),
    ),
  );
  final decoration = pill.decoration as BoxDecoration;
  expect(decoration.color, scheme.secondaryContainer);
}

Future<void> _keyboard(WidgetTester tester) async {
  var selected = 0;
  var calls = 0;
  await tester.pumpWidget(
    _bar(
      selectedIndex: selected,
      onDestinationSelected: (int index) {
        calls += 1;
        selected = index;
      },
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('Home'));
  await tester.pump();
  expect(calls, 1);
  expect(selected, 0);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return M3ENavigationBar(
              selectedIndex: selected,
              autoLayout: false,
              safeArea: false,
              onDestinationSelected: (int index) {
                setState(() => selected = index);
              },
              destinations: _destinations,
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowRight);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowRight);
  expect(selected, 0);
  await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
  await tester.pump();
  await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
  await tester.pump(const Duration(milliseconds: 150));
  expect(selected, 1);
  expect(tester.takeException(), isNull);
}

Future<void> _pointerDismissesRing(WidgetTester tester) async {
  await tester.pumpWidget(_bar());
  await tester.pumpAndSettle();
  await tester.sendKeyDownEvent(LogicalKeyboardKey.tab);
  await tester.pump();
  expect(M3EFocusInteraction.instance.ringsAllowed, isTrue);
  await tester.sendKeyUpEvent(LogicalKeyboardKey.tab);
  await tester.tap(find.text('Home'));
  await tester.pump();
  expect(M3EFocusInteraction.instance.ringsAllowed, isFalse);
}

Future<void> _controller(WidgetTester tester) async {
  final controller = M3ENavigationBarController();
  addTearDown(controller.dispose);
  var selected = 0;
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return M3ENavigationBar(
              controller: controller,
              selectedIndex: selected,
              autoLayout: false,
              safeArea: false,
              onDestinationSelected: (int index) {
                setState(() => selected = index);
              },
              destinations: _destinations,
            );
          },
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  controller.select(2);
  await tester.pump();
  expect(selected, 2);
  expect(controller.index, 2);
}

Future<void> _hideOnScroll(WidgetTester tester) async {
  final scroll = ScrollController();
  addTearDown(scroll.dispose);
  Widget page({required bool accessible}) {
    return MaterialApp(
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(accessibleNavigation: accessible),
          child: child!,
        );
      },
      home: Scaffold(
        body: ListView.builder(
          controller: scroll,
          itemCount: 40,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(height: 48, child: Text('Row $index'));
          },
        ),
        bottomNavigationBar: M3ENavigationBar(
          hideOnScroll: true,
          scrollController: scroll,
          autoLayout: false,
          safeArea: false,
          destinations: _destinations,
        ),
      ),
    );
  }

  await tester.pumpWidget(page(accessible: false));
  await tester.pumpAndSettle();
  expect(tester.getSize(find.byType(M3ENavigationBar)).height, 80);
  await tester.fling(find.byType(ListView), const Offset(0, -600), 1200);
  await tester.pumpAndSettle();
  expect(tester.getSize(find.byType(M3ENavigationBar)).height, 0);

  await tester.pumpWidget(page(accessible: true));
  await tester.pumpAndSettle();
  await tester.fling(find.byType(ListView), const Offset(0, -600), 1200);
  await tester.pumpAndSettle();
  expect(tester.getSize(find.byType(M3ENavigationBar)).height, 80);
}

Future<void> _safeArea(WidgetTester tester) async {
  final double ratio = tester.view.devicePixelRatio;
  tester.view.viewPadding = FakeViewPadding(bottom: 20 * ratio);
  tester.view.padding = FakeViewPadding(bottom: 20 * ratio);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        bottomNavigationBar: M3ENavigationBar(
          autoLayout: false,
          destinations: _destinations,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final Rect bar = tester.getRect(find.byType(M3ENavigationBar));
  expect(bar.height, closeTo(100, 1));
  final Rect label = tester.getRect(find.text('Home'));
  expect(label.bottom, lessThanOrEqualTo(bar.bottom - 20));
  final material = tester.widget<Material>(
    find
        .descendant(
          of: find.byType(M3ENavigationBar),
          matching: find.byType(Material),
        )
        .first,
  );
  expect(tester.getSize(find.byWidget(material)).height, closeTo(100, 1));
}

Future<void> _textScale(WidgetTester tester) async {
  await tester.pumpWidget(_bar(textScaler: const TextScaler.linear(1.5)));
  await tester.pumpAndSettle();
  expect(tester.getSize(find.byType(M3ENavigationBar)).height, greaterThan(64));
  expect(tester.widget<Text>(find.text('Home')).maxLines, 2);
  expect(tester.widget<Text>(find.text('Home')).overflow, TextOverflow.clip);

  await tester.pumpWidget(_bar(textScaler: const TextScaler.linear(2.5)));
  await tester.pumpAndSettle();
  expect(
    tester.widget<Text>(find.text('Home')).overflow,
    TextOverflow.ellipsis,
  );
}
