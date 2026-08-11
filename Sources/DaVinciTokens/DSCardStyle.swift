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
    /// Outlined card: standard density, no elevation, semantic border.
    case outlined

    /// Inner content padding.
    public var padding: CGFloat {
        switch self {
        case .compact:   SpacingTokens.space3
        case .standard, .outlined: SpacingTokens.space4
        case .prominent: SpacingTokens.space5
        }
    }

    /// Corner radius.
    public var cornerRadius: CGFloat {
        switch self {
        case .compact:   RadiusTokens.medium
        case .standard, .prominent, .outlined: RadiusTokens.large
        }
    }

    /// Shadow / elevation level.
    public var elevation: DSElevation {
        switch self {
        case .compact:   ElevationTokens.none
        case .standard:  ElevationTokens.small
        case .prominent: ElevationTokens.medium
        case .outlined:  ElevationTokens.none
        }
    }

    /// Semantic outline width. Non-outlined presets do not render a border.
    public var borderWidth: CGFloat {
        switch self {
        case .outlined: StrokeTokens.hairline
        case .compact, .standard, .prominent: 0
        }
    }
}
