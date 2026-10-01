## 1.1.5

### Changed

* **Search:** search bars are **56** tall and fully rounded, on **surface container
  high**, with no shadow. They sit **24** from their pane and spring out to
  **12** when focused. Width is **360–720**. With actions, the edge to the 48
  tap target is **4**, the target to the label is **4**, and trailing targets
  have no gap between them. Without actions the label is **16** from each edge.
  The leading icon is **on surface**; trailing icons and hinted text are **on
  surface variant**; input text is **on surface** (body large). Hover is
  **0.08** and press is **0.1** on **on surface**, with the sparkle ripple. The
  keyboard focus ring is **secondary**, **3** thick, **2** off the bar, and hides
  on pointer input. `avatar` adds a **30** circle in a **48** target, and
  `showClearButton` puts a clear action first while the field has text. Enter
  runs the search and keeps the query visible.
* **Search:** the view comes in `M3ESearchViewStyle.contained` (default) and
  `.divided`. Contained full-screen sits on **surface container low** with the
  pill bar **12** from each side and **8** above and below it, and results
  inset **12**. Contained docked puts its results in a
  **28**-radius container **2** below the bar, with a **0.32** scrim behind.
  Divided uses a **72** (full-screen) or **56** (docked) header and an
  **outline** divider, with results inset **16**. When `isFullScreen` is not set, the view is full-screen
  below **600** and docked at **600** and wider, and it switches between the two
  when the window is resized. The bar morphs into the view with a spatial
  spring. On Android, predictive back scales the view down to **0.9**, toward
  the gesture. Arrow keys move from the field into the results and between
  them. Screen readers hear "N results available" when the results change.
  `M3ESliverSearchBar` scrolls away with content and returns when the user
  scrolls toward the top, or stays `fixed`. App bar search keeps the divided
  view.
* **Text fields:** containers are **56** tall with a **4** corner (top corners
  only on filled). Padding is **16** without icons and **12** to a **24** icon,
  with **16** between icon and text. On filled fields the label sits **8** from
  the top over the input, with **8** below. Supporting text and the counter sit
  **4** below, inset **16**, with a **16** gap. Filled fields are **surface
  container highest** with a **1** (focused **2**) bottom indicator. Hover adds
  an **0.08** **on surface** layer. Outlined fields use a **1** (focused **3**)
  **outline** with a **4**-padded notch for the floating label. Labels, icons and
  supporting text are **on surface variant**, and input is **on surface**. Focus
  is **primary** and error is **error**, darkening to **on error container** on
  hover. Disabled fields fade to **0.38** (filled container **0.04**, outline
  **0.12**) and are skipped by Tab. The label springs between the middle and the
  top. Added `prefixText`, `suffixText`, `placeholder`, `isRequired` (asterisk),
  `maxLength` with a counter, `readOnly`, `minLines` (multi-line and text area),
  `supportingTextOnFocusOnly`, `density` (**0** to **-3**, **4** each), and
  `showClearButton` / `showPasswordToggle`. An error icon is shown by default.
  Tap, double-tap, long-press and drag select text. The keyboard focus ring is
  **secondary** (or **error**), **3** thick, **2** off the field, and hides on
  pointer input. Screen readers hear the label (with its asterisk) and the
  supporting text. The error message has the alert role, and the counter reads
  "Character count, N of M characters entered". Outlined fields with a label
  reserve **8** above the container for the floating label.
* **Text fields:** `iconAlignment` and `affixAlignment`
  (`M3ETextFieldSlotAlignment.firstLine` / `.center` / `.bottom`, also on
  `M3ETextFieldTheme`) place the icons and the prefix/suffix text in multi-line
  fields and text areas. Icons default to `center` and prefix/suffix text to
  `firstLine`. `maxLines` is now `int?` (default still **1**); `null` lets the
  field grow without a line limit.
* **Text fields (web):** fixed fields that ignored typing after password
  visibility, read-only or keyboard type changed while focused and the field
  was then refocused. The caret showed but no text was entered.
* **Breaking — text fields:** `M3ETextFieldTheme` was rebuilt around the spec
  tokens. Removed `minHeight` (use `containerHeight`), `contentHeight`,
  `contentVerticalPadding` and `labelRestingOffset` (layout is derived from
  `verticalPadding` and the text styles), `horizontalPadding` as `EdgeInsets`
  (now a `double`), `iconGap` (use `iconTextGap` / `iconEdgePadding`),
  `labelFloatingTopPadding`, `labelRestingTopPadding`, `labelBottomPadding`,
  `supportingTextPadding` (use `supportingTopPadding` /
  `supportingHorizontalPadding`), `labelSlotHeight()`, `accentColor()`,
  `backgroundDecoration()`, `borderDecoration()` and `decoration()`. Colors are
  now set per state with `colors: M3ETextFieldColorTheme(...)`, or resolved with
  `resolveColors()`.

