import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSSegmentedControlGalleryScreen

struct DSSegmentedControlGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    @State private var timeRange = 0
    @State private var viewMode = 0
    @State private var tabIndex = 0
    @State private var modelIndex = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Text Only") {
                    DSSegmentedControl(
                        options: ["Day", "Week", "Month"],
                        selectedIndex: $timeRange
                    )
                    DSSegmentedControl(
                        options: ["All", "Active", "Closed"],
                        selectedIndex: $tabIndex
                    )
                }

                GallerySection(title: "With Icons") {
                    DSSegmentedControl(
                        options: ["List", "Grid"],
                        selectedIndex: $viewMode,
                        icons: ["list.bullet", "square.grid.2x2"]
                    )
                    DSSegmentedControl(
                        options: ["Map", "Satellite", "Hybrid"],
                        selectedIndex: .constant(0),
                        icons: ["map", "globe.americas", "map.fill"]
                    )
                }

                GallerySection(title: "DSSegmentItem Model") {
                    DSSegmentedControl(
                        segments: [
                            DSSegmentItem(title: "Map", iconSystemName: "map"),
                            DSSegmentItem(title: "List", iconSystemName: "list.bullet"),
                            DSSegmentItem(title: "Grid", iconSystemName: "square.grid.2x2")
                        ],
                        selectedIndex: $modelIndex
                    )
                }

                GallerySection(title: "Edge Cases") {
                    DSText("Two segments", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSSegmentedControl(
                        options: ["On", "Off"],
                        selectedIndex: .constant(0)
                    )

                    DSText("Four segments", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSSegmentedControl(
                        options: ["S", "M", "L", "XL"],
                        selectedIndex: .constant(1)
                    )

                    DSText("Icon-only items", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSSegmentedControl(
                        segments: [
                            DSSegmentItem(title: "", iconSystemName: "sun.max"),
                            DSSegmentItem(title: "", iconSystemName: "cloud"),
                            DSSegmentItem(title: "", iconSystemName: "cloud.rain")
                        ],
                        selectedIndex: .constant(0)
                    )
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Segmented Control")
    }
}

// MARK: - Previews

#Preview("DSSegmentedControl — Light") {
    NavigationStack { DSSegmentedControlGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSSegmentedControl — Dark") {
    NavigationStack { DSSegmentedControlGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
