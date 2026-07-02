// Vendored from the `icon_button_m3e` package
// (https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/icon_button_m3e/lib).
// The logic is kept identical to the reference implementation; only the public
// identifiers carry the `M3E` prefix to match this package's conventions.
//
// As vendored third-party code kept intentionally identical to its source, the
// project's opinionated lints are relaxed for this file.
// ignore_for_file: type=lint
// ignore_for_file: cognitive_complexity, function_length, file_length
// ignore_for_file: class_length, number_of_parameters, long_method

import 'package:flutter/material.dart';

/// Visual scale labels (A–E in the spec).
enum M3EIconButtonSize { xs, sm, md, lg, xl }

/// Width variants of the button's container (not the icon glyph).
enum M3EIconButtonWidth { defaultWidth, narrow, wide }

/// The two resting shape variants.
enum M3EIconButtonShapeVariant { round, square }

/// Visual variants (kept from previous API).
enum M3EIconButtonVariant { standard, filled, tonal, outlined }

/// Icon glyph size inside the button (reads tokens).
extension M3EIconGlyphExt on M3EIconButtonSize {
  double get icon => M3EIconButtonTokens.icon[this]!;
}

/// Visual (painted) size & target size helpers (read tokens).
extension M3EIconButtonSizesExt on M3EIconButtonSize {
  Size visual(M3EIconButtonWidth width) =>
      M3EIconButtonTokens.visual[this]![width]!;

  Size target(M3EIconButtonWidth width) =>
      M3EIconButtonTokens.target[this]![width]!;

  Size get defaultSize => visual(M3EIconButtonWidth.defaultWidth);
  Size get narrowSize => visual(M3EIconButtonWidth.narrow);
  Size get wideSize => visual(M3EIconButtonWidth.wide);
}

/// Shape resolution helpers: resting/pressed radii and toggle behavior.
class M3EIconButtonShapes {
  const M3EIconButtonShapes._();

  static M3EIconButtonShapeVariant restVariant({
    required bool isToggle,
    required bool isSelected,
    required M3EIconButtonShapeVariant baseVariant,
  }) {
    if (isToggle && isSelected) {
      return baseVariant == M3EIconButtonShapeVariant.round
          ? M3EIconButtonShapeVariant.square
          : M3EIconButtonShapeVariant.round;
    }
    return baseVariant;
  }

  static double restingRadius({
    required M3EIconButtonSize size,
    required M3EIconButtonShapeVariant variant,
  }) {
    return switch (variant) {
      M3EIconButtonShapeVariant.round =>
        M3EIconButtonTokens.radiusRestRound[size]!,
      M3EIconButtonShapeVariant.square =>
        M3EIconButtonTokens.radiusRestSquare[size]!,
    };
  }

  /// Effective corner radius for the given material states.
  /// Hover does not change the radius; Pressed uses the shared pressed radius.
  static double effectiveRadius({
    required M3EIconButtonSize size,
    required M3EIconButtonShapeVariant baseVariant,
    required bool isToggle,
    required bool isSelected,
    required Set<WidgetState> states,
  }) {
    final variant = restVariant(
      isToggle: isToggle,
      isSelected: isSelected,
      baseVariant: baseVariant,
    );

    if (states.contains(WidgetState.pressed)) {
      return M3EIconButtonTokens.radiusPressed[size]!;
    }
    return restingRadius(size: size, variant: variant);
  }
}

/// All numeric tokens & constants for M3 Expressive IconButton.
/// No business logic here—just data.
class M3EIconButtonTokens {
  const M3EIconButtonTokens._();

  // ----------------------------
  // Icon glyph sizes (dp)
  // ----------------------------
  static const Map<M3EIconButtonSize, double> icon = {
    M3EIconButtonSize.xs: 20.0, // A
    M3EIconButtonSize.sm: 24.0, // B
    M3EIconButtonSize.md: 24.0, // C
    M3EIconButtonSize.lg: 32.0, // D
    M3EIconButtonSize.xl: 40.0, // E
  };

