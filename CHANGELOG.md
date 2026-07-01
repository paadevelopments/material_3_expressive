## 1.0.0

Initial release.

A faithful, dependency-light Flutter implementation of the Material 3
Expressive component set, built on `package:flutter/widgets.dart` (no dependency
on the framework's `material` library).

### Added

* **36 components** spanning the six official Material 3 groups:
  * **Actions** — buttons, icon buttons, FAB, extended FAB, FAB menu, button
    groups, segmented buttons, split buttons.
  * **Communication** — badges, linear & circular progress indicators, loading
    indicator, snackbar, tooltips.
  * **Containment** — cards, carousel, dividers, lists, dialogs (standard &
    full-screen), bottom sheets, side sheets.
  * **Navigation** — top & bottom app bars, tabs, navigation bar, navigation
    rail, navigation drawer, toolbars, menus.
  * **Selection** — checkbox, radio button, switch, chips, sliders, date
    picker, time picker.
  * **Text inputs** — text fields, search bar.
* **Grouped facade API** — every component is reachable through a concise,
  discoverable facade: `M3EActions`, `M3ECommunication`, `M3EContainment`,
  `M3ENavigation`, `M3ESelection`, and `M3ETextInputs`.
* **Design token foundations** — a centralized `foundations` layer for color
  schemes, typography, motion/spring physics, shapes, elevation, and state
  layers, provided through the `M3ETheme` inherited widget.
* **Expressive motion** — spring-driven press feedback, shape morphing, and
  M3-accurate hover/focus/press state layers via the shared `M3ETappable`
  interaction primitive.
