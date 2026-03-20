import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSTextGalleryScreen

struct DSTextGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Roles") {
                    DSText("Display", role: .display)
                    DSText("Title", role: .title)
                    DSText("Headline", role: .headline)
                    DSText("Body — the main reading style.", role: .body)
                    DSText("Callout — supporting text.", role: .callout)
                    DSText("Caption — smallest named size.", role: .caption)
                    DSText("OVERLINE", role: .overline)
                }

                GallerySection(title: "Semantic Colors") {
                    DSText("textPrimary (default)", role: .body)
                    DSText("textSecondary", role: .body, color: theme.colors.semantic.textSecondary)
                    DSText("textTertiary", role: .body, color: theme.colors.semantic.textTertiary)
                    HStack(spacing: 0) {
                        DSText("textOnBrand", role: .body, color: theme.colors.semantic.textOnBrand)
                            .padding(.horizontal, SpacingTokens.space3)
                            .padding(.vertical, SpacingTokens.space2)
                            .background(theme.colors.brand.primary)
                            .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.small))
                    }
                }

                GallerySection(title: "Emphasis Colors") {
                    DSText("text.brand", role: .body, color: theme.colors.textEmphasis.brand)
                    DSText("text.success", role: .body, color: theme.colors.textEmphasis.success)
                    DSText("text.warning", role: .body, color: theme.colors.textEmphasis.warning)
                    DSText("text.error", role: .body, color: theme.colors.textEmphasis.error)
                    DSText("text.info", role: .body, color: theme.colors.textEmphasis.info)
                }

                GallerySection(title: "Edge Cases") {
                    DSText(
                        "This is a long body paragraph that wraps gracefully across multiple lines. " +
                        "It tests how text behaves in real content layouts where line height and spacing matter.",
                        role: .body
                    )
                    DSText(
                        "OVERLINE LABEL THAT IS INTENTIONALLY LONGER THAN USUAL",
                        role: .overline,
                        color: theme.colors.semantic.textTertiary
                    )
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Text")
    }
}

// MARK: - Previews

#Preview("DSText — Light") {
    NavigationStack { DSTextGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSText — Dark") {
    NavigationStack { DSTextGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