### Fixed

* **Lists:** `M3EList.sliver` no longer throws in a `CustomScrollView`. Its
  semantics, `margin`, and `emptyBuilder` now build as slivers.

## 1.1.4

### Changed

* **Sliders:** spec sizes XS–XL, colors, stops, value indicator, inset icons,
  vertical stops, and keyboard steps.
* **Toolbars:** spec docked and floating sizes, padding, colors and paired FAB;
  arrow-key navigation; docked action layouts at 600 and wider.
* **Navigation drawer:** spec standard and modal sheets, destinations, colors
  and focus ring; modal open/dismiss with spring and drag;
  `M3ENavigationDrawerController`.
* **Navigation rail:** spec collapsed and expanded sizes, colors, scroll
  elevation, modal rail and `destinationTopPadding`;
  `M3ENavigationRailController`.
* **Lists:** expressive segmented and standard styles with spec heights,
  slots and state layers; `M3EList` is the only list widget (`M3ECardList`,
  `M3EDismissibleList`, `M3EDismissibleColumn` and `M3EExpandableList` are
  removed); nested sub-lists, swipe, expand and drag-to-reorder.
* **App bars:** spec small, medium and large heights, scrolled-under color and
  elevation, `M3EAppBarHideMode` (`entire` / `actions`), search field, and
  `M3EAppBarController`; smoother scroll-driven collapse and hide.
* **Carousel:** multi-browse, uncontained, multi-aspect, hero and full-screen
  layouts with `M3ECarouselItem`, `M3ECarouselController`, keyboard
  navigation and a show-all morph.
* **Navigation bar:** spec flexible and baseline sizes, horizontal items,
  colors, pill and focus ring; `M3ENavigationBarController` with hide on
  scroll.
* **Tabs:** spec primary and secondary bars, indicators and colors;
  `M3ETabsController`, `M3ETabsView` and `M3ETabs.sliver`.
* **Cards:** vertical layout, keyboard order, swipe actions, card groups,
  reorder and container transform.
* **Focus and interaction:** pointer input hides keyboard focus rings until
  the next Tab or arrow key; no hover flashes while scrolling; plain tooltips
  ignore the pointer.

## 1.1.3

### Changed

* **Menus:** vertical and baseline menus with spec sizes and full keyboard
  support.
* **Toolbars:** floating `alignment` and `screenOffset`.
* **Overlays:** `M3EOverlayHistory` closes open popups on back before the
  route pops.
* **Navigation:** selection pills scale in place with springs.
* **Dividers, chips, switches, radio buttons, checkboxes, snackbars,
  tooltips, progress indicators:** aligned to spec sizes, colors, focus rings
  and semantics; `M3EChipGroup`, `M3ERadioGroup`, `M3ESnackbarController`,
  `M3ETooltipController` and `M3ETooltipPlacement` added.
* **Loading indicator:** per-instance sizes, shape and colors.
* **Split buttons, segmented buttons, buttons, icon buttons, button
  groups:** aligned to M3E size, color and shape tokens.
* **FAB, extended FAB, FAB menu:** controllers, container transforms, focus
  rings and disabled colors added.
* Raise Flutter SDK to `>=3.47.0` and `material_ui` to `^1.4.0` (Dart SDK
  `^3.13.0`).
* **Breaking — badges:** `defaultOffset` is replaced by `smallOffset` /
  `largeOffset`; default `maxCount` is **999**; `label` is preferred over
  `count`.
* **Breaking — loading indicator:** `elevation` is removed (widget, theme and
  shadow).
* **Breaking — FAB menus:** require **2–6** items; `itemHorizontalPadding`
  and the old gaps are replaced by the new theme paddings.
* **Breaking — extended FABs:** new `M3EExtendedFabSize` (default `small`);
  a label is required (no icon-only).
* **Breaking — FABs:** `M3EFabSize.medium` is now **80dp**; use
  `M3EFabSize.regular` for the old 56dp size.
* **Breaking — buttons:** toggle selection moves into `M3EButton`
  (`isSelected`, `selectedIcon`, `selectedLabel`); `M3EToggleButton`,
  `M3EToggleButtonDecoration` and `M3EToggleButtonTheme` are removed.
* **Breaking — button groups:** module renamed `toggle_button_group` →
  `button_group`; `toggleButtonGroupTheme` → `buttonGroupTheme`; decoration
  uses `M3EButtonDecoration`; `M3EButtonGroupItemKind` and
  `M3EButtonGroupAction.iconButton` are removed (use `minWidth`).
* **Breaking — button group density:** `M3EButtonGroupDensity` is now
  `regular` / `comfortable` / `compact` / `dense` and changes container
  height.
* **Breaking — icon buttons:** default `variant` is now `filled`.
