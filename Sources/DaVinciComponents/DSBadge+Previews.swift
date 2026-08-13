import SwiftUI
import DaVinciTokens

// MARK: - Previews

#Preview("DSBadge - Light") {
    ScrollView {
        VStack(alignment: .leading, spacing: SpacingTokens.space5) {

            DSText("Tones — readability check", role: .headline)
            HStack(spacing: SpacingTokens.space3) {
                DSBadge("Brand", tone: .brand)
                DSBadge("Success", tone: .success)
                DSBadge("Warning", tone: .warning)
                DSBadge("Error", tone: .error)
                DSBadge("Neutral", tone: .neutral)
            }

            DSText("Sizes — all tones", role: .headline)
            ForEach([DSBadge.Tone.brand, .success, .warning, .error, .neutral], id: \.self) { tone in
                HStack(spacing: SpacingTokens.space3) {
                    DSBadge("Small", tone: tone, size: .small)
                    DSBadge("Medium", tone: tone, size: .medium)
                    DSBadge("Large", tone: tone, size: .large)
                }
            }

            DSText("Numbers", role: .headline)
            HStack(spacing: SpacingTokens.space3) {
                DSBadge("1")
                DSBadge("5")
                DSBadge("99")
                DSBadge("999+")
                DSBadge("1", tone: .error)
                DSBadge("99+", tone: .error)
            }

            DSText("Dot indicators — graduated sizes", role: .headline)
            HStack(alignment: .center, spacing: SpacingTokens.space4) {
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(tone: .error, size: .small)
                    DSText("small", role: .caption)
                }
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(tone: .error, size: .medium)
                    DSText("medium", role: .caption)
                }
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(tone: .error, size: .large)
                    DSText("large", role: .caption)
                }
            }
            HStack(spacing: SpacingTokens.space3) {
                DSBadge(tone: .brand)
                DSBadge(tone: .success)
                DSBadge(tone: .warning)
                DSBadge(tone: .error)
                DSBadge(tone: .neutral)
            }
        }
        .padding()
    }
    .dsTheme(.defaultTheme)
}

#Preview("DSBadge - Dark") {
    ScrollView {
        VStack(alignment: .leading, spacing: SpacingTokens.space5) {

            DSText("Tones — dark mode readability", role: .headline)
            HStack(spacing: SpacingTokens.space3) {
                DSBadge("Brand", tone: .brand)
                DSBadge("Success", tone: .success)
                DSBadge("Warning", tone: .warning)
                DSBadge("Error", tone: .error)
                DSBadge("Neutral", tone: .neutral)
            }

            DSText("Sizes — all tones", role: .headline)
            ForEach([DSBadge.Tone.brand, .success, .warning, .error, .neutral], id: \.self) { tone in
                HStack(spacing: SpacingTokens.space3) {
                    DSBadge("Small", tone: tone, size: .small)
                    DSBadge("Medium", tone: tone, size: .medium)
                    DSBadge("Large", tone: tone, size: .large)
                }
            }

            DSText("Numbers", role: .headline)
            HStack(spacing: SpacingTokens.space3) {
                DSBadge("1")
                DSBadge("99")
                DSBadge("999+")
                DSBadge("1", tone: .error)
                DSBadge("99+", tone: .error)
            }

            DSText("Dot indicators — graduated sizes", role: .headline)
            HStack(alignment: .center, spacing: SpacingTokens.space4) {
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(tone: .error, size: .small)
                    DSText("small", role: .caption)
                }
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(tone: .error, size: .medium)
                    DSText("medium", role: .caption)
                }
                VStack(spacing: SpacingTokens.space2) {
                    DSBadge(tone: .error, size: .large)
                    DSText("large", role: .caption)
                }
            }
        }
        .padding()
    }
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}

#Preview("DSBadge - Accessibility") {
    VStack(spacing: SpacingTokens.space4) {
        DSText("Custom a11y label on dot", role: .caption)
        DSBadge(tone: .error, accessibilityLabel: "3 unread messages")

        DSText("All sizes", role: .caption)
        HStack(spacing: SpacingTokens.space3) {
            DSBadge("S", size: .small)
            DSBadge("M", size: .medium)
            DSBadge("L", size: .large)
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
}
