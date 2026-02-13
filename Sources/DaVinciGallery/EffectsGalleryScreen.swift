import SwiftUI
import DaVinciTokens

// MARK: - EffectsGalleryScreen

struct EffectsGalleryScreen: View {
    @Environment(\.dsTheme) private var theme

    @State private var motionToggle = false

    var body: some View {
        List {
            elevationSection
            motionSection
        }
        .navigationTitle("Effects")
    }

    // MARK: - Elevation

    private var elevationSection: some View {
        Section("Elevation") {
            elevationRow("none", elevation: ElevationTokens.none)
            elevationRow("small", elevation: ElevationTokens.small)
            elevationRow("medium", elevation: ElevationTokens.medium)
        }
    }

    private func elevationRow(_ name: String, elevation: DSElevation) -> some View {
        HStack(spacing: SpacingTokens.space3) {
            RoundedRectangle(cornerRadius: RadiusTokens.medium)
                .fill(theme.colors.semantic.surfacePrimary)
                .frame(width: 64, height: 44)
                .shadow(
                    color: elevation.color,
                    radius: elevation.radius,
                    x: elevation.x,
                    y: elevation.y
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(theme.typography.body.font(family: theme.typography.family))
                    .foregroundStyle(theme.colors.semantic.textPrimary)

                Text("radius \(Int(elevation.radius))  ·  y \(Int(elevation.y))")
                    .font(theme.typography.caption.font(family: theme.typography.family))
                    .foregroundStyle(theme.colors.semantic.textTertiary)
            }

            Spacer()
        }
        .padding(.vertical, SpacingTokens.space2)
    }

    // MARK: - Motion

    private var motionSection: some View {
        Section("Motion") {
            motionRow("fast", duration: theme.motion.fast)
            motionRow("normal", duration: theme.motion.normal)
            motionRow("slow", duration: theme.motion.slow)

            VStack(alignment: .leading, spacing: SpacingTokens.space3) {
                Text("Tap to animate")
                    .font(theme.typography.caption.font(family: theme.typography.family))
                    .foregroundStyle(theme.colors.semantic.textSecondary)

                HStack(spacing: SpacingTokens.space4) {
                    curveDemo("easeInOut", animation: theme.motion.easeInOut)
                    curveDemo("snappy", animation: theme.motion.snappy)
                }
            }
            .padding(.vertical, SpacingTokens.space2)
            .onTapGesture {
                motionToggle.toggle()
            }
        }
    }

    private func motionRow(_ name: String, duration: Double) -> some View {
        HStack {
            Text(name)
                .font(theme.typography.body.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textPrimary)

            Spacer()

            Text("\(duration, specifier: "%.2f")s")
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textTertiary)
        }
    }

    private func curveDemo(_ name: String, animation: Animation) -> some View {
        VStack(spacing: SpacingTokens.space1) {
            Circle()
                .fill(theme.colors.brand.primary)
                .frame(width: 24, height: 24)
                .offset(y: motionToggle ? -20 : 20)
                .animation(animation.speed(1.0 / theme.motion.normal), value: motionToggle)

            Text(name)
                .font(theme.typography.caption.font(family: theme.typography.family))
                .foregroundStyle(theme.colors.semantic.textSecondary)
        }
        .frame(height: 80)
    }
}

// MARK: - Previews

#Preview("Effects — Default") {
    NavigationStack {
        EffectsGalleryScreen()
    }
    .dsTheme(.defaultTheme)
}

#Preview("Effects — Alternate") {
    NavigationStack {
        EffectsGalleryScreen()
    }
    .dsTheme(.alternate)
}
