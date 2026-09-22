## 1.1.3

### Changed

* Bump `material_ui` to `^1.4.0` (Dart SDK `^3.13.0`).
* **Breaking — Extended FABs:** add `M3EExtendedFabSize` (`small` 56 /
  `medium` 80 / `large` 96; default **small**). Icon is optional; label is
  required (no icon-only). Per-size paddings (medium leading/trailing **26**),
  radii 16/20/28, and label type titleMedium / titleLarge / headlineSmall.
  `M3EExtendedFabTheme` resolves via size metrics; min width **80**. Add
  `M3EExtendedFabController` (scroll collapse/expand, appear morph, container
  transform), focus ring **3dp** / **2dp** / `secondary`, TapRegion focus
  clear, and disabled muted colors (shared with FAB).
* **Breaking — FABs:** `M3EFabSize.medium` is now **80dp** / icon **28** /
  radius **20** (was 56/24/16). Add `M3EFabSize.regular` (56/24/16) for the
  baseline size. Default size remains `medium`. Add filled color styles
  `primaryFilled` / `secondaryFilled` / `tertiaryFilled`; existing
  `primary` / `secondary` / `tertiary` stay as container roles. Add
  `M3EFabController` (scroll show/hide, appear morph, container transform),
  focus ring **3dp** / **2dp** gap / `secondary`, and disabled muted colors.
* **Split buttons** — align to M3E size tokens: pressed inner corners match
  hovered (8/12/12/20/20); between-space always **2dp**; optical vs centered
  trailing pads; small leading icon **20dp**; standard-motion chevron **180°**;
  trailing a11y expanded/collapsed + “More options”; shared button colors with
  state-layer-only open trailing (no toggle recolor).
* **Segmented buttons** — align to M3E Outlined tokens: density
  (`M3ESegmentedButtonDensity` 0/−1/−2/−3 → 40/36/32/28dp), ≥48dp target,
  disabled outline/content opacities (0.12 / 0.38), focus ring 3dp /
  `secondary` with 2dp gap, single-select cannot clear, multi-select allows
  empty, a11y radio/checkbox semantics, and theme overrides for selected fill,
  focus, and optional `maxWidth`.
* **Breaking — buttons:** fold toggle selection into `M3EButton` via
  caller-controlled `isSelected`, `selectedIcon`, and `selectedLabel`;
  `M3EToggleButton`, `M3EToggleButtonDecoration`, and
  `M3EToggleButtonTheme` are removed. Toggle text buttons are no longer
  supported.
* **Breaking — button groups:** rename the component module from
  `toggle_button_group` to `button_group`; group actions now use
  `isSelected`, `selectedIcon`, and `selectedLabel`, and group decoration uses
  `M3EButtonDecoration`. Theme access moves from `toggleButtonGroupTheme` to
  `buttonGroupTheme`. All actions render as `M3EButton` (icon-only, text-only,
  or icon+label); `M3EButtonGroupItemKind` and `M3EButtonGroupAction.iconButton`
  are removed — use `minWidth` for icon-button-like resting widths. Connected
  groups span their surface with equal-width segments (optional
  `buttonGroupTheme.maxWidth` cap); standard between-space follows size tokens
  (18 / 12 / 8 / 8 / 8) and connected gap is 2dp.
* **Breaking — button groups density:** `M3EButtonGroupDensity` is now
  `regular` / `comfortable` / `compact` / `dense` (spec levels 0 / −1 / −2 /
  −3). Density adjusts **container height** (−4dp per level), not between-space.
  Hover keeps resting shape; press morphs corners / neighbour squish.
* **Button groups** — align standard spacing and connected corner tokens per
  size; add `selectionRequired` and `multiSelect` (with `selectedIndices` /
  `onSelectedIndicesChanged`); use the 1400/0.9 neighbour-squish spring; keep
  keyboard traversal on Tab order without capturing arrow keys; and keep all
  actions at a uniform group-managed height for each size. Elevated
  button groups remain available but are not recommended.
* Bump `material_ui` to `^1.3.0`.
* Raise Flutter SDK constraint to `>=3.47.0` (FVM pin `3.47.0`) for
  `material_ui` `1.3.0` compatibility.
