import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Brightness, Color, ColorScheme;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Builds a subtree from device light and dark dynamic [ColorScheme]s.
typedef M3EDynamicColorBuilder = Widget Function(
  ColorScheme? lightDynamic,
  ColorScheme? darkDynamic,
);

/// Fetches device dynamic colors and refreshes them when the app resumes.
///
/// Prefers Android's core palette: extracts its primary color and builds light
/// and dark [ColorScheme]s via [ColorScheme.fromSeed]. Falls back to
/// [DynamicColorPlugin.getAccentColor] on platforms that expose an accent
/// color (desktop) or when the core palette is unavailable.
///
/// Re-fetches on [AppLifecycleState.resumed] so OS color changes apply without
/// restarting the app.
class M3EDynamicColorHost extends StatefulWidget {
  const M3EDynamicColorHost({required this.builder, super.key});

  final M3EDynamicColorBuilder builder;

  @override
  State<M3EDynamicColorHost> createState() => _M3EDynamicColorHostState();
}

class _M3EDynamicColorHostState extends State<M3EDynamicColorHost>
    with WidgetsBindingObserver {
  ColorScheme? _light;
  ColorScheme? _dark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchDynamicColors();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchDynamicColors();
    }
  }

  void _applySeed(Color seed) {
    setState(() {
      _light = ColorScheme.fromSeed(seedColor: seed);
      _dark = ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.dark,
      );
    });
  }

  Future<void> _fetchDynamicColors() async {
    try {
      final corePalette = await DynamicColorPlugin.getCorePalette();

      if (!mounted) {
        return;
      }

      if (corePalette != null) {
        // Primary role from the OS palette, used as fromSeed input.
        final Color seed = corePalette.toColorScheme().primary;
        if (kDebugMode) {
          debugPrint('dynamic_color: Core palette primary seed detected.');
        }
        _applySeed(seed);
        return;
      }
    } on PlatformException {
      if (kDebugMode) {
        debugPrint('dynamic_color: Failed to obtain core palette.');
      }
    }

    try {
      final Color? accentColor = await DynamicColorPlugin.getAccentColor();

      if (!mounted) {
        return;
      }

      if (accentColor != null) {
        if (kDebugMode) {
          debugPrint('dynamic_color: Accent color detected.');
        }
        _applySeed(accentColor);
        return;
      }
    } on PlatformException {
      if (kDebugMode) {
        debugPrint('dynamic_color: Failed to obtain accent color.');
      }
    }

    if (kDebugMode) {
      debugPrint('dynamic_color: Dynamic color not detected on this device.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_light, _dark);
  }
}
