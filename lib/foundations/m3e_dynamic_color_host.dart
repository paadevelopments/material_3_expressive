import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Color, ColorScheme;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

import 'm3e_dynamic_color_cache.dart';

/// Builds a subtree from device light and dark dynamic [ColorScheme]s.
typedef M3EDynamicColorBuilder = Widget Function(
  ColorScheme? lightDynamic,
  ColorScheme? darkDynamic,
);

/// Fetches OS seed colors and refreshes them when the app resumes.
///
/// On Android, reads the Material You primary tone from the platform core
/// palette list returned by [DynamicColorPlugin]. On desktop, uses
/// [DynamicColorPlugin.getAccentColor]. Both paths build light and dark
/// [ColorScheme]s via [ColorScheme.fromSeed].
///
/// Loading starts automatically when adaptive theming enables `dynamicColoring`.
/// The first frame waits for that load (or a cached result) so the static seed
/// is not shown first.
///
/// Re-fetches on [AppLifecycleState.resumed] so OS color changes apply without
/// restarting the app.
class M3EDynamicColorHost extends StatefulWidget {
  const M3EDynamicColorHost({required this.builder, super.key});

  final M3EDynamicColorBuilder builder;

  static Future<void>? _ensureLoadedFuture;

  /// Starts or awaits in-flight platform color loading.
  ///
  /// Called automatically by the theme scope and material app. Safe to call
  /// multiple times; subsequent calls share the same in-flight request.
  static Future<void> ensureLoaded() {
    if (M3EDynamicColorCache.isPopulated) {
      return Future<void>.value();
    }
    return _ensureLoadedFuture ??= _loadSeedIntoCache();
  }

  @visibleForTesting
  static void clearCacheForTesting() {
    _ensureLoadedFuture = null;
    M3EDynamicColorCache.clear();
  }

  /// Reads the OS dynamic seed color, if any.
  @visibleForTesting
  static Future<Color?> fetchDynamicSeed() => _fetchDynamicSeed();

  static Future<void> _loadSeedIntoCache() async {
    final Color? seed = await _fetchDynamicSeed();
    if (seed != null) {
      M3EDynamicColorCache.storeSeed(seed);
    }
  }

  @override
  State<M3EDynamicColorHost> createState() => _M3EDynamicColorHostState();
}

class _M3EDynamicColorHostState extends State<M3EDynamicColorHost>
    with WidgetsBindingObserver {
  ColorScheme? _light;
  ColorScheme? _dark;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshDynamicColors();
    }
  }

  Future<void> _bootstrap() async {
    await M3EDynamicColorHost.ensureLoaded();
    if (!mounted) {
      return;
    }
    _applyResolvedColors();
  }

  Future<void> _refreshDynamicColors() async {
    final Color? seed = await M3EDynamicColorHost.fetchDynamicSeed();
    if (!mounted) {
      return;
    }

    if (seed != null) {
      if (kDebugMode) {
        debugPrint('dynamic_color: Dynamic seed detected.');
      }
      M3EDynamicColorCache.storeSeed(seed);
    } else if (kDebugMode && !M3EDynamicColorCache.isPopulated) {
      debugPrint('dynamic_color: Dynamic color not detected on this device.');
    }

    _applyResolvedColors();
  }

  void _applyResolvedColors() {
    setState(() {
      if (M3EDynamicColorCache.isPopulated) {
        _light = M3EDynamicColorCache.light;
        _dark = M3EDynamicColorCache.dark;
      }
      _ready = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const SizedBox.shrink();
    }
    return widget.builder(_light, _dark);
  }
}

Future<Color?> _fetchDynamicSeed() async {
  try {
    final Object? result = await DynamicColorPlugin.channel.invokeMethod(
      DynamicColorPlugin.methodName,
    );

    final Color? seed = _seedFromPlatformCorePalette(result);
    if (seed != null) {
      return seed;
    }
  } on PlatformException {
    if (kDebugMode) {
      debugPrint('dynamic_color: Failed to obtain core palette.');
    }
  }

  try {
    return await DynamicColorPlugin.getAccentColor();
  } on PlatformException {
    if (kDebugMode) {
      debugPrint('dynamic_color: Failed to obtain accent color.');
    }
  }

  return null;
}

/// Reads the primary Material You tone from the Android core palette list.
Color? _seedFromPlatformCorePalette(Object? result) {
  if (result is! List) {
    return null;
  }

  final List<int> colors = result.cast<int>();
  if (colors.length < TonalPalette.commonSize) {
    return null;
  }

  final TonalPalette primary = TonalPalette.fromList(
    colors.sublist(0, TonalPalette.commonSize),
  );
  return Color(primary.get(40));
}
