## 1.0.9

### Added

* `M3ECheckbox` optional `label`, `boxSize`, `hitSize`, `checkedChild`,
  `uncheckedChild`, and `checkIconPadding` (default right inset for optical
  centering of the built-in check), with a spatial-spring pulse on value
  changes.
* `M3EProgressIndicator.circular` / `.linear` optional `trackStrokeWidth`
  (and `.linear` `strokeWidth`) so all kinds can override track and value
  thickness.
* `M3ERefreshIndicator.contentDragOffset` — caps list top padding while
  pulling (defaults to indicator height + `2 * indicatorPadding`).
* `M3ERefreshIndicator.indicatorPadding` — vertical gap above/below the
  spinner in the list pad (default 8); reveal starts after `2 ×` this value.
* `M3ELoadingIndicator.rotationTurns` — when set, disables auto spin and
  morph pulse so a host (e.g. refresh) can drive rotation.
* `M3ELoadingIndicator.color` / `containerColor` document shape vs contained
  shell colors (both overridable).
* `M3ERefreshIndicatorController` to trigger refresh programmatically
  (same as Material `RefreshIndicatorState.show`).

### Fixed

* `M3ECheckbox` check mark is centered in the box (with default optical
  padding on the built-in check icon).
* `M3EProgressIndicator.linearWavy` honors `linearSize` for stroke thickness;
  linear painters draw track and active with separate stroke widths.
* `M3EButtonGroup` labeled actions with distinct `checkedLabel` no longer
  blank for a frame when the parent rebuilds a new `actions` list on
  selection change. Measured widths are kept across remotion, and layout
  signatures ignore visual-only decoration / widget identity noise.
* `M3ERefreshIndicator` locks resting inset on refresh; release bubble is
  scale-only (does not move layout). Short pulls cancel without `onRefresh`.

### Changed

* `M3EExpressiveLoadingIndicator` applies a noticeable scale pulse (spatial
  spring) to the active polygon holder on each morph — not the outer
  container. Morph rotation defaults are slower (45° / cycle, slower spring);
  timing and springs are configurable via widget params and
  `M3ELoadingIndicatorTheme`.
* `M3ERefreshIndicator` default `displacement` is 8 (top padding). List pad
  defaults to spinner height + 16. Scale/fade/downward reveal lags until pad
  reaches `2 × indicatorPadding`, then fills through full visibility.
  `onRefresh` runs only when fully revealed and the pointer is released.

## 1.0.8

### Added

* `M3EDimensions` — shared spacing (4dp grid) and corner-radius catalog.
  `M3ESpacing.regular` and `M3EShapes` radius tokens forward to it.
* Shape catalog helpers: `M3EShapeKind`, `M3EShapeClipper`, and
  `M3EShapeContainer` (named constructors for all 35 expressive polygons).
  Clip paths come from `M3EMaterialNewShapes` morph polygons.
* Example gallery: copyable Dart snippets on every playground (live with
  current controls). Wide split view highlights the active catalog row with
  the same fill and radius spring as selection list cards.

### Fixed

* `M3EButtonGroup` no longer jumps when `selectedIndex` changes while using
  the default scroll overflow. Fitting groups keep an unclipped, non-scrolling
  viewport; overflowing groups keep their scroll offset across rebuilds.

### Changed

