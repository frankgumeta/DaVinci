import SwiftUI
import DaVinciTokens

// MARK: - Previews

private struct DSActionRowShowcase: View {
    @State private var selection = "Midnight"

    private let themes = ["Midnight", "Daylight", "Sepia"]

    var body: some View {
        VStack(spacing: SpacingTokens.space4) {
            DSText("Action rows", role: .headline)

            DSActionRow(action: {}, content: {
                DSRowLabel(title: "Open settings", subtitle: "Tappable row")
            })
            DSDivider(style: .hairline)
            DSActionRow(isDisabled: true, action: {}, content: {
                DSRowLabel(title: "Disabled", subtitle: "Not interactive")
            })
            DSDivider(style: .hairline)
            DSActionRow(isLoading: true, action: {}, content: {
                DSRowLabel(title: "Loading", subtitle: "Inert while work is in flight")
            })

            DSText("Selectable rows", role: .headline)

            ForEach(themes, id: \.self) { theme in
                DSSelectableRow(
                    isSelected: selection == theme,
                    action: { selection = theme },
                    content: { DSRowLabel(title: theme) }
                )
            }

            DSSelectableRow(
                isSelected: false,
                isDisabled: true,
                action: {},
                content: { DSRowLabel(title: "Unavailable") }
            )

            DSText("With leading content", role: .headline)

            DSSelectableRow(
                isSelected: true,
                action: {},
                leading: { Circle().fill(.purple).frame(width: 20, height: 20) },
                content: { DSRowLabel(title: "Midnight", subtitle: "Dark palette") }
            )
        }
        .padding()
    }
}

#Preview("DSActionRow - Light") {
    DSActionRowShowcase()
        .dsTheme(.defaultTheme)
}

#Preview("DSActionRow - Dark") {
    DSActionRowShowcase()
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
