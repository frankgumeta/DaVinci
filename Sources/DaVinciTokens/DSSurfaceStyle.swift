import SwiftUI

// MARK: - DSSurfaceShape

/// The outline a surface is clipped and stroked with.
public enum DSSurfaceShape: Sendable, Equatable {
    /// A rounded rectangle with an explicit corner radius. Prefer a `RadiusTokens` value.
    case roundedRectangle(cornerRadius: CGFloat)
    /// A capsule — fully rounded on the leading and trailing ends.
    case capsule
    /// A circle, for square controls such as icon buttons and avatars.
    case circle
    /// A plain rectangle with square corners.
    case rectangle

    /// Rounded rectangle using the `small` radius token.
    public static let small = DSSurfaceShape.roundedRectangle(cornerRadius: RadiusTokens.small)
    /// Rounded rectangle using the `medium` radius token.
    public static let medium = DSSurfaceShape.roundedRectangle(cornerRadius: RadiusTokens.medium)
    /// Rounded rectangle using the `large` radius token.
    public static let large = DSSurfaceShape.roundedRectangle(cornerRadius: RadiusTokens.large)
}

// MARK: - DSSurfaceFill

/// What paints the body of a surface.
///
/// Semantic cases resolve against the theme, so a surface follows the active
/// colour scheme without the caller reaching for a literal.
public enum DSSurfaceFill: Sendable, Equatable {
    /// No fill. The surface contributes only its shape, stroke and elevation.
    case none
    /// `semantic.surfacePrimary` — cards and containers.
    case primary
    /// `semantic.surfaceSecondary` — secondary cards and wells.
    case secondary
    /// `semantic.surfaceElevated` — modals and popovers floating above content.
    case elevated
    /// An explicit colour, for cases the semantic roles do not cover.
    case color(Color)
}

// MARK: - DSSurfaceStroke

/// The border drawn around a surface.
public struct DSSurfaceStroke: Sendable, Equatable {

    /// What colours the border.
    public enum Fill: Sendable, Equatable {
        /// `semantic.stroke` — the default border colour.
        case semantic
        /// `semantic.divider` — a lighter separator-weight border.
        case divider
        /// `accent.strokeAccent` — selected or focused state.
        case accent
        /// An explicit colour.
        case color(Color)
    }

    public let fill: Fill
    public let width: CGFloat

    public init(fill: Fill = .semantic, width: CGFloat = StrokeTokens.hairline) {
        self.fill = fill
        self.width = width
    }

    /// Hairline border in the default semantic stroke colour.
    public static let hairline = DSSurfaceStroke()
    /// Hairline border in the accent colour, for selection and focus.
    public static let accent = DSSurfaceStroke(fill: .accent)
}

// MARK: - DSSurfaceStyle

/// The visual treatment of a surface: shape, fill, stroke and elevation.
///
/// A surface is deliberately *not* a layout primitive. It carries no padding and
/// imposes no internal arrangement, so it can dress anything from a full card to a
/// colour swatch, a selection ring or a floating control without the caller having to
/// fight built-in spacing. Compose padding around it:
///
/// ```swift
/// content
///     .padding(SpacingTokens.space4)
///     .dsSurface(.card)
/// ```
///
/// ## Presets
///
/// - ``card`` — opaque container with the large radius and a small shadow.
/// - ``overlay`` — elevated fill for modals and popovers.
/// - ``pill`` — capsule with a secondary fill, for chips and tags.
/// - ``floating`` — elevated capsule with a medium shadow, for floating controls.
/// - ``outline`` — no fill, hairline border. For rings, swatch outlines and wells.
/// - ``plain`` — shape only. A neutral starting point for customisation.
public struct DSSurfaceStyle: Sendable, Equatable {
    public var shape: DSSurfaceShape
    public var fill: DSSurfaceFill
    public var stroke: DSSurfaceStroke?
    public var elevation: DSElevation

    public init(
        shape: DSSurfaceShape = .medium,
        fill: DSSurfaceFill = .primary,
        stroke: DSSurfaceStroke? = nil,
        elevation: DSElevation = ElevationTokens.none
    ) {
        self.shape = shape
        self.fill = fill
        self.stroke = stroke
        self.elevation = elevation
    }

    // MARK: Presets

    /// Opaque container: large radius, primary fill, small shadow.
    public static let card = DSSurfaceStyle(
        shape: .large,
        fill: .primary,
        elevation: ElevationTokens.small
    )

    /// Modal and popover surface: large radius, elevated fill, medium shadow.
    public static let overlay = DSSurfaceStyle(
        shape: .large,
        fill: .elevated,
        elevation: ElevationTokens.medium
    )

    /// Chip and tag surface: capsule with a secondary fill.
    public static let pill = DSSurfaceStyle(
        shape: .capsule,
        fill: .secondary
    )

    /// Floating control surface: capsule, elevated fill, medium shadow.
    public static let floating = DSSurfaceStyle(
        shape: .capsule,
        fill: .elevated,
        elevation: ElevationTokens.medium
    )

    /// Border only — no fill, no shadow. For rings, wells and swatch outlines.
    public static let outline = DSSurfaceStyle(
        shape: .medium,
        fill: .none,
        stroke: .hairline
    )

    /// Shape only. Nothing painted; a neutral base to customise from.
    public static let plain = DSSurfaceStyle(
        shape: .medium,
        fill: .none
    )

    // MARK: Modifiers

    /// A copy of this style with a different shape.
    public func shape(_ shape: DSSurfaceShape) -> DSSurfaceStyle {
        var copy = self
        copy.shape = shape
        return copy
    }

    /// A copy of this style with a different fill.
    public func fill(_ fill: DSSurfaceFill) -> DSSurfaceStyle {
        var copy = self
        copy.fill = fill
        return copy
    }

    /// A copy of this style with a different stroke. Pass `nil` to remove the border.
    public func stroke(_ stroke: DSSurfaceStroke?) -> DSSurfaceStyle {
        var copy = self
        copy.stroke = stroke
        return copy
    }

    /// A copy of this style at a different elevation.
    public func elevation(_ elevation: DSElevation) -> DSSurfaceStyle {
        var copy = self
        copy.elevation = elevation
        return copy
    }
}

// MARK: - DSElevation Equatable

extension DSElevation: Equatable {
    public static func == (lhs: DSElevation, rhs: DSElevation) -> Bool {
        lhs.color == rhs.color
            && lhs.radius == rhs.radius
            && lhs.x == rhs.x
            && lhs.y == rhs.y
    }
}
