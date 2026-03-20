import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSBadgeGalleryScreen

struct DSBadgeGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Variants") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("Brand", variant: .brand)
                        DSBadge("Success", variant: .success)
                        DSBadge("Warning", variant: .warning)
                        DSBadge("Error", variant: .error)
                        DSBadge("Neutral", variant: .neutral)
                    }
                }

                GallerySection(title: "Sizes") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("Small", size: .small)
                        DSBadge("Medium", size: .medium)
                        DSBadge("Large", size: .large)
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("Error", variant: .error, size: .small)
                        DSBadge("Error", variant: .error, size: .medium)
                        DSBadge("Error", variant: .error, size: .large)
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
                        DSBadge("1", variant: .error)
                        DSBadge("12", variant: .error)
                        DSBadge("99+", variant: .error)
                    }
                }

                GallerySection(title: "Dot Indicators") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge(variant: .brand)
                        DSBadge(variant: .success)
                        DSBadge(variant: .warning)
                        DSBadge(variant: .error)
                        DSBadge(variant: .neutral)
                    }
                    DSText(
                        "With custom accessibility label",
                        role: .caption,
                        color: theme.colors.semantic.textSecondary
                    )
                    DSBadge(variant: .error, accessibilityLabel: "3 unread messages")
                }

                GallerySection(title: "In Context") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSText("Notifications", role: .body)
                        Spacer()
                        DSBadge("12", variant: .error)
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSText("Status", role: .body)
                        Spacer()
                        DSBadge("Active", variant: .success)
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSText("Review", role: .body)
                        Spacer()
                        DSBadge("Pending", variant: .warning)
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSText("Build", role: .body)
                        Spacer()
                        DSBadge("Failed", variant: .error)
                    }
                }

                GallerySection(title: "Edge Cases") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSBadge("W", variant: .brand)
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
