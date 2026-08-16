# AGENTS.md — Contributor Rules for AI Agents

> These rules apply to **every AI agent** (Copilot, Cursor, Gemini, Claude, etc.) that touches this repository.
> Read this file completely before writing a single line of code.

This document complements **The base rule** in [`.cursor/rules/base-rule.mdc`](.cursor/rules/base-rule.mdc). When both apply, follow both; if anything conflicts, treat the base rule as the tighter project-specific constraint.

---

## 1. Understand Before You Act

**Every session must begin with a project orientation pass.** Before any implementation or fix, you MUST review:

- **Project structure**: [`lib/components/`](lib/components/) — one folder per component (`buttons/`, `sliders/`, `date_pickers/`, …); [`lib/foundations/`](lib/foundations/) — shared theme, tokens, motion, tappable, and forthcoming haptics
- **Public API surface**: [`lib/material_3_expressive.dart`](lib/material_3_expressive.dart) is the single export barrel — understand what is and is not exported
- **Architecture patterns**: Each component follows the pattern in §2 — understand it before adding to it
- **Example app**: [`example/lib/`](example/lib/) — run it and trace your component’s demo **page** before making changes
- **Changelog**: [`CHANGELOG.md`](CHANGELOG.md) — understand what has recently changed and why
- **README**: [`README.md`](README.md) — understand the user-facing surface and component documentation

Do not assume you remember the structure from a previous session. Re-read what is relevant each time.

---

## 2. Project Architecture

This is a **Flutter UI component library** implementing Material 3 Expressive (M3E) components.

### Top-level layout

```
lib/
├── material_3_expressive.dart   # public barrel
├── components/                  # ~39 component modules
│   └── <component>/
└── foundations/                 # theme, tokens, shared primitives
```

There is **no** `lib/src/`.

### Component directory pattern

Each component lives under `lib/components/<component-name>/` and may contain (only if needed):

```
lib/components/<component>/
├── m3e_<component>.dart    # entry file(s); may hold variations
├── components/             # sub-widgets
├── enums/
├── styles/                 # theme / token data classes
├── models/
├── controllers/
├── utils/
└── res/                    # static constants (not enums)
```

**Example — `buttons/`:**

```
lib/components/buttons/
├── m3e_buttons.dart
├── components/
├── enums/
├── styles/
└── ...
```

### Foundations

[`lib/foundations/`](lib/foundations/) holds design tokens, theming, shapes, motion, and shared interaction primitives. Key exports are wired through [`lib/foundations/foundations.dart`](lib/foundations/foundations.dart).

Notable areas:

- **Theme**: `M3ETheme`, `M3EThemeData`, `M3EThemeScope`, `M3EMaterialApp`
- **Color**: `M3EColorScheme`, `M3EDynamicColorHost`
- **Tokens**: typography, spacing, elevation, shapes, state layers
- **Motion / interaction**: `m3e_motion.dart`, `M3ETappable`
- **Shapes bridge**: `m3e_material_new_shapes_bridge.dart` → `material_new_shapes`
- **Haptics (forthcoming)**: shared expressive haptics will live here (see §2.1)

### 2.1 Haptics (forthcoming)

The package **will add** a shared haptics implementation under **foundations** (same layer as motion and `M3ETappable`), for example `lib/foundations/m3e_haptics.dart`, exported via `foundations.dart` and the public barrel when ready.

Rules for agents:

- Use the **shared M3E haptics API** for tactile feedback — do **not** scatter raw `HapticFeedback.*` or one-off platform calls across components.
- If the shared API does not cover a case, **ask** before inventing a parallel path.
- Pair haptics with spring/expressive motion where the M3E spec calls for feedback (press, select, snap, dismiss, etc.).
- Respect platform no-ops / reduced capability (same spirit as `dynamic_color` on unsupported platforms).

### Key design principles

