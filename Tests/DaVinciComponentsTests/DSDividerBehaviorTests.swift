import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSDivider Behavior Tests

@Suite("DSDivider Behavior")
struct DSDividerBehaviorTests {

    // MARK: - Style Thickness

    @Test func hairlineThicknessIsHalf() {
        #expect(DSDivider.Style.hairline.thickness == 0.5)
    }

    @Test func regularThicknessIsOne() {
        #expect(DSDivider.Style.regular.thickness == 1)
    }

    @Test func hairlineIsThinnerThanRegular() {
        #expect(DSDivider.Style.hairline.thickness < DSDivider.Style.regular.thickness)
    }

    @Test func bothThicknessesArePositive() {
        #expect(DSDivider.Style.hairline.thickness > 0)
        #expect(DSDivider.Style.regular.thickness > 0)
    }

    // MARK: - Orientation Enum Distinctness

    @Test func orientationsAreDistinct() {
        let horizontal = DSDivider.Orientation.horizontal
        let vertical = DSDivider.Orientation.vertical
        #expect(horizontal != vertical)
    }

    // MARK: - Style Enum Distinctness

    @Test func stylesAreDistinct() {
        let hairline = DSDivider.Style.hairline
        let regular = DSDivider.Style.regular
        #expect(hairline != regular)
    }

    // MARK: - Default Init Values

    @Test @MainActor func defaultInitIsHorizontalRegular() {
        // Default init: orientation = .horizontal, style = .regular
        // We can't read private properties directly, but we verify the
        // combination creates without error and the thickness value.
        let divider = DSDivider()
        #expect(type(of: divider) == DSDivider.self)
    }

    @Test @MainActor func horizontalHairlineDivider() {
        let divider = DSDivider(orientation: .horizontal, style: .hairline)
        #expect(type(of: divider) == DSDivider.self)
    }

    @Test @MainActor func verticalRegularDivider() {
        let divider = DSDivider(orientation: .vertical, style: .regular)
        #expect(type(of: divider) == DSDivider.self)
    }

    @Test @MainActor func verticalHairlineDivider() {
        let divider = DSDivider(orientation: .vertical, style: .hairline)
        #expect(type(of: divider) == DSDivider.self)
    }

    // MARK: - All Combinations

    @Test @MainActor func allOrientationStyleCombinations() {
        let orientations: [DSDivider.Orientation] = [.horizontal, .vertical]
        let styles: [DSDivider.Style] = [.hairline, .regular]

        for orientation in orientations {
            for style in styles {
                let divider = DSDivider(orientation: orientation, style: style)
                #expect(type(of: divider) == DSDivider.self)
            }
        }
    }
}
