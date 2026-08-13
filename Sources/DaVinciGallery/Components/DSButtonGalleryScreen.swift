import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSButtonGalleryScreen

struct DSButtonGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Appearances") {
                    DSButton("Primary", appearance: .primary) {}
                    DSButton("Secondary", appearance: .secondary) {}
                    DSButton("Outline", appearance: .outline) {}
                    DSButton("Ghost", appearance: .ghost) {}
                }

                GallerySection(title: "Icons") {
                    DSButton("Add Item", appearance: .primary, icon: .leading(DSSymbol(systemName: "plus")!)) {}
                    DSButton("Continue", appearance: .outline, icon: .trailing(DSSymbol(systemName: "arrow.right")!)) {}
                    DSButton("Share", appearance: .secondary, icon: .leading(DSSymbol(systemName: "square.and.arrow.up")!)) {}
                }

                GallerySection(title: "States") {
                    DSText("Loading", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSButton("Saving…", appearance: .primary, isLoading: true) {}
                    DSButton("Loading…", appearance: .secondary, isLoading: true) {}

                    DSText("Disabled", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSButton("Primary", appearance: .primary, isDisabled: true) {}
                    DSButton("Secondary", appearance: .secondary, isDisabled: true) {}
                    DSButton("Outline", appearance: .outline, isDisabled: true) {}
                    DSButton("Ghost", appearance: .ghost, isDisabled: true) {}
                }

                GallerySection(title: "Edge Cases") {
                    DSButton("Short", appearance: .primary) {}
                    DSButton(
                        "This is a very long button label that should expand or wrap naturally",
                        appearance: .primary
                    ) {}
                    DSButton(
                        "Loading + Icon",
                        appearance: .primary,
                        icon: .leading(DSSymbol(systemName: "checkmark")!),
                        isLoading: true
                    ) {}
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Button")
    }
}

// MARK: - Previews

#Preview("DSButton — Light") {
    NavigationStack { DSButtonGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSButton — Dark") {
    NavigationStack { DSButtonGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
