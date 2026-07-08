# Material 3 Expressive

A faithful, dependency-light Flutter implementation of the
[Material 3](https://m3.material.io/components) **Expressive** component set.

Every widget is built directly on `package:flutter/widgets.dart` — the package
does **not** depend on the framework's `material` library — and ships with
M3-accurate motion: spring-driven press feedback, shape morphing, and
hover/focus/press state layers. All 36 components are used directly as `M3E*`
widgets.

## Features

- **36 components** covering the six official Material 3 groups (Actions,
  Communication, Containment, Navigation, Selection, Text inputs).
- **Direct component API** — construct each `M3E*` widget directly; enums and
  models are exported from the single library import.
- **Expressive motion & interaction** — spring physics, shape morphing, and
  proper state layers on every interactive surface.
- **Design token foundations** — color schemes, typography, motion, shapes,
  elevation, and state layers, provided via the `M3ETheme` inherited widget.
- **No `material` dependency** — pure `widgets`-layer implementation, so it
  drops cleanly into any Flutter app shell.

## Requirements

| Tool    | Version    |
| ------- | ---------- |
| Flutter | `>= 3.3.0` |
| Dart    | `^3.12.0`  |

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  material_3_expressive: ^1.0.0
```

Then fetch it:

```bash
flutter pub get
```

Or add it from the command line:

```bash
flutter pub add material_3_expressive
```

## Setup

Import the library — a single import exposes every component and foundation:

```dart
import 'package:material_3_expressive/material_3_expressive.dart';
```

Wrap your app (or any subtree) in an `M3ETheme` so components can resolve their
color scheme and type scale. If no `M3ETheme` is found, components fall back to
a default light theme, so this step is optional but recommended:

```dart
M3ETheme(
  data: M3EThemeData.light(seedColor: const Color(0xFF6750A4)),
  child: myApp,
);
```

Use `M3EThemeData.dark(...)` for a dark scheme, or build one from an existing
`ColorScheme`.

## Accessing components

Every component is a widget you construct directly. Each `M3E*` class and its
enums/models are exported from the single library import.

### Examples

```dart
// A filled button
M3EButton(
  onPressed: () {},
  child: const Text('Continue'),
);

// A tonal icon button that toggles
M3EIconButton(
  icon: const Icon(M3EIcons.edit),
  variant: M3EIconButtonVariant.tonal,
  onPressed: () {},
);

// A switch bound to state
M3ESwitch(
  value: enabled,
  onChanged: (bool value) => setState(() => enabled = value),
);

// A card
M3ECard(
  variant: M3ECardVariant.elevated,
  child: const Text('Card content'),
);
```

Components that present transient surfaces take a `BuildContext` and require a
`Navigator`/`Overlay` ancestor (any `WidgetsApp`/`MaterialApp` provides this):

```dart
// Snackbar
M3ESnackbar.show(
  context,
  message: 'Draft saved',
  actionLabel: 'Undo',
  onAction: () {},
);

// Dialog
M3EDialog.show<void>(
  context,
  dialog: M3EDialog(
    title: 'Reset settings?',
    content: const Text('This restores default values.'),
    actions: <Widget>[
      M3EButton(
        style: M3EButtonStyle.text,
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
      M3EButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Reset'),
      ),
    ],
  ),
);
```

## Running the example

A full gallery app demonstrating every component lives in the [`example/`](example)
directory:

```bash
cd example
flutter run
```

The gallery groups components exactly like this README (Actions, Selection,
Containment, Navigation, Feedback) and includes a light/dark theme toggle.

## Development

Static analysis is enforced with the standard analyzer plus the
[`klin_dart`](https://pub.dev/packages/klin_dart) custom lint rules for
readability, complexity, and file/class length.

```bash
flutter analyze
dart run custom_lint
flutter test
```

## License

Distributed under the MIT License. See [`LICENSE`](LICENSE) for details.

Copyright (c) 2026 Paa Developments <paa.code.me@gmail.com>
