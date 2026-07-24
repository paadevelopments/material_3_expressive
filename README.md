# Material 3 Expressive

A faithful, dependency-light Flutter implementation of the
[Material 3](https://m3.material.io/components) **Expressive** component set.

Every widget is exposed as a direct `M3E*` class with spring-driven press
feedback, shape morphing, and hover/focus/press state layers. Design tokens
(color, typography, motion, shapes, elevation) are provided through
`M3ETheme`.

## Example app

An interactive gallery demonstrating **all 44 widgets** lives in the
[`example/`](example/) directory. It groups components the same way as the
official Material 3 catalog:

| Tab | Page | Components |
| --- | ---- | ---------- |
| **Do** | [`actions_page.dart`](example/lib/pages/actions_page.dart) | Buttons, FABs, groups, toggles, segmented & split buttons |
| **Pick** | [`selection_page.dart`](example/lib/pages/selection_page.dart) | Checkbox, radio, switch, chips, dropdown, slider, pickers |
| **View** | [`containment_page.dart`](example/lib/pages/containment_page.dart) | Cards, carousel, lists, divider, dialogs, sheets |
| **Nav** | [`navigation_page.dart`](example/lib/pages/navigation_page.dart) | App bars, tabs, nav bar/rail/drawer, toolbar, menu |
| **Find** | [`feedback_page.dart`](example/lib/pages/feedback_page.dart) | Badges, progress, refresh, tooltip, snackbar, inputs |

The gallery shell in [`example/lib/main.dart`](example/lib/main.dart) uses
`M3EMaterialApp` with adaptive theming and a light/dark toggle.

```bash
cd example
flutter run
```

## Features

- **44 widgets** across 39 component modules, covering Actions, Selection,
  Containment, Navigation, and Feedback (communication + text input).
- **Direct component API** — construct each `M3E*` widget directly; enums and
  models are exported from a single library import.
- **Expressive motion & interaction** — spring physics, shape morphing, and
  proper state layers on every interactive surface.
- **Design token foundations** — color schemes, typography, motion, shapes,
  elevation, and state layers via the `M3ETheme` inherited widget.
- **Interactive example gallery** in [`example/`](example/) with live demos
  for every component.

## Requirements

| Tool    | Version    |
| ------- | ---------- |
| Flutter | `>= 3.3.0` |
| Dart    | `^3.12.0`  |

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  material_3_expressive: ^1.0.0
```

Then fetch it:

```bash
flutter pub get
```

Or add it from the command line:

```bash
flutter pub add material_3_expressive
```

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

`M3EMaterialApp` additionally supports `autoTheming` (platform brightness) and
`dynamicColoring` (OS seed color on supported platforms — Material You primary
on Android 12+, accent color on desktop — with schemes generated via
`ColorScheme.fromSeed`).

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

> See also: [`example/lib/pages/actions_page.dart`](example/lib/pages/actions_page.dart) (Do tab)

#### M3EButton

Five color variants with shape morphing on press.

```dart
M3EButton(
  style: M3EButtonStyle.elevated,
  onPressed: () {},
  child: const Text('Elevated'),
);

M3EButton.icon(
  icon: const Icon(M3EIcons.add),
  label: const Text('Add'),
  onPressed: () {},
);
```

#### M3EIconButton

Icon-only actions; supports toggle selection.

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

Floating action button in three sizes.

```dart
M3EFab(
  icon: const Icon(M3EIcons.add),
  size: M3EFabSize.large,
  color: M3EFabColor.tertiary,
  onPressed: () {},
);
```

#### M3EExtendedFab

FAB with a text label.

```dart
M3EExtendedFab(
  label: 'Compose',
  icon: const Icon(M3EIcons.edit),
  onPressed: () {},
);
```

#### M3EFabMenu

Speed-dial menu anchored to a FAB.

```dart
M3EFabMenu(
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

Toggle with round-to-square shape morphing.

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

Single- or multi-select segmented control.

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

Primary action with a trailing menu.

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
```

---

### Selection

> See also: [`example/lib/pages/selection_page.dart`](example/lib/pages/selection_page.dart) (Pick tab)

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

On/off toggle with optional selected icon.

```dart
// in State
M3ESwitch(
  value: wifiEnabled,
  selectedIcon: const Icon(M3EIcons.check),
  onChanged: (v) => setState(() => wifiEnabled = v),
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

Static list, multi-select, search, and async loading.

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

Compose Material 3 expressive slider — standard, centered, vertical, and range.

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

M3ESlider.centered(
  value: balance,
  min: -100,
  max: 100,
  onChanged: (v) => setState(() => balance = v),
);

M3ERangeSlider(
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

> See also: [`example/lib/pages/containment_page.dart`](example/lib/pages/containment_page.dart) (View tab)

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
via `axis`.

```dart
M3ECarousel(
  type: M3ECarouselType.hero,
  heroAlignment: M3ECarouselHeroAlignment.center,
  onTap: (index) {},
  children: List.generate(10, (i) => ColoredBox(color: Colors.blue)),
);

M3ECarousel(
  type: M3ECarouselType.contained,
  isExtended: true,
  children: items,
);

M3ECarousel(
  type: M3ECarouselType.uncontained,
  uncontainedItemExtent: 80,
  children: items,
);

// Vertical (hero left/right map to top/bottom)
M3ECarousel(
  axis: Axis.vertical,
  type: M3ECarouselType.hero,
  children: items,
);
```

#### M3EListItem

Standard list row with headline, supporting text, and slots.

```dart
M3EListItem(
  headline: 'Wireless charging',
  supportingText: 'On · Fast charge enabled',
  leading: const Icon(M3EIcons.schedule),
  trailing: const Icon(M3EIcons.chevron_right),
  onTap: () {},
);
```

#### M3ECardList

Vertically stacked cards with dynamic corner rounding.

```dart
M3ECardList(
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

> See also: [`example/lib/pages/navigation_page.dart`](example/lib/pages/navigation_page.dart) (Nav tab)

#### M3EAppBar

Top, sliver, and bottom app bar variants.

```dart
M3EAppBar.top(
  titleText: 'Inbox',
  leading: const Icon(M3EIcons.menu),
  actions: const [Icon(M3EIcons.search)],
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

Bottom navigation for compact layouts.

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
  onFabPressed: () {},
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
surface with a gap between them; dividers stay inside a surface.

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

> See also: [`example/lib/pages/feedback_page.dart`](example/lib/pages/feedback_page.dart) (Find tab)

#### M3EBadge

Notification dot or numeric badge on a child.

```dart
const M3EBadge(
  showDot: true,
  child: Icon(M3EIcons.menu, size: 28),
);

const M3EBadge(
  count: 8,
  child: Icon(M3EIcons.calendar_today, size: 28),
);
```

#### M3EProgressIndicator

Material 3 Expressive progress indicators with circular and linear variants,
including Compose-style wavy forms.

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
  child: M3EProgressIndicator.linearWavy(value: 0.6),
);
```

#### M3ELoadingIndicator

Expressive loading spinner.

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

Filled and outlined text input with floating label.

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

The [`example/`](example/) project is a full gallery app:

- **Entry point:** [`example/lib/main.dart`](example/lib/main.dart) —
  `M3EMaterialApp` with `autoTheming`, `dynamicColoring`, and a five-tab
  gallery shell.
- **Pages:** one file per Material 3 category under
  [`example/lib/pages/`](example/lib/pages/).
- **Theme toggle:** app-bar `M3EIconButton` calls
  `M3ETheme.controllerOf(context)?.toggleBrightness(...)`.

```bash
cd example
flutter pub get
flutter run
```

Pick a device or simulator when prompted. Use the bottom navigation bar to
switch between component groups and the app-bar icon to toggle light/dark mode.

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
| [The Android Open Source Project](https://source.android.com/) | Floating / docked toolbars (Compose reference, `material3:1.4.0-alpha01`) | [`FloatingToolbar.kt`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/FloatingToolbar.kt) / [`FlexibleBottomAppBar`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/AppBar.kt) / [`DockedToolbarTokens`](https://cs.android.com/androidx/platform/frameworks/support/+/androidx-main:compose/material3/material3/src/commonMain/kotlin/androidx/compose/material3/tokens/DockedToolbarTokens.kt) |
| [The Flutter Authors](https://github.com/flutter/flutter) | Carousel view layout (`CarouselView`) | Flutter SDK / [m3_carousel](https://pub.dev/packages/m3_carousel) |

Copyright notices and licenses from those sources are retained in the
corresponding source files where applicable.

## License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for details.

Copyright (c) 2026 Paa Developments <paa.code.me@gmail.com>
