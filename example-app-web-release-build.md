# Example app web release build

Runbook for building the Material 3 Expressive gallery web demo into [`docs/`](docs/) and restoring the patched [`docs/index.html`](docs/index.html) (splash screen + CanvasKit loader).

## Agent instructions

**When the user says any of the following, read and follow this file end-to-end:**

- Run `example-app-web-release-build.md`
- Build the web release
- Update the docs web demo
- Rebuild the GitHub Pages demo
- Publish / refresh the live web demo

Do **not** skip post-build steps. Follow [AGENTS.md](AGENTS.md): use FVM Flutter at [`.fvm/flutter_sdk/bin/flutter`](.fvm/flutter_sdk/bin/flutter), run `dart analyze` after changes, and do **not** commit or push unless the user explicitly asks.

## Context

| Item | Value |
|------|-------|
| Live demo | https://paadevelopments.github.io/material_3_expressive/ |
| Site root | [`docs/`](docs/) (GitHub Pages) |
| Base href | `/material_3_expressive/` |
| Flutter SDK | `3.44.0` via FVM ([`.fvmrc`](.fvmrc)) |

`flutter build web` writes a fresh [`docs/index.html`](docs/index.html) from [`example/web/index.html`](example/web/index.html) using `flutter_bootstrap.js`. That default loader caused blank-page hangs on iOS Safari. The patched index instead uses `flutter.js` + `loadEntrypoint` with `renderer: "canvaskit"`, plus an inline splash screen. Splash and loader customizations live **only** in docs — not in the example app.

**Golden template:** [`docs/index.web-release.html`](docs/index.web-release.html) is the source of truth for the patched index. After each build, copy it over `docs/index.html`.

## Prerequisites

- Shell at the **repository root** (`material_3_expressive/`).
- FVM Flutter available at `.fvm/flutter_sdk/bin/flutter`.
- Expect the build to **overwrite most of** [`docs/`](docs/) (compiled JS, assets, service worker, etc.). Files Flutter does not emit (e.g. [`.nojekyll`](docs/.nojekyll), `index.web-release.html`) are preserved.

## Step A — Preserve patched index (before build)

### Primary (preferred)

If [`docs/index.web-release.html`](docs/index.web-release.html) exists, no backup is needed — use it in Step C.

### Fallback (template missing)

Back up the current patched index **before** building:

```bash
# Create or refresh the golden template from the live patched index
cp docs/index.html docs/index.web-release.html
```

One-off backup only (without updating the template):

```bash
cp docs/index.html /tmp/m3e-index-patched-backup.html
```

When splash or bootstrap logic changes, **edit `docs/index.web-release.html` first**, then run the full pipeline so future builds stay in sync.

## Step B — Build

From the repository root:

```bash
cd example
../.fvm/flutter_sdk/bin/flutter build web \
  --release \
  --base-href /material_3_expressive/ \
  --output ../docs
cd ..
```

| Flag | Purpose |
|------|---------|
| `--release` | Production bundle |
| `--base-href /material_3_expressive/` | GitHub Pages project-site path (leading and trailing `/` required) |
| `--output ../docs` | Write the site into [`docs/`](docs/) |

## Step C — Post-build restore `index.html`

### Primary

```bash
cp docs/index.web-release.html docs/index.html
```

### Fallback

If the template was missing before Step B and you only made a one-off backup:

```bash
cp /tmp/m3e-index-patched-backup.html docs/index.html
```

Or, if you created the template in Step A fallback:

```bash
cp docs/index.web-release.html docs/index.html
```

### Confirm patched content

[`docs/index.html`](docs/index.html) must contain:

- `#m3e-splash` splash markup and inline CSS
- `hideM3eSplash()` in the inline bootstrap script
- `<script src="flutter.js" defer></script>` as the loader (not `flutter_bootstrap.js` alone)
- `initializeEngine({ renderer: 'canvaskit' })`

## Step D — GitHub Pages extras

Ensure Jekyll does not process the folder:

```bash
test -f docs/.nojekyll || touch docs/.nojekyll
```

## Step E — Verification

Run from the repository root:

```bash
# Patched loader + splash present
rg -q "hideM3eSplash" docs/index.html
rg -q "renderer: 'canvaskit'" docs/index.html
rg -q 'src="flutter.js"' docs/index.html

# Loader should not rely on flutter_bootstrap.js alone
if rg -q 'src="flutter_bootstrap.js"' docs/index.html; then
  echo "WARN: flutter_bootstrap.js still referenced in index.html"
fi

# GitHub Pages marker
test -f docs/.nojekyll

# Project static analysis
.fvm/flutter_sdk/bin/dart analyze
```

### Manual smoke test

1. Open https://paadevelopments.github.io/material_3_expressive/ (or serve `docs/` locally under that base path).
2. Hard refresh with cache disabled.
3. Splash appears immediately (title, shapes, loader) and fades when the gallery loads.
4. Toggle system light/dark mode — splash colors adapt.

## Maintenance

- **Splash / bootstrap changes:** edit [`docs/index.web-release.html`](docs/index.web-release.html), copy to [`docs/index.html`](docs/index.html), then commit both with the rest of the `docs/` build output when asked.
- **Do not** add splash logic to [`example/web/index.html`](example/web/index.html) — the next build + patch workflow would drop it unless duplicated in the template.
- **Commits / pushes:** only when the user explicitly requests them.

## One-liner (full pipeline)

From the repository root, when `docs/index.web-release.html` already exists:

```bash
cd example && ../.fvm/flutter_sdk/bin/flutter build web --release --base-href /material_3_expressive/ --output ../docs && cd .. && cp docs/index.web-release.html docs/index.html && (test -f docs/.nojekyll || touch docs/.nojekyll)
```

Then run the Step E verification commands above.
