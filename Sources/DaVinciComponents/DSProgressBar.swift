import SwiftUI
import DaVinciTokens

// MARK: - DSProgressBar

/// A themed linear progress bar component.
///
/// `DSProgressBar` displays progress as a horizontal bar that fills from left to right.
/// It supports both determinate (with a specific value) and indeterminate (loading) states,
/// and respects the system Reduce Motion accessibility setting.
///
/// ## Basic Usage
///
/// ```swift
/// DSProgressBar(value: 0.7) // 70% progress
/// ```
///
/// ## With Label
///
/// ```swift
/// DSProgressBar(value: 0.5, label: "Uploading...")
/// ```
///
/// ## Indeterminate Loading
///
/// ```swift
/// DSProgressBar(isIndeterminate: true, label: "Loading...")
/// ```
///
/// ## Sizes
///
/// ```swift
/// DSProgressBar(value: 0.5, size: .small)
/// DSProgressBar(value: 0.5, size: .medium)
/// DSProgressBar(value: 0.5, size: .large)
/// ```
///
/// ## Accessibility
///
/// The progress bar automatically provides:
/// - Progress indicator trait
/// - Current value announcement (e.g. "75%")
/// - Label if provided
/// - Static loading state when Reduce Motion is enabled
public struct DSProgressBar: View, Sendable {
    @Environment(\.dsTheme) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    internal let value: Double
    private let size: Size
    private let label: String?
    internal let isIndeterminate: Bool
    private let accessibilityLabel: String?

    /// Semantic height of the progress bar.
    public enum Size: Sendable {
        /// 4pt — subtle, inline usage.
        case small
        /// 6pt — standard for most contexts.
        case medium
        /// 8pt — prominent, hero usage.
        case large

        var height: CGFloat {
            switch self {
            case .small:  return SpacingTokens.space1
            case .medium: return 6
            case .large:  return SpacingTokens.space2
            }
        }
    }

    /// Creates a themed progress bar.
    ///
    /// - Parameters:
    ///   - value: Progress value from 0.0 to 1.0 (clamped; ignored when `isIndeterminate` is true)
    ///   - size: Semantic height of the bar (default: `.small`)
    ///   - label: Optional label text displayed above the bar
    ///   - isIndeterminate: If true, shows an animated loading state
    ///   - accessibilityLabel: Optional custom accessibility label
    public init(
        value: Double = 0.0,
        size: Size = .small,
        label: String? = nil,
        isIndeterminate: Bool = false,
        accessibilityLabel: String? = nil
    ) {
        self.value = min(max(value, 0.0), 1.0)
        self.size = size
        self.label = label
        self.isIndeterminate = isIndeterminate
        self.accessibilityLabel = accessibilityLabel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space2) {
            if let label {
                DSText(label, role: .caption)
                    .foregroundStyle(theme.colors.semantic.textSecondary)
            }

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: size.height / 2)
                        .fill(theme.colors.semantic.bgTertiary)
                        .frame(height: size.height)

                    if isIndeterminate {
                        IndeterminateBar(
                            theme: theme,
                            height: size.height,
                            width: geometry.size.width,
                            reduceMotion: reduceMotion
                        )
                    } else {
                        RoundedRectangle(cornerRadius: size.height / 2)
                            .fill(theme.colors.brand.primary)
                            .frame(width: geometry.size.width * value, height: size.height)
                            .animation(theme.motion.easeInOutNormal, value: value)
                    }
                }
            }
            .frame(height: size.height)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(resolvedAccessibilityLabel)
        .accessibilityValue(resolvedAccessibilityValue)
    }

    internal var resolvedAccessibilityLabel: String {
        if let accessibilityLabel { return accessibilityLabel }
        return label ?? "Progress"
    }

    internal var resolvedAccessibilityValue: String {
        isIndeterminate ? "Loading" : "\(Int(value * 100))%"
    }
}

// MARK: - IndeterminateBar

private struct IndeterminateBar: View {
    let theme: DSTheme
    let height: CGFloat
    let width: CGFloat
    let reduceMotion: Bool

    @State private var offset: CGFloat = -1

    var body: some View {
        if reduceMotion {
            // Reduce Motion: full-track fill at reduced opacity communicates
            // "loading in progress" intentionally without any animation.
            RoundedRectangle(cornerRadius: height / 2)
                .fill(theme.colors.brand.primary)
                .opacity(OpacityTokens.shimmerStatic)
                .frame(height: height)
        } else {
            RoundedRectangle(cornerRadius: height / 2)
                .fill(theme.colors.brand.primary)
                .frame(width: width * 0.3, height: height)
                .offset(x: offset * width)
                .onAppear {
                    withAnimation(
                        .linear(duration: theme.motion.shimmerDuration)
                        .repeatForever(autoreverses: false)
                    ) {
                        offset = 1.7
                    }
                }
        }
    }
}

// MARK: - Previews

#Preview("DSProgressBar - Light") {
    VStack(spacing: SpacingTokens.space5) {
        DSProgressBar(value: 0.0, label: "Not started")
        DSProgressBar(value: 0.25, label: "25% complete")
        DSProgressBar(value: 0.5, label: "Half way")
        DSProgressBar(value: 0.75, label: "Almost done")
        DSProgressBar(value: 1.0, label: "Complete")
        DSProgressBar(label: "Loading...", isIndeterminate: true)

        DSText("Sizes", role: .caption)
        DSProgressBar(value: 0.6, size: .small, label: "Small")
        DSProgressBar(value: 0.6, size: .medium, label: "Medium")
        DSProgressBar(value: 0.6, size: .large, label: "Large")
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSProgressBar - Dark") {
    VStack(spacing: SpacingTokens.space5) {
        DSProgressBar(value: 0.0, label: "Not started")
        DSProgressBar(value: 0.5, label: "Half way")
        DSProgressBar(value: 1.0, label: "Complete")
        DSProgressBar(label: "Loading...", isIndeterminate: true)
        DSProgressBar(value: 0.6, size: .large, label: "Large")
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
