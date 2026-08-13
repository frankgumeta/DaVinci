import SwiftUI
import DaVinciTokens

// MARK: - Previews

struct DSSegmentedControlLightPreview: View {
    @State private var itemSelection = 1
    @State private var subtleSelection = 1
    @State private var iconSelection = 0
    @State private var filterSelection = 2
    @State private var mapSelection = 0

    var body: some View {
        VStack(spacing: SpacingTokens.space5) {
            VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                DSText("DSSegmentItem API", role: .headline)
                DSSegmentedControl(
                    segments: [
                        DSSegmentItem(title: "Day"),
                        DSSegmentItem(title: "Week"),
                        DSSegmentItem(title: "Month")
                    ],
                    selectedIndex: $itemSelection
                )
            }

            VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                DSText("Subtle", role: .headline)
                DSSegmentedControl(
                    options: ["Day", "Week", "Month"],
                    selectedIndex: $subtleSelection,
                    appearance: .subtle
                )
            }

            VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                DSText("With Icons", role: .headline)
                DSSegmentedControl(
                    segments: [
                        DSSegmentItem(title: "List", icon: DSSymbol(systemName: "list.bullet")!),
                        DSSegmentItem(title: "Grid", icon: DSSymbol(systemName: "square.grid.2x2")!),
                        DSSegmentItem(title: "Calendar", icon: DSSymbol(systemName: "calendar")!)
                    ],
                    selectedIndex: $iconSelection
                )
            }

            VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                DSText("Text options", role: .headline)
                DSSegmentedControl(
                    options: ["All", "Active", "Pending", "Closed"],
                    selectedIndex: $filterSelection
                )
            }

            VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                DSText("Two options", role: .headline)
                DSSegmentedControl(
                    options: ["Map", "List"],
                    selectedIndex: $mapSelection,
                    symbols: [DSSymbol(systemName: "map")!, DSSymbol(systemName: "list.bullet")!]
                )
            }
        }
        .padding()
        .dsTheme(.defaultTheme)
    }
}

struct DSSegmentedControlDarkPreview: View {
    @State private var itemSelection = 1
    @State private var iconSelection = 0
    @State private var subtleSelection = 2

    var body: some View {
        VStack(spacing: SpacingTokens.space5) {
            DSSegmentedControl(
                segments: [
                    DSSegmentItem(title: "Day"),
                    DSSegmentItem(title: "Week"),
                    DSSegmentItem(title: "Month")
                ],
                selectedIndex: $itemSelection
            )

            DSSegmentedControl(
                options: ["List", "Grid", "Calendar"],
                selectedIndex: $iconSelection,
                symbols: [
                    DSSymbol(systemName: "list.bullet")!,
                    DSSymbol(systemName: "square.grid.2x2")!,
                    DSSymbol(systemName: "calendar")!
                ]
            )

            DSSegmentedControl(
                options: ["All", "Active", "Pending", "Closed"],
                selectedIndex: $subtleSelection,
                appearance: .subtle
            )
        }
        .padding()
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
    }
}

#Preview("DSSegmentedControl - Light") {
    DSSegmentedControlLightPreview()
}

#Preview("DSSegmentedControl - Dark") {
    DSSegmentedControlDarkPreview()
}
