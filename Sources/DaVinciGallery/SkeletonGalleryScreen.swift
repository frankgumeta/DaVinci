import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - SkeletonGalleryScreen

struct SkeletonGalleryScreen: View {
    @Environment(\.dsTheme) private var theme
    @State private var isShimmering = true

    var body: some View {
        List {
            Section {
                Toggle("Shimmer", isOn: $isShimmering)
            }

            Section("Feed List") {
                DSSkeletonList(
                    count: 6,
                    showLeading: true,
                    showTrailing: false,
                    isShimmering: isShimmering,
                    showDividers: true
                )
                .listRowInsets(EdgeInsets(
                    top: SpacingTokens.space1,
                    leading: SpacingTokens.space4,
                    bottom: SpacingTokens.space1,
                    trailing: SpacingTokens.space4
                ))
            }

            Section("Settings List") {
                DSSkeletonList(
                    count: 5,
                    showLeading: false,
                    showTrailing: true,
                    isShimmering: isShimmering,
                    spacing: .compact,
                    showDividers: true
                )
                .listRowInsets(EdgeInsets(
                    top: SpacingTokens.space1,
                    leading: SpacingTokens.space4,
                    bottom: SpacingTokens.space1,
                    trailing: SpacingTokens.space4
                ))
            }

            Section("Skeleton Cards") {
                DSSkeletonCard(isShimmering: isShimmering)
                    .listRowInsets(EdgeInsets(
                        top: SpacingTokens.space2,
                        leading: SpacingTokens.space4,
                        bottom: SpacingTokens.space2,
                        trailing: SpacingTokens.space4
                    ))

                DSSkeletonCard(showFooter: true, isShimmering: isShimmering)
                    .listRowInsets(EdgeInsets(
                        top: SpacingTokens.space2,
                        leading: SpacingTokens.space4,
                        bottom: SpacingTokens.space2,
                        trailing: SpacingTokens.space4
                    ))
            }

            Section("Skeleton Blocks") {
                DSSkeletonBlock(height: 44, isShimmering: isShimmering)
                DSSkeletonBlock(height: 20, width: 200, isShimmering: isShimmering)
                DSSkeletonBlock(
                    height: 100,
                    cornerRadius: RadiusTokens.large,
                    isShimmering: isShimmering
                )
            }
        }
        .navigationTitle("Skeletons")
    }
}

// MARK: - Previews

#Preview("Skeletons — Light") {
    NavigationStack {
        SkeletonGalleryScreen()
    }
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.light)
}

#Preview("Skeletons — Dark") {
    NavigationStack {
        SkeletonGalleryScreen()
    }
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("Skeletons — Alternate Dark") {
    NavigationStack {
        SkeletonGalleryScreen()
    }
    .dsTheme(.alternate)
    .preferredColorScheme(.dark)
}
