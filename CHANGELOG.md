## 1.1.6

### Changed

* Raise `material_ui` to `^1.6.0`.
* **Carousel:** added `M3ECarouselScrim.gradient`. By default it fades from
  transparent at the top to **60%** `colorScheme.scrim` at the bottom, under
  the text; pass `gradient` for a custom one. `opacity` fades the whole layer.
* **Sliders:** inner tick marks now default to **4dp**, the same size as the
  end stop indicators (`M3ESliderTheme.tickSize`, was **2dp**). They are also
  drawn at full strength (`tickOpacity` **1**, was **0.38**), and inactive
  ticks use `onSecondaryContainer` like the end stops.

### Fixed

* **Bottom sheets:** a sheet no longer bounces back up when its content or the
  system bars change size while it is closing. Detent changes are not
  re-settled while the route exits
  ([#28](https://github.com/paadevelopments/material_3_expressive/pull/28),
  thanks @StillMisty).

## 1.1.5

### Changed

* **Search:** spec pill bar, contained or divided view and `M3ESliverSearchBar`.
* **Text fields:** spec filled and outlined fields with new slots, counter,
  clear and password buttons; `maxLines` is now `int?`.
* **Dialogs:** spec basic and full-screen dialogs, spring motion, focus trap,
  `M3EDialogController` and `M3EDialog.showAdaptive`.
* **Bottom sheets:** spec sheets with preset heights, `.standard`,
  `M3EBottomSheetController` and `.showAdaptive`; new `handleVerticalPadding`
  and `dismissVelocity` defaults.
* **Side sheets:** spec modal, standard and detached sheets,
  `M3ESideSheetLayout` and `M3ESideSheetController`.
* **Buttons:** `M3EButtonDecorationScope` and live state layers.
* **Lists:** expandable row fill, sublist corners and single Tab stop with
  arrow keys.
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

* **Text fields (web):** typing works after refocusing a reconfigured field.
* **Text fields, search:** touch selection shows the selection handles.
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
