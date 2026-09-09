import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSListRowGalleryScreen

struct DSListRowGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    @State private var spatialAudio = true

    private func alignmentSample(_ alignment: VerticalAlignment) -> some View {
        DSListRow(
            alignment: alignment,
            leading: { Image(systemName: "headphones").frame(width: 32, height: 32) },
            trailing: { DSSwitch(isOn: $spatialAudio) },
            content: {
                DSRowLabel(
                    title: "Spatial audio",
                    subtitle: "Requires headphones with motion sensors, and shows controls "
                        + "while an ambience is playing."
                )
            }
        )
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Presets") {
                    DSText("Title and value", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSListRow(title: "Language", value: "English")
                    DSDivider(style: .hairline)
                    DSListRow(title: "Region", value: "Mexico")

                    DSText("Title and subtitle", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSListRow(title: "Appearance", subtitle: "Follows the system")
                    DSDivider(style: .hairline)
                    DSListRow(title: "Downloads")
                }

                GallerySection(title: "Slots") {
                    DSListRow(
                        leading: { Image(systemName: "globe") },
                        trailing: { DSRowAccessory(.chevron) },
                        content: { DSRowLabel(title: "Region", subtitle: "Mexico") }
                    )
                    DSDivider(style: .hairline)
                    DSListRow(
                        leading: { Image(systemName: "bell") },
                        trailing: { DSText("3", role: .callout) },
                        content: { DSRowLabel(title: "Notifications") }
                    )
                }

                GallerySection(title: "Accessories") {
                    DSText("Chevron", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSListRow(
                        leading: { EmptyView() },
                        trailing: { DSRowAccessory(.chevron) },
                        content: { DSRowLabel(title: "Opens a detail screen") }
                    )

                    DSText("Selection", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSListRow(
                        leading: { EmptyView() },
                        trailing: { DSRowAccessory(.selection(isSelected: true)) },
                        content: { DSRowLabel(title: "Selected") }
                    )
                    DSListRow(
                        leading: { EmptyView() },
                        trailing: { DSRowAccessory(.selection(isSelected: false)) },
                        content: { DSRowLabel(title: "Not selected") }
                    )

                    DSText("Activity", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSListRow(
                        leading: { EmptyView() },
                        trailing: { DSRowAccessory(.activity) },
                        content: { DSRowLabel(title: "Syncing") }
                    )
                }

                GallerySection(title: "Vertical Alignment") {
                    DSText(
                        "When the subtitle wraps, centred alignment drags the leading icon "
                            + "to the middle of the block, away from the title it labels.",
                        role: .caption,
                        color: theme.colors.semantic.textSecondary
                    )

                    DSText(".center — the default", role: .caption, color: theme.colors.semantic.textSecondary)
                    alignmentSample(.center)

                    DSText(".top", role: .caption, color: theme.colors.semantic.textSecondary)
                    alignmentSample(.top)

                    DSText(
                        "The trailing slot stays centred on the row either way: a switch "
                            + "belongs to the whole row, not to its first line.",
                        role: .caption,
                        color: theme.colors.semantic.textSecondary
                    )
                }

                GallerySection(title: "In Context") {
                    DSCard(style: .standard) {
                        VStack(spacing: 0) {
                            DSListRow(title: "Language", value: "English")
                            DSDivider(style: .hairline)
                            DSListRow(title: "Region", value: "Mexico")
                            DSDivider(style: .hairline)
                            DSListRow(title: "Appearance", subtitle: "Follows the system")
                        }
                    }
                }

                GallerySection(title: "Edge Cases") {
                    DSText("Long title and value", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSListRow(
                        title: "A preference with a considerably longer label than usual",
                        value: "A long value too"
                    )

                    DSText("Long subtitle wraps", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSListRow(
                        title: "Background refresh",
                        subtitle: "Allows the app to fetch new content while it is not in the foreground."
                    )
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("List Row")
    }
}

// MARK: - Previews

#Preview("DSListRow — Light") {
    NavigationStack { DSListRowGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSListRow — Dark") {
    NavigationStack { DSListRowGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
