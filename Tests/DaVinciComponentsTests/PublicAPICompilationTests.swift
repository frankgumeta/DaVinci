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
        _ = DSSegmentedControl(
            options: ["List", "Grid"],
            selectedIndex: selectionBinding,
            appearance: .subtle
        )
        _ = DSProgressBar(value: 0.5, style: .shimmer)
        _ = DSCard(style: .outlined) { Text("Summary") }
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
