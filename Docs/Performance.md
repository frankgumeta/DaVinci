# Performance baselines

DaVinci keeps deterministic guardrails around its highest-risk runtime path:
remote-image decoding and in-memory caching.

`DSPerformanceBaselineTests` exercises sustained LRU traffic and repeated 512×512
PNG decoding. The limits are intentionally generous enough for shared CI runners;
they are regression alarms, not device-level product benchmarks. The complete test
suite runs them on every pull request and release using the current CI runtime.
The minimum-runtime compatibility lane compiles but does not execute these timed
checks because a freshly installed legacy simulator can be throttled severely.

For meaningful product measurements, profile the consuming application on physical
devices with its real image sizes, themes, network loaders, and view hierarchy.
Package-level tests cannot establish the host application's launch, scrolling, or
memory budget.