- **Spring physics first**: Animations use the `motor` package for spring-driven motion (not Flutter `AnimationController` curves directly unless there is a strong reason). Foundations motion and `M3ETappable` are the reference patterns.
- **Material 3 Expressive spec**: Components align with the M3E design spec — expressive shapes, state layers, neighbor effects where appropriate (ask for confirmation when adding squish or similar behavior that may affect layout).
- **Barrel exports**: Each component exposes via its entry `m3e_*.dart`; public symbols reach consumers through [`material_3_expressive.dart`](lib/material_3_expressive.dart).
- **Compose with other components**: Components may depend on other M3E components when the spec calls for it (e.g. date/time pickers use `M3EButton` and `M3EIconButton`, toolbars use `M3EIconButton` and menus, navigation bar uses `M3EBadge`). Import the other component’s **entry file** or its **public** enums/styles/models — not private sub-widgets, utils, or implementation details from another folder. Avoid circular dependencies between component modules.
- **Style via theme data**: Customization is exposed via component `styles/` theme classes (e.g. `M3ESliderTheme`), not ad-hoc raw parameters where a theme already exists.
- **No facades**: Use `M3E*` widgets directly (including in the example app). Do not add facade wrappers.
- **Variations**: Prefer one base type with named constructors (e.g. `M3EAppBar.top`, `.bottom`, `.sliver`) **only when** variants share enough fields/logic; otherwise keep separate entry types.

### Naming

| Kind | Convention |
|------|------------|
| Files | `m3e_` prefix + snake_case (e.g. `m3e_toggle_button_group.dart`) |
| Classes | `M3E` prefix + PascalCase (e.g. `M3EToggleButtonGroup`) |
| One class per file | Except private `State` classes and everything under `foundations/` |

---

## 3. API Rules — Do Not Break Without Confirmation

**Never make breaking API changes without explicit user approval.**

A breaking change includes:

- Renaming or removing any public class, method, parameter, or property
- Changing the type or nullability of a public parameter
- Changing the behavior of a default value
- Removing or reordering positional parameters
- Changing a named parameter to positional or vice versa

If your implementation requires a breaking change:

1. **Stop immediately.**
2. Describe the change clearly: what is changing, why, and the migration path.
3. Wait for explicit confirmation before proceeding.

Public surface = symbols exported from [`material_3_expressive.dart`](lib/material_3_expressive.dart) (directly or via component/foundations barrels).

---

## 4. Do Not Over-Engineer

- Implement **only** what was asked. No speculative features, no “while I’m at it” refactors.
- If a request is ambiguous, **ask** before writing code. State what is unclear.
- Prefer the simplest implementation that satisfies the requirement.
- Do not add or upgrade dependencies without explicit user approval.
- Do not restructure files or directories unless that restructure **is** the task.
- If you find an unrelated bug and a fix: describe the issue with an example, give a **criticality score (1–5)**, propose the simplest fix, and **wait for explicit approval** before fixing.

**When in doubt, ask. Never guess at intent.**

---

## 5. Always Make a Plan First

For any non-trivial change (anything beyond a typo or single-line correction):

1. **Write a plan** before implementation. Include:
   - Files touched and why
   - New/changed API (types and signatures)
   - How it fits existing architecture
   - Risks or open questions
2. **Present the plan** and get confirmation.
3. Then implement.

---

## 6. Commit Message Format

All commits MUST follow:

```
<scope>: <message>
```

- **`<scope>`** — component folder name from `lib/components/` (e.g. `buttons`, `date_pickers`), or `foundations`, `example`, `pubspec`, `test`, `chore`, `doc`
- **`<message>`** — short, lowercase, imperative description

**Good examples:**

```
date_pickers: fix landscape dialog vertical stretch
divider: fill bounded height for vertical axis
foundations: add shared haptics helper
example: demo vertical divider in containment page
pubspec: bump version to 1.0.2
chore: add AGENTS.md for ai contributors
```

**Bad examples:**

```
fix bug                    ❌  too vague, no scope
Updated toggle button      ❌  not lowercase, no scope
feat: add new component      ❌  conventional-commits style — not this project
```

**Only create commits when the user explicitly asks.**

---

## 7. After Every Change — Report to the User

After completing work, provide:

1. **What changed** — every file modified and what was done
2. **Why** — reasoning for non-obvious decisions
3. **How to test** — concrete steps:
   - Name the example **page** in [`example/lib/pages/`](example/lib/pages/) (e.g. `containment_page.dart`, `selection_page.dart`)
   - Describe the exact interaction (e.g. “open date picker in landscape, confirm dialog height wraps content”)
   - Include paste-ready snippets for the example app when helpful

Any change to a component’s **entry-file** public API must be reflected in the example app (The base rule §7).

---

## 8. Never Push to GitHub Without Confirmation

- Do **not** run `git push` without explicit user instruction.
- You may stage files when the user asks for a commit.
- Tell the user what is ready to push before asking whether to push.

---

## 9. Follow Existing Conventions — Do Not Reinvent

