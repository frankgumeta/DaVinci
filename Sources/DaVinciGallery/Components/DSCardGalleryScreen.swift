import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSCardGalleryScreen

struct DSCardGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Styles") {
                    DSCard(style: .standard) {
                        VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                            DSText("Standard", role: .headline)
                            DSText(
                                "Default surface, elevation, and radius tokens.",
                                role: .body,
                                color: theme.colors.semantic.textSecondary
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    DSCard(style: .compact) {
                        HStack(spacing: SpacingTokens.space3) {
                            Circle()
                                .fill(theme.colors.brand.primary)
                                .frame(width: 40, height: 40)
                            VStack(alignment: .leading, spacing: SpacingTokens.space1) {
                                DSText("Compact", role: .callout)
                                DSText(
                                    "Tighter padding, no shadow.",
                                    role: .caption,
                                    color: theme.colors.semantic.textTertiary
                                )
                            }
                            Spacer()
                        }
                    }

                    DSCard(style: .prominent) {
                        VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                            DSText("Prominent", role: .headline)
                            DSText(
                                "Generous padding with elevated shadow for hero content.",
                                role: .body,
                                color: theme.colors.semantic.textSecondary
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                GallerySection(title: "In Context") {
                    DSCard(style: .standard) {
                        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                            HStack {
                                DSText("Release 1.1.0", role: .headline)
                                Spacer()
                                DSBadge("New", variant: .brand)
                            }
                            DSText(
                                "DSBadge, DSDivider, DSProgressBar, DSSegmentedControl, DSSwitch.",
                                role: .body,
                                color: theme.colors.semantic.textSecondary
                            )
                            DSDivider(style: .hairline)
                            DSButton("View Changelog", variant: .outline) {}
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    DSCard(style: .compact) {
                        HStack(spacing: SpacingTokens.space3) {
                            DSText("Upload complete", role: .body)
                            Spacer()
                            DSBadge("Done", variant: .success)
                        }
                    }
                }

                GallerySection(title: "Edge Cases") {
                    DSCard(style: .standard) {
                        DSText("Minimal content", role: .body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    DSCard(style: .compact) {
                        DSText(
                            "A card with a very long text body that wraps across multiple lines " +
                            "to verify that padding and layout remain correct for all card styles.",
                            role: .body,
                            color: theme.colors.semantic.textSecondary
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    DSCard(style: .prominent) {
                        DSProgressBar(value: 0.65, size: .medium, label: "Loading…")
                    }
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Card")
    }
}

// MARK: - Previews

#Preview("DSCard — Light") {
    NavigationStack { DSCardGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSCard — Dark") {
    NavigationStack { DSCardGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
