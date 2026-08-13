import CoreGraphics
import Testing
@testable import DaVinciComponents

@Suite("DSRemoteImage Geometry")
struct DSRemoteImageGeometryTests {

    @Test func circleDerivesSquareSizeAndRadiusFromDiameter() {
        let geometry = DSRemoteImage.Geometry.circle(diameter: 80)
        #expect(geometry.size == CGSize(width: 80, height: 80))
        #expect(geometry.cornerRadius == 40)
    }

    @Test func rectangleHasNoCornerRadius() {
        let geometry = DSRemoteImage.Geometry.rectangle(size: CGSize(width: 120, height: 80))
        #expect(geometry.size == CGSize(width: 120, height: 80))
        #expect(geometry.cornerRadius == 0)
    }

    @Test func roundedPreservesSizeAndValidRadius() {
        let geometry = DSRemoteImage.Geometry.rounded(
            size: CGSize(width: 120, height: 80),
            cornerRadius: 16
        )
        #expect(geometry.size == CGSize(width: 120, height: 80))
        #expect(geometry.cornerRadius == 16)
    }

    @Test func roundedCapsRadiusAtHalfTheShortestEdge() {
        let geometry = DSRemoteImage.Geometry.rounded(
            size: CGSize(width: 120, height: 40),
            cornerRadius: 100
        )
        #expect(geometry.cornerRadius == 20)
    }

    @Test func invalidDimensionsNormalizeToZero() {
        let rectangle = DSRemoteImage.Geometry.rectangle(
            size: CGSize(width: -10, height: CGFloat.infinity)
        )
        let circle = DSRemoteImage.Geometry.circle(diameter: -CGFloat.infinity)
        #expect(rectangle.size == .zero)
        #expect(circle.size == .zero)
    }

}
