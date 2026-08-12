import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSBadge Behavior Tests

@Suite("DSBadge Behavior")
@MainActor
struct DSBadgeBehaviorTests {

    // MARK: - Size Metrics

    @Test func sizeHorizontalPaddingProgression() {
        #expect(DSBadge.Size.small.horizontalPadding == SpacingTokens.space2)
        #expect(DSBadge.Size.medium.horizontalPadding == SpacingTokens.space3)
        #expect(DSBadge.Size.large.horizontalPadding == SpacingTokens.space4)
        #expect(DSBadge.Size.small.horizontalPadding < DSBadge.Size.medium.horizontalPadding)
        #expect(DSBadge.Size.medium.horizontalPadding < DSBadge.Size.large.horizontalPadding)
    }

    @Test func sizeVerticalPaddingValues() {
        #expect(DSBadge.Size.small.verticalPadding == SpacingTokens.space1)
        #expect(DSBadge.Size.medium.verticalPadding == SpacingTokens.space1)
        #expect(DSBadge.Size.large.verticalPadding == SpacingTokens.space2)
    }

    @Test func smallAndMediumShareVerticalPadding() {
        #expect(DSBadge.Size.small.verticalPadding == DSBadge.Size.medium.verticalPadding)
    }

    @Test func largeHasGreaterVerticalPaddingThanSmall() {
        #expect(DSBadge.Size.large.verticalPadding > DSBadge.Size.small.verticalPadding)
    }

    @Test func dotSizeProgression() {
        let small = DSBadge.Size.small.dotSize
        let medium = DSBadge.Size.medium.dotSize
        let large = DSBadge.Size.large.dotSize

        #expect(small == SpacingTokens.space2)
        #expect(medium == SpacingTokens.space3)
        #expect(large == SpacingTokens.space4)
        #expect(small < medium)
        #expect(medium < large)
    }

    @Test func sizeTextStyleMapping() {
        #expect(DSBadge.Size.small.textStyle == \DSTypography.overline)
        #expect(DSBadge.Size.medium.textStyle == \DSTypography.caption)
        #expect(DSBadge.Size.large.textStyle == \DSTypography.callout)
    }

    @Test func eachSizeMapsToDistinctTextStyle() {
        let styles: Set<KeyPath<DSTypography, DSTextStyle>> = [
            DSBadge.Size.small.textStyle,
            DSBadge.Size.medium.textStyle,
            DSBadge.Size.large.textStyle
        ]
        #expect(styles.count == 3)
    }

    // MARK: - Tone and Appearance

    @Test func allTonesAndAppearancesAreAvailable() {
        #expect(DSBadge.Tone.allCases.count == 5)
        #expect(DSBadge.Appearance.allCases == [.filled, .subtle, .outlined])
    }

    // MARK: - Filled Background Colors

    @Test func brandVariantUsesThemeBrandPrimary() {
        let theme = DSTheme.defaultTheme
        let color = DSBadge.backgroundColor(for: .brand, theme: theme)
        #expect(color == theme.colors.brand.primary)
    }

    @Test func successVariantUsesFeedbackSuccess() {
        let theme = DSTheme.defaultTheme
        let color = DSBadge.backgroundColor(for: .success, theme: theme)
        #expect(color == theme.colors.feedback.success)
    }

    @Test func warningVariantUsesFeedbackWarning() {
        let theme = DSTheme.defaultTheme
        let color = DSBadge.backgroundColor(for: .warning, theme: theme)
        #expect(color == theme.colors.feedback.warning)
    }

    @Test func errorVariantUsesFeedbackError() {
        let theme = DSTheme.defaultTheme
        let color = DSBadge.backgroundColor(for: .error, theme: theme)
        #expect(color == theme.colors.feedback.error)
    }

    @Test func neutralVariantUsesBgTertiary() {
        let theme = DSTheme.defaultTheme
        let color = DSBadge.backgroundColor(for: .neutral, theme: theme)
        #expect(color == theme.colors.semantic.bgTertiary)
    }

