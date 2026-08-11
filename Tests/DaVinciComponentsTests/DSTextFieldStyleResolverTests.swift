import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSTextField Style Resolver Tests

@Suite("DSTextField Style Resolver")
@MainActor
struct DSTextFieldStyleResolverTests {

    private let theme = DSTheme.defaultTheme

    // MARK: - FieldState.resolve precedence

    @Test func disabledBeatsErrorAndFocus() {
        let state = DSTextField.FieldState.resolve(
            isEnabled: false, hasError: true, isFocused: true
        )
        #expect(state == .disabled)
    }

    @Test func errorBeatsFocus() {
        let state = DSTextField.FieldState.resolve(
            isEnabled: true, hasError: true, isFocused: true
        )
        #expect(state == .error)
    }

    @Test func focusedWhenNoErrorAndEnabled() {
        let state = DSTextField.FieldState.resolve(
            isEnabled: true, hasError: false, isFocused: true
        )
        #expect(state == .focused)
    }

    @Test func normalWhenIdle() {
        let state = DSTextField.FieldState.resolve(
            isEnabled: true, hasError: false, isFocused: false
        )
        #expect(state == .normal)
    }

    @Test func disabledWhenUnfocusedAndNoError() {
        let state = DSTextField.FieldState.resolve(
            isEnabled: false, hasError: false, isFocused: false
        )
        #expect(state == .disabled)
    }

    // MARK: - Resolver: disabled

    @Test func disabledUsesAttenuatedTertiaryBorder() {
        let filled = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .disabled, theme: theme
        )
        let outlined = DSTextFieldStyleResolver.resolve(
            appearance: .outlined, state: .disabled, theme: theme
        )
        let underlined = DSTextFieldStyleResolver.resolve(
            appearance: .underlined, state: .disabled, theme: theme
        )
        // Disabled should attenuate the border, not use the same opacity as normal.
        #expect(filled.borderWidth == StrokeTokens.hairline)
        #expect(outlined.borderWidth == StrokeTokens.hairline)
        #expect(underlined.borderWidth == StrokeTokens.hairline)
        // Both appearances share the same disabled treatment.
        #expect(filled.borderColor == outlined.borderColor)
        #expect(outlined.borderColor == underlined.borderColor)
    }

    // MARK: - Resolver: error

    @Test func errorUsesFeedbackErrorColor() {
        let filled = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .error, theme: theme
        )
        let outlined = DSTextFieldStyleResolver.resolve(
            appearance: .outlined, state: .error, theme: theme
        )
        #expect(filled.borderColor == theme.colors.feedback.error)
        #expect(outlined.borderColor == theme.colors.feedback.error)
    }

    @Test func errorDoesNotDependOnAppearance() {
        // Error semantics are the same regardless of appearance.
        let filled = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .error, theme: theme
        )
        let outlined = DSTextFieldStyleResolver.resolve(
            appearance: .outlined, state: .error, theme: theme
        )
        #expect(filled == outlined)
    }

    @Test func focusedErrorReinforcesBorderWithoutLosingErrorColor() {
        let resolved = DSTextFieldStyleResolver.resolve(
            appearance: .outlined,
            state: .error,
            isFocused: true,
            theme: theme
        )
        #expect(resolved.borderColor == theme.colors.feedback.error)
        #expect(resolved.borderWidth > StrokeTokens.hairline)
    }

    // MARK: - Resolver: focused

    @Test func focusedFilledUsesBrandPrimary() {
        let resolved = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .focused, theme: theme
        )
        #expect(resolved.borderColor == theme.colors.brand.primary)
        #expect(resolved.borderWidth == StrokeTokens.hairline)
    }

    @Test func focusedOutlinedUsesBrandPrimaryWithReinforcedWidth() {
        let resolved = DSTextFieldStyleResolver.resolve(
            appearance: .outlined, state: .focused, theme: theme
        )
        #expect(resolved.borderColor == theme.colors.brand.primary)
        #expect(resolved.borderWidth > StrokeTokens.hairline)
    }

    @Test func focusedUnderlinedUsesBrandPrimaryWithReinforcedWidth() {
        let resolved = DSTextFieldStyleResolver.resolve(
            appearance: .underlined, state: .focused, theme: theme
        )
        #expect(resolved.borderColor == theme.colors.brand.primary)
        #expect(resolved.borderWidth > StrokeTokens.hairline)
    }

    @Test func focusedDoesNotEliminateError() {
        // When both focus and error are present, error wins (precedence).
        // This test documents that focus alone would use brand.primary,
        // but error overrides it to feedback.error.
        let focusedOnly = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .focused, theme: theme
        )
        let errorState = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .error, theme: theme
        )
        #expect(focusedOnly.borderColor == theme.colors.brand.primary)
        #expect(errorState.borderColor == theme.colors.feedback.error)
        #expect(focusedOnly.borderColor != errorState.borderColor)
    }

    // MARK: - Resolver: normal

    @Test func normalFilledUsesTertiaryBorder() {
        let resolved = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .normal, theme: theme
        )
        #expect(resolved.borderColor == theme.colors.semantic.textTertiary)
        #expect(resolved.borderWidth == StrokeTokens.hairline)
    }

    @Test func normalOutlinedUsesTertiaryBorder() {
        let resolved = DSTextFieldStyleResolver.resolve(
            appearance: .outlined, state: .normal, theme: theme
        )
        #expect(resolved.borderColor == theme.colors.semantic.textTertiary)
        #expect(resolved.borderWidth == StrokeTokens.hairline)
    }

    @Test func normalUnderlinedUsesTertiaryBorder() {
        let resolved = DSTextFieldStyleResolver.resolve(
            appearance: .underlined, state: .normal, theme: theme
        )
        #expect(resolved.borderColor == theme.colors.semantic.textTertiary)
        #expect(resolved.borderWidth == StrokeTokens.hairline)
    }

    // MARK: - Disabled vs normal distinction

    @Test func disabledBorderIsVisuallyDistinctFromNormal() {
        let normal = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .normal, theme: theme
        )
        let disabled = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .disabled, theme: theme
        )
        // Disabled must not be identical to normal — it relies on opacity,
        // not just a different color, so it is distinguishable but not
        // solely via a hue change.
        #expect(normal.borderColor != disabled.borderColor)
    }

    @Test func errorBorderIsVisuallyDistinctFromNormal() {
        let normal = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .normal, theme: theme
        )
        let errorState = DSTextFieldStyleResolver.resolve(
            appearance: .filled, state: .error, theme: theme
        )
        #expect(normal.borderColor != errorState.borderColor)
    }
}
