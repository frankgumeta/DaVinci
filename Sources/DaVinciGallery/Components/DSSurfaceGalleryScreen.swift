import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSSurfaceGalleryScreen

struct DSSurfaceGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    private func sample(_ title: String, style: DSSurfaceStyle) -> some View {
        DSText(title, role: .labelMedium)
            .padding(SpacingTokens.space4)
            .frame(maxWidth: .infinity)
            .dsSurface(style)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Presets") {
                    sample("card — opaque container, large radius, small shadow", style: .card)
                    sample("overlay — elevated fill for modals", style: .overlay)
                    sample("outline — no fill, hairline border", style: .outline)
                    sample("plain — shape only", style: .plain)

                    HStack(spacing: SpacingTokens.space3) {
                        DSText("pill", role: .labelSmall)
                            .padding(.horizontal, SpacingTokens.space3)
                            .padding(.vertical, SpacingTokens.space2)
                            .dsSurface(.pill)

                        DSText("floating", role: .labelSmall)
                            .padding(.horizontal, SpacingTokens.space3)
                            .padding(.vertical, SpacingTokens.space2)
                            .dsSurface(.floating)
                    }
                }

                GallerySection(title: "Shape") {
                    HStack(spacing: SpacingTokens.space3) {
                        ForEach(
                            [
                                ("small", DSSurfaceShape.small),
                                ("medium", DSSurfaceShape.medium),
                                ("large", DSSurfaceShape.large)
                            ],
                            id: \.0
                        ) { name, shape in
                            DSText(name, role: .labelSmall)
                                .padding(SpacingTokens.space3)
                                .frame(maxWidth: .infinity)
                                .dsSurface(DSSurfaceStyle(shape: shape, fill: .secondary))
                        }
                    }

                    HStack(spacing: SpacingTokens.space3) {
                        Color.purple
                            .frame(width: 56, height: 56)
                            .dsSurface(DSSurfaceStyle(shape: .circle, fill: .none))

                        Color.teal
                            .frame(width: 120, height: 56)
                            .dsSurface(DSSurfaceStyle(shape: .capsule, fill: .none))

                        Color.orange
                            .frame(width: 56, height: 56)
                            .dsSurface(DSSurfaceStyle(shape: .rectangle, fill: .none))
                    }
                }

                GallerySection(title: "Fill") {
                    sample("primary", style: DSSurfaceStyle(fill: .primary))
                    sample("secondary", style: DSSurfaceStyle(fill: .secondary))
                    sample("elevated", style: DSSurfaceStyle(fill: .elevated))
                    sample("explicit colour", style: DSSurfaceStyle(fill: .color(.purple.opacity(0.2))))
                }

                GallerySection(title: "Stroke") {
                    sample("hairline", style: DSSurfaceStyle(fill: .none, stroke: .hairline))
                    sample("accent", style: DSSurfaceStyle(fill: .none, stroke: .accent))
                    sample(
                        "divider weight",
                        style: DSSurfaceStyle(fill: .none, stroke: DSSurfaceStroke(fill: .divider))
                    )
                    sample(
                        "2pt accent",
                        style: DSSurfaceStyle(fill: .none, stroke: DSSurfaceStroke(fill: .accent, width: 2))
                    )
                }

                GallerySection(title: "In Context") {
                    DSText(
                        "A surface carries no padding, so the caller composes it.",
                        role: .caption,
                        color: theme.colors.semantic.textSecondary
                    )

                    VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                        DSText("Selected palette", role: .headline)
                        DSText("Midnight", role: .body, color: theme.colors.semantic.textSecondary)
                    }
                    .padding(SpacingTokens.space4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .dsSurface(DSSurfaceStyle(shape: .large, fill: .secondary, stroke: .accent))
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Surface")
    }
}

// MARK: - Previews

#Preview("DSSurface — Light") {
    NavigationStack { DSSurfaceGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSSurface — Dark") {
    NavigationStack { DSSurfaceGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
