import SwiftUI
import DaVinciTokens

// MARK: - DSSegmentItem

/// A model representing a single segment in a `DSSegmentedControl`.
public struct DSSegmentItem: Sendable {
    /// The text label for the segment.
    public let title: String
    /// Optional SF Symbol name displayed alongside the title.
    public let iconSystemName: String?

    public init(title: String, iconSystemName: String? = nil) {
        self.title = title
        self.iconSystemName = iconSystemName
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
///     icons: ["list.bullet", "square.grid.2x2"]
/// )
/// ```
///
/// ## Accessibility
///
/// Each segment reports as a button with selected state. The container announces
/// itself as a segmented control.
public struct DSSegmentedControl: View, Sendable {
    @Environment(\.dsTheme) private var theme
    @Binding private var selectedIndex: Int
    @Namespace private var animation

    internal let segments: [DSSegmentItem]

    /// Creates a segmented control from an array of `DSSegmentItem` values.
    ///
    /// - Parameters:
    ///   - segments: The items to display as segments
    ///   - selectedIndex: Binding to the currently selected index
    public init(segments: [DSSegmentItem], selectedIndex: Binding<Int>) {
        self.segments = segments
        self._selectedIndex = selectedIndex
    }

    /// Convenience initializer using plain string arrays.
    ///
    /// - Parameters:
    ///   - options: Array of option labels
    ///   - selectedIndex: Binding to the currently selected index
    ///   - icons: Optional SF Symbol names; if provided, must align with `options` by index
    public init(options: [String], selectedIndex: Binding<Int>, icons: [String]? = nil) {
        self.segments = options.indices.map { i in
            let icon = icons.flatMap { arr in arr.indices.contains(i) ? arr[i] : nil }
            return DSSegmentItem(title: options[i], iconSystemName: icon)
        }
        self._selectedIndex = selectedIndex
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
                        if let icon = segment.iconSystemName {
                            Image(systemName: icon)
                                .font(
                                    theme.typography.callout.font(family: theme.typography.family)
                                )
                        }

                        Text(segment.title)
                            .font(
                                theme.typography.callout.font(family: theme.typography.family)
                            )
                    }
                    .foregroundStyle(
                        selectedIndex == index
                            ? theme.colors.semantic.textOnBrand
                            : theme.colors.semantic.textSecondary
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, SpacingTokens.space2)
                    .background {
                        if selectedIndex == index {
                            RoundedRectangle(cornerRadius: RadiusTokens.small)
                                .fill(theme.colors.brand.primary)
                                .matchedGeometryEffect(id: "selectedSegment", in: animation)
                        }
                    }
                }
                .accessibilityAddTraits(selectedIndex == index ? [.isButton, .isSelected] : .isButton)
                .accessibilityLabel(segment.title)
            }
        }
        .padding(SpacingTokens.space1)
        .background(theme.colors.semantic.bgSecondary)
        .clipShape(RoundedRectangle(cornerRadius: RadiusTokens.medium))
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Segmented control")
    }
}

// MARK: - Previews

#Preview("DSSegmentedControl - Light") {
    VStack(spacing: SpacingTokens.space5) {
        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            DSText("DSSegmentItem API", role: .headline)
            DSSegmentedControl(
                segments: [
                    DSSegmentItem(title: "Day"),
                    DSSegmentItem(title: "Week"),
                    DSSegmentItem(title: "Month")
                ],
                selectedIndex: .constant(1)
            )
        }

        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            DSText("With Icons", role: .headline)
            DSSegmentedControl(
                segments: [
                    DSSegmentItem(title: "List", iconSystemName: "list.bullet"),
                    DSSegmentItem(title: "Grid", iconSystemName: "square.grid.2x2"),
                    DSSegmentItem(title: "Calendar", iconSystemName: "calendar")
                ],
                selectedIndex: .constant(0)
            )
        }

        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            DSText("Convenience init (compat)", role: .headline)
            DSSegmentedControl(
                options: ["All", "Active", "Pending", "Closed"],
                selectedIndex: .constant(2)
            )
        }

        VStack(alignment: .leading, spacing: SpacingTokens.space3) {
            DSText("Two options", role: .headline)
            DSSegmentedControl(
                options: ["Map", "List"],
                selectedIndex: .constant(0),
                icons: ["map", "list.bullet"]
            )
        }
    }
    .padding()
    .dsTheme(.defaultTheme)
}

#Preview("DSSegmentedControl - Dark") {
    VStack(spacing: SpacingTokens.space5) {
        DSSegmentedControl(
            segments: [
                DSSegmentItem(title: "Day"),
                DSSegmentItem(title: "Week"),
                DSSegmentItem(title: "Month")
            ],
            selectedIndex: .constant(1)
        )

        DSSegmentedControl(
            options: ["List", "Grid", "Calendar"],
            selectedIndex: .constant(0),
            icons: ["list.bullet", "square.grid.2x2", "calendar"]
        )

        DSSegmentedControl(
            options: ["All", "Active", "Pending", "Closed"],
            selectedIndex: .constant(2)
        )
    }
    .padding()
    .dsTheme(.defaultTheme)
    .preferredColorScheme(.dark)
}
