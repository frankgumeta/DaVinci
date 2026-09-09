import SwiftUI
import DaVinciTokens

// MARK: - DSSurfaceStyleResolver

/// Resolves the semantic cases of a `DSSurfaceStyle` against a theme.
///
/// Kept separate from the view so resolution can be unit tested without rendering.
public enum DSSurfaceStyleResolver {

    /// The colour that paints the surface body, or `nil` when the surface has no fill.
    public static func fillColor(for fill: DSSurfaceFill, theme: DSTheme) -> Color? {
        switch fill {
        case .none:            nil
        case .primary:         theme.colors.semantic.surfacePrimary
        case .secondary:       theme.colors.semantic.surfaceSecondary
        case .elevated:        theme.colors.semantic.surfaceElevated
        case .color(let color): color
        }
    }

    /// The colour of the surface border.
    public static func strokeColor(for fill: DSSurfaceStroke.Fill, theme: DSTheme) -> Color {
        switch fill {
        case .semantic:         theme.colors.semantic.stroke
        case .divider:          theme.colors.semantic.divider
        case .accent:           theme.colors.accent.strokeAccent
        case .color(let color): color
        }
    }
}

// MARK: - Shape Erasure

/// `DSSurfaceShape` rendered as a concrete SwiftUI shape.
///
/// `AnyShape` keeps the four cases interchangeable at a single call site, so the
/// modifier does not have to branch its whole view body per shape.
internal extension DSSurfaceShape {
    var resolved: AnyShape {
        switch self {
        case .roundedRectangle(let cornerRadius):
            AnyShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        case .capsule:
            AnyShape(Capsule())
        case .circle:
            AnyShape(Circle())
        case .rectangle:
            AnyShape(Rectangle())
        }
    }
}

// MARK: - dsSurface

public extension View {
    /// Applies a themed surface treatment — shape, fill, stroke and elevation.
    ///
    /// The surface adds no padding. Compose spacing around it so the same primitive
    /// serves both a padded card and a bare ring or swatch:
    ///
    /// ```swift
    /// VStack { … }
    ///     .padding(SpacingTokens.space4)
    ///     .dsSurface(.card)
    /// ```
    func dsSurface(_ style: DSSurfaceStyle) -> some View {
        modifier(DSSurfaceModifier(style: style))
    }
}

private struct DSSurfaceModifier: ViewModifier {
    @Environment(\.dsTheme) private var theme
    let style: DSSurfaceStyle

    func body(content: Content) -> some View {
        let shape = style.shape.resolved
        let fillColor = DSSurfaceStyleResolver.fillColor(for: style.fill, theme: theme)
        let elevation = style.elevation

        content
            .background {
                if let fillColor {
                    shape.fill(fillColor)
                }
            }
            .clipShape(shape)
            .overlay {
                if let stroke = style.stroke, stroke.width > 0 {
                    strokeOverlay(
                        stroke,
                        color: DSSurfaceStyleResolver.strokeColor(for: stroke.fill, theme: theme)
                    )
                }
            }
            .shadow(
                color: elevation.color,
                radius: elevation.radius,
                x: elevation.x,
                y: elevation.y
            )
    }

    /// Draws the border inset within the shape's bounds.
    ///
    /// This branches on the concrete shape rather than reusing the erased `AnyShape`,
    /// because `strokeBorder` requires `InsettableShape` and `AnyShape` does not conform.
    /// Stroking inset matters here: `stroke` would centre the line on the edge and let
    /// half its width fall outside the clip, thinning the border unevenly.
    @ViewBuilder
    private func strokeOverlay(_ stroke: DSSurfaceStroke, color: Color) -> some View {
        switch style.shape {
        case .roundedRectangle(let cornerRadius):
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(color, lineWidth: stroke.width)
        case .capsule:
            Capsule()
                .strokeBorder(color, lineWidth: stroke.width)
        case .circle:
            Circle()
                .strokeBorder(color, lineWidth: stroke.width)
        case .rectangle:
            Rectangle()
                .strokeBorder(color, lineWidth: stroke.width)
        }
    }
}
