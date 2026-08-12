import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSBadgeGalleryScreen

struct DSBadgeGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Tones — Filled") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("Brand", tone: .brand)
                        DSBadge("Success", tone: .success)
                        DSBadge("Warning", tone: .warning)
                        DSBadge("Error", tone: .error)
                        DSBadge("Neutral", tone: .neutral)
                    }
                }

                GallerySection(title: "Appearances") {
                    appearanceRow(.filled)
                    appearanceRow(.subtle)
                    appearanceRow(.outlined)
                }

                GallerySection(title: "Appearance Dots") {
                    HStack(spacing: SpacingTokens.space4) {
                        DSBadge(tone: .brand, appearance: .filled)
                        DSBadge(tone: .success, appearance: .subtle)
                        DSBadge(tone: .warning, appearance: .subtle)
                        DSBadge(tone: .error, appearance: .outlined)
                        DSBadge(tone: .neutral, appearance: .outlined)
                    }
                }

                GallerySection(title: "Sizes") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("Small", size: .small)
                        DSBadge("Medium", size: .medium)
                        DSBadge("Large", size: .large)
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("Error", tone: .error, size: .small)
                        DSBadge("Error", tone: .error, size: .medium)
                        DSBadge("Error", tone: .error, size: .large)
                    }
                }

                GallerySection(title: "Numeric Badges") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("1")
                        DSBadge("5")
                        DSBadge("42")
                        DSBadge("99")
                        DSBadge("999+")
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("1", tone: .error)
                        DSBadge("12", tone: .error)
                        DSBadge("99+", tone: .error)
                    }
                }

                GallerySection(title: "Dot Indicators") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge(tone: .brand)
                        DSBadge(tone: .success)
                        DSBadge(tone: .warning)
                        DSBadge(tone: .error)
                        DSBadge(tone: .neutral)
                    }
                    DSText(
                        "With custom accessibility label",
                        role: .caption,
                        color: theme.colors.semantic.textSecondary
                    )
                    DSBadge(tone: .error, accessibilityLabel: "3 unread messages")
                }

                GallerySection(title: "In Context") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSText("Notifications", role: .body)
                        Spacer()
                        DSBadge("12", tone: .error)
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSText("Status", role: .body)
                        Spacer()
                        DSBadge("Active", tone: .success)
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSText("Review", role: .body)
                        Spacer()
                        DSBadge("Pending", tone: .warning)
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSText("Build", role: .body)
                        Spacer()
                        DSBadge("Failed", tone: .error)
                    }
                }

                GallerySection(title: "Edge Cases") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("W", tone: .brand)
                        DSBadge("Long label badge")
                        DSBadge("Very long label that tests wrapping")
                    }
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Badge")
    }

    private func appearanceRow(_ appearance: DSBadge.Appearance) -> some View {
        HStack(spacing: SpacingTokens.space2) {
            DSBadge("Brand", tone: .brand, appearance: appearance)
            DSBadge("Success", tone: .success, appearance: appearance)
            DSBadge("Warning", tone: .warning, appearance: appearance)
            DSBadge("Error", tone: .error, appearance: appearance)
            DSBadge("Neutral", tone: .neutral, appearance: appearance)
        }
    }
}

// MARK: - Previews

#Preview("DSBadge — Light") {
    NavigationStack { DSBadgeGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSBadge — Dark") {
    NavigationStack { DSBadgeGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
