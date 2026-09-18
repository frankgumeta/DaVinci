# Migrating from 1.4 to 2.0

DaVinci 2.0 is a major release with source-breaking changes. It does **not** ship
deprecated aliases for the removed APIs: a 1.4 call site that uses `title` will
fail to compile against 2.0 rather than silently changing appearance. That is
deliberate — a typography change that compiles but renders differently is harder
to find than one the compiler points at.

This guide covers every breaking change and the exact replacement for each.

## Toolchain requirement

DaVinci 2.0 requires Xcode 27.0 and Swift tools 6.4 while retaining Swift 6
language mode and an iOS 17 deployment target. Update the development and CI
toolchains before resolving 2.0; adopting Xcode 27 does not require raising an
application's deployment target to iOS 27.

## At a glance

| 1.4 | 2.0 | Notes |
|---|---|---|
| `DSText.Role.title` | `DSText.Role.titleMedium` | Identical metrics, different Dynamic Type scaling — see below |
| `theme.typography.title` | `theme.typography.titleMedium` | Same |
| `DSButton` label typography | `typography.labelLarge` | Now applied automatically; smaller and lighter than before |
| `DSPressableButtonStyle` (internal) | `DSPressableButtonStyle` (public) | Now usable from app code |

## 1. The `title` role was replaced by a three-step scale

1.4 had a single title step. 2.0 splits it into three, so a screen can express
title hierarchy without falling back to `display` or `headline`:

| Role | Size / line height | Weight | `relativeTo` |
|---|---|---|---|
| `titleLarge` | 28 / 34 | bold | `.title` |
| `titleMedium` | 24 / 30 | bold | `.title2` |
| `titleSmall` | 20 / 26 | bold | `.title3` |

**`titleMedium` is the canonical destination for `title`.** It carries the same
24pt size, 30pt line height and bold weight, so layout is unchanged at the default
Dynamic Type size:

```swift
// 1.4
DSText("Settings", role: .title)
Text("Settings").dsTextStyle(theme.typography.title, family: theme.typography.family)

// 2.0
DSText("Settings", role: .titleMedium)
Text("Settings").dsTextStyle(theme.typography.titleMedium, family: theme.typography.family)
```

### The one behavioural difference: Dynamic Type scaling

This is the part a mechanical find-and-replace will miss. The removed `title`
scaled relative to SwiftUI's `.title` text style; `titleMedium` scales relative to
`.title2`.

At the default size the two are indistinguishable — same rendered pixels. They
diverge as the user raises Dynamic Type: `.title2` grows more slowly than
`.title`, so at accessibility sizes `titleMedium` renders somewhat smaller than
1.4's `title` did.

This was a deliberate choice. The new scale is internally consistent — `.title`,
`.title2` and `.title3` map to `titleLarge`, `titleMedium` and `titleSmall`
respectively — and that consistency matters more than preserving the old curve for
one step.

**If your app depends on the 1.4 scaling curve,** override the token rather than
picking a different role, so size and weight stay correct:

```swift
DSTypography(
    titleMedium: DSTextStyle(size: 24, lineHeight: 30, weight: .bold, relativeTo: .title)
)
```

Verify the result at accessibility sizes before deciding: for most layouts the
slower growth of `.title2` is an improvement, because a 24pt title scaling on the
`.title` curve is a frequent source of truncation on small devices.

## 2. `DSButton` labels use the label family

1.4 painted button labels with `typography.headline` (20/26, bold). 2.0 uses
`typography.labelLarge` (16/20, medium) at both `regular` and `compact` sizes.

Buttons will render with visibly smaller, lighter text. Nothing to change at the
call site, but **it will alter your layouts**, and any snapshot test covering a
button needs re-recording. Control text is now a distinct typographic family
(`labelLarge` / `labelMedium` / `labelSmall`) rather than borrowed heading styles.

To keep the 1.4 appearance, override the token:

```swift
DSTypography(labelLarge: DSTextStyle(size: 20, lineHeight: 26, weight: .semibold, relativeTo: .headline))
```

Note this affects every control using `labelLarge`, not only buttons.

## 3. New roles you may already have hand-rolled

If you defined local styles for these, replace them with the tokens:

- `subheadline` (15/20, regular) — secondary header supporting a `headline`
- `footnote` (13/18, regular) — disclaimers and ancillary text
- `labelMedium` (14/18, medium), `labelSmall` (12/16, medium) — control text

## 4. `DSCard` corners are continuous

Card corners now use continuous curvature (the "squircle" shape used throughout
iOS) instead of circular corners. No API change; snapshots covering cards need
re-recording.

## 5. Numeric text can hold its column width

`DSDigitStyle` adds `monospaced` digits without changing the font family, for
timers, prices and any figure that must not shift as it updates:

```swift
Text(elapsed)
    .dsTextStyle(theme.typography.body.monospacedDigits(), family: theme.typography.family)
```

## 6. `AttributedString` in `DSText`

`DSText` accepts an `AttributedString` and preserves its inline attributes rather
than flattening them into the role's baseline style:

```swift
var text = AttributedString("Read the terms and conditions")
if let range = text.range(of: "terms and conditions") {
    text[range].link = URL(string: "https://example.com/terms")
}
DSText(text, role: .body)
```

## Checklist

1. Replace `role: .title` with `role: .titleMedium`, and `typography.title` with
   `typography.titleMedium`.
2. Decide whether you need the 1.4 Dynamic Type curve. Check your titles at
   accessibility sizes; override `titleMedium` only if the new curve hurts.
3. Re-record snapshots covering buttons and cards.
4. Review button-adjacent layouts for the smaller label typography.
5. Replace hand-rolled subheadline, footnote and control-label styles with the
   new tokens.
6. Update local and CI environments to Xcode 27.0 and Swift tools 6.4.

## Pinning the pre-release

`2.0.0-alpha.1` carries the full 2.0 public API. The local release gates now cover
previews, gallery screens, snapshots, list performance baselines, accessibility
tests, DocC, API drift, and the iOS 17.5 compatibility lane. Publication still
depends on the release checklist and an approved tag. Pin the alpha exactly:

```swift
.package(url: "https://github.com/frankgumeta/DaVinci.git", exact: "2.0.0-alpha.1")
```
