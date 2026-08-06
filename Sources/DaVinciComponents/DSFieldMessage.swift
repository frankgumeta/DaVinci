import SwiftUI

// MARK: - DSFieldMessage

/// A mutually exclusive auxiliary message displayed by a field control.
///
/// `DSFieldMessage` guarantees that supporting and error text are never
/// shown at the same time: the type itself makes the combination
/// impossible. When a field needs to show an error, the supporting text
/// is simply not provided.
///
/// Use ``supporting(_:)`` for helper text that is always visible, and
/// ``error(_:)`` for validation feedback that takes precedence when
/// present.
///
/// ```swift
/// let message: DSFieldMessage = .supporting("Enter your account email")
/// let error: DSFieldMessage = .error("Invalid email format")
/// ```
///
/// ## Topics
///
/// ### Creating a message
/// - ``supporting(_:)``
/// - ``error(_:)``
///
/// ### Inspecting a message
/// - ``isError``
/// - ``text``
public enum DSFieldMessage: Sendable {
    /// Helper text shown below the field in all states except disabled
    /// (where it is attenuated).
    case supporting(String)
    /// Validation feedback that takes visual precedence over supporting
    /// text and changes the field border to the error color.
    case error(String)

    /// `true` when this message represents an error.
    public var isError: Bool {
        switch self {
        case .supporting: return false
        case .error: return true
        }
    }

    /// The textual content of the message, regardless of kind.
    public var text: String {
        switch self {
        case .supporting(let text): return text
        case .error(let text): return text
        }
    }
}
