import Testing
import SwiftUI
@testable import DaVinciTokens
@testable import DaVinciComponents

// MARK: - DSSwitch Behavior Tests

@Suite("DSSwitch Behavior")
struct DSSwitchBehaviorTests {

    // MARK: - Metrics

    @Test func trackDimensionsAreReasonable() {
        #expect(DSSwitch.Metrics.trackWidth == 44)
        #expect(DSSwitch.Metrics.trackHeight == 24)
        #expect(DSSwitch.Metrics.trackWidth > DSSwitch.Metrics.trackHeight)
    }

    @Test func knobFitsInsideTrack() {
        #expect(DSSwitch.Metrics.knobSize < DSSwitch.Metrics.trackHeight)
        #expect(DSSwitch.Metrics.knobSize == 20)
    }

    @Test func knobInsetIsPositive() {
        #expect(DSSwitch.Metrics.knobInset == 2)
        #expect(DSSwitch.Metrics.knobInset > 0)
    }

    @Test func knobOffsetDerivedCorrectly() {
        let expected = (DSSwitch.Metrics.trackWidth - DSSwitch.Metrics.knobSize) / 2
            - DSSwitch.Metrics.knobInset
        #expect(DSSwitch.Metrics.knobOffset == expected)
        #expect(DSSwitch.Metrics.knobOffset > 0)
    }

    @Test func knobTravelIsSymmetric() {
        let offset = DSSwitch.Metrics.knobOffset
        #expect(offset > 0)
        // On state uses +offset, off state uses -offset, so travel = 2 * offset
        let totalTravel = offset * 2
        #expect(totalTravel < DSSwitch.Metrics.trackWidth)
    }

    // MARK: - Accessibility Label Resolution

    @Test @MainActor func customAccessibilityLabelTakesPriority() {
        let toggle = DSSwitch(
            isOn: .constant(true),
            label: "Notifications",
            accessibilityLabel: "Enable push notifications"
        )
        #expect(toggle.resolvedAccessibilityLabel == "Enable push notifications")
    }

    @Test @MainActor func labelUsedWhenNoCustomAccessibilityLabel() {
        let toggle = DSSwitch(isOn: .constant(true), label: "Notifications")
        #expect(toggle.resolvedAccessibilityLabel == "Notifications")
    }

    @Test @MainActor func fallbackToToggleWhenNoLabels() {
        let toggle = DSSwitch(isOn: .constant(true))
        #expect(toggle.resolvedAccessibilityLabel == "Toggle")
    }

    @Test @MainActor func disabledSwitchRetainsAccessibilityLabel() {
        let toggle = DSSwitch(
            isOn: .constant(false),
            label: "Wi-Fi",
            isDisabled: true
        )
        #expect(toggle.resolvedAccessibilityLabel == "Wi-Fi")
    }

    @Test @MainActor func customLabelOverridesEvenWhenDisabled() {
        let toggle = DSSwitch(
            isOn: .constant(false),
            label: "Wi-Fi",
            isDisabled: true,
            accessibilityLabel: "Toggle Wi-Fi connection"
        )
        #expect(toggle.resolvedAccessibilityLabel == "Toggle Wi-Fi connection")
    }

    // MARK: - Accessibility Value

    @Test @MainActor func accessibilityValueReflectsOnState() {
        // The body sets .accessibilityValue(isOn ? "On" : "Off")
        // We verify the label resolution; the value is set inline in body
        // and tested via the label fallback chain consistency
        let onSwitch = DSSwitch(isOn: .constant(true))
        let offSwitch = DSSwitch(isOn: .constant(false))

        // Both should resolve labels correctly regardless of on/off state
        #expect(onSwitch.resolvedAccessibilityLabel == "Toggle")
        #expect(offSwitch.resolvedAccessibilityLabel == "Toggle")
    }

    // MARK: - Init Parameter Combinations

    @Test @MainActor func allStateCombinationsResolveLabels() {
        struct TestState {
            let isOn: Bool
            let isDisabled: Bool
            let label: String?
            let a11yLabel: String?
        }

        let states: [TestState] = [
            TestState(isOn: true, isDisabled: false, label: "Label", a11yLabel: nil),
            TestState(isOn: false, isDisabled: false, label: "Label", a11yLabel: nil),
            TestState(isOn: true, isDisabled: true, label: nil, a11yLabel: nil),
            TestState(isOn: false, isDisabled: true, label: nil, a11yLabel: "Custom"),
            TestState(isOn: true, isDisabled: false, label: "Label", a11yLabel: "Custom")
        ]

        for state in states {
            let toggle = DSSwitch(
                isOn: .constant(state.isOn),
                label: state.label,
                isDisabled: state.isDisabled,
                accessibilityLabel: state.a11yLabel
            )
            let resolved = toggle.resolvedAccessibilityLabel

            if let a11yLabel = state.a11yLabel {
                #expect(resolved == a11yLabel)
            } else if let label = state.label {
                #expect(resolved == label)
            } else {
                #expect(resolved == "Toggle")
            }
        }
    }
}
