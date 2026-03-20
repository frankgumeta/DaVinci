import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - GallerySectionHeader

/// A labelled subsection header with a hairline rule underneath.
/// Shared across all component gallery screens for visual consistency.
struct GallerySectionHeader: View {
    @Environment(\.dsTheme) private var theme
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space1) {
            DSText(title, role: .callout, color: theme.colors.semantic.textSecondary)
            DSDivider(style: .hairline)
        }
        .padding(.top, SpacingTokens.space2)
    }
}

// MARK: - GallerySection

/// A titled subsection block used in component gallery screens.
///
/// Wraps a `GallerySectionHeader` above a `@ViewBuilder` content block.
struct GallerySection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            GallerySectionHeader(title: title)
            content()
        }
    }
}
