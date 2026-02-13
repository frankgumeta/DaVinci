import SwiftUI
import DaVinciTokens

// MARK: - DSSkeletonBlock

/// A single rectangular skeleton placeholder block.
/// Fills with `theme.colors.semantic.skeleton` and optionally shimmers.
public struct DSSkeletonBlock: View {
    @Environment(\.dsTheme) private var theme

    private let height: CGFloat
    private let width: CGFloat?
    private let cornerRadius: CGFloat
    private let isShimmering: Bool

    public init(
        height: CGFloat,
        width: CGFloat? = nil,
        cornerRadius: CGFloat = RadiusTokens.small,
        isShimmering: Bool = true
    ) {
        self.height = height
        self.width = width
        self.cornerRadius = cornerRadius
        self.isShimmering = isShimmering
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(theme.colors.semantic.skeleton)
            .frame(width: width, height: height)
            .dsShimmering(isShimmering)
            .accessibilityHidden(true)
    }
}

// MARK: - DSSkeletonRow

/// A skeleton placeholder mimicking a common list row layout:
/// optional leading circle, two text lines, optional trailing block.
public struct DSSkeletonRow: View {
    @Environment(\.dsTheme) private var theme

    private let showLeading: Bool
    private let showTrailing: Bool
    private let isShimmering: Bool
    private let primaryLineWidth: CGFloat
    private let secondaryLineWidth: CGFloat

    public init(
        showLeading: Bool = true,
        showTrailing: Bool = false,
        isShimmering: Bool = true,
        primaryLineWidth: CGFloat = SkeletonTokens.rowLineWidthPrimary,
        secondaryLineWidth: CGFloat = SkeletonTokens.rowLineWidthSecondary
    ) {
        self.showLeading = showLeading
        self.showTrailing = showTrailing
        self.isShimmering = isShimmering
        self.primaryLineWidth = primaryLineWidth
        self.secondaryLineWidth = secondaryLineWidth
    }

    public var body: some View {
        HStack(spacing: SpacingTokens.space3) {
            if showLeading {
                DSSkeletonBlock(
                    height: SkeletonTokens.avatarSize,
                    width: SkeletonTokens.avatarSize,
                    cornerRadius: SkeletonTokens.avatarSize / 2,
                    isShimmering: isShimmering
                )
            }

            VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                DSSkeletonBlock(
                    height: SkeletonTokens.rowLineHeightPrimary,
                    width: primaryLineWidth,
                    cornerRadius: RadiusTokens.extraSmall,
                    isShimmering: isShimmering
                )
                DSSkeletonBlock(
                    height: SkeletonTokens.rowLineHeightSecondary,
                    width: secondaryLineWidth,
                    cornerRadius: RadiusTokens.extraSmall,
                    isShimmering: isShimmering
                )
            }

            Spacer()

            if showTrailing {
                DSSkeletonBlock(
                    height: SkeletonTokens.trailingChipHeight,
                    width: SkeletonTokens.trailingChipWidth,
                    cornerRadius: RadiusTokens.extraSmall,
                    isShimmering: isShimmering
                )
            }
        }
        .padding(.vertical, SpacingTokens.space2)
        .accessibilityHidden(true)
    }
}

// MARK: - DSSkeletonCard

/// A skeleton placeholder styled as a card with header blocks, text lines,
/// and an optional footer block.
public struct DSSkeletonCard: View {
    @Environment(\.dsTheme) private var theme

    private let showFooter: Bool
    private let isShimmering: Bool

    public init(
        showFooter: Bool = false,
        isShimmering: Bool = true
    ) {
        self.showFooter = showFooter
        self.isShimmering = isShimmering
    }

    public var body: some View {
        let elevation = ElevationTokens.small
        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            // Header area
            HStack(spacing: SpacingTokens.space3) {
                DSSkeletonBlock(
                    height: SkeletonTokens.cardIconSize,
                    width: SkeletonTokens.cardIconSize,
                    cornerRadius: RadiusTokens.extraSmall,
                    isShimmering: isShimmering
                )
                VStack(alignment: .leading, spacing: SpacingTokens.space1) {
                    DSSkeletonBlock(
                        height: SkeletonTokens.cardTitleHeight,
                        width: SkeletonTokens.cardTitleWidth,
                        cornerRadius: RadiusTokens.extraSmall,
                        isShimmering: isShimmering
                    )
                    DSSkeletonBlock(
                        height: SkeletonTokens.cardSubtitleHeight,
                        width: SkeletonTokens.cardSubtitleWidth,
                        cornerRadius: RadiusTokens.extraSmall,
                        isShimmering: isShimmering
                    )
                }
            }

            // Body lines
            DSSkeletonBlock(
                height: SkeletonTokens.cardBodyLineHeight,
                cornerRadius: RadiusTokens.extraSmall,
                isShimmering: isShimmering
            )
            DSSkeletonBlock(
                height: SkeletonTokens.cardBodyLineHeight,
                cornerRadius: RadiusTokens.extraSmall,
                isShimmering: isShimmering
            )
            DSSkeletonBlock(
                height: SkeletonTokens.cardBodyLineHeight,
                width: SkeletonTokens.cardBodyShortWidth,
                cornerRadius: RadiusTokens.extraSmall,
                isShimmering: isShimmering
            )

            // Footer
            if showFooter {
                HStack {
                    Spacer()
                    DSSkeletonBlock(
                        height: SkeletonTokens.cardFooterHeight,
                        width: SkeletonTokens.cardFooterWidth,
                        cornerRadius: RadiusTokens.small,
                        isShimmering: isShimmering
                    )
                }
            }
        }
        .padding(SpacingTokens.space4)
        .background(theme.colors.semantic.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.large))
        .shadow(color: elevation.color, radius: elevation.radius, x: elevation.x, y: elevation.y)
        .accessibilityHidden(true)
    }
}

