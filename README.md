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
  shape morphing, per-destination selection indicators, shared haptics (`M3EHaptics`), and
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

This package uses [`material_ui`](https://pub.dev/packages/material_ui) `^1.5.0`
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

## What's new in 1.1.5

Summary of updates since 1.1.4 (details in [`CHANGELOG.md`](CHANGELOG.md)):

- **Search** — **56** pill bar on **surface container high**, **24** from its
  pane and **12** once focused (spring), **360–720** wide. Optional avatar
  (**30** in a **48** target) and a clear action. The focus ring is
  **secondary**, **3** thick. The view is contained (default) or divided,
  full-screen below **600**, otherwise docked with a scrim. It springs out of
  the bar, supports predictive back, moves through results with the arrow
  keys, and announces when results change. `M3ESliverSearchBar` scrolls away
  and comes back when you scroll toward the top.
- **Text fields** — filled and outlined fields are **56** tall, with a **4**
  corner. The label springs between the middle and the top, and the outlined
  label sits in a notch. Focus is **primary**: a **2** line on filled, a **3**
  outline on outlined. Errors are **error** and show an error icon. Adds
  prefix and suffix text, a placeholder, a character counter, required and
  read-only fields, clear and password buttons, and opt-in density. Text
  fields can be multi-line (`maxLines: null` grows without a limit) or a text
  area, and icons and prefix/suffix text can align to the first line, center
  or bottom. The focus ring is **secondary**, **3** thick. Tab skips disabled
  fields.


## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  material_3_expressive: ^1.1.5
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
| [`motor`](https://pub.dev/packages/motor) | Unified motion API — physics springs and curves that drive expressive morphs and selection indicators |
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

Text button aligned with the Material 3 Expressive spec: five sizes, press
shape morph, and `InkSparkle`. Selection uses `isSelected`, `selectedIcon`,
and `selectedLabel`.

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

Keyboard: Tab, then Space or Enter.

#### M3EIconButton

Icon-only button aligned with the Material 3 Expressive spec. Default variant
is `filled`. Toggle with `isSelected` and `selectedIcon`.

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

Keyboard: Tab, then Space or Enter.

#### M3EFab

Floating action button aligned with the Material 3 Expressive spec. Sizes:
`small` 40, `regular` 56, `medium` 80 (default), `large` 96. `M3EFabController`
handles scroll, appear, and container transform.

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

Keyboard: Tab, then Space or Enter.

#### M3EExtendedFab

Extended FAB aligned with the Material 3 Expressive spec. Label is required.
Sizes are `small` 56 (default), `medium` 80, and `large` 96.
`M3EExtendedFabController` handles scroll, appear, and container transform.

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

Keyboard: Tab, then Space or Enter.

#### M3EFabMenu

Speed-dial menu of 2–6 items, aligned with the Material 3 Expressive spec.
The trigger becomes a 56dp close button. Back closes the menu before the route.

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

Keyboard: Tab walks items. Escape closes.

#### M3EButtonGroup

Connected or standard groups aligned with the Material 3 Expressive spec.
Actions are `M3EButton`. Density changes height, not the gap.

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

Keyboard: Tab, then Space or Enter. Arrows are not captured.

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

Keyboard: Tab, then Space or Enter.

#### M3ESegmentedButton

Outlined single- or multi-select control, aligned with the Material 3
Expressive spec. Two to five segments. Density lowers the height; the target
stays at least 48.

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

Keyboard: Tab, then Space or Enter.

#### M3ESplitButton

Primary action plus a menu, aligned with the Material 3 Expressive spec.
The gap between the two segments is 2. Back closes the popup before the route.

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

Keyboard: Tab, then Space or Enter. Escape closes the menu.

---

### Selection

> See also: [`example/lib/pages/playground/pick/`](example/lib/pages/playground/pick/) (Pick tab)

#### M3ECheckbox

Checkbox aligned with the Material 3 Expressive spec: 18dp box, 2dp corners,
40dp state layer, 48dp target. Optional label. `checkIconPadding` defaults to
none.

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

Keyboard: Tab, then Space or Enter.

#### M3ERadio

Radio aligned with the Material 3 Expressive spec: 20dp icon, 40dp state
layer, 48dp target. Put options in `M3ERadioGroup` for arrow-key selection.

```dart
// in State
M3ERadioGroup<String>(
  groupValue: plan,
  groupLabel: 'Plan',
  onChanged: (v) => setState(() => plan = v),
  child: M3ERadio<String>(
    value: 'pro',
    groupValue: plan,
    label: const Text('Pro'),
    onChanged: (v) => setState(() => plan = v),
  ),
);
```

Keyboard: Tab or Shift+Tab enters the selected radio. Arrows move, select, and wrap.

#### M3ESwitch

Switch aligned with the Material 3 Expressive spec. Track is 52×32. The handle
is 16 off, 24 on or with an icon, and 28 pressed. Drag past the midpoint toggles.

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

Keyboard: Tab, then Space or Enter.

#### M3EChip

Chips aligned with the Material 3 Expressive spec: height 32, radius 8.
`M3EChipGroup` moves focus with the arrow keys.

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

M3EChipGroup(
  child: Wrap(
    spacing: 8,
    children: [
      M3EChip(
        label: 'Dart',
        type: M3EChipType.input,
        avatar: const Icon(M3EIcons.person),
        onPressed: () {},
        onDeleted: () {},
      ),
    ],
  ),
);
```

Keyboard: arrows move focus. Backspace or Delete removes a focused input chip.

#### M3EDropdownMenu

Dropdown for one value, many values, search, or async items. Back closes the
panel before the route.

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

Keyboard: Enter or Space opens. Escape closes. Arrows move inside the panel.

#### M3ESlider

Slider for a value or a range, including centered, wavy, and vertical,
aligned with the Material 3 Expressive spec: sizes `xs`–`xl` scale the track
(**16–96**) and handle (**44–108**) together. Active track and handle are
**primary**; inactive track is **secondary container**. Stops use
`divisions`.

```dart
// in State
M3ESlider(
  value: volume,
  onChanged: (v) => setState(() => volume = v),
);

// Spec size — track and handle scale together (defaults to xs)
M3ESlider(
  value: level,
  size: M3ESliderSize.l,
  semanticLabel: 'Volume',
  onChanged: (v) => setState(() => level = v),
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

Keyboard: arrows step. Page Up and Page Down jump. Home and End go to the ends.

#### M3EDatePicker

Dialog and inline calendar for one date or a range. Month paging uses the
arrow keys.

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

Keyboard: arrows change month. Enter moves focus.

#### M3ETimePicker

Dialog and dial for a time of day.

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

Keyboard: Enter moves focus.

---

### Containment

> See also: [`example/lib/pages/playground/view/`](example/lib/pages/playground/view/) (View tab)

#### M3ECard

Elevated, filled, and outlined surface for content and actions, aligned with
the Material 3 Expressive spec: content padding **16** on every side, focus
ring **secondary** at **3dp**. Optional media, headline, supporting text,
actions, overflow menu, dividers, one swipe action, and a full-screen
`openBuilder` container transform.

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

// Structured slots — vertical stacks media above the text
M3ECard(
  vertical: true,
  media: Image.network(imageUrl, fit: BoxFit.cover),
  headline: const Text('Weekend trip'),
  supportingText: const Text('12 photos · 3 people'),
  dividerAfterMedia: true,
  actions: M3EButton.text(onPressed: () {}, child: const Text('Share')),
  overflow: M3EIconButton(
    icon: const Icon(M3EIcons.more_vert),
    onPressed: () {},
  ),
);

// Swipe to reveal a trailing action, or flick to dismiss
M3ECard(
  swipeMode: M3ECardSwipeMode.both,
  trailingSwipeAction: const Icon(M3EIcons.delete),
  onSwipe: () {},
  child: const Text('Swipe me'),
);

// Full-screen container transform
M3ECard(
  openBuilder: (context) => const Scaffold(body: Center(child: Text('Detail'))),
  child: const Text('Tap to open'),
);

// A group of cards sharing a gap, elevation, and layout
M3ECardGroup(
  layout: M3ECardGroupLayout.staggered,
  onReorder: (oldIndex, newIndex) {},
  children: const [
    M3ECard(child: Text('One')),
    M3ECard(child: Text('Two')),
  ],
);
```

#### M3ECarousel

Multi-browse, uncontained, uncontained multi-aspect, hero, and full-screen
layouts — horizontal by default, or vertical via `axis`. Items are
`M3ECarouselItem` values; a `null` `onTap` on an item disables it. Use
`onChange` for leading/focal index updates (e.g. hide labels on smaller
items).

```dart
M3ECarousel(
  type: M3ECarouselType.hero,
  heroAlignment: M3ECarouselHeroAlignment.center,
  onTap: (index) {},
  onChange: (details) {
    // details.focalIndex / details.leadingIndex / details.isFocal(i)
  },
  children: List.generate(
    10,
    (i) => M3ECarouselItem(
      image: Image.network(imageUrls[i], fit: BoxFit.cover),
      title: Text('Item $i'),
      subtitle: const Text('Subtitle'),
      onTap: () {},
    ),
  ),
);

// Step, jump, or open the full list with a controller
final carouselController = M3ECarouselController();
M3ECarousel(
  controller: carouselController,
  type: M3ECarouselType.uncontained,
  showAll: true,
  children: const [...],
);
// carouselController.next() / .previous() / .animateToItem(i) / .jumpToItem(i)
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

#### M3EList

One list. List-level fields set the variant, selection, and reorder. Each
`M3EListItem` can opt into `swipe`, `expanded`, and `transform`. A sub-list
expansion is its own nested `M3EList`, which inherits the parent corner join,
fill, and variant. Use `.scrollable` for a lazy list and `.sliver` inside a
`CustomScrollView` (slivers keep selection and do not reorder). Resting
corners (`M3EListStyle.segmented`, the default, vs `.standard`) are set on
`M3EListTheme`, like other component styling.

```dart
M3EList(
  variant: M3ECardVariant.outlined,
  itemCount: 3,
  onTap: (index) {},
  itemBuilder: (context, index) => M3EListItem(
    headline: 'Inbox',
    leading: const Icon(M3EIcons.schedule),
    swipe: M3EListItemSwipe(
      onDismiss: (direction) async => true,
      trailing: const [
        M3EListSwipeAction(
          icon: Icon(M3EIcons.delete),
          isPrimary: true,
        ),
      ],
    ),
    expanded: M3EExpandableExpanded.list(
      M3EList(
        embedded: true,
        itemCount: 2,
        itemBuilder: (context, i) => M3EListItem(headline: 'Child $i'),
      ),
    ),
  ),
);

// Scrollable / lazy
M3EList.scrollable(
  itemCount: 20,
  shrinkWrap: true,
  itemBuilder: (context, index) => M3EListItem(
    headline: 'Item $index',
  ),
);
```

#### M3ESelection

Multi-select host with an optional app bar and any list as the body. Back
clears the selection before leaving the page.

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
    body: M3EList.scrollable(
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
`M3ESelection`), or set `M3EListItem.swipe` for swipe + select.
An explicit `colorBuilder` still wins over the selection highlight.

#### M3EDivider

Divider aligned with the Material 3 Expressive spec: a 1dp outline-variant
line. Full width unless `inset` or `outerMargin` is set.

```dart
const M3EDivider();

const M3EDivider(inset: M3EDividerInset.inset);

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

Basic and full-screen dialogs. A basic dialog is **280–560** wide on
**surface container high**, with **28** corners and **24** padding, over a
**0.32** scrim. The headline and actions stay pinned while content scrolls, and
actions stack when they don't fit. `position` places it at the center
(default), left, right, top or bottom, inside the system bars and above the
keyboard. A full-screen dialog fills the view, and its header changes color on
scroll like an app bar. Customize everything on `M3EDialogTheme`.

```dart
M3EDialog.show<void>(
  context,
  dialog: M3EDialog(
    title: 'Reset settings?',
    content: const Text('This restores default values.'),
    actions: [
      M3EButton.text(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
      M3EButton.text(onPressed: () => Navigator.pop(context), child: const Text('Reset')),
    ],
  ),
);

// Pick from a list; confirm stays disabled until something is chosen.
final picked = await M3EDialog.showSelectionScreen(
  context,
  title: 'Choose a plan',
  options: const ['Standard', 'Pro', 'Team'],
);

// Full screen; closing with unsaved changes asks to discard them.
final controller = M3EDialogController(hasUnsavedChanges: true);
M3EDialog.showFullScreen<void>(
  context,
  title: 'New event',
  confirmLabel: 'Save',
  onConfirm: controller.close,
  controller: controller,
  body: const Text('Form fields'),
);

// Full screen below 600dp, basic dialog above; switches on resize.
M3EDialog.showAdaptive<void>(
  context,
  title: 'Create album',
  content: const Text('Album details'),
  confirmLabel: 'Save',
  onConfirm: () => Navigator.pop(context),
);
```

Keyboard: focus starts on the first control, and Tab and Shift+Tab stay inside
the dialog. Space or Enter activates. Escape closes. In a selection list, arrows
move between options and Tab moves on to the actions.

#### M3EBottomSheet

Standard and modal bottom sheets. A sheet is full width up to **640**, on
**surface container low**, with **28** top corners and an optional **32×4**
drag handle in a **48** top strip. Below **640** wide the top margin is
**72**. Above that, the top and side margins are **56**. A modal sheet opens
over a **0.32** scrim, at no more than half the screen. It can be pulled up to
its content height; long content then scrolls inside. A standard sheet sits
next to the main UI without a scrim. Customize everything on
`M3EBottomSheetTheme`.

```dart
// Modal: closes on scrim tap, swipe down, Escape or back.
M3EBottomSheet.show<void>(
  context,
  builder: (context) => ListView(
    children: [for (final item in items) Text(item)],
  ),
);

// Standard: place it over your content, e.g. in a Stack.
final controller = M3EBottomSheetController();
Stack(
  children: [
    const MapView(),
    Positioned.fill(
      child: M3EBottomSheet.standard(
        controller: controller,
        previewHeight: 64,
        expandToFullScreen: true, // full width, plus a full-screen height with a collapse button
        fullScreenTitle: 'Places',
        child: const PlacesList(),
      ),
    ),
  ],
);
controller.expand(); // or collapse(), cycle(), show(), hide()

// Bottom sheet below 840dp, side sheet at 840dp and wider.
M3EBottomSheet.showAdaptive<void>(
  context,
  title: 'Share',
  builder: (context) => const ShareTargets(),
);
```

Keyboard and accessibility: Tab focuses the drag handle, and Space or Enter
cycles the heights. Escape closes a modal sheet. Only the handle is labelled
("Drag handle"); it reads as a button with the current height and has Expand,
Collapse and Dismiss actions. Use `M3EBottomSheetController` as the
single-pointer alternative to dragging when there is no handle.

#### M3ESideSheet

Standard and modal side sheets anchored to the end edge (left in RTL). A sheet
is **256** wide (up to **400**) and spans the window height. A modal sheet is on
**surface container low** with **16** corners facing the content, over a
**0.32** scrim. A standard sheet is on **surface** and sits next to the
content, which shrinks to make room. `M3ESideSheetLayout` turns it modal below
**600**. Customize everything on `M3ESideSheetTheme`.

```dart
// Modal: closes on the close icon, scrim tap, Escape or back.
M3ESideSheet.show<void>(
  context,
  title: 'Filters',
  body: const FilterList(),
);

// Standard next to your content; modal on compact windows.
final controller = M3ESideSheetController();
M3ESideSheetLayout(
  controller: controller,
  body: const Inbox(),
  sheet: const M3ESideSheet.standard(title: 'Details', body: Details()),
);
controller.toggle(); // or open(), close()
```

Keyboard: Tab moves through the back and close icons, content and actions, and
Space or Enter activates them. Escape closes a modal sheet.

---

### Navigation

> See also: [`example/lib/pages/playground/nav/`](example/lib/pages/playground/nav/) (Nav tab)

#### M3EAppBar

Top, search, sliver, and bottom app bar variants, aligned with the
Material 3 Expressive spec: small content band is **64**, flexible medium
**112** and large **120** (taller with a subtitle). Docked top/bottom bars
apply single-edge `safeArea` padding from `MediaQuery.viewPadding` by
default (opt out with `safeArea: false`).

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

// Sliver with a controller and an actions-only hide mode — the action row
// stays on its own fill while the title/image slide away on scroll.
final appBarController = M3EAppBarController();
M3EAppBar.sliver(
  controller: appBarController,
  hideMode: M3EAppBarHideMode.actions,
  titleText: 'Inbox',
  actions: const [Icon(M3EIcons.search)],
);
// appBarController.expand() / .collapse() / .show() / .hide() / .followScroll()
```

**Collapse and hide on scroll with `M3EAppBar.top` / `.search`.** A
`Scaffold` starts its body where the app bar ends, so a bar that shrinks
drags the body up while the list inside it is also scrolling: the content
then moves faster than the bar and slides under its edge. No bar can fix
that from inside the `appBar` slot. Set `extendBodyBehindAppBar: true` and
the page runs behind the bar instead: the bar keeps a fixed slot, only its
surface moves, and it travels exactly with the content. `ListView`,
`GridView`, and `CustomScrollView` pick up the bar height as top padding
from the Scaffold on their own; add it yourself for anything else
(`MediaQuery.paddingOf(context).top`).

```dart
Scaffold(
  extendBodyBehindAppBar: true, // bar moves 1:1 with the content
  appBar: M3EAppBar.top(
    titleText: 'Inbox',
    variant: M3EAppBarVariant.mediumFlexible,
    hideMode: M3EAppBarHideMode.entire,
  ),
  body: ListView(children: messages),
);
```

Without the flag, collapse still works but the content moves ahead of the
bar, and hiding falls back to a timed slide. `M3EAppBar.sliver` needs no
flag: it is part of the scroll content, so it always moves with it.

#### M3ETabs

Primary and secondary tab bars, aligned with the Material 3 Expressive
spec: primary label-only and secondary bars are **48**; primary icon plus
label is **64**.

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

// Swipeable body kept in sync with the bar, plus a selection controller
final tabsController = M3ETabsController();
M3ETabs(
  controller: tabsController,
  selectedIndex: tabIndex,
  onTabSelected: (i) => setState(() => tabIndex = i),
  tabs: const [M3ETab(label: 'Overview'), M3ETab(label: 'Specs')],
);
M3ETabsView(
  selectedIndex: tabIndex,
  onTabSelected: (i) => setState(() => tabIndex = i),
  children: const [Text('Overview'), Text('Specs')],
);

// Sliver — scrolls away and returns on an upward scroll
M3ETabs.sliver(
  selectedIndex: tabIndex,
  onTabSelected: (i) => setState(() => tabIndex = i),
  tabs: const [M3ETab(label: 'Overview'), M3ETab(label: 'Specs')],
);
```

#### M3ENavigationBar

Bottom navigation aligned with the Material 3 Expressive spec. The selected
pill scales in place. Wide layout is a row of icon and label chips.

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

// Hide on a downward scroll, with a controller for manual show/hide/select
final navBarController = M3ENavigationBarController();
M3ENavigationBar(
  controller: navBarController,
  hideOnScroll: true,
  scrollController: listScrollController,
  destinations: const [...],
  selectedIndex: barIndex,
  onDestinationSelected: (i) => setState(() => barIndex = i),
);
// navBarController.show() / .hide() / .select(i)
```

#### M3ENavigationRail

Vertical navigation aligned with the Material 3 Expressive spec: collapsed
width **96** (narrow **80**), expanded **220–360**. The selected pill scales
in place. Collapsed pills match the navigation bar. A modal rail dismisses
on the scrim, Escape, or system back. Horizontal body scroll raises the
rail's container automatically (`scrollUnder`, default on).

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

// Leading control, a divider on the content edge, and a controller
final railController = M3ENavigationRailController();
M3ENavigationRail(
  controller: railController,
  leading: M3EIconButton(
    icon: const Icon(M3EIcons.menu),
    onPressed: railController.toggle,
  ),
  showDivider: true,
  alignment: M3ENavigationRailAlignment.center,
  sections: const [...],
  selectedIndex: railIndex,
  onDestinationSelected: (i) => setState(() => railIndex = i),
);

// railController.expand() / .collapse() / .select(i) / .show() / .hide()
```

#### M3ENavigationDrawer

Standard (default) or modal drawer aligned with the Material 3 Expressive
spec: width **360**, end corners **16**. The selected pill scales in place.
A modal drawer opens from a button and dismisses on a destination, the
scrim, a drag toward the start edge, or system back. A dismissible standard
drawer closes only from its `controller`.

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
  sections: const [
    M3ENavigationDrawerSection(
      header: 'Labels',
      destinations: [
        M3ENavigationDestination(icon: Icon(M3EIcons.favorite), label: 'Starred'),
      ],
    ),
  ],
  selectedIndex: drawerIndex,
  onDestinationSelected: (i) => setState(() => drawerIndex = i),
);

// Modal drawer, opened from a button, with a controller
final drawerController = M3ENavigationDrawerController();
M3EIconButton(
  icon: const Icon(M3EIcons.menu),
  onPressed: drawerController.open,
);
M3ENavigationDrawer(
  type: M3ENavigationDrawerType.modal,
  controller: drawerController,
  onDismissed: () {},
  destinations: const [...],
  selectedIndex: drawerIndex,
  onDestinationSelected: (i) => setState(() => drawerIndex = i),
);
```

#### M3EToolbar

Floating or docked toolbar, both **64** tall, aligned with the Material 3
Expressive spec. Floating placement uses `alignment`. `screenOffset`
(default 16) keeps the pill off the screen edge. Docked ignores both and
uses `contentAlignment` to place actions at 600dp and wider.

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
  // At 600dp and wider: even (default), centered, or edges.
  contentAlignment: M3EToolbarContentAlignment.even,
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

Menu aligned with the Material 3 Expressive spec. Variants are vertical and
baseline. Opening focuses the first enabled item. Multi-select stays open.
Back closes a submenu, then the menu, before the route.

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

Keyboard: Up and Down move. Left and Right open or close a submenu. Letters
jump. Escape closes. Enter or Space activates.

---

### Feedback

> See also: [`example/lib/pages/playground/find/`](example/lib/pages/playground/find/) (Find tab)

#### M3EBadge

Badge aligned with the Material 3 Expressive spec. A 6dp dot or a large label
(min 16dp) in error colors. It overlays the child without shifting it.

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

Circular and linear progress aligned with the Material 3 Expressive spec,
including wavy forms. The track is secondary container. Set `showTrack: false`
to hide it.

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

Indeterminate loading shape aligned with the Material 3 Expressive spec.
Default outer size is 48 and the active shape is 38. There is no elevation.

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

Plain or rich tooltip aligned with the Material 3 Expressive spec. Plain sits
above the target. Rich can stay open with `persistent`.

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

Brief message aligned with the Material 3 Expressive spec. A bar with an
action or close button stays until dismissed. Escape dismisses it when focused.

```dart
M3ESnackbar.show(
  context,
  message: 'Draft saved',
  actionLabel: 'Undo',
  onAction: () {},
  showCloseButton: true,
);
```

Keyboard: Escape dismisses when focused.

#### M3ETextField

Filled or outlined field (**56** tall) with a label that springs between the
middle and the top. It supports leading and trailing icons, prefix and suffix
text, a placeholder, supporting or error text (with an error icon), a
character counter, and required (`isRequired`) and read-only fields. Input can
be single-line, multi-line (grows up to `maxLines`) or a fixed-height text area
(`minLines == maxLines`); `maxLines: null` grows without a limit. In taller
fields, `iconAlignment` and `affixAlignment` keep icons and prefix/suffix text
on the first line, centered, or at the bottom. `density` (**0** to **-3**) is
opt-in. Every value is
customizable through `M3ETextFieldTheme` and `M3ETextFieldColorTheme`.

```dart
M3ETextField(
  controller: nameController,
  label: 'Full name',
  supportingText: 'As it appears on your ID',
  leading: const Icon(M3EIcons.search),
  showClearButton: true,
);

const M3ETextField(
  label: 'Price',
  variant: M3ETextFieldVariant.outlined,
  prefixText: '€',
  prefixSemanticsLabel: 'Euro',
  isRequired: true,
  maxLength: 20,
);

const M3ETextField(
  label: 'Password',
  obscureText: true,
  showPasswordToggle: true,
  errorText: 'At least 6 characters required',
);
```

Keyboard: Tab focuses enabled fields and Escape unfocuses. The focus ring hides
on pointer input.

#### M3ESearchBar / M3ESearchAnchor / M3ESliverSearchBar

Contained search bar (**56** pill, **24** → **12** margins on focus) and a
search view that is full-screen below **600** and docked with a scrim above.
Use `viewStyle: M3ESearchViewStyle.divided` for the baseline style. The hint
is the accessibility label, result changes are announced, and predictive back
is supported on Android. Every value is customizable through
`M3ESearchBarTheme` and `M3ESearchViewTheme`.

```dart
// Inline bar: leading icon, one trailing action + avatar, clear while typing.
M3ESearchBar(
  controller: searchController,
  hintText: 'Search messages',
  leading: const Icon(M3EIcons.search),
  trailing: [
    M3EIconButton(
      icon: const Icon(M3EIcons.mic),
      tooltip: 'Voice search',
      onPressed: () {},
    ),
  ],
  avatar: Image.asset('assets/me.png'),
  showClearButton: true,
);

// Anchor + search view. Results are lists; separate groups with gaps.
final controller = M3ESearchController();
M3ESearchAnchor.bar(
  searchController: controller,
  barHintText: 'Search messages',
  // null: full-screen below 600dp, docked above (swaps on resize).
  isFullScreen: null,
  viewStyle: M3ESearchViewStyle.contained,
  suggestionsBuilder: (context, controller) => [
    M3EList(
      itemCount: names.length,
      itemBuilder: (context, i) => M3EListItem(
        headline: names[i],
        onTap: () => controller.closeView(names[i]),
      ),
    ),
  ],
);

// Scroll away with content and come back on scroll toward the top.
CustomScrollView(
  slivers: [
    const M3ESliverSearchBar(
      scrollBehavior: M3ESearchBarScrollBehavior.scrollAway, // or .fixed
      child: M3ESearchBar(hintText: 'Search your library'),
    ),
    // content slivers…
  ],
);
```

Keyboard: Tab, then Space or Enter opens the view. Arrows move through
results. Escape closes.

---

### Modal surfaces

Several components present transient UI over the app. They all require a
`BuildContext` with a `Navigator` / `Overlay` ancestor (any `MaterialApp` or
`WidgetsApp` provides this):

| Component | API |
| --------- | --- |
| `M3EDialog` | `M3EDialog.show`, `.showSelectionScreen`, `.showFullScreen`, `.showAdaptive` |
| `M3EBottomSheet` | `M3EBottomSheet.show`, `.showAdaptive`, `.standard` |
| `M3ESideSheet` | `M3ESideSheet.show`, `M3ESideSheetLayout` |
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

Custom lint rules live in `tools/klin_dart` (path dependency, omitted from the published archive):

```bash
export PATH="$PWD/.fvm/flutter_sdk/bin:$PATH"
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