Before adding anything new, search for how similar things are already done:

| What you want to do | Where to look first |
|---------------------|---------------------|
| Add spring / expressive animation | `motor` usage in components; [`lib/foundations/m3e_motion.dart`](lib/foundations/m3e_motion.dart); [`lib/foundations/m3e_tappable.dart`](lib/foundations/m3e_tappable.dart) |
| Add haptics | Foundations haptics module (forthcoming); do not duplicate per component |
| Add a theme / style parameter | Component `styles/m3e_*_theme.dart` |
| Use another M3E component | Import its entry `m3e_*.dart` and public enums/styles/models (e.g. `date_pickers` → `buttons`, `toolbars` → `icon_buttons` / `menus`); do not import another component’s private sub-widgets or utils |
| Add an example demo | [`example/lib/pages/`](example/lib/pages/) — follow `GallerySection` / `DemoRow` in [`example/lib/widgets/gallery_section.dart`](example/lib/widgets/gallery_section.dart) |
| Export a new public symbol | Component entry `m3e_*.dart`, then [`lib/material_3_expressive.dart`](lib/material_3_expressive.dart) |
| Shapes / morph polygons | [`lib/foundations/m3e_shapes.dart`](lib/foundations/m3e_shapes.dart), [`lib/foundations/m3e_material_new_shapes_bridge.dart`](lib/foundations/m3e_material_new_shapes_bridge.dart) |
| Dynamic color from OS | [`lib/foundations/m3e_dynamic_color_host.dart`](lib/foundations/m3e_dynamic_color_host.dart) |
| Split oversized files | Same component folder; prefer extracted widgets/helpers or `part` + `extension on State` over fragile cross-mixin stubs |

Match existing patterns for vendored/portions: headers may note upstream sources; see [`NOTICE`](NOTICE) for third-party attributions.

---

## 10. Dependency Rules

- **Do not add** new `pub.dev` dependencies without user approval.
- **Do not upgrade** existing dependencies without user approval.

Runtime dependencies and their roles:

| Package | Role |
|---------|------|
| `motor` | Spring physics for expressive motion |
| `dynamic_color` | Device dynamic color (no-ops on iOS/Web; platforms declared in pubspec) |
| `material_new_shapes` | Expressive morph polygons via foundations bridge |
| `collection` | Utilities (e.g. carousel) |
| `flutter` | SDK (`>=3.44.0`, Dart `^3.12.0`) |
| `material_ui` | Official Material widgets (`MaterialApp`, `ThemeData`, `ColorScheme`) |

Dev-only: `flutter_lints`, `custom_lint`, `klin_dart`, `material_color_utilities`.

Use **FVM** Flutter at [`.fvm/flutter_sdk`](.fvm/flutter_sdk) (see [`.fvmrc`](.fvmrc)).

---

## 11. Code Formatting & Static Analysis

Before finalizing work:

- Run **`dart analyze`** (or `flutter analyze`) and fix all errors introduced by your changes. This is required **every prompt** (The base rule §6).
- Do **not** run `klin_dart` / `dart run custom_lint` unless the user explicitly asks.
- Run **`dart format`** on touched paths when finishing a change set.
- [`lib/foundations/m3e_icons.dart`](lib/foundations/m3e_icons.dart) is analyzer-excluded (generated glyph dump) — do not “fix” it.

Prefer fixing issues in source over adding `// ignore` or new `analysis_options` suppressions.

---

## Quick Reference Checklist

Before declaring a task done:

- [ ] I read relevant source files, not only the ones I edited
- [ ] I checked [`lib/material_3_expressive.dart`](lib/material_3_expressive.dart) — public exports are correct
- [ ] I ran `dart analyze` / `flutter analyze` cleanly on affected code
- [ ] I ran the example app and tested manually on the right **page**
- [ ] Entry-file API changes are reflected in the example app
- [ ] Commit message would follow `<scope>: <message>` (if committing)
- [ ] I did **not** make breaking API changes (or got explicit approval)
- [ ] I reported what changed, why, and how to test
- [ ] I did **not** push or commit without user confirmation
- [ ] I did **not** add or upgrade dependencies without approval
- [ ] New code matches `m3e_` / `M3E` naming, folder layout, and The base rule
- [ ] Cross-component usage imports public entry/types only — no private internals from other folders
- [ ] Haptics (when used) go through foundations — not raw `HapticFeedback` scattered in components
