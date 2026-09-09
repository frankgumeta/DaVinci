import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSActionRowGalleryScreen

struct DSActionRowGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    @State private var selection = "Midnight"
    @State private var tapCount = 0

    private let palettes = ["Midnight", "Daylight", "Sepia"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Action Row") {
                    DSText("Tappable", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSActionRow(action: { tapCount += 1 }, content: {
                        DSRowLabel(title: "Open settings", subtitle: "Tapped \(tapCount) times")
                    })

                    // DSActionRow has a single content slot, so a trailing accessory
                    // is composed inside it rather than passed as its own slot.
                    DSText("With a chevron", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSActionRow(action: {}, content: {
                        HStack(spacing: SpacingTokens.space3) {
                            DSRowLabel(title: "Account", subtitle: "Signed in")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            DSRowAccessory(.chevron)
                        }
                    })
                }

                GallerySection(title: "States") {
                    DSText("Disabled", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSActionRow(isDisabled: true, action: {}, content: {
                        DSRowLabel(title: "Unavailable", subtitle: "Not interactive")
                    })

                    DSText("Loading", role: .caption, color: theme.colors.semantic.textSecondary)
                    // Loading disables the row, so a second tap cannot start the work twice.
                    DSActionRow(isLoading: true, action: {}, content: {
                        DSRowLabel(title: "Restoring purchases", subtitle: "Inert while in flight")
                    })
                }

                GallerySection(title: "Selectable Row") {
                    ForEach(palettes, id: \.self) { palette in
                        DSSelectableRow(
                            isSelected: selection == palette,
                            action: { selection = palette },
                            content: { DSRowLabel(title: palette) }
                        )
                    }

                    DSText("Disabled", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSSelectableRow(
                        isSelected: false,
                        isDisabled: true,
                        action: {},
                        content: { DSRowLabel(title: "Unavailable palette") }
                    )
                }

                GallerySection(title: "With Leading Content") {
                    DSSelectableRow(
                        isSelected: selection == "Midnight",
                        action: { selection = "Midnight" },
                        leading: { Circle().fill(.purple).frame(width: 20, height: 20) },
                        content: { DSRowLabel(title: "Midnight", subtitle: "Dark palette") }
                    )
                    DSSelectableRow(
                        isSelected: selection == "Daylight",
                        action: { selection = "Daylight" },
                        leading: { Circle().fill(.yellow).frame(width: 20, height: 20) },
                        content: { DSRowLabel(title: "Daylight", subtitle: "Light palette") }
                    )
                }

                GallerySection(title: "In Context") {
                    DSCard(style: .standard) {
                        VStack(spacing: 0) {
                            DSActionRow(action: {}, content: { DSRowLabel(title: "Export data") })
                            DSDivider(style: .hairline)
                            DSActionRow(action: {}, content: { DSRowLabel(title: "Import data") })
                            DSDivider(style: .hairline)
                            DSActionRow(isDisabled: true, action: {}, content: { DSRowLabel(title: "Delete account") })
                        }
                    }
                }

                GallerySection(title: "Edge Cases") {
                    DSText("Long label wraps", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSActionRow(action: {}, content: {
                        DSRowLabel(
                            title: "Reset every preference back to its factory default value",
                            subtitle: "This cannot be undone once confirmed."
                        )
                    })
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Action Row")
    }
}

// MARK: - Previews

#Preview("DSActionRow — Light") {
    NavigationStack { DSActionRowGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSActionRow — Dark") {
    NavigationStack { DSActionRowGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
