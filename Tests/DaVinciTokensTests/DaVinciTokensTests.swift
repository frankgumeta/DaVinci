import Foundation
import SwiftUI
import Testing
@testable import DaVinciTokens

// MARK: - Semantic Mapping Defaults

@Suite("SemanticColors Defaults")
struct SemanticColorsDefaultsTests {

    @Test func textPrimaryMapsToGray900() {
        let semantic = SemanticColors()
        #expect(semantic.textPrimary == GrayScale.gray900)
    }

    @Test func textSecondaryMapsToGray600() {
        let semantic = SemanticColors()
        #expect(semantic.textSecondary == GrayScale.gray600)
    }

    @Test func textTertiaryMapsToGray500() {
        let semantic = SemanticColors()
        #expect(semantic.textTertiary == GrayScale.gray500)
    }

    @Test func textDisabledMapsToGray400() {
        let semantic = SemanticColors()
        #expect(semantic.textDisabled == GrayScale.gray400)
    }

    @Test func textInverseMapsToGray050() {
        let semantic = SemanticColors()
        #expect(semantic.textInverse == GrayScale.gray050)
    }

    @Test func textOnBrandMapsToGray050() {
        let semantic = SemanticColors()
        #expect(semantic.textOnBrand == GrayScale.gray050)
    }

    @Test func bgPrimaryMapsToGray050() {
        let semantic = SemanticColors()
        #expect(semantic.bgPrimary == GrayScale.gray050)
    }

    @Test func bgSecondaryMapsToGray100() {
        let semantic = SemanticColors()
        #expect(semantic.bgSecondary == GrayScale.gray100)
    }

    @Test func surfacePrimaryMapsToGray050() {
        let semantic = SemanticColors()
        #expect(semantic.surfacePrimary == GrayScale.gray050)
    }

    @Test func strokeMapsToGray200() {
        let semantic = SemanticColors()
        #expect(semantic.stroke == GrayScale.gray200)
    }

    @Test func dividerMapsToGray100() {
        let semantic = SemanticColors()
        #expect(semantic.divider == GrayScale.gray100)
    }

    @Test func surfaceElevatedMapsToGray050() {
        let semantic = SemanticColors()
        #expect(semantic.surfaceElevated == GrayScale.gray050)
    }

    @Test func bgScrimMapsToGray900WithScrimOpacity() {
        let semantic = SemanticColors()
        #expect(semantic.bgScrim == GrayScale.gray900.opacity(OpacityTokens.scrim))
    }

    @Test func skeletonMapsToGray200() {
        let semantic = SemanticColors()
        #expect(semantic.skeleton == GrayScale.gray200)
    }
}

// MARK: - TextEmphasis Default Mapping

@Suite("TextEmphasisColors Defaults")
struct TextEmphasisColorsDefaultsTests {

    @Test func textBrandMapsToBrandPrimary() {
        let brand = BrandColors()
        let feedback = FeedbackColors()
        let emphasis = TextEmphasisColors(brand: brand.primary, feedback: feedback)
        #expect(emphasis.brand == brand.primary)
    }

    @Test func textSuccessMapsToFeedbackSuccess() {
        let feedback = FeedbackColors()
        let emphasis = TextEmphasisColors(brand: BrandColors().primary, feedback: feedback)
        #expect(emphasis.success == feedback.success)
    }

    @Test func textWarningMapsToFeedbackWarning() {
        let feedback = FeedbackColors()
        let emphasis = TextEmphasisColors(brand: BrandColors().primary, feedback: feedback)
        #expect(emphasis.warning == feedback.warning)
    }

    @Test func textErrorMapsToFeedbackError() {
        let feedback = FeedbackColors()
        let emphasis = TextEmphasisColors(brand: BrandColors().primary, feedback: feedback)
        #expect(emphasis.error == feedback.error)
    }

    @Test func textInfoMapsToFeedbackInfo() {
        let feedback = FeedbackColors()
        let emphasis = TextEmphasisColors(brand: BrandColors().primary, feedback: feedback)
        #expect(emphasis.info == feedback.info)
    }
}

