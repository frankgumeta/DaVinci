import SwiftUI

// MARK: - DSMotion

/// Motion / animation tokens used by `DSTheme`.
public struct DSMotion: Sendable {
    /// 0.15s — fast micro-interactions
    public let fast: Double
    /// 0.25s — standard transitions
    public let normal: Double
    /// 0.35s — deliberate, larger transitions
    public let slow: Double

    /// Default easing curve for most animations.
    public let easeInOut: Animation
    /// Snappy spring for interactive feedback.
    public let snappy: Animation

    /// Duration for a single skeleton shimmer sweep (seconds).
    /// Defaults to 1.2s — a comfortable, non-distracting pace.
    public let shimmerDuration: Double

    public init(
        fast: Double = 0.15,
        normal: Double = 0.25,
        slow: Double = 0.35,
        easeInOut: Animation = .easeInOut,
        snappy: Animation = .snappy,
        shimmerDuration: Double = 1.2
    ) {
        self.fast = fast
        self.normal = normal
        self.slow = slow
        self.easeInOut = easeInOut
        self.snappy = snappy
        self.shimmerDuration = shimmerDuration
    }
}
