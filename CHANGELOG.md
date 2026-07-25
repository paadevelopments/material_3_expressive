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