// MARK: - Theme Override

@Suite("DSTheme Override")
struct DSThemeOverrideTests {

    @Test func customBrandPrimaryChangesTextBrand() {
        let customBrand = Color.red
        let colors = DSColors(brand: BrandColors(primary: customBrand))
        let theme = DSTheme(colors: colors)

        #expect(theme.colors.brand.primary == customBrand)
        #expect(theme.colors.textEmphasis.brand == customBrand)
    }

    @Test func customFeedbackOverridesTextEmphasis() {
        let customFeedback = FeedbackColors(
            success: .green,
            warning: .orange,
            error: .pink,
            info: .purple
        )
        let colors = DSColors(feedback: customFeedback)
        let theme = DSTheme(colors: colors)

        #expect(theme.colors.textEmphasis.success == .green)
        #expect(theme.colors.textEmphasis.warning == .orange)
        #expect(theme.colors.textEmphasis.error == .pink)
        #expect(theme.colors.textEmphasis.info == .purple)
    }

    @Test func explicitTextEmphasisOverridesTakesPrecedence() {
        let customEmphasis = TextEmphasisColors(
            brand: .yellow,
            success: .mint,
            warning: .brown,
            error: .cyan,
            info: .indigo
        )
        let colors = DSColors(textEmphasis: customEmphasis)
        let theme = DSTheme(colors: colors)

        #expect(theme.colors.textEmphasis.brand == .yellow)
        #expect(theme.colors.textEmphasis.success == .mint)
    }

    @Test func defaultThemeUsesDefaultValues() {
        let theme = DSTheme.defaultTheme
        let defaultBrand = BrandColors()
        let defaultSemantic = SemanticColors()

        #expect(theme.colors.brand.primary == defaultBrand.primary)
        #expect(theme.colors.semantic.textPrimary == defaultSemantic.textPrimary)
    }

    @Test func convenienceColorsInitCreatesUniformPalette() {
        let colors = DSColors(brand: BrandColors(primary: .red))
        let theme = DSTheme(colors: colors)
        #expect(theme.palette.light.brand.primary == .red)
        #expect(theme.palette.dark.brand.primary == .red)
    }
}

// MARK: - DSPalette

@Suite("DSPalette")
struct DSPaletteTests {

    @Test func resolvedLightReturnsLightColors() {
        let palette = DSPalette.default
        let resolved = palette.resolved(for: .light)
        #expect(resolved.semantic.textPrimary == GrayScale.gray900)
        #expect(resolved.semantic.bgPrimary == GrayScale.gray050)
    }

    @Test func resolvedDarkReturnsDarkColors() {
        let palette = DSPalette.default
        let resolved = palette.resolved(for: .dark)
        #expect(resolved.semantic.textPrimary == GrayScale.gray050)
        #expect(resolved.semantic.bgPrimary == GrayScale.gray900)
    }

    @Test func uniformPaletteReturnsSameForBothSchemes() {
        let colors = DSColors(brand: BrandColors(primary: .red))
        let palette = DSPalette(uniform: colors)
        #expect(palette.resolved(for: .light).brand.primary == .red)
        #expect(palette.resolved(for: .dark).brand.primary == .red)
    }

    @Test func themeResolvedForDarkUsesDarkPalette() {
        let theme = DSTheme.defaultTheme.resolved(for: .dark)
        #expect(theme.colors.semantic.textPrimary == GrayScale.gray050)
        #expect(theme.colors.semantic.bgPrimary == GrayScale.gray900)
    }

    @Test func darkSemanticDefaultsInvertGrayScale() {
        let dark = SemanticColors.darkDefaults
        #expect(dark.textPrimary == GrayScale.gray050)
        #expect(dark.textSecondary == GrayScale.gray300)
        #expect(dark.textTertiary == GrayScale.gray400)
        #expect(dark.textDisabled == GrayScale.gray500)
        #expect(dark.textInverse == GrayScale.gray900)
        #expect(dark.textOnBrand == GrayScale.gray050)
        #expect(dark.bgPrimary == GrayScale.gray900)
        #expect(dark.bgSecondary == GrayScale.gray800)
        #expect(dark.bgTertiary == GrayScale.gray700)
        #expect(dark.surfacePrimary == GrayScale.gray800)
        #expect(dark.surfaceSecondary == GrayScale.gray700)
        #expect(dark.surfaceElevated == GrayScale.gray600)
        #expect(dark.stroke == GrayScale.gray700)
        #expect(dark.divider == GrayScale.gray800)
        #expect(dark.skeleton == GrayScale.gray700)
    }