    @Test func subtleAppearanceUsesTintedBackgroundAndHairlineBorder() {
        let theme = DSTheme.defaultTheme.resolved(for: .light)

        for tone in DSBadge.Tone.allCases {
            let style = DSBadgeStyleResolver.resolve(
                tone: tone,
                appearance: .subtle,
                theme: theme,
                colorScheme: .light
            )
            #expect(style.backgroundColor == DSBadgeStyleResolver.toneColor(for: tone, theme: theme)
                .opacity(OpacityTokens.subtleFill))
            #expect(style.foregroundColor == theme.colors.semantic.textPrimary)
            #expect(style.borderWidth == StrokeTokens.hairline)
        }
    }

    @Test func outlinedAppearanceUsesTransparentFillAndSemanticBorder() {
        let theme = DSTheme.defaultTheme.resolved(for: .light)

        for tone in DSBadge.Tone.allCases {
            let style = DSBadgeStyleResolver.resolve(
                tone: tone,
                appearance: .outlined,
                theme: theme,
                colorScheme: .light
            )
            #expect(style.backgroundColor == Color.clear)
            #expect(style.foregroundColor == theme.colors.semantic.textPrimary)
            #expect(style.borderColor == DSBadgeStyleResolver.toneColor(for: tone, theme: theme))
            #expect(style.borderWidth == StrokeTokens.hairline)
        }
    }

    @Test func filledAppearancePreservesLegacyColorResolution() {
        let theme = DSTheme.defaultTheme.resolved(for: .light)

        for tone in DSBadge.Tone.allCases {
            let style = DSBadgeStyleResolver.resolve(
                tone: tone,
                appearance: .filled,
                theme: theme,
                colorScheme: .light
            )
            #expect(style.backgroundColor == DSBadge.backgroundColor(for: tone, theme: theme))
            #expect(style.borderWidth == 0)
        }
    }

    // MARK: - Variant Foreground Colors

    @Test func everyToneAndAppearanceMeetsNormalTextContrast() throws {
        for colorScheme in [ColorScheme.light, .dark] {
            let theme = DSTheme.defaultTheme.resolved(for: colorScheme)

            for tone in DSBadge.Tone.allCases {
                for appearance in DSBadge.Appearance.allCases {
                    let style = DSBadgeStyleResolver.resolve(
                        tone: tone,
                        appearance: appearance,
                        theme: theme,
                        colorScheme: colorScheme
                    )
                    let effectiveBackground = appearance == .filled
                        ? style.backgroundColor
                        : theme.colors.semantic.surfacePrimary
                    let ratio = DSColorContrast.ratio(
                        foreground: style.foregroundColor,
                        background: effectiveBackground,
                        colorScheme: colorScheme
                    )
                    #expect(try #require(ratio) >= 4.5)
                }
            }
        }
    }

    // MARK: - Accessibility Label Resolution

    @Test @MainActor func textBadgeUsesTextAsAccessibilityLabel() {
        let badge = DSBadge("New")
        #expect(badge.resolvedAccessibilityLabel == "New")
    }

    @Test @MainActor func dotBadgeUsesDefaultAccessibilityLabel() {
        let badge = DSBadge(tone: .error)
        #expect(badge.resolvedAccessibilityLabel == "Notification indicator")
    }

    @Test @MainActor func customAccessibilityLabelOverridesText() {
        let badge = DSBadge("5", accessibilityLabel: "5 notifications")
        #expect(badge.resolvedAccessibilityLabel == "5 notifications")
    }

    @Test @MainActor func customAccessibilityLabelOverridesDotDefault() {
        let badge = DSBadge(tone: .error, accessibilityLabel: "3 unread messages")
        #expect(badge.resolvedAccessibilityLabel == "3 unread messages")
    }

    @Test @MainActor func numericTextBadgeUsesNumberAsLabel() {
        let badge = DSBadge("99+")
        #expect(badge.resolvedAccessibilityLabel == "99+")
    }

    // MARK: - Variant Hashable / Equatable

    @Test func variantConformsToHashable() {
        let set: Set<DSBadge.Tone> = [.brand, .success, .warning, .error, .neutral]
        #expect(set.count == 5)
    }

    @Test func allVariantsAreDistinct() {
        let variants: [DSBadge.Tone] = [.brand, .success, .warning, .error, .neutral]
        for i in variants.indices {
            for j in variants.indices where i != j {
                #expect(variants[i] != variants[j])
            }
        }
    }
}
