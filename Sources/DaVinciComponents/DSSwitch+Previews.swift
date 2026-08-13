import SwiftUI
import DaVinciTokens

// MARK: - Previews

#Preview("DSSwitch - Light") {
    VStack(alignment: .leading, spacing: SpacingTokens.space4) {
        DSText("Labeled", role: .caption)
        DSSwitch(isOn: .constant(true), label: "On")
        DSSwitch(isOn: .constant(false), label: "Off")

        DSDivider()

        DSText("Unlabeled", role: .caption)
        HStack(spacing: SpacingTokens.space4) {
            DSSwitch(isOn: .constant(true))
            DSSwitch(isOn: .constant(false))
        }

        DSDivider()

        DSText("Disabled", role: .caption)
        DSSwitch(isOn: .constant(true), label: "On (disabled)", isDisabled: true)
        DSSwitch(isOn: .constant(false), label: "Off (disabled)", isDisabled: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSSwitch - Dark") {
    VStack(alignment: .leading, spacing: SpacingTokens.space4) {
        DSSwitch(isOn: .constant(true), label: "On")
        DSSwitch(isOn: .constant(false), label: "Off")

        DSDivider()

        DSSwitch(isOn: .constant(true), label: "On (disabled)", isDisabled: true)
        DSSwitch(isOn: .constant(false), label: "Off (disabled)", isDisabled: true)

        DSDivider()

        HStack(spacing: SpacingTokens.space4) {
            DSSwitch(isOn: .constant(true))
            DSSwitch(isOn: .constant(false))
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
