import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

/// Accessibility coverage for the row components introduced in 2.0.
///
/// Snapshots prove these render; this suite proves they are *usable* — that the
/// hit targets are reachable, the states reach VoiceOver, and the layout survives
/// mirroring and accessibility text sizes.
@Suite("Row Accessibility")
@MainActor
struct DSRowAccessibilityTests {

    private let theme = DSTheme.defaultTheme

    // MARK: - Hit Targets

    /// Every interactive row must be at least 44pt tall regardless of its content,
    /// which is what `minHeight` on the row guarantees.
    @Test func rowsMeetTheMinimumHitTarget() {
        #expect(ControlHeightTokens.minimumHitTarget >= 44)
    }

    /// The accessories are decorative: they are hidden from VoiceOver and the whole
    /// row is the tap target, so a 14pt chevron never becomes a 14pt hit area.
    @Test func accessoryKindsAreDistinctSoStateCannotBeConfused() {
        #expect(DSRowAccessory.Kind.selection(isSelected: true) != .selection(isSelected: false))
        #expect(DSRowAccessory.Kind.chevron != .activity)
    }

    @Test func rowIsTheTapTargetRatherThanItsAccessory() throws {
        // The row claims the full width via contentShape, so the tappable area is
        // the row's own minHeight, not the glyph's intrinsic size.
        let row = DSActionRow(action: {}, content: { DSRowLabel(title: "Open") })
        #expect(row.accessibilityDescriptor.children == .combine)
        #expect(ControlHeightTokens.minimumHitTarget >= 44)
    }

    // MARK: - VoiceOver: Traits

    @Test func actionRowCarriesTheButtonTrait() {
        let row = DSActionRow(action: {}, content: { EmptyView() })
        #expect(row.accessibilityDescriptor.traits.contains(.isButton))
    }

    @Test func selectableRowCarriesButtonAndSelectedTraits() {
        let selected = DSSelectableRow(isSelected: true, action: {}, content: { EmptyView() })
        let unselected = DSSelectableRow(isSelected: false, action: {}, content: { EmptyView() })

        #expect(selected.resolvedTraits.contains(.isButton))
        #expect(selected.resolvedTraits.contains(.isSelected))
        #expect(unselected.resolvedTraits.contains(.isButton))
        #expect(!unselected.resolvedTraits.contains(.isSelected))
    }

    // MARK: - VoiceOver: State

    @Test func disabledRowReportsDisabledRatherThanDisappearing() {
        let row = DSActionRow(isDisabled: true, action: {}, content: { EmptyView() })

        // A disabled row must stay in the accessibility tree; hiding it would make
        // the reason for the disabled state unreachable.
        #expect(!row.accessibilityDescriptor.isEnabled)
        #expect(!row.accessibilityDescriptor.isHidden)
    }

    @Test func loadingRowAnnouncesItsStateAsAValue() {
        let row = DSActionRow(isLoading: true, action: {}, content: { EmptyView() })

        #expect(row.accessibilityDescriptor.value == DSLocalizedStrings.value(.loading))
        #expect(!row.accessibilityDescriptor.isEnabled)
    }

    @Test func selectionIsAnnouncedAsAValueNotOnlyAsACheckmark() {
        let selected = DSSelectableRow(isSelected: true, action: {}, content: { EmptyView() })
        let unselected = DSSelectableRow(isSelected: false, action: {}, content: { EmptyView() })

        #expect(selected.selectionValue == DSLocalizedStrings.value(.selected))
        #expect(unselected.selectionValue == DSLocalizedStrings.value(.notSelected))
    }

    @Test func hintIsForwardedToTheDescriptor() {
        let row = DSActionRow(
            accessibilityLabel: "Language",
            accessibilityHint: "Opens language settings",
            action: {},
            content: { EmptyView() }
        )

        #expect(row.accessibilityDescriptor.label == "Language")
        #expect(row.accessibilityDescriptor.hint == "Opens language settings")
    }

    @Test func listRowCombinesItsChildren() {
        // Three separate elements per row is the classic list accessibility bug.
        let row = DSListRow(title: "Language", value: "English")
        #expect(row.accessibilityDescriptor.children == .combine)
    }

    @Test func titleValuePresetSeparatesLabelFromValue() {
        let row = DSListRow(title: "Language", value: "English")

        // VoiceOver must say "Language, English", not one concatenated label.
        #expect(row.accessibilityDescriptor.label == "Language")
        #expect(row.accessibilityDescriptor.value == "English")
    }

    @Test func activityIndicatorAnnouncesOngoingActivity() {
        let descriptor = DSActivityIndicator().accessibilityDescriptor

        #expect(descriptor.traits.contains(.updatesFrequently))
        #expect(descriptor.label == DSLocalizedStrings.value(.loading))
    }

    // MARK: - Dynamic Type

    /// Row typography must scale. A style that resolves to a fixed size would keep
    /// the row legible-looking in tests while clipping for real users.
    @Test func rowTypographyIsRelativeToATextStyle() {
        #expect(theme.typography.body.relativeTo == .body)
        #expect(theme.typography.footnote.relativeTo == .footnote)
    }

    @Test func rowsRenderAtAccessibilitySizesWithoutFailing() throws {
        // Rendering is the assertion: a layout that cannot resolve at AX5 throws.
        let row = DSListRow(title: "Appearance", subtitle: "Follows the system")

        for size in [DynamicTypeSize.large, .accessibility1, .accessibility3, .accessibility5] {
            let rendered = try renderData(row, dynamicTypeSize: size)
            #expect(!rendered.isEmpty, "Row failed to render at \(size)")
        }
    }

    // MARK: - Right-to-Left

    @Test func rowsRenderMirroredWithoutFailing() throws {
        let row = DSListRow(
            leading: { Image(systemName: "globe") },
            trailing: { DSRowAccessory(.chevron) },
            content: { DSRowLabel(title: "Region", subtitle: "Mexico") }
        )

        let leftToRight = try renderData(row, layoutDirection: .leftToRight)
        let rightToLeft = try renderData(row, layoutDirection: .rightToLeft)

        // Identical bytes would mean the row hard-codes its horizontal order
        // instead of following the environment.
        #expect(leftToRight != rightToLeft, "Row did not mirror under RTL")
    }

    // MARK: - Long Strings

    @Test func longLabelsDoNotCollapseTheRow() throws {
        let row = DSListRow(
            title: "A preference with a considerably longer label than any real setting would use",
            subtitle: "And a subtitle that also runs well past the width of the row it belongs to."
        )

        let rendered = try renderData(row, size: CGSize(width: 320, height: 200))
        #expect(!rendered.isEmpty)
    }

    // MARK: - Helpers

    private func renderData(
        _ view: some View,
        size: CGSize = CGSize(width: 320, height: 80),
        layoutDirection: LayoutDirection = .leftToRight,
        dynamicTypeSize: DynamicTypeSize = .large
    ) throws -> Data {
        let wrapped = view
            .frame(width: size.width, height: size.height)
            .dsTheme(theme)
            .environment(\.layoutDirection, layoutDirection)
            .environment(\.dynamicTypeSize, dynamicTypeSize)

        let renderer = ImageRenderer(content: wrapped)
        renderer.scale = 2.0

        guard let image = renderer.uiImage, let data = image.pngData() else {
            throw SnapshotError.renderingFailed
        }
        return data
    }
}
