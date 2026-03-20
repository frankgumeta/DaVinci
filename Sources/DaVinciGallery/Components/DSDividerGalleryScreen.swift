import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSDividerGalleryScreen

struct DSDividerGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Styles") {
                    DSText("Hairline (0.5pt)", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSDivider(style: .hairline)

                    DSText("Regular (1pt)", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSDivider(style: .regular)

                    DSText("Default — hairline", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSDivider()
                }

                GallerySection(title: "Orientation") {
                    DSText("Horizontal", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSDivider(orientation: .horizontal)

                    DSText("Vertical", role: .caption, color: theme.colors.semantic.textSecondary)
                    HStack(spacing: SpacingTokens.space4) {
                        DSText("Left", role: .body)
                        DSDivider(orientation: .vertical)
                            .frame(height: 40)
                        DSText("Right", role: .body)
                    }
                }

                GallerySection(title: "In Context") {
                    DSCard(style: .standard) {
                        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                            DSText("Section One", role: .headline)
                            DSText(
                                "Content above the divider.",
                                role: .body,
                                color: theme.colors.semantic.textSecondary
                            )
                            DSDivider()
                            DSText("Section Two", role: .headline)
                            DSText(
                                "Content below the divider.",
                                role: .body,
                                color: theme.colors.semantic.textSecondary
                            )
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    HStack(spacing: SpacingTokens.space4) {
                        DSText("Profile", role: .body)
                        DSDivider(orientation: .vertical).frame(height: 24)
                        DSText("Settings", role: .body)
                        DSDivider(orientation: .vertical).frame(height: 24)
                        DSText("Help", role: .body)
                    }
                }

                GallerySection(title: "Edge Cases") {
                    DSText("Multiple consecutive dividers", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSDivider(style: .hairline)
                    DSDivider(style: .regular)
                    DSDivider(style: .hairline)

                    DSText("Hairline between dense list items", role: .caption, color: theme.colors.semantic.textSecondary)
                    VStack(spacing: 0) {
                        DSText("Item one", role: .body)
                            .padding(.vertical, SpacingTokens.space2)
                        DSDivider(style: .hairline)
                        DSText("Item two", role: .body)
                            .padding(.vertical, SpacingTokens.space2)
                        DSDivider(style: .hairline)
                        DSText("Item three", role: .body)
                            .padding(.vertical, SpacingTokens.space2)
                    }
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Divider")
    }
}

// MARK: - Previews

#Preview("DSDivider — Light") {
    NavigationStack { DSDividerGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSDivider — Dark") {
    NavigationStack { DSDividerGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