* **Buttons** — align `M3EButton` defaults to Material 3 Expressive size /
  color / shape tokens: XS leading/trailing **12dp** and icon–label gap
  **4dp**; outline widths **1 / 1 / 1 / 2 / 3** (XS→XL); outlined outline
  role `outlineVariant` and label/icon `onSurfaceVariant`; disabled container
  / outline opacity **0.1**; shape spring default stiffness **1400** /
  damping **0.9** (`M3EButtonTheme.shapeSpring`, overridable via decoration
  motion); hover keeps resting corners (press morph only); pressed state
  layer **0.1** with default `InkSparkle`; label `maxLines` **1** (up to
  **2** at ≥200% text scale).
* **Icon buttons** — align `M3EIconButton` to M3E size / color / shape
  tokens: square radii **12 / 12 / 16 / 28 / 28**, pressed **8 / 8 / 12 /
  16 / 16**; outline widths **1 / 1 / 1 / 2 / 3**; outline role
  `outlineVariant`; full default/toggle color roles; disabled **0.1** /
  **0.38**; shape spring **1400 / 0.9**; hover keeps resting; pressed
  state layer **0.1** + `InkSparkle`; keyboard focus ring only (no sticky
  focus fill). Selected toggle icons use per-size icon tokens (**20 / 24 /
  24 / 32 / 40**). **Breaking:** default `variant` is now **`filled`**.

## 1.1.2

### Added

* Keyboard focus rings via foundations `M3EFocusRing`, `M3EFocusRingTheme`
  (`M3EThemeData.focusRingTheme`), and `M3EFocusInteraction`. Rings follow each
  control’s outer shape and show for keyboard focus; pointer interaction clears
  them until Tab/arrow navigation resumes. Text fields and search bars keep
  their focused border **and** show the outset ring.
* `M3EThemeData.keyboardFocusIndicators` to globally enable/disable focus-ring
  chrome.
* Focus rings / keyboard activation across actionable hosts (buttons, icon /
  toggle / split buttons, cards, lists, switches, dropdowns, sliders, nav bar /
  rail / drawer, text fields, search, checkboxes, radios, chips, FABs / FAB
  menu, segmented buttons, tabs, menus, expandable headers, and more).
* Example **Focus rings** playground (View tab).
* List-owned **selection** and **reorder** on `M3ECardList` /
  `M3ECardList.builder` (`selection`, `reorder`, `selectionController`,
  `onSelectionChanged`, `onReorder`, `selectionState`, `reorderState`),
  **selection** and **reorder** on dismissible lists, and **selection** /
  **reorder** on expandable header rows (nested sublists keep their own list
  APIs; expanded rows snap-collapse for reorder). Theme tokens:
  `M3EListSelectionState`, `M3EListReorderState`, enums
  `M3EListSelectionMode` / `M3EListSelectionTrigger`.
* Dismissible **swipe actions** via `leadingActionsBuilder` /
  `trailingActionsBuilder` and `M3EListSwipeAction` (icon pills, preview snap,
  primary auto-execute). Style tokens on `M3EDismissibleListStyle` /
  `M3EListDismissibleTheme` (spacing, edge padding, preview threshold,
  overdrag, min sizes).
* Expandable nested expansions via `M3EExpandableExpanded.list` /
  `.content` on `M3EExpandableData.expanded`; `embedded` on card /
  dismissible lists for inner corner radii when nested.
* `M3EDropdownMenu.limit` (`int?`, default `null` = unlimited) to cap
  multi-select count (`limit` takes precedence over `maxSelections` when set).
* Configurable spatial springs on component themes (defaults match prior
  hard-coded motion), including switch position/size, FAB menu expand/shape,
  nav rail indicator/icon scale, checkbox pulse, slider dock, icon button
  morph, toolbar expand/label, list card `radiusSpring`, dismissible
  neighbour / re-engage / detach / roundness / spring-back / fly /
  `collapseDamping`, and refresh `settleSpring`.
