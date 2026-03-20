import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - ComponentsListScreen

/// Entry point for the component gallery.
/// Each row navigates to its dedicated component screen.
struct ComponentsListScreen: View {
    var body: some View {
        List {
            Section("Typography") {
                NavigationLink("Text") { DSTextGalleryScreen() }
            }

            Section("Controls") {
                NavigationLink("Button") { DSButtonGalleryScreen() }
                NavigationLink("Icon Button") { DSIconButtonGalleryScreen() }
                NavigationLink("Switch") { DSSwitchGalleryScreen() }
                NavigationLink("Segmented Control") { DSSegmentedControlGalleryScreen() }
                NavigationLink("Text Field") { DSTextFieldGalleryScreen() }
            }

            Section("Feedback") {
                NavigationLink("Progress Bar") { DSProgressBarGalleryScreen() }
                NavigationLink("Badge") { DSBadgeGalleryScreen() }
            }

            Section("Structure") {
                NavigationLink("Divider") { DSDividerGalleryScreen() }
                NavigationLink("Card") { DSCardGalleryScreen() }
            }
        }
        .navigationTitle("Components")
    }
}

// MARK: - Previews

#Preview("Components List") {
    NavigationStack {
        ComponentsListScreen()
    }
    .dsTheme(.defaultTheme)
}

#Preview("Components List — Dark") {
    NavigationStack {
        ComponentsListScreen()
    }
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
