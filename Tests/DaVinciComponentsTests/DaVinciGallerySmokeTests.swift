import SwiftUI
import Testing
import UIKit
@testable import DaVinciGallery
@testable import DaVinciTokens

@Suite("DaVinci Gallery Smoke Tests")
@MainActor
struct DaVinciGallerySmokeTests {

    private struct GalleryScreen {
        let name: String
        let view: AnyView
        let rasterize: Bool
    }

    private static let canvas = CGSize(width: 390, height: 844)

    @Test("Every gallery screen constructs with the default theme")
    func everyScreenConstructsWithDefaultTheme() {
        let screens = galleryScreens()

        for screen in screens {
            _ = configured(
                screen.view,
                theme: .defaultTheme,
                colorScheme: .light
            )
        }
    }

    @Test("Every gallery screen constructs with alternate theme, RTL and accessibility type")
    func everyScreenConstructsWithAlternateTheme() {
        let screens = galleryScreens()

        for screen in screens {
            _ = configured(
                screen.view,
                theme: .alternate,
                colorScheme: .dark,
                layoutDirection: .rightToLeft,
                dynamicTypeSize: .accessibility2
            )
        }
    }

    @Test("Pure SwiftUI gallery screens rasterize in both themes")
    func pureSwiftUIScreensRasterize() {
        for screen in galleryScreens() where screen.rasterize {
            #expect(
                renders(screen.view, theme: .defaultTheme, colorScheme: .light),
                "\(screen.name) did not rasterize with the default theme"
            )
            #expect(
                renders(
                    screen.view,
                    theme: .alternate,
                    colorScheme: .dark,
                    layoutDirection: .rightToLeft,
                    dynamicTypeSize: .accessibility2
                ),
                "\(screen.name) did not rasterize with the alternate theme"
            )
        }
    }

    @Test("Gallery exposes every navigation destination")
    func allNavigationDestinationsAreCovered() {
        let names = galleryScreens().map(\.name)

        #expect(names.count == 22)
        #expect(Set(names).count == names.count)
        #expect(names.contains("Home"))
        #expect(names.contains("Components"))
        #expect(names.contains("Remote Image"))
        #expect(names.contains("Skeletons"))
    }

    private func galleryScreens() -> [GalleryScreen] {
        return [
            homeScreen(),
            screen("Colors", ColorGalleryScreen()),
            screen("Typography", TypographyGalleryScreen()),
            screen("Layout", LayoutGalleryScreen()),
            screen("Effects", EffectsGalleryScreen()),
            screen("Components", ComponentsListScreen(), rasterize: false),
            screen("Skeletons", SkeletonGalleryScreen()),
            screen("Text", DSTextGalleryScreen()),
            screen("Button", DSButtonGalleryScreen()),
            screen("Icon Button", DSIconButtonGalleryScreen()),
            screen("Switch", DSSwitchGalleryScreen(), rasterize: false),
            screen("Segmented Control", DSSegmentedControlGalleryScreen(), rasterize: false),
            screen("Text Field", DSTextFieldGalleryScreen(), rasterize: false),
            screen("Progress Bar", DSProgressBarGalleryScreen(), rasterize: false),
            screen("Badge", DSBadgeGalleryScreen()),
            screen("Activity Indicator", DSActivityIndicatorGalleryScreen(), rasterize: false),
            screen("Divider", DSDividerGalleryScreen()),
            screen("Card", DSCardGalleryScreen()),
            screen("Surface", DSSurfaceGalleryScreen()),
            screen("List Row", DSListRowGalleryScreen()),
            screen("Action Row", DSActionRowGalleryScreen()),
            screen("Remote Image", DSRemoteImageGalleryScreen(), rasterize: false)
        ]
    }

    private func homeScreen() -> GalleryScreen {
        let theme = Binding.constant(DSTheme.defaultTheme)
        let colorScheme = Binding<ColorScheme?>.constant(nil)
        let view = GalleryHomeScreen(
            currentTheme: theme,
            colorSchemeOverride: colorScheme
        )
        return screen("Home", view, rasterize: false)
    }

    private func screen<V: View>(
        _ name: String,
        _ view: V,
        rasterize: Bool = true
    ) -> GalleryScreen {
        GalleryScreen(name: name, view: AnyView(view), rasterize: rasterize)
    }

    private func configured(
        _ view: AnyView,
        theme: DSTheme,
        colorScheme: ColorScheme,
        layoutDirection: LayoutDirection = .leftToRight,
        dynamicTypeSize: DynamicTypeSize = .large
    ) -> some View {
        view
            .frame(width: Self.canvas.width, height: Self.canvas.height)
            .dsTheme(theme)
            .preferredColorScheme(colorScheme)
            .environment(\.layoutDirection, layoutDirection)
            .environment(\.dynamicTypeSize, dynamicTypeSize)
    }

    private func renders(
        _ view: AnyView,
        theme: DSTheme,
        colorScheme: ColorScheme,
        layoutDirection: LayoutDirection = .leftToRight,
        dynamicTypeSize: DynamicTypeSize = .large
    ) -> Bool {
        let content = configured(
            view,
            theme: theme,
            colorScheme: colorScheme,
            layoutDirection: layoutDirection,
            dynamicTypeSize: dynamicTypeSize
        )

        let renderer = ImageRenderer(content: content)
        renderer.scale = 1.0
        return renderer.uiImage != nil
    }
}
