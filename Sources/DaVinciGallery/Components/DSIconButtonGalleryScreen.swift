import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSIconButtonGalleryScreen

struct DSIconButtonGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Appearances") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSIconButton(symbol: DSSymbol(systemName: "plus")!, titleForAccessibility: "Add", appearance: .primary) {}
                        DSIconButton(symbol: DSSymbol(systemName: "gearshape")!, titleForAccessibility: "Settings", appearance: .secondary) {}
                        DSIconButton(symbol: DSSymbol(systemName: "pencil")!, titleForAccessibility: "Edit", appearance: .outline) {}
                        DSIconButton(symbol: DSSymbol(systemName: "star")!, titleForAccessibility: "Favorite", appearance: .accent) {}
                        DSIconButton(symbol: DSSymbol(systemName: "ellipsis")!, titleForAccessibility: "More", appearance: .ghost) {}
                    }
                }

                GallerySection(title: "Sizes") {
                    HStack(spacing: SpacingTokens.space4) {
                        VStack(spacing: SpacingTokens.space2) {
                            DSIconButton(
                                symbol: DSSymbol(systemName: "heart.fill")!,
                                titleForAccessibility: "Like (Small)",
                                appearance: .primary,
                                size: .small
                            ) {}
                            DSText("small", role: .caption, color: theme.colors.semantic.textTertiary)
                        }
                        VStack(spacing: SpacingTokens.space2) {
                            DSIconButton(
                                symbol: DSSymbol(systemName: "heart.fill")!,
                                titleForAccessibility: "Like (Medium)",
                                appearance: .primary,
                                size: .medium
                            ) {}
                            DSText("medium", role: .caption, color: theme.colors.semantic.textTertiary)
                        }
                        VStack(spacing: SpacingTokens.space2) {
                            DSIconButton(
                                symbol: DSSymbol(systemName: "heart.fill")!,
                                titleForAccessibility: "Like (Large)",
                                appearance: .primary,
                                size: .large
                            ) {}
                            DSText("large", role: .caption, color: theme.colors.semantic.textTertiary)
                        }
                    }
                }

                GallerySection(title: "States") {
                    HStack(spacing: SpacingTokens.space3) {
                        DSIconButton(symbol: DSSymbol(systemName: "trash")!, titleForAccessibility: "Delete", appearance: .primary) {}
                        DSIconButton(
                            symbol: DSSymbol(systemName: "trash")!,
                            titleForAccessibility: "Delete (disabled)",
                            appearance: .primary,
                            isDisabled: true
                        ) {}
                        DSIconButton(
                            symbol: DSSymbol(systemName: "trash")!,
                            titleForAccessibility: "Delete (loading)",
                            appearance: .primary,
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
                        DSIconButton(symbol: DSSymbol(systemName: "xmark")!, titleForAccessibility: "Close", appearance: .ghost) {}
                        DSIconButton(symbol: DSSymbol(systemName: "arrow.left")!, titleForAccessibility: "Back", appearance: .outline) {}
                        DSIconButton(symbol: DSSymbol(systemName: "square.and.arrow.up")!, titleForAccessibility: "Share", appearance: .secondary) {}
                        DSIconButton(symbol: DSSymbol(systemName: "bookmark")!, titleForAccessibility: "Save", appearance: .outline) {}
                        DSIconButton(symbol: DSSymbol(systemName: "ellipsis")!, titleForAccessibility: "More", appearance: .ghost) {}
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
