import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSButtonGalleryScreen

struct DSButtonGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Variants") {
                    DSButton("Primary", variant: .primary) {}
                    DSButton("Secondary", variant: .secondary) {}
                    DSButton("Outline", variant: .outline) {}
                }

                GallerySection(title: "Icons") {
                    DSButton("Add Item", variant: .primary, icon: .leading(systemName: "plus")) {}
                    DSButton("Continue", variant: .outline, icon: .trailing(systemName: "arrow.right")) {}
                    DSButton("Share", variant: .secondary, icon: .leading(systemName: "square.and.arrow.up")) {}
                }

                GallerySection(title: "States") {
                    DSText("Loading", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSButton("Saving…", variant: .primary, isLoading: true) {}
                    DSButton("Loading…", variant: .secondary, isLoading: true) {}

                    DSText("Disabled", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSButton("Primary", variant: .primary, isDisabled: true) {}
                    DSButton("Secondary", variant: .secondary, isDisabled: true) {}
                    DSButton("Outline", variant: .outline, isDisabled: true) {}
                }

                GallerySection(title: "Edge Cases") {
                    DSButton("Short", variant: .primary) {}
                    DSButton(
                        "This is a very long button label that should expand or wrap naturally",
                        variant: .primary
                    ) {}
                    DSButton(
                        "Loading + Icon",
                        variant: .primary,
                        icon: .leading(systemName: "checkmark"),
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
