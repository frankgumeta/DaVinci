import Testing
import SwiftUI
@testable import DaVinciComponents

// MARK: - DSTextField Character Limit Tests

@Suite("DSTextField Character Limit")
@MainActor
struct DSTextFieldCharacterLimitTests {

    @Test func characterLimitConfigured() {
        let config = DSTextField.Configuration.filled.characterLimit(50)
        #expect(config.characterLimit == 50)
    }

    @Test func characterLimitNotSetByDefault() {
        let config = DSTextField.Configuration.filled
        #expect(config.characterLimit == nil)
    }

    @Test func characterLimitBuilderReturnsCopy() {
        let original = DSTextField.Configuration.filled
        let modified = original.characterLimit(30)
        #expect(original.characterLimit == nil)
        #expect(modified.characterLimit == 30)
    }

    @Test func characterLimitPreservesOtherFields() {
        let config = DSTextField.Configuration.outlined
            .leading(DSSymbol(systemName: "person")!)
            .characterLimit(20)
        #expect(config.appearance == .outlined)
        #expect(config.leading != nil)
        #expect(config.characterLimit == 20)
    }

    @Test func constrainedTextTruncatesWithoutSplittingGraphemeClusters() {
        let value = "A👨‍👩‍👧‍👦B"
        #expect(DSTextField.constrainedText(value, limit: 2) == "A👨‍👩‍👧‍👦")
    }

    @Test func constrainedTextHandlesZeroAndNegativeLimitsSafely() {
        #expect(DSTextField.constrainedText("abc", limit: 0).isEmpty)
        #expect(DSTextField.constrainedText("abc", limit: -3).isEmpty)
    }

    @Test func constrainedTextLeavesValueUnchangedWithoutLimit() {
        #expect(DSTextField.constrainedText("abc", limit: nil) == "abc")
    }

    @Test func clearActionClearsTheBinding() {
        var value = "query"
        let binding = Binding(get: { value }, set: { value = $0 })
        let field = DSTextField(
            "Search",
            text: binding,
            configuration: .filled.trailing(.clear)
        )

        field.clearText()

        #expect(value.isEmpty)
    }

    @Test func characterProgressIsIncludedInAccessibilityValue() {
        let field = DSTextField(
            "Title",
            text: .constant("Hello"),
            configuration: .filled.characterLimit(10)
        )
        #expect(field.resolvedAccessibilityValue == "Hello. 5 of 10 characters")
    }
}

// MARK: - DSFieldMessage Rendering Tests

@Suite("DSTextField Message Rendering")
@MainActor
struct DSTextFieldMessageRenderingTests {

    @Test func supportingMessageDoesNotAffectAccessibilityValue() {
        let field = DSTextField(
            "Email",
            text: .constant("test@test.com"),
            configuration: .filled.message(.supporting("Helper"))
        )
        #expect(field.resolvedAccessibilityValue == "test@test.com")
    }

    @Test func errorMessageIncludedInAccessibilityValue() {
        let field = DSTextField(
            "Email",
            text: .constant("bad@"),
            configuration: .filled.message(.error("Invalid"))
        )
        #expect(field.resolvedAccessibilityValue == "bad@. Error: Invalid")
    }

    @Test func supportingAndErrorAreMutuallyExclusive() {
        // DSFieldMessage is an enum, so only one can be present.
        let supporting: DSFieldMessage = .supporting("A")
        let error: DSFieldMessage = .error("B")
        #expect(!supporting.isError)
        #expect(error.isError)
    }

    @Test func messageReplacedNotAccumulated() {
        let config = DSTextField.Configuration.filled
            .message(.supporting("Helper"))
            .message(.error("Now bad"))
        #expect(config.message?.isError == true)
        #expect(config.message?.text == "Now bad")
    }

    // MARK: - Filled vs Outlined message equivalence

    @Test func errorMessageSameAccessibilityInBothAppearances() {
        let filled = DSTextField(
            "Email",
            text: .constant("bad@"),
            configuration: .filled.message(.error("Invalid"))
        )
        let outlined = DSTextField(
            "Email",
            text: .constant("bad@"),
            configuration: .outlined.message(.error("Invalid"))
        )
        #expect(filled.resolvedAccessibilityValue == outlined.resolvedAccessibilityValue)
    }

    // MARK: - Message + Character Limit combination

    @Test func messageAndCharacterLimitCoexist() {
        let config = DSTextField.Configuration.outlined
            .message(.supporting("Max 20 characters"))
            .characterLimit(20)
        #expect(config.message?.text == "Max 20 characters")
        #expect(config.characterLimit == 20)
    }
}

// MARK: - DSFieldMessageRow Tests

@Suite("DSFieldMessageRow")
struct DSFieldMessageRowTests {

    @Test func supportingMessageIsNotError() {
        let message = DSFieldMessage.supporting("Helper")
        #expect(!message.isError)
        #expect(message.text == "Helper")
    }

    @Test func errorMessageIsError() {
        let message = DSFieldMessage.error("Bad")
        #expect(message.isError)
        #expect(message.text == "Bad")
    }
}
