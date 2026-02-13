import SwiftUI
import DaVinciTokens

// MARK: - DSPressableButtonStyle

/// A button style that applies `OpacityTokens.pressed` on press for consistent
/// interaction feedback across all DS buttons.
///
/// - Parameter duration: Animation duration in seconds. Pass `theme.motion.fast`
///   to keep the timing token-driven.
struct DSPressableButtonStyle: ButtonStyle {
    var duration: Double = 0.15

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? OpacityTokens.pressed : 1.0)
            .animation(.easeInOut(duration: duration), value: configuration.isPressed)
    }
}
