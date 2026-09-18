import SwiftUI
import Testing
import DaVinciComponents
import DaVinciTokens

@MainActor
@Suite("Public API Examples")
struct PublicAPICompilationTests {
    @Test func canonicalComponentExamplesCompile() {
        var text = ""
        var selection = 0
        let textBinding = Binding(get: { text }, set: { text = $0 })
        let selectionBinding = Binding(get: { selection }, set: { selection = $0 })
        let plus = DSSymbol.firstAvailable("plus.circle.fill", "plus")
        guard let plus else {
            Issue.record("Expected a bundled fallback symbol")
            return
        }

        _ = DSBadge("Stable", tone: .success, appearance: .subtle)
        _ = DSButton("Add", appearance: .primary, icon: .leading(plus)) {}
        _ = DSTextField(
            "Search",
            text: textBinding,
            configuration: .underlined.leading(plus).trailing(.clear)
        )
        _ = DSRemoteImage(
            url: nil,
            geometry: .circle(diameter: 80),
            placeholder: DSSymbol(systemName: "person.crop.circle")
        )
        _ = DSRemoteImage(
            url: URL(string: "https://example.com/photo.jpg"),
            geometry: .rounded(
                size: CGSize(width: 120, height: 80),
                cornerRadius: RadiusTokens.medium
            ),
            loading: {
                Image(systemName: "hourglass")
            }
        )
        _ = DSRemoteImage(
            url: URL(string: "https://example.com/avatar.jpg"),
            geometry: .circle(diameter: 80),
            loading: {
                ZStack {
                    ProgressView()
                    Text("Loading")
                }
            }
        )
        _ = DSSegmentedControl(
            options: ["List", "Grid"],
            selectedIndex: selectionBinding,
            appearance: .subtle
        )
        _ = DSProgressBar(value: 0.5, style: .shimmer)
        _ = DSCard(style: .outlined) { Text("Summary") }
    }

    /// Everything added in 2.0 must be reachable without `@testable`.
    ///
    /// This file imports `DaVinciComponents` normally, so anything referenced here is
    /// provably part of the public surface — which is the only way to assert that
    /// `DSPressableButtonStyle` really was published rather than left internal.
    @Test func twoPointZeroSurfaceIsPublic() {
        // Typography: the label family and tabular figures.
        _ = DSText("Control label", role: .labelLarge)
        _ = DSText(AttributedString("Attributed"), role: .footnote)
        _ = DSTypography().labelMedium.monospacedDigits()
        _ = DSTypography().namedStyles

        // Surfaces, composed without any card padding.
        _ = Text("Swatch").dsSurface(.outline)
        _ = Text("Chip").dsSurface(.pill)
        _ = Text("Custom").dsSurface(
            DSSurfaceStyle(shape: .circle, fill: .color(.red), stroke: .accent)
        )

        // Rows: layout, action and selection kept separate.
        _ = DSListRow(title: "Language", value: "English")
        _ = DSListRow(title: "Appearance", subtitle: "Follows the system")
        _ = DSListRow(
            leading: { Image(systemName: "globe") },
            trailing: { DSRowAccessory(.chevron) },
            content: { DSText("Language", role: .body) }
        )
        _ = DSActionRow(action: {}, content: { DSRowLabel(title: "Open", subtitle: nil) })
        _ = DSSelectableRow(isSelected: true, action: {}, content: { DSText("Midnight", role: .body) })

        // Controls and feedback.
        _ = DSActivityIndicator(size: .small)
        _ = DSButton("Buy", size: .compact) {}
        _ = Button("Custom control") {}
            .buttonStyle(DSPressableButtonStyle(duration: 0.2))

        if let play = DSSymbol(systemName: "play.fill") {
            _ = DSIconButton(symbol: play, titleForAccessibility: "Play", shape: .circle) {}
        }

        _ = ControlHeightTokens.minimumHitTarget
        _ = ControlHeightTokens.compact
    }

    @Test func canonicalThemeValidationExampleCompiles() {
        let brand = BrandColors(primary: .indigo, secondary: .blue, tertiary: .cyan)
        let feedback = FeedbackColors()
        let colors = DSColors(
            brand: brand,
            feedback: feedback,
            textEmphasis: TextEmphasisColors(brand: brand.primary, feedback: feedback)
        )
        let theme = DSTheme(name: "Consumer", colors: colors)

        _ = DSThemeValidator.validate(theme)
    }
}