* Depend on [`material_ui`](https://pub.dev/packages/material_ui) `^1.0.0` and
  import `package:material_ui/material_ui.dart` instead of
  `package:flutter/material.dart`. Flutter SDK constraint is `>=3.44.0`.

## 1.0.6

### Added

* Multi-select host `M3ESelection` with `M3ESelectionController`,
  `M3ESelectionAppBar`, `M3ESelectionLeading`, `M3ESelectionScope`, and
  `M3ESelectionTheme`. Optional `selectedColor` / theme `highlightColor` fill
  selected rows; `M3ECardList` and `M3EDismissibleList` pick that fill up
  automatically when hosted under the selection scope.
* Gradient decorations on action surfaces:
  `backgroundGradient`, `foregroundGradient`, `overlayGradient`, and
  `outlineGradient` on `M3EButtonDecoration`, `M3EToggleButtonDecoration`,
  `M3EIconButtonDecoration`, `M3EFabDecoration`, and
  `M3ESplitButtonDecoration` (plus trailing-segment gradient overrides).
* `M3ESegmentedButtonTheme` outline, divider, selected/unselected fill, and
  foreground colors/gradients. Dividers can sample a group-wide
  `dividerGradient`.
* `M3EFabMenu.decoration` (`M3EFabDecoration`) for the trigger FAB, plus
  `M3EFabMenuTheme` item fill, foreground, and outline gradients.
* `M3EBadge.alignment` (`M3EBadgeAlignment.topLeft` / `topCenter` /
  `topRight`). The badge sizes itself to the child's box; no parent
  `SizedBox` is required.
* `M3ETextField.inputFormatters`. `M3ETextFieldVariant` and
  `M3ETextFieldTheme` are exported from the package barrel.
* `M3ECarousel.onChange` with `M3ECarouselChangeDetails` (leading / focal
  index).
* `M3ESplitButton.m3eMenuBuilder` for a rich M3E menu tree (groups, dividers,
  submenus). `M3EButtonDecoration.animationDuration` is honored by split
  segments (defaults to `Duration.zero` so radius morph stays on the spring).
* Search idle `alignment` / `barAlignment` (`M3EAppBar.search` defaults to
  center). Toolbar `fabExpandsToolbar` and `pillActiveSpring`.
* List `colorBuilder` / `borderRadiusBuilder`, plus spring radius motion when
  a selected card's corners change. Card list / list item `variant` and
  `border`.
* `M3ETypeScale.apply` for shared typography (family, fallback, package,
  size factor/delta, color, decoration, `fontVariations`). `withColor`
  delegates to `apply`. `M3ETypeVariations` is an enum of Roboto Flex
  presets (`.variations`: regular, emphasized, condensed, extra condensed,
  wide, extra wide, round).
* `M3EThemeData.copyWith(fontFamily:)` / `fontFamilyFallback` / `package` /
  `fontVariations` and the same fields on `M3EMaterialApp`.
* Example gallery: catalog-driven playgrounds, palette theme-config screen
  (auto theming, dynamic color, five seed colors, font family and M3
  Expressive type styles).

### Fixed

* `M3ETextField` no longer grows when the focused stroke thickens (border is
  painted as a foreground decoration). Height grows with `maxLines`. Empty
  labels sit vertically centered; unlabeled values sit vertically centered.
* Split-button foreground gradients tint text/icons instead of filling the
  segment; trailing radius morphs immediately after the menu closes when a
  background gradient is set.
* Button gradient outlines no longer expand into unbounded height.
* Selection highlight color (`selectedColor` / `highlightColor`) now reaches
  hosted list rows.

### Changed

* Example app shell uses the playground catalog under
  `example/lib/pages/playground/` and a theme config route from the home
  app bar.

## 1.0.5

### Fixed

* `M3ESwitch` — pressed thumb now bleeds into left/right track padding (matching
  vertical edge contact); default `thumbSizePressed` is `trackHeight` (32).
* `M3EExpressiveLoadingIndicator` — morph settle uses
  `M3EMotion.expressiveSpatialDefault` (keeps droppy overshoot velocity).
* Dropdown menu search field — defaults to `surface` fill and panel
  `containerRadius` (was unfilled with item outer radius).
* Navigation bar, drawer, and rail destinations — `SystemMouseCursors.click` on
  desktop/web hover.
* Classic circular indeterminate progress — shares wavy circular rotation and
  sweep timing (flat arcs unchanged).
* `M3ESlider` / `M3ERangeSlider` — tap outside clears focus via `TapRegion` and
  `M3EFocus.tapOutsideHandler`.
* `M3EMenu` — no longer autofocuses the first item on open; popup focus scope is
  still focused so keyboard navigation works without a pre-highlight.

### Changed

* `M3EIconButton` — hover radius morph (with press), aligned with button-style
  state listening; theme `radiusHovered` tokens.
* `M3ESearchBarTheme.maxWidth` default is `double.infinity` (full-width layouts).

## 1.0.4

### Added

* Shared foundations haptics API (`M3EHapticFeedback`, `M3EHaptics`) with `none` /
  `light` / `medium` / `heavy` impact levels plus `selection()` for discrete snaps.
* Opt-in haptic wiring across `M3ETappable`, buttons, icon buttons, navigation
  destinations, carousel item taps, dismissible lists, and related surfaces
  (defaults to `none`).
* Selection haptics on stepped slider tick changes.
* Dismissible list haptic hooks on tap and swipe-action commit (defaults to `none`).
* `M3ESlider` / `M3ERangeSlider` `cornerRadius` (theme default
  `trackCornerRadius` = 8) — fixed outer track radius, not derived from
  thickness.
* `M3ESwitch` thumb-centered state layer (`stateLayerSize` on widget/theme,
  default 48) for hover/focus/press.
* Toolbar scroll-exit / manual visibility via `M3EToolbarVisibilityController`
  and `M3EToolbarScrollBehavior`.
* Toolbar action selection via `activeIndex` / `onActiveIndexChanged`, labeled
  action width springs, and FAB expand/collapse icons with pill↔FAB morph.
* `M3EFabMenu` expand/collapse icons, size morph (80↔56), and
  `M3EFabMenuPosition` (left/right).
* `M3EIconButton.visualSize` for layout-driven visual size overrides.

### Fixed

* Classic linear and wavy linear/circular indeterminate progress indicators —
  dual traveling segments with track gaps (linear) and spin + sweep (circular
  wavy); classic circular indeterminate unchanged.
* Switch thumb press feedback now shows the Material concentric translucent
  state-layer circle.

### Changed

* Internal analyze / `klin_dart` compliance refactors (progress controller sync,
  toolbar build/scroll helpers, carousel wrapper `part` splits) with no
  intentional public API or behavior breaks.
* Default slider outer track corners use fixed radius 8 (previously half of
  track thickness).

## 1.0.3

### Fixed

* Re-implement `M3ECarouselWrapper` pulse logic to use a sliding clip window instead of `Transform`
  scaling, ensuring content remains stable and does not snap during animations.
* Introduce `_stableInnerContentExtent` to calculate fixed layout sizes for carousel items based on
  viewport constraints and flex weights.
* Update `ContainmentPage` in the example app to demonstrate image-based carousel items with
  gradient overlays and labels.
* Add sample image assets to the example project and update `pubspec.yaml` to include the assets
  directory.
* Enhance documentation for `M3ECarouselWrapper` parameters and internal state management.

## 1.0.2

### Fixed

* **Platform tags** — declare all six Flutter platforms in `pubspec.yaml` so
  pub.dev lists iOS and Web (dynamic color still no-ops where unsupported).

## 1.0.1

### Fixed

* **License detection** — `LICENSE` is now a clean OSI-recognized MIT text so
  pub.dev awards the license points; third-party and vendored attributions
  live in `NOTICE`.
* **Date / range / time picker dialogs** — landscape layouts no longer stretch
  to the screen edge; dialogs use bounded height and wrap content correctly.
* **Landscape picker sizing** — slightly wider dialog and title panel defaults
  for date, range, and time pickers.
* **Vertical `M3EDivider`** — fills the parent’s bounded height again so it
  renders in rows (for example the containment gallery demo).

### Changed

* Internal refactors for analyzer / `klin_dart` compliance (file and complexity
  splits) with no intentional public API breaks.

## 1.0.0

Initial release.

A faithful Flutter implementation of the Material 3 Expressive component set,
exposed as direct `M3E*` widgets with spring-driven motion and design tokens
via `M3ETheme`.

### Added

* **39 component modules** spanning the official Material 3 groups:
    * **Actions** — buttons, icon buttons, FAB, extended FAB, FAB menu, button
      groups, segmented buttons, split buttons, toggle buttons.
    * **Communication** — badges, linear & circular progress indicators, loading
      indicator, snackbar, tooltips.
    * **Containment** — cards, carousel, dividers, lists, dialogs (standard &
      full-screen), bottom sheets, side sheets.
    * **Navigation** — top & bottom app bars (incl. search), tabs, navigation
      bar, navigation rail, navigation drawer, toolbars, menus.
    * **Selection** — checkbox, radio button, switch, chips, sliders (incl.
      wavy), dropdown menus, date picker, time picker.
    * **Text inputs** — text fields, search bar / search view.
* **Direct component API** — construct each `M3E*` widget directly; enums and
  models are exported from a single library import.
* **Design token foundations** — a centralized `foundations` layer for color
  schemes, typography, motion/spring physics, shapes, elevation, and state
  layers, provided through the `M3ETheme` inherited widget.
* **Expressive motion** — spring-driven press feedback, shape morphing, liquid
  selection indicators, and M3-accurate hover/focus/press state layers via the
  shared `M3ETappable` interaction primitive.
