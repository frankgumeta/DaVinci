import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSIconButtonGalleryScreen

struct DSIconButtonGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Variants") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .primary) {}
                        DSIconButton(systemName: "gearshape", titleForAccessibility: "Settings", variant: .secondary) {}
                        DSIconButton(systemName: "pencil", titleForAccessibility: "Edit", variant: .outline) {}
                    }
                }

                GallerySection(title: "Sizes") {
                    HStack(spacing: SpacingTokens.space4) {
                        VStack(spacing: SpacingTokens.space2) {
                            DSIconButton(
                                systemName: "heart.fill",
                                titleForAccessibility: "Like (Small)",
                                variant: .primary,
                                size: .small
                            ) {}
                            DSText("small", role: .caption, color: theme.colors.semantic.textTertiary)
                        }
                        VStack(spacing: SpacingTokens.space2) {
                            DSIconButton(
                                systemName: "heart.fill",
                                titleForAccessibility: "Like (Medium)",
                                variant: .primary,
                                size: .medium
                            ) {}
                            DSText("medium", role: .caption, color: theme.colors.semantic.textTertiary)
                        }
                        VStack(spacing: SpacingTokens.space2) {
                            DSIconButton(
                                systemName: "heart.fill",
                                titleForAccessibility: "Like (Large)",
                                variant: .primary,
                                size: .large
                            ) {}
                            DSText("large", role: .caption, color: theme.colors.semantic.textTertiary)
                        }
                    }
                }

                GallerySection(title: "States") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSIconButton(systemName: "trash", titleForAccessibility: "Delete", variant: .primary) {}
                        DSIconButton(
                            systemName: "trash",
                            titleForAccessibility: "Delete (disabled)",
                            variant: .primary,
                            isDisabled: true
                        ) {}
                        DSIconButton(
                            systemName: "trash",
                            titleForAccessibility: "Delete (loading)",
                            variant: .primary,
                            isLoading: true
                        ) {}
                    }
                    HStack(spacing: SpacingTokens.space3) {
                        DSText("default", role: .caption, color: theme.colors.semantic.textTertiary).frame(width: 44)
                        DSText("disabled", role: .caption, color: theme.colors.semantic.textTertiary).frame(width: 44)
                        DSText("loading", role: .caption, color: theme.colors.semantic.textTertiary).frame(width: 44)
                    }
                }

                GallerySection(title: "Common Actions") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSIconButton(systemName: "xmark", titleForAccessibility: "Close", variant: .secondary) {}
                        DSIconButton(systemName: "arrow.left", titleForAccessibility: "Back", variant: .outline) {}
                        DSIconButton(systemName: "square.and.arrow.up", titleForAccessibility: "Share", variant: .secondary) {}
                        DSIconButton(systemName: "bookmark", titleForAccessibility: "Save", variant: .outline) {}
                        DSIconButton(systemName: "ellipsis", titleForAccessibility: "More", variant: .secondary) {}
                    }
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Icon Button")
    }
}

// MARK: - Previews

#Preview("DSIconButton — Light") {
    NavigationStack { DSIconButtonGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSIconButton — Dark") {
    NavigationStack { DSIconButtonGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
