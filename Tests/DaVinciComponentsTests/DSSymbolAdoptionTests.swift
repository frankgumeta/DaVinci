import Testing
import SwiftUI
@testable import DaVinciComponents

// MARK: - DSSymbol Adoption Tests

/// Validates that components which accept SF Symbols correctly bridge between
/// the validated `DSSymbol` API and the legacy `String` API, producing
/// identical internal state.
@Suite("DSSymbol Adoption")
struct DSSymbolAdoptionTests {

    // MARK: - DSButtonIcon

    @Test func buttonIconLeadingFactoryMatchesStringCase() throws {
        let symbol = try #require(DSSymbol(systemName: "plus"))
        let fromSymbol: DSButtonIcon = .leading(symbol)
        let fromString: DSButtonIcon = .leading(systemName: "plus")

        // Both should produce the same internal systemName when pattern-matched.
        switch (fromSymbol, fromString) {
        case (.leading(let a), .leading(let b)):
            #expect(a == b)
        default:
            Issue.record("Both should be .leading")
        }
    }

    @Test func buttonIconTrailingFactoryMatchesStringCase() throws {
        let symbol = try #require(DSSymbol(systemName: "arrow.right"))
        let fromSymbol: DSButtonIcon = .trailing(symbol)
        let fromString: DSButtonIcon = .trailing(systemName: "arrow.right")

        switch (fromSymbol, fromString) {
        case (.trailing(let a), .trailing(let b)):
            #expect(a == b)
        default:
            Issue.record("Both should be .trailing")
        }
    }

    // MARK: - DSIconButton

    @Test @MainActor func iconButtonSymbolInitMatchesSystemNameInit() throws {
        let symbol = try #require(DSSymbol(systemName: "plus"))
        let fromSymbol = DSIconButton(
            symbol: symbol,
            titleForAccessibility: "Add",
            variant: .primary
        ) {}
        let fromString = DSIconButton(
            systemName: "plus",
            titleForAccessibility: "Add",
            variant: .primary
        ) {}

        // Both should report the same accessibility label (proves they're
        // constructed equivalently for the consumer's perspective).
        #expect(fromSymbol.accessibilityDescriptor.label == fromString.accessibilityDescriptor.label)
    }

    // MARK: - DSSegmentItem

    @Test func segmentItemSymbolInitMatchesStringInit() throws {
        let symbol = try #require(DSSymbol(systemName: "list.bullet"))
        let fromSymbol = DSSegmentItem(title: "List", icon: symbol)
        let fromString = DSSegmentItem(title: "List", iconSystemName: "list.bullet")

        #expect(fromSymbol.iconSystemName == fromString.iconSystemName)
    }

    @Test func segmentItemNilSymbolMatchesNilString() {
        let fromSymbol = DSSegmentItem(title: "Day")
        let fromString = DSSegmentItem(title: "Day", iconSystemName: nil)

        #expect(fromSymbol.iconSystemName == fromString.iconSystemName)
    }

    // MARK: - DSRemoteImage

    @Test @MainActor func remoteImageAcceptsTypedPlaceholderWithExplicitFrame() throws {
        let symbol = try #require(DSSymbol(systemName: "person"))
        let image = DSRemoteImage(
            url: nil,
            width: 80,
            height: 80,
            placeholder: symbol,
            accessibilityLabel: "Profile photo"
        )

        #expect(image.accessibilityDescriptor.label == "Profile photo")
    }

    @Test @MainActor func remoteImageAcceptsTypedPlaceholderWithSize() throws {
        let symbol = try #require(DSSymbol(systemName: "photo"))
        let image = DSRemoteImage(
            url: nil,
            size: CGSize(width: 80, height: 80),
            placeholder: symbol
        )

        #expect(image.accessibilityDescriptor.label == "Placeholder image")
    }
}
