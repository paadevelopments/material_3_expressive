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
* **Dialogs:** basic dialogs follow the spec: **surface container high**,
  **28** corners, **level 3**, **280–560** wide, **24** padding, **16** icon to
  headline and headline to body, **24** body to actions and **8** between
  actions. The icon is **24** **secondary** and centres the headline. The
  headline is **on surface** (headline small), supporting text **on surface
  variant** (body medium), and dividers **outline**, **1** thick. Content now
  scrolls with the headline and actions pinned. Actions stack (confirm on top)
  when they don't fit, and `leadingAction` adds an optional third action.
  Every text button in the action row, whether built in (selection, discard)
  or passed by the caller, uses the dialog action tokens: label large in
  **primary** with **0.08** hover, **0.1** keyboard-focus (plus the ring) and
  **0.1** press layers, and the sparkle ripple. Added `subhead`,
  `titleMaxLines` (a truncated headline expands on tap), `scrollController`
  and `semanticLabel`. Dialogs are announced as alert dialogs and labelled by
  their headline. Every value lives on `M3EDialogTheme` and its new
  `appearance` (`M3EDialogAppearance`) and `fullScreen`
  (`M3EFullScreenDialogTheme`).
* **Dialogs:** dialogs open and close on springs: basic dialogs fade and scale
  up, and full-screen dialogs slide up. Focus lands on the first interactive
  element, Tab and Shift+Tab wrap inside the dialog, and Escape always
  closes it. `onDismissRequest` can block Escape, back, barrier and close.
  `M3EDialogController` closes the dialog, reports `isOpen` and `variant`, and
  with `hasUnsavedChanges` shows "Discard unsaved changes?" before closing
  (`M3EDialog.showDiscardConfirmation`). `position` (`M3EDialogPosition`
  center, left, right, top or bottom) places basic dialogs inside the system
  bars and above the soft keyboard. On screens **600** and wider, an
  off-centre dialog keeps a **56** margin. Keyboard users land on the first
  element, while pointer users get no highlighted control. The **0.1** focus
  layer only shows during keyboard navigation. In selection dialogs the list is
  one Tab stop: arrow keys (and Home / End) move between rows, Space or Enter
  selects, and the next Tab moves on to the actions.
* **Dialogs:** full-screen dialogs (now `M3EFullScreenDialog`, also usable as
  an `M3EFab.openBuilder` container-transform destination) have a **56**
  header (was **64**) on **surface** that extends under the status bar like an
  app bar: a **24** **on surface** close icon **16** from the edge, a title
  large headline **24** after it, and a trailing action (`confirmLabel` /
  `onConfirm`). The header turns **surface container** while content scrolls
  under it, staying at **level 0** like an app bar
  (`headerScrolledElevation` can raise it). Content is padded **24** top, left
  and right by default (`contentPadding`), and the dialog fills the view
  width. Added `bottomActions` (a **56** action bar that extends under the
  navigation bar, with its actions kept above it) and `contentHeadline` for
  long headlines. The header divider is off by default (`showDivider`); when
  shown it is **surface container highest**. System bar insets are read from
  the view, so the header and action bar stay clear of the bars in
  edge-to-edge apps (`M3EMaterialApp.drawUnderSystemBars`).
* **Dialogs:** `M3EDialog.showAdaptive` / `M3EAdaptiveDialog` is full-screen
  below **600** and a basic dialog at **600** and wider. It morphs between
  the two on a spatial spring when the window is resized.
* **Bottom sheets:** sheets follow the spec. The container is **surface
  container low** at **level 1**, with **28** top corners and square bottom
  corners. Sheets are full width up to **640**. Below that width the top
  margin is **72**; above it the top margin is **56** and each side margin is
  **56**, so the sheet is `min(640, width − 112)` wide and centred. The width
  springs when the window crosses **640**. The drag handle is **32×4**,
  **on surface variant** at **0.4**, with **22** above and below, so it sits
  in a **48** top strip. That strip shows the grab cursor, and grabbing while
  you drag. The handle is a **48** button (labelled "Drag handle", read with
  the current height) with the sparkle ripple, **0.08** hover and **0.1**
  press layers, and a **secondary** focus ring **3** thick and **2** off the
  handle. The ring hides on pointer input. The scrim is **scrim** at
  **0.32**. The optional surface tint (`colors.surfaceTintColor`) is off by
  default. The container paints under the system bars, while its content is
  inset from the bottom (and side) bars. The insets are read from the view,
  so this also works in edge-to-edge apps.
  In light theme, a modal sheet sets the system bar icons from whatever is under
  each bar: light icons over the scrim, dark icons where the sheet reaches under
  the status bar or the navigation bar. Dark theme keeps light status-bar
  icons. Standard sheets don't touch the system bars.
