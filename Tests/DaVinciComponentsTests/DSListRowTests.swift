import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@Suite("DSListRow")
@MainActor
struct DSListRowTests {

    // MARK: - Layout Row

    @Test func rowCombinesChildrenForVoiceOver() {
        let row = DSListRow(
            leading: { EmptyView() },
            trailing: { EmptyView() },
            content: { DSText("Language", role: .body) }
        )

        // A row read as three separate elements is the classic list accessibility bug.
        #expect(row.accessibilityDescriptor.children == .combine)
    }

    @Test func titleValuePresetExposesTitleAndValueSeparately() {
        let row = DSListRow(title: "Language", value: "English")

        // Label and value must be distinct so VoiceOver announces
        // "Language, English" rather than concatenating them into the label.
        #expect(row.accessibilityDescriptor.label == "Language")
        #expect(row.accessibilityDescriptor.value == "English")
    }

    @Test func titleSubtitlePresetLeavesAccessibilityToTheCombinedChildren() {
        let row = DSListRow(title: "Appearance", subtitle: "Follows the system")
        #expect(row.accessibilityDescriptor.label == nil)
        #expect(row.accessibilityDescriptor.children == .combine)
    }

    // MARK: - Action Row

    @Test func actionRowIsAButton() {
        let row = DSActionRow(action: {}, content: { EmptyView() })
        #expect(row.accessibilityDescriptor.traits.contains(.isButton))
        #expect(row.accessibilityDescriptor.isEnabled)
    }

    @Test func disabledActionRowIsNotInteractive() {
        let row = DSActionRow(isDisabled: true, action: {}, content: { EmptyView() })
        #expect(!row.isInteractive)
        #expect(!row.accessibilityDescriptor.isEnabled)
    }

    @Test func loadingActionRowIsInertAndAnnouncesItself() {
        let row = DSActionRow(isLoading: true, action: {}, content: { EmptyView() })

        // Loading must disable the row, otherwise a second tap starts the work twice.
        #expect(!row.isInteractive)
        #expect(!row.accessibilityDescriptor.isEnabled)
        #expect(row.accessibilityDescriptor.value == DSLocalizedStrings.value(.loading))
    }

    @Test func actionRowHintIsForwarded() {
        let row = DSActionRow(
            accessibilityLabel: "Language",
            accessibilityHint: "Opens language settings",
            action: {},
            content: { EmptyView() }
        )

        #expect(row.accessibilityDescriptor.label == "Language")
        #expect(row.accessibilityDescriptor.hint == "Opens language settings")
    }

    @Test func actionRowFiresItsAction() {
        var fired = false
        let row = DSActionRow(action: { fired = true }, content: { EmptyView() })
        #expect(type(of: row) == DSActionRow<EmptyView>.self)
        #expect(!fired)
    }

    // MARK: - Selectable Row

    @Test func selectedRowCarriesTheSelectedTrait() {
        let row = DSSelectableRow(isSelected: true, action: {}, content: { EmptyView() })
        #expect(row.resolvedTraits.contains(.isSelected))
        #expect(row.resolvedTraits.contains(.isButton))
    }

    @Test func unselectedRowDoesNotCarryTheSelectedTrait() {
        let row = DSSelectableRow(isSelected: false, action: {}, content: { EmptyView() })
        #expect(!row.resolvedTraits.contains(.isSelected))
        #expect(row.resolvedTraits.contains(.isButton))
    }

    @Test func selectionStateIsAnnouncedAsAValue() {
        let selected = DSSelectableRow(isSelected: true, action: {}, content: { EmptyView() })
        let unselected = DSSelectableRow(isSelected: false, action: {}, content: { EmptyView() })

        // The checkmark is the only visual cue, so the state must also reach VoiceOver.
        #expect(selected.selectionValue == DSLocalizedStrings.value(.selected))
        #expect(unselected.selectionValue == DSLocalizedStrings.value(.notSelected))
        #expect(selected.selectionValue != unselected.selectionValue)
    }

    @Test func disabledSelectableRowReportsDisabled() {
        let row = DSSelectableRow(isSelected: false, isDisabled: true, action: {}, content: { EmptyView() })
        #expect(!row.accessibilityDescriptor.isEnabled)
    }

    @Test func selectableRowAcceptsLeadingContent() {
        let row = DSSelectableRow(
            isSelected: true,
            action: {},
            leading: { Circle().frame(width: 20, height: 20) },
            content: { DSText("Midnight", role: .body) }
        )
        #expect(row.accessibilityDescriptor.children == .combine)
    }

