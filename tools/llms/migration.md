## Migrating from Flutter Material widgets

Every M3E component is a plain widget from a single import
(`package:material_3_expressive/material_3_expressive.dart`). Swap the Flutter
widget for its M3E counterpart below. Callbacks keep the usual Flutter shapes
(`VoidCallback`, `ValueChanged<T>`) unless the notes say otherwise.

### App shell and theme

| Flutter | M3E | Notes |
| ------- | --- | ----- |
| `MaterialApp` | `M3EMaterialApp` | Pass `data: M3EThemeData.light(seedColor: ...)`. Adds `autoTheming`, `dynamicColoring` and `drawUnderSystemBars`. |
| `ThemeData` / `ColorScheme.fromSeed` | `M3EThemeData.light` / `M3EThemeData.dark` | Per-component themes are fields on `M3EThemeData`, changed with `copyWith`. |
| `Theme(data: ..., child: ...)` | `M3ETheme(data: ..., child: ...)` | Read tokens with `M3ETheme.of(context)`. |
| `Theme.of(context).textTheme` | `M3ETheme.of(context).typography` | `.baseline` and `.emphasized` scales; `typeScale` is the baseline alias. |
| `Icons.*` | `M3EIcons.*` | Bundled glyph set. |

### Actions

| Flutter | M3E | Notes |
| ------- | --- | ----- |
| `ElevatedButton` | `M3EButton.elevated` | Or `M3EButton(style: M3EButtonStyle.elevated, ...)`. |
| `FilledButton` | `M3EButton.filled` | `M3EButton` defaults to filled. |
| `FilledButton.tonal` | `M3EButton.tonal` | |
| `OutlinedButton` | `M3EButton.outlined` | |
| `TextButton` | `M3EButton.text` | |
| `FilledButton.icon` and similar | `M3EButton.icon` | Takes `icon` and `label` widgets plus `style`. |
| `IconButton` | `M3EIconButton` | Defaults to the filled variant; pass `variant: M3EIconButtonVariant.standard` for a plain icon button. Toggle with `isSelected` and `selectedIcon`. |
| `IconButton.filled` / `.filledTonal` / `.outlined` | `M3EIconButton(variant: ...)` | `M3EIconButtonVariant.filled`, `.tonal`, `.outlined`. |
| `FloatingActionButton` (and `.small` / `.large`) | `M3EFab` | `size: M3EFabSize.small / regular / medium / large`; default is `medium`. |
| `FloatingActionButton.extended` | `M3EExtendedFab` | `label` is a required `String`. |
| `SegmentedButton<T>` | `M3ESegmentedButton<T>` | `segments` are `M3ESegment(value:, label:)` with a `String` label. `selected` is a `Set<T>`; set `multiSelect: true` for several. |
| `ToggleButtons` | `M3EButtonGroup` | `actions` are `M3EButtonGroupAction`; selection by `selectedIndex` and `onSelectedIndexChanged`. |
| `PopupMenuButton` next to a button | `M3ESplitButton<T>` | Items are `M3ESplitButtonItem(value:, child:)`. |

### Selection

| Flutter | M3E | Notes |
| ------- | --- | ----- |
| `Checkbox` / `CheckboxListTile` | `M3ECheckbox` | Optional `label` replaces the list tile. `onChanged` is `ValueChanged<bool?>`. |
| `Radio<T>` / `RadioListTile<T>` | `M3ERadio<T>` | Wrap options in `M3ERadioGroup<T>` for arrow-key selection. |
| `Switch` / `SwitchListTile` | `M3ESwitch` | `selectedIcon` shows an icon in the handle. |
| `ActionChip` | `M3EChip` | `type: M3EChipType.assist` (default). `label` is a `String`. |
| `FilterChip` | `M3EChip(type: M3EChipType.filter)` | Pass `selected`; toggle in `onPressed`. |
| `InputChip` | `M3EChip(type: M3EChipType.input)` | |
| `ChoiceChip` | `M3EChip(type: M3EChipType.filter)` | Keep single selection in your own state. |
| Suggestion `ActionChip` | `M3EChip(type: M3EChipType.suggestion)` | |
| `DropdownButton` / `DropdownMenu` | `M3EDropdownMenu<T>` | Items are `M3EDropdownItem(label:, value:)`; `singleSelect: true` for one value. `.future` loads items async. |
| `Slider` | `M3ESlider` | `size: M3ESliderSize.xs ... xl`. Also `.centered`, `.wavy`, `.vertical`. |
| `RangeSlider` | `M3ERangeSlider` | |
| `CalendarDatePicker` | `M3ECalendarDatePicker` | |
| `showDatePicker` | `M3EDatePicker.show` | Returns `Future<DateTime?>`. |
| `showDateRangePicker` | `M3EDatePicker.showRange` | Returns `Future<M3EDateRange?>`. |
| `showTimePicker` | `M3ETimePicker.show` | Returns `Future<M3ETime?>`, not `TimeOfDay`. Inline dial: `M3EDialTimePicker`. |