* Export `M3EOverflowStrategy`, `M3ENoOverflowStrategy`, and
  `M3EScrollOverflowStrategy` for `M3EButtonGroup.overflowStrategy`.

### Changed

* Bump `material_ui` to `^1.1.1`.
* `M3EDropdownMenu.openMotion` / `closeMotion` are nullable; when null they
  resolve from `M3EDropdownMenuTheme.openSpring` / `closeSpring`.
* Dropdown field selected-value text defaults to `bodyMedium` (was
  `bodyLarge`); chip delete icon size follows the chip label font size.
* Prefer `M3EThemeData.focusRingTheme` for package-wide focus ring overrides;
  legacy `M3EButtonTheme.focusRingWidth` / `focusRingGap` / `focusRingColor`
  remain for compatibility.
* Button-family focus clearance uses `focusRingTheme` /
  `M3EFocusRing.outsetOf` instead of hardcoded primary constants.
* Icon buttons and navigation rail destinations use
  `SystemMouseCursors.click` when enabled.

### Fixed

* Focus interaction: primary-focused control only; rings clear on pointer and
  resume on keyboard; pointer down requests focus so Tab continues from the
  last clicked control; menus/dropdowns trap Tab; Escape closes overlays /
  unfocuses fields; keyboard focus scrolls into view when rings are allowed.
* Expandable list: Tab traverses expanded sublist rows after the header;
  collapsed / mid-animation bodies stay out of the focus order.
* `M3EFocusRing` keeps a stable tree when toggling `focused` so `EditableText`
  is not remounted (Tab-focus text fields stay editable).
* Search bar keeps the editing row mounted under idle chrome; `M3ESearchAnchor.bar`
  participates in Tab with Enter/Space to open and Escape to close.
* FAB menu focus scope skips as a Tab stop, focuses the first item on open,
  and closed-loops Tab across items; FAB menu no longer depends on inherited
  theme during `initState` for item springs.
* Web: `ButtonActivateIntent` support on `M3ETappable` and navigation
  destinations (Enter activation).
* Date picker: mode-toggle / month labels ellipsize under narrow width;
  dialog actions use `OverflowBar` so cancel/confirm wrap instead of overflow.
* `M3EStateLayerOverlay` InkWell no longer steals a second tab stop under
  `M3ETappable`.
* Dropdown selected chips and trailing clear are keyboard Tab stops with focus
  rings.

## 1.1.1

### Added

* M3-aligned typography foundation: `M3ETypography` pairs 15 baseline and 15
  emphasized type scales (`md.sys.typescale.*` and `.emphasized.*`), token
  tables for static and variable-font sets, `M3ETypefaceConfig` (brand/plain
  families), and `M3EVariableFontConfig` for per-role `opsz`, `wght`, split
  `ROND`, and emphasized-only `GRAD`. `M3EThemeData.typography` is the source
  of truth; `typeScale` remains a baseline alias for components.
* `M3EVariableFontAxes` for explicit `wght`, `opsz`, `ROND`, `wdth`, `slnt`,
  `GRAD`, and advanced Y-axis values with global/brand/body group overrides
  on `M3EVariableFontConfig`.
* `M3ETypeStyleConversion` converts arbitrary `TextStyle`s to baseline,
  emphasized, or variable token variants; `M3ETypeStyleTokens.copyWith` and
  `fromTextStyle` customize individual token fields.
* `M3ETypeVariations.graded` alias clarifies the weight+grade axis preset vs
  the M3 emphasized type scale. `M3EMaterialApp` accepts `typeScaleMode`,
  `typeface`, and `variableFont`.
* Example **Typography** playground (View tab) with live axis and conversion
  controls.
* Export `buildM3EThemeDefaults()` and `M3EDynamicColorHost` through
  `foundations.dart`.
* `M3EHourMinuteTextField` for Material-aligned hour/minute time inputs
  (used by the input time picker; exported from the time pickers entry).
* `M3ENavigationBar` wide layout APIs: `autoLayout`, `layout`
  (`M3ENavBarLayout`), `alignment` (`M3ENavBarAlignment`), `iconBehavior`
  (`M3ENavBarIconBehavior`), optional `wideBreakpoint` and
  `wideDestinationWidth`, plus `M3ENavBarConstants` (default chip width `128`,
  documented 5-destination breakpoint, `minWideBarWidth`). Destinations may be
  icon-only and/or label-only. Wide chips use a fixed width so the fluid pill
  does not clip when icons or labels appear or disappear.
