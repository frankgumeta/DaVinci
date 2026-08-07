import Testing
import SwiftUI
@testable import DaVinciComponents

// MARK: - DSFieldMessage Tests

@Suite("DSFieldMessage")
struct DSFieldMessageTests {

    @Test func supportingIsNotError() {
        let message = DSFieldMessage.supporting("Helper text")
        #expect(!message.isError)
        #expect(message.text == "Helper text")
    }

    @Test func errorIsError() {
        let message = DSFieldMessage.error("Invalid")
        #expect(message.isError)
        #expect(message.text == "Invalid")
    }

    @Test func supportingAndErrorAreMutuallyExclusive() {
        // The enum type itself guarantees this: you can only construct
        // one or the other, never both.
        let supporting: DSFieldMessage = .supporting("A")
        let error: DSFieldMessage = .error("B")
        #expect(!supporting.isError)
        #expect(error.isError)
        #expect(supporting.text != error.text)
    }
}

// MARK: - DSTextField.Configuration Tests

@Suite("DSTextField.Configuration")
struct DSTextFieldConfigurationTests {

    // MARK: - Presets

    @Test func filledPresetDefaults() {
        let config = DSTextField.Configuration.filled
        #expect(config.appearance == .filled)
        #expect(config.labelVisibility == .visible)
        #expect(config.leading == nil)
        #expect(config.trailingAction == nil)
        #expect(config.message == nil)
        #expect(config.characterLimit == nil)
    }

    @Test func outlinedPresetDefaults() {
        let config = DSTextField.Configuration.outlined
        #expect(config.appearance == .outlined)
        #expect(config.labelVisibility == .visible)
        #expect(config.leading == nil)
        #expect(config.trailingAction == nil)
        #expect(config.message == nil)
        #expect(config.characterLimit == nil)
    }

    // MARK: - Builder immutability

    @Test func labelVisibilityBuilderReturnsCopy() {
        let original = DSTextField.Configuration.filled
        let modified = original.labelVisibility(.hidden)
        #expect(original.labelVisibility == .visible)
        #expect(modified.labelVisibility == .hidden)
        #expect(modified.appearance == original.appearance)
    }

    @Test func leadingBuilderReturnsCopy() throws {
        let symbol = try #require(DSSymbol(systemName: "person"))
        let original = DSTextField.Configuration.filled
        let modified = original.leading(symbol)
        #expect(original.leading == nil)
        #expect(modified.leading != nil)
        #expect(modified.appearance == original.appearance)
    }

    @Test func trailingBuilderReturnsCopy() {
        let original = DSTextField.Configuration.filled
        let modified = original.trailing(.clear)
        #expect(original.trailingAction == nil)
        #expect(modified.trailingAction == .clear)
    }

    @Test func messageBuilderReturnsCopy() {
        let original = DSTextField.Configuration.filled
        let modified = original.message(.supporting("Helper"))
        #expect(original.message == nil)
        #expect(modified.message?.text == "Helper")
        #expect(modified.message?.isError == false)
    }

    @Test func characterLimitBuilderReturnsCopy() {
        let original = DSTextField.Configuration.filled
        let modified = original.characterLimit(50)
        #expect(original.characterLimit == nil)
        #expect(modified.characterLimit == 50)
    }

    @Test func negativeCharacterLimitNormalizesToZero() {
        let config = DSTextField.Configuration.filled.characterLimit(-1)
        #expect(config.characterLimit == 0)
    }

    // MARK: - Chaining

    @Test func chainedBuildersCompose() throws {
        let person = try #require(DSSymbol(systemName: "person"))
        let config = DSTextField.Configuration.outlined
            .labelVisibility(.hidden)
            .leading(person)
            .trailing(.clear)
            .message(.supporting("Enter your name"))
            .characterLimit(30)

        #expect(config.appearance == .outlined)
        #expect(config.labelVisibility == .hidden)
        #expect(config.leading != nil)
        #expect(config.trailingAction == .clear)
        #expect(config.message?.text == "Enter your name")
        #expect(config.characterLimit == 30)
    }

    @Test func chainingDoesNotMutateOriginal() throws {
        let original = DSTextField.Configuration.filled
        _ = original
            .labelVisibility(.hidden)
            .trailing(.clear)
            .message(.error("Bad"))
            .characterLimit(10)

        #expect(original.labelVisibility == .visible)
        #expect(original.trailingAction == nil)
        #expect(original.message == nil)
        #expect(original.characterLimit == nil)
    }

    // MARK: - Message exclusivity in configuration

    @Test func configurationCanHoldSupportingOrErrorButNotBoth() {
        // Since message is a single optional DSFieldMessage, the type
        // guarantees only one kind is present at a time.
        let withSupporting = DSTextField.Configuration.filled
            .message(.supporting("Helper"))
        let withError = DSTextField.Configuration.filled
            .message(.error("Bad"))

        #expect(withSupporting.message?.isError == false)
        #expect(withError.message?.isError == true)

        // Calling .message twice replaces, not accumulates.
        let replaced = withSupporting.message(.error("Now bad"))
        #expect(replaced.message?.isError == true)
        #expect(replaced.message?.text == "Now bad")
    }
}

// MARK: - DSTextField Configuration Init Tests

@Suite("DSTextField Configuration Init")
@MainActor
struct DSTextFieldConfigurationInitTests {

    @Test func configurationInitPreservesMessage() {
        let field = DSTextField(
            "Email",
            text: .constant(""),
            configuration: .filled.message(.supporting("Helper"))
        )
        #expect(field.accessibilityDescriptor.label == "Email")
    }

    @Test func configurationInitErrorPropagatesToAccessibilityValue() {
        let field = DSTextField(
            "Email",
            text: .constant("bad@"),
            configuration: .filled.message(.error("Invalid"))
        )
        #expect(field.resolvedAccessibilityValue == "bad@. Error: Invalid")
    }

    @Test func configurationInitSupportingDoesNotAffectAccessibilityValue() {
        let field = DSTextField(
            "Email",
            text: .constant("good@email.com"),
            configuration: .filled.message(.supporting("Helper"))
        )
        // Supporting messages do not appear in the accessibility value.
        #expect(field.resolvedAccessibilityValue == "good@email.com")
        #expect(field.accessibilityDescriptor.hint == "Helper")
    }

    @Test func supportingMessageCombinesWithCustomAccessibilityHint() {
        let field = DSTextField(
            "Email",
            text: .constant(""),
            configuration: .filled.message(.supporting("Required for receipts")),
            accessibilityHint: "Enter your email"
        )
        #expect(field.accessibilityDescriptor.hint == "Enter your email. Required for receipts")
    }

    @Test func legacyErrorInitMatchesConfigurationErrorInit() {
        let legacy = DSTextField(
            "Email",
            text: .constant("bad@"),
            error: "Invalid"
        )
        let withConfig = DSTextField(
            "Email",
            text: .constant("bad@"),
            configuration: .filled.message(.error("Invalid"))
        )
        #expect(legacy.resolvedAccessibilityValue == withConfig.resolvedAccessibilityValue)
    }

    @Test func configurationInitHiddenLabelRetainsAccessibleLabel() {
        let field = DSTextField(
            "Search",
            text: .constant(""),
            configuration: .filled.labelVisibility(.hidden)
        )
        #expect(field.accessibilityDescriptor.label == "Search")
    }
}
