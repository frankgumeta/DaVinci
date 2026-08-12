import SwiftUI
import DaVinciTokens

// MARK: - DSSegmentItem

/// A model representing a single segment in a `DSSegmentedControl`.
public struct DSSegmentItem: Sendable {
    /// The text label for the segment.
    public let title: String
    /// Optional validated SF Symbol displayed alongside the title.
    public let icon: DSSymbol?

    /// Creates a segment with an optional validated `DSSymbol` icon.
    public init(title: String, icon: DSSymbol? = nil) {
        self.title = title
        self.icon = icon
    }

    internal func accessibilityDescriptor(isSelected: Bool) -> DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(
            label: title,
            traits: isSelected ? [.isButton, .isSelected] : .isButton
        )
    }
}

// MARK: - DSSegmentedControl

/// A themed segmented control component for selecting between mutually exclusive options.
///
/// `DSSegmentedControl` provides a consistent segmented picker interface that
/// automatically adapts to your theme. Segments are modelled as `DSSegmentItem` values,
/// or you can use the convenience init with plain string arrays.
///
/// ## Basic Usage
///
/// ```swift
/// @State private var selectedIndex = 0
///
/// DSSegmentedControl(
///     segments: [
///         DSSegmentItem(title: "Day"),
///         DSSegmentItem(title: "Week"),
///         DSSegmentItem(title: "Month")
///     ],
///     selectedIndex: $selectedIndex
/// )
/// ```
///
/// ## Convenience Init (string arrays)
///
/// ```swift
/// DSSegmentedControl(
///     options: ["List", "Grid"],
///     selectedIndex: $selectedIndex,
///     symbols: [DSSymbol(systemName: "list.bullet")!, DSSymbol(systemName: "square.grid.2x2")!]
/// )
/// ```
///
/// ## Accessibility
///
/// Each segment reports as a button with selected state. The container announces
/// itself as a segmented control.
public struct DSSegmentedControl: View, Sendable {
    @Environment(\.dsTheme) private var theme
    @Environment(\.colorScheme) private var colorScheme
    @Binding private var selectedIndex: Int
    @Namespace private var animation

    internal let segments: [DSSegmentItem]
    internal let appearance: Appearance

    /// Visual emphasis of the segmented control.
    public enum Appearance: CaseIterable, Hashable, Sendable {
        /// Filled container with a high-emphasis brand selection (default).
        case filled
        /// Transparent container with a low-emphasis tinted selection.
        case subtle
    }

    /// Creates a segmented control from an array of `DSSegmentItem` values.
    ///
    /// - Parameters:
    ///   - segments: The items to display as segments
    ///   - selectedIndex: Binding to the currently selected index
    ///   - appearance: Visual emphasis of the container and selected segment
    public init(
        segments: [DSSegmentItem],
        selectedIndex: Binding<Int>,
        appearance: Appearance = .filled
    ) {
        self.segments = segments
        self._selectedIndex = selectedIndex
        self.appearance = appearance
    }

    /// Convenience initializer using plain string arrays.
    ///
    /// - Parameters:
    ///   - options: Array of option labels
    ///   - selectedIndex: Binding to the currently selected index
    ///   - symbols: Optional validated `DSSymbol` icons; if provided, must align with `options` by index
    ///   - appearance: Visual emphasis of the container and selected segment
    public init(
        options: [String],
        selectedIndex: Binding<Int>,
        symbols: [DSSymbol]? = nil,
        appearance: Appearance = .filled
    ) {
        self.segments = options.indices.map { i in
            let icon = symbols.flatMap { arr in arr.indices.contains(i) ? arr[i] : nil }
            if let icon {
                return DSSegmentItem(title: options[i], icon: icon)
            }
            return DSSegmentItem(title: options[i])
        }
        self._selectedIndex = selectedIndex
        self.appearance = appearance
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(segments.enumerated()), id: \.offset) { index, segment in
                Button {
                    withAnimation(theme.motion.snappy) {
                        selectedIndex = index
                    }
                } label: {
                    HStack(spacing: SpacingTokens.space2) {
                        if let icon = segment.icon {
                            icon.image
                        }

                        Text(segment.title)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .dsTextStyle(theme.typography.callout, family: theme.typography.family)
                    .foregroundStyle(
                        selectedIndex == index
                            ? resolvedStyle.selectedForeground
                            : theme.colors.semantic.textSecondary
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, SpacingTokens.space2)
                    .frame(minHeight: minimumSegmentHitHeight)
                    .background {
                        if selectedIndex == index {
                            RoundedRectangle(cornerRadius: RadiusTokens.small)
                                .fill(resolvedStyle.selectedBackground)
                                .overlay {
                                    RoundedRectangle(cornerRadius: RadiusTokens.small)
                                        .strokeBorder(
                                            resolvedStyle.selectedBorder,
                                            lineWidth: resolvedStyle.selectedBorderWidth
                                        )
                                }
                                .matchedGeometryEffect(id: "selectedSegment", in: animation)
                        }
                    }
                }
                .modifier(
                    DSAccessibilityModifier(
                        descriptor: segment.accessibilityDescriptor(isSelected: selectedIndex == index)
                    )
                )
            }
        }
        .padding(SpacingTokens.space1)
        .background(resolvedStyle.containerBackground)
        .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.medium))
        .modifier(DSAccessibilityModifier(descriptor: accessibilityDescriptor))
    }

    internal var minimumSegmentHitHeight: CGFloat { 44 }

    internal var accessibilityDescriptor: DSAccessibilityDescriptor {
        DSAccessibilityDescriptor(label: "Segmented control", children: .contain)
    }

    private var resolvedStyle: DSSegmentedControlStyleResolver.ResolvedStyle {
        DSSegmentedControlStyleResolver.resolve(
            appearance: appearance,
            theme: theme,
            colorScheme: colorScheme
        )
    }
}
