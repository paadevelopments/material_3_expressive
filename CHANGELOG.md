## 1.2.2

### Fixed

* **Menus, split buttons:** popups opened inside a nested `Navigator` (such as
  a page modal or modal sheet) now anchor to their trigger instead of opening
  offset from it; the anchor is measured against the root overlay that hosts
  the popup
  ([#44](https://github.com/paadevelopments/material_3_expressive/pull/44),
  thanks @StillMisty).
* **Dropdown menus:** long selection chip labels truncate with an ellipsis
  instead of overflowing
  ([#45](https://github.com/paadevelopments/material_3_expressive/pull/45),
  thanks @SafalFrom2050).

## 1.2.1

* Raise `material_ui` to `^1.11.0`.
* **Lists:** swiping an expandable `M3EListItem` no longer throws a `DragUpdateDetails` assertion on non-horizontal drags ([#41](https://github.com/paadevelopments/material_3_expressive/issues/41), thanks @Stefichen5).
* **Search:** read-only `M3ESearchBar` calls `onTap` once per tap ([#42](https://github.com/paadevelopments/material_3_expressive/issues/42), thanks @saicharanrajana).

## 1.2.0

* Raise `material_ui` to `^1.8.0`. **Breaking:** it exports its own `RoundedPolygon` and `CornerRounding`, which clash with the ones re-exported from `material_new_shapes`; add `hide CornerRounding, RoundedPolygon` to the `material_ui` import.
* **Button group, segmented buttons:** no autofocus on mount; set `autofocus` on an action to focus it ([#35](https://github.com/paadevelopments/material_3_expressive/pull/35), thanks @StillMisty).
* **Search:** view field focuses as the view starts opening ([#35](https://github.com/paadevelopments/material_3_expressive/pull/35), thanks @StillMisty).
* **Buttons:** icon-only and label-only `M3EButton` render their content ([#34](https://github.com/paadevelopments/material_3_expressive/pull/34), thanks @StillMisty).
* **Button group:** overflow menu titles icon-only actions from `semanticLabel`/`tooltip`; focus-ring gaps no longer shift layout on tap ([#34](https://github.com/paadevelopments/material_3_expressive/pull/34), [#38](https://github.com/paadevelopments/material_3_expressive/pull/38)).
* **Date pickers:** `M3EInputDatePickerFormField` honors `autofocus` ([#37](https://github.com/paadevelopments/material_3_expressive/pull/37), thanks @StillMisty).
* **Theme:** correct iOS `statusBarBrightness` in `M3EMaterialApp` and `M3EScrimSystemUi` ([#40](https://github.com/paadevelopments/material_3_expressive/pull/40)).
* **Example:** iOS runner targets iOS 15.0.
