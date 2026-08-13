import SwiftUI
import DaVinciTokens

// MARK: - Stepped Progress

internal struct SteppedProgressBar: View {
    let value: Double
    let count: Int
    let height: CGFloat
    let theme: DSTheme

    internal var body: some View {
        HStack(spacing: StrokeTokens.default) {
            ForEach(0..<count, id: \.self) { index in
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: height / 2)
                            .fill(theme.colors.semantic.bgTertiary)
                        RoundedRectangle(cornerRadius: height / 2)
                            .fill(theme.colors.brand.primary)
                            .frame(
                                width: geometry.size.width * Self.segmentProgress(
                                    value: value,
                                    count: count,
                                    index: index
                                )
                            )
                    }
                    .clipShape(RoundedRectangle(cornerRadius: height / 2))
                }
            }
        }
        .frame(height: height)
        .animation(theme.motion.easeInOutNormal, value: value)
    }

    nonisolated internal static func segmentProgress(value: Double, count: Int, index: Int) -> Double {
        let normalizedCount = max(1, count)
        let progress = min(max(value, 0), 1) * Double(normalizedCount) - Double(index)
        return min(max(progress, 0), 1)
    }
}

// MARK: - Striped Progress

internal struct StripedProgressBar: View {
    let value: Double
    let height: CGFloat
    let width: CGFloat
    let theme: DSTheme
    let reduceMotion: Bool

    @State private var phase: CGFloat = 0

    private var patternPeriod: CGFloat { max(height * 2, SpacingTokens.space2) }

    internal var body: some View {
        ZStack {
            theme.colors.brand.primary
            DiagonalStripePattern(phase: phase, period: patternPeriod)
                .fill(theme.colors.semantic.textOnBrand.opacity(OpacityTokens.shimmerStatic))
        }
        .frame(width: width * value, height: height)
        .clipShape(RoundedRectangle(cornerRadius: height / 2))
        .animation(theme.motion.easeInOutNormal, value: value)
        .onAppear {
            guard Self.shouldAnimate(reduceMotion: reduceMotion) else { return }
            withAnimation(
                .linear(duration: theme.motion.shimmerDuration)
                    .repeatForever(autoreverses: false)
            ) {
                phase = patternPeriod
            }
        }
    }

    nonisolated internal static func shouldAnimate(reduceMotion: Bool) -> Bool {
        !reduceMotion
    }
}

internal struct DiagonalStripePattern: Shape {
    var phase: CGFloat
    let period: CGFloat

    internal var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        let bandWidth = period / 2
        let start = -period * 2 + phase

        for position in stride(from: start, through: rect.width + period * 2, by: period) {
            path.move(to: CGPoint(x: position, y: 0))
            path.addLine(to: CGPoint(x: position + bandWidth, y: 0))
            path.addLine(to: CGPoint(x: position + bandWidth - rect.height, y: rect.height))
            path.addLine(to: CGPoint(x: position - rect.height, y: rect.height))
            path.closeSubpath()
        }

        return path
    }
}
