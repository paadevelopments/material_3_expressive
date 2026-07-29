## 1.0.4

### Added

* Shared foundations haptics API (`M3EHapticFeedback`, `M3EHaptics`) with `none` /
  `light` / `medium` / `heavy` impact levels plus `selection()` for discrete snaps.
* Default LIGHT tap/long-press feedback via `M3ETappable`, buttons, icon buttons,
  navigation destinations, carousel item taps, and related interactive surfaces.
* Selection haptics on stepped slider tick changes.
* Dismissible list LIGHT feedback on tap and on swipe-action commit.

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