    @Test func darkSurfaceHierarchyHasClearSeparation() {
        let dark = SemanticColors.darkDefaults
        // Elevated is distinct from secondary, secondary from primary
        #expect(dark.surfaceElevated != dark.surfaceSecondary)
        #expect(dark.surfaceSecondary != dark.surfacePrimary)
        // Divider is subtler (closer to bg) than stroke
        #expect(dark.divider != dark.stroke)
    }

    @Test func darkAccentOpacityHigherThanLight() {
        let palette = DSPalette.default
        let lightAccent = palette.light.accent.bgAccent
        let darkAccent = palette.dark.accent.bgAccent
        // They should be different (dark uses 0.18, light uses 0.12)
        #expect(lightAccent != darkAccent)
    }
}

// MARK: - Opacity Tokens

@Suite("OpacityTokens")
struct OpacityTokensTests {

    @Test func opacityValues() {
        #expect(OpacityTokens.disabled == 0.4)
        #expect(OpacityTokens.pressed == 0.85)
        #expect(OpacityTokens.scrim == 0.35)
        #expect(OpacityTokens.shimmerHighlight == 0.55)
        #expect(OpacityTokens.shimmerStatic == 0.30)
    }
}

// MARK: - Spacing Tokens

@Suite("SpacingTokens")
struct SpacingTokensTests {

    @Test func spacingScaleIsAscending() {
        let scale: [CGFloat] = [
            SpacingTokens.space1,
            SpacingTokens.space2,
            SpacingTokens.space3,
            SpacingTokens.space4,
            SpacingTokens.space5,
            SpacingTokens.space6,
            SpacingTokens.space7,
            SpacingTokens.space8
        ]
        for i in 0..<scale.count - 1 {
            #expect(scale[i] < scale[i + 1])
        }
    }

    @Test func space4Is16() {
        #expect(SpacingTokens.space4 == 16)
    }
}

// MARK: - Radius Tokens

@Suite("RadiusTokens")
struct RadiusTokensTests {

    @Test func radiusValues() {
        #expect(RadiusTokens.extraSmall == 6)
        #expect(RadiusTokens.small == 10)
        #expect(RadiusTokens.medium == 14)
        #expect(RadiusTokens.large == 20)
    }

    @Test func radiusScaleIsAscending() {
        let scale: [CGFloat] = [
            RadiusTokens.extraSmall,
            RadiusTokens.small,
            RadiusTokens.medium,
            RadiusTokens.large
        ]
        for i in 0..<scale.count - 1 {
            #expect(scale[i] < scale[i + 1])
        }
    }
}

// MARK: - Skeleton Tokens

@Suite("SkeletonTokens")
struct SkeletonTokensTests {

    @Test func rowTokenValues() {
        #expect(SkeletonTokens.avatarSize == 40)
        #expect(SkeletonTokens.rowLineHeightPrimary == 14)
        #expect(SkeletonTokens.rowLineHeightSecondary == 12)
        #expect(SkeletonTokens.rowLineWidthPrimary == 140)
        #expect(SkeletonTokens.rowLineWidthSecondary == 200)
        #expect(SkeletonTokens.trailingChipHeight == 28)
        #expect(SkeletonTokens.trailingChipWidth == 60)
    }

