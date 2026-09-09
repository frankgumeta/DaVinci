import SwiftUI
import DaVinciTokens

// MARK: - Previews

private struct DSListRowShowcase: View {
    var body: some View {
        VStack(spacing: SpacingTokens.space4) {
            DSText("Presets", role: .headline)

            DSListRow(title: "Language", value: "English")
            DSDivider(style: .hairline)
            DSListRow(title: "Appearance", subtitle: "Follows the system")

            DSText("Slots", role: .headline)

            DSListRow(
                leading: { Image(systemName: "globe") },
                trailing: { DSRowAccessory(.chevron) },
                content: { DSRowLabel(title: "Region", subtitle: "Mexico") }
            )

            DSListRow(
                leading: { Image(systemName: "icloud") },
                trailing: { DSRowAccessory(.activity) },
                content: { DSRowLabel(title: "Syncing") }
            )

            DSText("Vertical alignment", role: .headline)

            // .top keeps the icon beside the title when the subtitle wraps; the
            // switch stays centred on the row either way.
            DSListRow(
                alignment: .top,
                leading: { Image(systemName: "headphones").frame(width: 32, height: 32) },
                trailing: { DSSwitch(isOn: .constant(true)) },
                content: {
                    DSRowLabel(
                        title: "Spatial audio",
                        subtitle: "Requires headphones with motion sensors, and shows "
                            + "controls while an ambience is playing."
                    )
                }
            )

            DSText("Accessories", role: .headline)

            DSListRow(
                leading: { EmptyView() },
                trailing: { DSRowAccessory(.selection(isSelected: true)) },
                content: { DSRowLabel(title: "Selected") }
            )

            DSListRow(
                leading: { EmptyView() },
                trailing: { DSRowAccessory(.selection(isSelected: false)) },
                content: { DSRowLabel(title: "Not selected") }
            )
        }
        .padding()
    }
}

#Preview("DSListRow - Light") {
    DSListRowShowcase()
        .dsTheme(.defaultTheme)
}

#Preview("DSListRow - Dark") {
    DSListRowShowcase()
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
