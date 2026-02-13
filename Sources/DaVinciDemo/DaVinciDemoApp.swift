import SwiftUI
import DaVinciTokens
import DaVinciGallery

@main
struct DaVinciDemoApp: App {
    @State private var currentTheme = DSTheme.defaultTheme
    @State private var colorSchemeOverride: ColorScheme?

    var body: some Scene {
        WindowGroup {
            GalleryHomeScreen(
                currentTheme: $currentTheme,
                colorSchemeOverride: $colorSchemeOverride
            )
            .dsTheme(currentTheme)
            .preferredColorScheme(colorSchemeOverride)
        }
    }
}
