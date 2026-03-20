import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - DSSwitchGalleryScreen

struct DSSwitchGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    @State private var notifications = true
    @State private var darkMode = false
    @State private var analytics = true
    @State private var autoSave = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: SpacingTokens.space6) {

                GallerySection(title: "Basic Usage") {
                    DSSwitch(isOn: $notifications, label: "Enable notifications")
                    DSSwitch(isOn: $darkMode, label: "Dark mode")
                    DSSwitch(isOn: $analytics, label: "Analytics")
                    DSSwitch(isOn: $autoSave, label: "Auto-save")
                }

                GallerySection(title: "Unlabeled") {
                    HStack(spacing: SpacingTokens.space4) {
                        DSSwitch(isOn: .constant(true))
                        DSSwitch(isOn: .constant(false))
                    }
                }

                GallerySection(title: "States") {
                    DSText("On / Off", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSSwitch(isOn: .constant(true), label: "On")
                    DSSwitch(isOn: .constant(false), label: "Off")

                    DSText("Disabled", role: .caption, color: theme.colors.semantic.textSecondary)
                    DSSwitch(isOn: .constant(true), label: "On (disabled)", isDisabled: true)
                    DSSwitch(isOn: .constant(false), label: "Off (disabled)", isDisabled: true)
                }

                GallerySection(title: "Accessibility") {
                    DSSwitch(
                        isOn: $notifications,
                        label: "Notifications",
                        accessibilityLabel: "Enable push notifications for new messages"
                    )
                }

                GallerySection(title: "Edge Cases") {
                    DSSwitch(
                        isOn: $notifications,
                        label: "This is a very long switch label that should push the control to the trailing edge"
                    )
                    DSSwitch(isOn: .constant(true))
                }
            }
            .padding(SpacingTokens.space4)
        }
        .background(theme.colors.semantic.bgPrimary)
        .navigationTitle("Switch")
    }
}

// MARK: - Previews

#Preview("DSSwitch — Light") {
    NavigationStack { DSSwitchGalleryScreen() }
        .dsTheme(.defaultTheme)
}

#Preview("DSSwitch — Dark") {
    NavigationStack { DSSwitchGalleryScreen() }
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
