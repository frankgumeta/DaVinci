# Long-term support policy

DaVinci 1.4 is the stable long-term-support line. Its public API baseline is the
contract against which later changes are checked.

## Supported line

| Version | Status | Scope |
|---|---|---|
| 1.4.x | LTS | Compatibility-preserving correctness, security, accessibility, documentation, and supported-toolchain fixes |
| 1.3.x and earlier | Unsupported | Upgrade to the latest 1.4 patch release |

The 1.4 line remains supported until an end-of-support date is explicitly
announced in this document and the README. No end-of-support date is currently set.

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

When development moves beyond 1.4, maintenance fixes should be based on a dedicated
`release/1.4.x` branch and merged back into the active development line.
