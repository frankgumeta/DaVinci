import SwiftUI
import Testing
@testable import DaVinciComponents
@testable import DaVinciTokens

@MainActor
@Suite("Verifiable Accessibility Contracts")
struct DSAccessibilityTests {
    @Test func buttonExposesLabelHintAndButtonTrait() {
        let descriptor = DSButton(
            "Submit",
            accessibilityLabel: "Submit form",
            accessibilityHint: "Sends the form"
        ) {}.accessibilityDescriptor

        #expect(descriptor.label == "Submit form")
        #expect(descriptor.hint == "Sends the form")
        #expect(descriptor.value == nil)
        #expect(descriptor.traits.contains(.isButton))
        #expect(descriptor.isEnabled)
    }

    @Test func loadingButtonExposesStateAndIsNotActionable() {
        let descriptor = DSButton("Save", isLoading: true) {}.accessibilityDescriptor

        #expect(descriptor.label == "Save")
        #expect(descriptor.value == "Loading")
        #expect(descriptor.traits.contains(.updatesFrequently))
        #expect(!descriptor.isEnabled)
    }

    @Test func disabledButtonRetainsLabelAndIsNotActionable() {
        let descriptor = DSButton("Delete", isDisabled: true) {}.accessibilityDescriptor

        #expect(descriptor.label == "Delete")
        #expect(!descriptor.isEnabled)
    }

    @Test func iconButtonExposesRequiredLabelHintAndLoadingState() {
        let normal = DSIconButton(
            symbol: DSSymbol(systemName: "heart")!,
            titleForAccessibility: "Like",
            accessibilityHint: "Adds to favorites"
        ) {}.accessibilityDescriptor
        let loading = DSIconButton(
            symbol: DSSymbol(systemName: "heart")!,
            titleForAccessibility: "Like",
            isLoading: true
        ) {}.accessibilityDescriptor

        #expect(normal.label == "Like")
        #expect(normal.hint == "Adds to favorites")
        #expect(normal.traits.contains(.isButton))
        #expect(loading.value == "Loading")
        #expect(loading.traits.contains(.updatesFrequently))
        #expect(!loading.isEnabled)
    }

    @Test func disabledIconButtonIsNotActionable() {
        let descriptor = DSIconButton(
            symbol: DSSymbol(systemName: "trash")!,
            titleForAccessibility: "Delete",
            isDisabled: true
        ) {}.accessibilityDescriptor

        #expect(descriptor.label == "Delete")
        #expect(!descriptor.isEnabled)
    }

    @Test func switchExposesLabelValueToggleTraitAndDisabledState() {
        let on = DSSwitch(isOn: .constant(true), label: "Wi-Fi").accessibilityDescriptor
        let off = DSSwitch(
            isOn: .constant(false),
            label: "Wi-Fi",
            isDisabled: true
        ).accessibilityDescriptor

        #expect(on.label == "Wi-Fi")
        #expect(on.value == "On")
        #expect(on.traits.contains(.isToggle))
        #expect(on.isEnabled)
        #expect(off.value == "Off")
        #expect(!off.isEnabled)
    }

    @Test func unlabeledSwitchUsesExplicitFallback() {
        let descriptor = DSSwitch(isOn: .constant(false)).accessibilityDescriptor

        #expect(descriptor.label == "Toggle")
        #expect(descriptor.value == "Off")
    }

    @Test func segmentedControlExposesContainerAndSelectionSemantics() {
        let selected = DSSegmentItem(title: "Week").accessibilityDescriptor(isSelected: true)
        let unselected = DSSegmentItem(title: "Month").accessibilityDescriptor(isSelected: false)
        let control = DSSegmentedControl(
            options: ["Week", "Month"],
            selectedIndex: .constant(0)
        ).accessibilityDescriptor

        #expect(control.label == "Segmented control")
        #expect(control.children == .contain)
        #expect(selected.label == "Week")
        #expect(selected.traits.contains(.isButton))
        #expect(selected.traits.contains(.isSelected))
        #expect(!unselected.traits.contains(.isSelected))
    }

