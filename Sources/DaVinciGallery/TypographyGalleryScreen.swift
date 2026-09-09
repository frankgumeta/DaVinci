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

            Section("Display") {
                styleRow("display", style: theme.typography.display)
            }

            Section("Title") {
                styleRow("titleLarge", style: theme.typography.titleLarge)
                styleRow("titleMedium", style: theme.typography.titleMedium)
                styleRow("titleSmall", style: theme.typography.titleSmall)
            }

            Section("Heading") {
                styleRow("headline", style: theme.typography.headline)
                styleRow("subheadline", style: theme.typography.subheadline)
            }

            Section("Body") {
                styleRow("body", style: theme.typography.body)
                styleRow("callout", style: theme.typography.callout)
                styleRow("footnote", style: theme.typography.footnote)
                styleRow("caption", style: theme.typography.caption)
            }

            Section("Label") {
                styleRow("labelLarge", style: theme.typography.labelLarge)
                styleRow("labelMedium", style: theme.typography.labelMedium)
                styleRow("labelSmall", style: theme.typography.labelSmall)
            }

            Section("Utility") {
                styleRow("overline", style: theme.typography.overline)
            }

            Section("Tabular Figures") {
                VStack(alignment: .leading, spacing: SpacingTokens.space2) {
                    Text("Proportional  12:04 · 88.10 · 11:19")
                        .dsTextStyle(theme.typography.body, family: theme.typography.family)
                        .foregroundStyle(theme.colors.semantic.textPrimary)
                    Text("Monospaced    12:04 · 88.10 · 11:19")
                        .dsTextStyle(
                            theme.typography.body.monospacedDigits(),
                            family: theme.typography.family
                        )
                        .foregroundStyle(theme.colors.semantic.textPrimary)
                }
                .padding(.vertical, SpacingTokens.space1)
            }

            Section("Attributed Text") {
                DSText(attributedSample, role: .footnote)
                    .padding(.vertical, SpacingTokens.space1)
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

    /// Demonstrates that inline attributes survive the role's baseline typography.
    private var attributedSample: AttributedString {
        var text = AttributedString("Roles set a baseline; bold, colour and links survive.")
        if let bold = text.range(of: "bold") {
            text[bold].font = .system(size: 13, weight: .bold)
        }
        if let colour = text.range(of: "colour") {
            text[colour].foregroundColor = theme.colors.feedback.success
        }
        if let links = text.range(of: "links") {
            text[links].link = URL(string: "https://github.com/frankgumeta/DaVinci")
        }
        return text
    }

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
