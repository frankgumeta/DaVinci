import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSActivityIndicatorGalleryScreen

struct DSActivityIndicatorGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Sizes") {
                    HStack(spacing: SpacingTokens.space6) {
                        ForEach(Array(DSActivityIndicator.Size.allCases.enumerated()), id: \.offset) { _, size in
                            VStack(spacing: SpacingTokens.space2) {
                                DSActivityIndicator(size: size)
                                DSText(
                                    "\(Int(size.dimension))pt",
                                    role: .labelSmall,
                                    color: theme.colors.semantic.textSecondary
                                )
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                GallerySection(title: "Tint") {
                    HStack(spacing: SpacingTokens.space6) {
                        VStack(spacing: SpacingTokens.space2) {
                            DSActivityIndicator()
                            DSText("default", role: .labelSmall, color: theme.colors.semantic.textSecondary)
                        }
                        VStack(spacing: SpacingTokens.space2) {
                            DSActivityIndicator(tint: .purple)
                            DSText("purple", role: .labelSmall, color: theme.colors.semantic.textSecondary)
                        }
                        VStack(spacing: SpacingTokens.space2) {
                            DSActivityIndicator(tint: .orange)
                            DSText("orange", role: .labelSmall, color: theme.colors.semantic.textSecondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }

                GallerySection(title: "Accessibility") {
                    DSText(
                        "The label reaches VoiceOver only; it is never painted. "
                            + "Without one, a localized default is announced.",
                        role: .caption,
                        color: theme.colors.semantic.textSecondary
                    )
                    HStack(spacing: SpacingTokens.space6) {
                        DSActivityIndicator(size: .large)
                        DSActivityIndicator(size: .large, label: "Loading packs")
                    }
                    .frame(maxWidth: .infinity)
                }

                GallerySection(title: "In Context") {
                    DSText("As a row accessory", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSCard(style: .standard) {
                        VStack(spacing: 0) {
                            DSListRow(
                                leading: { EmptyView() },
                                trailing: { DSActivityIndicator(size: .small) },
                                content: { DSRowLabel(title: "Syncing", subtitle: "Started a moment ago") }
                            )
                            DSDivider(style: .hairline)
                            DSListRow(
                                leading: { EmptyView() },
                                trailing: { DSRowAccessory(.activity) },
                                content: { DSRowLabel(title: "Via DSRowAccessory.activity") }
                            )
                        }
                    }

                    DSText("Section-level loading", role: .caption, color: theme.colors.semantic.textSecondary)
                    VStack(spacing: SpacingTokens.space3) {
                        DSActivityIndicator(size: .large)
                        DSText("Loading your library", role: .callout, color: theme.colors.semantic.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(SpacingTokens.space6)
                    .dsSurface(.card)
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Activity Indicator")
    }
}

// MARK: - Previews

#Preview("DSActivityIndicator — Light") {
    NavigationStack { DSActivityIndicatorGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSActivityIndicator — Dark") {
    NavigationStack { DSActivityIndicatorGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
