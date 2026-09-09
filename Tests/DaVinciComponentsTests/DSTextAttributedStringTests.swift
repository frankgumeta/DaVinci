import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

/// `DSText(AttributedString)` must apply the role's typography and colour as a *baseline*
/// without destroying attributes the caller already set. These tests pin that contract,
/// because the naive implementation — applying `.font()` to the rendered `Text` — silently
/// flattens inline styling and links.
@Suite("DSText AttributedString")
struct DSTextAttributedStringTests {

    private let theme = DSTheme.defaultTheme

    private func styled(
        _ input: AttributedString,
        role: DSText.Role = .body,
        color: Color = .primary
    ) -> AttributedString {
        DSText.styled(
            input,
            style: DSText.textStyle(for: role, theme: theme),
            family: theme.typography.family,
            color: color
        )
    }

    // MARK: - Baseline application

    @Test func unstyledRunsReceiveTheRoleFontAndColor() throws {
        let result = styled(AttributedString("Plain"), role: .headline, color: .red)
        let run = try #require(result.runs.first)

        #expect(run.font == theme.typography.headline.font(family: theme.typography.family))
        #expect(run.foregroundColor == .red)
    }

    @Test func eachRoleAppliesItsOwnStyle() {
        for role in DSText.Role.allCases {
            let expected = DSText.textStyle(for: role, theme: theme)
            let result = styled(AttributedString("Sample"), role: role)

            #expect(result.runs.first?.font == expected.font(family: theme.typography.family))
        }
    }

    // MARK: - Preservation

    @Test func inlineFontSurvivesTheBaseline() throws {
        var input = AttributedString("Regular and bold")
        let boldRange = try #require(input.range(of: "bold"))
        let inlineFont = Font.system(size: 13, weight: .bold)
        input[boldRange].font = inlineFont

        let result = styled(input, role: .body)
        let resultBoldRange = try #require(result.range(of: "bold"))

        #expect(result[resultBoldRange].font == inlineFont)
    }

    @Test func inlineColorSurvivesTheBaseline() throws {
        var input = AttributedString("Normal and green")
        let greenRange = try #require(input.range(of: "green"))
        input[greenRange].foregroundColor = .green

        let result = styled(input, role: .body, color: .red)
        let resultGreenRange = try #require(result.range(of: "green"))

        #expect(result[resultGreenRange].foregroundColor == .green)
    }

    @Test func linksSurviveTheBaseline() throws {
        var input = AttributedString("Read the license terms")
        let linkRange = try #require(input.range(of: "license"))
        let url = try #require(URL(string: "https://example.com/license"))
        input[linkRange].link = url

        let result = styled(input, role: .footnote)
        let resultLinkRange = try #require(result.range(of: "license"))

        #expect(result[resultLinkRange].link == url)
    }

    @Test func unstyledNeighboursOfAStyledRunStillGetTheBaseline() throws {
        var input = AttributedString("before bold after")
        let boldRange = try #require(input.range(of: "bold"))
        input[boldRange].font = .system(size: 13, weight: .bold)

        let result = styled(input, role: .body, color: .red)
        let beforeRange = try #require(result.range(of: "before"))
        let expected = theme.typography.body.font(family: theme.typography.family)

        #expect(result[beforeRange].font == expected)
        #expect(result[beforeRange].foregroundColor == .red)
    }

    // MARK: - Content integrity

    @Test func characterContentIsNeverAltered() {
        let original = AttributedString("Attribution: Kenneth — CC BY 4.0")
        let result = styled(original, role: .caption)

        #expect(String(result.characters) == String(original.characters))
    }

    @Test func emptyStringIsHandled() {
        let result = styled(AttributedString(""))
        #expect(String(result.characters).isEmpty)
    }

    // MARK: - View construction

    @MainActor
    @Test func bothInitialisersProduceDSText() {
        let plain = DSText("Plain", role: .body)
        let attributed = DSText(AttributedString("Attributed"), role: .body)

        #expect(type(of: plain) == DSText.self)
        #expect(type(of: attributed) == DSText.self)
    }

    @MainActor
    @Test func attributedInitAcceptsEveryRole() {
        for role in DSText.Role.allCases {
            let text = DSText(AttributedString("Sample"), role: role)
            #expect(type(of: text) == DSText.self)
        }
    }
}
