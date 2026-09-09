# Long-term support policy

DaVinci 1.4 remains the stable long-term-support line. 2.0 is in pre-release and is
not yet an LTS line; its public API is source-breaking against 1.4, so adopting it
is a migration rather than an upgrade. See [Migration-2.0](Migration-2.0.md).

## Supported lines

| Version | Status | Scope |
|---|---|---|
| 2.0.0-alpha | Pre-release | The 2.0 API surface, pinnable but not yet covered by the stability contract below |
| 1.4.x | LTS | Compatibility-preserving correctness, security, accessibility, documentation, and supported-toolchain fixes |
| 1.3.x and earlier | Unsupported | Upgrade to the latest 1.4 patch release |

The 1.4 line remains supported until an end-of-support date is explicitly
announced in this document and the README. No end-of-support date is currently set;
in particular, the 2.0 pre-release does not end support for 1.4.

## Stability contract

- Patch releases in 1.4.x do not remove public APIs or introduce source-breaking
  signature and behavior changes.
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

## The 2.0 pre-release

`2.0.0-alpha.1` carries the complete 2.0 public API and can be pinned exactly, but
the stability contract above does not apply to it:

- Pre-release versions may change API between alphas if a defect requires it.
- The remaining work before 2.0.0 is coverage and documentation, not API changes.
- Pin it with `exact:` rather than a range, so a later alpha cannot be resolved
  into a build without an explicit decision.
