import Foundation

// MARK: - DSCardStyle

/// Strict style variants for `DSCard`.
/// Controls padding, corner radius, and elevation via tokens — no raw `CGFloat`.
public enum DSCardStyle: Sendable {
    /// Compact card: tighter padding, smaller radius, no elevation.
    case compact
    /// Default card: standard padding, large radius, small elevation.
    case standard
    /// Prominent card: generous padding, large radius, medium elevation.
    case prominent

    /// Inner content padding.
    public var padding: CGFloat {
        switch self {
        case .compact:   SpacingTokens.space3
        case .standard:  SpacingTokens.space4
        case .prominent: SpacingTokens.space5
        }
    }

    /// Corner radius.
    public var cornerRadius: CGFloat {
        switch self {
        case .compact:   RadiusTokens.medium
        case .standard:  RadiusTokens.large
        case .prominent: RadiusTokens.large
        }
    }

    /// Shadow / elevation level.
    public var elevation: DSElevation {
        switch self {
        case .compact:   ElevationTokens.none
        case .standard:  ElevationTokens.small
        case .prominent: ElevationTokens.medium
        }
    }
}
