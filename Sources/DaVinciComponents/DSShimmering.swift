import SwiftUI
import DaVinciTokens

// MARK: - DSShimmering

/// A view modifier that applies a sweeping shimmer highlight over its content.
///
/// The shimmer overlay is **masked** to the content's shape, so it naturally
/// respects rounded corners without requiring an extra `clipShape`.
///
/// Theme-aware: uses `surfaceElevated` as the highlight color.
/// Respects `accessibilityReduceMotion` — falls back to a static highlight.
private struct DSShimmeringModifier: ViewModifier {
    let isActive: Bool

    @Environment(\.dsTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay { shimmerOverlay.mask(content) }
        } else {
            content
        }
    }

    @ViewBuilder
    private var shimmerOverlay: some View {
        let highlight = theme.colors.semantic.surfaceElevated
            .opacity(OpacityTokens.shimmerHighlight)

        if reduceMotion {
            Rectangle()
                .fill(
                    theme.colors.semantic.surfaceElevated
                        .opacity(OpacityTokens.shimmerStatic)
                )
        } else {
            GeometryReader { geo in
                let width = geo.size.width
                Rectangle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: .clear, location: 0),
                                .init(color: highlight, location: 0.4),
                                .init(color: highlight, location: 0.6),
                                .init(color: .clear, location: 1)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: width * 0.6)
                    .offset(x: phase * (width * 1.6) - width * 0.3)
                    .onAppear {
                        withAnimation(
                            .linear(duration: theme.motion.shimmerDuration)
                            .repeatForever(autoreverses: false)
                        ) {
                            phase = 1
                        }
                    }
            }
        }
    }
}

// MARK: - View Extension

extension View {
    /// Apply a shimmer loading effect to this view.
    ///
    /// - Parameter isActive: Whether the shimmer animation is running.
    ///   When `false`, the view renders normally with no overlay.
    public func dsShimmering(_ isActive: Bool = true) -> some View {
        modifier(DSShimmeringModifier(isActive: isActive))
    }
}