* **Bottom sheets:** added preset heights (`M3EBottomSheetValue`).
  `collapsed` is the initial height, capped at **50%** of the screen;
  `expanded` fits the content, up to the screen minus the top margin. Long
  content can be pulled up and then scrolls inside: vertical lists that use
  the primary scroll controller grow the sheet before they scroll, and
  horizontal lists scroll on their own. Dragging snaps on spatial springs. A
  fling faster than **700** dp/s moves one height, and a release below half
  the lowest height dismisses. Tapping the handle, or pressing Space or Enter
  on it, cycles the heights (`handleCyclesToClose` adds closing). The handle
  also offers Expand, Collapse and Dismiss accessibility actions. Tab lands
  on the handle, and keyboard users start there on a modal sheet. Escape,
  the scrim, back and a downward swipe close modal sheets; `onDismissRequest`
  can veto them. On Android, predictive back narrows the sheet by up to **48**
  and shortens it by up to **24**, from the bottom centre.
* **Bottom sheets:** added `M3EBottomSheet.standard`, which sits next to the
  main UI with no scrim. It has an optional `previewHeight`, can be hidden,
  and `isDismissible` allows dragging it away. `expandToFullScreen` adds a
  full-screen height: the corners spring to **0**, the handle gives way to a
  **64** header with a collapse (standard) or close (modal) button, and an
  optional `fullScreenTitle` is shown. With `expandToFullScreen` the sheet spans
  the full view width. `M3EBottomSheetController` expands,
  collapses, cycles, shows, hides and closes the sheet without dragging.
  `M3EBottomSheet.showAdaptive` shows an `M3ESideSheet` at **840** and wider.
  Every value is on `M3EBottomSheetTheme`, plus `colors`
  (`M3EBottomSheetColors`) and `dragHandle`
  (`M3EBottomSheetDragHandleStyle`). The labels are on
  `M3EBottomSheetLabels`.
* **Bottom sheets (defaults):** `handleVerticalPadding` is now **22** (was
  **16**). `dismissVelocity` is now **700** (was **200**) and means the fling
  speed that moves one preset height. Before, any downward fling faster than
  it popped the sheet.
* **Side sheets:** sheets follow the spec. They are **256** wide by default
  (`width`, capped at **400**) and span the window height, anchored to the end
  edge (left in RTL, with the header mirrored; `edge` picks the start edge).
  Modal sheets are **surface container low** at **level 1** with **16**
  corners facing the content; `M3ESideSheet.standard` is **surface** at
  **level 0** with no rounding and an optional vertical edge divider.
  `detached` insets the sheet **16** from the edges and rounds every corner
  **16**. The header has **24** start/end padding (**16** before the optional
  back icon) and **12** between the back icon, headline and close icon, with
  **8** above and below, so the header is **64** tall and lines up with a
  small app bar. The headline is title large on **on surface variant**, on
  one line with an ellipsis (`headlineMaxLines`). The bottom actions bar is at least **72** tall, with **16** above
  and **24** below the buttons, which sit at the start **8** apart under an
  **outline variant** divider. The back and close icons are **on surface
  variant**, and turn **primary** with **primary** state layers on hover
  (**0.08**), keyboard focus (**0.1**) and press (**0.1**), using the sparkle
  ripple. The sheet's focus ring is **secondary**, **3** thick and **2** off,
  and it hides on pointer input. The body scrolls vertically and independently
  of the page (`scrollable` wraps non-scrolling content). The container
  paints under the system bars, while its content is inset from them. The
  insets are read from the view (as the app bar does), so the header and
  actions stay clear of the bars in edge-to-edge apps. The optional surface
  tint (`colors.surfaceTintColor`) is off by default.
