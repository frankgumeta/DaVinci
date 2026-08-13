import Testing
import SwiftUI
@testable import DaVinciComponents
@testable import DaVinciTokens

// MARK: - DSSymbol Adoption Tests

@Suite("DSSymbol Adoption")
struct DSSymbolAdoptionTests {
    @Test func buttonIconStoresValidatedSymbols() throws {
        let leading = try #require(DSSymbol(systemName: "plus"))
        let trailing = try #require(DSSymbol(systemName: "arrow.right"))

        if case .leading(let storedLeading) = DSButtonIcon.leading(leading) {
            #expect(storedLeading == leading)
        } else {
            Issue.record("Expected a leading symbol")
        }

        if case .trailing(let storedTrailing) = DSButtonIcon.trailing(trailing) {
            #expect(storedTrailing == trailing)
        } else {
            Issue.record("Expected a trailing symbol")
        }
    }

    @Test @MainActor func iconButtonAcceptsValidatedSymbol() throws {
        let symbol = try #require(DSSymbol(systemName: "plus"))
        let button = DSIconButton(
            symbol: symbol,
            titleForAccessibility: "Add",
            appearance: .primary
        ) {}

        #expect(button.accessibilityDescriptor.label == "Add")
    }

    @Test func segmentItemAcceptsOptionalValidatedSymbol() throws {
        let symbol = try #require(DSSymbol(systemName: "list.bullet"))

        #expect(DSSegmentItem(title: "List", icon: symbol).icon == symbol)
        #expect(DSSegmentItem(title: "Day").icon == nil)
    }

    @Test @MainActor func remoteImageAcceptsTypedPlaceholderWithCircleGeometry() throws {
        let symbol = try #require(DSSymbol(systemName: "person"))
        let image = DSRemoteImage(
            url: nil,
            geometry: .circle(diameter: 80),
            placeholder: symbol,
            accessibilityLabel: "Profile photo"
        )

        #expect(image.accessibilityDescriptor.label == "Profile photo")
    }

    @Test @MainActor func remoteImageAcceptsTypedPlaceholderWithRoundedGeometry() throws {
        let symbol = try #require(DSSymbol(systemName: "photo"))
        let image = DSRemoteImage(
            url: nil,
            geometry: .rounded(
                size: CGSize(width: 80, height: 80),
                cornerRadius: RadiusTokens.extraSmall
            ),
            placeholder: symbol
        )

        #expect(image.accessibilityDescriptor.label == "Placeholder image")
    }
}
