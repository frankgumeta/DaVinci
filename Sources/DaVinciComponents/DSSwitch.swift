import SwiftUI
import DaVinciTokens

// MARK: - DSSwitch

/// A themed toggle switch component.
///
/// `DSSwitch` provides a polished switch that adapts to your theme, supports a
/// disabled state, and respects DS motion tokens for its animation.
///
/// ## Basic Usage
///
/// ```swift
/// @State private var isEnabled = false
///
/// DSSwitch(isOn: $isEnabled, label: "Enable notifications")
/// ```
///
/// ## Without Label
///
/// ```swift
/// DSSwitch(isOn: $isEnabled)
/// ```
///
/// ## Disabled
///
/// ```swift
/// DSSwitch(isOn: .constant(false), isDisabled: true)
/// ```
///
/// ## Custom Accessibility Label
///
/// ```swift
/// DSSwitch(
///     isOn: $isEnabled,
///     label: "Notifications",
///     accessibilityLabel: "Enable push notifications"
/// )
/// ```
public struct DSSwitch: View, Sendable {
    @Environment(\.dsTheme) private var theme
    @Binding private var isOn: Bool

    private let label: String?
    private let isDisabled: Bool
    private let accessibilityLabel: String?

    /// Internal track/knob proportions. Not part of the public API.
    internal enum Metrics {
        static let trackWidth: CGFloat  = 44
        static let trackHeight: CGFloat = 24
        static let knobSize: CGFloat    = 20
        static let knobInset: CGFloat   = 2
        /// Pre-computed lateral knob travel from center.
        static let knobOffset: CGFloat  = (trackWidth - knobSize) / 2 - knobInset
    }

    /// Creates a themed switch.
    ///
    /// - Parameters:
    ///   - isOn: Binding to the switch state
    ///   - label: Optional label text displayed to the left of the switch
    ///   - isDisabled: When true, the switch is non-interactive and visually dimmed
    ///   - accessibilityLabel: Optional override for the accessibility label
    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        isDisabled: Bool = false,
        accessibilityLabel: String? = nil
    ) {
        self._isOn = isOn
        self.label = label
        self.isDisabled = isDisabled
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack(spacing: SpacingTokens.space3) {
                if let label {
                    DSText(label, role: .body)
                    Spacer()
                }
                trackView
            }
        }
        .buttonStyle(DSSwitchButtonStyle(pressAnimation: theme.motion.press))
        .disabled(isDisabled)
        .opacity(isDisabled ? OpacityTokens.disabled : 1)
        .accessibilityLabel(resolvedAccessibilityLabel)
        .accessibilityValue(isOn ? "On" : "Off")
        .accessibilityAddTraits(.isToggle)
    }

    private var trackView: some View {
        ZStack {
            Capsule()
                .fill(isOn ? theme.colors.brand.primary : theme.colors.semantic.bgTertiary)
                .overlay(
                    Capsule()
                        .stroke(theme.colors.semantic.stroke, lineWidth: 0.5)
                        .opacity(isOn ? 0 : 0.5)
                )
                .frame(width: Metrics.trackWidth, height: Metrics.trackHeight)

            Circle()
                .fill(theme.colors.semantic.bgPrimary)
                .frame(width: Metrics.knobSize, height: Metrics.knobSize)
                .shadow(color: .black.opacity(0.15), radius: 3, x: 0, y: 1)
                .offset(x: isOn ? Metrics.knobOffset : -Metrics.knobOffset)
        }
        .animation(theme.motion.snappy, value: isOn)
    }

    internal var resolvedAccessibilityLabel: String {
        accessibilityLabel ?? label ?? "Toggle"
    }
}

// MARK: - DSSwitchButtonStyle

private struct DSSwitchButtonStyle: ButtonStyle {
    let pressAnimation: Animation

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? OpacityTokens.pressed : 1.0)
            .animation(pressAnimation, value: configuration.isPressed)
    }
}

// MARK: - Previews

#Preview("DSSwitch - Light") {
    VStack(alignment: .leading, spacing: SpacingTokens.space4) {
        DSText("Labeled", role: .caption)
        DSSwitch(isOn: .constant(true), label: "On")
        DSSwitch(isOn: .constant(false), label: "Off")

        DSDivider()

        DSText("Unlabeled", role: .caption)
        HStack(spacing: SpacingTokens.space4) {
            DSSwitch(isOn: .constant(true))
            DSSwitch(isOn: .constant(false))
        }

        DSDivider()

        DSText("Disabled", role: .caption)
        DSSwitch(isOn: .constant(true), label: "On (disabled)", isDisabled: true)
        DSSwitch(isOn: .constant(false), label: "Off (disabled)", isDisabled: true)
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSSwitch - Dark") {
    VStack(alignment: .leading, spacing: SpacingTokens.space4) {
        DSSwitch(isOn: .constant(true), label: "On")
        DSSwitch(isOn: .constant(false), label: "Off")

        DSDivider()

        DSSwitch(isOn: .constant(true), label: "On (disabled)", isDisabled: true)
        DSSwitch(isOn: .constant(false), label: "Off (disabled)", isDisabled: true)

        DSDivider()

        HStack(spacing: SpacingTokens.space4) {
            DSSwitch(isOn: .constant(true))
            DSSwitch(isOn: .constant(false))
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