    @Test func textFieldExposesPromptEnteredValueHintAndError() {
        let empty = DSTextField(
            "Email",
            text: .constant(""),
            prompt: "you@example.com",
            accessibilityHint: "Enter your account email"
        ).accessibilityDescriptor
        let entered = DSTextField(
            "Email",
            text: .constant("invalid"),
            configuration: .filled.message(.error("Invalid email format"))
        ).accessibilityDescriptor

        #expect(empty.label == "Email")
        #expect(empty.value == "you@example.com")
        #expect(empty.hint == "Enter your account email")
        #expect(entered.value == "invalid. Error: Invalid email format")
    }

    @Test func hiddenTextFieldLabelRetainsAccessibleLabel() {
        let descriptor = DSTextField(
            "Search",
            text: .constant(""),
            configuration: .filled.labelVisibility(.hidden)
        ).accessibilityDescriptor

        #expect(descriptor.label == "Search")
        #expect(descriptor.value == "Empty")
    }

    @Test func progressExposesDeterminateAndIndeterminateState() {
        let determinate = DSProgressBar(value: 0.75, label: "Upload").accessibilityDescriptor
        let indeterminate = DSProgressBar(
            label: "Upload",
            isIndeterminate: true
        ).accessibilityDescriptor

        #expect(determinate.label == "Upload")
        #expect(determinate.value == "75%")
        #expect(determinate.children == .combine)
        #expect(indeterminate.value == "Loading")
        #expect(indeterminate.traits.contains(.updatesFrequently))
    }

    @Test func remoteImageExposesEveryPhaseAndDecorativeState() {
        let url = URL(string: "https://example.com/avatar.jpg")
        let loading = DSRemoteImage.accessibilityDescriptor(
            phase: .loading,
            customLabel: "Profile photo",
            url: url,
            isDecorative: false
        )
        let success = DSRemoteImage.accessibilityDescriptor(
            phase: .success,
            customLabel: "Profile photo",
            url: url,
            isDecorative: false
        )
        let failure = DSRemoteImage.accessibilityDescriptor(
            phase: .failure,
            customLabel: "Profile photo",
            url: url,
            isDecorative: false
        )
        let decorative = DSRemoteImage.accessibilityDescriptor(
            phase: .success,
            customLabel: nil,
            url: url,
            isDecorative: true
        )

        #expect(loading.label == "Profile photo")
        #expect(loading.value == "Loading")
        #expect(loading.traits.contains(.updatesFrequently))
        #expect(success.value == nil)
        #expect(success.traits.contains(.isImage))
        #expect(failure.value == "Failed to load")
        #expect(decorative.isHidden)
    }

    @Test func badgeCardAndTextExposeGroupingAndTraits() {
        let badge = DSBadge("New").accessibilityDescriptor
        let card = DSCard(
            accessibilityLabel: "Product card",
            accessibilityHint: "Opens product details",
            accessibilityTraits: .isButton
        ) { Text("Product") }.accessibilityDescriptor
        let heading = DSText("Title", role: .headline).accessibilityDescriptor
        let body = DSText("Body", role: .body).accessibilityDescriptor

        #expect(badge.label == "New")
        #expect(badge.traits.contains(.isStaticText))
        #expect(badge.children == .ignore)
        #expect(card.label == "Product card")
        #expect(card.hint == "Opens product details")
        #expect(card.traits.contains(.isButton))
        #expect(card.children == .combine)
        #expect(heading.traits.contains(.isHeader))
        #expect(!body.traits.contains(.isHeader))
    }

    @Test func primaryControlsRenderAtLeastFortyFourPointsTall() throws {
        let iconButton = try renderedSize(
            DSIconButton(
                symbol: DSSymbol(systemName: "heart")!,
                titleForAccessibility: "Like",
                size: .small
            ) {}
        )
        let toggle = try renderedSize(DSSwitch(isOn: .constant(false)))
        let segments = try renderedSize(
            DSSegmentedControl(options: ["Day", "Week"], selectedIndex: .constant(0))
                .frame(width: 300)
        )
        let button = try renderedSize(DSButton("Continue") {}.frame(width: 300))

        #expect(iconButton.width >= 44)
        #expect(iconButton.height >= 44)
        #expect(toggle.height >= 44)
        #expect(segments.height >= 44)
        #expect(button.height >= 44)
    }

    private func renderedSize<V: View>(_ view: V) throws -> CGSize {
        let renderer = ImageRenderer(content: view.fixedSize())
        renderer.scale = 1
        return try #require(renderer.uiImage).size
    }
}
