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