    @Test func cardTokenValues() {
        #expect(SkeletonTokens.cardIconSize == 36)
        #expect(SkeletonTokens.cardTitleHeight == 14)
        #expect(SkeletonTokens.cardTitleWidth == 120)
        #expect(SkeletonTokens.cardSubtitleHeight == 10)
        #expect(SkeletonTokens.cardSubtitleWidth == 80)
        #expect(SkeletonTokens.cardBodyLineHeight == 12)
        #expect(SkeletonTokens.cardBodyShortWidth == 180)
        #expect(SkeletonTokens.cardFooterHeight == 32)
        #expect(SkeletonTokens.cardFooterWidth == 100)
    }
}

@Suite("StrokeTokens")
struct StrokeTokensTests {

    @Test func strokeTokensHaveCorrectValues() {
        #expect(StrokeTokens.hairline == 1)
        #expect(StrokeTokens.default == 2)
    }

    @Test func strokeTokensAreAscending() {
        #expect(StrokeTokens.hairline < StrokeTokens.default)
    }
}

// MARK: - Radius tokens are ascending
@Test func radiusTokensAreAscending() {
    #expect(RadiusTokens.extraSmall < RadiusTokens.small)
    #expect(RadiusTokens.small < RadiusTokens.medium)
    #expect(RadiusTokens.medium < RadiusTokens.large)
}

@Test func radiusTokensHaveCorrectValues() {
    #expect(RadiusTokens.extraSmall == 6)
    #expect(RadiusTokens.small == 10)
    #expect(RadiusTokens.medium == 14)
    #expect(RadiusTokens.large == 20)
}

// MARK: - Opacity tokens
@Test func opacityTokensAreValid() {
    #expect(OpacityTokens.disabled >= 0 && OpacityTokens.disabled <= 1)
    #expect(OpacityTokens.pressed >= 0 && OpacityTokens.pressed <= 1)
    #expect(OpacityTokens.scrim >= 0 && OpacityTokens.scrim <= 1)
    #expect(OpacityTokens.shimmerHighlight >= 0 && OpacityTokens.shimmerHighlight <= 1)
    #expect(OpacityTokens.shimmerStatic >= 0 && OpacityTokens.shimmerStatic <= 1)
}

@Test func opacityTokensHaveCorrectValues() {
    #expect(OpacityTokens.disabled == 0.4)
    #expect(OpacityTokens.pressed == 0.85)
    #expect(OpacityTokens.scrim == 0.35)
    #expect(OpacityTokens.shimmerHighlight == 0.55)
    #expect(OpacityTokens.shimmerStatic == 0.30)
}

@Test func disabledOpacityIsLowerThanPressed() {
    #expect(OpacityTokens.disabled < OpacityTokens.pressed)
}

// MARK: - Elevation tokens
@Test func elevationNoneHasZeroValues() {
    let none = ElevationTokens.none
    #expect(none.radius == 0)
    #expect(none.x == 0)
    #expect(none.y == 0)
}

@Test func elevationSmallHasCorrectValues() {
    let small = ElevationTokens.small
    #expect(small.radius == 4)
    #expect(small.x == 0)
    #expect(small.y == 2)
}

@Test func elevationMediumHasCorrectValues() {
    let medium = ElevationTokens.medium
    #expect(medium.radius == 8)
    #expect(medium.x == 0)
    #expect(medium.y == 4)
}

@Test func elevationRadiusIsAscending() {
    #expect(ElevationTokens.none.radius < ElevationTokens.small.radius)
    #expect(ElevationTokens.small.radius < ElevationTokens.medium.radius)
}

@Test func elevationYOffsetIsAscending() {
    #expect(ElevationTokens.none.y < ElevationTokens.small.y)
    #expect(ElevationTokens.small.y < ElevationTokens.medium.y)
}

@Test func customElevationCreates() {
    let custom = DSElevation(color: .red, radius: 10, x: 2, y: 3)
    #expect(custom.radius == 10)
    #expect(custom.x == 2)
    #expect(custom.y == 3)
}

// MARK: - Card Style tokens
@Test func cardStylePaddingIsAscending() {
    #expect(DSCardStyle.compact.padding < DSCardStyle.standard.padding)
    #expect(DSCardStyle.standard.padding < DSCardStyle.prominent.padding)
}

