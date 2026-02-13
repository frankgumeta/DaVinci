import SwiftUI
import DaVinciTokens

// MARK: - LayoutGalleryScreen

struct LayoutGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    var body: some View {
        List {
            spacingSection
            radiusSection
            strokeSection
            controlHeightSection
        }
        .navigationTitle("Layout")
    }

    // MARK: - Spacing

    private var spacingSection: some View {
        Section("Spacing") {
            spacingRow("space.1", value: SpacingTokens.space1)
            spacingRow("space.2", value: SpacingTokens.space2)
            spacingRow("space.3", value: SpacingTokens.space3)
            spacingRow("space.4", value: SpacingTokens.space4)
            spacingRow("space.5", value: SpacingTokens.space5)
            spacingRow("space.6", value: SpacingTokens.space6)
            spacingRow("space.7", value: SpacingTokens.space7)
            spacingRow("space.8", value: SpacingTokens.space8)
        }
    }

    private func spacingRow(_ name: String, value: CGFloat) -> some View {
        HStack(spacing: SpacingTokens.space3) {
            RoundedRectangle(cornerRadius: 2)
                .fill(theme.colors.brand.primary)
                .frame(width: value, height: 20)

            Text(name)
                .font(theme.typography.body.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textPrimary)

            Spacer()

            Text("\(Int(value))pt")
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textTertiary)
        }
    }

    // MARK: - Radius

    private var radiusSection: some View {
        Section("Radius") {
            radiusRow("extraSmall", value: RadiusTokens.extraSmall)
            radiusRow("small", value: RadiusTokens.small)
            radiusRow("medium", value: RadiusTokens.medium)
            radiusRow("large", value: RadiusTokens.large)
        }
    }

    private func radiusRow(_ name: String, value: CGFloat) -> some View {
        HStack(spacing: SpacingTokens.space3) {
            RoundedRectangle(cornerRadius: value)
                .fill(theme.colors.brand.primary.opacity(0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: value)
                        .stroke(theme.colors.brand.primary, lineWidth: StrokeTokens.hairline)
                )
                .frame(width: 44, height: 44)

            Text(name)
                .font(theme.typography.body.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textPrimary)

            Spacer()

            Text("\(Int(value))pt")
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textTertiary)
        }
    }

    // MARK: - Stroke

    private var strokeSection: some View {
        Section("Stroke") {
            strokeRow("hairline", value: StrokeTokens.hairline)
            strokeRow("default", value: StrokeTokens.default)
        }
    }

    private func strokeRow(_ name: String, value: CGFloat) -> some View {
        HStack(spacing: SpacingTokens.space3) {
            Rectangle()
                .fill(theme.colors.semantic.stroke)
                .frame(width: 44, height: value)

            Text(name)
                .font(theme.typography.body.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textPrimary)

            Spacer()

            Text("\(Int(value))pt")
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textTertiary)
        }
    }

    // MARK: - ControlHeight

    private var controlHeightSection: some View {
        Section("Control Height") {
            controlRow("small", value: ControlHeightTokens.small)
            controlRow("medium", value: ControlHeightTokens.medium)
            controlRow("large", value: ControlHeightTokens.large)
        }
    }

    private func controlRow(_ name: String, value: CGFloat) -> some View {
        HStack(spacing: SpacingTokens.space3) {
            RoundedRectangle(cornerRadius: RadiusTokens.small)
                .fill(theme.colors.semantic.surfaceSecondary)
                .overlay(
                    RoundedRectangle(cornerRadius: RadiusTokens.small)
                        .stroke(theme.colors.semantic.stroke, lineWidth: StrokeTokens.hairline)
                )
                .frame(width: 80, height: value)

            Text(name)
                .font(theme.typography.body.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textPrimary)

            Spacer()

            Text("\(Int(value))pt")
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textTertiary)
        }
    }
}

// MARK: - Previews

#Preview("Layout — Default") {
    NavigationStack {
        LayoutGalleryScreen()
    }
    .dsTheme(.defaultTheme)
}

#Preview("Layout — Alternate") {
    NavigationStack {
        LayoutGalleryScreen()
    }
    .dsTheme(.alternate)
}