  // ----------------------------
  // Visual container sizes (dp)
  // width × height
  // ----------------------------
  static const Map<M3EIconButtonSize, Map<M3EIconButtonWidth, Size>> visual = {
    M3EIconButtonSize.xs: {
      M3EIconButtonWidth.defaultWidth: Size(32, 32),
      M3EIconButtonWidth.narrow: Size(28, 32),
      M3EIconButtonWidth.wide: Size(40, 32),
    },
    M3EIconButtonSize.sm: {
      M3EIconButtonWidth.defaultWidth: Size(40, 40),
      M3EIconButtonWidth.narrow: Size(32, 40),
      M3EIconButtonWidth.wide: Size(52, 40),
    },
    M3EIconButtonSize.md: {
      M3EIconButtonWidth.defaultWidth: Size(56, 56),
      M3EIconButtonWidth.narrow: Size(48, 56),
      M3EIconButtonWidth.wide: Size(72, 56),
    },
    M3EIconButtonSize.lg: {
      M3EIconButtonWidth.defaultWidth: Size(96, 96),
      M3EIconButtonWidth.narrow: Size(64, 96),
      M3EIconButtonWidth.wide: Size(128, 96),
    },
    M3EIconButtonSize.xl: {
      M3EIconButtonWidth.defaultWidth: Size(136, 136),
      M3EIconButtonWidth.narrow: Size(104, 136),
      M3EIconButtonWidth.wide: Size(184, 136),
    },
  };

  // ----------------------------
  // Minimum interactive target sizes (dp)
  // XS/SM must be ≥48×48 (SM wide = 52×48); others equal visual.
  // ----------------------------
  static const Map<M3EIconButtonSize, Map<M3EIconButtonWidth, Size>> target = {
    M3EIconButtonSize.xs: {
      M3EIconButtonWidth.defaultWidth: Size(48, 48),
      M3EIconButtonWidth.narrow: Size(48, 48),
      M3EIconButtonWidth.wide: Size(48, 48),
    },
    M3EIconButtonSize.sm: {
      M3EIconButtonWidth.defaultWidth: Size(48, 48),
      M3EIconButtonWidth.narrow: Size(48, 48),
      M3EIconButtonWidth.wide: Size(52, 48),
    },
    // MD/LG/XL already meet or exceed 48×48 – use visual sizes as targets.
    M3EIconButtonSize.md: {
      M3EIconButtonWidth.defaultWidth: Size(56, 56),
      M3EIconButtonWidth.narrow: Size(48, 56),
      M3EIconButtonWidth.wide: Size(72, 56),
    },
    M3EIconButtonSize.lg: {
      M3EIconButtonWidth.defaultWidth: Size(96, 96),
      M3EIconButtonWidth.narrow: Size(64, 96),
      M3EIconButtonWidth.wide: Size(128, 96),
    },
    M3EIconButtonSize.xl: {
      M3EIconButtonWidth.defaultWidth: Size(136, 136),
      M3EIconButtonWidth.narrow: Size(104, 136),
      M3EIconButtonWidth.wide: Size(184, 136),
    },
  };

  // ----------------------------
  // Corner radii (dp)
  // Pressed radius is shared by both variants at the same size and
  // is more square than the square resting radius.
  // Values are consistent, scalable defaults; tune to match your spec.
  // ----------------------------
  static const Map<M3EIconButtonSize, double> radiusRestRound = {
    // Half of the default height → circular/pill look
    M3EIconButtonSize.xs: 16.0, // 32/2
    M3EIconButtonSize.sm: 20.0, // 40/2
    M3EIconButtonSize.md: 28.0, // 56/2
    M3EIconButtonSize.lg: 48.0, // 96/2
    M3EIconButtonSize.xl: 68.0, // 136/2
  };

  static const Map<M3EIconButtonSize, double> radiusRestSquare = {
    // Rounded-square feel (~25% of height)
    M3EIconButtonSize.xs: 8.0, // ≈32*0.25
    M3EIconButtonSize.sm: 10.0, // ≈40*0.25
    M3EIconButtonSize.md: 14.0, // ≈56*0.25
    M3EIconButtonSize.lg: 24.0, // ≈96*0.25
    M3EIconButtonSize.xl: 34.0, // ≈136*0.25
  };

  static const Map<M3EIconButtonSize, double> radiusPressed = {
    // More square than the square resting radius (~20% of height)
    M3EIconButtonSize.xs: 6.0, // ≈32*0.20
    M3EIconButtonSize.sm: 8.0, // ≈40*0.20
    M3EIconButtonSize.md: 11.0, // ≈56*0.20
    M3EIconButtonSize.lg: 19.0, // ≈96*0.20
    M3EIconButtonSize.xl: 27.0, // ≈136*0.20
  };

  // ----------------------------
  // Motion tokens for shape morph (optional, but handy)
  // ----------------------------
  static const Duration morphDuration = Duration(milliseconds: 120);
  static const Curve morphCurve = Curves.easeOut;
}
