import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - ComponentsGalleryScreen

struct ComponentsGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    @State private var textFieldValue = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {
                textSection
                buttonSection
                iconButtonSection
                cardSection
                textFieldSection
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Components")
    }

    // MARK: - DSText

    private var textSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            sectionHeader("DSText")

            DSText("Display", role: .display)
            DSText("Title", role: .title)
            DSText("Headline", role: .headline)
            DSText("Body — the main reading style.", role: .body)
            DSText("Callout — supporting text.", role: .callout)
            DSText("Caption — smallest text.", role: .caption, color: theme.colors.semantic.textSecondary)
            DSText("OVERLINE", role: .overline, color: theme.colors.semantic.textTertiary)

            Divider()

            DSText("text.brand", role: .body, color: theme.colors.textEmphasis.brand)
            DSText("text.success", role: .body, color: theme.colors.textEmphasis.success)
            DSText("text.warning", role: .body, color: theme.colors.textEmphasis.warning)
            DSText("text.error", role: .body, color: theme.colors.textEmphasis.error)
            DSText("text.info", role: .body, color: theme.colors.textEmphasis.info)
        }
    }

    // MARK: - DSButton

    private var buttonSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            sectionHeader("DSButton")

            DSButton("Primary", variant: .primary) {}
            DSButton("Secondary", variant: .secondary) {}
            DSButton("Outline", variant: .outline) {}

            DSText("With Icons", role: .caption, color: theme.colors.semantic.textSecondary)
            DSButton("Add Item", variant: .primary, icon: .leading(systemName: "plus")) {}
            DSButton("Continue", variant: .outline, icon: .trailing(systemName: "arrow.right")) {}

            DSText("Loading", role: .caption, color: theme.colors.semantic.textSecondary)
            DSButton("Saving…", variant: .primary, isLoading: true) {}
            DSButton("Loading…", variant: .secondary, isLoading: true) {}

            DSText("Disabled", role: .caption, color: theme.colors.semantic.textSecondary)
            DSButton("Primary", variant: .primary, isDisabled: true) {}
            DSButton("Outline", variant: .outline, isDisabled: true) {}

            DSText("Pressed — tap and hold", role: .caption, color: theme.colors.semantic.textSecondary)
            DSButton("Hold Me", variant: .primary) {}
        }
    }

    // MARK: - DSIconButton

    private var iconButtonSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            sectionHeader("DSIconButton")

            DSText("Variants", role: .caption, color: theme.colors.semantic.textSecondary)
            HStack(spacing: SpacingTokens.space3) {
                DSIconButton(systemName: "plus", titleForAccessibility: "Add", variant: .primary) {}
                DSIconButton(systemName: "gearshape", titleForAccessibility: "Settings", variant: .secondary) {}
                DSIconButton(systemName: "pencil", titleForAccessibility: "Edit", variant: .outline) {}
            }

            DSText("Sizes", role: .caption, color: theme.colors.semantic.textSecondary)
            HStack(spacing: SpacingTokens.space3) {
                DSIconButton(systemName: "heart.fill", titleForAccessibility: "Like", variant: .primary, size: .small) {}
                DSIconButton(systemName: "heart.fill", titleForAccessibility: "Like", variant: .primary, size: .medium) {}
                DSIconButton(systemName: "heart.fill", titleForAccessibility: "Like", variant: .primary, size: .large) {}
            }

            DSText("States", role: .caption, color: theme.colors.semantic.textSecondary)
            HStack(spacing: SpacingTokens.space3) {
                DSIconButton(systemName: "trash", titleForAccessibility: "Delete", variant: .primary) {}
                DSIconButton(systemName: "trash", titleForAccessibility: "Delete (disabled)", variant: .primary, isDisabled: true) {}
                DSIconButton(systemName: "trash", titleForAccessibility: "Delete (loading)", variant: .primary, isLoading: true) {}
            }
        }
    }

    // MARK: - DSCard

    private var cardSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            sectionHeader("DSCard")

            DSCard(style: .standard) {
                VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                    DSText("Standard Card", role: .headline)
                    DSText(
                        "Cards use surface, elevation, and radius tokens to create a contained content area.",
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
                    VStack(alignment: .leading, spacing: 2) {
                        DSText("Compact Card", role: .callout)
                        DSText("Tighter padding, no shadow", role: .caption, color: theme.colors.semantic.textTertiary)
                    }
                    Spacer()
                }
            }

            DSCard(style: .prominent) {
                VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                    DSText("Prominent Card", role: .headline)
                    DSText(
                        "Generous padding with medium elevation for hero content.",
                        role: .body,
                        color: theme.colors.semantic.textSecondary
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    // MARK: - DSTextField

    private var textFieldSection: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            sectionHeader("DSTextField")

            DSTextField("Email", text: $textFieldValue, prompt: "you@example.com")

            DSTextField("Name", text: .constant("Frank Gumeta"))
        }
    }

    // MARK: - Helpers

    private func sectionHeader(_ title: String) -> some View {
        DSText(title, role: .title)
    }
}

// MARK: - Previews

#Preview("Components — Default") {
    NavigationStack {
        ComponentsGalleryScreen()
    }
    .dsTheme(.defaultTheme)
}

#Preview("Components — Alternate") {
    NavigationStack {
        ComponentsGalleryScreen()
    }
    .dsTheme(.alternate)
}
