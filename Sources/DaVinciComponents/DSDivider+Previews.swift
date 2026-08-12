import SwiftUI
import DaVinciTokens

// MARK: - Previews

#Preview("DSDivider - Light") {
    VStack(spacing: SpacingTokens.space4) {
        DSText("Horizontal", role: .headline)

        DSText("Hairline", role: .caption)
        DSDivider(style: .hairline)

        DSText("Regular", role: .caption)
        DSDivider(style: .regular)

        DSText("Vertical", role: .headline)
        HStack(spacing: SpacingTokens.space4) {
            DSText("Left", role: .body)
            DSDivider(orientation: .vertical, style: .regular)
                .frame(height: 40)
            DSText("Middle", role: .body)
            DSDivider(orientation: .vertical, style: .hairline)
                .frame(height: 40)
            DSText("Right", role: .body)
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSDivider - Dark") {
    VStack(spacing: SpacingTokens.space4) {
        DSText("Hairline", role: .caption)
        DSDivider(style: .hairline)

        DSText("Regular", role: .caption)
        DSDivider(style: .regular)

        HStack(spacing: SpacingTokens.space4) {
            DSText("Left", role: .body)
            DSDivider(orientation: .vertical)
                .frame(height: 40)
            DSText("Right", role: .body)
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