* **Side sheets:** `M3ESideSheet.show` springs the modal sheet in from its
  edge over a **0.32** scrim. The close icon, the scrim, Escape, back and
  `M3ESideSheetController.close` dismiss it; `onDismissRequest` can veto them.
  On Android, predictive back lifts the sheet off the top and bottom edges
  (**48** in total), scales its width toward the gesture (grows up to **12**
  from its own edge, shrinks up to **24** from the other edge) and rounds every
  corner to **16**. Release commits and cancel springs back. In light theme,
  modal sheets set the system bar icons from what is under each bar: light
  icons over the scrim, dark icons where the sheet sits under the status or
  navigation bar. Dark theme keeps light icons. Standard sheets don't touch
  the system bars. The sheet reads
  as a dialog named by its headline: the headline comes first, then back,
  close, content and the actions in order. Tab lands on the icon buttons, and
  keyboard users start on the first one.
* **Side sheets:** added `M3ESideSheetLayout`, which places a sheet next to
  `body`. A standard sheet springs open as the body shrinks, keeping a **24**
  margin on its trailing edge. In `M3ESideSheetLayoutMode.adaptive` (default)
  the sheet is modal below **600** (scrim, Escape, back and predictive back)
  and standard at **600** and wider, and it morphs between the two on a spatial
  spring when the window is resized. `M3ESideSheetController` opens, closes and
  toggles it. Every value is on `M3ESideSheetTheme`, plus `colors`
  (`M3ESideSheetColors`), `action` (`M3ESideSheetActionStyle`) and `motion`
  (`M3ESideSheetMotion`). The labels are on `M3ESideSheetLabels`.
* **Side sheets (defaults):** the width is now **256** (was **320**), the modal
  corner radius is now **16** (was **28**), the headline is now **on surface
  variant** (was **on surface**), and the open and close motion is now a
  spatial spring (was a 450 ms curve).
* **Buttons:** added `M3EButtonDecorationScope`. `M3EButton`s below it take
  its decoration, with their own `decoration` merged on top field by field.
  `styles` limits it to certain button styles.
* **Buttons:** state layers are painted from live states (pressed **0.1**
  over keyboard focus **0.1** over hover **0.08**) instead of ink
  highlights, which kept their first color. Hover now shows again after a
  click, the press layer clears as soon as the press is released, and the
  focus layer shows only for keyboard focus (with the ring), never after a
  click.
* **Breaking — side sheets:** `M3ESideSheetTheme` was rebuilt around the
  spec. `cornerRadius` is now `modalCornerRadius`. `headerPadding` is replaced
  by `horizontalPadding`, `startPaddingWithIcon`, `headerVerticalPadding` and
  `topElementsGap`. `actionsPadding` is replaced by `actionsTopPadding`,
  `actionsBottomPadding` and `horizontalPadding`. `closeButtonPadding` and
  `iconSize` are removed (the close icon is an `M3EIconButton`).
  `containerColor(scheme)` now takes the variant, and `titleStyle()` is now
  `headlineStyle()`. `M3ESideSheet(title:, body:, actions:)` and
  `M3ESideSheet.show` still work as before.
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
* **Lists:** the expandable trailing icon sits in a **32 x 40** narrow pill with
  no fill at rest and **surface container** when expanded
  (`expandedIconBackgroundHeight` sets the height). An expanded row and its
  sublist now fill with **surface container high** as they open;
  `expandedStateColor` overrides it and `expandedStateFill: false` keeps the
  rest fill. Both are on `M3EExpandableStyle` and `M3EListExpandableTheme`.
* **Lists:** a sublist expansion's last row now always takes the **16** outer
  bottom corners, like a standalone list's last row. Set
  `roundSublistBottom: false` to round it only under the last parent row and
  otherwise keep the **4** inner radius, as before.
* **Lists:** keyboard focus treats the whole list, including sublists, as one
  Tab stop. Tab enters on the last-focused row (else the selected row, else the
  first) and Tab or Shift+Tab leaves from any row. Arrows move through rows,
  sub-rows, and row actions. Expandable headers, the leading selection icon,
  and the tap-to-toggle expand icon are no longer separate Tab stops; the
  icons are arrow-reachable row actions. Widgets inside an open expanded body
  stay on Tab. A sublist (or expanded body) joins the arrow order as soon as
  its row starts expanding, not only after the spring settles.
* **Lists:** a dismissible row without `onTap` now has a default tap: it
  reveals the row's swipe actions, or does nothing when there are none. The
  row is focusable either way, so it shows the keyboard focus ring.

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
