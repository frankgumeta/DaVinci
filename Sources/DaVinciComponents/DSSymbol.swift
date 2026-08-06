import SwiftUI
import UIKit

// MARK: - DSSymbol

/// A validated, `Hashable` and `Sendable` SF Symbol reference.
///
/// `DSSymbol` prevents invalid SF Symbol names from reaching DaVinci components.
/// Its initializer validates the name against the operating system on which the
/// application is running:
///
/// ```swift
/// guard let profile = DSSymbol(systemName: "person") else {
///     return
/// }
///
/// // Pass `profile` to a DaVinci component API that accepts `DSSymbol`.
/// ```
///
/// Availability is intentionally evaluated at runtime. A symbol introduced by a
/// newer version of iOS produces `nil` when the same application runs on an older
/// supported version, allowing the caller to omit the icon or choose a fallback.
/// DaVinci does not maintain a public catalog because SF Symbols evolves with each
/// SDK and consumer applications need access to the complete installed set.
public struct DSSymbol: Hashable, Sendable {

    /// The validated SF Symbol name used by DaVinci's internal renderer.
    internal let systemName: String

    /// Creates a symbol when `systemName` exists on the current operating system.
    ///
    /// - Parameter systemName: A name accepted by `UIImage(systemName:)`.
    /// - Returns: `nil` when the name is empty, misspelled or unavailable on the
    ///   current operating system.
    public init?(systemName: String) {
        guard UIImage(systemName: systemName) != nil else { return nil }
        self.systemName = systemName
    }
}

// MARK: - DaVinci-owned symbols

extension DSSymbol {

    /// Symbol used by the built-in text-field clear action.
    internal static let clear = requiredSystemSymbol("xmark")

    /// Symbol used by the default remote-image placeholder.
    internal static let imagePlaceholder = requiredSystemSymbol("photo")

    /// Symbol used alongside field validation errors.
    internal static let errorIndicator = requiredSystemSymbol("exclamationmark.circle")

    /// DaVinci-owned symbols are framework invariants rather than consumer input.
    /// Failing loudly here prevents a future internal typo from producing an
    /// empty or inaccessible control in release builds.
    private static func requiredSystemSymbol(_ name: String) -> DSSymbol {
        guard let symbol = DSSymbol(systemName: name) else {
            preconditionFailure("DaVinci requires unavailable SF Symbol '\(name)'")
        }
        return symbol
    }
}

// MARK: - Rendering

extension DSSymbol {

    /// The single renderer used by DaVinci components after validation.
    @MainActor
    internal var image: Image { Image(systemName: systemName) }
}