// MARK: - DSSkeletonList

/// A high-level skeleton list that renders multiple `DSSkeletonRow` instances
/// with deterministic line-width variation for a natural loading appearance.
///
/// Width variation follows a repeating **long / medium / short** pattern
/// applied to each row's primary and secondary text lines, cycling through
/// the list without randomness.
public struct DSSkeletonList: View {
    @Environment(\.dsTheme) private var theme

    private let count: Int
    private let showLeading: Bool
    private let showTrailing: Bool
    private let isShimmering: Bool
    private let spacing: DSListSpacing
    private let showDividers: Bool

    public init(
        count: Int = 6,
        showLeading: Bool = true,
        showTrailing: Bool = false,
        isShimmering: Bool = true,
        spacing: DSListSpacing = .compact,
        showDividers: Bool = true
    ) {
        self.count = count
        self.showLeading = showLeading
        self.showTrailing = showTrailing
        self.isShimmering = isShimmering
        self.spacing = spacing
        self.showDividers = showDividers
    }

    /// Deterministic width multipliers cycling long / medium / short.
    private static let primaryMultipliers: [CGFloat] = [1.0, 0.75, 0.55]
    private static let secondaryMultipliers: [CGFloat] = [1.0, 0.85, 0.65]

    public var body: some View {
        VStack(spacing: spacing.value) {
            ForEach(0..<count, id: \.self) { index in
                if showDividers && index > 0 {
                    Divider()
                        .overlay(theme.colors.semantic.divider)
                }

                let pMul = Self.primaryMultipliers[index % Self.primaryMultipliers.count]
                let sMul = Self.secondaryMultipliers[index % Self.secondaryMultipliers.count]

                DSSkeletonRow(
                    showLeading: showLeading,
                    showTrailing: showTrailing,
                    isShimmering: isShimmering,
                    primaryLineWidth: SkeletonTokens.rowLineWidthPrimary * pMul,
                    secondaryLineWidth: SkeletonTokens.rowLineWidthSecondary * sMul
                )
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - DSSkeletonList Previews

#Preview("DSSkeletonList") {
    ScrollView {
        DSSkeletonList()
            .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonList — Dark") {
    ScrollView {
        DSSkeletonList()
            .padding()
    }
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSSkeletonList — Shimmer Off") {
    ScrollView {
        DSSkeletonList(isShimmering: false)
            .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonList — No Leading") {
    ScrollView {
        DSSkeletonList(showLeading: false)
            .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonList — Compact") {
    ScrollView {
        DSSkeletonList(count: 4, spacing: .compact, showDividers: false)
            .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonList — Spaced") {
    ScrollView {
        DSSkeletonList(count: 4, spacing: .spacious, showDividers: true)
            .padding()
    }
    .dsTheme(.defaultTheme)
}

// MARK: - Previews

#Preview("DSSkeletonBlock") {
    VStack(spacing: 12) {
        DSSkeletonBlock(height: 44)
        DSSkeletonBlock(height: 20)
        DSSkeletonBlock(height: 20)
        DSSkeletonBlock(height: 20)
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonBlock — Dark") {
    VStack(spacing: 12) {
        DSSkeletonBlock(height: 44)
        DSSkeletonBlock(height: 20)
        DSSkeletonBlock(height: 20)
        DSSkeletonBlock(height: 20)
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSSkeletonRow") {
    VStack(spacing: 0) {
        DSSkeletonRow()
        DSSkeletonRow(showLeading: false, showTrailing: true)
        DSSkeletonRow(showLeading: true, showTrailing: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonRow — Dark") {
    VStack(spacing: 0) {
        DSSkeletonRow()
        DSSkeletonRow(showLeading: false, showTrailing: true)
        DSSkeletonRow(showLeading: true, showTrailing: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSSkeletonCard") {
    VStack(spacing: 16) {
        DSSkeletonCard()
        DSSkeletonCard(showFooter: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSSkeletonCard — Dark") {
    VStack(spacing: 16) {
        DSSkeletonCard()
        DSSkeletonCard(showFooter: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("Skeleton — Shimmer Off") {
    VStack(spacing: 16) {
        DSSkeletonRow(isShimmering: false)
        DSSkeletonCard(isShimmering: false)
    }
    .padding()
    .dsTheme(.defaultTheme)
}
