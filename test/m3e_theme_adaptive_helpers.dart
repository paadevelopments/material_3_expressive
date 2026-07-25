import 'dart:typed_data';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

const Color accentGreen = Color(0xFF286C2A);
const Color accentOrange = Color(0xFFE65100);

M3EColorScheme resolvedM3eSchemeFromAccent(
  Color accent, {
  Brightness brightness = Brightness.light,
}) {
  final fromSeed = ColorScheme.fromSeed(
    seedColor: accent,
    brightness: brightness,
  );
  return M3EColorScheme.fromColorScheme(fromSeed.harmonized()).harmonized();
}

/// Builds the concatenated tonal-palette list Android's DynamicColorPlugin
/// returns, without using the deprecated CorePalette API.
({List<int> list, Color primarySeed}) corePaletteMockFromSeed(Color seed) {
  final cam = Cam16.fromInt(seed.toARGB32());
  final primary = TonalPalette.of(cam.hue, cam.chroma < 48 ? 48 : cam.chroma);
  final secondary = TonalPalette.of(cam.hue, 16);
  final tertiary = TonalPalette.of(cam.hue + 60, 24);
  final neutral = TonalPalette.of(cam.hue, 4);
  final neutralVariant = TonalPalette.of(cam.hue, 8);
  return (
    list: <int>[
      ...primary.asList,
      ...secondary.asList,
      ...tertiary.asList,
      ...neutral.asList,
      ...neutralVariant.asList,
    ],
    primarySeed: Color(primary.get(40)),
  );
}

void mockDynamicColorChannel({List<int>? corePaletteList, Color? accentColor}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(DynamicColorPlugin.channel, (
        MethodCall methodCall,
      ) async {
        if (methodCall.method == DynamicColorPlugin.methodName) {
          return corePaletteList != null
              ? Int64List.fromList(corePaletteList)
              : null;
        }
        if (methodCall.method == DynamicColorPlugin.accentColorMethodName) {
          return accentColor?.toARGB32();
        }
        return null;
      });
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          DynamicColorPlugin.channel,
          (MethodCall methodCall) => null,
        );
  });
}
