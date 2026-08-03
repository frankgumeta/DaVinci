import SwiftUI

/// The semantic accessibility contract applied by DaVinci components.
///
/// Components expose this internally so tests verify the same values consumed
/// by the production modifier instead of duplicating accessibility logic.
internal struct DSAccessibilityDescriptor {
    let label: String?
    let value: String?
    let hint: String?
    let traits: AccessibilityTraits
    let isEnabled: Bool
    let isHidden: Bool
    let children: DSAccessibilityChildBehavior

    init(
        label: String? = nil,
        value: String? = nil,
        hint: String? = nil,
        traits: AccessibilityTraits = [],
        isEnabled: Bool = true,
        isHidden: Bool = false,
        children: DSAccessibilityChildBehavior = .preserve
    ) {
        self.label = label
        self.value = value
        self.hint = hint
        self.traits = traits
        self.isEnabled = isEnabled
        self.isHidden = isHidden
        self.children = children
    }
}

internal enum DSAccessibilityChildBehavior: Equatable {
    case preserve
    case combine
    case contain
    case ignore
}

internal struct DSAccessibilityModifier: ViewModifier {
    let descriptor: DSAccessibilityDescriptor

    func body(content: Content) -> some View {
        content
            .modifier(DSAccessibilityChildrenModifier(behavior: descriptor.children))
            .modifier(OptionalAccessibilityLabel(label: descriptor.label))
            .modifier(OptionalAccessibilityValue(value: descriptor.value))
            .modifier(OptionalAccessibilityHint(hint: descriptor.hint))
            .accessibilityAddTraits(descriptor.traits)
            .accessibilityHidden(descriptor.isHidden)
    }
}

private struct DSAccessibilityChildrenModifier: ViewModifier {
    let behavior: DSAccessibilityChildBehavior

    @ViewBuilder
    func body(content: Content) -> some View {
        switch behavior {
        case .preserve:
            content
        case .combine:
            content.accessibilityElement(children: .combine)
        case .contain:
            content.accessibilityElement(children: .contain)
        case .ignore:
            content.accessibilityElement(children: .ignore)
        }
    }
}

private struct OptionalAccessibilityLabel: ViewModifier {
    let label: String?

    func body(content: Content) -> some View {
        if let label {
            content.accessibilityLabel(label)
        } else {
            content
        }
    }
}

private struct OptionalAccessibilityValue: ViewModifier {
    let value: String?

    func body(content: Content) -> some View {
        if let value {
            content.accessibilityValue(value)
        } else {
            content
        }
    }
}

private struct OptionalAccessibilityHint: ViewModifier {
    let hint: String?

    func body(content: Content) -> some View {
        if let hint {
            content.accessibilityHint(hint)
        } else {
            content
        }
    }
}
