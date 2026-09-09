import SwiftUI
import DaVinciTokens

// MARK: - DSPressableButtonStyle

/// A button style that applies `OpacityTokens.pressed` on press for consistent
/// interaction feedback across all DS buttons.
///
/// Public so that controls which do not fit ``DSButton`` — a custom card that acts as a
/// button, a tappable row, a bespoke transport control — still press like everything
/// else in the system instead of reinventing the feedback:
///
/// ```swift
/// Button(action: play) { artwork }
///     .buttonStyle(DSPressableButtonStyle(duration: theme.motion.fast))
/// ```
///
/// - Parameter duration: Animation duration in seconds. Pass `theme.motion.fast`
///   to keep the timing token-driven.
public struct DSPressableButtonStyle: ButtonStyle {
    public var duration: Double

    /// - Parameter duration: Animation duration in seconds; defaults to 0.15.
    public init(duration: Double = 0.15) {
        self.duration = duration
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? OpacityTokens.pressed : 1.0)
            .animation(.easeInOut(duration: duration), value: configuration.isPressed)
    }
}
