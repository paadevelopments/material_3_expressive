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

An interactive gallery demonstrating **all 45 widgets** also lives in the
[`example/`](example/) directory (same build as the live demo). It groups
components the same way as the official Material 3 catalog, with a live
playground per component under [`example/lib/pages/playground/`](example/lib/pages/playground/):

| Tab | Playgrounds | Components |
| --- | ----------- | ---------- |
| **Do** | [`playground/do/`](example/lib/pages/playground/do/) | Buttons, FABs, FAB menu, groups, segmented & split buttons |
| **Pick** | [`playground/pick/`](example/lib/pages/playground/pick/) | Checkbox, radio, switch, chips, dropdown, slider (incl. wavy), pickers |
| **View** | [`playground/view/`](example/lib/pages/playground/view/) | Cards, carousel, lists, selection, divider, dialogs, sheets |
| **Nav** | [`playground/nav/`](example/lib/pages/playground/nav/) | App bars (incl. search), tabs, nav bar/rail/drawer, toolbar, menu |
| **Find** | [`playground/find/`](example/lib/pages/playground/find/) | Badges, progress, refresh, tooltip, snackbar, inputs |

The gallery shell in [`example/lib/main.dart`](example/lib/main.dart) uses
`M3EMaterialApp` with adaptive theming, a light/dark toggle, and a palette
action that opens [`theme_config_page.dart`](example/lib/pages/theme_config_page.dart)
(auto theming, dynamic color, five seed colors, font family, and M3 Expressive
type styles on Roboto Flex).

```bash
cd example
flutter run
```

## Features

- **45 widgets** across 40 component modules, covering Actions, Selection,
  Containment, Navigation, and Feedback (communication + text input).
- **Direct component API** — construct each `M3E*` widget directly; enums and
  models are exported from a single library import. Action surfaces accept
  optional gradient decorations (fill, foreground, overlay, outline).
