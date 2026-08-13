import SwiftUI
import DaVinciTokens
import DaVinciComponents

// MARK: - TypographyGalleryScreen

struct TypographyGalleryScreen: View {
    @Environment(\.dsTheme) private var theme
    @State private var accessibilityText = ""
    @State private var accessibilitySelection = 0

    var body: some View {
        List {
            Section("Font Family") {
                infoRow("Brand", value: theme.typography.family.brand ?? "(system)")
                infoRow("Resolved", value: theme.typography.family.resolved)
            }

            Section("Text Styles") {
                styleRow("Display", style: theme.typography.display)
                styleRow("Title", style: theme.typography.title)
                styleRow("Headline", style: theme.typography.headline)
                styleRow("Body", style: theme.typography.body)
                styleRow("Callout", style: theme.typography.callout)
                styleRow("Caption", style: theme.typography.caption)
                styleRow("Overline", style: theme.typography.overline)
            }

            Section("Allowed Weights") {
                ForEach(AllowedWeight.allCases, id: \.self) { weight in
                    HStack {
                        Text(weight.rawValue.capitalized)
                            .dsTextStyle(
                                DSTextStyle(
                                    size: theme.typography.body.size,
                                    lineHeight: theme.typography.body.lineHeight,
                                    weight: weight.fontWeight,
                                    relativeTo: theme.typography.body.relativeTo
                                ),
                                family: theme.typography.family
                            )
                            .foregroundStyle(theme.colors.semantic.textPrimary)
                        Spacer()
                    }
                }
            }

            Section("Accessibility Size") {
                VStack(alignment: .leading, spacing: SpacingTokens.space4) {
                    DSText(
                        "A longer body example wraps without losing its typography hierarchy.",
                        role: .body
                    )
                    DSButton("Continue with accessible text", icon: .trailing(DSSymbol(systemName: "arrow.right")!)) {}
                    DSBadge("Accessible status", tone: .success, size: .large)
                    DSSegmentedControl(
                        options: ["Overview", "Activity"],
                        selectedIndex: $accessibilitySelection
                    )
                    DSTextField(
                        "Email address",
                        text: $accessibilityText,
                        prompt: "you@example.com"
                    )
                }
                .dynamicTypeSize(.accessibility3)
            }
        }
        .navigationTitle("Typography")
    }

    // MARK: - Helpers

    private func styleRow(_ name: String, style: DSTextStyle) -> some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space1) {
            Text(name)
                .dsTextStyle(style, family: theme.typography.family)
                .foregroundStyle(theme.colors.semantic.textPrimary)

            Text("Size \(Int(style.size))  ·  Line height \(Int(style.lineHeight))")
                .dsTextStyle(theme.typography.caption, family: theme.typography.family)
                .foregroundStyle(theme.colors.semantic.textTertiary)
        }
        .padding(.vertical, SpacingTokens.space1)
    }

    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .dsTextStyle(theme.typography.body, family: theme.typography.family)
                .foregroundStyle(theme.colors.semantic.textPrimary)
            Spacer()
            Text(value)
                .dsTextStyle(theme.typography.callout, family: theme.typography.family)
                .foregroundStyle(theme.colors.semantic.textSecondary)
        }
    }
}

// MARK: - Previews

#Preview("Typography — Default") {
    NavigationStack {
        TypographyGalleryScreen()
    }
    .dsTheme(.defaultTheme)
}

#Preview("Typography — Alternate") {
    NavigationStack {
        TypographyGalleryScreen()
    }
    .dsTheme(.alternate)
}

#Preview("Typography — Accessibility") {
    NavigationStack {
        TypographyGalleryScreen()
    }
    .dsTheme(.defaultTheme)
    .dynamicTypeSize(.accessibility3)
}
