import SwiftUI

// MARK: - Remote Image Geometry

/// Geometry and clipping shape for a ``DSRemoteImage``.
public enum DSRemoteImageGeometry: Sendable, Equatable {
    /// A rectangular image with explicit dimensions.
    case rectangle(size: CGSize)
    /// A rounded rectangle with explicit dimensions and corner radius.
    case rounded(size: CGSize, cornerRadius: CGFloat)
    /// A circle whose width and height are both derived from one diameter.
    case circle(diameter: CGFloat)

    internal var normalized: DSRemoteImageGeometry {
        switch self {
        case .rectangle(let size):
            return .rectangle(size: Self.normalized(size))
        case .rounded(let size, let cornerRadius):
            let size = Self.normalized(size)
            let maximumRadius = min(size.width, size.height) / 2
            return .rounded(
                size: size,
                cornerRadius: min(Self.normalized(cornerRadius), maximumRadius)
            )
        case .circle(let diameter):
            return .circle(diameter: Self.normalized(diameter))
        }
    }

    internal var size: CGSize {
        switch normalized {
        case .rectangle(let size), .rounded(let size, _):
            return size
        case .circle(let diameter):
            return CGSize(width: diameter, height: diameter)
        }
    }

    internal var cornerRadius: CGFloat {
        switch normalized {
        case .rectangle:
            return 0
        case .rounded(_, let cornerRadius):
            return cornerRadius
        case .circle(let diameter):
            return diameter / 2
        }
    }

    internal var clipShape: AnyShape {
        switch normalized {
        case .rectangle:
            return AnyShape(Rectangle())
        case .rounded(_, let cornerRadius):
            return AnyShape(RoundedRectangle(cornerRadius: cornerRadius))
        case .circle:
            return AnyShape(Circle())
        }
    }

    private static func normalized(_ size: CGSize) -> CGSize {
        CGSize(width: normalized(size.width), height: normalized(size.height))
    }

    private static func normalized(_ value: CGFloat) -> CGFloat {
        value.isFinite ? max(0, value) : 0
    }
}

extension DSRemoteImage {
    /// Geometry and clipping shape used by the image and all of its states.
    public typealias Geometry = DSRemoteImageGeometry
}