- **Expressive motion & interaction** — spring physics (via [`motor`](https://pub.dev/packages/motor)),
  shape morphing, liquid selection indicators, shared haptics (`M3EHaptics`), and
  proper state layers on every interactive surface.
- **Design token foundations** — color schemes, typography, motion, shapes
  (including [`material_new_shapes`](https://pub.dev/packages/material_new_shapes)
  morph polygons), elevation, haptics, and state layers via the `M3ETheme` inherited widget.
- **Interactive example gallery** — run locally from [`example/`](example/), or
  open the [live web demo](https://paadevelopments.github.io/material_3_expressive/).

## Requirements

| Tool    | Version    |
| ------- | ---------- |
| Flutter | `>= 3.38.0` |
| Dart    | `^3.12.0`  |

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  material_3_expressive: ^1.0.6
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
| [`flutter`](https://api.flutter.dev/) | SDK — widgets, painting, gestures, and Material primitives used throughout |
| [`collection`](https://pub.dev/packages/collection) | Small collection helpers used by component logic |
| [`dynamic_color`](https://pub.dev/packages/dynamic_color) | Platform dynamic / Material You seed colors for `M3EMaterialApp` (`dynamicColoring`) |
| [`motor`](https://pub.dev/packages/motor) | Unified motion API — physics springs and curves that drive expressive morphs and liquid selection indicators |
| [`material_new_shapes`](https://pub.dev/packages/material_new_shapes) | Expressive `RoundedPolygon` morph shapes (`M3EMaterialNewShapes`) used by loading / shape-driven surfaces |

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
- `typeScale` — `M3ETypeScale` (display, headline, title, label, body)
- `spacing`, `visualDensity`, per-component `*Theme` extensions

Shared typography (font family, fallback, package, size factor/delta, color,
decoration, and variable-font axes) is a one-knob on the type scale — not a
full `TextStyle`:

```dart
final themed = M3EThemeData.light(seedColor: seed).copyWith(
  typeScale: M3ETypeScale.baseline().apply(
    fontFamily: 'Roboto Flex',
    fontVariations: M3ETypeVariations.emphasized.variations,
  ),
);

// Sugar: same result without building a type scale by hand
final alsoThemed = M3EThemeData.light(seedColor: seed).copyWith(
  fontFamily: 'Roboto Flex',
  fontVariations: M3ETypeVariations.emphasized.variations,
);
```

`M3EMaterialApp` additionally supports `autoTheming` (platform brightness) and
`dynamicColoring` (OS seed color on supported platforms — Material You primary
on Android 12+, accent color on desktop — with schemes generated via
`ColorScheme.fromSeed`). Pass `fontFamily` / `fontFamilyFallback` /
`fontVariations` to apply the same type-scale knobs at the shell:

```dart
M3EMaterialApp(
  data: M3EThemeData.light(seedColor: seed),
  fontFamily: 'Roboto Flex',
  fontVariations: M3ETypeVariations.wide.variations,
  home: const HomePage(),
);
```

`M3ETypeVariations` is an enum of Roboto Flex axes (`.variations`): regular,
emphasized, condensed, extra condensed, wide, extra wide, and round. Static
and mono fonts ignore axes they do not define. The shell projects the type
scale onto `ThemeData.textTheme` and `DefaultTextStyle`.

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

Floating action button in three sizes. Optional `decoration: M3EFabDecoration`
for fill, foreground, overlay, and outline gradients.

```dart
M3EFab(
  icon: const Icon(M3EIcons.add),
  size: M3EFabSize.large,
  color: M3EFabColor.tertiary,
  onPressed: () {},
);
```

#### M3EExtendedFab

FAB with a text label. Accepts the same `M3EFabDecoration` as `M3EFab`.

```dart
M3EExtendedFab(
  label: 'Compose',
  icon: const Icon(M3EIcons.edit),
  onPressed: () {},
);
```

#### M3EFabMenu

Speed-dial menu anchored to a FAB. The FAB morphs size (80↔56) and circle when
opening; use `position` for left/right anchor, and optional `expandIcon` /
`collapseIcon` (fallbacks: `icon` / `closeIcon`). Pass `decoration` for the
trigger FAB. Menu-item fill, foreground, and outline gradients live on
`M3EFabMenuTheme` (`itemBackgroundGradient`, `itemForegroundGradient`,
`itemOutlineGradient` / `itemOutlineColor`, `itemBorderWidth`).

```dart
M3EFabMenu(
  position: M3EFabMenuPosition.right,
  expandIcon: const Icon(M3EIcons.add),
  collapseIcon: const Icon(M3EIcons.close),
  decoration: M3EFabDecoration(
    backgroundGradient: WidgetStateProperty.all(
      const LinearGradient(colors: [Color(0xFF6750A4), Color(0xFF9A82DB)]),
    ),
  ),
  items: [
    M3EFabMenuItem(
      icon: const Icon(M3EIcons.edit),
      label: 'Note',
      onPressed: () {},
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

Grouped icon buttons with neighbour squish or connected corner morphing.

```dart
// in State
M3EButtonGroup(
  selectedIndex: groupIndex,
  onSelectedIndexChanged: (i) => setState(() => groupIndex = i ?? groupIndex),
  actions: const [
    M3EButtonGroupAction(icon: Icon(M3EIcons.arrow_back)),
    M3EButtonGroupAction(icon: Icon(M3EIcons.add)),
    M3EButtonGroupAction(icon: Icon(M3EIcons.arrow_forward)),
  ],
);

M3EButtonGroup(
  type: M3EButtonGroupType.connected,
  actions: const [
    M3EButtonGroupAction(icon: Icon(M3EIcons.chevron_left)),
    M3EButtonGroupAction(icon: Icon(M3EIcons.menu)),
    M3EButtonGroupAction(icon: Icon(M3EIcons.chevron_right)),
  ],
);
```

#### M3EToggleButton

Toggle with round-to-square shape morphing. Optional
`decoration: M3EToggleButtonDecoration(...)` for the same gradient fields as
`M3EButtonDecoration`. `M3EButtonGroup` / `M3EToggleButtonGroup` accept a
group-level `decoration` and per-action `M3EButtonGroupAction.decoration`.

```dart
// in State
M3EToggleButton.filled(
  icon: const Icon(M3EIcons.favorite_border),
  checkedIcon: const Icon(M3EIcons.favorite),
  checked: isFavorite,
  onCheckedChange: (v) => setState(() => isFavorite = v),
);

M3EToggleButton.text(
  label: const Text('Bold'),
  checked: isBold,
  onCheckedChange: (v) => setState(() => isBold = v),
);
```

#### M3ESegmentedButton

Single- or multi-select segmented control. Theme
`M3ESegmentedButtonTheme` can set `outlineColor` / `outlineGradient`,
`dividerColor` / `dividerGradient` (sampled across the whole group), and
selected/unselected background and foreground colors or gradients.

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
  segments: const [
    M3ESegment(value: 'new', label: 'New'),
    M3ESegment(value: 'sale', label: 'Sale'),
  ],
  selected: filters,
  onSelectionChanged: (v) => setState(() => filters = v),
);
```

#### M3ESplitButton

Primary action with a trailing menu. Use `items` for a flat list, or
`m3eMenuBuilder` for a rich M3E menu tree (groups, dividers, submenus). Legacy
`menuBuilder` still opens Flutter `showMenu`. Gradients on
`M3ESplitButtonDecoration` span both segments; optional
`trailingBackgroundGradient` / `trailingForegroundGradient` /
`trailingOutlineGradient` / `trailingOverlayGradient` override the trailing
half. `decoration.animationDuration` defaults to `Duration.zero` so the
trailing radius morph stays on the spring.

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

Binary and tristate checkbox.

```dart
// in State
M3ECheckbox(
  value: checked,
  onChanged: (v) => setState(() => checked = v),
);

M3ECheckbox(
  value: tristateValue,
  tristate: true,
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

// Multi select with search
M3EDropdownMenu<String>(
  searchEnabled: true,
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
highlight. Use `borderRadiusBuilder` for selected-item corner morph (spring),
gestures (`onTap` / `onLongPress`), and [M3ESelectionLeading] on each item.
Wrap with [PopScope] so system back clears selection first. Prefer
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
      borderRadiusBuilder: (i, pos) => selection.isSelected(i)
          ? BorderRadius.circular(24)
          : null,
      onLongPress: (i) => selection.select(i),
      onTap: (i) {
        if (selection.isSelectionMode) {
          selection.toggle(i);
        }
      },
      itemBuilder: (context, i) => M3EListItem(
        headline: items[i],
        leading: M3ESelectionLeading(
          selected: selection.isSelected(i),
          onTap: () => selection.toggle(i),
          selectedChild: CircleAvatar(child: Icon(M3EIcons.check)),
          child: CircleAvatar(child: Text('$i')),
        ),
      ),
    ),
  ),
);
```

Advanced: wire `M3ESelectionAppBar` + a shared controller yourself (omit
`M3ESelection`), or pass `M3EDismissibleList` as `body` for swipe + select.
An explicit `colorBuilder` still wins over the selection highlight.

#### M3EDismissibleColumn

Vertically swipeable card list with expressive physics.

```dart
M3EDismissibleColumn(
  itemCount: 3,
  onDismiss: (index, direction) async => true,
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

Expandable cards with expressive open/close motion.

```dart
M3EExpandableList(
  data: [
    M3EExpandableData(
      title: 'Battery level low',
      subtitle: 'Plug in your device.',
      leading: const Icon(M3EIcons.battery_alert),
      body: const Text('Your battery is at 10%.'),
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

Bottom navigation for compact layouts. Destinations use a click mouse cursor on
desktop/web (same for rail and drawer).

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
```

#### M3ENavigationRail

Vertical navigation for medium and expanded layouts.

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
  fab: M3ENavigationRailFabSlot(
    icon: const Icon(M3EIcons.add),
    label: 'Compose',
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

Notification dot or numeric badge on a child. `alignment` places the
indicator at `topLeft`, `topCenter`, or `topRight` of the child's own box
(default `topRight`). The badge sizes itself to cover the child plus
indicator — no parent `SizedBox` is required. `offset` nudges away from the
anchored edge (`dx` is ignored when centered).

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
```

#### M3EProgressIndicator

Material 3 Expressive progress indicators with circular and linear variants,
including Compose-style wavy forms. Null `value` runs indeterminate animation
(classic linear: dual traveling segments with gaps; wavy linear/circular: m3e
style travel / spin+sweep; classic circular: same rot/sweep timing as wavy,
flat arcs with gaps).

```dart
// Classic
const M3EProgressIndicator.circular();
M3EProgressIndicator.circular(value: 0.6);

const M3EProgressIndicator.linear();
SizedBox(
  width: 200,
  child: M3EProgressIndicator.linear(value: 0.6),
);

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

Expressive loading spinner. Shape morph settle uses
`M3EMotion.expressiveSpatialDefault`.

```dart
const M3ELoadingIndicator();

const M3ELoadingIndicator(
  variant: M3ELoadingIndicatorVariant.contained,
);
```

#### M3ERefreshIndicator

Pull-to-refresh wrapper for scrollables.

```dart
M3ERefreshIndicator(
  onRefresh: () async {
    await Future<void>.delayed(const Duration(seconds: 2));
  },
  child: ListView.builder(
    itemCount: 12,
    itemBuilder: (context, index) => Text('Item ${index + 1}'),
  ),
);

// Contained variant
M3ERefreshIndicator.contained(
  onRefresh: () async {},
  child: listView,
);
```

#### M3ETooltip

Descriptive label on hover or long-press.

```dart
M3ETooltip(
  message: 'Compose a new message',
  child: M3EIconButton(
    icon: const Icon(M3EIcons.edit),
    onPressed: () {},
  ),
);
```

#### M3ESnackbar

Brief feedback message — use `.show` (hosts via internal `M3ESnackbarHost`).

```dart
M3ESnackbar.show(
  context,
  message: 'Draft saved',
  actionLabel: 'Undo',
  onAction: () {},
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
  dynamic color is off, and choose a font family (platform default, Roboto
  Flex, Roboto Mono) plus M3 Expressive type styles on Flex.
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

## Credits

Several components were ported or vendored from earlier Material 3 Expressive
implementations. Thanks to the original authors:

| Author | Components | Source |
| ------ | ---------- | ------ |
| [Mudit Purohit](https://github.com/Mudit200408) | Buttons, split buttons, toggle button groups | [m3e_buttons](https://github.com/Mudit200408/m3e_buttons) |
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