* `M3ENavigationRail` `expandTooltip` / `collapseTooltip` for the
  expand/collapse toggle (defaults `'Expand'` / `'Collapse'`).
* `M3EFab` and `M3EExtendedFab` optional `elevation` / `hoverElevation`
  overrides; `M3ENavigationRailFabSlot` forwards them to the rail FAB.

### Changed

* Typography additions are additive; `M3EThemeData.typeScale` remains a
  baseline alias for components.
* Foundations sources grouped under `lib/foundations/{color,shape,theme,type,interaction,tokens}/`;
  the public barrel path is unchanged for consumers.
* Date and time pickers aligned closer to Material dialog specs: landscape
  dialog sizing (12/24-hour), standardized content padding, unified action
  bars, calendar/year responsive layouts (year mode toggle stacked in the
  calendar parent), dial help-text layout, and input-time fields with labels
  under the boxes and AM/PM top-aligned with the hour/minute row.
* `M3EYearPicker` no longer takes `mode` / `onModeChanged` — the mode header
  lives on the parent calendar. Call sites that passed those arguments should
  drop them (the built-in `M3ECalendarDatePicker` already hosts the toggle).
* `M3ENavBarConstants.wideBreakpoint` default is sized for five fixed-width
  wide chips (`704` at the default `128` chip width) instead of a flat `600`.
  When `wideBreakpoint` is omitted on the bar, autoLayout uses
  `minWideBarWidth` for the current destination count and chip width.
* README: document `M3ENavigationBar` wide-layout public surface and samples.

### Fixed

* Date picker landscape/year layouts: year grid overflow and vertical stretch,
  header alignment with calendar and actions, help text compact only in input
  entry mode (`alignHelpWithSubHeader`).
* Time picker landscape dial: help text no longer covered by hour/minute
  fields; input mode field geometry matches filled Material time inputs.
* Complete public surface exports from all component entry files so
  `import 'package:material_3_expressive/material_3_expressive.dart'` is
  sufficient: missing themes/decorations (app bar, FAB, navigation drawer,
  icon button shapes, button motion/overflow, split button decorations),
  tokens/utils (slider, toolbar, carousel scroll helper, progress indicator,
  navigation rail layout), dismissible list extension APIs, picker composables
  (date/time form fields, headers, actions), carousel view/controller/wrapper,
  toolbar building blocks, and button-group overflow controller.
* Export missing public enums and models from component entry files so the
  barrel alone is enough: button style/size/shape, FAB color/size, split
  button enums, navigation bar / rail enums and models, and
  `M3EButtonGroupAction` from the toggle button group entry.
* `M3EDropdownMenu`: do not fire `onSelectionChange` during
  `didUpdateWidget` rebuilds when the selection did not actually change
  (lifecycle / build-phase safe).

### Chore

* Remove redundant deep imports in library, example, and tests now covered by
  entry / barrel exports (`unnecessary_import` / analyzer cleanup).

## 1.1.0

### Documentation

* README: document current public APIs for `M3ERefreshIndicator` (controller,
  pad/reveal, elevation, contained spinner), `M3ELoadingIndicator`
  (`elevation`, `rotationTurns`, colors), `M3ECheckbox` label/sizing options,
  `M3EProgressIndicator` stroke overrides, and `dynamic_color` 2.x /
  `material_ui` `^1.1.0` harmonization notes.

### Fixed

* Compatible with `dynamic_color` 2.x (`material_ui`): drop duplicate
  `ColorScheme.harmonized` extension; re-export package harmonization; tests use
  local channel mocks (`test_utils` moved to `dynamic_color_testing`).
* Nav bar, rail, and drawer selection pills remasure on size / constraint
  changes (window resize); stale geometry cache no longer blocks morphs to
  other destinations.
