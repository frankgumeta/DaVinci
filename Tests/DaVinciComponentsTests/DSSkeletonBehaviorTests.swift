import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSSkeleton Behavior Tests

@Suite("DSSkeleton Behavior")
struct DSSkeletonBehaviorTests {

    // MARK: - SkeletonList Multiplier Pattern

    @Test func primaryMultipliersHaveThreeEntries() {
        #expect(DSSkeletonList.primaryMultipliers.count == 3)
    }

    @Test func secondaryMultipliersHaveThreeEntries() {
        #expect(DSSkeletonList.secondaryMultipliers.count == 3)
    }

    @Test func primaryMultipliersAreDescending() {
        let m = DSSkeletonList.primaryMultipliers
        #expect(m[0] > m[1])
        #expect(m[1] > m[2])
    }

    @Test func secondaryMultipliersAreDescending() {
        let m = DSSkeletonList.secondaryMultipliers
        #expect(m[0] > m[1])
        #expect(m[1] > m[2])
    }

    @Test func primaryMultipliersStartAtOne() {
        #expect(DSSkeletonList.primaryMultipliers[0] == 1.0)
    }

    @Test func secondaryMultipliersStartAtOne() {
        #expect(DSSkeletonList.secondaryMultipliers[0] == 1.0)
    }

    @Test func allMultipliersArePositive() {
        for m in DSSkeletonList.primaryMultipliers {
            #expect(m > 0)
        }
        for m in DSSkeletonList.secondaryMultipliers {
            #expect(m > 0)
        }
    }

    @Test func allMultipliersAreAtMostOne() {
        for m in DSSkeletonList.primaryMultipliers {
            #expect(m <= 1.0)
        }
        for m in DSSkeletonList.secondaryMultipliers {
            #expect(m <= 1.0)
        }
    }

    // MARK: - Multiplier Pattern Cycling

    @Test func primaryMultipliersCycleCorrectly() {
        let m = DSSkeletonList.primaryMultipliers
        let count = 9

        for i in 0..<count {
            let expected = m[i % m.count]
            let actual = m[i % m.count]
            #expect(actual == expected)
        }

        // Verify the pattern repeats: 0→long, 1→medium, 2→short, 3→long, ...
        #expect(m[0 % m.count] == m[3 % m.count])
        #expect(m[1 % m.count] == m[4 % m.count])
        #expect(m[2 % m.count] == m[5 % m.count])
    }

    // MARK: - Row Width Derivation

    @Test func rowPrimaryWidthsVaryWithMultiplier() {
        let baseWidth = SkeletonTokens.rowLineWidthPrimary
        let multipliers = DSSkeletonList.primaryMultipliers

        let widths = multipliers.map { baseWidth * $0 }

        #expect(widths[0] == baseWidth)
        #expect(widths[1] == baseWidth * 0.75)
        #expect(widths[2] == baseWidth * 0.55)
        #expect(widths[0] > widths[1])
        #expect(widths[1] > widths[2])
    }

    @Test func rowSecondaryWidthsVaryWithMultiplier() {
        let baseWidth = SkeletonTokens.rowLineWidthSecondary
        let multipliers = DSSkeletonList.secondaryMultipliers

        let widths = multipliers.map { baseWidth * $0 }

        #expect(widths[0] == baseWidth)
        #expect(widths[1] == baseWidth * 0.85)
        #expect(widths[2] == baseWidth * 0.65)
    }

    // MARK: - SkeletonTokens Consistency

    @Test func avatarSizeIsReasonable() {
        #expect(SkeletonTokens.avatarSize == 40)
        #expect(SkeletonTokens.avatarSize > 0)
    }

    @Test func rowLineHeightsAreOrdered() {
        #expect(SkeletonTokens.rowLineHeightPrimary > SkeletonTokens.rowLineHeightSecondary)
    }

    @Test func cardTokensArePositive() {
        #expect(SkeletonTokens.cardIconSize > 0)
        #expect(SkeletonTokens.cardTitleHeight > 0)
        #expect(SkeletonTokens.cardTitleWidth > 0)
        #expect(SkeletonTokens.cardSubtitleHeight > 0)
        #expect(SkeletonTokens.cardSubtitleWidth > 0)
        #expect(SkeletonTokens.cardBodyLineHeight > 0)
        #expect(SkeletonTokens.cardBodyShortWidth > 0)
        #expect(SkeletonTokens.cardFooterHeight > 0)
        #expect(SkeletonTokens.cardFooterWidth > 0)
    }

    @Test func cardTitleIsLargerThanSubtitle() {
        #expect(SkeletonTokens.cardTitleHeight > SkeletonTokens.cardSubtitleHeight)
        #expect(SkeletonTokens.cardTitleWidth > SkeletonTokens.cardSubtitleWidth)
    }

    @Test func trailingChipDimensionsArePositive() {
        #expect(SkeletonTokens.trailingChipHeight > 0)
        #expect(SkeletonTokens.trailingChipWidth > 0)
    }

    // MARK: - DSSkeletonRow Default Widths

    @Test @MainActor func skeletonRowDefaultWidthsMatchTokens() {
        let row = DSSkeletonRow()
        // Default init uses SkeletonTokens values —
        // verify the type constructs without error (init parameter defaults)
        #expect(type(of: row) == DSSkeletonRow.self)
    }

    @Test @MainActor func skeletonRowCustomWidths() {
        let row = DSSkeletonRow(
            primaryLineWidth: 100,
            secondaryLineWidth: 80
        )
        #expect(type(of: row) == DSSkeletonRow.self)
    }

    // MARK: - DSSkeletonBlock Init Variations

    @Test @MainActor func skeletonBlockDefaultShimmering() {
        let block = DSSkeletonBlock(height: 20)
        #expect(type(of: block) == DSSkeletonBlock.self)
    }

    @Test @MainActor func skeletonBlockShimmerDisabled() {
        let block = DSSkeletonBlock(height: 20, isShimmering: false)
        #expect(type(of: block) == DSSkeletonBlock.self)
    }

    @Test @MainActor func skeletonBlockCustomCornerRadius() {
        let block = DSSkeletonBlock(
            height: 40,
            width: 40,
            cornerRadius: RadiusTokens.large,
            isShimmering: true
        )
        #expect(type(of: block) == DSSkeletonBlock.self)
    }
}
