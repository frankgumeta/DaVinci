import SwiftUI
import DaVinciTokens

// MARK: - Previews

#Preview("DSProgressBar - Light") {
    VStack(spacing: SpacingTokens.space5) {
        DSProgressBar(value: 0.0, label: "Not started")
        DSProgressBar(value: 0.25, label: "25% complete")
        DSProgressBar(value: 0.5, label: "Half way")
        DSProgressBar(value: 0.75, label: "Almost done")
        DSProgressBar(value: 1.0, label: "Complete")
        DSProgressBar(label: "Loading...", isIndeterminate: true)

        DSText("Sizes", role: .caption)
        DSProgressBar(value: 0.6, size: .small, label: "Small")
        DSProgressBar(value: 0.6, size: .medium, label: "Medium")
        DSProgressBar(value: 0.6, size: .large, label: "Large")

        DSText("Styles", role: .caption)
        DSProgressBar(value: 0.625, size: .large, label: "Stepped", style: .stepped(count: 4))
        DSProgressBar(value: 0.65, size: .large, label: "Striped", style: .striped)
        DSProgressBar(size: .large, label: "Striped loading", isIndeterminate: true, style: .striped)
        DSProgressBar(value: 0.65, size: .large, label: "Shimmer", style: .shimmer)
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSProgressBar - Dark") {
    VStack(spacing: SpacingTokens.space5) {
        DSProgressBar(value: 0.0, label: "Not started")
        DSProgressBar(value: 0.5, label: "Half way")
        DSProgressBar(value: 1.0, label: "Complete")
        DSProgressBar(label: "Loading...", isIndeterminate: true)
        DSProgressBar(value: 0.6, size: .large, label: "Large")
        DSProgressBar(value: 0.625, size: .large, label: "Stepped", style: .stepped(count: 4))
        DSProgressBar(value: 0.65, size: .large, label: "Striped", style: .striped)
        DSProgressBar(value: 0.65, size: .large, label: "Shimmer", style: .shimmer)
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
