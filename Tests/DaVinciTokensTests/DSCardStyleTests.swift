import Testing
@testable import DaVinciTokens

@Suite("DSCardStyle")
struct DSCardStyleTests {

    @Test func paddingIsAscending() {
        #expect(DSCardStyle.compact.padding < DSCardStyle.standard.padding)
        #expect(DSCardStyle.standard.padding < DSCardStyle.prominent.padding)
    }

    @Test func compactHasCorrectTokens() {
        #expect(DSCardStyle.compact.padding == SpacingTokens.space3)
        #expect(DSCardStyle.compact.cornerRadius == RadiusTokens.medium)
        #expect(DSCardStyle.compact.elevation.radius == 0)
    }

    @Test func standardHasCorrectTokens() {
        #expect(DSCardStyle.standard.padding == SpacingTokens.space4)
        #expect(DSCardStyle.standard.cornerRadius == RadiusTokens.large)
        #expect(DSCardStyle.standard.elevation.radius == 4)
    }

    @Test func prominentHasCorrectTokens() {
        #expect(DSCardStyle.prominent.padding == SpacingTokens.space5)
        #expect(DSCardStyle.prominent.cornerRadius == RadiusTokens.large)
        #expect(DSCardStyle.prominent.elevation.radius == 8)
    }

    @Test func outlinedHasStandardDensityWithoutElevation() {
        #expect(DSCardStyle.outlined.padding == DSCardStyle.standard.padding)
        #expect(DSCardStyle.outlined.cornerRadius == DSCardStyle.standard.cornerRadius)
        #expect(DSCardStyle.outlined.elevation.radius == 0)
        #expect(DSCardStyle.outlined.borderWidth == StrokeTokens.hairline)
    }

    @Test func onlyOutlinedHasABorder() {
        #expect(DSCardStyle.compact.borderWidth == 0)
        #expect(DSCardStyle.standard.borderWidth == 0)
        #expect(DSCardStyle.prominent.borderWidth == 0)
        #expect(DSCardStyle.outlined.borderWidth > 0)
    }

    @Test func elevationIsAscending() {
        #expect(DSCardStyle.compact.elevation.radius < DSCardStyle.standard.elevation.radius)
        #expect(DSCardStyle.standard.elevation.radius < DSCardStyle.prominent.elevation.radius)
    }
}