@Test func cardStyleCompactHasCorrectTokens() {
    #expect(DSCardStyle.compact.padding == SpacingTokens.space3)
    #expect(DSCardStyle.compact.cornerRadius == RadiusTokens.medium)
    #expect(DSCardStyle.compact.elevation.radius == 0)
}

@Test func cardStyleStandardHasCorrectTokens() {
    #expect(DSCardStyle.standard.padding == SpacingTokens.space4)
    #expect(DSCardStyle.standard.cornerRadius == RadiusTokens.large)
    #expect(DSCardStyle.standard.elevation.radius == 4)
}

@Test func cardStyleProminentHasCorrectTokens() {
    #expect(DSCardStyle.prominent.padding == SpacingTokens.space5)
    #expect(DSCardStyle.prominent.cornerRadius == RadiusTokens.large)
    #expect(DSCardStyle.prominent.elevation.radius == 8)
}

@Test func cardStyleElevationIsAscending() {
    #expect(DSCardStyle.compact.elevation.radius < DSCardStyle.standard.elevation.radius)
    #expect(DSCardStyle.standard.elevation.radius < DSCardStyle.prominent.elevation.radius)
}

// MARK: - List Spacing tokens
@Test func listSpacingCompactIsZero() {
    #expect(DSListSpacing.compact.value == 0)
}

@Test func listSpacingComfortableHasCorrectValue() {
    #expect(DSListSpacing.comfortable.value == SpacingTokens.space2)
    #expect(DSListSpacing.comfortable.value == 8)
}

@Test func listSpacingSpaciousHasCorrectValue() {
    #expect(DSListSpacing.spacious.value == SpacingTokens.space3)
    #expect(DSListSpacing.spacious.value == 12)
}

@Test func listSpacingIsAscending() {
    #expect(DSListSpacing.compact.value < DSListSpacing.comfortable.value)
    #expect(DSListSpacing.comfortable.value < DSListSpacing.spacious.value)
}

// MARK: - Skeleton tokens
@Test func skeletonRowTokensArePositive() {
    #expect(SkeletonTokens.avatarSize > 0)
    #expect(SkeletonTokens.rowLineHeightPrimary > 0)
    #expect(SkeletonTokens.rowLineHeightSecondary > 0)
    #expect(SkeletonTokens.rowLineWidthPrimary > 0)
    #expect(SkeletonTokens.rowLineWidthSecondary > 0)
    #expect(SkeletonTokens.trailingChipHeight > 0)
    #expect(SkeletonTokens.trailingChipWidth > 0)
}

@Test func skeletonCardTokensArePositive() {
    #expect(SkeletonTokens.cardIconSize > 0)
    #expect(SkeletonTokens.cardTitleHeight > 0)
    #expect(SkeletonTokens.cardTitleWidth > 0)
    #expect(SkeletonTokens.cardSubtitleHeight > 0)
    #expect(SkeletonTokens.cardSubtitleWidth > 0)
    #expect(SkeletonTokens.cardBodyLineHeight > 0)
    #expect(SkeletonTokens.cardBodyShortWidth > 0)
    #expect(SkeletonTokens.cardFooterHeight > 0)
    #expect(SkeletonTokens.cardFooterWidth > 0)
}

@Test func skeletonRowPrimaryIsLargerThanSecondary() {
    #expect(SkeletonTokens.rowLineHeightPrimary > SkeletonTokens.rowLineHeightSecondary)
}

@Test func skeletonCardTitleIsLargerThanSubtitle() {
    #expect(SkeletonTokens.cardTitleHeight > SkeletonTokens.cardSubtitleHeight)
}

// MARK: - ControlHeight Tokens

@Suite("ControlHeightTokens")
struct ControlHeightTokensTests {

    @Test func controlHeightValues() {
        #expect(ControlHeightTokens.small == 32)
        #expect(ControlHeightTokens.medium == 40)
        #expect(ControlHeightTokens.large == 50)
    }

    @Test func controlHeightScaleIsAscending() {
        #expect(ControlHeightTokens.small < ControlHeightTokens.medium)
        #expect(ControlHeightTokens.medium < ControlHeightTokens.large)
    }
}

