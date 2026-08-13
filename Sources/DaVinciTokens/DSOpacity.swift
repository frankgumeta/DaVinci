import SwiftUI

// MARK: - OpacityTokens

/// Interaction opacity tokens for consistent state feedback.
/// - `disabled`: applied to controls in a disabled state.
/// - `pressed`: applied to controls during a press/tap interaction.
/// - `scrim`: used for overlay/scrim backgrounds (e.g. `bgScrim`).
/// - `subtleFill`: used to derive low-emphasis tinted surfaces.
/// - `subtleStroke`: used to reinforce the boundary of tinted surfaces.
public enum OpacityTokens: Sendable {
    /// 40% — disabled controls
    public static let disabled: Double = 0.4
    /// 85% — pressed/active controls
    public static let pressed: Double = 0.85
    /// 35% — scrim overlays
    public static let scrim: Double = 0.35
    /// 14% — low-emphasis tinted component surfaces
    public static let subtleFill: Double = 0.14
    /// 40% — low-emphasis tinted component outlines
    public static let subtleStroke: Double = 0.4
    /// 55% — shimmer highlight peak opacity
    public static let shimmerHighlight: Double = 0.55
    /// 30% — static shimmer overlay when Reduce Motion is enabled
    public static let shimmerStatic: Double = 0.30
}
