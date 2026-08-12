import SwiftUI
import DaVinciTokens

// MARK: - Previews

#Preview("DSText — All Roles") {
    VStack(alignment: .leading, spacing: 8) {
        DSText("Display", role: .display)
        DSText("Title", role: .title)
        DSText("Headline", role: .headline)
        DSText("Body text", role: .body)
        DSText("Callout text", role: .callout)
        DSText("Caption text", role: .caption)
        DSText("OVERLINE", role: .overline)
    }
    .padding()
}

#Preview("DSText — Accessibility") {
    VStack(alignment: .leading, spacing: 16) {
        DSText("Page Title", role: .title)
        // Automatically marked as .isHeader

        DSText("Section Heading", role: .headline)
        // Automatically marked as .isHeader

        DSText(
            "Important Notice",
            role: .body,
            color: .red,
            accessibilityLabel: "Alert: Important Notice",
            accessibilityTraits: .isStaticText
        )

        DSText("Regular body text", role: .body)
        // Default static text, no special traits
    }
    .padding()
}
