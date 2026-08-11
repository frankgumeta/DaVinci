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
/// ## Styles
///
/// ```swift
/// DSProgressBar(value: 0.5, style: .continuous)
/// DSProgressBar(value: 0.5, style: .stepped(count: 5))
/// DSProgressBar(value: 0.5, style: .striped)
/// DSProgressBar(value: 0.5, style: .shimmer)
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
    internal let style: Style
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

    /// Visual presentation of the progress track.
    public enum Style: Sendable, Equatable {
        /// A single uninterrupted fill (default, preserves the original API).
        case continuous
        /// Discrete segments with partial fill in the active segment.
        case stepped(count: Int)
        /// Animated diagonal bands clipped to the current progress.
        case striped
        /// A sweeping reflective highlight clipped to the current progress.
        case shimmer

        internal var normalized: Style {
            guard case .stepped(let count) = self else { return self }
            return .stepped(count: max(1, count))
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
    ///   - style: Track presentation (default: `.continuous`)
    public init(
        value: Double = 0.0,
        size: Size = .small,
        label: String? = nil,
        isIndeterminate: Bool = false,
        accessibilityLabel: String? = nil,
        style: Style = .continuous
    ) {
        self.value = min(max(value, 0.0), 1.0)
        self.size = size
        self.label = label
        self.isIndeterminate = isIndeterminate
        self.accessibilityLabel = accessibilityLabel
        self.style = style.normalized
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: SpacingTokens.space2) {
            if let label {
                DSText(label, role: .caption)
                    .foregroundStyle(theme.colors.semantic.textSecondary)
            }

            GeometryReader { geometry in
                progressTrack(width: geometry.size.width)
            }
            .frame(height: size.height)
        }
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    @ViewBuilder
    private func progressTrack(width: CGFloat) -> some View {
        if case .stepped(let count) = style, !isIndeterminate {
            SteppedProgressBar(
                value: value,
                count: count,
                height: size.height,
                theme: theme
            )
        } else {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: size.height / 2)
                    .fill(theme.colors.semantic.bgTertiary)
                    .frame(height: size.height)

                progressFill(width: width)
            }
        }
    }

    @ViewBuilder
    private func progressFill(width: CGFloat) -> some View {
        if style == .striped {
            StripedProgressBar(
                value: isIndeterminate ? 1 : value,
                height: size.height,
                width: width,
                theme: theme,
                reduceMotion: reduceMotion
            )
        } else if style == .shimmer {
            RoundedRectangle(cornerRadius: size.height / 2)
                .fill(theme.colors.brand.primary)
                .frame(width: width * (isIndeterminate ? 1 : value), height: size.height)
                .dsShimmering()
                .animation(theme.motion.easeInOutNormal, value: value)
        } else if isIndeterminate {
            IndeterminateBar(
                theme: theme,
                height: size.height,
                width: width,
                reduceMotion: reduceMotion
            )
        } else {
            RoundedRectangle(cornerRadius: size.height / 2)
                .fill(theme.colors.brand.primary)
                .frame(width: width * value, height: size.height)
                .animation(theme.motion.easeInOutNormal, value: value)
        }
    }

    internal var resolvedAccessibilityLabel: String {
        if let accessibilityLabel { return accessibilityLabel }
        return label ?? "Progress"
    }

    internal var resolvedAccessibilityValue: String {
        isIndeterminate ? "Loading" : "\(Int(value * 100))%"
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: resolvedAccessibilityLabel,
            value: resolvedAccessibilityValue,
            traits: isIndeterminate ? .updatesFrequently : [],
            children: .combine
        )
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

        DSText("Styles", role: .caption)
        DSProgressBar(value: 0.625, size: .large, label: "Stepped", style: .stepped(count: 4))
        DSProgressBar(value: 0.65, size: .large, label: "Striped", style: .striped)
        DSProgressBar(size: .large, label: "Striped loading", isIndeterminate: true, style: .striped)
        DSProgressBar(value: 0.65, size: .large, label: "Shimmer", style: .shimmer)
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
        DSProgressBar(value: 0.625, size: .large, label: "Stepped", style: .stepped(count: 4))
        DSProgressBar(value: 0.65, size: .large, label: "Striped", style: .striped)
        DSProgressBar(value: 0.65, size: .large, label: "Shimmer", style: .shimmer)
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
