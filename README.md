# Material 3 Expressive

A faithful Flutter implementation of the
[Material 3](https://m3.material.io/components) **Expressive** component set.

Every widget is exposed as a direct `M3E*` class with spring-driven press
feedback, shape morphing, and hover/focus/press state layers. Design tokens
(color, typography, motion, shapes, elevation) are provided through
`M3ETheme`.

Runtime dependencies are intentionally small — see
[Dependencies](#dependencies) for the packages declared in
[`pubspec.yaml`](pubspec.yaml).

### Samples

| Actions | Selection |
| :-----: | :-------: |
| ![Actions — buttons, FABs, and button groups](https://raw.githubusercontent.com/paadevelopments/material_3_expressive/main/assets/asset_1.gif) | ![Selection — segmented controls, chips, menus, and sliders](https://raw.githubusercontent.com/paadevelopments/material_3_expressive/main/assets/asset_2.gif) |

| Containment | Navigation |
| :---------: | :--------: |
| ![Containment — pickers, cards, lists, and dialogs](https://raw.githubusercontent.com/paadevelopments/material_3_expressive/main/assets/asset_3.gif) | ![Navigation — app bars, tabs, nav bar, and toolbars](https://raw.githubusercontent.com/paadevelopments/material_3_expressive/main/assets/asset_4.gif) |

| Feedback |
| :------: |
| ![Feedback — progress, badges, text fields, and snackbars](https://raw.githubusercontent.com/paadevelopments/material_3_expressive/main/assets/asset_5.gif) |

## Example app

Try the live gallery on the web:
[paadevelopments.github.io/material_3_expressive](https://paadevelopments.github.io/material_3_expressive/).

An interactive gallery demonstrating **all 44 widgets** also lives in the
[`example/`](example/) directory (same build as the live demo). It groups
components the same way as the official Material 3 catalog, with a live
playground per component under [`example/lib/pages/playground/`](example/lib/pages/playground/).
Each playground includes a **Code** section with paste-ready Dart that tracks
the current controls (copy to clipboard).

| Tab | Playgrounds | Components |
| --- | ----------- | ---------- |
| **Do** | [`playground/do/`](example/lib/pages/playground/do/) | Buttons, FABs, FAB menu, groups, segmented & split buttons |
| **Pick** | [`playground/pick/`](example/lib/pages/playground/pick/) | Checkbox, radio, switch, chips, dropdown, slider (incl. wavy), pickers |
| **View** | [`playground/view/`](example/lib/pages/playground/view/) | Cards, carousel, lists, selection, divider, dialogs, sheets, shapes, typography |
| **Nav** | [`playground/nav/`](example/lib/pages/playground/nav/) | App bars (incl. search), tabs, nav bar/rail/drawer, toolbar, menu |
| **Find** | [`playground/find/`](example/lib/pages/playground/find/) | Badges, progress, refresh, tooltip, snackbar, inputs |

The gallery shell in [`example/lib/main.dart`](example/lib/main.dart) uses
`M3EMaterialApp` with adaptive theming, a light/dark toggle, and a palette
action that opens [`theme_config_page.dart`](example/lib/pages/theme_config_page.dart)
(auto theming, dynamic color, five seed colors, and font family — default
**Google Sans Flex**). For type scale, variable-font axes, and style
conversion, use the **Typography** playground under the View tab.

```bash
cd example
flutter run
```

## Features

- **44 widgets** across 39 component modules, covering Actions, Selection,
  Containment, Navigation, and Feedback (communication + text input).
- **Direct component API** — construct each `M3E*` widget directly; enums and
  models are exported from a single library import. Action surfaces accept
  optional gradient decorations (fill, foreground, overlay, outline).
- **Expressive motion & interaction** — spring physics (via [`motor`](https://pub.dev/packages/motor)),
  shape morphing, liquid selection indicators, shared haptics (`M3EHaptics`), and
  proper state layers on every interactive surface.
- **Design token foundations** — color schemes, typography, motion, shapes
  (including [`material_new_shapes`](https://pub.dev/packages/material_new_shapes)
  morph polygons), spacing and radius via `M3EDimensions`, elevation, haptics,
  and state layers via the `M3ETheme` inherited widget.
- **Interactive example gallery** — run locally from [`example/`](example/), or
  open the [live web demo](https://paadevelopments.github.io/material_3_expressive/).

## Requirements

| Tool    | Version    |
| ------- | ---------- |
| Flutter | `>= 3.47.0` |
| Dart    | `^3.13.0`  |

## Migrating to `material_ui`

This package uses [`material_ui`](https://pub.dev/packages/material_ui) `^1.4.0`
for Material widgets (`MaterialApp`, `ThemeData`, `ColorScheme`, and the rest of
the Material library). **Do not import** `package:flutter/material.dart`.

```dart
import 'package:material_ui/material_ui.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
```

Apps that still import `package:flutter/material.dart` should switch those
imports to `package:material_ui/material_ui.dart`. Flutter **3.47.0 or newer**
(Dart **3.13.0+**) is required (`material_ui` will not resolve on older SDKs).

`ColorScheme.harmonized()` / `Color.harmonizeWith()` come from
[`dynamic_color`](https://pub.dev/packages/dynamic_color) `^2.1.0` (re-exported
through this package). Prefer those APIs rather than a local duplicate.

## What's new in 1.1.3

Summary of updates since 1.1.2 (details in [`CHANGELOG.md`](CHANGELOG.md)):

- **Deps** — `material_ui` `^1.4.0`; Flutter SDK constraint `>=3.47.0` (Dart `^3.13.0`)
  (FVM `3.47.0`).
- **Buttons** — `M3EButton` size/color/shape defaults match M3E specs (XS
  padding/gap, outline widths by size, outlined roles, disabled opacity,
  shape spring 1400/0.9, press overlay + `InkSparkle`, single-line labels
  with 200% text allowance). **Breaking:** selection lives on `M3EButton`
  (`isSelected` / `selectedIcon` / `selectedLabel`); `M3EToggleButton` is
  removed (no toggle text).
- **Button groups** — module moved to `button_group`; theme is
  `buttonGroupTheme`. Actions use `selected*` / `isSelected`; spacing and
  connected radii follow per-size tokens. All actions are `M3EButton` (icon /
  text / both) with optional `minWidth`. Groups support required selection,
  surface-filling connected layout (`maxWidth` cap), and spring-driven
  neighbour squish. Keyboard traversal is Tab-only.
- **Icon buttons** — `M3EIconButton` tokens match M3E specs (radii, outline
  widths, toggle/default color roles, spring 1400/0.9, press overlay +
  `InkSparkle`, focus-ring chrome). **Breaking:** default variant is
  **`filled`**.

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  material_3_expressive: ^1.1.3
```

Then fetch it:

```bash
flutter pub get
```

Or add it from the command line:

```bash
flutter pub add material_3_expressive
```

## Dependencies

External packages declared in [`pubspec.yaml`](pubspec.yaml):

| Package | Role in this library |
| ------- | -------------------- |
| [`flutter`](https://api.flutter.dev/) | SDK — widgets, painting, gestures |
| [`material_ui`](https://pub.dev/packages/material_ui) | Official Material widget library (`MaterialApp`, `ThemeData`, `ColorScheme`) |
| [`collection`](https://pub.dev/packages/collection) | Small collection helpers used by component logic |
| [`dynamic_color`](https://pub.dev/packages/dynamic_color) | Platform dynamic / Material You seed colors for `M3EMaterialApp` (`dynamicColoring`); `ColorScheme.harmonized` / `Color.harmonizeWith` (2.x, `material_ui`) |
| [`motor`](https://pub.dev/packages/motor) | Unified motion API — physics springs and curves that drive expressive morphs and liquid selection indicators |
| [`material_new_shapes`](https://pub.dev/packages/material_new_shapes) | Expressive `RoundedPolygon` morph shapes (`M3EMaterialNewShapes`, `M3EShapeKind`, `M3EShapeClipper`, `M3EShapeContainer`) used by loading / shape-driven surfaces |

Dev-only: [`flutter_lints`](https://pub.dev/packages/flutter_lints), [`flutter_test`](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html), and [`custom_lint`](https://pub.dev/packages/custom_lint).

## Quick start

Import the library — a single import exposes every component and foundation:

```dart
import 'package:material_3_expressive/material_3_expressive.dart';
```

### Recommended: `M3EMaterialApp`

Wrap your app in `M3EMaterialApp` for adaptive theming, dynamic color, and
Material `ThemeMode` alignment (same pattern as the example gallery):

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return M3EMaterialApp(
      title: 'My App',
      data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
      autoTheming: true,
      dynamicColoring: true,
      drawUnderSystemBars: true, // transparent system bars, edge-to-edge layout
      home: const HomePage(),
    );
  }
}
```

Surfaces draw behind the OS navigation bar; components such as `M3ENavigationBar`
keep interactive content above the gesture area via `viewPadding`.

Actionable controls draw an outset **keyboard focus ring** when focused via
Tab (hidden after pointer interaction). Override globally with
`focusRingTheme` / `keyboardFocusIndicators` on `M3EThemeData`, or try the
example **Focus rings** playground (View tab):

```dart
M3EThemeData.light(seedColor: seed).copyWith(
  keyboardFocusIndicators: true,
  focusRingTheme: const M3EFocusRingTheme(
    color: Color(0xFF6750A4),
    width: 2,
    gap: 2,
  ),
);
```

### Alternative: `M3ETheme` subtree

If you already have an app shell, wrap any subtree in `M3ETheme`:

```dart
M3ETheme(
  data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
  child: myApp,
);
```

Use `M3EThemeData.dark(...)` for a dark scheme. If no `M3ETheme` is found,
components fall back to a default light theme.

### Accessing theme tokens

```dart
final theme = M3ETheme.of(context);
final scheme = theme.colorScheme;
final type = theme.typeScale;

// Toggle brightness at runtime (requires adaptive M3EMaterialApp / M3EThemeScope)
M3ETheme.controllerOf(context)?.toggleBrightness(
  fallback: theme.brightness,
  autoTheming: true,
);
```

## Theming

`M3EThemeData` bundles expressive tokens and per-component themes:

```dart
final theme = M3EThemeData.light(
  seedColor: const Color(0xFF6750A4),
);

// Override a single component theme
final custom = theme.copyWith(
  buttonTheme: M3EButtonTheme.defaults.copyWith(/* ... */),
);
```

Key properties on `M3EThemeData`:

- `colorScheme` — `M3EColorScheme` with M3 semantic roles
- `typography` — `M3ETypography` with baseline and emphasized scales (30 styles)
- `typeScale` — baseline alias for `typography.baseline` (used by components)
- `spacing`, `visualDensity`, per-component `*Theme` extensions
- `focusRingTheme` / `keyboardFocusIndicators` — keyboard focus chrome
- Per-component `M3ESpring` motion fields on themes such as `switchTheme`,
  `fabMenuTheme`, `navigationRailTheme`, `listTheme`, `toolbarTheme`,
  `sliderTheme`, `iconButtonTheme`, `checkboxTheme`, and
  `refreshIndicatorTheme` (defaults preserve prior hard-coded springs)

The M3 type system has 15 baseline and 15 emphasized roles. Use emphasized
styles for selection, actions, and editorial hierarchy:

```dart
final theme = M3ETheme.of(context);
Text('Headline', style: theme.typography.emphasized.headlineSmall);
```

Shared typography (font family, fallback, package, size factor/delta, color,
decoration, brand/plain typefaces, and variable-font axes) is applied through
`M3ETypography.apply` or theme `copyWith` — not a full `TextStyle`:

```dart
final themed = M3EThemeData.light(seedColor: seed).copyWith(
  typography: M3ETypography.material3().apply(
    fontFamily: 'Roboto Flex',
    fontVariations: M3ETypeVariations.graded.variations,
  ),
);

// Sugar: same result without building typography by hand
final alsoThemed = M3EThemeData.light(seedColor: seed).copyWith(
  fontFamily: 'Roboto Flex',
  fontVariations: M3ETypeVariations.graded.variations,
);

// Per-role variable-font axes (opsz, wght, split ROND, emphasized GRAD)
final variable = M3EThemeData.light(seedColor: seed).copyWith(
  fontFamily: 'Roboto Flex',
  typeScaleMode: M3ETypeScaleMode.variable,
  variableFont: const M3EVariableFontConfig(
    global: M3EVariableFontAxes(wght: 500, opsz: 16),
    brand: M3EVariableFontAxes(rond: 25),
    body: M3EVariableFontAxes(rond: 50),
  ),
);

// Convert any TextStyle to a spec variant
final converted = M3ETypeStyleConversion.toVariant(
  Theme.of(context).textTheme.bodyLarge!,
  variant: M3ETypeScaleVariant.emphasized,
  role: M3ETypeRole.bodyLarge,
);

// Customize token fields before building a TextStyle
final tokens = M3ETypeStyleTokens.fromTextStyle(style).copyWith(
  letterSpacing: 0.25,
);
final custom = tokens.toTextStyle(fontFamily: 'Roboto Flex');
```

`M3EMaterialApp` additionally supports `autoTheming` (platform brightness) and
`dynamicColoring` (OS seed color on supported platforms — Material You primary
on Android 12+, accent color on desktop — with schemes generated via
`ColorScheme.fromSeed`). Pass `fontFamily` / `fontFamilyFallback` /
`fontVariations`, `typeScaleMode`, `typeface`, or `variableFont` to apply
type-scale knobs at the shell. Use [`buildM3EThemeDefaults()`](lib/foundations/theme/m3e_theme_defaults.dart)
to assemble a full [`M3EThemeData`](lib/foundations/theme/m3e_theme_data.dart)
from core tokens, or [`M3EDynamicColorHost`](lib/foundations/theme/m3e_dynamic_color_host.dart)
when you need device dynamic color outside `M3EMaterialApp`:

```dart
M3EMaterialApp(
  data: M3EThemeData.light(seedColor: seed),
  fontFamily: 'Roboto Flex',
  typeScaleMode: M3ETypeScaleMode.variable,
  variableFont: const M3EVariableFontConfig(),
  home: const HomePage(),
);
```

`M3ETypeVariations` is an enum of Roboto Flex axis presets (`.variations`):
regular, graded (alias for the weight+grade preset formerly named emphasized),
condensed, extra condensed, wide, extra wide, and round. This is not the M3
emphasized type scale — use `theme.typography.emphasized` for that. Static
and mono fonts ignore axes they do not define. The shell projects the baseline
type scale onto `ThemeData.textTheme` and `DefaultTextStyle`.

## Components

<!-- markdownlint-disable MD051 -->

- [Actions](#actions)
- [Selection](#selection)
- [Containment](#containment)
- [Navigation](#navigation)
- [Feedback](#feedback)
- [Modal surfaces](#modal-surfaces)

<!-- markdownlint-enable MD051 -->

Every component is a widget you construct directly. Snippets below use a single
import. Stateful controls show `// in State` where a `setState` wrapper is
needed.

---

### Actions

> See also: [`example/lib/pages/playground/do/`](example/lib/pages/playground/do/) (Do tab)

#### M3EButton

Five color variants with shape morphing on press. Optional
`M3EButtonDecoration` gradients: `backgroundGradient`, `foregroundGradient`
(text/icons), `overlayGradient` (state layer), and `outlineGradient` (stroke
width still comes from `side`).

```dart
M3EButton(
  style: M3EButtonStyle.elevated,
  onPressed: () {},
  child: const Text('Elevated'),
);

M3EButton(
  decoration: M3EButtonDecoration(
    backgroundGradient: WidgetStateProperty.all(
      const LinearGradient(colors: [Color(0xFF6750A4), Color(0xFF9A82DB)]),
    ),
    foregroundGradient: WidgetStateProperty.all(
      const LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFEADDFF)]),
    ),
    outlineGradient: WidgetStateProperty.all(
      const LinearGradient(colors: [Color(0xFF6750A4), Color(0xFF9A82DB)]),
    ),
    side: WidgetStateProperty.all(const BorderSide(width: 1)),
  ),
  onPressed: () {},
  child: const Text('Gradient'),
);
```

#### M3EIconButton

Icon-only actions; supports toggle selection. Optional `visualSize` overrides
the painted control size while hit target follows theme rules. Hover and press
morph container radius (theme `radiusHovered` / press tokens). Pass
`decoration: M3EIconButtonDecoration(...)` for fill, foreground, overlay, and
outline gradients (same fields as `M3EButtonDecoration`).

```dart
M3EIconButton(
  icon: const Icon(M3EIcons.edit),
  variant: M3EIconButtonVariant.filled,
  onPressed: () {},
);

// in State
M3EIconButton(
  icon: const Icon(M3EIcons.add),
  selectedIcon: const Icon(M3EIcons.check),
  isSelected: isFavorite,
  onPressed: () => setState(() => isFavorite = !isFavorite),
);
```

#### M3EFab

Floating action button in four sizes (`small` 40, `regular` 56, `medium` 80
default, `large` 96). Color styles: container (`primary` / `secondary` /
`tertiary`), filled (`primaryFilled` / `secondaryFilled` / `tertiaryFilled`),
and baseline `surface`. Optional `decoration: M3EFabDecoration` for fill,
foreground, overlay, and outline gradients. Override resting / hover elevation
with `elevation` / `hoverElevation` (defaults: level 3 and 4).

Use `M3EFabController` for scroll show/hide, appear morph, and optional
container transform (`openBuilder` or `controller.open`).

```dart
final fabController = M3EFabController();

M3EFabScrollVisibility(
  controller: fabController,
  child: Scaffold(
    body: ListView(...),
    floatingActionButton: M3EFab(
      controller: fabController,
      appear: true,
      icon: const Icon(M3EIcons.add),
      size: M3EFabSize.medium,
      color: M3EFabColor.primaryFilled,
      elevation: 3,
      hoverElevation: 4,
      openBuilder: (context) => const ComposePage(),
      onPressed: () {},
    ),
  ),
);
```

```dart
M3EFab(
  icon: const Icon(M3EIcons.add),
  size: M3EFabSize.large,
  color: M3EFabColor.tertiary,
  elevation: 3,
  hoverElevation: 4,
  onPressed: () {},
);
```

#### M3EExtendedFab

Extended FAB with a required text label and optional icon (no icon-only).
Three sizes via `M3EExtendedFabSize`: `small` 56 (default), `medium` 80,
`large` 96 — matching FAB container radii (16 / 20 / 28) and stepped label
type (titleMedium / titleLarge / headlineSmall). Reuses `M3EFabColor` and
`M3EFabDecoration`. Focus ring is 3dp / 2dp gap / `secondary`.

Use `M3EExtendedFabController` for scroll expand/collapse, appear morph, and
optional container transform (`openBuilder` or `controller.open`).

```dart
final fabController = M3EExtendedFabController();

M3EExtendedFabScrollVisibility(
  controller: fabController,
  child: Scaffold(
    body: ListView(...),
    floatingActionButton: M3EExtendedFab(
      controller: fabController,
      appear: true,
      label: 'Compose',
      icon: const Icon(M3EIcons.edit),
      size: M3EExtendedFabSize.small,
      color: M3EFabColor.primary,
      openBuilder: (context) => const ComposePage(),
      onPressed: () {},
    ),
  ),
);
```

```dart
M3EExtendedFab(
  label: 'Compose',
  icon: const Icon(M3EIcons.edit),
  size: M3EExtendedFabSize.medium,
  color: M3EFabColor.primaryFilled,
  onPressed: () {},
);
```

#### M3EFabMenu

Speed-dial style menu (2–6 items) anchored to a FAB. One menu size pairs with
any `M3EFabSize`; the trigger morphs into a **56dp** circular close button
(icon **20dp**). Color sets follow the FAB style: filled close + container
items (primary / secondary / tertiary; `surface` maps to primary).

Use `M3EFabMenuController` for programmatic open/close. Optional
`M3EFabMenuItem.openBuilder` opens a container transform. When the viewport is
short, items scroll behind the close button. Theme paddings: leading/trailing
**24**, icon–label **8**, between items **4**, close↔items **8**.

```dart
final menuController = M3EFabMenuController();

M3EFabMenu(
  controller: menuController,
  position: M3EFabMenuPosition.right,
  size: M3EFabSize.medium,
  color: M3EFabColor.primary,
  expandIcon: const Icon(M3EIcons.add),
  collapseIcon: const Icon(M3EIcons.close),
  items: [
    M3EFabMenuItem(
      icon: const Icon(M3EIcons.edit),
      label: 'Note',
      onPressed: () {},
      openBuilder: (context) => const NotePage(),
    ),
    M3EFabMenuItem(
      icon: const Icon(M3EIcons.schedule),
      label: 'Reminder',
      onPressed: () {},
    ),
  ],
);
```

#### M3EButtonGroup

Standard or connected button groups. Size tokens set height and between-space;
connected groups use a 2dp gap and fill their width. Optional density, neighbour
squish, single/multi selection (`multiSelect`), and overflow strategies. Actions
are always `M3EButton` — use `minWidth` for icon-only resting widths.

```dart
// in State — single-select
M3EButtonGroup(
  selectedIndex: groupIndex,
  onSelectedIndexChanged: (i) => setState(() => groupIndex = i),
  selectionRequired: true,
  actions: const [
    M3EButtonGroupAction(icon: Icon(M3EIcons.arrow_back), minWidth: 40),
    M3EButtonGroupAction(icon: Icon(M3EIcons.add), minWidth: 40),
    M3EButtonGroupAction(icon: Icon(M3EIcons.arrow_forward), minWidth: 40),
  ],
);

// multi-select
M3EButtonGroup(
  multiSelect: true,
  selectedIndices: selected,
  onSelectedIndicesChanged: (s) => setState(() => selected = s),
  type: M3EButtonGroupType.connected,
  actions: const [
    M3EButtonGroupAction(label: Text('Mon')),
    M3EButtonGroupAction(label: Text('Tue')),
    M3EButtonGroupAction(label: Text('Wed')),
  ],
);
```

#### Button selection

Set `M3EButton.isSelected` to enable caller-controlled selection with
round-to-square (or square-to-round) shape morphing. `selectedIcon` and
`selectedLabel` replace their unselected counterparts. Selection is not
available for `M3EButtonStyle.text`. `M3EButtonGroup` accepts a group-level
`M3EButtonDecoration` and per-action `M3EButtonGroupAction.decoration`.

```dart
// in State
M3EButton.filled(
  icon: const Icon(M3EIcons.favorite_border),
  selectedIcon: const Icon(M3EIcons.favorite),
  isSelected: isFavorite,
  onPressed: () => setState(() => isFavorite = !isFavorite),
);
```

#### M3ESegmentedButton

Outlined single- or multi-select control (2–5 segments). Density levels
0/−1/−2/−3 shrink height (−4dp/step) from 40dp; touch target stays ≥48dp.
Selected segments use `secondaryContainer` fill and an optional check that
replaces the category icon. Theme `M3ESegmentedButtonTheme` exposes outline,
divider, focus ring (3dp / `secondary`), disabled opacities, and color or
gradient overrides. Large-screen width can be capped via
`segmentedButtonTheme.maxWidth` (null = unconstrained).

```dart
// in State — single select
M3ESegmentedButton<String>(
  segments: const [
    M3ESegment(value: 'list', label: 'List'),
    M3ESegment(value: 'grid', label: 'Grid'),
  ],
  selected: viewMode,
  onSelectionChanged: (v) => setState(() => viewMode = v),
);

// multi select
M3ESegmentedButton<String>(
  multiSelect: true,
  density: M3ESegmentedButtonDensity.comfortable,
  segments: const [
    M3ESegment(value: 'new', label: 'New'),
    M3ESegment(value: 'sale', label: 'Sale'),
  ],
  selected: filters,
  onSelectionChanged: (v) => setState(() => filters = v),
);
```

#### M3ESplitButton

Primary action with a trailing menu (XS–XL; elevated / filled / tonal /
outlined). Between-segment gap is **2dp**; pressed inner corners match hovered
(**8 / 12 / 12 / 20 / 20**). Closed trailing uses optical pads + offset; open
trailing centers the chevron (180° standard-motion rotate) with 50% selected
corners. Shared button color roles; open trailing applies a state layer only
(no toggle recolor). Use `items`, or `m3eMenuBuilder` for a rich M3E menu.
Gradients on `M3ESplitButtonDecoration` span both segments; optional trailing
color/gradient overrides apply to the menu half. Menu sits **4dp** from the
control.

```dart
M3ESplitButton<String>(
  label: 'Save',
  leadingIcon: M3EIcons.check,
  onPressed: () {},
  onSelected: (value) {},
  items: const [
    M3ESplitButtonItem(value: 'draft', child: Text('Save as draft')),
    M3ESplitButtonItem(value: 'copy', child: Text('Save a copy')),
  ],
);

M3ESplitButton<String>(
  label: 'Share',
  items: null,
  onSelected: (value) {},
  m3eMenuBuilder: (context) => [
    M3EMenuSelectable(label: 'Copy link', value: 'link'),
    const M3EMenuDivider(),
    M3EMenuSelectable(label: 'Email', value: 'email'),
  ],
);
```

---

### Selection

> See also: [`example/lib/pages/playground/pick/`](example/lib/pages/playground/pick/) (Pick tab)

#### M3ECheckbox

Binary and tristate checkbox. The control is an **18dp** box with **2dp**
corners and an **18dp** icon, inside a **40dp** circular state layer and a
**48dp** target. Optional `label` (on surface; tapping it toggles), `boxSize`,
`hitSize`, `targetSize`, `checkedChild` / `uncheckedChild`, and
`checkIconPadding` (default none). Value changes use a spatial-spring pulse.
Keyboard: Tab, then Space or Enter.

```dart
// in State
M3ECheckbox(
  value: checked,
  onChanged: (v) => setState(() => checked = v),
);

M3ECheckbox(
  value: tristateValue,
  tristate: true,
  label: const Text('Remember me'),
  onChanged: (v) => setState(() => tristateValue = v),
);
```

#### M3ERadio

Mutually exclusive selection within a group. Optional [label] is part of the
tap target.

```dart
// in State
M3ERadio<String>(
  value: 'pro',
  groupValue: plan,
  label: const Text('Pro'),
  onChanged: (v) => setState(() => plan = v),
);
```

#### M3ESwitch

On/off toggle with optional selected icon. Hover/focus/press paints a
thumb-centered translucent state layer (`stateLayerSize`, default 48 via theme).
Pressed thumb expands to the track edges (`thumbSizePressed` defaults to
`trackHeight`).

```dart
// in State
M3ESwitch(
  value: wifiEnabled,
  selectedIcon: const Icon(M3EIcons.check),
  onChanged: (v) => setState(() => wifiEnabled = v),
);

M3ESwitch(
  value: bluetoothEnabled,
  stateLayerSize: 56,
  onChanged: (v) => setState(() => bluetoothEnabled = v),
);
```

#### M3EChip

Assist, filter, input, and suggestion chip types.

```dart
M3EChip(
  label: 'Assist',
  leading: const Icon(M3EIcons.edit),
  onPressed: () {},
);

// in State — filter chip
M3EChip(
  label: 'Flutter',
  type: M3EChipType.filter,
  selected: chips.contains('flutter'),
  onPressed: () => toggleChip('flutter'),
);
```

#### M3EDropdownMenu

Static list, multi-select, search, and async loading. When search is enabled,
the in-panel field defaults to `surface` fill and the panel container radius.
Optional `limit` caps how many items can be selected in multi-select (`null` =
unlimited). Optional `openMotion` / `closeMotion` override theme
`M3EDropdownMenuTheme.openSpring` / `closeSpring` (null → theme).

```dart
// Single select
M3EDropdownMenu<String>(
  singleSelect: true,
  items: const [
    M3EDropdownItem(label: 'Flutter', value: 'flutter'),
    M3EDropdownItem(label: 'Dart', value: 'dart'),
  ],
  fieldStyle: const M3EDropdownFieldStyle(hintText: 'Choose a framework'),
  onSelectionChanged: (items) {},
);

// Multi select with search (and optional selection cap)
M3EDropdownMenu<String>(
  searchEnabled: true,
  limit: 2,
  items: const [
    M3EDropdownItem(label: 'Layout', value: 'layout'),
    M3EDropdownItem(label: 'Theming', value: 'theming'),
  ],
  fieldStyle: const M3EDropdownFieldStyle(hintText: 'Select skills'),
  onSelectionChanged: (items) {},
);

// Async items
M3EDropdownMenu<String>.future(
  singleSelect: true,
  future: () async => [
    const M3EDropdownItem(label: 'Ghana', value: 'gh'),
    const M3EDropdownItem(label: 'Kenya', value: 'ke'),
  ],
  fieldStyle: const M3EDropdownFieldStyle(hintText: 'Load countries'),
  onSelectionChanged: (items) {},
);
```

#### M3ESlider

Compose Material 3 expressive slider — standard, centered, wavy, vertical, and
range. Optional `trackThickness`, `cornerRadius`, `thumbLength`, `dotSize`,
`dotSpacing`, and `dotBuilder` customize track, thumb, and stop/tick markers.
`cornerRadius` defaults to theme `trackCornerRadius` (8) and is not derived
from track thickness. Tap outside the slider clears focus.

```dart
// in State
M3ESlider(
  value: volume,
  onChanged: (v) => setState(() => volume = v),
);

M3ESlider(
  value: brightness,
  max: 5,
  divisions: 5,
  onChanged: (v) => setState(() => brightness = v),
);

// Wavy active value (inactive track stays flat)
M3ESlider.wavy(
  value: progress,
  onChanged: (v) => setState(() => progress = v),
);

M3ESlider.centered(
  value: balance,
  min: -100,
  max: 100,
  onChanged: (v) => setState(() => balance = v),
);

// Custom track / thumb / end dots (size & edge padding)
M3ESlider(
  value: level,
  max: 4,
  divisions: 4,
  trackThickness: 30,
  cornerRadius: 8,
  thumbLength: 50,
  dotSize: 12,
  dotSpacing: 10,
  onChanged: (v) => setState(() => level = v),
  dotBuilder: ({
    required context,
    required color,
    required size,
    required active,
  }) {
    // e.g. paint M3EMaterialNewShapes.cookie4Sided / softBurst
    return ColoredBox(color: color);
  },
);

M3ERangeSlider(
  values: range,
  onChanged: (v) => setState(() => range = v),
);

M3ERangeSlider.wavy(
  values: range,
  onChanged: (v) => setState(() => range = v),
);

SizedBox(
  height: 160,
  width: 48,
  child: M3ESlider.vertical(
    value: level,
    onChanged: (v) => setState(() => level = v),
  ),
);
```

#### M3EDatePicker

Dialog and inline calendar date pickers.

```dart
// Inline calendar
M3ECalendarDatePicker(
  initialDate: date,
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
  onDateChanged: (v) => setState(() => date = v),
);

// Dialog
final picked = await M3EDatePicker.show(
  context,
  initialDate: date,
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
);

// Range dialog
final range = await M3EDatePicker.showRange(
  context,
  firstDate: DateTime(2020),
  lastDate: DateTime(2030),
);
```

#### M3ETimePicker

Dialog and dial-style time picker.

```dart
// Dialog
final M3ETime? picked = await M3ETimePicker.show(
  context,
  initialTime: time,
);

// Inline dial
M3EDialTimePicker(
  value: time,
  onChanged: (v) => setState(() => time = v),
);
```

---

### Containment

> See also: [`example/lib/pages/playground/view/`](example/lib/pages/playground/view/) (View tab)

#### M3ECard

Elevated, filled, and outlined surface for content and actions.

```dart
M3ECard(child: const Text('Elevated'));

M3ECard(
  variant: M3ECardVariant.filled,
  child: const Text('Filled'),
);

M3ECard(
  variant: M3ECardVariant.outlined,
  onPressed: () {},
  child: const Text('Outlined (tap)'),
);
```

#### M3ECarousel

Hero, contained, and uncontained layouts — horizontal by default, or vertical
via `axis`. Use `onChange` for leading/focal index updates (e.g. hide labels on
smaller items).

```dart
M3ECarousel(
  type: M3ECarouselType.hero,
  heroAlignment: M3ECarouselHeroAlignment.center,
  onTap: (index) {},
  onChange: (details) {
    // details.focalIndex / details.leadingIndex / details.isFocal(i)
  },
  children: List.generate(10, (i) => ColoredBox(color: Colors.blue)),
);
```

#### M3EListItem

Standard list row with headline, supporting text, and slots. Optional
`variant` / `border` control the standalone card outline.

```dart
M3EListItem(
  headline: 'Wireless charging',
  supportingText: 'On · Fast charge enabled',
  leading: const Icon(M3EIcons.schedule),
  trailing: const Icon(M3EIcons.chevron_right),
  variant: M3ECardVariant.outlined,
  onTap: () {},
);
```

#### M3ECardList

Vertically stacked cards with dynamic corner rounding. Pass
`variant: M3ECardVariant.outlined` (or `border`) for outlined cards.
Enable list-owned `selection` / `reorder`, or nest with `embedded: true`
(all rows use inner radii).

```dart
M3ECardList(
  variant: M3ECardVariant.outlined,
  itemCount: 3,
  onTap: (index) {},
  itemBuilder: (context, index) => M3EListItem(
    headline: 'Inbox',
    leading: const Icon(M3EIcons.schedule),
  ),
);

// Selection + reorder (theme: M3EListTheme.selection / .reorder)
M3ECardList(
  selection: true,
  reorder: true,
  onReorder: (oldIndex, newIndex) {},
  selectionState: const M3EListSelectionState(
    mode: M3EListSelectionMode.multiple,
    trigger: M3EListSelectionTrigger.icon,
    selectedIcon: Icon(M3EIcons.check),
  ),
  itemCount: items.length,
  itemBuilder: (context, index) => M3EListItem(headline: items[index]),
);

// Scrollable / lazy
M3ECardList.builder(
  itemCount: 20,
  shrinkWrap: true,
  itemBuilder: (context, index) => M3EListItem(
    headline: 'Item $index',
  ),
);
```

#### M3ESelection

Multi-select host: optional [M3ESelectionController], [M3ESelectionAppBar]
(idle header → contextual bar + select-all; `idle` is any [Widget]), and any
list [body] ([M3ECardList], [M3EDismissibleList], …). Selected rows pick up
`selectedColor` (or `M3ESelectionTheme.highlightColor`, default
`secondaryContainer`) automatically — no `colorBuilder` required for the
highlight. Prefer list-owned `selection: true` on the body when you want
built-in flip / double-tap triggers; otherwise use `borderRadiusBuilder` for
selected-item corner morph, gestures (`onTap` / `onLongPress`), and
[M3ESelectionLeading] on each item. Wrap with [PopScope] so system back clears
selection first. Prefer
`listPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8)`.

```dart
final selection = M3ESelectionController();

PopScope(
  canPop: !selection.isSelectionMode,
  onPopInvokedWithResult: (didPop, _) {
    if (!didPop) selection.clear();
  },
  child: M3ESelection(
    controller: selection,
    itemCount: items.length,
    selectedColor: const Color(0xFFC8E6C9),
    appBar: M3ESelectionAppBar(
      idle: M3EAppBar.search(
        searchController: searchController,
        suggestionsBuilder: (_, __) => const [],
        barHintText: 'Search items',
      ),
      actions: [
        M3EIconButton(icon: Icon(M3EIcons.archive), onPressed: () {}),
        M3EIconButton(icon: Icon(M3EIcons.delete), onPressed: () {}),
      ],
    ),
    body: M3ECardList.builder(
      itemCount: items.length,
      listPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      selection: true,
      selectionController: selection,
      selectionState: const M3EListSelectionState(
        selectedIcon: Icon(M3EIcons.check),
      ),
      itemBuilder: (context, i) => M3EListItem(headline: items[i]),
    ),
  ),
);
```

Advanced: wire `M3ESelectionAppBar` + a shared controller yourself (omit
`M3ESelection`), or pass `M3EDismissibleList` as `body` for swipe + select.
An explicit `colorBuilder` still wins over the selection highlight.

#### M3EDismissibleColumn

Vertically swipeable card list with expressive physics. Supports list-owned
`selection` and `reorder` (same tokens as card list). Optional
`leadingActionsBuilder` / `trailingActionsBuilder` reveal icon actions
(`M3EListSwipeAction`) with preview snap; a side with no actions still
full-dismisses.

```dart
M3EDismissibleColumn(
  itemCount: 3,
  selection: true,
  reorder: true,
  onReorder: (oldIndex, newIndex) {},
  onDismiss: (index, direction) async => true,
  trailingActionsBuilder: (index) => [
    M3EListSwipeAction(
      icon: const Icon(M3EIcons.archive),
      onPressed: () {},
    ),
    const M3EListSwipeAction(
      icon: Icon(M3EIcons.delete),
      isPrimary: true,
    ),
  ],
  onTap: (index) {},
  itemBuilder: (context, index) => M3EListItem(
    headline: 'Swipe to dismiss',
    leading: const Icon(M3EIcons.schedule),
  ),
);
```

#### M3EDismissibleList

Horizontal swipeable card list — same API as `M3EDismissibleColumn`.

```dart
SizedBox(
  height: 120,
  child: M3EDismissibleList(
    itemCount: 5,
    onDismiss: (index, direction) async => true,
    itemBuilder: (context, index) => M3EListItem(
      headline: 'Card $index',
    ),
  ),
);
```

#### M3EExpandableList

Expandable cards with expressive open/close motion. Use
`M3EExpandableExpanded.list` for a nested list (e.g. `M3ECardList` with
`embedded: true`) or `.content` for freeform body content. Header rows support
list-owned `selection` / `reorder` (nested lists keep their own APIs; expanded
rows snap-collapse for reorder). Optional `expandMotion` / `collapseMotion`
override theme springs.

```dart
M3EExpandableList(
  selection: true,
  reorder: true,
  onReorder: (oldIndex, newIndex) {},
  data: [
    M3EExpandableData(
      title: 'Battery level low',
      subtitle: 'Plug in your device.',
      leading: const Icon(M3EIcons.battery_alert),
      expanded: M3EExpandableExpanded.content(
        const Text('Your battery is at 10%.'),
      ),
    ),
    M3EExpandableData(
      title: 'Nested list',
      expanded: M3EExpandableExpanded.list(
        M3ECardList(
          embedded: true,
          itemCount: 3,
          itemBuilder: (context, i) => M3EListItem(headline: 'Child $i'),
        ),
      ),
    ),
  ],
);

// Scrollable variant for long lists
M3EExpandableList.scrollable(
  data: expandableItems,
  shrinkWrap: true,
);

// Sliver variant for CustomScrollView
CustomScrollView(
  slivers: [
    M3EExpandableList.sliver(data: expandableItems),
  ],
);
```

#### M3EDivider

Horizontal and vertical dividers.

```dart
const M3EDivider();

Row(
  children: [
    const Text('Left'),
    const SizedBox(width: 12),
    const M3EDivider(axis: M3EDividerAxis.vertical),
    const SizedBox(width: 12),
    const Text('Right'),
  ],
);
```

#### M3EDialog

Modal dialog — use the static `.show` helper. Optional `topDivider` /
`bottomDivider` draw full-bleed lines between header, content, and actions
(padding lives on those sections so dividers can reach the edges).

```dart
M3EDialog.show<void>(
  context,
  dialog: M3EDialog(
    title: 'Reset settings?',
    content: const Text('This restores default values.'),
    topDivider: true,
    bottomDivider: true,
    actions: [
      M3EButton(
        style: M3EButtonStyle.text,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      M3EButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Reset'),
      ),
    ],
  ),
);

// Selection list (single or multi); confirm disabled until a choice is made
final List<String>? picked = await M3EDialog.showSelectionScreen(
  context,
  title: 'Choose a plan',
  options: const <String>['Standard', 'Pro', 'Team'],
  multiSelect: false,
);

// Full-screen variant
M3EDialog.showFullScreen<void>(
  context,
  title: 'New event',
  body: const Padding(
    padding: EdgeInsets.all(24),
    child: Text('Full-screen dialog body.'),
  ),
);
```

#### M3EBottomSheet

Modal bottom sheet — use `.show`.

```dart
M3EBottomSheet.show<void>(
  context,
  builder: (context) => const Padding(
    padding: EdgeInsets.all(24),
    child: Text('A modal bottom sheet with a drag handle.'),
  ),
);
```

#### M3ESideSheet

Side sheet panel — use `.show`.

```dart
M3ESideSheet.show<void>(
  context,
  title: 'Filters',
  body: const Padding(
    padding: EdgeInsets.all(24),
    child: Text('Side sheet content.'),
  ),
);
```

---

### Navigation

> See also: [`example/lib/pages/playground/nav/`](example/lib/pages/playground/nav/) (Nav tab)

#### M3EAppBar

Top, search, sliver, and bottom app bar variants. Docked top/bottom bars apply
single-edge `safeArea` padding from `MediaQuery.viewPadding` by default
(opt out with `safeArea: false`).

```dart
M3EAppBar.top(
  titleText: 'Inbox',
  leading: const Icon(M3EIcons.menu),
  actions: const [Icon(M3EIcons.search)],
);

// Anchored search title — tap opens fullscreen (or docked) search.
// Idle pill content (leading + hint + trailing) defaults to Alignment.center.
M3EAppBar.search(
  searchController: searchController,
  barHintText: 'Search mail',
  leading: const Icon(M3EIcons.menu),
  actions: const [Icon(M3EIcons.tune)],
  suggestionsBuilder: (context, controller) sync* {
    yield const ListTile(title: Text('Suggestion'));
  },
);

// Sliver (inside CustomScrollView)
M3EAppBar.sliver(
  titleText: 'Sliver • medium',
  actions: const [Icon(M3EIcons.search)],
);

// Bottom app bar with FAB slot
M3EAppBar.bottom(
  actions: const [Icon(M3EIcons.menu), Icon(M3EIcons.search)],
  floatingActionButton: M3EFab(
    icon: const Icon(M3EIcons.add),
    size: M3EFabSize.small,
    onPressed: () {},
  ),
);
```

#### M3ETabs

Primary and secondary tab bars.

```dart
// in State
M3ETabs(
  selectedIndex: tabIndex,
  onTabSelected: (i) => setState(() => tabIndex = i),
  tabs: const [
    M3ETab(label: 'Overview'),
    M3ETab(label: 'Specs'),
    M3ETab(label: 'Reviews'),
  ],
);

M3ETabs(
  variant: M3ETabsVariant.secondary,
  selectedIndex: tabIndex,
  onTabSelected: (i) => setState(() => tabIndex = i),
  tabs: const [
    M3ETab(label: 'Photos', icon: Icon(M3EIcons.calendar_today)),
    M3ETab(label: 'Albums', icon: Icon(M3EIcons.menu)),
  ],
);
```

#### M3ENavigationBar

Bottom navigation for compact and wide layouts. With `autoLayout: true` (default),
the bar switches to a horizontal icon+label chip group once its own width can fit
all destinations at the fixed wide chip width (`wideDestinationWidth`, default
`128`) — see `M3ENavBarConstants.minWideBarWidth`. Override with `wideBreakpoint`
and/or `wideDestinationWidth`. Wide mode keeps the bar full width and only aligns
the destination group (`alignment`: start / center / end). Destinations may be
icon-only, label-only, or both. Destinations use a click mouse cursor on
desktop/web (same for rail and drawer). Layout enums, theme, and
`M3ENavBarConstants` ship with the navigation bar entry / package barrel.

```dart
// in State
M3ENavigationBar(
  destinations: const [
    M3ENavigationBarDestination(icon: Icon(M3EIcons.menu), label: 'Home'),
    M3ENavigationBarDestination(
      icon: Icon(M3EIcons.search),
      label: 'Search',
      badgeDot: true,
    ),
  ],
  selectedIndex: barIndex,
  onDestinationSelected: (i) => setState(() => barIndex = i),
);

// Force wide layout (autoLayout off) with end-aligned chips
M3ENavigationBar(
  autoLayout: false,
  layout: M3ENavBarLayout.wide,
  alignment: M3ENavBarAlignment.end,
  wideDestinationWidth: 128,
  iconBehavior: M3ENavBarIconBehavior.alwaysShow,
  labelBehavior: M3ENavBarLabelBehavior.alwaysShow,
  destinations: const [
    M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
    M3ENavigationBarDestination(label: 'Browse'), // label-only
    M3ENavigationBarDestination(icon: Icon(M3EIcons.radio)), // icon-only
  ],
  selectedIndex: barIndex,
  onDestinationSelected: (i) => setState(() => barIndex = i),
);

// Custom autoLayout breakpoint + chip width
M3ENavigationBar(
  autoLayout: true,
  wideBreakpoint: 720,
  wideDestinationWidth: 140,
  destinations: const [
    M3ENavigationBarDestination(icon: Icon(M3EIcons.home), label: 'Home'),
    M3ENavigationBarDestination(icon: Icon(M3EIcons.search), label: 'Search'),
  ],
  selectedIndex: barIndex,
  onDestinationSelected: (i) => setState(() => barIndex = i),
);
```

#### M3ENavigationRail

Vertical navigation for medium and expanded layouts. Customize the
expand/collapse toggle tooltips with `expandTooltip` / `collapseTooltip`.

```dart
// in State
M3ENavigationRail(
  sections: const [
    M3ENavigationRailSection(
      destinations: [
        M3ENavigationRailDestination(
          icon: Icon(M3EIcons.menu),
          label: 'Home',
        ),
        M3ENavigationRailDestination(
          icon: Icon(M3EIcons.search),
          label: 'Search',
        ),
      ],
    ),
  ],
  selectedIndex: railIndex,
  onDestinationSelected: (i) => setState(() => railIndex = i),
  expandTooltip: 'Expand',
  collapseTooltip: 'Collapse',
  fab: M3ENavigationRailFabSlot(
    icon: const Icon(M3EIcons.add),
    label: 'Compose',
    elevation: 3,
    hoverElevation: 4,
    onPressed: () {},
  ),
);
```

#### M3ENavigationDrawer

Modal navigation drawer.

```dart
// in State
M3ENavigationDrawer(
  headline: 'Mail',
  destinations: const [
    M3ENavigationDestination(icon: Icon(M3EIcons.menu), label: 'Home'),
    M3ENavigationDestination(
      icon: Icon(M3EIcons.search),
      label: 'Search',
      showBadge: true,
    ),
  ],
  selectedIndex: drawerIndex,
  onDestinationSelected: (i) => setState(() => drawerIndex = i),
);
```

#### M3EToolbar

Compose Material 3 expressive floating and docked toolbars. Floating toolbars
own expand/collapse when one action sets `isExpandTrigger` (`expanded` is the
initial state; the adjacent FAB stays visible and does not toggle expansion).
Optional `visibilityController` / `scrollBehavior` enable scroll-exit or manual
show/hide. Set `onActiveIndexChanged` for toolbar-managed action selection
(labeled actions animate width). Use `fabExpandIcon` / `fabCollapseIcon` when a
FAB morphs with the pill. Set `fabExpandsToolbar: false` for a fixed small FAB
that only runs `onFabPressed` (pill stays open). Set `pillActiveSpring: false`
to keep a fixed pill width for labeled selection (widest label + icon-only
neighbors) while action labels still morph.

```dart
// Floating (default) — pill, wrap-content
M3EToolbar(
  actions: <M3EToolbarItem>[
    M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
    M3EToolbarAction(icon: M3EIcons.share, onPressed: () {}),
  ],
);

// Floating + expand trigger + adjacent FAB
M3EToolbar(
  expanded: true,
  onExpandedChanged: (open) {},
  actions: <M3EToolbarItem>[
    M3EToolbarAction(
      icon: M3EIcons.menu,
      isExpandTrigger: true,
      onPressed: () {},
    ),
    M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
    M3EToolbarAction(icon: M3EIcons.share, onPressed: () {}),
  ],
  fabIcon: const Icon(M3EIcons.add),
  fabExpandIcon: const Icon(M3EIcons.add),
  fabCollapseIcon: const Icon(M3EIcons.close),
  onFabPressed: () {},
);

// Small FAB — no pill expand/collapse (only onFabPressed)
M3EToolbar(
  fabExpandsToolbar: false,
  onFabPressed: () {},
  fabExpandIcon: const Icon(M3EIcons.add),
  actions: <M3EToolbarItem>[...],
);

// Action selection (internal active index when onActiveIndexChanged is set)
M3EToolbar(
  onActiveIndexChanged: (i) {},
  actions: <M3EToolbarItem>[
    M3EToolbarAction(
      icon: M3EIcons.edit,
      label: 'Edit',
      onPressed: () {},
    ),
    M3EToolbarAction(icon: M3EIcons.share, onPressed: () {}),
  ],
);

// Labeled selection — fixed pill width (action labels still spring)
M3EToolbar(
  pillActiveSpring: false,
  onActiveIndexChanged: (i) {},
  actions: <M3EToolbarItem>[...],
);

// Scroll-exit / manual visibility
final visibility = M3EToolbarVisibilityController();
M3EToolbarScrollWrapper(
  behavior: M3EToolbarScrollBehavior.exitAlways(controller: visibility),
  child: ListView(...),
);
M3EToolbar(
  visibilityController: visibility,
  actions: <M3EToolbarItem>[...],
);

// Mixed icon actions + custom widgets (widgets stay inline; height-capped)
M3EToolbar(
  actions: <M3EToolbarItem>[
    M3EToolbarAction(icon: M3EIcons.edit, onPressed: () {}),
    M3EToolbarWidget(
      child: M3ESplitButton<String>(
        size: M3EButtonSize.sm,
        label: 'Sort',
        items: const [
          M3ESplitButtonItem(value: 'name', child: 'Name'),
          M3ESplitButtonItem(value: 'date', child: 'Date'),
        ],
        onSelected: (_) {},
      ),
    ),
    M3EToolbarAction(icon: M3EIcons.share, onPressed: () {}),
  ],
);

// Vertical floating
M3EToolbar(
  axis: Axis.vertical,
  colorStyle: M3EToolbarColorStyle.vibrant,
  actions: <M3EToolbarItem>[...],
);

// Docked — full width; safeArea pads only the dock edge
M3EToolbar.docked(
  dockEdge: M3EToolbarDockEdge.bottom,
  safeArea: true,
  titleText: 'Inbox',
  actions: <M3EToolbarItem>[
    M3EToolbarAction(icon: M3EIcons.search, onPressed: () {}),
    M3EToolbarAction(
      icon: M3EIcons.delete,
      label: 'Delete',
      isDestructive: true,
      onPressed: () {},
    ),
  ],
);
```

#### M3EMenu

Anchored dropdown menu. Top-level `M3EMenuGroup`s each render as an elevated
surface with a gap between them; dividers stay inside a surface. Opening the
menu focuses the popup without pre-highlighting the first item.

```dart
M3EMenu(
  anchorBuilder: (context, open) => M3EButton.icon(
    style: M3EButtonStyle.outlined,
    icon: const Icon(M3EIcons.arrow_drop_down),
    label: const Text('Open menu'),
    onPressed: open,
  ),
  children: [
    M3EMenuGroup.entries(
      entries: [
        M3EMenuEntry(
          label: 'Edit',
          leading: const Icon(M3EIcons.edit),
          onPressed: () {},
        ),
        const M3EMenuEntry(label: 'Disabled', enabled: false),
      ],
    ),
    M3EMenuGroup.entries(
      label: 'More',
      entries: [
        M3EMenuEntry(
          label: 'Copy',
          trailingText: '⌘C',
          onPressed: () {},
        ),
      ],
    ),
  ],
);
```

---

### Feedback

> See also: [`example/lib/pages/playground/find/`](example/lib/pages/playground/find/) (Find tab)

#### M3EBadge

Notification **dot** (small, 6dp) or **large** badge (count / status label,
min 16dp) on a child. Colors: **Error** / **On error**. `alignment` is
`topLeft` (leading), `topCenter`, or `topRight` (trailing; default) and
**mirrors in RTL**. Placement uses Compose-style offsets (small **6×6**, large
**12×14** from the anchored corner to the badge bottom-leading). The badge
**overlays** without expanding or shifting the child. Default `maxCount` is
**999** (`999+`). Optional `label` is preferred over `count`. A11y: “New
notification” (dot), “One new notification” / “{n} new notifications”
(count).

```dart
const M3EBadge(
  showDot: true,
  child: Icon(M3EIcons.menu, size: 28),
);

const M3EBadge(
  count: 8,
  alignment: M3EBadgeAlignment.topLeft,
  child: Icon(M3EIcons.calendar_today, size: 28),
);

const M3EBadge(
  label: 'New',
  child: Icon(M3EIcons.mail, size: 28),
);
```

#### M3EProgressIndicator

Material 3 Expressive progress indicators with circular and linear variants,
including Compose-style wavy forms. Track uses **secondary container**; active
(+ linear stop) uses **primary**. Circular track–active gap defaults to **4dp**.
Null `value` runs indeterminate animation (classic linear: dual traveling
segments with gaps; wavy linear/circular: m3e style travel / spin+sweep;
classic circular: same rot/sweep timing as wavy, flat arcs with gaps). Optional
`trackStrokeWidth` (and `.linear` `strokeWidth`) override track and value
thickness. Set `showTrack: false` for in-button use. Linear mirrors in RTL;
circular does not. A11y role is **progressbar** (`semanticsLabel` /
`semanticsValue`).

```dart
// Classic
const M3EProgressIndicator.circular();
M3EProgressIndicator.circular(value: 0.6);
M3EProgressIndicator.circular(
  value: 0.6,
  trackStrokeWidth: 2,
);

const M3EProgressIndicator.linear();
SizedBox(
  width: 200,
  child: M3EProgressIndicator.linear(value: 0.6),
);

// Hide track (e.g. inside a button)
M3EProgressIndicator.circular(showTrack: false);

// Expressive wavy (Compose CircularWavy / LinearWavy)
const M3EProgressIndicator.circularWavy();
M3EProgressIndicator.circularWavy(value: 0.6);

SizedBox(
  width: 200,
  child: M3EProgressIndicator.linearWavy(),
);
SizedBox(
  width: 200,
  child: M3EProgressIndicator.linearWavy(value: 0.6),
);
```

#### M3ELoadingIndicator

Expressive loading spinner (indeterminate). Spec defaults: outer **48dp**,
active **38dp**, container **`CircleBorder`**, a11y role **progressbar**.
Shape morph settle uses `M3EMotion.expressiveSpatialSlow`. Use `size` to scale
both edges while keeping the 38:48 ratio (guidance **24–240dp**). Also supports
`indicatorSize` / `containerWidth` / `containerHeight`, `containerShape`,
`indicatorColors` (exclusive with `color`), `color` / `containerColor`, and
`rotationTurns` (host-driven rotation; disables auto spin and morph pulse).

```dart
const M3ELoadingIndicator();

const M3ELoadingIndicator(
  variant: M3ELoadingIndicatorVariant.contained,
);

// Ratio-preserving scale (outer 96 → active 76)
const M3ELoadingIndicator(size: 96);

M3ELoadingIndicator(
  indicatorSize: 32,
  containerWidth: 56,
  containerHeight: 56,
  containerShape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
  ),
  indicatorColors: const <Color>[
    Color(0xff6750a4),
    Color(0xff006a6a),
  ],
);

// Host-driven rotation (e.g. during pull-to-refresh drag)
M3ELoadingIndicator(
  variant: M3ELoadingIndicatorVariant.contained,
  rotationTurns: dragTurns,
);
```

#### M3ERefreshIndicator

Pull-to-refresh wrapper for scrollables. Default and `.contained` kinds always
build a **contained** `M3ELoadingIndicator`; optional `elevation` is applied on
the refresh host shell (including Flutter web). Reveal starts after
`2 × indicatorPadding`; arm / refresh only when fully revealed. List pad is
capped by `contentDragOffset` (defaults to indicator height +
`2 × indicatorPadding`). Use `M3ERefreshIndicatorController` (or a
`GlobalKey<M3ERefreshIndicatorState>`) for programmatic `show()`.

```dart
final controller = M3ERefreshIndicatorController();

M3ERefreshIndicator(
  controller: controller,
  onRefresh: () async {
    await Future<void>.delayed(const Duration(seconds: 2));
  },
  child: ListView.builder(
    itemCount: 12,
    itemBuilder: (context, index) => Text('Item ${index + 1}'),
  ),
);

// Contained shell + optional elevation / pad overrides
M3ERefreshIndicator.contained(
  controller: controller,
  elevation: 3,
  indicatorPadding: 8,
  contentDragOffset: 72,
  onRefresh: () async {},
  child: listView,
);

// Manual trigger
await controller.show();
```

#### M3ETooltip

Plain (hover / focus / long-press) or rich tooltips. Plain defaults **above**
the target; rich defaults **bottom-end**, with on-screen flip in **8dp** steps.
Dismiss immediately after leaving by default for plain tooltips (themable);
transient rich dismisses after **1.5s** so actions stay reachable. Rich supports optional subhead,
up to two text-button actions, and **`persistent`** (tap / `M3ETooltipController`
only). Colors: plain inverse surface / on inverse surface; rich surface
container / on surface variant.

```dart
M3ETooltip(
  message: 'Compose a new message',
  child: M3EIconButton(
    icon: const Icon(M3EIcons.edit),
    onPressed: () {},
  ),
);

M3ETooltip(
  persistent: true,
  richTitle: 'Compose',
  richMessage: 'Start a new draft with expressive defaults.',
  actions: <Widget>[
    M3EButton.text(onPressed: () {}, child: Text('Got it')),
  ],
  child: M3EIconButton(
    icon: const Icon(M3EIcons.edit),
    onPressed: () {},
  ),
);
```

#### M3ESnackbar

Brief bottom feedback. Plain bars auto-dismiss after **4s**; bars with an
action or close stay until dismissed. Only one snackbar is shown at a time
(`M3ESnackbarController`). Optional close icon; action uses inverse primary
text with InkSparkle. Heights **48** / **68**; padding start **16**, end **8**
with trailing.

```dart
M3ESnackbar.show(
  context,
  message: 'Draft saved',
  actionLabel: 'Undo',
  onAction: () {},
  showCloseButton: true,
);
```

#### M3ETextField

Filled and outlined text input with floating label. The focused stroke is
painted over the field so width/height stay stable. Height grows with
`maxLines`. An empty label sits vertically centered; with no label, the
value is centered. `inputFormatters` are forwarded to the inner
`EditableText`. `M3ETextFieldVariant` and `M3ETextFieldTheme` are public.

```dart
M3ETextField(
  controller: nameController,
  label: 'Full name',
  supportingText: 'As it appears on your ID',
  leading: const Icon(M3EIcons.edit),
);

const M3ETextField(
  label: 'Email',
  variant: M3ETextFieldVariant.outlined,
  errorText: 'Enter a valid email address',
);
```

#### M3ESearchBar / M3ESearchAnchor

Inline search field, or a bar that opens a full search view with suggestions.
When embedded in toolbars or app bars, `expandOnFocus` / `expandRestPadding`
control the horizontal inset spring on focus. Use `alignment` /
`barAlignment` to place leading + hint + trailing while empty and unfocused
(defaults to start; `M3EAppBar.search` defaults to `Alignment.center`).

```dart
// Inline bar
M3ESearchBar(
  controller: searchController,
  hintText: 'Search components',
  trailing: [
    M3EIconButton(
      icon: const Icon(M3EIcons.close),
      onPressed: searchController.clear,
    ),
  ],
);

// Anchor + search view
final controller = M3ESearchController();
M3ESearchAnchor.bar(
  searchController: controller,
  barHintText: 'Search',
  suggestionsBuilder: (context, controller) sync* {
    for (final name in names.where((n) => n.contains(controller.text))) {
      yield ListTile(
        title: Text(name),
        onTap: () => controller.closeView(name),
      );
    }
  },
);
```

---

### Modal surfaces

Several components present transient UI over the app. They all require a
`BuildContext` with a `Navigator` / `Overlay` ancestor (any `MaterialApp` or
`WidgetsApp` provides this):

| Component | API |
| --------- | --- |
| `M3EDialog` | `M3EDialog.show`, `M3EDialog.showFullScreen` |
| `M3EBottomSheet` | `M3EBottomSheet.show` |
| `M3ESideSheet` | `M3ESideSheet.show` |
| `M3ESnackbar` | `M3ESnackbar.show` |

## Example app (detailed)

Live web build:
[paadevelopments.github.io/material_3_expressive](https://paadevelopments.github.io/material_3_expressive/).

The [`example/`](example/) project is a full gallery app:

- **Entry point:** [`example/lib/main.dart`](example/lib/main.dart) —
  `M3EMaterialApp` with `autoTheming`, `dynamicColoring`, and a five-tab
  catalog-driven gallery shell. The home app bar palette action opens
  [`theme_config_page.dart`](example/lib/pages/theme_config_page.dart) to
  toggle auto theming and dynamic color, pick one of five seed colors when
  dynamic color is off, and choose a font family (Google Sans Flex default,
  system, Roboto Flex, or Roboto Mono). Open **View → Typography** for type
  scale, variable-font axes, and conversion demos.
- **Pages:** playgrounds under
  [`example/lib/pages/playground/`](example/lib/pages/playground/), grouped
  by tab (`do/`, `pick/`, `view/`, `nav/`, `find/`).
- **Theme toggle:** app-bar `M3EIconButton` calls
  `M3ETheme.controllerOf(context)?.toggleBrightness(...)`.

```bash
cd example
flutter pub get
flutter run
```

Pick a device or simulator when prompted. Use the bottom navigation bar to
switch between component groups, the palette icon for theme settings, and the
brightness icon to toggle light/dark mode.

## Development

Static analysis and tests:

```bash
flutter analyze
flutter test
```

Optional custom lint rules (if `klin_dart` is enabled in your environment):

```bash
dart run custom_lint
```

## Support

If this package helps your project:

- **Star** it on [pub.dev](https://pub.dev/packages/material_3_expressive)
- **Star or fork** the repo on [GitHub](https://github.com/paadevelopments/material_3_expressive)
- Share it with others building Material 3 Expressive UIs

### Version 1.1.1 — API compatibility

Version **1.1.1** adds typography foundations (`M3ETypography`, variable-font
axes, style conversion) and exports `buildM3EThemeDefaults()` and
`M3EDynamicColorHost` through the public barrel. These changes are **additive**:
`M3EThemeData.typeScale` remains a baseline alias, and existing component code
continues to work without migration.

## Credits

Several components were ported or vendored from earlier Material 3 Expressive
implementations. Thanks to the original authors:

| Author | Components | Source |
| ------ | ---------- | ------ |
| [Mudit Purohit](https://github.com/Mudit200408) | Buttons, split buttons, button groups | [m3e_buttons](https://github.com/Mudit200408/m3e_buttons) |
| [Mudit Purohit](https://github.com/Mudit200408) | Dropdown menus | [m3e_dropdown_menu](https://github.com/Mudit200408/m3e_dropdown_menu) |
| [Mudit Purohit](https://github.com/Mudit200408) | Expandable lists | [m3e_expandable](https://github.com/Mudit200408/m3e_expandable) |
| [Emily](https://github.com/EmilyMoonstone) | Icon buttons | [icon_button_m3e](https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/icon_button_m3e) |
| [Emily](https://github.com/EmilyMoonstone) | Navigation bar | [navigation_bar_m3e](https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_bar_m3e) |
| [Emily](https://github.com/EmilyMoonstone) | Navigation rail | [navigation_rail_m3e](https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/navigation_rail_m3e) |
| [Emily](https://github.com/EmilyMoonstone) | Loading indicator (Flutter package) | [loading_indicator_m3e](https://github.com/EmilyMoonstone/material_3_expressive/tree/main/packages/loading_indicator_m3e) |
| [The Android Open Source Project](https://source.android.com/) | Loading indicator (Compose reference) | [`LoadingIndicator.kt`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/LoadingIndicator.kt) |
| [The Android Open Source Project](https://source.android.com/) | Slider / RangeSlider / VerticalSlider (Compose reference, `material3:1.4.0-alpha01`) | [`Slider.kt`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/Slider.kt) / [`SliderTokens.kt`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/tokens/SliderTokens.kt) |
| [The Android Open Source Project](https://source.android.com/) | Linear / circular wavy progress (Compose reference) | [`LinearWavyProgressIndicator`](https://developer.android.com/reference/kotlin/androidx/compose/material3/LinearWavyProgressIndicator.composable) / [`CircularWavyProgressIndicator`](https://developer.android.com/reference/kotlin/androidx/compose/material3/CircularWavyProgressIndicator.composable) |
| [The Android Open Source Project](https://source.android.com/) | Floating / docked toolbars (Compose reference, `material3:1.4.0-alpha01`) | [`FloatingToolbar.kt`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/FloatingToolbar.kt) / [`FlexibleBottomAppBar`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/AppBar.kt) / [`DockedToolbarTokens`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/tokens/DockedToolbarTokens.kt) |
| [The Flutter Authors](https://github.com/flutter/flutter) | Carousel view layout (`CarouselView`) | Flutter SDK / [m3_carousel](https://pub.dev/packages/m3_carousel) |
| [pub.dev](https://pub.dev/) | Spring motion (`motor`), expressive morph polygons (`material_new_shapes`), dynamic color (`dynamic_color`) | See [Dependencies](#dependencies) |

Copyright notices and licenses from those sources are retained in the
corresponding source files where applicable, and summarized in
[`NOTICE`](NOTICE).

## License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for details.

Copyright (c) 2026 Paa Developments <paa.code.me@gmail.com>
