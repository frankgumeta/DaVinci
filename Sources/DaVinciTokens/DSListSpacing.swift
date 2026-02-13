import Foundation

// MARK: - DSListSpacing

/// Strict spacing options for list-style layouts.
/// Maps to `SpacingTokens` values — no raw `CGFloat` escape hatch.
public enum DSListSpacing: Sendable {
    /// 0pt — rows touch with no gap.
    case compact
    /// 8pt — default comfortable breathing room (`SpacingTokens.space2`).
    case comfortable
    /// 12pt — generous spacing between rows (`SpacingTokens.space3`).
    case spacious

    /// The resolved `CGFloat` value for use in layout.
    public var value: CGFloat {
        switch self {
        case .compact:     0
        case .comfortable: SpacingTokens.space2
        case .spacious:    SpacingTokens.space3
        }
    }
}
