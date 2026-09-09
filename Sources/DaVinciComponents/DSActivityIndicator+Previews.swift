import SwiftUI
import DaVinciTokens

// MARK: - Previews

private struct DSActivityIndicatorShowcase: View {
    var body: some View {
        VStack(spacing: SpacingTokens.space4) {
            DSText("Sizes", role: .headline)

            HStack(spacing: SpacingTokens.space5) {
                ForEach(Array(DSActivityIndicator.Size.allCases.enumerated()), id: \.offset) { _, size in
                    VStack(spacing: SpacingTokens.space2) {
                        DSActivityIndicator(size: size)
                        DSText("\(Int(size.dimension))pt", role: .labelSmall)
                    }
                }
            }

            DSText("Tint", role: .headline)

            HStack(spacing: SpacingTokens.space5) {
                DSActivityIndicator()
                DSActivityIndicator(tint: .purple)
                DSActivityIndicator(tint: .orange)
            }

            DSText("In context", role: .headline)

            DSListRow(
                leading: { EmptyView() },
                trailing: { DSActivityIndicator(size: .small) },
                content: { DSRowLabel(title: "Syncing", subtitle: "Inline with a row") }
            )

            DSText("Custom label", role: .headline)

            // The label reaches VoiceOver only; it is not painted.
            DSActivityIndicator(size: .large, label: "Loading packs")
        }
        .padding()
    }
}

#Preview("DSActivityIndicator - Light") {
    DSActivityIndicatorShowcase()
        .dsTheme(.defaultTheme)
}

#Preview("DSActivityIndicator - Dark") {
    DSActivityIndicatorShowcase()
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
