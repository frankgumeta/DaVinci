# Long-term support policy

DaVinci 2.0 is the stable line and 1.4 remains the long-term-support branch. The
2.0 API is source-breaking against 1.4, so adopting it is a migration rather than
an upgrade. See [Migration-2.0](Migration-2.0.md).

## Supported lines

| Version | Status | Scope |
|---|---|---|
| 2.0.x | Stable | Compatibility-preserving correctness, security, accessibility, and documentation fixes |
| 1.4.x | LTS | Compatibility-preserving correctness, security, accessibility, documentation, and supported-toolchain fixes |
| 1.3.x and earlier | Unsupported | Upgrade to the latest 1.4 patch release |

The 1.4 line remains supported until an end-of-support date is explicitly
announced in this document and the README. No end-of-support date is currently set.

## Stability contract

- Patch releases in 1.4.x do not remove public APIs or introduce source-breaking
  signature and behavior changes.
- Patch releases in 2.0.x accept compatible correctness, security, accessibility,
  and documentation fixes; new compatible APIs belong in 2.1 and source-breaking
  changes wait for 3.0.
- Security and correctness fixes are prioritized over expanding the component
  catalog.
- New opt-in APIs belong in a later minor version and must preserve the 1.4 public
  surface.
- Support for iOS 17, Xcode 26.6, Swift tools 6.3, and Swift 6 language mode is not
  dropped within 1.4.x.
- Every patch release runs the current-runtime suite, the minimum-runtime
  compatibility suite, public API comparison, documentation checks, coverage
  enforcement, and DocC. Pixel snapshots and time-based performance baselines
  remain pinned to the current CI runtime.

Active development has moved beyond 1.4, so maintenance fixes for the LTS line are
based on a dedicated `release/1.4.x` branch and merged back into the development
line rather than being cut from it.

The 2.0 development line uses Xcode 27.0, Swift tools 6.4, and Swift 6 language
mode while retaining iOS 17 as its deployment target. That toolchain change does
not alter the published 1.4.x compatibility contract above.

## The 2.0 stable line

The `2.0.0` release is the supported stable API line. The 1.4.x LTS branch remains
available for consumers that cannot yet complete the migration.
