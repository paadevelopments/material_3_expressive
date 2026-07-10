import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/components/navigation_bar/models/m3e_navigation_bar_destination.dart';
import 'package:material_3_expressive/components/navigation_rail/enums/m3e_navigation_rail_enums.dart';
import 'package:material_3_expressive/components/navigation_rail/models/m3e_navigation_rail_destination.dart';
import 'package:material_3_expressive/components/navigation_rail/models/m3e_navigation_rail_section.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('M3EIconButton renders its icon and fires onPressed',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _host(
        M3EIconButton(
          icon: const Icon(M3EIcons.favorite),
          onPressed: () => taps++,
        ),
      ),
    );

    expect(find.byIcon(M3EIcons.favorite), findsOneWidget);
    await tester.tap(find.byIcon(M3EIcons.favorite));
    expect(taps, 1);
  });

  testWidgets('M3ENavigationBar renders destinations and reports selection',
      (tester) async {
    var selected = -1;
    await tester.pumpWidget(
      _host(
        Align(
          alignment: Alignment.bottomCenter,
          child: M3ENavigationBar(
            onDestinationSelected: (i) => selected = i,
            destinations: const <M3ENavigationBarDestination>[
              M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
              M3ENavigationBarDestination(
                icon: Icon(M3EIcons.search),
                label: 'Search',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    await tester.tap(find.text('Search'));
    expect(selected, 1);
  });

  testWidgets('M3ENavigationRail renders section destinations', (tester) async {
    await tester.pumpWidget(
      _host(
        M3ENavigationRail(
          type: M3ENavigationRailType.alwaysExpand,
          selectedIndex: 0,
          onDestinationSelected: (_) {},
          sections: const <M3ENavigationRailSection>[
            M3ENavigationRailSection(
              destinations: <M3ENavigationRailDestination>[
                M3ENavigationRailDestination(
                  icon: Icon(M3EIcons.inbox),
                  label: 'Inbox',
                ),
                M3ENavigationRailDestination(
                  icon: Icon(M3EIcons.send),
                  label: 'Sent',
                ),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Inbox'), findsWidgets);
    expect(find.byIcon(M3EIcons.inbox), findsOneWidget);
  });

  testWidgets('M3ESlider reports value changes', (tester) async {
    var value = 0.5;
    await tester.pumpWidget(
      _host(
        StatefulBuilder(
          builder: (context, setState) {
            return M3ESlider(
              value: value,
              onChanged: (v) => setState(() => value = v),
            );
          },
        ),
      ),
    );

    expect(find.byType(M3ESlider), findsOneWidget);
    final Rect rect = tester.getRect(find.byType(M3ESlider));
    await tester.tapAt(Offset(rect.left + rect.width * 0.2, rect.center.dy));
    expect(value, isNot(0.5));
  });

  testWidgets(
      'M3ENavigationBar works under a WidgetsApp with the Material delegate',
      (tester) async {
    // Mirrors the example app: no MaterialApp, just WidgetsApp + the Material
    // localizations delegate so the wrapped Material widgets can resolve.
    await tester.pumpWidget(
      WidgetsApp(
        color: const Color(0xFF6750A4),
        pageRouteBuilder: <T>(RouteSettings settings, WidgetBuilder builder) {
          return PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          );
        },
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          DefaultMaterialLocalizations.delegate,
          DefaultWidgetsLocalizations.delegate,
        ],
        home: const Align(
          alignment: Alignment.bottomCenter,
          child: M3ENavigationBar(
            destinations: <M3ENavigationBarDestination>[
              M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
              M3ENavigationBarDestination(
                icon: Icon(M3EIcons.search),
                label: 'Search',
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('M3ESlider renders without a Scaffold/Material ancestor',
      (tester) async {
    // Components placed directly under a ListView with no Material ancestor
    // must not throw.
    await tester.pumpWidget(
      MaterialApp(
        home: ListView(
          children: <Widget>[
            M3ESlider(value: 0.5, onChanged: (_) {}),
          ],
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(M3ESlider), findsOneWidget);
  });
}
