import Testing
import SwiftUI
@testable import DaVinciComponents

// MARK: - DSTextField Accessories Tests

@Suite("DSTextField Accessories")
@MainActor
struct DSTextFieldAccessoriesTests {

    // MARK: - Clear action visibility

    @Test func clearActionHiddenWhenTextIsEmpty() {
        #expect(!DSTextField.shouldShowTrailingAction(.clear, text: ""))
    }

    @Test func clearActionVisibleWhenTextIsNotEmpty() {
        #expect(DSTextField.shouldShowTrailingAction(.clear, text: "query"))
    }

    @Test func absentActionRemainsHidden() {
        #expect(!DSTextField.shouldShowTrailingAction(nil, text: "query"))
    }

    @Test func clearActionConfigured() {
        let config = DSTextField.Configuration.filled.trailing(.clear)
        #expect(config.trailingAction == .clear)
    }

    @Test func clearActionNotSetByDefault() {
        let config = DSTextField.Configuration.filled
        #expect(config.trailingAction == nil)
    }

    // MARK: - Leading symbol

    @Test func leadingSymbolConfigured() throws {
        let person = try #require(DSSymbol(systemName: "person"))
        let config = DSTextField.Configuration.filled.leading(person)
        #expect(config.leading != nil)
    }

    @Test func leadingSymbolNotSetByDefault() {
        let config = DSTextField.Configuration.filled
        #expect(config.leading == nil)
    }

    // MARK: - Accessibility preservation with accessories

    @Test func accessoriesDoNotChangeAccessibilityLabel() {
        let plain = DSTextField(
            "Email",
            text: .constant("test@test.com")
        )
        let withAccessories = DSTextField(
            "Email",
            text: .constant("test@test.com"),
            configuration: .filled
                .leading(DSSymbol(systemName: "envelope")!)
                .trailing(.clear)
        )
        #expect(plain.accessibilityDescriptor.label == withAccessories.accessibilityDescriptor.label)
    }

    @Test func accessoriesDoNotChangeAccessibilityValue() {
        let plain = DSTextField(
            "Email",
            text: .constant("test@test.com")
        )
        let withAccessories = DSTextField(
            "Email",
            text: .constant("test@test.com"),
            configuration: .filled
                .leading(DSSymbol(systemName: "envelope")!)
                .trailing(.clear)
        )
        #expect(plain.resolvedAccessibilityValue == withAccessories.resolvedAccessibilityValue)
    }

    // MARK: - Outlined appearance

    @Test func outlinedConfigurationPreservesAppearance() {
        let config = DSTextField.Configuration.outlined
        #expect(config.appearance == .outlined)
    }

    @Test func outlinedWithLeadingAndTrailing() throws {
        let person = try #require(DSSymbol(systemName: "person"))
        let config = DSTextField.Configuration.outlined
            .leading(person)
            .trailing(.clear)
        #expect(config.appearance == .outlined)
        #expect(config.leading != nil)
        #expect(config.trailingAction == .clear)
    }

    // MARK: - Filled vs outlined same accessibility

    @Test func filledAndOutlinedHaveSameAccessibilitySemantics() {
        let filled = DSTextField(
            "Email",
            text: .constant("test@test.com"),
            configuration: .filled
        )
        let outlined = DSTextField(
            "Email",
            text: .constant("test@test.com"),
            configuration: .outlined
        )
        #expect(filled.accessibilityDescriptor.label == outlined.accessibilityDescriptor.label)
        #expect(filled.resolvedAccessibilityValue == outlined.resolvedAccessibilityValue)
    }
}