* `M3ERefreshIndicator` pointer-pull platforms (Flutter web and native
  desktop): mouse drag, 1:1 pointer deltas, host reveal/arm math
  (`2 × indicatorPadding` delay, arm at full reveal), list pad hard-capped at
  `contentDragOffset` with safe leading underscroll clamp. Web also uses
  Opacity+scale reveal, split rebuilds, and `RepaintBoundary` so CanvasKit
  does not freeze. Mobile keeps classic overscroll deltas.
* `M3ERefreshIndicator` expressive and contained kinds always use
  `M3ELoadingIndicator` **contained** variant so shell elevation works on all
  platforms (avoids morph-path `drawShadow`, which freezes CanvasKit).
* `M3ERefreshIndicatorController` attach/detach uses one stable show closure
  (fresh method tear-offs are never `identical`), so dispose clears correctly
  and manual `show()` does not hit disposed animation controllers after keyed
  rebuilds; keyed variant switches still keep the newer attachment.

## 1.0.9

### Added

* `M3ESafeArea` — keyboard-aware system insets from raw view metrics
  (`paddingOf`, `topOf` / `bottomOf` / `leftOf` / `rightOf`, and
  `overlayBottomOf` for floating overlays). Docked chrome, snackbar, search,
  nav rail indicator, and dialog inset hosts use it instead of
  `MediaQuery.viewPaddingOf`.
* `M3EDialogInset` — pads dialogs with screen margin and optional keyboard
  view insets (Material Dialog behavior).
* `M3EDialogTheme.resizeToAvoidBottomInset` (default true),
  `insetAnimationDuration`, and `insetAnimationCurve`.
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
* `M3ERefreshIndicatorTheme.releaseBubbleSpring` /
  `releaseBubbleFromScale` (and matching widget overrides) for the release
  scale bubble (defaults stiffness 350 / damping 0.1 / from-scale 0.96).
* `M3ELoadingIndicator.elevation` (theme default `0`) — contained uses
  rounded-shell [M3EElevation] shadows; uncontained casts a path shadow that
  follows the morphing polygon (including rotate / scale / morph).
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
* `M3ECard` outlined variant defaults to a transparent fill (border only);
  list surfaces that use `M3ECard` inherit this unless an explicit color is set.
* Time dial minutes: drag selects any 0–59; tap snaps to nearest ×5; interstitial
  selector dot when between labels (Material `_Dial` behavior).
* Time AM/PM control uses Material portrait / landscape / input sizes and sits
  beside dial/input hour–minute fields (not a button row below input).
* Date range input fields are side-by-side (8dp gap), matching Material.
* Date, date-range, and time picker entry-mode toggles sit at the bottom-left
  of the dialog actions row (Material time-picker placement).
* Date and time entry-mode icons use `keyboard_outlined` (calendar/clock when
  returning from input).
* Time picker manual entry no longer autofocuses the hour field.
* `M3EDialogInset` + `M3EDialogTheme.resizeToAvoidBottomInset` (default true)
  shift dialogs above the keyboard; opt out via theme or
  `resizeToAvoidBottomInset: false` on `M3EDialog.show` / date / time pickers.

### Changed

* Internal `klin_dart` compliance: split `M3EInputTimePickerFormField` build
  helpers to clear cognitive complexity (no behavior change).
* `M3EExpressiveLoadingIndicator` applies a noticeable scale pulse (spatial
  spring) to the active polygon holder on each morph — not the outer
  container. Morph rotation defaults are slower (45° / cycle, slower spring);
  timing and springs are configurable via widget params and
  `M3ELoadingIndicatorTheme`.
* `M3ERefreshIndicator` default `displacement` is 8 (top padding). List pad
  defaults to spinner height + 16. Scale/fade/downward reveal lags until pad
  reaches `2 × indicatorPadding`, then fills through full visibility.
  `onRefresh` runs only when fully revealed and the pointer is released.
* `M3ETimePickerTheme` period sizes align with Material (`periodPortraitSize`
  52×80, `periodLandscapeSize` 216×38, `periodInputSize` 52×72).
* Vendor/source attribution headers removed from `lib/` Dart sources;
  third-party notices remain in `NOTICE` only.

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
