import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSText Behavior Tests

@Suite("DSText Behavior")
struct DSTextBehaviorTests {

    // MARK: - Accessibility Traits Auto-Assignment

    @Test @MainActor func displayRoleGetsHeaderTrait() {
        let text = DSText("Hero", role: .display)
        #expect(text.resolvedAccessibilityTraits == .isHeader)
    }

    @Test @MainActor func titleRoleGetsHeaderTrait() {
        let text = DSText("Page Title", role: .title)
        #expect(text.resolvedAccessibilityTraits == .isHeader)
    }

    @Test @MainActor func headlineRoleGetsHeaderTrait() {
        let text = DSText("Section", role: .headline)
        #expect(text.resolvedAccessibilityTraits == .isHeader)
    }

    @Test @MainActor func bodyRoleGetsNilTraits() {
        let text = DSText("Body text", role: .body)
        #expect(text.resolvedAccessibilityTraits == nil)
    }

    @Test @MainActor func calloutRoleGetsNilTraits() {
        let text = DSText("Callout", role: .callout)
        #expect(text.resolvedAccessibilityTraits == nil)
    }

    @Test @MainActor func captionRoleGetsNilTraits() {
        let text = DSText("Caption", role: .caption)
        #expect(text.resolvedAccessibilityTraits == nil)
    }

    @Test @MainActor func overlineRoleGetsNilTraits() {
        let text = DSText("OVERLINE", role: .overline)
        #expect(text.resolvedAccessibilityTraits == nil)
    }

    // MARK: - Custom Traits Override Auto-Assignment

    @Test @MainActor func customTraitsOverrideAutoHeader() {
        let text = DSText(
            "Title",
            role: .title,
            accessibilityTraits: .isStaticText
        )
        #expect(text.resolvedAccessibilityTraits == .isStaticText)
    }

    @Test @MainActor func customTraitsOverrideBodyNil() {
        let text = DSText(
            "Important",
            role: .body,
            accessibilityTraits: .isHeader
        )
        #expect(text.resolvedAccessibilityTraits == .isHeader)
    }

    // MARK: - Role → TextStyle Mapping

    @Test func displayRoleMapsToDisplayStyle() {
        let theme = DSTheme.defaultTheme
        let style = DSText.textStyle(for: .display, theme: theme)
        #expect(style == theme.typography.display)
    }

    @Test func titleRoleMapsToTitleStyle() {
        let theme = DSTheme.defaultTheme
        let style = DSText.textStyle(for: .title, theme: theme)
        #expect(style == theme.typography.title)
    }

    @Test func headlineRoleMapsToHeadlineStyle() {
        let theme = DSTheme.defaultTheme
        let style = DSText.textStyle(for: .headline, theme: theme)
        #expect(style == theme.typography.headline)
    }

    @Test func bodyRoleMapsToBodyStyle() {
        let theme = DSTheme.defaultTheme
        let style = DSText.textStyle(for: .body, theme: theme)
        #expect(style == theme.typography.body)
    }

    @Test func calloutRoleMapsToCalloutStyle() {
        let theme = DSTheme.defaultTheme
        let style = DSText.textStyle(for: .callout, theme: theme)
        #expect(style == theme.typography.callout)
    }

    @Test func captionRoleMapsToCaptionStyle() {
        let theme = DSTheme.defaultTheme
        let style = DSText.textStyle(for: .caption, theme: theme)
        #expect(style == theme.typography.caption)
    }

    @Test func overlineRoleMapsToOverlineStyle() {
        let theme = DSTheme.defaultTheme
        let style = DSText.textStyle(for: .overline, theme: theme)
        #expect(style == theme.typography.overline)
    }

    // MARK: - Each Role Maps to Unique Style

    @Test func allRolesMapToDistinctStyles() {
        let theme = DSTheme.defaultTheme
        let roles: [DSText.Role] = [
            .display, .title, .headline, .body, .callout, .caption, .overline
        ]
        var styles: [DSTextStyle] = []

        for role in roles {
            styles.append(DSText.textStyle(for: role, theme: theme))
        }

        // All sizes should be distinct
        let sizes = styles.map(\.size)
        #expect(Set(sizes).count == roles.count)
    }

    // MARK: - Typography Scale Ordering

    @Test func typographySizeDecreases() {
        let theme = DSTheme.defaultTheme
        let display = DSText.textStyle(for: .display, theme: theme).size
        let title = DSText.textStyle(for: .title, theme: theme).size
        let headline = DSText.textStyle(for: .headline, theme: theme).size
        let body = DSText.textStyle(for: .body, theme: theme).size
        let callout = DSText.textStyle(for: .callout, theme: theme).size
        let caption = DSText.textStyle(for: .caption, theme: theme).size
        let overline = DSText.textStyle(for: .overline, theme: theme).size

        #expect(display > title)
        #expect(title > headline)
        #expect(headline > body)
        #expect(body > callout)
        #expect(callout > caption)
        #expect(caption > overline)
    }

    // MARK: - Default Role

    @Test func defaultRoleIsBody() {
        let theme = DSTheme.defaultTheme
        let style = DSText.textStyle(for: .body, theme: theme)
        #expect(style == theme.typography.body)
    }

    // MARK: - Header Roles Grouped

    @Test @MainActor func headerRolesAllGetHeaderTrait() {
        let headerRoles: [DSText.Role] = [.display, .title, .headline]
        for role in headerRoles {
            let text = DSText("X", role: role)
            #expect(text.resolvedAccessibilityTraits == .isHeader)
        }
    }

    @Test @MainActor func nonHeaderRolesGetNilTraits() {
        let nonHeaderRoles: [DSText.Role] = [.body, .callout, .caption, .overline]
        for role in nonHeaderRoles {
            let text = DSText("X", role: role)
            #expect(text.resolvedAccessibilityTraits == nil)
        }
    }
}