// MARK: - Motion Tokens

@Suite("DSMotion")
struct DSMotionTests {

    @Test func defaultDurations() {
        let motion = DSMotion()
        #expect(motion.fast == 0.15)
        #expect(motion.normal == 0.25)
        #expect(motion.slow == 0.35)
    }

    @Test func durationScaleIsAscending() {
        let motion = DSMotion()
        #expect(motion.fast < motion.normal)
        #expect(motion.normal < motion.slow)
    }

    @Test func shimmerDurationDefaultsTo1Point2() {
        let motion = DSMotion()
        #expect(motion.shimmerDuration == 1.2)
    }

    @Test func shimmerDurationCustomOverride() {
        let motion = DSMotion(shimmerDuration: 1.5)
        #expect(motion.shimmerDuration == 1.5)
    }
}

// MARK: - Typography Tokens

@Suite("DSTypography")
struct DSTypographyTests {

    @Test func fontSizeScaleIsAscending() {
        let typo = DSTypography()
        let sizes: [CGFloat] = [
            typo.overline.size,
            typo.caption.size,
            typo.callout.size,
            typo.body.size,
            typo.headline.size,
            typo.title.size,
            typo.display.size
        ]
        for i in 0..<sizes.count - 1 {
            #expect(sizes[i] < sizes[i + 1])
        }
    }

    @Test func defaultFamilyIsSystem() {
        let family = FontFamily()
        #expect(family.brand == nil)
        #expect(family.resolved == Font.systemFontFamilyName)
    }

    @Test func customFamilyOverridesResolved() {
        let family = FontFamily(brand: "Avenir")
        #expect(family.resolved == "Avenir")
    }

    @Test func allowedWeightMapsToFontWeight() {
        #expect(AllowedWeight.regular.fontWeight == Font.Weight.regular)
        #expect(AllowedWeight.medium.fontWeight == Font.Weight.medium)
        #expect(AllowedWeight.semibold.fontWeight == Font.Weight.semibold)
        #expect(AllowedWeight.bold.fontWeight == Font.Weight.bold)
    }

    @Test func textStyleFontWithSystemFamily() {
        let style = DSTextStyle(size: 16, lineHeight: 24, weight: .regular)
        let systemFamily = FontFamily()
        let font = style.font(family: systemFamily)

        #expect(font == Font.system(size: 16, weight: .regular))
    }

    @Test func textStyleFontWithBrandFamily() {
        let style = DSTextStyle(size: 18, lineHeight: 28, weight: .bold)
        let brandFamily = FontFamily(brand: "Helvetica")
        let font = style.font(family: brandFamily)

        #expect(font == Font.custom("Helvetica", size: 18))
    }

    @Test func textStyleFontRespectsSize() {
        let style = DSTextStyle(size: 24, lineHeight: 32, weight: .medium)
        let font = style.font(family: FontFamily())

        #expect(font == Font.system(size: 24, weight: .medium))
    }

    @Test func allTypographyStylesGenerateFont() {
        let typo = DSTypography()
        let family = FontFamily()

        let displayFont = typo.display.font(family: family)
        let titleFont = typo.title.font(family: family)
        let headlineFont = typo.headline.font(family: family)
        let bodyFont = typo.body.font(family: family)
        let calloutFont = typo.callout.font(family: family)
        let captionFont = typo.caption.font(family: family)
        let overlineFont = typo.overline.font(family: family)

        #expect(displayFont == Font.system(size: typo.display.size, weight: typo.display.weight))
        #expect(titleFont == Font.system(size: typo.title.size, weight: typo.title.weight))
        #expect(headlineFont == Font.system(size: typo.headline.size, weight: typo.headline.weight))
        #expect(bodyFont == Font.system(size: typo.body.size, weight: typo.body.weight))
        #expect(calloutFont == Font.system(size: typo.callout.size, weight: typo.callout.weight))
        #expect(captionFont == Font.system(size: typo.caption.size, weight: typo.caption.weight))
        #expect(overlineFont == Font.system(size: typo.overline.size, weight: typo.overline.weight))
    }
}
