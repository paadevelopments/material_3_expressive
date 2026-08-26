import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../../../theme/example_theme_settings.dart';
import '../../../widgets/playground/control_panel.dart';
import '../../../widgets/playground/controls/play_enum_menu.dart';
import '../../../widgets/playground/controls/play_slider.dart';
import '../../../widgets/playground/controls/play_switch.dart';
import '../../../widgets/playground/controls/play_text_field.dart';
import '../../../widgets/playground/play_preview_card.dart';
import '../../../widgets/playground/playground_body.dart';

/// Live playground for M3 type scale, variable-font axes, and style conversion.
class TypographyPlayground extends StatefulWidget {
  /// Creates the typography playground.
  const TypographyPlayground({super.key});

  @override
  State<TypographyPlayground> createState() => _TypographyPlaygroundState();
}

class _TypographyPlaygroundState extends State<TypographyPlayground> {
  M3ETypeRole _role = M3ETypeRole.headlineSmall;
  M3ETypeScaleVariant _variant = M3ETypeScaleVariant.baseline;
  String _sample = 'Material 3 Expressive';
  String _fontFamily = ExampleThemeSettings.robotoFlex;

  bool _autoWght = true;
  bool _autoOpsz = true;
  double _wght = 400;
  double _opsz = 24;
  double _globalRond = 0;

  bool _groupOverrides = false;
  double _brandRond = 25;
  double _bodyRond = 50;

  bool _advancedEnabled = false;
  double _wdth = 100;
  double _slnt = 0;
  double _grad = 0;
  double _ytas = 750;
  double _ytde = -250;
  double _ytlc = 500;
  double _ytuc = 750;
  bool _emphasizedGrad = true;

  bool _convertFromCustom = false;
  double _customFontSize = 18;

  String _roleLabel(M3ETypeRole role) {
    return switch (role) {
      M3ETypeRole.displayLarge => 'Display large',
      M3ETypeRole.displayMedium => 'Display medium',
      M3ETypeRole.displaySmall => 'Display small',
      M3ETypeRole.headlineLarge => 'Headline large',
      M3ETypeRole.headlineMedium => 'Headline medium',
      M3ETypeRole.headlineSmall => 'Headline small',
      M3ETypeRole.titleLarge => 'Title large',
      M3ETypeRole.titleMedium => 'Title medium',
      M3ETypeRole.titleSmall => 'Title small',
      M3ETypeRole.bodyLarge => 'Body large',
      M3ETypeRole.bodyMedium => 'Body medium',
      M3ETypeRole.bodySmall => 'Body small',
      M3ETypeRole.labelLarge => 'Label large',
      M3ETypeRole.labelMedium => 'Label medium',
      M3ETypeRole.labelSmall => 'Label small',
    };
  }

  String _variantLabel(M3ETypeScaleVariant variant) {
    return switch (variant) {
      M3ETypeScaleVariant.baseline => 'Baseline',
      M3ETypeScaleVariant.emphasized => 'Emphasized',
      M3ETypeScaleVariant.variableBaseline => 'Variable baseline',
      M3ETypeScaleVariant.variableEmphasized => 'Variable emphasized',
    };
  }

  M3EVariableFontConfig _buildConfig() {
    M3EVariableFontAxes? global;
    if (!_autoWght ||
        !_autoOpsz ||
        _globalRond != 0 ||
        (_advancedEnabled &&
            (_wdth != 100 || _slnt != 0 || _grad != 0 || _ytas != 750))) {
      global = M3EVariableFontAxes(
        wght: _autoWght ? null : _wght,
        opsz: _autoOpsz ? null : _opsz,
        rond: _globalRond == 0 ? null : _globalRond,
        wdth: _advancedEnabled && _wdth != 100 ? _wdth : null,
        slnt: _advancedEnabled && _slnt != 0 ? _slnt : null,
        grad: _advancedEnabled && _grad != 0 ? _grad : null,
        ytas: _advancedEnabled && _ytas != 750 ? _ytas : null,
        ytde: _advancedEnabled && _ytde != -250 ? _ytde : null,
        ytlc: _advancedEnabled && _ytlc != 500 ? _ytlc : null,
        ytuc: _advancedEnabled && _ytuc != 750 ? _ytuc : null,
      );
    }

    M3EVariableFontAxes? brand;
    M3EVariableFontAxes? body;
    if (_groupOverrides) {
      brand = M3EVariableFontAxes(rond: _brandRond);
      body = M3EVariableFontAxes(rond: _bodyRond);
    }

    return M3EVariableFontConfig(
      enableOpsz: _autoOpsz,
      syncWghtToWeight: _autoWght,
      emphasizedGrad: _emphasizedGrad && _variant.isEmphasized ? 50 : 0,
      global: global,
      brand: brand,
      body: body,
    );
  }

