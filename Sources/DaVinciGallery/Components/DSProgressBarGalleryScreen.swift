import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSProgressBarGalleryScreen

struct DSProgressBarGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Determinate") {
                    DSProgressBar(value: 0.0, label: "Not started — 0%")
                    DSProgressBar(value: 0.25, label: "25% complete")
                    DSProgressBar(value: 0.5, label: "Half way — 50%")
                    DSProgressBar(value: 0.75, label: "Almost done — 75%")
                    DSProgressBar(value: 1.0, label: "Complete — 100%")
                }

                GallerySection(title: "Indeterminate") {
                    DSProgressBar(label: "Loading…", isIndeterminate: true)
                    DSProgressBar(isIndeterminate: true)
                }

                GallerySection(title: "Sizes") {
                    DSProgressBar(value: 0.6, size: .small, label: "Small (4pt)")
                    DSProgressBar(value: 0.6, size: .medium, label: "Medium (6pt)")
                    DSProgressBar(value: 0.6, size: .large, label: "Large (8pt)")
                }

                GallerySection(title: "Stepped") {
                    DSProgressBar(
                        value: 0.625,
                        size: .large,
                        label: "2½ of 4 steps",
                        style: .stepped(count: 4)
                    )
                    DSProgressBar(
                        value: 0.72,
                        size: .medium,
                        label: "Seven-step flow",
                        style: .stepped(count: 7)
                    )
                }

                GallerySection(title: "Striped") {
                    DSProgressBar(
                        value: 0.65,
                        size: .large,
                        label: "Uploading — 65%",
                        style: .striped
                    )
                    DSProgressBar(
                        size: .large,
                        label: "Processing…",
                        isIndeterminate: true,
                        style: .striped
                    )
                }

                GallerySection(title: "Shimmer") {
                    DSProgressBar(
                        value: 0.65,
                        size: .large,
                        label: "Downloading — 65%",
                        style: .shimmer
                    )
                    DSProgressBar(
                        size: .large,
                        label: "Preparing…",
                        isIndeterminate: true,
                        style: .shimmer
                    )
                }

                GallerySection(title: "Edge Cases") {
                    DSText("No label", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSProgressBar(value: 0.4)

                    DSText("Custom accessibility label", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSProgressBar(
                        value: 0.7,
                        label: "Upload",
                        accessibilityLabel: "File upload: 70% complete"
                    )

                    DSText("Value clamped below zero", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSProgressBar(value: -1.0, label: "Clamped → 0%")

                    DSText("Value clamped above one", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSProgressBar(value: 2.0, label: "Clamped → 100%")

                    DSText("Large indeterminate", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSProgressBar(size: .large, label: "Processing…", isIndeterminate: true)
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Progress Bar")
    }
}

// MARK: - Previews

#Preview("DSProgressBar — Light") {
    NavigationStack { DSProgressBarGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSProgressBar — Dark") {
    NavigationStack { DSProgressBarGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
