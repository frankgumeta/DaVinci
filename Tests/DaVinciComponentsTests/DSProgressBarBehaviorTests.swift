import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSProgressBar Behavior Tests

@Suite("DSProgressBar Behavior")
struct DSProgressBarBehaviorTests {

    // MARK: - Value Clamping

    @Test @MainActor func valueClampedToZeroWhenNegative() {
        let bar = DSProgressBar(value: -0.5)
        #expect(bar.value == 0.0)
    }

    @Test @MainActor func valueClampedToOneWhenAboveOne() {
        let bar = DSProgressBar(value: 2.0)
        #expect(bar.value == 1.0)
    }

    @Test @MainActor func valuePreservedWhenInRange() {
        let bar = DSProgressBar(value: 0.5)
        #expect(bar.value == 0.5)
    }

    @Test @MainActor func valueExactlyZeroPreserved() {
        let bar = DSProgressBar(value: 0.0)
        #expect(bar.value == 0.0)
    }

    @Test @MainActor func valueExactlyOnePreserved() {
        let bar = DSProgressBar(value: 1.0)
        #expect(bar.value == 1.0)
    }

    @Test @MainActor func valueLargeNegativeClampedToZero() {
        let bar = DSProgressBar(value: -100.0)
        #expect(bar.value == 0.0)
    }

    @Test @MainActor func valueLargePositiveClampedToOne() {
        let bar = DSProgressBar(value: 999.0)
        #expect(bar.value == 1.0)
    }

    @Test @MainActor func valueSmallFractionPreserved() {
        let bar = DSProgressBar(value: 0.001)
        #expect(bar.value == 0.001)
    }

    // MARK: - Size Height Mapping

    @Test func sizeSmallHeight() {
        #expect(DSProgressBar.Size.small.height == SpacingTokens.space1)
        #expect(DSProgressBar.Size.small.height == 4)
    }

    @Test func sizeMediumHeight() {
        #expect(DSProgressBar.Size.medium.height == 6)
    }

    @Test func sizeLargeHeight() {
        #expect(DSProgressBar.Size.large.height == SpacingTokens.space2)
        #expect(DSProgressBar.Size.large.height == 8)
    }

    @Test func sizeHeightProgression() {
        #expect(DSProgressBar.Size.small.height < DSProgressBar.Size.medium.height)
        #expect(DSProgressBar.Size.medium.height < DSProgressBar.Size.large.height)
    }

    // MARK: - Accessibility Label Resolution

    @Test @MainActor func customAccessibilityLabelTakesPriority() {
        let bar = DSProgressBar(
            value: 0.5,
            label: "Upload",
            accessibilityLabel: "File upload progress"
        )
        #expect(bar.resolvedAccessibilityLabel == "File upload progress")
    }

    @Test @MainActor func labelUsedWhenNoCustomAccessibilityLabel() {
        let bar = DSProgressBar(value: 0.5, label: "Uploading...")
        #expect(bar.resolvedAccessibilityLabel == "Uploading...")
    }

    @Test @MainActor func fallbackToProgressWhenNoLabels() {
        let bar = DSProgressBar(value: 0.5)
        #expect(bar.resolvedAccessibilityLabel == "Progress")
    }

    @Test @MainActor func indeterminateWithLabelUsesLabel() {
        let bar = DSProgressBar(label: "Loading...", isIndeterminate: true)
        #expect(bar.resolvedAccessibilityLabel == "Loading...")
    }

    @Test @MainActor func indeterminateWithoutLabelUsesDefault() {
        let bar = DSProgressBar(isIndeterminate: true)
        #expect(bar.resolvedAccessibilityLabel == "Progress")
    }

    // MARK: - Accessibility Value Resolution

    @Test @MainActor func determinateValueShowsPercentage() {
        let bar = DSProgressBar(value: 0.75)
        #expect(bar.resolvedAccessibilityValue == "75%")
    }

    @Test @MainActor func determinateZeroShowsZeroPercent() {
        let bar = DSProgressBar(value: 0.0)
        #expect(bar.resolvedAccessibilityValue == "0%")
    }

    @Test @MainActor func determinateOneShowsHundredPercent() {
        let bar = DSProgressBar(value: 1.0)
        #expect(bar.resolvedAccessibilityValue == "100%")
    }

    @Test @MainActor func determinateHalfShowsFiftyPercent() {
        let bar = DSProgressBar(value: 0.5)
        #expect(bar.resolvedAccessibilityValue == "50%")
    }

    @Test @MainActor func indeterminateShowsLoading() {
        let bar = DSProgressBar(isIndeterminate: true)
        #expect(bar.resolvedAccessibilityValue == "Loading")
    }

    @Test @MainActor func clampedValueReflectsInAccessibilityValue() {
        let bar = DSProgressBar(value: 1.5)
        #expect(bar.resolvedAccessibilityValue == "100%")
    }

    @Test @MainActor func negativeClampedValueReflectsInAccessibilityValue() {
        let bar = DSProgressBar(value: -0.3)
        #expect(bar.resolvedAccessibilityValue == "0%")
    }

    // MARK: - Indeterminate State

    @Test @MainActor func indeterminateFlagStoredCorrectly() {
        let determinateBar = DSProgressBar(value: 0.5)
        let indeterminateBar = DSProgressBar(isIndeterminate: true)

        #expect(determinateBar.isIndeterminate == false)
        #expect(indeterminateBar.isIndeterminate == true)
    }

    @Test @MainActor func indeterminateIgnoresValue() {
        let bar = DSProgressBar(value: 0.75, isIndeterminate: true)
        // Value is still stored (clamped), but accessibility says "Loading"
        #expect(bar.value == 0.75)
        #expect(bar.resolvedAccessibilityValue == "Loading")
    }
}
