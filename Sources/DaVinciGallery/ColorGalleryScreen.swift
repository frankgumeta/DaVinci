import SwiftUI
import DaVinciTokens

// MARK: - ColorGalleryScreen

struct ColorGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        List {
            grayScaleSection
            semanticSection
            surfaceStackSection
            brandSection
            accentSection
            feedbackSection
            textEmphasisSection
        }
        .navigationTitle("Colors")
    }

    // MARK: - GrayScale

    private var grayScaleSection: some View {
        Section("GrayScale") {
            colorRow("gray.900", color: GrayScale.gray900)
            colorRow("gray.800", color: GrayScale.gray800)
            colorRow("gray.700", color: GrayScale.gray700)
            colorRow("gray.600", color: GrayScale.gray600)
            colorRow("gray.500", color: GrayScale.gray500)
            colorRow("gray.400", color: GrayScale.gray400)
            colorRow("gray.300", color: GrayScale.gray300)
            colorRow("gray.200", color: GrayScale.gray200)
            colorRow("gray.100", color: GrayScale.gray100)
            colorRow("gray.050", color: GrayScale.gray050)
        }
    }

    // MARK: - Semantic

    private var semanticSection: some View {
        Section("Semantic") {
            colorRow("text.primary", color: theme.colors.semantic.textPrimary)
            colorRow("text.secondary", color: theme.colors.semantic.textSecondary)
            colorRow("text.tertiary", color: theme.colors.semantic.textTertiary)
            colorRow("text.disabled", color: theme.colors.semantic.textDisabled)
            colorRow("text.inverse", color: theme.colors.semantic.textInverse)
            colorRow("text.onBrand", color: theme.colors.semantic.textOnBrand)
            colorRow("bg.primary", color: theme.colors.semantic.bgPrimary)
            colorRow("bg.secondary", color: theme.colors.semantic.bgSecondary)
            colorRow("bg.tertiary", color: theme.colors.semantic.bgTertiary)
            colorRow("surface.primary", color: theme.colors.semantic.surfacePrimary)
            colorRow("surface.secondary", color: theme.colors.semantic.surfaceSecondary)
            colorRow("surface.elevated", color: theme.colors.semantic.surfaceElevated)
            colorRow("bg.scrim", color: theme.colors.semantic.bgScrim)
            colorRow("stroke", color: theme.colors.semantic.stroke)
            colorRow("divider", color: theme.colors.semantic.divider)
        }
    }

    // MARK: - Surface Stack

    private var surfaceStackSection: some View {
        Section("Surface Stack") {
            VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                Text("Background → Surface → Elevated")
                    .font(theme.typography.caption.font(family: theme.typography.family))
                    .foregroundStyle(theme.colors.semantic.textSecondary)

                ZStack(alignment: .topLeading) {
                    // bgPrimary base
                    RoundedRectangle(cornerRadius: RadiusTokens.medium)
                        .fill(theme.colors.semantic.bgPrimary)
                        .frame(height: 140)
                        .overlay(alignment: .topLeading) {
                            Text("bgPrimary")
                                .font(theme.typography.caption.font(family: theme.typography.family))
                                .foregroundStyle(theme.colors.semantic.textSecondary)
                                .padding(SpacingTokens.space2)
                        }

                    // surfacePrimary card
                    RoundedRectangle(cornerRadius: RadiusTokens.small)
                        .fill(theme.colors.semantic.surfacePrimary)
                        .frame(width: 220, height: 100)
                        .overlay(alignment: .topLeading) {
                            Text("surfacePrimary")
                                .font(theme.typography.caption.font(family: theme.typography.family))
                                .foregroundStyle(theme.colors.semantic.textSecondary)
                                .padding(SpacingTokens.space2)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: RadiusTokens.small)
                                .stroke(theme.colors.semantic.stroke, lineWidth: StrokeTokens.hairline)
                        )
                        .padding(.top, SpacingTokens.space4)
                        .padding(.leading, SpacingTokens.space3)

                    // surfaceElevated floating card
                    RoundedRectangle(cornerRadius: RadiusTokens.small)
                        .fill(theme.colors.semantic.surfaceElevated)
                        .frame(width: 160, height: 60)
                        .overlay(alignment: .topLeading) {
                            Text("surfaceElevated")
                                .font(theme.typography.caption.font(family: theme.typography.family))
                                .foregroundStyle(theme.colors.semantic.textPrimary)
                                .padding(SpacingTokens.space2)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: RadiusTokens.small)
                                .stroke(theme.colors.semantic.stroke, lineWidth: StrokeTokens.hairline)
                        )
                        .padding(.top, 70)
                        .padding(.leading, SpacingTokens.space5)
                }
            }

            HStack(spacing: SpacingTokens.space2) {
                separatorSwatch("divider", color: theme.colors.semantic.divider)
                separatorSwatch("stroke", color: theme.colors.semantic.stroke)
            }

            VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                Text("Accent bgAccent fill")
                    .font(theme.typography.caption.font(family: theme.typography.family))
                    .foregroundStyle(theme.colors.semantic.textSecondary)
                RoundedRectangle(cornerRadius: RadiusTokens.medium)
                    .fill(theme.colors.accent.bgAccent)
                    .frame(height: 44)
                    .overlay(alignment: .leading) {
                        Text("bgAccent")
                            .font(theme.typography.caption.font(family: theme.typography.family))
                            .foregroundStyle(theme.colors.semantic.textPrimary)
                            .padding(.leading, SpacingTokens.space3)
                    }
            }
        }
    }

    private func separatorSwatch(_ label: String, color: Color) -> some View {
        VStack(spacing: SpacingTokens.space1) {
            RoundedRectangle(cornerRadius: RadiusTokens.extraSmall)
                .fill(theme.colors.semantic.surfacePrimary)
                .frame(height: 40)
                .overlay {
                    Rectangle()
                        .fill(color)
                        .frame(height: StrokeTokens.default)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: RadiusTokens.extraSmall)
                        .stroke(theme.colors.semantic.stroke, lineWidth: StrokeTokens.hairline)
                )
            Text(label)
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textSecondary)
        }
    }

    // MARK: - Brand

    private var brandSection: some View {
        Section("Brand") {
            colorRow("brand.primary", color: theme.colors.brand.primary)
            colorRow("brand.secondary", color: theme.colors.brand.secondary)
            colorRow("brand.tertiary", color: theme.colors.brand.tertiary)
        }
    }

    // MARK: - Accent

    private var accentSection: some View {
        Section("Accent (semantic)") {
            colorRow("accent.bgAccent", color: theme.colors.accent.bgAccent)
            colorRow("accent.strokeAccent", color: theme.colors.accent.strokeAccent)

            VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                Text("bgAccent fill")
                    .font(theme.typography.caption.font(family: theme.typography.family))
                    .foregroundStyle(theme.colors.semantic.textSecondary)
                RoundedRectangle(cornerRadius: RadiusTokens.medium)
                    .fill(theme.colors.accent.bgAccent)
                    .frame(height: 44)
            }

            VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                Text("strokeAccent border")
                    .font(theme.typography.caption.font(family: theme.typography.family))
                    .foregroundStyle(theme.colors.semantic.textSecondary)
                RoundedRectangle(cornerRadius: RadiusTokens.medium)
                    .fill(theme.colors.semantic.surfacePrimary)
                    .frame(height: 44)
                    .overlay(
                        RoundedRectangle(cornerRadius: RadiusTokens.medium)
                            .stroke(theme.colors.accent.strokeAccent, lineWidth: StrokeTokens.default)
                    )
            }
        }
    }

    // MARK: - Feedback

    private var feedbackSection: some View {
        Section("Feedback") {
            colorRow("success", color: theme.colors.feedback.success)
            colorRow("warning", color: theme.colors.feedback.warning)
            colorRow("error", color: theme.colors.feedback.error)
            colorRow("info", color: theme.colors.feedback.info)
        }
    }

    // MARK: - TextEmphasis

    private var textEmphasisSection: some View {
        Section("Text Emphasis") {
            colorRow("text.brand", color: theme.colors.textEmphasis.brand)
            colorRow("text.success", color: theme.colors.textEmphasis.success)
            colorRow("text.warning", color: theme.colors.textEmphasis.warning)
            colorRow("text.error", color: theme.colors.textEmphasis.error)
            colorRow("text.info", color: theme.colors.textEmphasis.info)
        }
    }

    // MARK: - Helpers

    private func colorRow(_ name: String, color: Color) -> some View {
        HStack(spacing: SpacingTokens.space3) {
            RoundedRectangle(cornerRadius: RadiusTokens.extraSmall)
                .fill(color)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: RadiusTokens.extraSmall)
                        .stroke(
                            theme.colors.semantic.stroke,
                            lineWidth: StrokeTokens.hairline
                        )
                )

            Text(name)
                .font(
                    theme.typography.body.font(
                        family: theme.typography.family
                    )
                )
                .foregroundStyle(
                    theme.colors.semantic.textPrimary
                )

            Spacer()
        }
    }
}

// MARK: - Previews

#Preview("Colors — Light") {
    NavigationStack {
        ColorGalleryScreen()
    }
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.light)
}

#Preview("Colors — Dark") {
    NavigationStack {
        ColorGalleryScreen()
    }
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("Colors — Alternate Light") {
    NavigationStack {
        ColorGalleryScreen()
    }
    .dsTheme(.alternate)
    .preferredColorScheme(.light)
}

#Preview("Colors — Alternate Dark") {
    NavigationStack {
        ColorGalleryScreen()
    }
    .dsTheme(.alternate)
    .preferredColorScheme(.dark)
}
