import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSText Snapshot Tests")
@MainActor
struct DSTextSnapshotTests {

    let recordMode = isRecordingSnapshots

    /// Sample text per role, chosen to show the role's intended use.
    private static func sample(for role: DSText.Role) -> String {
        switch role {
        case .display:     "Display"
        case .titleLarge:  "Title Large"
        case .titleMedium: "Title Medium"
        case .titleSmall:  "Title Small"
        case .headline:    "Headline"
        case .subheadline: "Subheadline"
        case .body:        "Body text content"
        case .callout:     "Callout text"
        case .footnote:    "Footnote text"
        case .caption:     "Caption text"
        case .labelLarge:  "Label Large"
        case .labelMedium: "Label Medium"
        case .labelSmall:  "Label Small"
        case .overline:    "OVERLINE"
        }
    }

    /// A canvas tall enough for the role's line height, so descenders are never clipped.
    private static func canvas(for role: DSText.Role) -> CGSize {
        let style = DSText.textStyle(for: role, theme: .defaultTheme)
        return CGSize(width: 320, height: ceil(style.lineHeight) + 16)
    }

    private func assertRole(_ role: DSText.Role, colorScheme: ColorScheme) throws {
        try SnapshotTester.assertSnapshot(
            DSText(Self.sample(for: role), role: role),
            named: "text-\(role.rawValue)",
            size: Self.canvas(for: role),
            colorScheme: colorScheme,
            record: recordMode
        )
    }

    // MARK: - Every Role, Light

    @Test(arguments: DSText.Role.allCases)
    func role_light(_ role: DSText.Role) throws {
        try assertRole(role, colorScheme: .light)
    }

    // MARK: - Every Role, Dark

    @Test(arguments: DSText.Role.allCases)
    func role_dark(_ role: DSText.Role) throws {
        try assertRole(role, colorScheme: .dark)
    }

    // MARK: - Colour Override

    @Test func customColor_light() throws {
        let text = DSText("Custom Color", role: .body, color: .red)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-custom-color",
            size: CGSize(width: 300, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func customColor_dark() throws {
        let text = DSText("Custom Color", role: .body, color: .red)
        try SnapshotTester.assertSnapshot(
            text,
            named: "text-custom-color",
            size: CGSize(width: 300, height: 30),
            colorScheme: .dark,
            record: recordMode
        )
    }

    // MARK: - Tabular Figures

    /// Proportional and tabular digits must render differently, otherwise
    /// `DSDigitStyle` is not reaching the resolved font.
    @Test func monospacedDigits_light() throws {
        let theme = DSTheme.defaultTheme
        let text = Text("11:19  88.10")
            .dsTextStyle(theme.typography.body.monospacedDigits(), family: theme.typography.family)
            .foregroundStyle(theme.colors.semantic.textPrimary)

        try SnapshotTester.assertSnapshot(
            text,
            named: "text-monospaced-digits",
            size: CGSize(width: 300, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func proportionalDigits_light() throws {
        let theme = DSTheme.defaultTheme
        let text = Text("11:19  88.10")
            .dsTextStyle(theme.typography.body, family: theme.typography.family)
            .foregroundStyle(theme.colors.semantic.textPrimary)

        try SnapshotTester.assertSnapshot(
            text,
            named: "text-proportional-digits",
            size: CGSize(width: 300, height: 30),
            colorScheme: .light,
            record: recordMode
        )
    }

    // MARK: - Attributed Text

    private static var attributedSample: AttributedString {
        var text = AttributedString("Baseline with bold and link")
        if let bold = text.range(of: "bold") {
            text[bold].font = .system(size: 16, weight: .bold)
        }
        if let link = text.range(of: "link") {
            text[link].link = URL(string: "https://example.com")
        }
        return text
    }

    @Test func attributed_light() throws {
        try SnapshotTester.assertSnapshot(
            DSText(Self.attributedSample, role: .body),
            named: "text-attributed",
            size: CGSize(width: 320, height: 32),
            colorScheme: .light,
            record: recordMode
        )
    }

    @Test func attributed_dark() throws {
        try SnapshotTester.assertSnapshot(
            DSText(Self.attributedSample, role: .body),
            named: "text-attributed",
            size: CGSize(width: 320, height: 32),
            colorScheme: .dark,
            record: recordMode
        )
    }

    /// The attributed and plain renderings of the same characters must differ,
    /// proving the inline attributes were not flattened by the baseline merge.
    @Test func attributedDiffersFromPlain_light() throws {
        try SnapshotTester.assertSnapshot(
            DSText("Baseline with bold and link", role: .body),
            named: "text-attributed-plain-control",
            size: CGSize(width: 320, height: 32),
            colorScheme: .light,
            record: recordMode
        )
    }
}
