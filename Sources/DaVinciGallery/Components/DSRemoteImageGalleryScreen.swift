import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSRemoteImageGalleryScreen

struct DSRemoteImageGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {
                GallerySection(title: "Geometry") {
                    HStack(spacing: SpacingTokens.space4) {
                        DSRemoteImage(
                            url: nil,
                            geometry: .circle(diameter: 80),
                            showsShimmer: false,
                            placeholder: DSSymbol(systemName: "person.crop.circle")
                        )
                        DSRemoteImage(
                            url: nil,
                            geometry: .rounded(
                                size: CGSize(width: 120, height: 80),
                                cornerRadius: RadiusTokens.medium
                            ),
                            showsShimmer: false,
                            placeholder: DSSymbol(systemName: "photo")
                        )
                    }

                    DSRemoteImage(
                        url: nil,
                        geometry: .rectangle(size: CGSize(width: 216, height: 100)),
                        showsShimmer: false,
                        placeholder: DSSymbol(systemName: "photo")
                    )
                }

                GallerySection(title: "Loading Shapes") {
                    HStack(spacing: SpacingTokens.space4) {
                        DSRemoteImage(
                            url: URL(string: "https://example.com/avatar.jpg"),
                            geometry: .circle(diameter: 80)
                        )
                        DSRemoteImage(
                            url: URL(string: "https://example.com/cover.jpg"),
                            geometry: .rounded(
                                size: CGSize(width: 120, height: 80),
                                cornerRadius: RadiusTokens.medium
                            )
                        )
                    }
                }

                GallerySection(title: "Additional Rounded Size") {
                    DSRemoteImage(
                        url: nil,
                        geometry: .rounded(
                            size: CGSize(width: 216, height: 100),
                            cornerRadius: RadiusTokens.medium
                        ),
                        showsShimmer: false
                    )
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Remote Image")
    }
}

#Preview("DSRemoteImage — Light") {
    NavigationStack { DSRemoteImageGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSRemoteImage — Dark") {
    NavigationStack { DSRemoteImageGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
