## 1.1.5

### Changed

* **Search:** spec **56** pill bar on **surface container high**, **360–720**
  wide, with optional `avatar` and `showClearButton`; spring focus inset and
  **secondary** focus ring. The view is `M3ESearchViewStyle.contained`
  (default) or `.divided`, full-screen below **600** and docked above, with a
  morph from the bar, predictive back, arrow-key results and result
  announcements. Added `M3ESliverSearchBar`.
* **Text fields:** spec filled and outlined fields (**56** tall, **4**
  corner), spring label, notched outline, state colors and focus ring. Added
  `prefixText`, `suffixText`, `placeholder`, `isRequired`, `maxLength`
  counter, `readOnly`, `minLines`, `supportingTextOnFocusOnly`, `density`,
  `showClearButton`, `showPasswordToggle`, `iconAlignment` and
  `affixAlignment` (`M3ETextFieldSlotAlignment`). `maxLines` is now `int?`
  (`null` grows without limit).
* **Dialogs:** spec basic dialogs with pinned headline and actions, stacked
  actions, `leadingAction`, `subhead` and `titleMaxLines`; spring open/close,
  focus trap, `onDismissRequest`, `position` (`M3EDialogPosition`) and
  `M3EDialogController` with discard confirmation. `M3EFullScreenDialog` has a
  **56** header, `bottomActions` and `contentHeadline`.
  `M3EDialog.showAdaptive` / `M3EAdaptiveDialog` switch at **600**.
* **Bottom sheets:** spec container, margins, drag handle and scrim; preset
  heights (`M3EBottomSheetValue`), spring snapping, keyboard and accessibility
  handle actions, predictive back and system bar icons.
  Added `M3EBottomSheet.standard`, `expandToFullScreen`,
  `M3EBottomSheetController` and `M3EBottomSheet.showAdaptive`. Defaults:
  `handleVerticalPadding` **22** (was **16**), `dismissVelocity` **700** (was
  **200**, now moves one height).
* **Side sheets:** spec modal, standard and `detached` sheets (**256** wide,
  **16** modal corners, **64** header); spring open/close, predictive back,
  system bar icons and dialog semantics. Added `M3ESideSheetLayout`
  (adaptive at **600**) and `M3ESideSheetController`.
* **Buttons:** added `M3EButtonDecorationScope`. State layers now follow live
  hover, focus and press states.
* **Lists:** expandable rows fill **surface container high** with a **32 x
  40** trailing pill; sublist last rows take the outer corners
  (`roundSublistBottom`). The whole list is one Tab stop with arrow-key
  navigation. Dismissible rows without `onTap` reveal their swipe actions.
* **Breaking — side sheets:** `M3ESideSheetTheme` was rebuilt.
  `cornerRadius` → `modalCornerRadius`; `headerPadding` → `horizontalPadding`,
  `startPaddingWithIcon`, `headerVerticalPadding`, `topElementsGap`;
  `actionsPadding` → `actionsTopPadding`, `actionsBottomPadding`,
  `horizontalPadding`; `closeButtonPadding` and `iconSize` removed;
  `containerColor(scheme)` now takes the variant; `titleStyle()` →
  `headlineStyle()`.
* **Breaking — text fields:** `M3ETextFieldTheme` was rebuilt. `minHeight` →
  `containerHeight`; `iconGap` → `iconTextGap` / `iconEdgePadding`;
  `supportingTextPadding` → `supportingTopPadding` /
  `supportingHorizontalPadding`; `horizontalPadding` is now a `double`;
  colors move to `colors: M3ETextFieldColorTheme(...)` / `resolveColors()`.
  Removed `contentHeight`, `contentVerticalPadding`, `labelRestingOffset`,
  `labelFloatingTopPadding`, `labelRestingTopPadding`, `labelBottomPadding`,
  `labelSlotHeight()`, `accentColor()`, `backgroundDecoration()`,
  `borderDecoration()` and `decoration()`.

### Fixed

* **Text fields (web):** typing works again after a focused field changes
  password visibility, read-only or keyboard type and is refocused.
* **Text fields, search:** touch selection (tap, long-press, drag) now shows
  the selection handles. The search input now supports long-press and drag
  selection.
* **Lists:** `M3EList.sliver` no longer throws in a `CustomScrollView`.

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
