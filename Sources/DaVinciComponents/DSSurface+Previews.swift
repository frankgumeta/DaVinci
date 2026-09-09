import SwiftUI
import DaVinciTokens

// MARK: - Previews

private struct DSSurfaceShowcase: View {

    private func sample(_ title: String, style: DSSurfaceStyle) -> some View {
        DSText(title, role: .labelMedium)
            .padding(SpacingTokens.space4)
            .frame(maxWidth: .infinity)
            .dsSurface(style)
    }

    var body: some View {
        VStack(spacing: SpacingTokens.space4) {
            DSText("Presets", role: .headline)

            sample("card", style: .card)
            sample("overlay", style: .overlay)
            sample("outline", style: .outline)
            sample("plain", style: .plain)

            HStack(spacing: SpacingTokens.space3) {
                DSText("pill", role: .labelSmall)
                    .padding(.horizontal, SpacingTokens.space3)
                    .padding(.vertical, SpacingTokens.space2)
                    .dsSurface(.pill)

                DSText("floating", role: .labelSmall)
                    .padding(.horizontal, SpacingTokens.space3)
                    .padding(.vertical, SpacingTokens.space2)
                    .dsSurface(.floating)
            }

            DSText("Composed", role: .headline)

            // A surface carries no padding of its own, so the caller composes it.
            DSText("Accent selection ring", role: .labelMedium)
                .padding(SpacingTokens.space4)
                .frame(maxWidth: .infinity)
                .dsSurface(
                    DSSurfaceStyle(
                        shape: .large,
                        fill: .secondary,
                        stroke: .accent
                    )
                )

            HStack(spacing: SpacingTokens.space3) {
                Color.purple
                    .frame(width: 44, height: 44)
                    .dsSurface(DSSurfaceStyle(shape: .circle, fill: .none))

                Color.teal
                    .frame(width: 44, height: 44)
                    .dsSurface(DSSurfaceStyle(shape: .small, fill: .none))
            }
        }
        .padding()
    }
}

#Preview("DSSurface - Light") {
    DSSurfaceShowcase()
        .dsTheme(.defaultTheme)
}

#Preview("DSSurface - Dark") {
    DSSurfaceShowcase()
        .dsTheme(.defaultTheme)
        .preferredColorScheme(.dark)
}
