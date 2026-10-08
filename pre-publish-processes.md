# Pre-publish processes

Run these steps across the whole package before publishing. Fix the issues
they find in source as described in step 6. Do not suppress anything, and do
not change any logical behavior.

Do only the steps listed in this file and nothing else. Do not publish the
package, do not run any git commands (commit, push, tag, branch or similar),
and do not take any other action that is not listed here.

Use the FVM Flutter SDK at `.fvm/flutter_sdk`.

## Before you start

Always ask the user first whether to include step 1 (dead code check). If
they say no, skip step 1 and start at step 2.

## 1. Dead code check (only if the user asked for it)

Check all of `lib/` for dead code:

- Files that no other file imports, exports or uses as a `part`.
- Public or private declarations (classes, enums, mixins, extensions and their
  members, typedefs, functions, constants) that nothing references.

Do not remove anything in this step. Report every finding to the user: what
it is, where it is, and whether it is public API. Anything reachable from
`lib/material_3_expressive.dart` is public API, and removing it is a breaking
change.

Then ask the user which findings, if any, to remove. Remove only the ones they
approve, and only after they approve them.

## 2. Barrel export check

Check that every public composable object is exported through the right
barrels:

- Each component exposes its public symbols through its entry file
  `lib/components/<component>/m3e_<component>.dart`.
- Each foundations symbol goes through `lib/foundations/foundations.dart`.
- `lib/material_3_expressive.dart` exports every component entry file and the
  foundations barrel.
- No public signature (constructor, parameter, field, return type) uses a type
  that is not exported.
- Every `M3E*` type used in `README.md` or `example/lib/` is reachable from
  `lib/material_3_expressive.dart`.

## 3. Format

```bash
.fvm/flutter_sdk/bin/dart format lib test example/lib
```

## 4. Flutter analysis

Run in the root and in `example/`:

```bash
.fvm/flutter_sdk/bin/flutter analyze
```

```bash
cd example && ../.fvm/flutter_sdk/bin/flutter analyze
```

## 5. Custom analysis

Run from the root. FVM's `dart` must be on `PATH`:

```bash
PATH="$PWD/.fvm/flutter_sdk/bin:$PATH" dart run custom_lint
```

## 6. Fix issues

Fix every issue from steps 2 to 5 in source. Dead code from step 1 is removed
only as the user approved in that step.

- Do not add `// ignore` comments or `analysis_options` suppressions.
- Do not change any logical behavior.
- Re-run steps 3 to 5 until they all report no issues.