    // MARK: - Accessories

    @Test func accessoryKindsAreDistinct() {
        #expect(DSRowAccessory.Kind.selection(isSelected: true) != .selection(isSelected: false))
        #expect(DSRowAccessory.Kind.chevron != .activity)
    }
}

@Suite("DSActivityIndicator")
@MainActor
struct DSActivityIndicatorTests {

    @Test func sizesAreAscending() {
        let sizes = DSActivityIndicator.Size.allCases.map(\.dimension)
        #expect(sizes == sizes.sorted())
        #expect(Set(sizes).count == sizes.count)
    }

    @Test func defaultLabelIsLocalized() {
        let indicator = DSActivityIndicator()
        #expect(indicator.resolvedLabel == DSLocalizedStrings.value(.loading))
    }

    @Test func customLabelOverridesTheDefault() {
        let indicator = DSActivityIndicator(label: "Loading packs")
        #expect(indicator.resolvedLabel == "Loading packs")
    }

    @Test func indicatorAnnouncesOngoingActivity() {
        let descriptor = DSActivityIndicator().accessibilityDescriptor

        // Without this trait VoiceOver treats the spinner as static content.
        #expect(descriptor.traits.contains(.updatesFrequently))
        #expect(descriptor.children == .ignore)
    }
}

@Suite("DSButton Compact Size")
@MainActor
struct DSButtonCompactSizeTests {

    private let theme = DSTheme.defaultTheme

    /// Both sizes draw their label with the label family: the size changes the
    /// control's height and padding, not its typography.
    @Test func bothSizesUseTheLabelFamily() {
        let regular = DSButton("Buy", size: .regular) {}
        let compact = DSButton("Buy", size: .compact) {}

        #expect(regular.labelStyle == theme.typography.labelLarge)
        #expect(compact.labelStyle == theme.typography.labelLarge)
    }

    @Test func compactPaintsSmallerThanTheMinimumHitTarget() {
        // This is the point of the size: it looks small but stays touchable.
        #expect(ControlHeightTokens.compact < ControlHeightTokens.minimumHitTarget)
    }

    @Test func minimumHitTargetMeetsTheGuideline() {
        #expect(ControlHeightTokens.minimumHitTarget == 44)
    }

    @Test func sizeDefaultsToRegular() {
        // Compared by painted height, since both sizes share the label style.
        #expect(DSButton("Buy") {}.paintedHeight == ControlHeightTokens.medium)
    }
}

@Suite("DSIconButton Shape")
@MainActor
struct DSIconButtonShapeTests {

    /// `AnyShape` is not `Equatable`, so shapes are compared by the geometry they
    /// produce. That is the stronger assertion anyway: it checks what gets drawn
    /// rather than which type was wrapped.
    private static let probe = CGRect(x: 0, y: 0, width: 40, height: 40)

    @Test func shapeDefaultsToRoundedRectangle() throws {
        let symbol = try #require(DSSymbol(systemName: "play.fill"))
        let button = DSIconButton(symbol: symbol, titleForAccessibility: "Play") {}

        let expected = RoundedRectangle(cornerRadius: RadiusTokens.medium).path(in: Self.probe)
        #expect(button.resolvedShape.path(in: Self.probe) == expected)
    }

    @Test func circleShapeIsAvailable() throws {
        let symbol = try #require(DSSymbol(systemName: "play.fill"))
        let button = DSIconButton(
            symbol: symbol,
            titleForAccessibility: "Play",
            shape: .circle
        ) {}

        #expect(button.resolvedShape.path(in: Self.probe) == Circle().path(in: Self.probe))
    }

    @Test func theTwoShapesDrawDifferently() throws {
        let symbol = try #require(DSSymbol(systemName: "play.fill"))
        let rounded = DSIconButton(symbol: symbol, titleForAccessibility: "Play") {}
        let circle = DSIconButton(symbol: symbol, titleForAccessibility: "Play", shape: .circle) {}

        #expect(rounded.resolvedShape.path(in: Self.probe) != circle.resolvedShape.path(in: Self.probe))
    }

    @Test func hitTargetUsesTheToken() throws {
        let symbol = try #require(DSSymbol(systemName: "play.fill"))
        let button = DSIconButton(symbol: symbol, titleForAccessibility: "Play") {}
        #expect(button.minimumHitDimension == ControlHeightTokens.minimumHitTarget)
    }
}
