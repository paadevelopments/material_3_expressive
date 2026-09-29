// Shared fixtures for the app bar test suite, split across
// `app_bar_test.dart` (structure/layout) and `app_bar_scroll_test.dart`
// (scroll-under color/elevation behavior).
import 'package:material_ui/material_ui.dart';

/// Common title text used across app bar structural and scroll tests.
const String appBarInboxTitle = 'Inbox';

/// Wraps [child] in a minimal `MaterialApp`/`Scaffold` host.
Widget hostAppBar(Widget child) => MaterialApp(home: Scaffold(body: child));
