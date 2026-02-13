import SwiftUI

// MARK: - DSElevation

/// Shadow parameters for a single elevation level.
public struct DSElevation: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat

    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - ElevationTokens

/// Elevation (shadow) tokens: none, small, medium.
public enum ElevationTokens: Sendable {
    public static let none = DSElevation(color: .clear, radius: 0, x: 0, y: 0)
    public static let small = DSElevation(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
    public static let medium = DSElevation(color: Color.black.opacity(0.12), radius: 8, x: 0, y: 4)
}
