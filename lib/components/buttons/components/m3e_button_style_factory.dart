// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import '../styles/m3e_button_tokens.dart';

class ButtonStyleFactory {
  static WidgetStateProperty<Color?> cachedForegroundColor({
    required Color color,
    required bool disabled,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      final isDisabled = states.contains(WidgetState.disabled);
      return isDisabled
          ? color.withValues(alpha: M3EButtonConstants.kDisabledForegroundAlpha)
          : color;
    });
  }

  static WidgetStateProperty<Color?> cachedBackgroundColor({
    required Color color,
    required bool disabled,
    required bool transparent,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      final isDisabled = states.contains(WidgetState.disabled);
      if (transparent) {
        return isDisabled ? Colors.transparent : color;
      }
      return isDisabled
          ? color.withValues(alpha: M3EButtonConstants.kDisabledBackgroundAlpha)
          : color;
    });
  }

  static WidgetStateProperty<double> cachedElevation(
    double Function(Set<WidgetState>) elevationResolver,
  ) {
    return WidgetStateProperty.resolveWith<double>(elevationResolver);
  }

  static WidgetStateProperty<BorderSide> cachedBorderSide(
    BorderSide? decorationBorderSide,
    bool isOutlined,
    Color Function() outlineColor,
  ) {
    return WidgetStateProperty.resolveWith<BorderSide>((states) {
      if (decorationBorderSide != null) {
        return decorationBorderSide;
      }
      if (isOutlined) {
        final disabled = states.contains(WidgetState.disabled);
        return BorderSide(
          color: outlineColor().withValues(
            alpha: disabled ? M3EButtonConstants.kDisabledOutlineAlpha : 1,
          ),
          width: 1,
        );
      }
      return BorderSide.none;
    });
  }

  static WidgetStateProperty<BorderSide> cachedBorderSideWithChecked({
    required BorderSide? decorationBorderSide,
    required bool isOutlined,
    required bool checked,
    required Color Function() outlineColor,
  }) {
    return WidgetStateProperty.resolveWith<BorderSide>((states) {
      if (decorationBorderSide != null) {
        return decorationBorderSide;
      }
      if (isOutlined && !checked) {
        final disabled = states.contains(WidgetState.disabled);
        return BorderSide(
          color: outlineColor().withValues(
            alpha: disabled ? M3EButtonConstants.kDisabledOutlineAlpha : 1,
          ),
          width: 1,
        );
      }
      return BorderSide.none;
    });
  }

  static WidgetStateProperty<Color?> cachedToggleForegroundColor({
    required Color resolvedColor,
    required bool disabled,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      final isDisabled = states.contains(WidgetState.disabled);
      return isDisabled
          ? resolvedColor.withValues(
              alpha: M3EButtonConstants.kDisabledForegroundAlpha,
            )
          : resolvedColor;
    });
  }

  static WidgetStateProperty<Color?> cachedToggleBackgroundColor({
    required Color resolvedColor,
    required bool disabled,
    required bool transparent,
  }) {
    return WidgetStateProperty.resolveWith<Color?>((states) {
      final isDisabled = states.contains(WidgetState.disabled);
      if (transparent) {
        return isDisabled ? Colors.transparent : resolvedColor;
      }
      return isDisabled
          ? resolvedColor.withValues(
              alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
            )
          : resolvedColor;
    });
  }
}
