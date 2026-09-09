import SwiftUI
import DaVinciTokens

// MARK: - DSActivityIndicator

/// A compact, themed indeterminate progress indicator.
///
/// Use it for work whose duration is unknown — loading a row, submitting a form,
/// refreshing a section. ``DSProgressBar`` is not a substitute: a bar communicates
/// *how far along* something is, and showing one for work with no measurable progress
/// misrepresents the state.
///
/// ```swift
/// DSActivityIndicator(size: .small)
/// DSActivityIndicator(size: .medium, tint: theme.colors.brand.primary)
/// ```
///
/// ## Accessibility
///
/// The indicator carries an `updatesFrequently` trait and a localized label, so
/// VoiceOver announces it as ongoing activity rather than reading it as static content.
/// Pass `label` to describe *what* is loading when the surrounding context does not.
public struct DSActivityIndicator: View {

    /// Diameter of the indicator.
    public enum Size: Sendable, CaseIterable {
        /// 16pt — inline with text and inside compact rows.
        case small
        /// 24pt — the default, for row accessories and buttons.
        case medium
        /// 36pt — section-level loading.
        case large

        /// The resolved diameter.
        public var dimension: CGFloat {
            switch self {
            case .small:  16
            case .medium: 24
            case .large:  36
            }
        }

        /// `ProgressView` renders at a fixed intrinsic size, so it is scaled to the token.
        internal var scale: CGFloat {
            dimension / 20
        }
    }

    @Environment(\.dsTheme) private var theme

    private let size: Size
    private let tint: Color?
    private let label: String?

    public init(
        size: Size = .medium,
        tint: Color? = nil,
        label: String? = nil
    ) {
        self.size = size
        self.tint = tint
        self.label = label
    }

    public var body: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(size.scale)
            .tint(tint ?? theme.colors.semantic.textSecondary)
            .frame(width: size.dimension, height: size.dimension)
            .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    internal var resolvedLabel: String {
        label ?? DSLocalizedStrings.value(.loading)
    }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: resolvedLabel,
            traits: .updatesFrequently,
            children: .ignore
        )
    }
}
