# Post-2.0 continuity

Once `v2.0.0` is published, the active 2.0 baseline becomes mandatory for every
pull request. The compatibility policy is:

- `fix/*` and `docs/*` may target 2.0.x when they preserve source and rendering
  contracts.
- New compatible public APIs target 2.1.0 and require documentation, behavior,
  accessibility, and coverage tests.
- Removed APIs, changed defaults, and incompatible visual contracts wait for 3.0.
- Shared fixes start on the oldest supported line affected and are forward-ported
  to newer lines.

Maintenance cadence:

- Xcode 27.x canary before changing snapshots or baselines;
- monthly review of dependencies, Actions, warnings, coverage, and performance;
- quarterly review of 1.4.x LTS status and support horizon.

Deferred, non-blocking backlog:

1. Expand Gallery interaction coverage beyond construction and pure SwiftUI raster
   smoke tests.
2. Add a dedicated sanitizer/Thread Sanitizer lane when the hosted runner cost is
   acceptable.
3. Replace the Xcode post-test `simctl diagnose` hang with an upstream toolchain
   workaround once Apple provides one; the test result itself is already green.
