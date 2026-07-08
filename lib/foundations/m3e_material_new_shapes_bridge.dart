import 'dart:collection';

import 'package:material_new_shapes/material_new_shapes.dart';

export 'package:material_new_shapes/material_new_shapes.dart'
    show
        CornerRounding,
        Matrix4PointTransformer,
        Morph,
        MorphToPathExtension,
        RoundedPolygon,
        RoundedPolygonToPathExtension,
        pathFromCubics;

/// Foundation bridge to `material_new_shapes` expressive morph polygons.
abstract final class M3EMaterialNewShapes {
  const M3EMaterialNewShapes._();

  static RoundedPolygon get circle => MaterialShapes.circle;
  static RoundedPolygon get square => MaterialShapes.square;
  static RoundedPolygon get slanted => MaterialShapes.slanted;
  static RoundedPolygon get arch => MaterialShapes.arch;
  static RoundedPolygon get semiCircle => MaterialShapes.semiCircle;
  static RoundedPolygon get oval => MaterialShapes.oval;
  static RoundedPolygon get pill => MaterialShapes.pill;
  static RoundedPolygon get triangle => MaterialShapes.triangle;
  static RoundedPolygon get arrow => MaterialShapes.arrow;
  static RoundedPolygon get fan => MaterialShapes.fan;
  static RoundedPolygon get diamond => MaterialShapes.diamond;
  static RoundedPolygon get clamShell => MaterialShapes.clamShell;
  static RoundedPolygon get pentagon => MaterialShapes.pentagon;
  static RoundedPolygon get gem => MaterialShapes.gem;
  static RoundedPolygon get sunny => MaterialShapes.sunny;
  static RoundedPolygon get verySunny => MaterialShapes.verySunny;
  static RoundedPolygon get cookie4Sided => MaterialShapes.cookie4Sided;
  static RoundedPolygon get cookie6Sided => MaterialShapes.cookie6Sided;
  static RoundedPolygon get cookie7Sided => MaterialShapes.cookie7Sided;
  static RoundedPolygon get cookie9Sided => MaterialShapes.cookie9Sided;
  static RoundedPolygon get cookie12Sided => MaterialShapes.cookie12Sided;
  static RoundedPolygon get clover4Leaf => MaterialShapes.clover4Leaf;
  static RoundedPolygon get clover8Leaf => MaterialShapes.clover8Leaf;
  static RoundedPolygon get burst => MaterialShapes.burst;
  static RoundedPolygon get softBurst => MaterialShapes.softBurst;
  static RoundedPolygon get boom => MaterialShapes.boom;
  static RoundedPolygon get softBoom => MaterialShapes.softBoom;
  static RoundedPolygon get flower => MaterialShapes.flower;
  static RoundedPolygon get puffy => MaterialShapes.puffy;
  static RoundedPolygon get puffyDiamond => MaterialShapes.puffyDiamond;
  static RoundedPolygon get ghostish => MaterialShapes.ghostish;
  static RoundedPolygon get pixelCircle => MaterialShapes.pixelCircle;
  static RoundedPolygon get pixelTriangle => MaterialShapes.pixelTriangle;
  static RoundedPolygon get bun => MaterialShapes.bun;
  static RoundedPolygon get heart => MaterialShapes.heart;

  static UnmodifiableListView<RoundedPolygon> get all => MaterialShapes.all;
}
