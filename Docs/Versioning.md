# Versioning policy

DaVinci follows Semantic Versioning for its public Swift products.

## Pre-adoption exception

Version 1.4.0 contains a one-time source-breaking cleanup approved before the
design system had known external consumers. Its migration is documented in
`CHANGELOG.md`. Starting immediately after 1.4.0, the major-version rules below
apply without this exception.

## Change classification

### Major

- Removing or renaming a public symbol.
- Changing a public signature without a source-compatible overload.
- Changing a default that materially alters established behavior or rendering.
- Raising the minimum iOS, Xcode, Swift tools, or Swift language requirement in a
  way that prevents an existing supported consumer from updating.

### Minor

- Adding a backward-compatible component, token, overload, or opt-in behavior.
- Deprecating an API while preserving its implementation and migration path.
- Expanding supported platforms or toolchains without dropping an existing one.

### Patch

- Correcting behavior without changing the documented public contract.
- Documentation, CI, test, and internal implementation improvements.
- Performance or accessibility fixes that preserve source compatibility.

## Deprecation and migration

When practical, a public API is deprecated for at least one minor release before
removal. Breaking releases must include a migration section in `CHANGELOG.md` with
before-and-after code for every affected API.

## Release evidence

Before publishing a version:

1. Run the minimum-deployment build and complete test suite with the documented
   Xcode version.
2. Enforce product coverage and SwiftLint in CI.
3. Review snapshot changes and complete the manual accessibility matrix when UI
   behavior changed.
4. Compare the public API with the previous tag and classify every difference.
5. Verify installation from a minimal external consumer app.

There are two API baselines with different jobs:

- The 1.4.0 baseline is historical evidence for the major migration and remains
  unchanged.
- The 2.0.0 baseline is the active development/release gate after the 2.0 public
  surface is approved. It is compared only against DaVinci-owned declarations;
  SDK-owned `EnvironmentValues` conformance churn is filtered by an exact,
  regression-tested rule.

CI compares the compiled Swift interface of every public product against the
active baseline. After an intentional release-level API review, update it with:

```bash
xcodebuild build \
  -scheme DaVinci-Package \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath .build
bash .github/scripts/check-api-baseline.sh --update
```

Never update the baseline merely to make an unexplained compatibility failure pass.

The compatibility matrix in `Docs/Compatibility.md` is part of the public support
contract. Any change to it must be called out in release notes.
