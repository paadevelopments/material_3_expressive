## 1.2.3

### Changed

* Raise `material_ui` to `^1.11.1`.

### Fixed

* **Icon buttons:** semantics report the enabled state, and report selection
  only for toggle buttons, so a plain icon button is no longer announced as
  "not selected"
  ([#51](https://github.com/paadevelopments/material_3_expressive/pull/51), thanks @KuljeetSinghXDA).
* **Search:** suggestions from an older query that resolve after a newer
  keystroke are dropped instead of replacing the newer list
  ([#50](https://github.com/paadevelopments/material_3_expressive/pull/50), thanks @KuljeetSinghXDA).
* **Text fields:** `M3ETextField` follows a new `controller` or `focusNode`
  given at runtime instead of keeping the first one
  ([#49](https://github.com/paadevelopments/material_3_expressive/pull/49), thanks @KuljeetSinghXDA).
* **Sliders:** discrete `M3ERangeSlider` thumbs stay inside `min`/`max` and
  no longer snap past each other
  ([#48](https://github.com/paadevelopments/material_3_expressive/pull/48), thanks @KuljeetSinghXDA).
* **Tabs:** fixed tab labels too long for their slot truncate with an
  ellipsis instead of overflowing
  ([#47](https://github.com/paadevelopments/material_3_expressive/pull/47), thanks @KuljeetSinghXDA).
* **Text fields:** removing a passed-in `controller` keeps its text,
  selection and composing region, and the field's own focus node lives until
  it is disposed instead of being replaced on each `focusNode` swap.
* **Tabs:** a primary tab with an icon keeps its label to one line, so a
  long label no longer overflows the 64 dp bar.

## 1.2.2

* **FAB menu:** new `closeOnItemTap` (default `true`); an item with an `openBuilder` keeps the menu open so its transform returns to it ([#43](https://github.com/paadevelopments/material_3_expressive/issues/43), thanks @allasca).
* **Cards:** `M3ECardContainerTransform.show` takes an optional `originBoundary` that cross-fades with the container.
* **Container transforms:** the origin's content cross-fades out and back in instead of landing as a blank shape, the origin hides while open, and the destination is built once ([#43](https://github.com/paadevelopments/material_3_expressive/issues/43)).
* **FAB, extended FAB:** closing transform lands with the resting shadow and icon position.
* **Carousel:** an item's transform opens on tap; closing transform no longer shows a stale hover highlight.
* **Menus, split buttons:** popups inside a nested `Navigator` anchor to their trigger ([#44](https://github.com/paadevelopments/material_3_expressive/pull/44), thanks @StillMisty).
* **Dropdown menus:** long selection chip labels truncate with an ellipsis ([#45](https://github.com/paadevelopments/material_3_expressive/pull/45), thanks @SafalFrom2050).

## 1.2.1

* Raise `material_ui` to `^1.11.0`.
* **Lists:** swiping an expandable `M3EListItem` no longer throws a `DragUpdateDetails` assertion on non-horizontal drags ([#41](https://github.com/paadevelopments/material_3_expressive/issues/41), thanks @Stefichen5).
* **Search:** read-only `M3ESearchBar` calls `onTap` once per tap ([#42](https://github.com/paadevelopments/material_3_expressive/issues/42), thanks @saicharanrajana).
