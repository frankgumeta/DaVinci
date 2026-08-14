import Testing
import UIKit
@testable import DaVinciComponents

// MARK: - DSSymbol Tests

@Suite("DSSymbol")
struct DSSymbolTests {

    @Test func validSystemNameCreatesSymbol() throws {
        let symbol = try #require(DSSymbol(systemName: "person"))

        #expect(symbol.systemName == "person")
    }

    @Test func invalidSystemNameReturnsNil() {
        #expect(DSSymbol(systemName: "davinci.symbol.does.not.exist") == nil)
    }

    @Test func emptySystemNameReturnsNil() {
        #expect(DSSymbol(systemName: "") == nil)
    }

    @Test func equalityUsesValidatedSystemName() throws {
        let first = try #require(DSSymbol(systemName: "person"))
        let second = try #require(DSSymbol(systemName: "person"))
        let different = try #require(DSSymbol(systemName: "photo"))

        #expect(first == second)
        #expect(first != different)
    }

    @Test func hashingUsesValidatedSystemName() throws {
        let person = try #require(DSSymbol(systemName: "person"))
        let duplicate = try #require(DSSymbol(systemName: "person"))
        let photo = try #require(DSSymbol(systemName: "photo"))
        let symbols: Set<DSSymbol> = [person, duplicate, photo]

        #expect(symbols.count == 2)
    }

    @Test func symbolIsSendable() throws {
        let symbol = try #require(DSSymbol(systemName: "person"))

        acceptSendable(symbol)
    }

    @Test func firstAvailableUsesFirstValidSymbol() throws {
        let symbol = try #require(
            DSSymbol.firstAvailable("davinci.symbol.does.not.exist", "person", "photo")
        )

        #expect(symbol.systemName == "person")
    }

    @Test func firstAvailableSupportsSequences() throws {
        let symbol = try #require(
            DSSymbol.firstAvailable(["davinci.symbol.does.not.exist", "photo"])
        )

        #expect(symbol.systemName == "photo")
    }

    @Test func firstAvailableReturnsNilWhenNoNameIsValid() {
        #expect(DSSymbol.firstAvailable("", "davinci.symbol.does.not.exist") == nil)
    }

    @Test func davinciOwnedSymbolsAreAvailable() {
        let symbols: [DSSymbol] = [.clear, .imagePlaceholder, .errorIndicator]

        for symbol in symbols {
            #expect(UIImage(systemName: symbol.systemName) != nil)
        }
    }

    private func acceptSendable<Value: Sendable>(_: Value) {}
}
