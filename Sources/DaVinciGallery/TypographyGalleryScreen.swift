import SwiftUI
import DaVinciTokens

// MARK: - TypographyGalleryScreen

struct TypographyGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

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
                            .font(.system(size: theme.typography.body.size, weight: weight.fontWeight))
                            .foregroundStyle(theme.colors.semantic.textPrimary)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Typography")
    }

    // MARK: - Helpers

    private func styleRow(_ name: String, style: DSTextStyle) -> some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space1) {
            Text(name)
                .font(style.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textPrimary)

            Text("Size \(Int(style.size))  ·  Line height \(Int(style.lineHeight))")
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textTertiary)
        }
        .padding(.vertical, SpacingTokens.space1)
    }

    private func infoRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(theme.typography.body.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textPrimary)
            Spacer()
            Text(value)
                .font(theme.typography.callout.font(family: theme.typography.family))
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
