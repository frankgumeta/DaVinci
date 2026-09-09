import Foundation

// MARK: - ControlHeightTokens

/// Standard control height tokens for interactive elements.
public enum ControlHeightTokens: Sendable {
    /// 32pt — small controls
    public static let small: CGFloat = 32
    /// 36pt — compact controls that must still meet the minimum hit target
    ///
    /// Paired with ``minimumHitTarget``: a compact control paints at this height and
    /// reserves 44pt of touch area around it.
    public static let compact: CGFloat = 36
    /// 40pt — medium controls (default)
    public static let medium: CGFloat = 40
    /// 50pt — large controls
    public static let large: CGFloat = 50

    /// 44pt — the smallest square a control may occupy for touch.
    ///
    /// A control may *paint* smaller than this, but its interactive area must not.
    /// Use it for both dimensions: a hit target is an area, so a control that is tall
    /// enough but narrow still fails.
    public static let minimumHitTarget: CGFloat = 44
}