  TextStyle _resolvedStyle(M3EThemeData theme) {
    final M3EVariableFontConfig config = _buildConfig();
    final M3EColorScheme scheme = theme.colorScheme;

    if (_convertFromCustom) {
      final TextStyle custom = TextStyle(
        fontFamily: _fontFamily,
        fontSize: _customFontSize,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface,
      );
      return M3ETypeStyleConversion.toVariant(
        custom,
        variant: _variant,
        role: _role,
        variableFont: config,
      );
    }

    return M3ETypeScale.baseline()
        .styleFor(_role, variant: _variant, variableFont: config)
        .copyWith(fontFamily: _fontFamily, color: scheme.onSurface);
  }

  @override
  Widget build(BuildContext context) {
    final M3EThemeData theme = M3ETheme.of(context);
    final TextStyle previewStyle = _resolvedStyle(theme);
    final M3ETypeStyleTokens tokens = M3ETypeStyleConversion.tokensFor(
      _role,
      _variant,
    );
    final M3EVariableFontConfig config = _buildConfig();
    final List<FontVariation> variations = config.resolveForRole(
      _role,
      previewStyle,
      isEmphasizedScale: _variant.isEmphasized,
    );

    final String variationDump = variations.isEmpty
        ? '(none)'
        : variations
              .map((FontVariation v) => '${v.axis}=${v.value}')
              .join(', ');

    return PlaygroundBody(
      previews: <Widget>[
        PlayPreviewCard(
          label: '${_roleLabel(_role)} · ${_variantLabel(_variant)}',
          child: Text(_sample, style: previewStyle),
        ),
        PlayPreviewCard(
          label: 'Token readout',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _readout(theme, 'Size', '${tokens.fontSize}'),
              _readout(theme, 'Line height', '${tokens.lineHeight}'),
              _readout(theme, 'Tracking', '${tokens.letterSpacing}'),
              _readout(theme, 'Weight', '${tokens.fontWeight.value}'),
              _readout(theme, 'Resolved axes', variationDump),
            ],
          ),
        ),
      ],
      snippets: <PlaySnippet>[
        PlaySnippet(
          label: 'Variable font config',
          code:
              '''
const config = M3EVariableFontConfig(
  syncWghtToWeight: $_autoWght,
  enableOpsz: $_autoOpsz,
  emphasizedGrad: ${_emphasizedGrad && _variant.isEmphasized ? 50 : 0},
  global: M3EVariableFontAxes(
    wght: ${_autoWght ? 'null' : _wght.toStringAsFixed(0)},
    opsz: ${_autoOpsz ? 'null' : _opsz.toStringAsFixed(0)},
  ),
);''',
        ),
        PlaySnippet(
          label: 'Style conversion',
          code:
              '''
final style = M3ETypeStyleConversion.toVariant(
  source,
  variant: M3ETypeScaleVariant.${_variant.name},
  role: M3ETypeRole.${_role.name},
  variableFont: config,
);''',
        ),
      ],
      controls: <Widget>[
        PlayControlPanel(
          title: 'Role & variant',
          children: <Widget>[
            PlayEnumMenu<M3ETypeRole>(
              label: 'Type role',
              value: _role,
              values: M3ETypeRole.values,
              labelOf: _roleLabel,
              onChanged: (M3ETypeRole v) => setState(() => _role = v),
            ),
            PlayEnumMenu<M3ETypeScaleVariant>(
              label: 'Variant',
              value: _variant,
              values: M3ETypeScaleVariant.values,
              labelOf: _variantLabel,
              onChanged: (M3ETypeScaleVariant v) =>
                  setState(() => _variant = v),
            ),
            PlayTextField(
              label: 'Sample text',
              value: _sample,
              onChanged: (String v) => setState(() => _sample = v),
            ),
            PlayEnumMenu<String>(
              label: 'Font family',
              value: _fontFamily,
              values: const <String>[
                ExampleThemeSettings.robotoFlex,
                ExampleThemeSettings.robotoMono,
              ],
              labelOf: (String v) => v,
              onChanged: (String v) => setState(() => _fontFamily = v),
            ),
          ],
        ),
        PlayControlPanel(
          title: 'Core axes',
          children: <Widget>[
            PlaySwitch(
              label: 'Auto wght from weight',
              value: _autoWght,
              onChanged: (bool v) => setState(() => _autoWght = v),
            ),
            if (!_autoWght)
              PlaySlider(
                label: 'wght',
                value: _wght,
                min: 100,
                max: 900,
                divisions: 16,
                onChanged: (double v) => setState(() => _wght = v),
              ),
            PlaySwitch(
              label: 'Auto opsz from size',
              value: _autoOpsz,
              onChanged: (bool v) => setState(() => _autoOpsz = v),
            ),
            if (!_autoOpsz)
              PlaySlider(
                label: 'opsz',
                value: _opsz,
                min: 8,
                max: 72,
                divisions: 32,
                onChanged: (double v) => setState(() => _opsz = v),
              ),
            PlaySlider(
              label: 'Global ROND',
              value: _globalRond,
              min: 0,
              max: 100,
              divisions: 20,
              onChanged: (double v) => setState(() => _globalRond = v),
            ),
            if (_variant.isEmphasized)
              PlaySwitch(
                label: 'Emphasized GRAD (+50)',
                value: _emphasizedGrad,
                onChanged: (bool v) => setState(() => _emphasizedGrad = v),
              ),
          ],
        ),
        PlayControlPanel(
          title: 'Brand / body groups',
          children: <Widget>[
            PlaySwitch(
              label: 'Group ROND overrides',
              value: _groupOverrides,
              onChanged: (bool v) => setState(() => _groupOverrides = v),
            ),
            if (_groupOverrides) ...<Widget>[
              PlaySlider(
                label: 'Brand ROND',
                value: _brandRond,
                min: 0,
                max: 100,
                divisions: 20,
                onChanged: (double v) => setState(() => _brandRond = v),
              ),
              PlaySlider(
                label: 'Body ROND',
                value: _bodyRond,
                min: 0,
                max: 100,
                divisions: 20,
                onChanged: (double v) => setState(() => _bodyRond = v),
              ),
            ],
          ],
        ),
        PlayControlPanel(
          title: 'Advanced axes',
          children: <Widget>[
            PlaySwitch(
              label: 'Enable advanced axes',
              value: _advancedEnabled,
              onChanged: (bool v) => setState(() => _advancedEnabled = v),
            ),
            if (_advancedEnabled) ...<Widget>[
              PlaySlider(
                label: 'wdth',
                value: _wdth,
                min: 50,
                max: 151,
                divisions: 20,
                onChanged: (double v) => setState(() => _wdth = v),
              ),
              PlaySlider(
                label: 'slnt',
                value: _slnt,
                min: -10,
                max: 0,
                divisions: 10,
                onChanged: (double v) => setState(() => _slnt = v),
              ),
              PlaySlider(
                label: 'GRAD',
                value: _grad,
                min: -50,
                max: 150,
                divisions: 20,
                onChanged: (double v) => setState(() => _grad = v),
              ),
              PlaySlider(
                label: 'ytas',
                value: _ytas,
                min: 649,
                max: 854,
                divisions: 20,
                onChanged: (double v) => setState(() => _ytas = v),
              ),
              PlaySlider(
                label: 'ytde',
                value: _ytde,
                min: -500,
                max: -100,
                divisions: 20,
                onChanged: (double v) => setState(() => _ytde = v),
              ),
              PlaySlider(
                label: 'ytlc',
                value: _ytlc,
                min: 416,
                max: 570,
                divisions: 20,
                onChanged: (double v) => setState(() => _ytlc = v),
              ),
              PlaySlider(
                label: 'ytuc',
                value: _ytuc,
                min: 649,
                max: 854,
                divisions: 20,
                onChanged: (double v) => setState(() => _ytuc = v),
              ),
            ],
          ],
        ),
        PlayControlPanel(
          title: 'Conversion',
          children: <Widget>[
            PlaySwitch(
              label: 'Convert from custom TextStyle',
              value: _convertFromCustom,
              onChanged: (bool v) => setState(() => _convertFromCustom = v),
            ),
            if (_convertFromCustom)
              PlaySlider(
                label: 'Custom font size',
                value: _customFontSize,
                min: 11,
                max: 57,
                divisions: 46,
                onChanged: (double v) => setState(() => _customFontSize = v),
              ),
          ],
        ),
      ],
    );
  }

  Widget _readout(M3EThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label: $value',
        style: theme.typeScale.bodySmall.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
