import Foundation

// MARK: - SkeletonTokens

/// Size constants for skeleton placeholder components.
/// Eliminates magic numbers from `DSSkeletonRow` and `DSSkeletonCard`.
public enum SkeletonTokens: Sendable {

    // MARK: - Row

    /// Leading avatar circle diameter.
    public static let avatarSize: CGFloat = 40
    /// Primary text line height in a row.
    public static let rowLineHeightPrimary: CGFloat = 14
    /// Secondary text line height in a row.
    public static let rowLineHeightSecondary: CGFloat = 12
    /// Primary text line width in a row.
    public static let rowLineWidthPrimary: CGFloat = 140
    /// Secondary text line width in a row.
    public static let rowLineWidthSecondary: CGFloat = 200
    /// Trailing chip height.
    public static let trailingChipHeight: CGFloat = 28
    /// Trailing chip width.
    public static let trailingChipWidth: CGFloat = 60

    // MARK: - Card

    /// Card header icon size.
    public static let cardIconSize: CGFloat = 36
    /// Card header title line height.
    public static let cardTitleHeight: CGFloat = 14
    /// Card header title line width.
    public static let cardTitleWidth: CGFloat = 120
    /// Card header subtitle line height.
    public static let cardSubtitleHeight: CGFloat = 10
    /// Card header subtitle line width.
    public static let cardSubtitleWidth: CGFloat = 80
    /// Card body line height.
    public static let cardBodyLineHeight: CGFloat = 12
    /// Card body short line width (last line).
    public static let cardBodyShortWidth: CGFloat = 180
    /// Card footer button height.
    public static let cardFooterHeight: CGFloat = 32
    /// Card footer button width.
    public static let cardFooterWidth: CGFloat = 100
}