### Containment

| Flutter | M3E | Notes |
| ------- | --- | ----- |
| `Card` / `Card.filled` / `Card.outlined` | `M3ECard` | `variant: M3ECardVariant.elevated` (default), `.filled`, `.outlined`. Slots: `media`, `headline`, `supportingText`, `actions`. |
| `CarouselView` | `M3ECarousel` | `type: M3ECarouselType.*`; children are `M3ECarouselItem`. |
| `ListTile` | `M3EListItem` | `headline` and `supportingText` are `String`s; `leading` / `trailing` widgets. |
| `ListView` of tiles | `M3EList` | `itemCount` + `itemBuilder`; `.scrollable` for a lazy list, `.sliver` for a `CustomScrollView`. |
| `Divider` / `VerticalDivider` | `M3EDivider` | `axis: M3EDividerAxis.vertical` for vertical. |
| `showDialog` + `AlertDialog` | `M3EDialog.show(context, dialog: M3EDialog(...))` | `title` is a `String`. Full-screen: `M3EDialog.showFullScreen`; adaptive: `M3EDialog.showAdaptive`. |
| `showModalBottomSheet` | `M3EBottomSheet.show(context, builder: ...)` | |
| `BottomSheet` (persistent) | `M3EBottomSheet.standard` | Driven by `M3EBottomSheetController`. |
| `Scaffold.endDrawer` used as a side panel | `M3ESideSheet.show` / `M3ESideSheetLayout` | |

### Navigation

| Flutter | M3E | Notes |
| ------- | --- | ----- |
| `AppBar` | `M3EAppBar.top` | `titleText` for a `String` title; `variant: M3EAppBarVariant.small` (default), `.medium`, `.large`, `.mediumFlexible`, `.largeFlexible`. |
| `SliverAppBar` (and `.medium` / `.large`) | `M3EAppBar.sliver` | |
| `BottomAppBar` | `M3EAppBar.bottom` or `M3EToolbar.docked` | |
| `TabBar` | `M3ETabs` | `tabs` are `M3ETab(label:)`; selection by `selectedIndex` and `onTabSelected` (no `TabController` needed). `variant: M3ETabsVariant.secondary` for secondary tabs. |
| `TabBarView` | `M3ETabsView` | |
| `NavigationBar` / `BottomNavigationBar` | `M3ENavigationBar` | Destinations are `M3ENavigationBarDestination(icon:, label:)`. |
| `NavigationRail` | `M3ENavigationRail` | Destinations sit in `sections: [M3ENavigationRailSection(destinations: [...])]`. |
| `NavigationDrawer` / `Drawer` | `M3ENavigationDrawer` | Destinations are `M3ENavigationDestination`. |
| `MenuAnchor` / `PopupMenuButton` | `M3EMenu` | `anchorBuilder: (context, open) => ...`; entries in `M3EMenuGroup.entries`. |

### Feedback and input

| Flutter | M3E | Notes |
| ------- | --- | ----- |
| `Badge` / `Badge.count` | `M3EBadge` | `count` or a `String` `label` for a large badge; `showDot: true` for a small dot. |
| `CircularProgressIndicator` | `M3EProgressIndicator.circular` | Also `.circularWavy`. Omit `value` for indeterminate. |
| `LinearProgressIndicator` | `M3EProgressIndicator.linear` | Also `.linearWavy`. |
| (no Flutter equivalent) | `M3ELoadingIndicator` | Morphing-shape indeterminate loader. |
| `RefreshIndicator` | `M3ERefreshIndicator` | Same `onRefresh` + `child` shape. |
| `Tooltip` | `M3ETooltip` | `message` for a plain tooltip; `richTitle` and actions for a rich one. |
| `ScaffoldMessenger.of(context).showSnackBar` | `M3ESnackbar.show(context, message: ...)` | `actionLabel` + `onAction` for an action. |
| `TextField` / `TextFormField` | `M3ETextField` | `label` is a `String`; `variant: M3ETextFieldVariant.filled` (default) or `.outlined`. Built-in `showClearButton` and `showPasswordToggle`. |
| `SearchBar` | `M3ESearchBar` | |
| `SearchAnchor` / `SearchAnchor.bar` | `M3ESearchAnchor` / `M3ESearchAnchor.bar` | Controller is `M3ESearchController`. |
| `SliverAppBar` with a search field | `M3ESliverSearchBar` | |
