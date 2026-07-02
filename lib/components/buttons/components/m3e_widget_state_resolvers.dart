// GENERATED VENDOR FILE. Ported from https://github.com/Mudit200408/m3e_buttons
// Adapted for material_3_expressive: import paths + M3E naming only.
// ignore_for_file: type=lint
// Copyright (c) 2026 Mudit Purohit
//
// This source code is licensed under the MIT license found in the
// LICENSE file in the root directory of this source tree.

import 'package:flutter/material.dart';
import '../styles/m3e_button_tokens.dart';

abstract class WidgetStateResolver<T> {
  WidgetStateProperty<T> resolve(Set<WidgetState> states);
}

abstract class _CachedWidgetStateResolver<T> extends WidgetStateResolver<T> {
  WidgetStateProperty<T>? _cached;

  WidgetStateProperty<T> buildProperty();

  @override
  WidgetStateProperty<T> resolve(Set<WidgetState> states) {
    _cached ??= buildProperty();
    return _cached!;
  }
}

class ColorResolver extends _CachedWidgetStateResolver<Color?> {
  final Color _color;
  final bool _applyDisabledAlpha;

  ColorResolver({required Color color, bool applyDisabledAlpha = true})
    : _color = color,
      _applyDisabledAlpha = applyDisabledAlpha;

  @override
  WidgetStateProperty<Color?> buildProperty() {
    return WidgetStateProperty.resolveWith((resolvedStates) {
      final disabled = resolvedStates.contains(WidgetState.disabled);
      if (disabled && _applyDisabledAlpha) {
        return _color.withValues(
          alpha: M3EButtonConstants.kDisabledForegroundAlpha,
        );
      }
      return _color;
    });
  }
}

class BackgroundColorResolver extends _CachedWidgetStateResolver<Color?> {
  final Color? _decorationColor;
  final Color _fallbackColor;
  final bool _transparentForOutlined;
  final bool _applyDisabledAlpha;

  BackgroundColorResolver({
    Color? decorationColor,
    required Color fallbackColor,
    bool transparentForOutlined = false,
    bool applyDisabledAlpha = true,
  }) : _decorationColor = decorationColor,
       _fallbackColor = fallbackColor,
       _transparentForOutlined = transparentForOutlined,
       _applyDisabledAlpha = applyDisabledAlpha;

  @override
  WidgetStateProperty<Color?> buildProperty() {
    return WidgetStateProperty.resolveWith((resolvedStates) {
      final disabled = resolvedStates.contains(WidgetState.disabled);
      final Color color;

      if (_decorationColor != null) {
        color = _decorationColor;
      } else if (_transparentForOutlined) {
        color = Colors.transparent;
      } else {
        color = _fallbackColor;
      }

      if (disabled && _applyDisabledAlpha) {
        return color.withValues(
          alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
        );
      }
      return color;
    });
  }
}

class StaticColorResolver extends _CachedWidgetStateResolver<Color?> {
  final Color _color;

  StaticColorResolver(this._color);

  @override
  WidgetStateProperty<Color?> buildProperty() {
    return WidgetStateProperty.all(_color);
  }
}

class DecorationColorResolver extends _CachedWidgetStateResolver<Color?> {
  final Color? _decorationColor;
  final Color Function(Set<WidgetState> states) _fallbackResolver;
  final bool _transparentForOutlined;
  final bool _applyDisabledAlpha;

  DecorationColorResolver({
    Color? decorationColor,
    required Color Function(Set<WidgetState> states) fallbackResolver,
    bool transparentForOutlined = false,
    bool applyDisabledAlpha = true,
  }) : _decorationColor = decorationColor,
       _fallbackResolver = fallbackResolver,
       _transparentForOutlined = transparentForOutlined,
       _applyDisabledAlpha = applyDisabledAlpha;

  @override
  WidgetStateProperty<Color?> buildProperty() {
    return WidgetStateProperty.resolveWith((resolvedStates) {
      final disabled = resolvedStates.contains(WidgetState.disabled);
      final Color color;

      if (_decorationColor != null) {
        color = _decorationColor;
      } else if (_transparentForOutlined) {
        if (disabled && _applyDisabledAlpha) {
          return Colors.transparent.withValues(
            alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
          );
        }
        return Colors.transparent;
      } else {
        color = _fallbackResolver(resolvedStates);
      }

      if (disabled && _applyDisabledAlpha) {
        return color.withValues(
          alpha: M3EButtonConstants.kDisabledBackgroundAlpha,
        );
      }
      return color;
    });
  }
}

class DoubleResolver extends _CachedWidgetStateResolver<double> {
  final double Function(Set<WidgetState> states) _resolver;

  DoubleResolver(this._resolver);

  @override
  WidgetStateProperty<double> buildProperty() {
    return WidgetStateProperty.resolveWith(_resolver);
  }
}

class BorderSideResolver extends _CachedWidgetStateResolver<BorderSide> {
  final BorderSide? _decorationBorderSide;
  final BorderSide Function(Set<WidgetState> states) _fallbackResolver;

  BorderSideResolver({
    BorderSide? decorationBorderSide,
    required BorderSide Function(Set<WidgetState> states) fallbackResolver,
  }) : _decorationBorderSide = decorationBorderSide,
       _fallbackResolver = fallbackResolver;

  @override
  WidgetStateProperty<BorderSide> buildProperty() {
    return _decorationBorderSide != null
        ? WidgetStateProperty.all(_decorationBorderSide)
        : WidgetStateProperty.resolveWith(_fallbackResolver);
  }
}

class OutlineBorderSideResolver extends _CachedWidgetStateResolver<BorderSide> {
  final Color? _decorationForegroundColor;
  final Color _fallbackColor;
  final bool _applyDisabledAlpha;

  OutlineBorderSideResolver({
    Color? decorationForegroundColor,
    required Color fallbackColor,
    bool applyDisabledAlpha = true,
  }) : _decorationForegroundColor = decorationForegroundColor,
       _fallbackColor = fallbackColor,
       _applyDisabledAlpha = applyDisabledAlpha;

  @override
  WidgetStateProperty<BorderSide> buildProperty() {
    return WidgetStateProperty.resolveWith((resolvedStates) {
      final disabled = resolvedStates.contains(WidgetState.disabled);
      final color = _decorationForegroundColor ?? _fallbackColor;
      return BorderSide(
        color: color.withValues(
          alpha: disabled && _applyDisabledAlpha
              ? M3EButtonConstants.kDisabledOutlineAlpha
              : 1,
        ),
        width: 1,
      );
    });
  }
}

class NoneBorderSideResolver extends WidgetStateResolver<BorderSide> {
  static final WidgetStateProperty<BorderSide> _cached =
      WidgetStateProperty.all(BorderSide.none);

  @override
  WidgetStateProperty<BorderSide> resolve(Set<WidgetState> states) {
    return _cached;
  }
}
