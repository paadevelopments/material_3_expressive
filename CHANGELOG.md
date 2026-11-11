## 1.2.1

### Changed

* Raise `material_ui` to `^1.11.0`.

### Fixed

* **Lists:** swiping an expandable `M3EListItem` that has `swipe` no longer
  throws a `DragUpdateDetails` assertion when the drag is not perfectly
  horizontal
  ([#41](https://github.com/paadevelopments/material_3_expressive/issues/41),
  thanks @Stefichen5).
* **Search:** a read-only `M3ESearchBar` (such as `M3ESearchAnchor.bar`) calls
  `onTap` once per tap instead of twice
  ([#42](https://github.com/paadevelopments/material_3_expressive/issues/42),
  thanks @saicharanrajana).

## 1.2.0

* Raise `material_ui` to `^1.8.0`. **Breaking:** it exports its own `RoundedPolygon` and `CornerRounding`, which clash with the ones re-exported from `material_new_shapes`; add `hide CornerRounding, RoundedPolygon` to the `material_ui` import.
* **Button group, segmented buttons:** no autofocus on mount; set `autofocus` on an action to focus it ([#35](https://github.com/paadevelopments/material_3_expressive/pull/35), thanks @StillMisty).
* **Search:** view field focuses as the view starts opening ([#35](https://github.com/paadevelopments/material_3_expressive/pull/35), thanks @StillMisty).
* **Buttons:** icon-only and label-only `M3EButton` render their content ([#34](https://github.com/paadevelopments/material_3_expressive/pull/34), thanks @StillMisty).
* **Button group:** overflow menu titles icon-only actions from `semanticLabel`/`tooltip`; focus-ring gaps no longer shift layout on tap ([#34](https://github.com/paadevelopments/material_3_expressive/pull/34), [#38](https://github.com/paadevelopments/material_3_expressive/pull/38)).
* **Date pickers:** `M3EInputDatePickerFormField` honors `autofocus` ([#37](https://github.com/paadevelopments/material_3_expressive/pull/37), thanks @StillMisty).
* **Theme:** correct iOS `statusBarBrightness` in `M3EMaterialApp` and `M3EScrimSystemUi` ([#40](https://github.com/paadevelopments/material_3_expressive/pull/40)).
* **Example:** iOS runner targets iOS 15.0.

## 1.1.7

* Raise `material_ui` to `^1.7.0`.
* **Bottom sheets, side sheets:** predictive back works with an `onDismissRequest` guard and no longer resets content state ([#31](https://github.com/paadevelopments/material_3_expressive/pull/31), [#32](https://github.com/paadevelopments/material_3_expressive/pull/32), thanks @StillMisty).
* **Chips:** long labels truncate with an ellipsis in bounded layouts ([#30](https://github.com/paadevelopments/material_3_expressive/pull/30), thanks @StillMisty).
